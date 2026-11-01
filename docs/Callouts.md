Obsidian callouts become coloured boxes with an icon. Type `> [!type] Optional title` and continue every line of the callout with `>`.

> [!note]
> A callout without a title uses its type as the title.

> [!tip] Callouts can contain other markdown
> - **Lists**, *formatting* and `code`
> - Citations, like [@ObsidianSharpenYour]

> [!important] Important
> Use these sparingly, so they stand out.

> [!success] Done
> The PDF built without errors.

> [!warning] Check before submitting
> Make sure the title page in `main.typ` has your details.

> [!danger] Danger
> Running setup with `y` to "Remove the git-ignored files" deletes your current Obsidian settings.

> [!bug] Known issue
> Plugin-only syntax like Dataview queries isn't converted: it stays a code block in the PDF.

> [!example]- Folded callouts
> A callout folded in Obsidian with `-` (or `+`) is always shown expanded in the PDF.

> [!quote] Edsger W. Dijkstra
> Simplicity is prerequisite for reliability.

> [!info] Callouts can be nested
> > [!tip] Inner callout
> > Start a line with `> >` to put a callout inside another one.

> [!question] Any other type
> Callout types the template doesn't know, like `question`, get a blue box with the type as the title.
