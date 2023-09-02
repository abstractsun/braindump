# braindump

**braindump** is a collection of notetaking scripts run from the command line.

I created these scripts because I was tired of using email/instant messaging for notes. I needed a better system, that would help me get stuff out of my head as quickly as possible, but still stay somewhat organized.

If you were looking for the next groundbreaking productivity/collaboration suite, this definitely ain't it! But I hope someone will find the ideas behind it interesting.

## Highlights

- Has various commands for opening files to write in
- When opening a file, jumps to the important line
- `./triage` semi-automates the note/idea review process

## Ingredients

To run most braindump scripts, you'll need bash, GNU find, and some other standard utilities available on your `$PATH`.

The default text editor is nano, but vim provides the best experience. By default, all files are suffixed with `.txt`. To change these defaults, export the environment variables `$EDITOR` and `$BRAINDUMP_FILE_SUFFIX`.

## The commands

All commands assume you stay in the same folder. A typical folder looks like this:

```
$ ls
idea  ideas  log  logs  note  notes  pin  qr  queue  remind  scratch  tag  task  tasks  todo  triage
```

- **Reviewable files:** `./todo`, `./note`, and `./idea` are used to write things down quickly for later, semi-automatic review
- **Special files:** `./task TASKNAME`, `./log LOGNAME`, `./queue`, and `./scratch` are used to write things down that are reviewed manually
- **Triage, review, and reminders:** `./triage`, `./remind`, `./pin`, and `./tag TAGNAME` can be used to review and search through files in different ways
- **Utility commands:** `./remind parse`, `./qr`, and `?` (command suffix) allow for integrating the commands with the shell or your text editor, or you can just use `?` to query the location of a file.
- **Advanced commands:** Various commands in `./.scripts`, hidden for various reasons. See the "Advanced commands" section.

## Reviewable files

`./todo` edits the TODO file.

`./note` and `./idea` edit a note or idea for the current day.

Alternatively, use `./todo TODO_MSG`, `./note "NOTE_MSG"`, or `./idea "IDEA_MSG"` to append a line to the respective file.

## Special files

`./task TASKNAME` opens the named task. You can write `[START]` in a task file to mark where you left off - `./task TASNAME` will then jump to that line next time. `./task` opens the task folder if possible.

When using `./task TASKNAME` with vim, `:loadview` is invoked to load the existing vim view if it exists. This is useful when the view contains folded lines. Alternatively, you can use modelines to define fold behavior. Folds will be unfolded when vim jumps to `[START]`.

`./log LOGNAME` opens the named log, appends a timestamp, and (if using vim) enters insert mode after the timestamp.

Files in `tasks/archived` and `logs/archived` are ignored by `./task` and `./log`, allowing the creation of new tasks/logs with the same names.

`./queue` and `./scratch` each edit a hidden file. Alternatively, use `./queue "QUEUE_MSG" to append to the queue file.

## Triage and review

`./triage` reviews the TODO file, as well as any files in `notes/` and `ideas/` which are not fully reviewed. You can write `[TRIAGE]` in a file in `notes/` or `ideas/` to mark where you left off. In those same folders, files with `[TRIAGE]` as the last line are ignored. They are considered fully reviewed.

`./tag TAGNAME` displays lines in notes/ideas containing `{TAGNAME}`, as well as the immediately preceding lines.

`./pin` Displays lines in notes/ideas/tasks containing `[PIN]`.

## Reminders

To use the `./remind` script, you'll need GNU date, GNU find, bash, and some other standard utilities available on your `$PATH`.

All commands assume you stay in the same folder.

- `./remind` - Periodically checks for lines containing `[remind DATETIME]` in tasks, notes, ideas, and logs; and shows messages when reminders expire. On some systems, it will also echo a terminal bell and display a notification.
- `./remind me` - Adds a reminder interactively
    - Variants: `./remind me "REMINDER"`, `./remind me "REMINDER" "REMIND_TIME"`
- `./remind parse` - Parses a line containing a reminder from stdin to stdout, for use in your text editor
    - Variant: `./remind parse "REMIND_TEXT [remind DATETIME] ..."`

Remind times can be in plain English or in machine format, relative or absolute. The script tries to select future dates when possible.

To remove expired reminders, remove the expired `[remind DATETIME]` from the file, or alternatively clobber the reminder, for example, `[.remind DATETIME]`. Reminders in `tasks/archived` and `logs/archived` are still valid reminders.

If you are using vim, you can create reminders inside files as you type using `./remind parse`:

```plaintext
Did the thing finally happen? [remind 6 months 8pm]
Do absolutely nothing for 5 minutes [remind tomorrow 12pm] [remind 2 days 12pm]
```

Select one or more lines containing new reminders and type `:!./remind parse`. Please note that `./remind` does not handle periodic reminders. All reminders must be converted to an absolute format in order to work correctly.

Reminders can be postponed in-place by appending "10 minutes", "1 hour", "1 day" or similar to the end of the reminder datetime. Alternatively, the [vim-speeddating](https://github.com/tpope/vim-speeddating) plugin lets you increment/decrement absolute reminder times in-place with `Ctrl-a` and `Ctrl-x`.

## Utility commands continued

### QR codes

`./qr` reads the text to be qr-encoded from stdin. It requires [qrencode](https://fukuchi.org/works/qrencode/index.html.en) to be on your `$PATH`.

In vim, select lines of text to be qr-ified and type `:!./qr`.

Alternatively, `./qr "QR_MSG"` will encode the provided `QR_MSG` on the command line.

Some characters do not work well in QR codes, for those, encode the message with base64 first.

### File query

`?`, when added to the end of some commands which would otherwise open a file, will cause the command to instead print the name of the file.

This works for `./note`, `./idea`, `./todo`, `./task TASKNAME`, `./log LOGNAME`, `./queue`, and `./scratch`

This can be used in vim to open a file in a separate buffer without using termcap, for example:

```vim
:split `./note ?`
```

## Advanced commands

Advanced commands are in the `./.scripts` folder. Some are for internal purposes. These ones can be invoked as standalone commands:

- `./.scripts/dateify [FILE_OR_FOLDER] ...` - Given one or more files or folders, interactively asks to add dates to file names.
- ` ./.scripts/sync_git`  - Opinionated git syncing script, invoked manually. See the source file for documentation.

## Customization

### Environment variables

`$EDITOR`, `$VISUAL`, or `$BRAINDUMP_EDITOR` may be used to set the default text editor. `nano` is the default. `vim` provides the best experience.

`$BRAINDUMP_FILE_SUFFIX` changes the suffix used for all files. `.txt` is the default.

### Quick note alias

In a bash command line (and some others), you can quickly jump to/from the braindump folder by setting an alias:

```bash
# Set this in your init file (`~/.bashrc`, `~/.bash_profile`, etc)
alias bd='pushd /path/to/my_braindump'
# Jump to notes folder
bd
# Write some notes...
./todo
# Return to previous folder
popd
```

### Syncing

Regardless of how you sync your files, it is strongly encouraged to exclude the `.braindump/` folder from syncing. Otherwise, some commands may stop working correctly.

`./sync` is an, "unreserved word." Use it for your syncing script of choice if you wish. (Alternatively, see the "Advanced commands" section)

### Parallel notes

You can make your note and idea files have different names in different situations by creating an executable called `.getdesc` which returns a descriptive name.

For example, if you are creating notes at home, your `.getdesc` file could look like this:

```bash
#!/usr/bin/env bash
echo "home"
```

Then, `./note` would create notes that look like: "notes/note_home_YYYY-MM-DD.txt"

### Reminder script

By default, `./remind` prints reminders to the terminal and echoes a terminal bell. On some systems, it will also display a notification.

You can override this behavior by creating a script file called `.doremind`, which will be called by `./remind`. The `.doremind` script will be given one or two arguments as input. For a single reminder, `$1` is a single elapsed reminder to be notified, and `$2` is undefined. For bulk reminders, `$1` is the recommended notification toast message, and `$2` is the newline-separated list of all elapsed reminders.

## License

With a few exceptions, braindump is licensed under [GPL version 3](https://www.gnu.org/licenses/gpl-3.0.html), or, at your option, any later version.

The following files are under different licenses. See their respective source files:

- `./.scripts/sync_git`

## See also

I don't use braindump for everything. Here are a few other tools I've found useful in various personal notetaking situations:

- [Fossil](https://fossil-scm.org/) - It's a code forge, issue tracker, wiki, forum, and more, in a single sub-10 megabyte executable. Trivial to back up and sync. Customizable if you know a bit of HTML/SQL.
- [Krita](https://krita.org/) - Drawing/painting program. Especially satisfying with a drawing tablet/touch interface.
- [Markdeep](https://casual-effects.com/markdeep/) - Turn a markdown file into a webpage by just downloading a script and adding a js include to it at the bottom of your file. Lots of bells and whistles.
- To be honest, I still use email or instant messaging on occasion, or a graphical text editor. It's more convenient in certain situations.

## Adages

A grad student I used to work with once said to me, "Keep a Gedankenlog." I still think about that.

Another adage: In the absence of other factors, if you have a choice between storing data in a flat data structure vs a hierarchical one, it is better to go with the flat data structure. Why? Because you can't anticipate how the data will be used.
