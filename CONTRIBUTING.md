# Contributing to ViaRE

Thanks for reading this! That'd mean, hopefully, that you want to contribute
with us.

We try to make it possible that, by reading some of our code, you'll recognize
our conventions and style.

But if you're unsure about it, or you just want to know how we get things done,
you should read this.

## Contents

- [**Git Flow**](#git-flow)
    - [Commiting](#commiting)
    - [Branching](#branching)
- [**Code Style**](#code-style)

## Git Flow

We use git —surprise!— to control versions. In this section, you can get to
know our workflow in this, and all of our projects.

### Commiting

Commited changes should be small, avoiding big chunks of code being created,
modified, or removed.

Our commiting system is based on modularity. Each one should be able to be
described in one sentence. If you need more than one, maybe you should make
multiple commits.

Yes, this can cause non—meaningful commits, but it makes easy to track down
bugs and errors.

If the change of the commit is style related, it doesn't matter the size of the
modified code, as long as it doesn't change functionality.

### Branching

We try to follow the branching system published by [Vincent Driessen at nvie](https://nvie.com/posts/a-successful-git-branching-model/).

`master` only has released versions. 

`develop` is where all approved changes (that are not big enough to make it to
a new version yet) go.

From develop, we have multiple branches. Branches with meaningful names related
to what is being developed inside each branch.

Once a new function or a bug-fix is implemented, we [create a Pull Request](#pull-requests)
to merge changes back into `develop`.

And once we feel that there are enough changes to make a new version of the
project, we [create a Pull Request](#pull-requests) to merge changes into
`master`.

Each merge into `master` is tagged, meaning there's a new release. 
See [Versioning](#versioning).

## Code Style

We try to be consistent with our style. When you doubt whether you should write
`blah blah` or `yada yada`, follow the most important rule:
**optimize for readabaility**.

That said, these are our suggested rules

- Indent using 4 spaces
- Use spaces after commas (unless separated by newlines): `[1, 2, 3]`, `(a, b, c)`.
- Use spaces after flow control statements: `if ()`, `for ()`, `while ()`
- Use spaces around operators, except unaries: `x + y`, `x == y`, `x++`, `!x`.
- Try to keep the line length at ~85. If exceeded, separate it in different lines.
- `variable_names`, `CONSTANT_NAMES`, `Function_Names`, `StructureNames`
- Use new line before `{` in blocks of code:
    ```
    /// Do this
    if (condition)
    {

    }

    /// Instead of this
    if (condition){

    }
    ```
- Always use curly braces after flow control statements. Even if only it's followed
by only one line:
    ```
    /// Do this
    if (condition)
    {
        doSomethingInOneLine()
    }

    /// Instead of this
    if (condition)
        doSomethingInOneLine()
    ```
