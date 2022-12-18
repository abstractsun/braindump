# braindump

**braindump** is a collection of notetaking scripts run from the command line.

I created these scripts because I was tired of using email/instant messaging for notes. I needed a better system, that would help me get stuff out of my head as quickly as possible, but still stay somewhat organized.

If you were looking for the next groundbreaking productivity/collaboration suite, this definitely ain't it! But I hope someone will find the ideas behind it interesting.

## Highlights

- Has various commands for opening files to write in
- When opening a file, jumps to the important line
- Has various commands for parsing files for later review

## Ingredients

To run most braindump scripts, you'll need bash, GNU find, and some other standard utilities available on your `$PATH`.

The default text editor is nano, but vim provides the best experience. By default, all files are suffixed with `.txt`. To change these defaults, export the environment variables `$EDITOR` and `$BRAINDUMP_FILE_SUFFIX`.

## The commands

All commands assume you stay in the same folder.

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
- `./remind` - Periodically checks for lines containing `[remind DATETIME]` in tasks, notes, ideas, and logs; and shows messages when reminders expire
    - `./remind me` and `./remind parse` allow for creating reminders interactively or inside your text editor
- `./log LOGNAME` - Opens the named log, appends a timestamp, and (if using vim) enters insert mode after the timestamp
- `./pin` - Displays lines in notes/ideas/tasks containing `[PIN]`
- `./tag TAGNAME` - Displays lines in notes/ideas containing `{TAGNAME}`, as well as the immediately preceding lines
- `./scratch` - Edits a hidden scratch file
- `./queue "QUEUE_MSG"` - Edits/appends to a hidden queue file
    - Variant: `./queue`
- `./qr "QR_MSG"` - A wrapper for [qrencode](https://fukuchi.org/works/qrencode/index.html.en) that displays a qr image which encodes the provided `QR_MSG`
    - Variant: `./qr` - Reads from stdin

## Reminders

To use the `./remind` script, you'll need GNU date, GNU find, bash, and some other standard utilities available on your `$PATH`.

All commands assume you stay in the same folder.

- `./remind` - Periodically checks for lines containing `[remind DATETIME]` in tasks, notes, ideas, and logs; and shows messages when reminders expire
- `./remind me` - Adds a reminder
    - Variants: `./remind me "REMINDER"`, `./remind me "REMINDER" "REMIND_TIME"`
- `./remind parse` - Parses a line containing a reminder from stdin to stdout, for use in your text editor
    - Variant: `./remind parse "REMIND_TEXT [remind DATETIME] ..."

Remind times can be in plain English or in machine format, relative or absolute. The script tries to select future dates when possible.

To remove expired reminders, remove the expired `[remind DATETIME]` from the reminder file, or alternatively clobber the reminder, for example, `[.remind DATETIME]`

If you are using vim, you can create reminders inside files as you type using `./remind parse`:

```plaintext
Did the thing finally happen? [remind 6 months 8pm]
Do absolutely nothing for 5 minutes [remind tomorrow 12pm] [remind 2 days 12pm]
```

Select one or more lines containing new reminders and type `:!./remind parse`. Please note that `./remind` does not handle periodic reminders. All reminders must be converted to an absolute format in order to work correctly.

### Reminder script

By default, `./remind` prints reminders to the terminal and echoes a visual bell. On some systems, it will also display a notification.

You can override this behavior by creating a script file called `.doremind`, which will be called by `./remind`. The `.doremind` script will be given one or two arguments as input. For a single reminder, `$1` is a single elapsed reminder to be notified, and `$2` is undefined. For bulk reminders, `$1` is the recommended notification toast message, and `$2` is the newline-separated list of all elapsed reminders.

## Tasks and logs continued

Files in the `tasks/archived` and `logs/archived` subdirectories are ignored by `./task` and `./log`, allowing the creation of new task/log files with the same names

When opening a task file in vim, `:loadview` is invoked to load the existing vim view if it exists. This is useful when the view contains folded lines. Alternatively, you can use modelines.

## Other tricks

### Parallel notes

You can make your note and idea files have different names in different situations by creating an executable called `.getdesc` which returns a descriptive name.

For example, if you are creating notes at home, your `.getdesc` file could look like this:

```bash
#!/bin/bash
echo "home"
```

Then, `./note` would create notes that look like: "notes/note_home_YYYY-MM-DD.txt"

### Command composition

- Adding "?" to the end of some commands which would otherwise open a file will instead print the name of the file.
- This works for `./note`, `./idea`, `./todo`, `./task TASKNAME`, `./log LOGNAME`, `./queue`, and `./scratch`
- This can be used in vim to open another braindump file in a separate buffer without using termcap, for example:
    ```vim
    :split `./note ?`
    ```

## Quick note

In a bash command line (and some others), you can quickly jump to/from the braindump folder by setting an alias:

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

## License

[GPL version 3](https://www.gnu.org/licenses/gpl-3.0.html), or, at your option, any later version

## See also

I don't use braindump for everything. Here are a few other tools I've found useful in various personal notetaking situations:

- [Fossil](https://fossil-scm.org/) - It's a code forge, issue tracker, wiki, forum, and more, in a single sub-10 megabyte executable. Trivial to back up and sync. Customizable if you know a bit of HTML/SQL.
- [Krita](https://krita.org/) - Drawing/painting program. Especially satisfying with a drawing tablet/touch interface.
- [Markdeep](https://casual-effects.com/markdeep/) - Turn a markdown file into a webpage by just downloading a script and adding a js include to it at the bottom of your file. Lots of bells and whistles.
- To be honest, I still use email or instant messaging on occasion, or a graphical text editor. It's more convenient in certain situations.

A grad student I used to work with once said to me, "Keep a Gedankenlog." I still think about that.

Another adage: In the absence of other factors, if you have a choice between storing data in a flat data structure vs a hierarchical one, it is better to go with the flat data structure. Why? Because you can't anticipate how the data will be used.
