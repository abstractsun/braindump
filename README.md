# braindump

**braindump** is a collection of notetaking scripts run from the command line.

I created these scripts because I was tired of using email/instant messaging for notes. I needed a better system, that would help me get stuff out of my head as quickly as possible, but still stay somewhat organized.

If you were looking for the next groundbreaking productivity/collaboration suite, this definitely ain't it! But I hope someone will find the ideas behind it interesting.

## Highlights

- Has various commands for opening files to write in
- When opening a file, jumps to the important line
- `./triage` semi-automates the note/idea review process

## Ingredients

Currently, to run most braindump scripts, you'll need bash, GNU find, and some other standard utilities available on your `$PATH`.

Braindump uses nano by default for text editing. See the "Other tricks" section for how to select the text editor.

## The commands

All commands currently assume you stay in the same folder.

- `./note` - Edits/appends a note for the current day
    - Variant: `./note "NOTE_MSG"`
- `./idea` - Edits/appends an idea for the current day
    - Variant: `./idea "IDEA_MSG"`
- `./todo` - Edits/prepends a todo
    - Variant: `./todo "TODO_MSG"`
- `./triage` - Assists in reviewing the todo file, notes, and ideas
    - You can write `[TRIAGE]` in a note/idea file to mark where you left off
    - Note/idea files with `[TRIAGE]` as the last line are ignored. They are considered fully reviewed.
- `./task TASKNAME` - Opens the named task
    - You can write `[START]` in a task file to mark where you left off
    - Variant: `./task` - Opens the tasks folder (if possible)
- `./log LOGNAME` - Opens the named log, appends a timestamp, and (if using vim) enters insert mode after the timestamp
- `./pin` - Displays lines in notes/ideas/tasks containing `[PIN]`
- `./tag TAGNAME` - Displays lines in notes/ideas containing `{TAGNAME}`, as well as the immediately preceding lines
- `./scratch` - Edits a hidden scratch file
- `./queue "QUEUE_MSG"` - Edits/appends to a hidden queue file
    - Variant: `./queue`
- `./qr "QR_MSG"` - A wrapper for [qrencode](https://fukuchi.org/works/qrencode/index.html.en) that displays a qr image which encodes the provided `QR_MSG`
    - Variant: `./qr` - Reads from stdin

## Other tricks

- To select the text editor that braindump uses, export an environment variable (`$BRAINDUMP_EDITOR`, `$VISUAL`, or `$EDITOR`)
    - `$BRAINDUMP_EDITOR` gets highest priority and can safely accept command line parameters
    - The default text editor is nano, which is is simple and easy to use
    - vim provides the best experience
    - You may also prefer to change the file type by setting `$BRAINDUMP_FILE_SUFFIX`. Its default value is `.txt`
- Files in the `tasks/archived` and `logs/archived` subdirectories are ignored, allowing the creation of new task/log files with the same names
- When opening a task file in vim, `:loadview` is invoked to load the existing vim view if it exists. This is useful when the view contains folded lines
- In a bash command line (and some others), you can quickly jump to/from the braindump folder by setting an alias:
    ```bash
    # Set this in your init file (`~/.bashrc`, `~/.bash_profile`, etc)
    alias bd='pushd /path/to/my_braindump'
    # Jump to notes folder
    bd
    # Write some notes...
    ./todo "Follow up on thing"
    # Return to previous folder
    popd
    ```
- Adding "?" to the end of some commands which would otherwise open a file will instead print the name of the file
    - This works for `./note`, `./idea`, `./todo`, `./task [TASKNAME]`, `./log [LOGNAME]`, `./queue`, and `./scratch`
    - This can be used in vim to open another braindump file in a separate buffer without using termcap, for example:
        ```vim
        :split `./note ?`
        ```
- You can make your note and idea files have different names in different situations by creating an executable called `.getdesc` which returns a descriptive name.
    - For example, if you are creating notes at home, your `.getdesc` file could look like this:
        ```bash
        #!/bin/bash
        echo "home"
        ```
      Then, `./note` would create notes that look like: "notes/note_home_YYYY-MM-DD.txt"

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
