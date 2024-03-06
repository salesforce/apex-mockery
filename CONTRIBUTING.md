# Contributing to apex-mockery

We encourage the developer community to contribute to this repository. This guide has instructions to install, build, test and contribute to the framework.

- [Requirements](#requirements)
- [Installation](#installation)
- [Testing](#testing)
- [Git Workflow](#git-workflow)

## Requirements

- [Node](https://nodejs.org/) >= 14

## Installation

### 1) Download the repository

```bash
git clone git@github.com:salesforce/apex-mockery.git
```

### 2) Install Dependencies

This will install all the tools needed to contribute

```bash
npm install
```

### 3) Build application

```bash
sfdx force:source:push
```

Rebuild every time you made a change in the source and you need to test locally

## Testing

### Unit Testing

When developing, use apex unit testing to provide test coverage for new functionality. To run the apex tests use the following command from the root directory:

```bash
# just run test
npm run test
```

To execute a particular test, use the sfdx command directly

## Editor Configurations

Configure your editor to use our lint and code style rules.

### Code formatting

[Prettier](https://prettier.io/) is a code formatter used to ensure consistent formatting across your code base. To use Prettier with Visual Studio Code, install [this extension](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) from the Visual Studio Code Marketplace.
This repository provide [.prettierignore](/.prettierignore) and [.prettierrc](/.prettierrc.json) files to control the behaviour of the Prettier formatter.

### Code linting

We use `sfdx-scanner` to execute code static analysis
It is automatically installed for you via `npm install`

## Git Workflow

The process of submitting a pull request is straightforward and
generally follows the same pattern each time:

1. [Fork the repo](#fork-the-repo)
1. [Create a feature branch](#create-a-feature-branch)
1. [Make your changes](#make-your-changes)
1. [Rebase](#rebase)
1. [Check your submission](#check-your-submission)
1. [Create a pull request](#create-a-pull-request)
1. [Update the pull request](#update-the-pull-request)

### Fork the repo

[Fork][fork-a-repo] the [salesforce/apex-mockery](https://github.com/salesforce/apex-mockery) repo. Clone your fork in your local workspace and [configure][configuring-a-remote-for-a-fork] your remote repository settings.

```bash
git clone git@github.com:<YOUR-USERNAME>/apex-mockery.git
cd apex-mockery
git remote add upstream git@github.com:salesforce/apex-mockery.git
```

### Create a feature branch

```bash
git checkout main
git pull origin main
git checkout -b feature/<name-of-the-feature>
```

### Make your changes

Change the files, build, test, lint and commit your code using the following command:

```bash
git add <path/to/file/to/commit>
git commit ...
git push origin feature/<name-of-the-feature>
```

Commit your changes using a descriptive commit message

The above commands will commit the files into your feature branch. You can keep
pushing new changes into the same branch until you are ready to create a pull
request.

### Rebase

Sometimes your feature branch will get stale on the main branch,
and it will must a rebase. Do not use the github UI rebase to keep your commits signed. The following steps can help:

```bash
git checkout main
git pull upstream main
git checkout feature/<name-of-the-feature>
git rebase upstream/main
```

_note: If no conflicts arise, these commands will apply your changes on top of the main branch. Resolve any conflicts._

### Check your submission

#### Lint your changes

```bash
npm run lint
```

The above command may display lint issues not related to your changes.
The recommended way to avoid lint issues is to [configure your
editor][eslint-integrations] to warn you in real time as you edit the file.

Fixing all existing lint issues is a tedious task so please pitch in by fixing
the ones related to the files you make changes to!

#### Run tests

Test your change by running the unit tests and integration tests. Instructions [here](#testing).

### Create a pull request

If you've never created a pull request before, follow [these
instructions][creating-a-pull-request]. Pull request samples [here](https://github.com/salesforce/apex-mockery/pulls)

### Update the pull request

```sh
git fetch origin
git rebase origin/${base_branch}

# Then force push it
git push origin ${feature_branch} --force-with-lease
```

_note: If your pull request needs more changes, keep working on your feature branch as described above._

CI validates prettifying, linting and tests

[fork-a-repo]: https://help.github.com/en/articles/fork-a-repo
[configuring-a-remote-for-a-fork]: https://help.github.com/en/articles/configuring-a-remote-for-a-fork
[setup-github-ssh]: https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
[creating-a-pull-request]: https://help.github.com/articles/creating-a-pull-request/
[eslint-integrations]: http://eslint.org/docs/user-guide/integrations

### Collaborate on the pull request

We use [Conventional Comments](https://conventionalcomments.org/) to ensure every comment expresses the intention and is easy to understand.
Pull Request comments are not enforced, it is more a way to help the reviewers and contributors to collaborate on the pull request.
