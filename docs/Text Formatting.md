Regular markdown formatting carries over to the PDF: *italic*, **bold**, ***both***, ~~strikethrough~~, ==highlighted==, `inline code` and [external links](https://typst.app). HTML tags fill the gaps markdown leaves, such as H<sub>2</sub>O and E = mc<sup>2</sup>.

# Lists

Unordered lists can be nested:

- Planning
    - Choose a topic
    - Find sources
- Writing
- Proofreading

Numbered lists keep their numbering:

1. Write the notes in Obsidian.
2. Embed them in `main.md`.
3. Build the PDF.

# Quotes and Footnotes

A plain blockquote is shown as an indented quote:

> Simplicity is prerequisite for reliability.

Footnotes go at the bottom of the page.[^footnote]

[^footnote]: Write a footnote with `[^name]` in the text and `[^name]: text` anywhere in the note.

# Citations and Cross-References

Cite a source from `citations/references.bib` with `[@key]`, for example [@Typst]. The same syntax refers to headings and figures inside the document: `[@callouts]` becomes [@callouts], and `[@pipeline]` becomes [@pipeline]. Heading labels are the heading text in lowercase with dashes instead of spaces.
