# ALES Ground Control Station UI

ALES Ground Control Station UI developed using QML and QT Designer Studio


# Collaboration using Feature Branch and Pull Request

### Branching Strategy

1. **Main Branches:**
    
    • **`main`** (or **`master`**): This is the production-ready branch.
    • **`develop`**: This branch contains the latest development code.
    
2. **Feature Branches:**
    - Create a new branch for each feature or bug fix from the **`develop`** branch.
    - Naming convention: **`feature/short-description`** or **`bugfix/short-description`**.
### Creating a Feature Branch

```
git checkout develop
git pull origin develop
git checkout -b feature/short-description
```

### Committing Changes

- Commit small, logical changes with clear commit messages.
- Use imperative mood in commit messages, e.g., "Add user authentication".

### Pull Request (PR) Process

- **Update Your `develop` Local Branch:**

```bash
git checkout develop
git pull origin develop
```

- **Merge `develop` into Your Feature Branch:**

```bash
git checkout feature/short-description
git merge develop
```

- **Push the Updated Feature Branch:**

```bash
git push origin feature/short-description
```

- **Make a PR to merge your feature branch into** **`develop`**.
    - Create a Pull Request (PR) to merge your feature branch into `develop`.
    - Filling the template of PR provided by the GitHub
- **Code Review and Merging:**
    - Assign at least one reviewer
    - Reviewers should check for coding standard adherence, functionality, and potential issues.
    - The developer who created the PR should address all comments and request re-reviews as necessary.
    - Once approved, the PR will be merged into `develop`.

# Coding Style

High level style information:

- Tabs expanded to 4 spaces
- Pascal/CamelCase naming conventions

The style itself is documents in the following example files:

- [CodingStyle.qml](https://github.com/ArgosdyneResearch/alesqgcui/blob/master/CodingStyle.qml)