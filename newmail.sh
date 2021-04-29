#!/bin/sh

unread=$(find /home/drmdub/.local/share/mail/*/INBOX/new -type f | wc -l)

echo "$unread"
