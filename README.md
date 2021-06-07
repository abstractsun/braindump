# braindump

**braindump** is a collection of notetaking scripts for unix/[vim](https://www.vim.org/).

I created these scripts because I was tired of using email/instant messaging for notes. I needed a better system, that would help me get stuff out of my head as quickly as possible, but still stay somewhat organized.

If you were looking for the next groundbreaking productivity/collaboration suite, this definitely ain't it! But I hope someone will find the ideas behind it interesting.

## Highlights

- Has various commands for opening files to write in
- When opening a file, jumps to the important line
- `./triage` semi-automates the note/idea review process

## The commands

All commands currently assume you stay in the same folder.

- `./note` - Edits/appends a note for the current day
    - Variant: `./note "NOTE_MSG"`
- `./idea` - Edits/appends an idea for the current day
    - Variant: `./idea "IDEA_MSG"`
- `./todo` - Edits/prepends a todo
    - Variant: `./todo "TODO_MSG"`
- `./triage` - Assists in reviewing notes, ideas, and the todo file
    - First, the todo file is opened
    - Then, files in the notes/ideas folders needing review are opened
        - If a line contains `[TRIAGE]`, jump to that line
        - Files with `[TRIAGE]` as the last line are ignored. They are considered fully reviewed.
- `./task TASKNAME` - Opens the named task
    - If a line contains `[START]`, jump to that line
    - `:loadview` is invoked to load the existing vim view if it exists. This is useful when the view contains folded lines.
    - Files in the `tasks/archived` subdirectory are ignored, allowing the creation of a new task file with the same name
    - Variant: `./task` - Opens the tasks folder
- `./log LOGNAME` - Opens the named log, appends a timestamp, and enters insert mode after the timestamp
    - Files in the `logs/archived` subdirectory are ignored, allowing the creation of a new log file with the same name
- `./pin` - Displays lines in notes/ideas/tasks containing `[PIN]`
- `./tag TAGNAME` - Displays lines in notes/ideas containing `{TAGNAME}`, as well as the immediately preceding lines
- `./scratch` - Edits a hidden scratch file
- `./queue "QUEUE_MSG"` - Edits/appends to a hidden queue file
    - Variant: `./queue`
- `./qr "QR_MSG"` - A wrapper for [qrencode](https://fukuchi.org/works/qrencode/index.html.en) that displays a qr image which encodes the provided `QR_MSG`
    - Variant: `./qr` - Reads from stdin

## License

[GPL version 3](https://www.gnu.org/licenses/gpl-3.0.html), or, at your option, any later version

## See also

I don't use braindump for everything. Here are a few other tools I've found useful in various personal notetaking situations:

- [Fossil](https://fossil-scm.org/) - It's a code forge, issue tracker, wiki, forum, and more, in a single sub-10 megabyte executable. Trivial to back up and sync. Customizable if you know a bit of HTML/SQL.
- [Krita](https://krita.org/) - Drawing/painting program. Especially satisfying with a drawing tablet/touch interface.
- [Markdeep](https://casual-effects.com/markdeep/) - Turn a markdown file into a webpage by just downloading a script and adding a js include to it at the bottom of your file. Lots of bells and whistles.
- To be honest, I still use instant messaging on occasion, or a graphical text editor. It's more convenient in certain situations.

A grad student I used to work with once said to me, "Keep a Gedankenlog." I still think about that.

Another adage: In the absence of other factors, if you have a choice between storing data in a flat data structure vs a hierarchical one, it is better to go with the flat data structure. Why? Because you can't anticipate how the data will be used.
