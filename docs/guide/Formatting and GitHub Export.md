Both of these commands rewrite your notes.

> [!warning] Commit your work first
> That way you can undo the changes with git if you don't like the result.

# Tidying With Prettier

```bash
./toolbox.sh format
```

This tidies every `.md` file in the vault, including Mermaid code, with [Prettier](https://prettier.io). It needs [Node.js](https://nodejs.org), and the first run downloads Prettier into `~/.cache/obsidian-typ-prettier`, so it needs an internet connection.

# Making Notes Readable on GitHub

Obsidian-only syntax, such as `[[links]]` and comments, shows up as raw text on GitHub. To rewrite it as standard markdown that GitHub, Obsidian **and** the PDF all understand, run:

```bash
./toolbox.sh format --github
```

You can also choose **4** in the menu and answer `y`. This needs Typst but not Node.js: without Node.js, it skips the Prettier step. It makes these changes:

| Obsidian | Becomes |
| --- | --- |
| `[[Note]]`, `[[Note\|text]]` | `[Note](</docs/Note.md>)`, `[text](…)` |
| `![[pic.png\|300]]` | `<img src="attachments/pic.png" width="300">` |
| `==text==` | `<mark>text</mark>` |
| `^[inline footnote]` | A numbered footnote at the end of the note |
| `text ^block-id` | `text <a id="block-id"></a>` |
| `> [!success] Title` | The closest of GitHub's five alert types, with the title in bold |

Comments become HTML comments, and embedded notes and PDFs become plain embed links: GitHub can't show them, but Obsidian and the PDF still do. Code, maths, Mermaid, front matter, `README.md` and the `templates/` folder are left alone. Links to notes that don't exist yet stay as wikilinks, so Obsidian can still create them.

Some things only work one way afterwards. Obsidian opens heading links at the top of the note rather than at the heading, and callout types other than GitHub's five are replaced by the closest one.
