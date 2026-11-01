The template comes with ready-made Obsidian settings in the `.obsidian.default` folder. Together with two plugins, they make links, attachments and citations work the way the PDF build expects. The plugins aren't stored in the template: the setup script downloads them from their official GitHub releases.

# With the Setup Script

1. **Close Obsidian.**
2. Open a terminal in the vault folder (see [@opening-a-terminal]).
3. Run:

   ```bash
   ./toolbox.sh setup
   ```

4. Answer each question by typing `y` or `n` and pressing Enter:
   - **Remove the git-ignored files above?** This is only asked if the vault already has settings. It deletes the `.obsidian/` folder (settings and installed plugins) and the old `main.pdf`. Type `y` on a fresh copy of the template. Type `n` to keep your own Obsidian customisations: the recommended settings are copied over them either way, and plugins you already have stay enabled.
   - **Also install the extras?** The two required plugins are always installed. Type `y` to also get the Minimal theme and some handy plugins, or `n` to keep Obsidian plain.
5. Open Obsidian again. If it asks whether you trust the plugins, click **Trust author and enable plugins**.

The script needs an internet connection to download the plugins.

# By Hand

1. Copy the `.json` files **inside** `.obsidian.default` into the vault's `.obsidian` folder. Create the folder if it doesn't exist, and overwrite files if asked.
2. In Obsidian, open **Settings → Community plugins**, turn off Restricted mode, and use **Browse** to install **Better Markdown Links** and **Citations**.
3. Copy each plugin's `data.json` from `.obsidian.default/plugins/<plugin>/` into `.obsidian/plugins/<plugin>/`, then restart Obsidian. You can also set the plugin options by hand from the tables below.

> [!note] Can't see these folders?
> Folder names starting with a dot are hidden. In Windows File Explorer, click **View → Show → Hidden items**. In macOS Finder, press `Cmd + Shift + .`

# What the Settings Do

You only need this section if you set Obsidian up yourself instead of copying `.obsidian.default`.

The two required community plugins are [Better Markdown Links](https://obsidian.md/plugins?id=better-markdown-links), which writes links with paths the PDF build understands, and [Citations](https://obsidian.md/plugins?id=obsidian-citation-plugin), which inserts citations from `citations/references.bib`.

The optional extras are the [Minimal](https://github.com/kepano/obsidian-minimal) theme, Minimal Theme Settings, Style Settings, Linter, Advanced Tables, Multi Properties, Note Auto Creator, Omnisearch, Text Extractor, Emoji Autocomplete and Vim Toggle. With the extras, PDFs opened inside Obsidian look exactly as they print, because Minimal's PDF inverting and blending are turned off. The PDF file itself is never affected.

Plugin versions are pinned in the lists at the top of `toolbox.sh`, so everyone gets versions that work with these settings. To upgrade a plugin, change its version number there and run setup again.

| Setting | Value |
| --- | --- |
| **Files and links** | |
| Default location for new notes | Same folder as current file |
| Default location for new attachments | In subfolder under current folder |
| Subfolder name | `attachments` |
| New link format | Absolute path in vault |
| Automatically update internal links | On |
| Use `[[Wikilinks]]` | Off (markdown links also work on GitHub) |
| Detect all file extensions | On |
| **Editor** | |
| Strict line breaks | On (a new paragraph needs an empty line, as in the PDF) |
| **Core plugins → Templates** | |
| Template folder location | `templates` |
| **Citations** | |
| Citation database format | BibLaTeX |
| Citation database path | `citations/references.bib` |
| Markdown citation template | `[@{{citekey}}]` |

For **Better Markdown Links**, turn on: use leading dot for relative paths, use leading slash for absolute paths, use angle brackets, normalize file links, automatically update links on rename or move, and allow empty embed alias. Turn off: include attachment extension to embed alias, and preserve existing link style. Set **Convert links** to *On save command* and leave the include and exclude paths as they are.
