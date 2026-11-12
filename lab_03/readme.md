# Lab 03: Linux Terminal — Navigation, File Operations, Pipes & Terminal Editors

## Learning outcomes

After this lab you will be able to:

- navigate the Linux filesystem using relative and absolute paths (`pwd`, `ls`, `cd`),
- inspect file contents and system manuals from the terminal (`cat`, `head`, `tail`, `less`, `man`, `--help`),
- organize files and directories using wildcards (`*`, `?`) and search tools (`mkdir`, `cp`, `mv`, `rm`, `find`),
- combine commands using redirections (`>`, `>>`) and pipes (`|`) with text-processing filters (`grep`, `wc`, `cut`, `sort`, `uniq`),
- edit configuration files and reports directly in the terminal using `nano` and `vim`.

## Before you start (Environment setup)

In this lab you will work in a real **Linux (Bash)** environment. Our primary tool is **GitHub Codespaces**, which runs an Ubuntu Linux container directly in your browser. You can also work locally on a **Lubuntu virtual machine** (or native Linux / WSL2).

### Option A (Primary): GitHub Codespaces in your browser

1. Sign in to [github.com](https://github.com) and click **New repository**.
2. Name the repository `dev-tools-lab03`, check **Add a README file**, and click **Create repository**.
3. On your new repository page, click the green **`<> Code`** button, switch to the **Codespaces** tab, and click **Create codespace on main**.
4. Wait ~15 seconds for the browser environment to start. You now have a full Ubuntu Linux machine with a Bash terminal at the bottom of the screen.
5. **Focus on the terminal:** press `` Ctrl+` `` (or click the **Terminal** tab) and drag the top border of the terminal panel up so you have a large terminal view. Do **not** use the graphical file explorer on the left to move or edit files—complete all tasks using terminal commands!

> **Important:** GitHub gives every account 60 free hours of Codespaces per month (180 hours with the GitHub Student Developer Pack). When you finish the class, go to [github.com/codespaces](https://github.com/codespaces), click the three dots `...` next to your codespace, and choose **Stop codespace**.

### Option B (Local alternative): Lubuntu VM / Native Linux

1. Open the terminal emulator in Lubuntu (`Ctrl+Alt+T`).
2. Create a repository `dev-tools-lab03` on GitHub (with a README) and clone it:
   ```bash
   cd ~
   git clone https://github.com/<your-username>/dev-tools-lab03.git
   cd dev-tools-lab03
   ```

## Time plan

| Time | Part |
| --- | --- |
| 10 min | 0. Environment launch & project setup |
| 15 min | 1. Navigating the filesystem & inspecting files |
| 20 min | 2. Organizing files, directories, wildcards & `find` |
| 20 min | 3. Redirections and pipes (`>`, `>>`, `\|`) — log investigation |
| 15 min | 4. Terminal text editors (`nano` and `vim`) |
| 10 min | 5. Self-verification, commit and submission |

---

## 0. Preparing the messy project

Throughout this lab you have a practical mission: you just inherited an unorganized backend project (`legacy-service`) left behind by another developer. Source code, documentation, configuration files, server logs, and temporary junk files are all mixed together.

Make sure you are in the root directory of your `dev-tools-lab03` repository. Check your environment first:

```bash
whoami        # print your current Linux username
hostname      # print the name of the machine/container
uname -a      # print Linux kernel and system information
pwd           # print working directory (where you are right now)
```

Download (or copy from the course repository) the two helper scripts `setup_lab03.sh` and `verify_lab03.sh` into your `dev-tools-lab03` directory, then run the setup script:

```bash
curl -sO https://raw.githubusercontent.com/kropiak/swps-developer-tools/main/lab_03/setup_lab03.sh
curl -sO https://raw.githubusercontent.com/kropiak/swps-developer-tools/main/lab_03/verify_lab03.sh
bash setup_lab03.sh
```

*(If the repository URL differs, copy `setup_lab03.sh` and `verify_lab03.sh` provided by the instructor into your repository folder and run `bash setup_lab03.sh`.)*

The script created a `./workspace` directory containing the messy project.

---

## 1. Navigating the filesystem & inspecting files

In Linux, all files and folders form a single tree starting at the root directory `/`.

| Symbol | Meaning |
| --- | --- |
| `/` | Root of the entire filesystem |
| `~` | Your home directory (e.g., `/home/codespace` or `/home/student`) |
| `.` | Current directory |
| `..` | Parent directory (one level up) |
| `-` | Previous directory you visited (`cd -`) |

### Essential navigation and inspection commands

```bash
# 1. Where am I and what is here?
pwd
ls              # list visible files
ls -l           # long format (permissions, owner, size, modification date)
ls -a           # show ALL files, including hidden ones (names starting with a dot '.')
ls -lah         # combine flags: long format + all files + human-readable sizes (K, M, G)

# 2. Moving between directories
cd workspace    # go into the 'workspace' subfolder
cd ..           # go one level up (back to the parent folder)
cd -            # jump back to the previous directory

# 3. Reading files without opening an editor
cat app.conf            # print the entire file to the screen
head -n 5 app.log       # print only the FIRST 5 lines of a file
tail -n 5 app.log       # print only the LAST 5 lines of a file
less app.log            # scrollable viewer (use Up/Down arrows, '/word' to search, 'q' to quit)

# 4. Getting help for any command
ls --help               # quick summary of options
man ls                  # full manual page (press 'q' to quit)
```

> **Tip — Tab completion & History:** Never type long filenames by hand! Type the first 2–3 letters and press **`Tab`**—the shell will autocomplete the name. Press the **`Up` / `Down` arrows** to cycle through commands you ran earlier.

### Practical Exercise 1: Auditing the messy workspace

Your first task as the new maintainer is to inspect `./workspace` and find out what was left behind:

1. Navigate into the `workspace` directory (`cd workspace`) and verify your location with `pwd`.
2. List all files—including **hidden files**—with human-readable sizes (`ls -lah`). Notice two hidden files starting with a dot (`.`).
3. Display the contents of the hidden file `.secret_note` using `cat`. Write down or remember the `SECRET_TOKEN` inside—you will need it in Part 4!
4. Inspect the first 3 lines and the last 3 lines of `app.log` using `head` and `tail`. Look at the timestamps: when did the first `WARN` appear, and what happened around `08:14`?

---

## 2. Organizing files, directories, wildcards & `find`

Now that you know what is inside `workspace`, it is time to clean up the directory structure.

### File and directory manipulation commands

```bash
# Creating directories and empty files
mkdir reports                   # create a single directory
mkdir -p a/b/c                  # create nested directories (or multiple directories at once)
touch notes.txt                 # create an empty file (or update its timestamp)

# Copying, moving, and renaming
cp app.conf app.conf.bak        # copy a file
cp -r docs docs_backup          # copy a directory recursively (-r)
mv old_name.txt new_name.txt    # rename a file
mv notes.txt reports/           # move a file into a directory

# Removing files and directories (CAREFUL: there is no Recycle Bin in the terminal!)
rm notes.txt                    # delete a file
rm -i *.tmp                     # delete with interactive confirmation (-i)
rmdir empty_folder              # delete an empty directory
rm -r folder_with_files         # delete a directory and everything inside it
```

### Wildcards (globbing) and `find`

Instead of moving 20 files one by one, the shell lets you match filenames with patterns (**wildcards**):

- `*` matches **any number of characters** (e.g., `*.py` matches all Python files; `crash_*` matches anything starting with `crash_`).
- `?` matches **exactly one character** (e.g., `crash_0?.tmp` matches `crash_01.tmp` and `crash_02.tmp`).

When files are buried inside subdirectories, wildcards in the current folder are not enough. Use `find` to search an entire directory tree:

```bash
# Find all files ending with .tmp anywhere inside the current directory (.) and its subfolders
find . -name "*.tmp"

# Find and delete all .tmp files in one step
find . -name "*.tmp" -delete
```

### Practical Exercise 2: Refactoring the project structure

Make sure you are inside the `workspace` directory (`pwd` should end with `/workspace`). Perform the following cleanup using terminal commands:

1. **Create a clean folder structure** in one command:
   ```bash
   mkdir -p src docs config logs reports
   ```
2. **Move files by type using wildcards (`*`):**
   - Move all Python files (`*.py`) into `src/`.
   - Move all Markdown documentation files (`*.md`) into `docs/`.
   - Move all configuration files (`*.conf`) **and** the hidden file `.env.example` into `config/`.
   - Move all log files (`*.log`) into `logs/`.
3. **Verify that the code still works** in its new location by running:
   ```bash
   python3 src/main.py
   ```
4. **Hunt down and remove all junk files:**
   - Use `find . -name "*.tmp"` and `find . -name "*.bak"` to see all temporary and backup files scattered across `workspace/` and its subdirectories (`old_stuff/`, `cache_dir/`).
   - Delete all `*.tmp` and `*.bak` files (using `rm` or `find ... -delete`).
   - Remove the now-empty directories `old_stuff` and `cache_dir` (`rmdir old_stuff cache_dir`).
5. **Check your clean workspace** with `ls -la`. Only `.secret_note` and the five folders (`config`, `docs`, `logs`, `reports`, `src`) should remain in `workspace/`.
6. **Commit your progress to Git:**
   ```bash
   git status
   git add -A
   git commit -m "Organize workspace directory structure and remove temp files"
   ```

---

## 3. Redirections and pipes (`>`, `>>`, `|`)

One of the greatest strengths of Unix/Linux is the philosophy: *Write programs that do one thing and do it well. Write programs to work together.*

### Redirections (`>` and `>>`)

By default, commands print their output (`stdout`) to the terminal screen. You can redirect that output to a file:

- `command > file.txt` — **overwrites** `file.txt` with the output of `command` (creates the file if it does not exist).
- `command >> file.txt` — **appends** the output to the end of `file.txt` without erasing existing content.

```bash
echo "=== Daily Summary ===" > summary.txt      # creates/overwrites summary.txt
date >> summary.txt                             # appends current date to summary.txt
```

### Pipes (`|`) and text filters

The pipe operator `|` takes the output of the command on the left and feeds it directly as the input to the command on the right:

```
command_1  |  command_2  |  command_3  >  result.txt
```

Here are the most useful filter commands to combine with pipes:

| Command | Purpose | Example |
| --- | --- | --- |
| `grep "pattern" file` | Filter lines matching a text pattern (`-i` ignore case, `-c` count matches, `-n` show line numbers) | `grep "WARN" logs/app.log` |
| `wc -l` | Count lines (`wc` counts lines, words, and bytes) | `grep "INFO" logs/app.log \| wc -l` |
| `cut -d' ' -f1` | Extract specific columns (`-d` delimiter, `-f` field number) | `cut -d' ' -f1 logs/access.log` |
| `sort` | Sort lines alphabetically (`-n` numerically, `-r` reverse/descending) | `sort logs/access.log` |
| `uniq -c` | Collapse adjacent duplicate lines and count occurrences (`-c`) — **always run `sort` before `uniq`!** | `sort names.txt \| uniq -c` |

**Example pipeline:** Let's see how to extract the first column (IP addresses) from `logs/access.log`, count how many requests each IP made, and sort them from highest to lowest:

```bash
cut -d' ' -f1 logs/access.log | sort | uniq -c | sort -nr
```

Try running that pipeline step by step in your terminal (first just `cut -d' ' -f1 logs/access.log`, then add `| sort`, then add `| uniq -c`, and finally `| sort -nr`) to see how each stage transforms the data!

### Practical Exercise 3: Investigating the server incident

Something went wrong in production around `08:05–08:14`. Working inside `workspace/`, generate two files inside `reports/` using **only redirections and pipes** (do not type the answers by hand!):

1. **Extract all errors to a separate log file:**
   Filter all lines containing `ERROR` from `logs/app.log` and redirect them to `reports/errors_only.log`:
   ```bash
   grep "ERROR" logs/app.log > reports/errors_only.log
   ```
   Check with `wc -l reports/errors_only.log` that it contains **6** lines.
2. **Start building `reports/incident_report.txt`:**
   Write a header line using `>` (so the file starts fresh):
   ```bash
   echo "=== INCIDENT REPORT ===" > reports/incident_report.txt
   ```
3. **Append the total number of log lines and error count:**
   ```bash
   echo "Total lines in app.log:" >> reports/incident_report.txt
   wc -l < logs/app.log >> reports/incident_report.txt
   echo "Total ERROR lines:" >> reports/incident_report.txt
   grep -c "ERROR" logs/app.log >> reports/incident_report.txt
   ```
4. **Append the Top 3 IP addresses from `logs/access.log`:**
   ```bash
   echo "Top 3 client IPs by request count:" >> reports/incident_report.txt
   cut -d' ' -f1 logs/access.log | sort | uniq -c | sort -nr | head -n 3 >> reports/incident_report.txt
   ```
5. Inspect your generated report with `cat reports/incident_report.txt`. Which IP address is responsible for the brute-force login attempts and 500 errors?
6. **Commit the reports to Git:**
   ```bash
   git add reports/
   git commit -m "Add automated incident report and filtered error logs"
   ```

---

## 4. Terminal text editors (`nano` and `vim`)

When you connect to a remote Linux server via SSH or debug a Docker container, you do not have VS Code or a mouse. You must be able to edit configuration files directly in the terminal.

### 4.1 `nano` — simple and friendly

`nano` works like a standard text editor: you open a file and start typing immediately. The bottom two lines of the screen show keyboard shortcuts where `^` means the **`Ctrl`** key.

```bash
nano config/app.conf
```

| Shortcut in `nano` | Action |
| --- | --- |
| `Ctrl+O`, then `Enter` | **Write Out** (Save the file) |
| `Ctrl+X` | **Exit** `nano` (asks to save if you have unsaved changes) |
| `Ctrl+W` | **Where Is** (Search for text in the file) |
| `Ctrl+K` | **Cut** the current line |
| `Ctrl+U` | **Uncut** (Paste the cut line) |

### 4.2 `vim` — powerful modal editor

`vim` is installed on virtually every Unix/Linux system in the world (and is often the default editor Git opens for commit and merge messages). Unlike `nano`, `vim` is a **modal editor**—keys do different things depending on which mode you are in:

1. **Normal mode (default when you open `vim`):** keys move the cursor or run editing commands (`j`/`k` or arrows to move, `dd` to delete a line, `u` to undo, `G` to jump to the bottom of the file). You **cannot** type normal text in this mode!
2. **Insert mode (for typing text):** press **`i`** (insert before cursor) or **`o`** (open a new line below) to start typing. The bottom corner shows `-- INSERT --`. To return to Normal mode, press **`Esc`**.
3. **Command-line mode (for saving and quitting):** from Normal mode (press **`Esc`** first!), type a colon `:` followed by a command and press `Enter`:

| Command in `vim` (after pressing `Esc`) | Action |
| --- | --- |
| `:w` + `Enter` | Save (write) the file |
| `:wq` + `Enter` | Save and quit |
| `:q!` + `Enter` | Quit **without** saving (emergency exit!) |
| `/word` + `Enter` | Search for `word` in the file (`n` jumps to next match) |
| `dd` | Delete the current line |
| `u` | Undo the last change |
| `G` | Jump to the last line of the file |

```
       press 'i' or 'o'
  +------------------------+
  |                        v
[ NORMAL MODE ]        [ INSERT MODE ] (type text normally)
  ^                        |
  +------------------------+
         press 'Esc'
              |
              | type ':'
              v
      [ COMMAND MODE ] (:wq to save & exit, :q! to discard & exit)
```

### Practical Exercise 4: Fixing configuration and finalizing the report

Make sure you are in the `workspace/` directory.

1. **Task 4A — Edit `config/app.conf` using `nano`:**
   Open the file:
   ```bash
   nano config/app.conf
   ```
   Update the following three lines so the service is safe for production:
   - Change `PORT=8080` to `PORT=9000`
   - Change `DEBUG=true` to `DEBUG=false`
   - Change `MAINTAINER=TODO` to `MAINTAINER=<your-name-or-github-username>`
   Save the file (`Ctrl+O`, `Enter`) and exit (`Ctrl+X`). Verify your changes with `cat config/app.conf`.

2. **Task 4B — Finalize `reports/incident_report.txt` using `vim`:**
   Open the incident report in `vim`:
   ```bash
   vim reports/incident_report.txt
   ```
   - Press `G` to jump to the last line of the file.
   - Press `o` to open a new line below and enter **Insert mode**.
   - Type the following conclusion block (fill in the suspicious IP from Part 3 and the `SECRET_TOKEN` you found in `.secret_note` in Part 1):
     ```
     === CONCLUSION ===
     Suspicious IP: 192.168.1.50
     Secret Token: LINUX_EXPLORER_2026
     ```
   - Press **`Esc`** to return to Normal mode, then type `:wq` and press **`Enter`** to save and exit.

3. **Commit your edited files to Git:**
   ```bash
   git diff
   git add config/app.conf reports/incident_report.txt
   git commit -m "Update production config and add incident conclusion"
   ```

---

## 5. Final check and submission

Run the verification script from the root of your repository (or from inside `workspace` using `bash ../verify_lab03.sh`):

```bash
cd ..
bash verify_lab03.sh
```

Every check should print `[OK]`. Once all checks pass, push your commits to GitHub:

```bash
git status
git log --oneline
git push
```

Submit the link to your `dev-tools-lab03` repository on GitHub in Google Classroom (assignment *Lab 03*).

> **Reminder for GitHub Codespaces users:** After pushing your work to GitHub, stop your codespace at [github.com/codespaces](https://github.com/codespaces) so it does not consume your free monthly quota in the background.

### Grading (8 points)

| Criterion | Points |
| --- | --- |
| Clean directory structure in `workspace/` (`src`, `docs`, `config`, `logs`, `reports`) with files moved to proper folders | 2 |
| All temporary (`*.tmp`) and backup (`*.bak`) files found and removed | 1 |
| `reports/errors_only.log` and `reports/incident_report.txt` generated correctly using pipes and redirections | 2 |
| `config/app.conf` and `reports/incident_report.txt` updated properly using terminal editors (`nano` / `vim`) | 2 |
| Meaningful Git commits pushed to GitHub & activity during the class | 1 |

## Troubleshooting

| Problem | Solution |
| --- | --- |
| I am stuck inside `less` or `man` and cannot type commands | Press **`q`** to quit the viewer and return to the shell prompt. |
| I am stuck inside `vim` and want to exit without saving | Press **`Esc`**, type **`:q!`** and press **`Enter`**. |
| `No such file or directory` when running a command | Run `pwd` and `ls` to check where you are. Linux filenames are **case-sensitive** (`API.md` is not `api.md`). |
| `grep` or `wc` seems to hang forever Doing Nothing | You forgot to specify the input file, so the command is waiting for keyboard input. Press **`Ctrl+C`** to cancel. |
| I accidentally deleted an important file in `workspace/` | Re-run `bash setup_lab03.sh` from the repository root to regenerate `workspace/` from scratch. |

## Command cheat sheet

| Command | Purpose |
| --- | --- |
| `pwd` | print current working directory |
| `ls -lah` | list all files (including hidden) with human-readable sizes |
| `cd <dir>` / `cd ..` / `cd ~` | change directory / go up one level / go to home directory |
| `cat <file>` | print entire file content |
| `head -n 5 <file>` / `tail -n 5 <file>` | print first 5 / last 5 lines of a file |
| `mkdir -p <dir1> <dir2>` | create directories |
| `cp <src> <dst>` / `mv <src> <dst>` | copy / move or rename files |
| `rm <file>` / `rm -r <dir>` | remove file / remove directory recursively |
| `find . -name "*.tmp"` | search for files matching a pattern in directory tree |
| `cmd > file` / `cmd >> file` | redirect output (overwrite / append) |
| `cmd1 \| cmd2` | pipe output of `cmd1` as input to `cmd2` |
| `grep "text" <file>` | filter lines containing `"text"` |
| `wc -l <file>` | count lines |
| `sort` / `uniq -c` | sort lines / count unique adjacent lines |
| `nano <file>` / `vim <file>` | open file in a terminal text editor |

## Practice in your own pace with fun

Want to become faster and more confident in the Linux terminal? Try these interactive resources:
- [OverTheWire: Bandit](https://overthewire.org/wargames/bandit/) — a famous beginner-friendly game where each level is solved by using Linux commands via SSH to find the password for the next level.
- [Command Line Murders](https://github.com/veltman/clmystery) — solve a murder mystery in the terminal using `grep`, `head`, `tail`, and `find`.
- [ExplainShell.com](https://explainshell.com/) — paste any complex Linux command or pipeline and see a visual breakdown of every flag and argument.
- [OpenVim](https://www.openvim.com/) — interactive browser tutorial for mastering `vim` navigation and editing.
