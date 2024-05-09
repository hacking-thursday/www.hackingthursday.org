#!/usr/bin/env bash
# Description: Read files from `/weeklynote` and update `/_data/menu.yml`
# Usage: make update_menu

TOP_SRCDIR="$(readlink -f $(dirname $0)/..)"

gen_menu_yml(){
        cat <<EOD
- label: Latest
  items:
    - name: HackMD
      link: "https://pad.hackingthursday.org"
EOD
    for yr in $(seq 2008 $(date +"%Y") | sort -r ) ; do
        cat <<EOD
- label: $yr
  items:
EOD

	(cd $TOP_SRCDIR; find weeklynote/ -type f -name "*.md") | grep -e "$yr-" | sort -r | while read -r line; do
            item=$line
            item=${item#weeklynote/}
            item=${item%.md}
            cat <<EOD
    - name: $item
      link: "/weeklynote/$item"
EOD
        done

    done
}

gen_menu_yml > menu.yml
