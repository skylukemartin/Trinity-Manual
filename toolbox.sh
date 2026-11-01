#!/usr/bin/env bash
# obsidian.typ toolbox. Run without arguments for a menu, or:
#   ./toolbox.sh build [file.typ]   compile the PDF once (default: main.typ)
#   ./toolbox.sh watch [file.typ]   recompile on every save (Ctrl+C to stop)
#   ./toolbox.sh setup              apply recommended Obsidian settings and install plugins
#   ./toolbox.sh format [--github]  tidy all markdown files with prettier; --github also converts
#                                   Obsidian-only syntax to markdown GitHub can show
#   ./toolbox.sh localize           download web images into attachments/ and relink them

cd "$(dirname "$0")" || exit 1

# Obsidian plugins installed by `setup`, downloaded from their GitHub releases.
# Format: <plugin id> <GitHub repo> <version>. Versions are pinned to the ones the
# settings in .obsidian.default were made with; bump them here to upgrade.
CORE_PLUGINS="
better-markdown-links     mnaoumov/obsidian-better-markdown-links 4.2.1
obsidian-citation-plugin  hans/obsidian-citation-plugin           0.4.5
"
EXTRA_PLUGINS="
obsidian-minimal-settings kepano/obsidian-minimal-settings        9.0.0
obsidian-style-settings   mgmeyers/obsidian-style-settings        1.0.9
obsidian-linter           platers/obsidian-linter                 1.32.0
table-editor-obsidian     tgrosinger/advanced-tables-obsidian     0.23.2
multi-properties          technohiker/obsidian-multi-properties   1.4.3
obsidian-note-autocreator SimonTC/obsidian-note-autocreation      1.6.0
omnisearch                scambier/obsidian-omnisearch            1.30.1
text-extractor            scambier/obsidian-text-extractor        0.7.0
emoji-autocomplete        KraXen72/obsidian-emoji-autocomplete    1.5.4
vim-toggle                conneroisu/vim-toggle                   1.1.0
"
EXTRA_THEME="Minimal kepano/obsidian-minimal 9.0.2"

# Web images and Mermaid diagrams are downloaded/rendered into .cache/ before every build.
# Set this to true to also copy web images into each note's attachments folder and relink them
# (the same as running `./toolbox.sh localize`) on every build.
LOCALIZE_ON_BUILD=false
MERMAID_SERVER="https://mermaid.ink"   # renders ```mermaid blocks (same project as mermaid.live)
USER_AGENT="obsidian.typ-toolbox/1.0 (https://github.com/obsidian2typst/template)"
CACHE=.cache
MANIFEST=$CACHE/web-cache.json

die() { echo "Error: $*" >&2; exit 1; }
ask() { read -r -p "$1 (y/n): " reply; [[ $reply =~ ^[Yy] ]]; }
need() { command -v "$1" >/dev/null 2>&1 || die "$1 is not installed. $2"; }

typst_run() {
    need typst "See the Install section of README.md."
    local mode=$1; shift
    [ $# -eq 0 ] && set -- main.typ
    typst "$mode" --font-path .fonts --pdf-standard=2.0 --input "web-cache=/$MANIFEST" "$@"
}

# ---------------------------------------------------------------------------------------------
# Web images and Mermaid diagrams
# ---------------------------------------------------------------------------------------------

# fetch <output file> <url> [curl args]: quiet download with retries; prints the content type
fetch() { curl -fsL --retry 3 --retry-delay 2 --connect-timeout 10 --max-time 60 -A "$USER_AGENT" -w '%{content_type}' -o "$@"; }

hash() { if command -v sha1sum >/dev/null 2>&1; then sha1sum; else shasum; fi | cut -c1-16; }

# Prints stdin as a JSON string (lines joined with \n)
json_str() {
    awk 'BEGIN { printf "\"" }
    {
        if (NR > 1) printf "\\n"
        s = $0; out = ""
        for (i = 1; i <= length(s); i++) {
            c = substr(s, i, 1)
            if (c == "\\") c = "\\\\"; else if (c == "\"") c = "\\\""; else if (c == "\t") c = "\\t"; else if (c == "\r") c = "\\r"
            out = out c
        }
        printf "%s", out
    }
    END { printf "\"" }'
}

png_width() { od -An -tu1 -j16 -N4 "$1" | awk '{ print (($1 * 256 + $2) * 256 + $3) * 256 + $4 }'; }

# All notes that can end up in the PDF
find_notes() {
    find . \( -name .git -o -name .obsidian -o -name .obsidian.default -o -name "$CACHE" -o -name .trash \
        -o -name node_modules -o -path ./templates \) -prune -o -type f -name '*.md' -print
}

# Every file in the vault (for resolving [[wikilinks]] and ![[embeds]] by name)
find_files() { find . \( -path './.*' -o -name node_modules \) -prune -o -type f -print | LC_ALL=C sort; }

# scan_note <file> <tmp prefix>: prints "U<tab>url" for each web image, and writes each ```mermaid
# block to <tmp prefix>N.mmd and prints "M<tab>path". Skips code blocks and typst-exclude blocks,
# exactly like obsidian.typ does.
scan_note() {
    awk -v prefix="$2" '
    # Length of the ``` or ~~~ run starting t (0 if under 3). A fence opened with N characters
    # only closes on N or more of the same character with nothing after, like CommonMark.
    function fence_len(t,   c, n) {
        c = substr(t, 1, 1); if (c != "`" && c != "~") return 0
        n = 1; while (substr(t, n + 1, 1) == c) n++
        return n >= 3 ? n : 0
    }
    function closes(t, open,   n, rest) {
        n = fence_len(t); if (n < length(open) || substr(t, 1, 1) != substr(open, 1, 1)) return 0
        rest = substr(t, n + 1); return rest ~ /^[ \t]*$/
    }
    { sub(/\r$/, ""); line = $0; t = line; sub(/^[ \t]+/, "", t) }
    index(t, "<!--typst-begin-exclude-->") == 1 { inex = 1 }
    inex { if (index(t, "<!--typst-end-exclude-->")) inex = 0; next }
    inmer {
        if (closes(t, "```")) { f = prefix (++n) ".mmd"; printf "%s", buf > f; close(f); print "M\t" f; inmer = 0 }
        else { buf = (nb++ ? buf "\n" : "") line }
        next
    }
    fence != "" { if (closes(t, fence)) fence = ""; next }
    t ~ /^```[ \t]*mermaid[ \t]*$/ { inmer = 1; buf = ""; nb = 0; next }
    fence_len(t) { fence = substr(t, 1, fence_len(t)); next }
    {
        gsub(/`[^`]*`/, "", line)
        s = line
        while (match(s, /!\[[^]]*\]\(<https?:\/\/[^>]+>/)) {
            m = substr(s, RSTART, RLENGTH); u = substr(m, index(m, "(<") + 2); print "U\t" substr(u, 1, length(u) - 1)
            s = substr(s, RSTART + RLENGTH)
        }
        s = line
        while (match(s, /!\[[^]]*\]\(https?:\/\/[^)> \t]+/)) {
            m = substr(s, RSTART, RLENGTH); print "U\t" substr(m, index(m, "](") + 2)
            s = substr(s, RSTART + RLENGTH)
        }
        s = line
        while (index(s, "<img") && match(s, /src="https?:\/\/[^"]+"/)) {
            m = substr(s, RSTART + 5, RLENGTH - 6); print "U\t" m
            s = substr(s, RSTART + RLENGTH)
        }
    }' "$1"
}

# cached_file <url>: prints the cached copy of a web image (empty if not downloaded yet)
cached_file() { local h; h=$(printf '%s' "$1" | hash); ls "$CACHE/web/$h".* 2>/dev/null | head -n 1; }

# download_web <url>: downloads a web image or PDF into .cache/web/
download_web() {
    local url=$1 h type ext tmp
    [ -n "$(cached_file "$url")" ] && return 0
    h=$(printf '%s' "$url" | hash)
    tmp="$CACHE/web/$h.part"
    type=$(fetch "$tmp" "$url") \
        || { rm -f "$tmp"; echo "  Warning: could not download $url" >&2; return 1; }
    case ${type%%;*} in
        image/png) ext=png ;; image/jpeg) ext=jpg ;; image/gif) ext=gif ;; image/webp) ext=webp ;;
        image/svg+xml) ext=svg ;; application/pdf) ext=pdf ;;
        *) case $(printf '%s' "${url%%[?#]*}" | tr 'A-Z' 'a-z') in
               *.png) ext=png ;; *.jpg|*.jpeg) ext=jpg ;; *.gif) ext=gif ;; *.webp) ext=webp ;;
               *.svg) ext=svg ;; *.pdf) ext=pdf ;; *) ext="" ;;
           esac ;;
    esac
    if [ -z "$ext" ]; then
        rm -f "$tmp"; echo "  Warning: $url is not an image or PDF, so it will be a link in the PDF" >&2; return 1
    fi
    mv "$tmp" "$CACHE/web/$h.$ext"
    echo "  Downloaded $url"
}

# render_mermaid <file.mmd>: renders a diagram into .cache/mermaid/<hash>.png (3x resolution)
render_mermaid() {
    local h png code width
    h=$(hash < "$1")
    png="$CACHE/mermaid/$h.png"
    [ -s "$png" ] && [ -s "$CACHE/mermaid/$h.width" ] && return 0
    code=$(base64 < "$1" | tr -d '\n' | tr '+/' '-_')
    if fetch "$png" "$MERMAID_SERVER/img/$code?type=png&bgColor=!white" >/dev/null; then
        width=$(png_width "$png")
        fetch "$png" "$MERMAID_SERVER/img/$code?type=png&bgColor=!white&width=$width&scale=3" >/dev/null \
            && echo "$width" > "$CACHE/mermaid/$h.width" && echo "  Rendered Mermaid diagram: $(head -n 1 "$1")" && return 0
    fi
    rm -f "$png"
    echo "  Warning: could not render Mermaid diagram \"$(head -n 1 "$1")\" (check the diagram code and your internet connection)" >&2
    return 1
}

# fetch_web: download/render everything the notes use and write the list for obsidian.typ
fetch_web() {
    local tmp f i=0 kind val file sep="" new
    need curl "Install curl (it comes with Git Bash on Windows and with macOS)."
    mkdir -p "$CACHE/web" "$CACHE/mermaid"
    tmp=$(mktemp -d)
    while IFS= read -r f; do
        i=$((i + 1)); scan_note "$f" "$tmp/m$i-"
    done < <(find_notes) > "$tmp/found"

    {
        printf '{\n  "web": {'
        while IFS=$'\t' read -r kind val; do
            [ "$kind" = U ] || continue
            download_web "$val" >&2
            file=$(cached_file "$val")
            [ -n "$file" ] && printf '%s\n    %s: "/%s"' "$sep" "$(printf '%s' "$val" | json_str)" "$file" && sep=","
        done < <(sort -u "$tmp/found")
        printf '\n  },\n  "mermaid": {'
        sep=""
        local seen=" "
        while IFS=$'\t' read -r kind val; do
            [ "$kind" = M ] || continue
            render_mermaid "$val" >&2 || continue
            file="$CACHE/mermaid/$(hash < "$val")"
            case $seen in *" $file "*) continue ;; esac
            seen="$seen$file "
            printf '%s\n    %s: { "path": "/%s.png", "width": %s }' "$sep" "$(json_str < "$val")" "$file" "$(cat "$file.width")"
            sep=","
        done < "$tmp/found"
        printf '\n  },\n  "files": ['
        sep=""
        while IFS= read -r f; do
            printf '%s\n    %s' "$sep" "$(printf '%s' "${f#./}" | json_str)"
            sep=","
        done < <(find_files)
        printf '\n  ]\n}\n'
    } > "$tmp/manifest"

    # Only replace the list when it changed, so `watch` doesn't rebuild for nothing
    cmp -s "$tmp/manifest" "$MANIFEST" || mv "$tmp/manifest" "$MANIFEST"
    rm -rf "$tmp"
}

# localize: copy cached web images into each note's attachments folder and point the links there
localize() {
    local f url file h name dir dest abs tmp
    fetch_web
    tmp=$(mktemp -d)
    while IFS= read -r f; do
        scan_note "$f" "$tmp/m-" | while IFS=$'\t' read -r kind url; do
            [ "$kind" = U ] || continue
            file=$(cached_file "$url"); [ -n "$file" ] || continue
            h=$(printf '%s' "$url" | hash)
            name=${url%%[?#]*}; name=${name##*/}; name=${name%.*}
            name=$(printf '%s' "$name" | tr -c 'A-Za-z0-9._-' '-' | cut -c1-60)
            [ ${#name} -lt 3 ] && name="web-${h:0:8}"
            dir=$(dirname "${f#./}"); [ "$dir" = . ] && dir="" || dir="$dir/"
            mkdir -p "${dir}attachments"
            dest="${dir}attachments/$name.${file##*.}"
            [ -e "$dest" ] && ! cmp -s "$file" "$dest" && dest="${dir}attachments/$name-${h:0:8}.${file##*.}"
            cp "$file" "$dest"
            abs="/$dest"
            FROM1="($url)" FROM2="(<$url>)" TO="(<$abs>)" FROM3="src=\"$url\"" TO3="src=\"$dest\"" awk '
                function rep(s, a, b,   o, i) { o = ""; while ((i = index(s, a)) > 0) { o = o substr(s, 1, i - 1) b; s = substr(s, i + length(a)) } return o s }
                { print rep(rep(rep($0, ENVIRON["FROM1"], ENVIRON["TO"]), ENVIRON["FROM2"], ENVIRON["TO"]), ENVIRON["FROM3"], ENVIRON["TO3"]) }
            ' "$f" > "$tmp/note" && mv "$tmp/note" "$f"
            echo "  $f: $url -> $dest"
        done
    done < <(find_notes)
    rm -rf "$tmp"
}

prepare() { if [ "$LOCALIZE_ON_BUILD" = true ]; then localize; else fetch_web; fi; }

# watch: rebuild on every save, and download/render new web images and diagrams as they appear
watch() {
    local pid stamp="$CACHE/.watch-stamp"
    prepare
    typst_run watch "$@" &
    pid=$!
    trap 'kill $pid 2>/dev/null; exit 0' INT TERM
    touch "$stamp"
    while kill -0 $pid 2>/dev/null; do
        sleep 2
        if [ -n "$(find_notes | while IFS= read -r f; do [ "$f" -nt "$stamp" ] && echo "$f"; done)" ]; then
            touch "$stamp"
            prepare
        fi
    done
}

# download <repo> <version> <file> <destination dir>
download() {
    curl -fsSL -o "$4/$3" "https://github.com/$1/releases/download/$2/$3"
}

# install_plugins <list>: download each plugin, copy its default settings, enable it
install_plugins() {
    local id repo version dir
    while read -r id repo version; do
        [ -z "$id" ] && continue
        echo "  $id $version"
        dir=".obsidian/plugins/$id"
        mkdir -p "$dir"
        download "$repo" "$version" main.js "$dir" && download "$repo" "$version" manifest.json "$dir" \
            || die "could not download $id. Check your internet connection and try again."
        download "$repo" "$version" styles.css "$dir" 2>/dev/null || rm -f "$dir/styles.css"
        [ -f ".obsidian.default/plugins/$id/data.json" ] && cp ".obsidian.default/plugins/$id/data.json" "$dir/"
        enabled="$enabled $id"
    done <<< "$1"
}

# Merge the newly installed plugins into .obsidian/community-plugins.json (keeps ones already enabled)
enable_plugins() {
    local file=.obsidian/community-plugins.json ids
    ids=$( { [ -f "$file" ] && grep -o '"[^"]*"' "$file" | tr -d '"'; printf '%s\n' $enabled; } | awk 'NF && !seen[$0]++')
    { echo "["; printf '%s\n' "$ids" | sed 's/.*/  "&"/; $!s/$/,/'; echo "]"; } > "$file"
}

install_theme() {
    local name repo version dir file=.obsidian/appearance.json
    read -r name repo version <<< "$EXTRA_THEME"
    echo "  $name theme $version"
    dir=".obsidian/themes/$name"
    mkdir -p "$dir"
    download "$repo" "$version" theme.css "$dir" && download "$repo" "$version" manifest.json "$dir" \
        || die "could not download the $name theme."
    if [ ! -s "$file" ] || [ "$(tr -d ' \n\r' < "$file")" = "{}" ]; then
        printf '{\n  "cssTheme": "%s"\n}\n' "$name" > "$file"
    elif grep -q '"cssTheme"' "$file"; then
        sed -i.bak "s/\"cssTheme\": *\"[^\"]*\"/\"cssTheme\": \"$name\"/" "$file" && rm -f "$file.bak"
    else
        awk -v n="$name" '!done && sub(/\{/, "{\n  \"cssTheme\": \"" n "\",") { done = 1 } 1' "$file" > "$file.tmp" \
            && mv "$file.tmp" "$file"
    fi
}

setup() {
    need curl "Install curl (it comes with Git Bash on Windows and with macOS)."
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1 && [ -n "$(git clean -ndX)" ]; then
        git clean -ndX
        ask "Remove the git-ignored files above (old settings, main.pdf)?" && git clean -fdX
    fi

    echo "Copying settings..."
    mkdir -p .obsidian
    cp .obsidian.default/*.json .obsidian/

    enabled=""
    echo "Installing required plugins..."
    install_plugins "$CORE_PLUGINS"
    if ask "Also install the extras (Minimal theme, Linter, Advanced Tables, Omnisearch and more)?"; then
        echo "Installing extras..."
        install_plugins "$EXTRA_PLUGINS"
        install_theme
    fi
    enable_plugins

    echo "Done. Open (or restart) Obsidian and click 'Trust author and enable plugins' if asked."
}

# Prints a JSON string from stdin as plain text (for `typst query` output)
json_decode() {
    LC_ALL=C awk '
    function hex(h,   n, i) { n = 0; for (i = 1; i <= 4; i++) n = n * 16 + index("0123456789abcdef", tolower(substr(h, i, 1))) - 1; return n }
    {
        s = $0; sub(/^[ \t]*"/, "", s); sub(/"[ \t]*$/, "", s)
        while ((i = index(s, "\\")) > 0) {
            printf "%s", substr(s, 1, i - 1)
            c = substr(s, i + 1, 1); s = substr(s, i + 2)
            if (c == "n") printf "\n"; else if (c == "t") printf "\t"; else if (c == "r") printf "\r"
            else if (c == "b") printf "\b"; else if (c == "f") printf "\f"
            else if (c == "u") { printf "%c", hex(substr(s, 1, 4)); s = substr(s, 5) }
            else printf "%s", c
        }
        printf "%s", s
    }'
}

# github_export: rewrite Obsidian-only syntax in every note as GitHub-friendly markdown, using the
# same converter as the PDF (obsidian.typ's `to-github`, run through `typst query`)
github_export() {
    need typst "See the Install section of README.md."
    local driver="$CACHE/github-export.typ" f out tmp
    echo "Converting Obsidian-only syntax to GitHub-friendly markdown..."
    fetch_web
    printf '%s\n' '#import "/obsidian.typ": to-github' \
        '#metadata(to-github(read("/" + sys.inputs.note), sys.inputs.note)) <github-export>' > "$driver"
    tmp=$(mktemp)
    while IFS= read -r f; do
        f=${f#./}
        [ "$f" = README.md ] && continue
        if ! out=$(typst eval 'query(<github-export>).first().value' --in "$driver" --root . \
            --input "web-cache=/$MANIFEST" --input "note=$f" 2>"$CACHE/github-export.log"); then
            echo "  Warning: could not convert $f:" >&2; head -n 5 "$CACHE/github-export.log" >&2; continue
        fi
        printf '%s\n' "$out" | json_decode > "$tmp"
        if ! cmp -s "$tmp" "$f"; then cp "$tmp" "$f"; echo "  Converted $f"; fi
    done < <(find_notes)
    rm -f "$tmp" "$driver"
}

format() {
    if [ "$1" = --github ]; then
        github_export
        command -v npm >/dev/null 2>&1 || { echo "Skipping prettier (Node.js isn't installed)."; return 0; }
    fi
    need npm "Install Node.js from https://nodejs.org first."
    local tools="$HOME/.cache/obsidian-typ-prettier"
    mkdir -p "$tools"
    echo '{ "plugins": ["mermaid-formatter/prettier-plugin"] }' > "$tools/.prettierrc"
    # Major versions are pinned: the options below need Prettier 3, and 0.x plugins can break on minor releases
    if ! npm install --prefix "$tools" --silent prettier@3 mermaid-formatter@0.3; then
        [ "$1" = --github ] && { echo "Warning: skipped prettier (npm install failed)." >&2; return 0; }
        die "npm install failed."
    fi
    # Prettier looks for plugins from the folder it runs in, so run it from $tools with full paths
    local vault notes=() f
    vault=$(pwd)
    while IFS= read -r f; do notes+=("$vault/${f#./}"); done < <(find_notes)
    [ ${#notes[@]} -gt 0 ] || { echo "No notes to format."; return 0; }
    if ! (cd "$tools" && ./node_modules/.bin/prettier --config .prettierrc --log-level warn --write "${notes[@]}"); then
        [ "$1" = --github ] && echo "The GitHub conversion above was still saved." >&2
        die "prettier failed (see the messages above)."
    fi
    echo "Formatted ${#notes[@]} notes."
}

menu() {
    echo "obsidian.typ toolbox"
    echo "  1) Build the PDF"
    echo "  2) Watch: rebuild the PDF on every save"
    echo "  3) Set up Obsidian: settings + plugins (close Obsidian first)"
    echo "  4) Format all markdown files"
    echo "  5) Download web images into attachments folders and relink them"
    read -r -p "Choose 1-5: " choice
    case $choice in
        1) main build ;;
        2) main watch ;;
        3) main setup ;;
        4) if ask "Also convert Obsidian-only syntax ([[links]], ![[embeds]], %%comments%%, …) to GitHub-friendly markdown?"; then
               main format --github
           else
               main format
           fi ;;
        5) main localize ;;
        *) die "Unknown choice: $choice" ;;
    esac
}

main() {
    local cmd=$1; shift
    case $cmd in
        build)  prepare && typst_run compile "$@" && echo "Done: PDF compiled." ;;
        watch)  watch "$@" ;;
        localize) localize ;;
        setup)  setup ;;
        format) format "$@" ;;
        "")     menu ;;
        *)      sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 1 ;;
    esac
}

main "$@"
