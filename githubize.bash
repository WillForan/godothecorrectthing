#!/usr/bin/env bash
set -xe
# put github commit page to clipboard -- based on xterm's title (user@host:path)

# title like user@host:path
userhostpath=$(xdotool getactivewindow getwindowname)
gitrevcmd='echo https://\\$(git remote -v | sed \\"s:.*\\(github.com\\|bitbucket.org\\).:\\1/:\;s:.git .*::\;q\\")/commit/\\$(git rev-parse HEAD)'
# use 
#  1. git remove -v to get where the remote is (user/repo)
#  2. git rev-parse HEAD to get the latest revision
#  3. combine as github commit url
# https://github.com/$(git remote -v | sed "s/.*github.com.//;s/.git .*//;q")/commit/$(git rev-parse HEAD)

# what to run
cmd="$(echo $userhostpath | 
   sed "s/^/ssh /;
        s/:/ \"cd /;
        s%$%\; $gitrevcmd\"%"
   )"

# run it and put on clipboard
url=$(eval $cmd )
notify-send "commit url from xterm" "$url" &
echo $url | xclip -i
