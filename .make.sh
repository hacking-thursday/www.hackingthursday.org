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

# usage: merge_frontmatter src.md to_add.yml output.md
function merge_frontmatter() {
	src="$1"
	to_add="$2"
	output="$3"

	# 檢查檔案是否存在
	if [ ! -f "$src" ] || [ ! -f "$to_add" ]; then
		echo "錯誤: 輸入檔案不存在"
		exit 1
	fi

	# 臨時檔案
	temp_src_fm=$(mktemp)
	temp_content=$(mktemp)
	temp_merged=$(mktemp)
	(
		# 提取原始檔案的 front matter 和內容
		awk '
    BEGIN {p=1}
    /^---$/ {
        if(p==1) {p=2;next}
        if(p==2) {p=3;next}
    }
    p==2 {print > "'$temp_src_fm'"}
    p==3 {print > "'$temp_content'"}
' "$src"

		# 使用 yq 合併 front matter，保持原始值
		# 使用 to_add.yml 作為基礎，然後用 src.md 的 front matter 覆蓋它
		yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' "$to_add" "$temp_src_fm" >"$temp_merged"

		# 建立輸出檔案
		{
			echo "---"
			cat "$temp_merged"
			echo "---"
			cat "$temp_content"
		} >"$output"

	)
	# 清理臨時檔案
	rm "$temp_src_fm" "$temp_content" "$temp_merged"
}

# usage: cat source.md | remove_frontmatter
function remove_frontmatter() {
	sed '1 { /^---/ { :a N; /\n---/! ba; d} }'
}

# usage: cat source.md | get_frontmatter
function get_frontmatter() {
	sed -n '/^---$/,/^---$/p' | sed '1d;$d'
}

# usage: echo "string" | pipe_urlencode
function pipe_urlencode() {
	python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read().strip()))'
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
				title: "${date_str} 聚會手記"
				date: ${date_str}
				layout: post
				permalink: /weeklynote/${date_str}/
				show_sidebar: false
				menubar: menu
				category: weeklynote
				author: community
				slug: "weeklynote_${date_str}"
				redirect_from:
				  - /$date_str
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

function process_blogs() {
	tmpd=$(mktemp -d)
	(
		cd $ROOT_DIR || exit
		find blog/ -maxdepth 1 -type f -name "*.md" | sort | while read -r line; do
			echo "Processing $line ..."
			fpath="$line"
			title=$(cat "$fpath" | remove_frontmatter | head -1 | grep -e "^#\s\+" | sed -e "s/^#\s*//g")
			title_urlencode=$(echo "$title" | pipe_urlencode)
			date_iso8601=$(cat "$fpath" | get_frontmatter | grep -e "\s*date:\s" | sed -e "s/\s*date:\s*//g")
			date_str=$(date --date="$date_iso8601" --iso-8601=d)
			date_epoch=$(date --date="$date_iso8601" +"%s")
			date_year=$(date --date="$date_iso8601" +"%Y")
			date_month=$(date --date="$date_iso8601" +"%m")
			date_day=$(date --date="$date_iso8601" +"%d")

			cat >$tmpd/front_matter.yml <<-EOD
				title: "${title}"
				layout: post
				permalink: /blog/${date_str}_${date_epoch}/
				category: blog
				slug: "blog_${date_str}_${date_epoch}"
				redirect_from:
				  - /${date_str}_${title_urlencode}
				  - /${date_year}/${date_month}/${date_day}/${title_urlencode}
			EOD
			dst_fpath="$ROOT_DIR/_posts/${date_str}-blog.md"
			install -D /dev/null "$dst_fpath"
			merge_frontmatter "$fpath" $tmpd/front_matter.yml "$dst_fpath"
		done
	)
	rm -r $tmpd
}

case "$1" in
build)
	# Regenerate weeklynotes' sidebar listing
	# Scan `/weeklynote` files and update `/_data/menu.yml`
	regenerate_menu_yml >$ROOT_DIR/_data/menu.yml

	# Regenerate blogs
	process_blogs

	# Regenerate weeklynote
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
