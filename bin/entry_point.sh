#!/bin/bash
set -e

CONFIG_FILE=_config.yml 

jekyll_serve() {
    rm -f Gemfile.lock
    bundle exec jekyll serve --watch --port=8080 --host=0.0.0.0 --livereload --verbose --trace --force_polling
}

jekyll_serve &

while true; do
    inotifywait -q -e modify,move,create,delete $CONFIG_FILE
    if [ $? -eq 0 ]; then
        echo "Change detected to $CONFIG_FILE, restarting Jekyll"
        pkill -f jekyll
        jekyll_serve &
    fi
done