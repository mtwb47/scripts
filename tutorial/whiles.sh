#1 /bin/bash

v=5

while [ $v -le 10 ]; do
    echo Number: $v
    ((v++))
done
