#!/usr/bin/env bash

SELF=$(readlink -f $0)
ROOT_DIR=$(dirname $SELF)

function usage() {
	cmd=$(basename $SELF)
	cat <<EOD
usage:
	$cmd help          # show this message
	$cmd build         # run build script
	$cmd build-local   # build jekyll site locally with docker/podman

EOD
}

function regenerate_menu_yml() {
	cat <<EOD
- label: Latest
  items:
    - name: HackMD
      link: "https://pad.hackingthursday.org"
EOD
	for yr in $(seq 2008 $(date +"%Y") | sort -r); do
		cat <<EOD
- label: $yr
  items:
EOD

		(
			cd $ROOT_DIR
			find weeklynote/ -type f -name "*.md"
		) | grep -e "$yr-" | sort -r | while read -r line; do
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

function process_weeklynotes() {
	tmpd=$(mktemp -d)
	(
		cd $ROOT_DIR || exit
		find weeklynote/ -maxdepth 1 -type f -name "*.md" | sort | while read -r line; do
			echo "Processing $line ..."
			fpath="$line"
			date_str=$(echo "$fpath" | sed -e "s/^.*weeklynote\///g" -e "s/\.md$//g")

			(echo $date_str | grep -e "^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}$" >&/dev/null) || {
				echo "[SKIP] $date_str is not in correct format."
				continue
			}
			cat >$tmpd/front_matter.txt <<-EOD
				---
				title: "$date_str 聚會手記"
				date: $date_str
				layout: post
				permalink: /weeklynote/$date_str
				show_sidebar: false
				menubar: menu
				category: weeklynote
				---
			EOD
			dst_fpath="$ROOT_DIR/_posts/${date_str}-聚會手記.md"
			install -D /dev/null "$dst_fpath"
			cat $tmpd/front_matter.txt >>"$dst_fpath"
			cat "$fpath" >>"$dst_fpath"
		done
	)
	rm -r $tmpd
}

case "$1" in
build)
	# Regenerate weeklynotes' sidebar listing
	# Scan `/weeklynote` files and update `/_data/menu.yml`
	regenerate_menu_yml >$ROOT_DIR/_data/menu.yml

	process_weeklynotes
	;;

build-local)
	$SELF build

	CONTAINER_CLI="docker"

	# Use podman instead if available
	(which podman >&/dev/null) && {
		CONTAINER_CLI="podman"
	}

	[ -n "$JEKYLL_GITHUB_TOKEN" ] && {
		OPTS="$OPTS -e JEKYLL_GITHUB_TOKEN=$JEKYLL_GITHUB_TOKEN "
	}

	[ -n "$JEKYLL_LOG_LEVEL" ] && {
		OPTS="$OPTS -e JEKYLL_LOG_LEVEL=$JEKYLL_LOG_LEVEL "
	}

	time (
		$CONTAINER_CLI run \
			--rm \
			-it \
			-v "${PWD}:/srv/jekyll:Z" \
			-e JEKYLL_ROOTLESS=1 \
			-e BUNDLE_APP_CONFIG='.bundle' \
			$OPTS \
			docker.io/jekyll/jekyll \
			sh -c "bundle update && bundle exec jekyll build --incremental"
	)
	;;

help | *)
	usage
	;;

esac
