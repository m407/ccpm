---
description: Edit issue details locally and synchronize changes with GitLab
---

# Issue Edit

Edit issue details locally and on GitLab.

## Usage
```
/pm-issue-edit <issue_number>
```

## Instructions

### 1. Get Current Issue State

```bash
# Get from GitLab
glab issue view $ARGUMENTS

# Find local task file
# Search for file with gitlab:.*issues/$ARGUMENTS
```

### 2. Interactive Edit

Ask user what to edit:
- Title
- Description/Body
- Labels
- Acceptance criteria (local only)
- Priority/Size (local only)

### 3. Update Local File

Get current datetime: `date -u +"%Y-%m-%dT%H:%M:%SZ"`

Update task file with changes:
- Update frontmatter `name` if title changed
- Update body content if description changed
- Update `updated` field with current datetime

### 4. Update GitLab

If title changed:
```bash
glab issue edit $ARGUMENTS --title "{new_title}"
```

If body changed:
```bash
glab issue edit $ARGUMENTS --body-file {updated_task_file}
```

If labels changed:
```bash
glab issue edit $ARGUMENTS --add-label "{new_labels}"
glab issue edit $ARGUMENTS --remove-label "{removed_labels}"
```

### 5. Output

```
✅ Updated issue #$ARGUMENTS
  Changes:
    {list_of_changes_made}
  
Synced to GitLab: ✅
```

## Important Notes

Always update local first, then GitLab.
Preserve frontmatter fields not being edited.
Follow `/rules/frontmatter-operations.md`.
