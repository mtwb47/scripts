#!/bin/bash

# This script downloads the RSS feed from 9to5Linux and in addition retrieves
# all articles linked inside the feed to the current directory. From the
# downloaded articles it extracts all the relevant content and rebuilds an RSS
# feed containing the full article (eg. "/home/myaccount/feed/9to5Linux.xml").
# The resulting feed can than be used in some news readers (eg. lifeara) as a 
# local feed or uploaded to a webserver and used from there
# (eg. http://localhost/9to5Linux.xml). This is an attempt in making RSS better
# in 2021. :)
#
# This simple bash script was inspired by the recent "Bash Challange" between
# Matt (The Linux Cast) & Tailor (Zaney) and a video made by Matt regarding
# crippled RSS feeds that are all too prevalent on modern websites.
# "Bash Challenge" => https://www.youtube.com/watch?v=IoFKD5Jm04o
# "How Useful is RSS in 2021?" => https://www.youtube.com/watch?v=kvITN6Md3F4

# 0) General settings
feed_name="9to5linux" # title for the resulting RSS feed.
feed_url="https://9to5linux.com/feed" # url to the actual RSS feed.
download_wait=1 # be nice and wait between downloads (seconds to wait).
cleanup=1 # should we cleanup all the temporary files afterwards (0=no|1=yes)?

# 1) Download the RSS feed
# If it hasn't already been downloaded within the last 10 minutes try
# downloading the feed again with curl to a local file. To garantee a unique
# and fixed length file name that can be represented in the file system, the 
# URL is simply hashed by using MD5 (eg. md5(feed_url)_original.xml).
feed_file=$(echo -n "$feed_url" | md5sum | awk '{print $1}')_original.xml
if [ ! -f "$feed_file" ] || [ ]; then
    printf "Downloading feed '%s' to '%s'.\n" "$feed_url" "$feed_file"
    curl -s -l "$feed_url" -o "$feed_file" 2>/dev/null
    sleep "$download_wait"
fi

# 2) Parse links to the articles from the feed
# This is a very dodgy approach and generally not recommended, since it heavily
# relies on the layout of the XML file. It skips the first 2 occurrances of
# <link>*</link> in the feed. A far better approach would be to use xmllint
# instead of cat, grep, sed and tail.
IFS=$'\n' # field separator
link_list=($(cat "$feed_file" | grep '<link>' | \
            sed -e 's/^[[:space:]]*//' -e 's/<link>//' -e 's/<\/link>//' | \
            tail -n +3))

# 3) Download all the articles
# Downloads all the original articles to a local file by using curl.
# This step is pretty much the same as 1) but for articles.
for link_url in ${link_list[@]}; do
    link_file=$(echo -n "$link_url" | md5sum | awk '{print $1}')_original.html
    if [ ! -f "$link_file" ]; then
        printf "Downloading article '%s' to '%s'.\n" "$link_url" "$link_file"
        curl -s -l "$link_url" -o "$link_file" 2>/dev/null
        sleep "$download_wait"
    fi
done

# 4) Clean up the original articles
# This steps loops through all the originally downloaded articles and tries
# to cleanup the HTML. By doing so it removes all the unnessary clutter and
# hopefully only leaves the actual content behind.
for link_url in ${link_list[@]}; do
    link_file=$(echo -n "$link_url" | md5sum | awk '{print $1}')_original.html
    printf "Cleaning up article '%s'.\n" "$link_file"

    # 4.1) Select the article part in the HTML.
    # Everything else is bloat anyway :D
    step_1_file=$(echo -n "$link_url" | md5sum | awk '{print $1}')_1.html
    cat "$link_file" | \
    grep -zo '<article.*</article>' > "$step_1_file"

    # 4.2) Replace or remove unecessary tags.
    step_2_file=$(echo -n "$link_url" | md5sum | awk '{print $1}')_2.html
    cat "$step_1_file" | \
    perl -0777 -pe 's/<script.*?<\/script>//sg' | \
    perl -0777 -pe 's/<style.*?<\/style>//sg' | \
    perl -0777 -pe 's|<figure.*?<img.*?src="(.*?)".*?>(.*?)</figure>|<p><img src="\1" /></p>|sg' | \
    perl -0777 -pe 's|<time class="updated".*?>.*?</time>||sg' | \
    perl -0777 -pe 's|<time.*?datetime="(.*?)".*?>(.*?)</time>|<p><time datetime="\1">\2</time></p>|sg' | \
    perl -0777 -pe 's/<p .*?>/<p>/sg' | \
    perl -0777 -pe 's|<blockquote.*?>|<blockquote>|sg' | \
    per -0777 -pe 's|<img width.*?src="(.*?)".*?/>|<p><img src="\1"/></p>|sg' | \
    perl -0777 -pe 's/<h1.*?>/<h1>/sg' | \
    perl -0777 -pe 's|<article.*?>||sg' | \
    perl -0777 -pe 's|</article>||sg' | \
    perl -0777 -pe 's|<p><i>Last updated.*?</p>||sg' | \
    perl -0777 -pe 's/<footer.*?<\/footer>//sg' \
    > "$step_2_file"

    # 4.3) Write the result to the output file.
    final_file=$(echo -n "$link_url" | md5sum | awk '{print $1}')_final.html
    
    cat "$step_2_file" | \
    grep -zoP '<h1.*?</h1>' | xargs -0 > "$final_file"

    cat "$step_2_file" | \
    grep -zoP '<p.*?</p>' | xargs -0 >> "$final_file"
done

# 5) Retrieve the number of articles in original RSS feed.
# This step retrieves the number of articles by using xmllint from the libxml2 
# package (arch).
article_count=$(xmllint --xpath 'count(//item)' $feed_file)

# 6.1) Recreate feed
# Write the header of a very basic RSS 2.0 feed. If the is already a file
# present at the destination, it will be overwritten.
recreation_file="$feed_name".xml
printf "Creating RSS feed '%s'.\n" "$recreation_file"
printf '<?xml version="1.0" encoding="UTF-8"?>\n' > "$recreation_file"
printf '<rss version="2.0">\n' >> "$recreation_file"
printf '<channel>\n' >> "$recreation_file"
printf '<title>%s</title>\n' "$feed_name" >> "$recreation_file"

# 6.2) Add the items including the full articles to the feed.
# At all the articles to feed. It uses the title, publication date, and link 
# from the original feed and only uses the extracted content from the 
# downloaded article as HTML for the "description".
i=1
while [ $i -le $article_count ] 
do
    article_link=$(xmllint --xpath '//item['$i']/link/text()' "$feed_file")
    article_date=$(xmllint --xpath '//item['$i']/pubDate/text()' "$feed_file")
    article_title=$(xmllint --xpath '//item['$i']/title' "$feed_file")
    article_file=$(echo -n "$article_link" | md5sum | awk '{print $1}')_final.html
    article_content=$(cat "$article_file")
    printf '<item>\n' >> "$recreation_file"
    printf '<link>%s</link>\n' "$article_link" >> "$recreation_file"
    printf '<guid>%s</guid>\n' "$article_link" >> "$recreation_file"
    printf '%s\n' "$article_title" >> "$recreation_file"
    printf '<pubDate>%s</pubDate>\n' "$article_date" >> "$recreation_file"
    printf '<description><![CDATA[%s]]></description>\n' "$article_content" >> "$recreation_file"
    printf '</item>\n' >> "$recreation_file"
    ((i++))
done

# 6.3) End the feed
printf '</channel>\n' >> "$recreation_file"
printf '</rss>\n' >> "$recreation_file"

# 7) Housekeeping
# Delete all temporary HTML files and the original RSS feed.
if [ "$cleanup" -eq "1" ]; then
    for file in *
    do
        if [ -f $file ] && [ "${file: -5}" == ".html" ]; then
            printf "Deleting file '%s'.\n" "$file"
            rm "$file"
        fi
    done
    printf "Deleting file '%s'.\n" "$feed_file"
    rm "$feed_file"
fi
