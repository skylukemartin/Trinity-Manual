<!--typst-begin-exclude-->

> [!tip] Start here
> This is `main.md`, the entry point of the PDF. Each `![](</docs/...>)` line below pulls a whole note from `docs/` into the PDF at that spot.
>
> Everything between the `typst-begin-exclude` and `typst-end-exclude` comments, like this callout, only shows up in Obsidian. Build the PDF with `./toolbox.sh build`, compare it with these notes, then replace the example content with your own.

<!--typst-end-exclude-->

# Introduction

This manual is an example of what the template can do. It was written as plain notes in Obsidian [@ObsidianSharpenYour] and typeset with Typst [@Typst], which reads the markdown through the cmarker package [@CmarkerTypstUniverse]. Every feature shown in [@writing-your-manual] is written the same way you would write any other Obsidian note.

![Background and Motivation](</docs/Background.md>)

# Writing Your Manual

Each section of this chapter is a separate note in the `docs/` folder, embedded here with a single line. The note's file name becomes the section heading, and its own headings are moved one level down to fit underneath.

![](</docs/Text Formatting.md>)

![](</docs/Callouts.md>)

![](</docs/Figures and Tables.md>)

![](</docs/Maths and Code.md>)

![](</docs/Obsidian Syntax.md>)

![](</docs/Hiding Content and Raw Typst.md>)

# Conclusion

The template turns ordinary Obsidian notes into a structured manual with a cover, table of contents, numbered sections and figures, callouts, maths and a reference list, as shown in [@introduction] to [@hiding-content-and-raw-typst].

To start your own manual:

1. Fill in the title, version and author in `main.typ`.
2. Replace the notes in `docs/` with your own sections and embed them in `main.md`.
3. Add your sources to `citations/references.bib` through Zotero.
4. Run `./toolbox.sh watch` and write.
