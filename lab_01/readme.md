# Lab 01: Git Basics + Markdown (Windows)

## Learning outcomes

After this lab you will be able to:

- explain what version control is and why developers use it,
- configure Git on your machine and create a local repository,
- record changes with `add` and `commit`, inspect history with `status`, `diff` and `log`,
- exclude files from tracking with `.gitignore`,
- write simple documentation in Markdown,
- publish a local repository to GitHub.


## Before you start (Lab 0 checklist)

You should have done this at home. If something is missing, fix it in the first minutes of the class.

- A GitHub account with two-factor authentication (2FA) enabled.
- Git for Windows installed (it includes Git Bash and Git Credential Manager). Check: open **Git Bash** and run `git --version`.
- A code editor, preferably Visual Studio Code.

## Time plan

| Time | Part |
| --- | --- |
| 10 min | 1. Why version control? (instructor demo) |
| 10 min | 2. First-time configuration |
| 20 min | 3. Your first repository |
| 10 min | 4. Markdown |
| 10 min | 5. Undoing changes and ignoring files |
| 15 min | 6. Publishing to GitHub |
| 10 min | 7. Final check and submission |
| 5 min | Wrap-up |

## 1. Why version control?

A version control system (VCS) records the history of your files. You can see who changed what and when, go back to an earlier state, and work on the same project with other people without overwriting each other's work.

Git keeps your files in three places, and a change moves from left to right:

```
Working directory  --git add-->  Staging area  --git commit-->  Local repository  --git push-->  GitHub
(your files)                     (what goes into                (history on your                (remote copy)
                                  the next commit)               computer)
```

**Git** is the tool on your computer. **GitHub** is a web service that hosts Git repositories. They are not the same thing.

## 2. First-time configuration

Open **Git Bash** (recommended in this course; PowerShell also works for Git commands, but later labs use Bash-style commands).

Tell Git who you are. This information is stored in every commit you make:

```bash
git config --global user.name "Your Name"
git config --global user.email "your-github-email@example.com"
git config --global init.defaultBranch main
git config --global core.editor "code --wait"
```

Check the result:

```bash
git config --list --show-origin
```

> **Note on line endings.** Windows ends lines with CRLF, Linux with LF. Git for Windows usually sets `core.autocrlf` to `true`, which converts line endings so that your repository stays consistent. Check with `git config --get core.autocrlf` and leave the default value. If you see a warning like *LF will be replaced by CRLF*, it is harmless.

## 3. Your first repository

```bash
cd ~
mkdir dev-tools-lab01
cd dev-tools-lab01
git init
```

`git init` creates a hidden `.git` folder: this is your repository. Never edit it by hand.

Create a file and look at the status:

```bash
echo "# My first Git repository" > README.md
git status
```

The file is *untracked*. Add it to the staging area and commit:

```bash
git add README.md
git status
git commit -m "Add README with title"
```

Now make a change and inspect it:

```bash
echo "This repository was created during Lab 01." >> README.md
git status
git diff
git add README.md
git diff --staged
git commit -m "Describe the purpose of the repository"
git log
git log --oneline
```

**Exercise.** Create a second file `notes.txt` with three lines about what you expect from this course. Commit it. Then edit one line and commit again. Your history should now have at least four commits.

**Good commit messages**

- Use the imperative mood: *Add notes file*, not *Added* or *Adding*.
- Keep the first line short (about 50 characters) and say what the commit does.
- One commit = one logical change.

## 4. Markdown

Markdown is a simple markup language used for documentation (README files, GitHub issues, wikis). You write plain text; GitHub renders it.

| Element | Markdown |
| --- | --- |
| Heading | `# Title`, `## Section`, `### Subsection` |
| Emphasis | `*italic*`, `**bold**` |
| Bullet list | `- item` |
| Numbered list | `1. item` |
| Inline code | `` `git status` `` |
| Code block | three backticks, optionally followed by the language |
| Link | `[text](https://example.com)` |
| Table | rows separated with `\|` and a header line of `---` |

**Exercise.** Open `README.md` in VS Code (`code README.md`) and extend it so that it contains:

1. a title and at least two section headings,
2. a short description of yourself (two sentences),
3. a bullet list of three tools you want to learn in this course,
4. a code block with one Git command,
5. a link to the course repository: https://github.com/kropiak/swps-developer-tools,
6. a small table (for example: command, what it does) with at least three rows.

Preview it in VS Code with `Ctrl+Shift+V`. Commit when done.

## 5. Undoing changes and ignoring files

**Discard a change** you have not staged:

```bash
echo "oops" >> notes.txt
git restore notes.txt
```

**Unstage** a file (the change stays in your working directory):

```bash
git add notes.txt
git restore --staged notes.txt
```

> `git restore <file>` permanently throws away uncommitted changes in that file. Use it carefully.

**Ignoring files.** Some files should never be in a repository: logs, temporary files, secrets. Create a file named `.gitignore`:

```
*.log
temp/
```

Test it:

```bash
echo "debug output" > debug.log
mkdir temp
echo "x" > temp/scratch.txt
git status
```

Neither `debug.log` nor `temp/` should appear in the status. Commit `.gitignore`.

## 6. Publishing to GitHub

1. On github.com click **New repository**. Name it `dev-tools-lab01`. Do **not** add a README, `.gitignore` or license (your local repository already has history).
2. Copy the repository URL and connect your local repository to it:

```bash
git remote add origin https://github.com/<your-username>/dev-tools-lab01.git
git branch -M main
git push -u origin main
```

3. A browser window will open for **Git Credential Manager** to sign you in. Authorize it. This is how Git authenticates on Windows, so you do not need to type a password.
4. Refresh the repository page on GitHub. You should see your files, your commits and your README rendered as formatted text.

`origin` is just the default name for the remote. `-u` remembers it, so later `git push` and `git pull` need no arguments.

## 7. Final check and submission

Make sure your repository `dev-tools-lab01` on GitHub contains:

- at least **5 commits** with meaningful messages,
- a `README.md` with all the Markdown elements from Part 4,
- `notes.txt`,
- a working `.gitignore` (files such as `debug.log` are **not** in the repository),
- commits authored with your real name.

Submit the link to your repository in Google Classroom (assignment *Lab 01*). The repository must be accessible to the instructor (public, or private with the instructor added as a collaborator).

### Grading (8 points)

| Criterion | Points |
| --- | --- |
| Git identity configured, commits show your name | 1 |
| At least 5 commits with meaningful messages | 2 |
| README with all required Markdown elements | 2 |
| `.gitignore` works, no ignored files committed | 1 |
| Repository pushed to GitHub and link submitted | 1 |
| Activity during the class | 1 |

## Troubleshooting

| Problem | Solution |
| --- | --- |
| `Please tell me who you are` | You skipped `user.name` / `user.email`. Run the `git config --global` commands from Part 2. |
| `src refspec main does not match any` | You have no commit yet, or your branch has another name. Run `git branch -M main` after your first commit. |
| `remote origin already exists` | Run `git remote -v`. Fix with `git remote set-url origin <URL>`. |
| `failed to push some refs` | The GitHub repository is not empty (you added a README there). Ask the instructor. |
| `LF will be replaced by CRLF` | A harmless warning about line endings. |
| Command not found in PowerShell | Use Git Bash for this course. |

## Command cheat sheet

| Command | Purpose |
| --- | --- |
| `git init` | create a repository |
| `git status` | show the state of files |
| `git add <file>` | stage a change |
| `git commit -m "msg"` | record staged changes |
| `git diff` / `git diff --staged` | show unstaged / staged changes |
| `git log --oneline` | show history |
| `git restore <file>` | discard unstaged changes |
| `git restore --staged <file>` | unstage |
| `git remote add origin <URL>` | connect to GitHub |
| `git push -u origin main` | publish the first time |

## Further reading

- *Pro Git* by S. Chacon, chapter 1 (Getting Started) and sections 2.1 to 2.5 (Git Basics).
- Markdown guide on GitHub Docs: *Basic writing and formatting syntax*.