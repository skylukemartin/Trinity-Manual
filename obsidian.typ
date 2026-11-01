#import "@preview/cmarker:0.1.10"
#import "@preview/mitex:0.2.7": mitex

#let get-callout-icon-svg(icon-name, color-hex) = {
  let icons = (
    flame: "<path d=\"M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z\"/>",
    check: "<polyline points=\"20 6 9 17 4 12\"/>",
    info: "<circle cx=\"12\" cy=\"12\" r=\"10\"/><line x1=\"12\" y1=\"16\" x2=\"12\" y2=\"12\"/><line x1=\"12\" y1=\"8\" x2=\"12.01\" y2=\"8\"/>",
    pencil: "<path d=\"M17 3a2.85 2.83 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5Z\"/><path d=\"m15 5 4 4\"/>",
    warning: "<path d=\"m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z\"/><line x1=\"12\" y1=\"9\" x2=\"12\" y2=\"13\"/><line x1=\"12\" y1=\"17\" x2=\"12.01\" y2=\"17\"/>",
    error: "<circle cx=\"12\" cy=\"12\" r=\"10\"/><line x1=\"15\" y1=\"9\" x2=\"9\" y2=\"15\"/><line x1=\"9\" y1=\"9\" x2=\"15\" y2=\"15\"/>",
    bug: "<rect width=\"8\" height=\"14\" x=\"8\" y=\"6\" rx=\"4\"/><path d=\"m19 7-3 2\"/><path d=\"m5 7 3 2\"/><path d=\"m19 19-3-2\"/><path d=\"m5 19 3-2\"/><path d=\"M20 13h-4\"/><path d=\"M4 13h4\"/><path d=\"m10 4 1 2\"/><path d=\"m14 4-1 2\"/>",
    zap: "<polygon points=\"13 2 3 14 12 14 11 22 21 10 12 10 13 2\"/>",
    list: "<line x1=\"8\" y1=\"6\" x2=\"21\" y2=\"6\"/><line x1=\"8\" y1=\"12\" x2=\"21\" y2=\"12\"/><line x1=\"8\" y1=\"18\" x2=\"21\" y2=\"18\"/><line x1=\"3\" y1=\"6\" x2=\"3.01\" y2=\"6\"/><line x1=\"3\" y1=\"12\" x2=\"3.01\" y2=\"12\"/><line x1=\"3\" y1=\"18\" x2=\"3.01\" y2=\"18\"/>",
    quote: "<path d=\"M3 21c3 0 7-1 7-8V5c0-1.25-.756-2.017-2-2H4c-1.25 0-2 .75-2 1.972V11c0 1.25.75 2 2 2 1 0 1 0 1 1v1c0 1-1 2-2 2s-1 .008-1 1.031V20c0 1 0 1 1 1z\"/><path d=\"M15 21c3 0 7-1 7-8V5c0-1.25-.757-2.017-2-2h-4c-1.25 0-2 .75-2 1.972V11c0 1.25.75 2 2 2 1 0 1 0 1 1v1c0 1-1 2-2 2s-1 .008-1 1.031V20c0 1 0 1 1 1z\"/>",
  )

  let icon-body = icons.at(icon-name, default: icons.info)
  let raw-svg = (
    "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\""
      + color-hex
      + "\" stroke-width=\"2.2\" stroke-linecap=\"round\" stroke-linejoin=\"round\">"
      + icon-body
      + "</svg>"
  )

  image(bytes(raw-svg), format: "svg", width: 1.15em, height: 1.15em)
}

#let render-callout(attrs, body) = {
  let callout-type = lower(attrs.at("type", default: "note"))
  let title = attrs.at("title", default: "")

  let themes = (
    important: (icon: "flame", color: rgb("#0284c7"), default-title: "Important"),
    info: (icon: "info", color: rgb("#0284c7"), default-title: "Info"),
    note: (icon: "pencil", color: rgb("#0284c7"), default-title: "Note"),
    success: (icon: "check", color: rgb("#16a34a"), default-title: "Success"),
    tip: (icon: "flame", color: rgb("#0d9488"), default-title: "Tip"),
    warning: (icon: "warning", color: rgb("#d97706"), default-title: "Warning"),
    caution: (icon: "warning", color: rgb("#d97706"), default-title: "Caution"),
    error: (icon: "error", color: rgb("#dc2626"), default-title: "Error"),
    danger: (icon: "zap", color: rgb("#dc2626"), default-title: "Danger"),
    bug: (icon: "bug", color: rgb("#dc2626"), default-title: "Bug"),
    example: (icon: "list", color: rgb("#9333ea"), default-title: "Example"),
    quote: (icon: "quote", color: rgb("#6b7280"), default-title: "Quote"),
  )

  let theme = themes.at(callout-type, default: (
    icon: "info",
    color: rgb("#0284c7"),
    default-title: upper(callout-type.slice(0, 1)) + callout-type.slice(1),
  ))

  let display-title = if title != "" { title } else { theme.default-title }
  let hex-str = theme.color.to-hex()

  block(
    width: 100%,
    breakable: true,
    stroke: (left: 3.5pt + theme.color),
    fill: theme.color.lighten(94%),
    radius: (right: 4pt),
    inset: (x: 12pt, top: 8pt, bottom: 8pt),
    spacing: 1.2em,
  )[
    #grid(
      columns: (auto, 1fr),
      gutter: 7pt,
      align: (horizon, horizon),
      get-callout-icon-svg(theme.icon, hex-str), text(weight: 700, fill: theme.color, size: 0.95em)[#display-title],
    )
    #v(3pt)
    #body
  ]
}

// =============================================================================================
// Vault information from toolbox.sh
// =============================================================================================
// `./toolbox.sh build|watch|format` writes .cache/web-cache.json and passes it in with
// `--input web-cache=...`: every file in the vault (to resolve [[wikilinks]] the way Obsidian
// does), downloaded web images and rendered Mermaid diagrams. Without it (plain
// `typst compile`), links are resolved from the vault root only, web images become links
// and Mermaid diagrams stay as code.
#let vault = {
  let cache = if "web-cache" in sys.inputs { json(sys.inputs.at("web-cache")) } else { (:) }
  let by-path = (:) // lowercase path -> path
  let by-name = (:) // lowercase file name (and note name without .md) -> shortest path
  for path in cache.at("files", default: ()) {
    by-path.insert(lower(path), path)
    let name = path.split("/").last()
    let keys = (name,) + if name.ends-with(".md") { (name.slice(0, -3),) } else { () }
    for key in keys.map(lower) {
      let old = by-name.at(key, default: none)
      if old == none or path.len() < old.len() { by-name.insert(key, path) }
    }
  }
  (
    web: cache.at("web", default: (:)),
    mermaid: cache.at("mermaid", default: (:)),
    by-path: by-path,
    by-name: by-name,
    indexed: by-path.len() > 0,
  )
}

// =============================================================================================
// Small helpers
// =============================================================================================
#let attr-escape(text) = text.replace("&", "&amp;").replace("\"", "&quot;")
#let typst-str(text) = "\"" + text.replace("\\", "\\\\").replace("\"", "\\\"").replace(">", "\\u{3e}") + "\""
#let raw-typst(code) = "<!--raw-typst " + code + "-->"

#let image-exts = ("png", "jpg", "jpeg", "gif", "svg", "webp")
#let ext-of(path) = {
  let name = path.split("/").last()
  if name.contains(".") { lower(name.split(".").last()) } else { "" }
}
#let dir-of(path) = path.split("/").slice(0, -1).join("/")
#let stem-of(path) = {
  let name = path.split("/").last()
  if name.contains(".") { name.split(".").slice(0, -1).join(".") } else { name }
}

// %20 and other %XX escapes (ASCII only)
#let url-decode(text) = text.replace(regex("%([0-9A-Fa-f]{2})"), m => {
  let n = 0
  for c in lower(m.captures.at(0)) { n = n * 16 + "0123456789abcdef".position(c) }
  if n < 128 { str.from-unicode(n) } else { m.text }
})

// The heading label cmarker (and GitHub) generates: lowercase, punctuation dropped, spaces -> dashes
#let slug(text) = {
  lower(text.replace(regex("[*_`~=]|<[^>]*>"), "").trim())
    .replace(regex("[^\\p{L}\\p{N}\\s_-]"), "")
    .replace(regex("\s"), "-")
}

// Removes "." and ".." from a vault path (no leading slash)
#let normalize(path) = {
  let parts = ()
  for part in path.split("/") {
    if part == "" or part == "." { continue }
    if part == ".." { if parts.len() > 0 { let _ = parts.pop() } } else { parts.push(part) }
  }
  parts.join("/")
}

// Finds a linked file the way Obsidian does: "/path" from the vault root, "./path" or "../path"
// from the note's folder, otherwise the vault root, the note's folder, then any file with that
// name (shortest path wins). Returns a vault path without leading slash, or none.
#let resolve-path(target, note-dir, note: false) = {
  let target = url-decode(target.trim())
  if target == "" { return none }
  let candidates = if target.starts-with("/") {
    (target,)
  } else if target.starts-with("./") or target.starts-with("../") {
    (note-dir + "/" + target,)
  } else {
    (target, note-dir + "/" + target)
  }
  let candidates = candidates.map(normalize)
  if note and ext-of(target) == "" { candidates = candidates.map(c => c + ".md") + candidates }
  if not vault.indexed { return candidates.first() }
  for c in candidates {
    let found = vault.by-path.at(lower(c), default: none)
    if found != none { return found }
  }
  let name = lower(target.split("/").last())
  vault.by-name.at(name, default: vault.by-name.at(name + ".md", default: none))
}

// Obsidian %%comments%%: dropped (pdf) or turned into <!-- html comments --> (github).
// Returns (line, still-in-comment). Comments can span several lines.
#let convert-comments(line, in-comment, github: false) = {
  if not in-comment and not line.contains("%%") { return (line, false) }
  let parts = line.split("`")
  let out = ""
  for (i, part) in parts.enumerate() {
    if calc.odd(i) {
      let closed = i + 1 < parts.len()
      if not in-comment or github { out += "`" + part + (if closed { "`" } else { "" }) }
      continue
    }
    for (j, seg) in part.split("%%").enumerate() {
      if j > 0 {
        in-comment = not in-comment
        if github { out += if in-comment { "<!--" } else { "-->" } }
      }
      if not in-comment or github { out += seg }
    }
  }
  (out, in-comment)
}

// Strips YAML front matter (Obsidian properties)
#let strip-frontmatter(text) = {
  let text = text.replace("\r\n", "\n")
  let m = text.match(regex("^---[ \t]*\n(?:[\s\S]*?\n)?(?:---|\.\.\.)[ \t]*(?:\n|$)"))
  if m != none { text.slice(m.end) } else { text }
}

#let read-note(path) = strip-frontmatter(read("/" + path))

// The text of an image size alias: "300" or "300x200" (Obsidian pixels)
#let parse-size(text) = {
  let m = text.trim().match(regex("^(\d+)(?:x(\d+))?$"))
  if m == none { return none }
  (width: m.captures.at(0), height: m.captures.at(1))
}

// =============================================================================================
// Web images and Mermaid diagrams
// =============================================================================================

// A ```mermaid block becomes the rendered diagram if it's cached. Otherwise it stays a code
// block (still as a figure if it has a caption or id, so references to it keep working).
// Optional "%% caption: …" and "%% id: …" lines make it a numbered figure you can refer to.
#let replace-mermaid(lines) = {
  let code = ("```mermaid",) + lines + ("```",)
  let attrs = (:)
  for line in lines {
    let m = line.match(regex("^\s*%%\s*(caption|id)\s*:\s*(.*?)\s*$"))
    if m != none { attrs.insert(m.captures.at(0), m.captures.at(1)) }
  }
  let entry = vault.mermaid.at(lines.join("\n"), default: none)
  if entry != none { attrs += (src: entry.path, width: str(entry.width)) } else if attrs.len() == 0 { return code }
  let attr-text = attrs.pairs().map(((k, v)) => k + "=\"" + attr-escape(v) + "\"").join(" ")
  ("", "<mermaid " + attr-text + ">", "") + (if entry == none { code } else { () }) + ("", "</mermaid>", "")
}

#let render-mermaid(attrs, body) = {
  let diagram = if "src" in attrs {
    let natural = float(attrs.width) * 0.75pt // mermaid's CSS pixels -> points
    layout(size => image(attrs.src, width: calc.min(natural, size.width)))
  } else { body }
  let caption = attrs.at("caption", default: "")
  if caption == "" and "id" not in attrs { return align(center, diagram) }
  let fig = figure(diagram, caption: if caption != "" { caption }, kind: image)
  if "id" in attrs [#fig#label(attrs.id)] else { fig }
}

// =============================================================================================
// Links and embeds (PDF)
// =============================================================================================
// Internal links point at labels: "note:<path>" for a note, "block:<path>#<id>" for a ^block,
// and cmarker's heading labels (see `slug`). A link whose target isn't in the PDF is plain text.
// vault-link(target, …, body): links to the first target label that exists
#let vault-link(..args) = context {
  let (..targets, body) = args.pos()
  let found = none
  for target in targets {
    if found == none {
      let matches = query(label(target))
      if matches.len() > 0 { found = matches.first() }
    }
  }
  if found != none { link(found.location(), body) } else { body }
}
#let anchor(name) = raw-typst("#metadata(none)#label(" + typst-str(name) + ")")
#let pdf-link(targets, text) = {
  let targets = if type(targets) == array { targets } else { (targets,) }
  raw-typst("#vault-link(" + (targets + (text,)).map(typst-str).join(", ") + ")")
}

// [[target#fragment|alias]] -> (path, fragment, alias); path is none if the note doesn't exist
#let parse-wikilink(inner, note-dir) = {
  let inner = inner.replace("\\|", "|")
  let (target, alias) = if inner.contains("|") {
    let i = inner.position("|")
    (inner.slice(0, i), inner.slice(i + 1))
  } else { (inner, none) }
  let (file, fragment) = if target.contains("#") {
    let i = target.position("#")
    (target.slice(0, i), target.slice(i + 1).split("#").last())
  } else { (target, none) }
  let path = if file.trim() == "" { "" } else { resolve-path(file, note-dir, note: true) }
  (file: file.trim(), path: path, fragment: fragment, alias: alias)
}

// The label an internal link points at
#let link-target(path, fragment, note-path) = {
  let path = if path == "" { note-path } else { path }
  if fragment == none or fragment == "" { "note:" + path } else if fragment.starts-with("^") {
    "block:" + path + "#" + fragment.slice(1)
  } else { slug(fragment) }
}

// Image or PDF embed for the PDF; anything else becomes its file name
#let pdf-embed-file(path, alias, alt: "", page: none) = {
  let size = if alias != none { parse-size(alias) } else { none }
  let alt = if size == none and alias != none { alias } else { alt }
  let ext = ext-of(path)
  if ext in image-exts or ext == "pdf" {
    let args = ("\"/" + path + "\"",)
    if size != none { args.push("width: " + str(float(size.width) * 0.75) + "pt") }
    if size != none and size.height != none { args.push("height: " + str(float(size.height) * 0.75) + "pt") }
    if ext == "pdf" and page != none { args.push("page: " + str(page)) }
    if alt != "" { args.push("alt: " + typst-str(alt)) }
    raw-typst("#box(image(" + args.join(", ") + "))")
  } else {
    "*" + path.split("/").last() + "*"
  }
}

// =============================================================================================
// Inline conversions (one line of text outside code)
// =============================================================================================
// A vault path relative to a folder ("../attachments/x.png"), as GitHub resolves <img src>
#let relative-to(path, dir) = {
  let from = if dir == "" { () } else { dir.split("/") }
  let to = path.split("/")
  let common = 0
  while common < from.len() and common < to.len() - 1 and from.at(common) == to.at(common) { common += 1 }
  "../" * (from.len() - common) + to.slice(common).join("/")
}

#let convert-part(part, note-path, github: false, in-figure: false) = {
    let note-dir = dir-of(note-path)

    // [[wikilinks]] and ![[embeds]]
    part = part.replace(regex("(!?)\[\[([^\]\n]+)\]\]"), m => {
      let embed = m.captures.at(0) == "!"
      let w = parse-wikilink(m.captures.at(1), note-dir)
      let display = if w.alias != none and not embed { w.alias } else if w.file == "" {
        if w.fragment == none { "" } else { w.fragment.trim("^") }
      } else if w.fragment != none and not w.fragment.starts-with("^") {
        stem-of(w.file) + " > " + w.fragment
      } else { stem-of(w.file) }
      if w.path == none { return if github { m.text } else { display } }
      let is-note = w.path == "" or w.path.ends-with(".md")
      if github {
        let url = if w.path == "" { "" } else { "/" + w.path }
        if embed and not is-note {
          let size = if w.alias != none { parse-size(w.alias) } else { none }
          if size != none and ext-of(w.path) in image-exts {
            let rel = relative-to(w.path, note-dir)
            let height = if size.height != none { " height=\"" + size.height + "\"" } else { "" }
            return "<img src=\"" + attr-escape(rel.replace(" ", "%20")) + "\" width=\"" + size.width + "\"" + height + ">"
          }
          let page = if w.fragment != none and w.fragment.starts-with("page=") { "#" + w.fragment } else { "" }
          // GitHub can't show these anyway; Obsidian's ![alt|width](…) keeps the size for Obsidian and the PDF
          return "![" + (if w.alias != none { (if size != none { "|" } else { "" }) + w.alias } else { "" }) + "](<" + url + page + ">)"
        }
        if embed { return "![](<" + url + (if w.fragment != none { "#" + w.fragment } else { "" }) + ">)" }
        let frag = if w.fragment == none { "" } else if w.fragment.starts-with("^") {
          "#" + w.fragment.slice(1)
        } else { "#" + slug(w.fragment) }
        return "[" + display + "](<" + url + frag + ">)"
      }
      if embed and not is-note {
        let page = if w.fragment != none { w.fragment.match(regex("page=(\d+)")) } else { none }
        return pdf-embed-file(w.path, w.alias, page: if page != none { int(page.captures.at(0)) })
      }
      // (note embeds are expanded line by line in process-markdown-text)
      pdf-link(link-target(w.path, w.fragment, note-path), display)
    })

    // Markdown links and images: [text](target) and ![alt](target)
    part = part.replace(
      regex("(!?)\[([^\]]*)\]\(\s*(<[^>]*>|[^)\s]+)((?:\s+\"[^\"]*\")?)\s*\)"),
      m => {
        let (bang, text, target, title) = m.captures
        let target = target.trim("<", at: start).trim(">", at: end)
        let embed = bang == "!"
        // Obsidian image size: ![alt|300](...)
        let (alt, size) = if embed and text.contains("|") {
          let i = text.position("|")
          (text.slice(0, i), parse-size(text.slice(i + 1)))
        } else { (text, none) }
        let web = target.starts-with("http://") or target.starts-with("https://")
        if web and embed {
          if github {
            if size == none { return m.text }
            return "<img src=\"" + attr-escape(target) + "\" alt=\"" + attr-escape(alt) + "\" width=\"" + size.width + "\">"
          }
          let cached = vault.web.at(target, default: none)
          if cached == none { return "[" + (if alt == "" { target } else { alt }) + "](<" + target + ">)" }
          return pdf-embed-file(cached.slice(1), if size != none { text.slice(text.position("|") + 1) }, alt: alt)
        }
        if web or target.starts-with("mailto:") or target.contains("://") { return m.text }

        // Local file, possibly with #heading / #^block / #page=N
        let (file, fragment) = if target.contains("#") {
          let i = target.position("#")
          (target.slice(0, i), url-decode(target.slice(i + 1)))
        } else { (target, none) }
        let path = if file == "" { "" } else { resolve-path(file, note-dir) }
        if github {
          if embed and size != none and path != none and ext-of(path) in image-exts {
            let rel = relative-to(path, note-dir)
            return "<img src=\"" + attr-escape(rel.replace(" ", "%20")) + "\" alt=\"" + attr-escape(alt) + "\" width=\"" + size.width + "\">"
          }
          if not embed and fragment != none and (file == "" or file.ends-with(".md")) and not fragment.starts-with("^") {
            return "[" + text + "](<" + file + "#" + slug(fragment) + ">)"
          }
          return m.text
        }
        if path == none { return if embed { alt } else { text } }
        if embed {
          // (note embeds are expanded line by line in process-markdown-text)
          let page = if fragment != none { fragment.match(regex("page=(\d+)")) } else { none }
          return pdf-embed-file(
            path,
            if size != none { text.slice(text.position("|") + 1) },
            alt: alt,
            page: if page != none { int(page.captures.at(0)) },
          )
        }
        if path == "" or path.ends-with(".md") {
          // A #fragment can be a heading or a block (<a id> from `format --github`)
          let targets = if fragment != none and not fragment.starts-with("^") {
            ("block:" + (if path == "" { note-path } else { path }) + "#" + fragment, slug(fragment))
          } else { link-target(path, fragment, note-path) }
          return pdf-link(targets, text)
        }
        text // a link to another local file isn't useful in a PDF
      },
    )

    // <img src="…">: cached web images, vault-relative paths, Obsidian pixel widths
    part = part.replace(regex("<img\b[^>]*>"), m => {
      let tag = m.text
      let src = tag.match(regex("\bsrc=\"([^\"]+)\""))
      if src == none { return tag }
      let url = src.captures.at(0)
      if github {
        if url.contains("://") { return tag }
        let path = resolve-path(url, note-dir)
        if path == none { return tag }
        let rel = relative-to(path, note-dir)
        return tag.replace(src.text, "src=\"" + attr-escape(rel.replace(" ", "%20")) + "\"")
      }
      let new-src = if url.starts-with("http://") or url.starts-with("https://") {
        vault.web.at(url, default: none)
      } else {
        let path = resolve-path(url, note-dir)
        if path != none { "/" + path }
      }
      if new-src == none {
        return if url.contains("://") { "<a href=\"" + url + "\">" + url + "</a>" } else { "" }
      }
      // Outside <figure>, draw it like ![[image|width]] (inline, so images can sit side by side)
      if not in-figure {
        let args = ("\"" + new-src + "\"",)
        for key in ("width", "height") {
          let v = tag.match(regex("\b" + key + "=\"(\d+(?:\.\d+)?)(px|%)?\""))
          if v != none {
            args.push(key + ": " + (if v.captures.at(1) == "%" { v.captures.at(0) + "%" } else {
              str(float(v.captures.at(0)) * 0.75) + "pt"
            }))
          }
        }
        let alt = tag.match(regex("\balt=\"([^\"]*)\""))
        if alt != none and alt.captures.at(0) != "" { args.push("alt: " + typst-str(alt.captures.at(0))) }
        return raw-typst("#box(image(" + args.join(", ") + "))")
      }
      tag
        .replace(src.text, "src=\"" + new-src + "\"")
        .replace(regex("\b(width|height)=\"(\d+)(?:px)?\""), w => {
          w.captures.at(0) + "=\"" + str(int(calc.round(float(w.captures.at(1)) * 0.75))) + "\"" // px -> pt
        })
    })

    // <a id="…"></a> anchors (from `format --github`) -> link targets in the PDF
    if not github {
      part = part.replace(regex("<a\s+(?:id|name)=\"([^\"]+)\"\s*>\s*</a>"), m => {
        anchor("block:" + note-path + "#" + m.captures.at(0))
      })
    }

    // ==highlight== -> <mark>highlight</mark>
    part.replace(regex("==([^=\s](?:[^=]*[^=\s])?)=="), m => "<mark>" + m.captures.at(0) + "</mark>")
}

// Converts one line. Returns (line, footnotes): new "[^id]: text" definitions for ^[inline notes].
#let convert-inline(line, note-path, github: false, footnote-start: 0, in-figure: false) = {
  let footnotes = ()
  let parts = line.split("`")
  let out = ()
  for (i, part) in parts.enumerate() {
    if calc.odd(i) {
      out.push(part)
      continue
    }
    // ^[inline footnote] -> [^inline-N] + a definition at the end of the note
    let new = ""
    let last = 0
    for m in part.matches(regex("\^\[([^\]]*)\]")) {
      let id = "inline-" + str(footnote-start + footnotes.len() + 1)
      footnotes.push("[^" + id + "]: " + m.captures.at(0))
      new += part.slice(last, m.start) + "[^" + id + "]"
      last = m.end
    }
    out.push(convert-part(new + part.slice(last), note-path, github: github, in-figure: in-figure))
  }
  let line = out.join("`")

  // A ^block-id at the end of a line (or on its own line after a list/table/quote)
  let block = line.match(regex("(^|\s)\^([A-Za-z0-9-]+)\s*$"))
  if block != none {
    let id = block.captures.at(1)
    line = line.slice(0, block.start) + (if github { " <a id=\"" + id + "\"></a>" } else { " " + anchor("block:" + note-path + "#" + id) })
    if line.trim() != "" and block.captures.at(0) == "" { line = line.trim() }
  }

  // Task statuses Obsidian themes add (- [/], - [-], - [>] …) count as done; markdown only knows [x]
  if not github {
    line = line.replace(regex("^(\s*(?:[-*+]|\d+[.)])\s+)\[[^ xX\]]\]"), m => m.captures.at(0) + "[x]")
  }

  (line, footnotes)
}

// =============================================================================================
// Callouts
// =============================================================================================
#let parse-obsidian-callouts(text) = {
  (text + "\n").replace(
    regex("(?m)^>[ \t]*\[!([a-zA-Z0-9_-]+)\][+-]?[ \t]*(.*?)\r?\n((?:>[ \t]*.*(?:\r?\n|$))*)"),
    m => {
      let callout-type = m.captures.at(0)
      let raw-title = m.captures.at(1).trim()
      let title = attr-escape(raw-title.replace(regex("^\*+|\*+$"), "").replace(regex("^_+|_+$"), "").trim())
      let body = m.captures.at(2).replace(regex("(?m)^>[ \t]?"), "")
      // GitHub alerts can't have titles, so `format --github` puts the title on a bold first line
      if title == "" {
        let first = body.match(regex("^[ \t]*\*\*([^*\n]+)\*\*[ \t]*\n(?:[ \t]*\n)?"))
        if first != none {
          title = attr-escape(first.captures.at(0))
          body = body.slice(first.end)
        }
      }
      // Callouts inside callouts
      let body = if body.contains("[!") { parse-obsidian-callouts(body) } else { body }
      "\n\n<callout type=\"" + callout-type + "\" title=\"" + title + "\">\n\n" + body + "\n\n</callout>\n\n"
    },
  )
}

// Obsidian callout types -> the five GitHub alerts
#let github-alert(type) = {
  let type = lower(type)
  if type in ("tip", "hint", "success", "check", "done") { "TIP" }
  else if type in ("important",) { "IMPORTANT" }
  else if type in ("warning", "attention", "question", "help", "faq") { "WARNING" }
  else if type in ("caution", "danger", "error", "bug", "failure", "fail", "missing") { "CAUTION" }
  else { "NOTE" }
}

// =============================================================================================
// Headings and embedded notes (PDF)
// =============================================================================================
// Code fences (CommonMark): a block opened by N backticks/tildes only closes on a line of at
// least N of the same character, so ````markdown can show a ```mermaid example inside it.
// Returns the open fence ("```", "````", "~~~", …) or none.
#let fence-of(trimmed) = {
  let m = trimmed.match(regex("^(`{3,}|~{3,})"))
  if m == none { none } else { m.captures.at(0) }
}
#let next-fence(fence, trimmed) = {
  let f = fence-of(trimmed)
  if f == none { return fence }
  if fence == none { return f }
  let closes = f.first() == fence.first() and f.len() >= fence.len() and trimmed.slice(f.len()).trim() == ""
  if closes { none } else { fence }
}

#let get-min-heading-level(raw-text) = {
  let min-h = 7
  let fence = none
  let in-exclude-block = false
  for line in raw-text.split("\n") {
    let trimmed = line.trim()
    if trimmed.starts-with("<!--typst-begin-exclude-->") { in-exclude-block = true }
    if in-exclude-block {
      if trimmed.contains("<!--typst-end-exclude-->") { in-exclude-block = false }
      continue
    }
    if fence != none or fence-of(trimmed) != none {
      fence = next-fence(fence, trimmed)
      continue
    }
    let h-match = line.match(regex("^ *(#{1,6}) +"))
    if h-match != none { min-h = calc.min(min-h, h-match.captures.at(0).len()) }
  }
  if min-h > 6 { 1 } else { min-h }
}

#let shift-markdown-headings(text, offset) = {
  if offset == 0 { return text }
  let fence = none
  let out = ()
  for line in text.split("\n") {
    let trimmed = line.trim()
    let was-in-code = fence != none
    fence = next-fence(fence, trimmed)
    if not was-in-code and fence == none {
      line = line.replace(regex("^([ \t]*)(#{1,6})([ \t]+)"), m => {
        let (indent, hashes, space) = m.captures
        indent + ("#" * calc.min(calc.max(hashes.len() + offset, 1), 6)) + space
      })
    }
    out.push(line)
  }
  out.join("\n")
}

// The part of a note under one heading: (heading text, text) or none
#let extract-section(text, fragment) = {
  let lines = text.split("\n")
  let fence = none
  let start = none
  let level = 0
  let title = none
  for (i, line) in lines.enumerate() {
    if fence != none or fence-of(line.trim()) != none {
      fence = next-fence(fence, line.trim())
      continue
    }
    let h = line.match(regex("^ *(#{1,6}) +(.*?)\s*#*\s*$"))
    if h == none { continue }
    if start == none {
      if slug(h.captures.at(1)) == slug(fragment) {
        start = i + 1
        level = h.captures.at(0).len()
        title = h.captures.at(1)
      }
    } else if h.captures.at(0).len() <= level {
      return (title, lines.slice(start, i).join("\n"))
    }
  }
  if start == none { none } else { (title, lines.slice(start).join("\n")) }
}

// The paragraph (or list/table/quote) marked with ^id
#let extract-block(text, id) = {
  let lines = text.split("\n")
  let at = lines.position(l => l.match(regex("(^|\s)\^" + id + "\s*$")) != none)
  if at == none { return none }
  let own-line = lines.at(at).trim() == "^" + id
  let end = if own-line { at } else { at + 1 }
  let start = if own-line { at - 1 } else { at }
  while start > 0 and lines.at(start - 1).trim() != "" { start -= 1 }
  if own-line { while start < end and lines.at(start).trim() == "" { start += 1 } }
  lines.slice(start, end).join("\n").replace(regex("\s\^" + id + "\s*$"), "")
}

// =============================================================================================
// One note -> markdown for cmarker (PDF) or GitHub
// =============================================================================================
#let process-markdown-text(raw-text, note-path: "", base-h: 0, embed-headings: true, embed-offset: 1, github: false) = {
  let lines = raw-text.split("\n")
  let out-lines = ()
  let footnotes = ()
  let current-h = base-h
  let fence = none
  let in-exclude-block = false
  let in-comment = false
  let in-figure = false
  let math-lines = none
  let mermaid-lines = none

  for line in lines {
    let line = line.trim("\r", at: end)
    let trimmed = line.trim()

    if trimmed.starts-with("<!--typst-begin-exclude-->") { in-exclude-block = true }
    if in-exclude-block {
      if trimmed.contains("<!--typst-end-exclude-->") { in-exclude-block = false }
      out-lines.push(line)
      continue
    }

    if mermaid-lines != none {
      if next-fence("```", trimmed) == none {
        out-lines += replace-mermaid(mermaid-lines)
        mermaid-lines = none
      } else {
        mermaid-lines.push(line)
      }
      continue
    }
    if not github and fence == none and not in-comment and trimmed.match(regex("^```\s*mermaid\s*$")) != none {
      mermaid-lines = ()
      continue
    }

    if fence != none or (not in-comment and fence-of(trimmed) != none) {
      fence = next-fence(fence, trimmed)
      out-lines.push(line)
      continue
    }

    // %%comments%%
    let (line, still-in-comment) = convert-comments(line, in-comment, github: github)
    let was-in-comment = in-comment
    in-comment = still-in-comment
    if not github and (was-in-comment or in-comment) and line.trim() == "" { continue }
    let trimmed = line.trim()

    // Join multi-line $$ … $$ blocks into one line, so markdown can't misread lines
    // inside them (a lone "=" or "-" becomes a heading, a blank line ends the maths).
    if not github {
      if math-lines != none {
        if trimmed != "" { math-lines.push(trimmed) }
        if trimmed.ends-with("$$") {
          out-lines.push(math-lines.join(" "))
          math-lines = none
        }
        continue
      }
      if trimmed.starts-with("$$") and not trimmed.slice(2).contains("$$") {
        math-lines = (trimmed,)
        continue
      }
    }

    // Callouts -> GitHub alerts
    if github {
      let c = line.match(regex("^(\s*>\s*)\[!([A-Za-z0-9_-]+)\]([+-]?)\s*(.*)$"))
      if c != none {
        let (prefix, type, fold, title) = c.captures
        let alert = github-alert(type)
        let name = if title.trim() != "" { title.trim() } else if lower(type) != lower(alert) {
          upper(type.slice(0, 1)) + lower(type.slice(1))
        }
        out-lines.push(prefix + "[!" + alert + "]")
        if name != none {
          let (name, _) = convert-inline(name.trim("*"), note-path, github: true)
          out-lines.push(prefix.trim(at: end) + " **" + name + "**")
          out-lines.push(prefix.trim(at: end))
        }
        continue
      }
    }

    let h-match = line.match(regex("^ *(#{1,6}) +"))
    if h-match != none {
      current-h = h-match.captures.at(0).len()
      let (converted, _) = convert-inline(line, note-path, github: github)
      out-lines.push(converted)
      continue
    }

    // Embedded notes: ![](</docs/Note.md>), ![title](Note.md#Heading), ![[Note]], ![[Note#^block]]
    let embed = none
    if not github {
      let md = line.match(regex("!\[([^\]]*)\]\(\s*<?([^>\)]+?\.(?:md|markdown))(#[^>\)]*)?>?\s*\)"))
      let wiki = line.match(regex("!\[\[([^\]\n]+)\]\]"))
      if md != none and (wiki == none or md.start < wiki.start) {
        let path = resolve-path(md.captures.at(1), dir-of(note-path))
        let fragment = if md.captures.at(2) != none { url-decode(md.captures.at(2).slice(1)) }
        if path != none { embed = (path: path, fragment: fragment, title: md.captures.at(0).trim()) }
      } else if wiki != none {
        let w = parse-wikilink(wiki.captures.at(0), dir-of(note-path))
        if w.path != none and (w.path == "" or w.path.ends-with(".md")) {
          let path = if w.path == "" { note-path } else { w.path }
          embed = (path: path, fragment: w.fragment, title: if w.alias != none { w.alias } else { "" })
        }
      }
    }
    if embed != none {
      let note-text = read-note(embed.path)
      let (default-title, body, with-heading) = if embed.fragment == none or embed.fragment == "" {
        (stem-of(embed.path), note-text, embed-headings)
      } else if embed.fragment.starts-with("^") {
        let block = extract-block(note-text, embed.fragment.slice(1))
        ("", if block == none { "" } else { block }, false)
      } else {
        let section = extract-section(note-text, embed.fragment)
        if section == none { (embed.fragment, "", embed-headings) } else { (section.at(0), section.at(1), embed-headings) }
      }
      let display-title = if embed.title != "" { embed.title } else { default-title }
      let target-h = if current-h == 0 { 1 } else { calc.min(current-h + embed-offset, 6) }
      let min-h = get-min-heading-level(body)
      let parts = ()
      if embed.fragment == none or embed.fragment == "" { parts.push(anchor("note:" + embed.path)) }
      if with-heading {
        parts.push(("#" * target-h) + " " + display-title + "\n")
        let child-h = calc.min(target-h + (if embed-offset > 0 { 1 } else { 0 }), 6)
        parts.push(process-markdown-text(
          shift-markdown-headings(body, child-h - min-h),
          note-path: embed.path,
          base-h: target-h,
          embed-headings: embed-headings,
          embed-offset: embed-offset,
        ))
      } else {
        let shifted = if embed.fragment != none and embed.fragment.starts-with("^") { body } else {
          shift-markdown-headings(body, target-h - min-h)
        }
        parts.push(process-markdown-text(
          shifted,
          note-path: embed.path,
          base-h: if current-h == 0 { 0 } else { current-h },
          embed-headings: embed-headings,
          embed-offset: embed-offset,
        ))
      }
      out-lines.push(parts.join("\n"))
      continue
    }

    if line.contains("<figure") { in-figure = true }
    let (converted, new-footnotes) = convert-inline(
      line,
      note-path,
      github: github,
      footnote-start: footnotes.len(),
      in-figure: in-figure,
    )
    if line.contains("</figure>") { in-figure = false }
    footnotes += new-footnotes
    out-lines.push(converted)
  }
  if math-lines != none { out-lines.push(math-lines.join(" ")) }
  if mermaid-lines != none { out-lines += replace-mermaid(mermaid-lines) }
  if footnotes.len() > 0 {
    if out-lines.len() > 0 and out-lines.last() == "" { let _ = out-lines.pop() }
    out-lines += ("",) + footnotes + ("",)
  }

  out-lines.join("\n")
}

// =============================================================================================
// GitHub export (used by `./toolbox.sh format --github`)
// =============================================================================================
// Converts Obsidian-only syntax in a note to markdown that GitHub (and Obsidian) render:
// [[wikilinks]] -> links, ![[embeds]] -> images, %%comments%% -> <!-- -->, callouts ->
// GitHub alerts, ^[inline footnotes] -> footnotes, ^block-ids -> <a id> anchors,
// image sizes -> <img width>. Front matter, code, maths and Mermaid are left alone.
#let to-github(text, path) = {
  let text = text.replace("\r\n", "\n")
  let m = text.match(regex("^---[ \t]*\n(?:[\s\S]*?\n)?(?:---|\.\.\.)[ \t]*(?:\n|$)"))
  let front = if m != none { m.text } else { "" }
  front + process-markdown-text(text.slice(front.len()), note-path: path, github: true)
}

// =============================================================================================
// Rendering
// =============================================================================================
#let task-box(checked) = box(
  width: 0.8em,
  height: 0.8em,
  stroke: 0.6pt + luma(90),
  radius: 1.5pt,
  baseline: 0.1em,
  align(center + horizon, if checked { text(0.75em, font: "DejaVu Sans Mono", weight: "bold")[✓] }),
)

#let render_markdown(..args) = {
  let file-headings = args.named().at("file-headings", default: false)
  let embed-headings = args.named().at("embed-headings", default: true)
  let embed-offset = args.named().at("embed-offset", default: 1)
  let auto-pagebreak = args.named().at("auto-pagebreak", default: true)
  // Colour for links in the text; none keeps the document template's own link style
  let link-color = args.named().at("link-color", default: rgb("#0284c7"))
  // How callouts are drawn: auto = the built-in boxes, or a function (type, title, body) => content
  // where type is lowercase ("note", "warning", …) and title is none when the callout has none
  let callout = args.named().at("callout", default: auto)
  let files = args.pos()

  let process_file(path) = {
    let path = normalize(path)
    let content = read-note(path)
    let initial-text = if file-headings { "# " + stem-of(path) + "\n\n" + content } else { content }
    let expanded = process-markdown-text(
      initial-text,
      note-path: path,
      base-h: if file-headings { 1 } else { 0 },
      embed-headings: embed-headings,
      embed-offset: embed-offset,
    )
    anchor("note:" + path) + "\n\n" + parse-obsidian-callouts(expanded)
  }

  let combined_md = files.map(process_file).join("\n<!--raw-typst #pagebreak(weak: true)-->\n")

  let rendered = cmarker.render(
    combined_md,
    math: mitex,
    task-list-marker: task-box,
    html: (
      callout: (attrs, body) => if callout == auto { render-callout(attrs, body) } else {
        let title = attrs.at("title", default: "")
        callout(lower(attrs.at("type", default: "note")), if title != "" { title }, body)
      },
      mermaid: (attrs, body) => render-mermaid(attrs, body),
    ),
    scope: (
      image: (source, ..args) => image(source, ..args),
      vault-link: vault-link,
    ),
  )

  show link: it => if link-color == none { it } else { text(fill: link-color, it) }

  if auto-pagebreak {
    show heading.where(level: 1): it => {
      pagebreak(weak: true)
      it
    }
    rendered
  } else {
    rendered
  }
}
