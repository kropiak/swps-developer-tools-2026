# Lab 02: Git Collaboration — Branches, Merging, Pull Requests (Windows)


## Learning outcomes

After this lab you will be able to:

- create, switch and merge branches,
- read a branch history with `git log --graph`,
- recognise and resolve a merge conflict,
- synchronise a local repository with a remote one (`fetch`, `pull`, `push`),
- work on a shared repository together with another person,
- contribute to someone else's project through a fork and a pull request.

## Before you start

- You completed Lab 01 (Git installed, GitHub account, identity configured).
- Open **Git Bash**.
- Run this once, so that `git pull` behaves the same for everybody (it merges instead of rebasing):

```bash
git config --global pull.rebase false
```

You will work in pairs in Part 3. Find a partner at the beginning of the class.

## Time plan

| Time | Part |
| --- | --- |
| 5 min | Recap of Lab 01 |
| 20 min | 1. Branches and merging |
| 15 min | 2. Merge conflicts |
| 25 min | 3. Working in pairs on a shared repository |
| 15 min | 4. Fork and pull request |
| 10 min | 5. Final check and submission |

## 1. Branches and merging

A **branch** is a lightweight, movable pointer to a commit. Branches let you try out an idea or develop a feature without touching the stable `main` branch. When the work is ready, you **merge** it back.


```bash
# nawigate to our repository created in lab 1
cd path # replace with correct path
echo My shopping list > shopping.md
# or on Linux/Mac
echo "My shopping list" > shopping.md
git add shopping.md
git commit -m "Add shopping list"
```

### 1.1 A fast-forward merge

```bash
git branch
# this creates a new branch (-c option) and switch to it just afterwards
git switch -c feature/fruits
```

You are now on a new branch. Add something and commit:

```bash
echo "- apples" >> shopping.md
git commit -am "Add apples"
git log --oneline --graph --all --decorate
```

Go back to `main` and merge:

```bash
git switch main
# cat - works on Linux/MacOs
cat shopping.md
# type - works on Windows
type shopping.md
# this will merge feature branch to current branch
git merge feature/fruits
git log --oneline --graph --all --decorate
# this deletes the feature branch
git branch -d feature/fruits
```

Because `main` had no new commits, Git simply moved the pointer forward. This is called a **fast-forward**. Notice that `cat shopping.md` on `main` did not show apples before the merge. Your files change when you switch branches.

### 1.2 A merge with a merge commit

Now let both branches change **different** parts of the project:

```bash
git switch -c feature/drinks
echo "\n## Drinks\n\n- water\n" >> shopping.md
git commit -am "Add drinks section"

git switch main
echo "This list is for the weekend." > notes.md
git add notes.md
git commit -m "Add notes file"

git merge feature/drinks
```

Git opens your editor for the merge commit message. Save and close it. Inspect the graph:

```bash
git log --oneline --graph --all --decorate
```

You should see two lines of history joining in a merge commit.

**Exercise.** Create a branch `feature/vegetables`, add three vegetables, commit, merge into `main` and delete the branch.

## 2. Merge conflicts

A conflict happens when two branches change **the same lines** and Git cannot decide which version to keep. This is normal and you will meet it often.

Create the situation on purpose:

```bash
# 1. create and switch to a new branch
git switch -c feature/water
# 2. replace the line - water with a new value - coconut water
# open editor and do the change
# 3. commit changes
git commit -am "Prefer coconut water"

# 4. go back to the main branch
git switch main
# 5. replace the line - water with a new value - sparkling water
# open editor and do the change
# 6. commit changes
git commit -am "Prefer sparkling water"
# 7. merge
git merge feature/water
```


Git stops and says `CONFLICT`. Check the state:

```bash
git status
```

Open the file in VS Code (`code shopping.md`). You will see conflict markers (your view migh look a little bit different):

```
<<<<<<< HEAD
- sparkling water
=======
- coconut water
>>>>>>> feature/water
```

- The part between `<<<<<<< HEAD` and `=======` is your current branch (`main`).
- The part between `=======` and `>>>>>>> feature/water` comes from the branch you are merging.

Resolve it: in VS Code click **Accept Current Change**, **Accept Incoming Change** or **Accept Both Changes**, or edit the text by hand. The result must contain **no markers**. Then:

```bash
git add shopping.md
git commit
```

If you panic, you can cancel the whole merge with `git merge --abort`.

**Exercise.** Make a second conflict, this time resolve it so that the line says `- water (coconut, sparkling)`.

## 3. Working in pairs on a shared repository

In this part you are **Student A** or **Student B**. In the second round you swap roles if time allows.

### 3.1 Student A prepares the repository

1. Create a new repository on GitHub called `dev-tools-pair`. Add a README when creating it.
2. Go to **Settings → Collaborators → Add people** and invite Student B by their GitHub username.

### 3.2 Student B joins

1. Accept the invitation (an email or the notification on GitHub).
2. Clone the repository:

```bash
cd ~ # Linux/Mac
# nawigate to C:\Users\your user name on Windows using cd or
# opening a new terminal
git clone https://github.com/<student-a-username>/dev-tools-pair.git
cd dev-tools-pair
```

### 3.3 Both work at the same time

Student A also clones the repository (or uses the local copy). Both create a file called `team.md` **with the same first line**, but only one of you pushes first.

**Student A:**

```bash
git pull
echo "# Team\n\nFavourite tool: Git\n" > team.md
git add team.md
git commit -m "Add team file"
git push
```

**Student B** (do this *before* pulling A's change):

```bash
echo "# Team\n\nFavourite tool: Linux\n" > team.md
git add team.md
git commit -m "Add team file with my favourite tool"
git push
```

Student B's push is **rejected** (`non-fast-forward`): the remote has a commit you do not have yet. This is the standard teamwork situation. Fix it:

```bash
git pull
```

A conflict appears. Resolve it **together**: the final file should list both favourite tools. Then:

```bash
git add team.md
git commit
git push
```

Student A runs `git pull` and checks `git log --oneline --graph` to see B's work.

### 3.4 Useful commands for working with a remote

| Command | What it does |
| --- | --- |
| `git fetch` | download new commits, but do not change your files |
| `git pull` | `fetch` + merge into the current branch |
| `git push` | upload your commits |
| `git remote -v` | show configured remotes |
| `git branch -a` | list local and remote branches |

**Rule of thumb:** `git pull` before you start working and before you push.

## 4. Fork and pull request

This is how most open-source projects accept contributions. You cannot push directly to somebody else's repository, so you copy it (**fork**), change your copy and ask the owner to take your changes (**pull request**, PR).

1. Open the course practice repository: `[dev-tools-practice](https://github.com/kropiak/dev-tools-practice)` (the instructor will give you the link). Click **Fork**.
2. Clone **your fork**:

```bash
cd ~
git clone https://github.com/<your-username>/<repository-name>.git
cd <repository-name>
```

3. Create a branch. Do not work on `main`:

```bash
git switch -c add-<your-username>
```

4. Create a file `students/<your-username>.md` with a short introduction (name, a favourite Git command, one Markdown element of your choice). Commit and push the branch:

```bash
git add students/
git commit -m "Add introduction of <your-username>"
git push -u origin add-<your-username>
```

5. Go to your fork on GitHub. Click **Compare & pull request**, write a short description, and create the PR against the original repository.
6. The instructor will review your PR and may ask for changes. If so, commit to the same branch and push again; the PR updates automatically.

## 5. Final check and submission

Submit in Google Classroom (assignment *Lab 02*):


1. the link to `dev-tools-pair`,
2. the link to your pull request.


### Grading (8 points)

| Criterion | Points |
| --- | --- |
| Local branches and merges in local repo (fast-forward and merge commit) | 2 |
| Conflict resolved correctly (no markers left in the file) | 2 |
| Pair work: `dev-tools-pair` has commits from both students and a resolved conflict | 2 |
| Pull request opened to the course repository | 1 |
| Activity during the class | 1 |

## Troubleshooting

| Problem | Solution |
| --- | --- |
| `CONFLICT (content)` | Open the file, resolve the markers, then `git add` and `git commit`. |
| I am stuck in the middle of a merge | `git status` shows what to do. Cancel with `git merge --abort`. |
| `failed to push some refs ... non-fast-forward` | Somebody pushed before you. Run `git pull`, resolve conflicts, push again. |
| `refusing to merge unrelated histories` | You mixed two independent repositories. Ask the instructor. |
| `Permission denied` or 403 on push | You are pushing to a repository you do not own. Push to your fork instead. |
| Editor opened and I do not know what to do | Save the file and close the tab (VS Code). The merge continues. |

## Command cheat sheet

| Command | Purpose |
| --- | --- |
| `git branch` | list branches |
| `git switch <branch>` | switch to a branch |
| `git switch -c <branch>` | create and switch |
| `git merge <branch>` | merge into the current branch |
| `git branch -d <branch>` | delete a merged branch |
| `git log --oneline --graph --all --decorate` | show the branch graph |
| `git merge --abort` | cancel a merge in progress |
| `git clone <URL>` | copy a remote repository |
| `git fetch`, `git pull`, `git push` | synchronise with a remote |

## Further reading

- *Pro Git*, chapter 3 (Git Branching), sections 3.1 to 3.2, and chapter 2.5 (Working with Remotes).
- GitHub Docs: *About pull requests* and *Fork a repo*.

## Practice in your own pace with fun

There are several interactive "tools" to play and learn git. Please check them out:
- https://ohmygit.org/
- https://learngitbranching.js.org
- [https://github.com/k88hudson/git-flight-rules](https://github.com/k88hudson/git-flight-rules)]
- https://gitimmersion.com