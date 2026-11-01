Everything runs through one script, `toolbox.sh`. Run `./toolbox.sh` on its own to get a numbered menu, or add a command (`build`, `watch`, `setup`, `format` or `localize`) to run it straight away.

# Opening a Terminal

Every command in this manual is run from a terminal opened **inside the vault folder**.

- **Windows:** open the vault folder in File Explorer, right-click an empty area and choose **Open Git Bash here**. On Windows 11, you may need to click **Show more options** first.
- **macOS:** right-click the folder in Finder and choose **New Terminal at Folder**. If that option is missing, open Terminal, type `cd ` (with a space), drag the folder into the window and press Enter.
- **Linux:** right-click in the folder and choose **Open in Terminal**.

<!--raw-typst #pagebreak()-->

# Building Once

```bash
./toolbox.sh build
```

This creates or updates `main.pdf` in the vault folder. The **first** build needs an internet connection, because Typst downloads the packages it uses. The build also downloads web images and renders Mermaid diagrams (see [@web-images-and-mermaid-diagrams]). After that, it works offline.

# Live Preview

```bash
./toolbox.sh watch
```

This rebuilds `main.pdf` every time you save a file. Open `main.pdf` in a PDF viewer that reloads automatically, such as the one in VS Code, SumatraPDF on Windows, Skim on macOS or most Linux viewers. Press `Ctrl + C` in the terminal to stop.

> [!important] Always build with the toolbox
> Running `typst compile` yourself skips the bundled fonts in `.fonts/`, web images and Mermaid diagrams. Both commands build `main.typ` by default. To build a different file, add its name: `./toolbox.sh build other.typ`.
