---
tags:
  - example
aliases:
  - Obsidian Markdown
---
Notes can use Obsidian's own syntax as well as standard markdown. The properties at the top of this note (front matter) are left out of the PDF.

# Links

- A link to another note: [[Callouts]]. In the PDF it's clickable.
- With different text: [[Callouts|the coloured boxes]].
- To a heading in another note: [[Text Formatting#Lists]].
- To a heading in this note: [[#Embeds]].
- To a block: [[#^key-point|the key point]].
- Markdown links work as well: [Maths and Code](</docs/Maths and Code.md>).
- A link to a note that isn't in the PDF is plain text: [[Not In The PDF]].

This sentence is the key point that the link above jumps to. ^key-point

# Embeds

`![[Note]]` inserts a whole note, `![[Note#Heading]]` one section of it, and `![[Note#^id]]` a single block. This is the "Goals" section of the background note:

![[Background#Goals]]

Images and PDFs can be embedded by name, with an optional width in pixels, like `![[Progress Chart.png|250]]`:

![[Progress Chart.png|250]] ![[Sample Handout.pdf#page=1|250]]

# Comments, Highlights and Footnotes

This sentence has an Obsidian comment after it, which only shows in Obsidian's editor. %%Like this one.%%

%%
A comment can also span several lines,
like this.
%%

==Highlighted text==, and an inline footnote^[Written straight into the text, like this.] that becomes a normal footnote.

# Tasks

- [ ] Something to do
- [x] Something done
- [/] In progress (other marks count as done)

# Tags

Tags like #example and #obsidian/syntax stay as plain text.
