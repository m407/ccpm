# GitLab Operations Rule

Standard patterns for GitLab CLI (glab) operations across all commands.

## CRITICAL: Repository Protection

**Before ANY GitLab operation that creates/modifies issues or MRs:**

```bash
# Check if remote origin is the CCPM template repository
remote_url=$(git remote get-url origin 2>/dev/null || echo "")
if [[ "$remote_url" == *"automazeio/ccpm"* ]] || [[ "$remote_url" == *"automazeio/ccpm.git"* ]]; then
  echo "❌ ERROR: You're trying to sync with the CCPM template repository!"
  echo ""
  echo "This repository (automazeio/ccpm) is a template for others to use."
  echo "You should NOT create issues or merge requests here."
  echo ""
  echo "To fix this:"
  echo "1. Create your own repository on GitLab (or mirror your GitLab fork to GitLab)"
  echo "2. Update your remote origin:"
  echo "   git remote set-url origin https://gitlab.com/YOUR_NAMESPACE/YOUR_REPO.git"
  echo ""
  echo "Current remote: $remote_url"
  exit 1
fi
```

This check MUST be performed in ALL commands that:
- Create issues (`glab issue create`)
- Update issues (`glab issue update`)
- Comment on issues (`glab issue note`)
- Create Merge Requests (`glab mr create`)
- Any other operation that modifies the GitLab repository

## Authentication

**Don't pre-check authentication.** Just run the command and handle failure:

```bash
glab {command} || echo "❌ GitLab CLI failed. Run: glab auth login"
```

## Common Operations

### Get Issue Details
Human-readable:
```bash
glab issue view {iid}
```

Structured JSON (recommended for parsing):
```bash
# Requires project context; this uses the REST API via glab
# Replace {iid} with the issue IID (internal ID visible in the web UI)
# You can supply a project with -R <namespace/repo> or rely on current repo
# Example with current repo:
glab api "/projects/:id/issues/{iid}"
```

### Create Issue
```bash
# ALWAYS check remote origin first!
# Use --description-file to read the body from a file and --labels for labels
# (comma-separated labels)
 glab issue create --title "{title}" --description-file {file} --labels "{labels}"
```

### Update Issue
```bash
# ALWAYS check remote origin first!
# Add labels / assign to a user (replace {username} with your GitLab username)
 glab issue update {iid} --add-labels "{label}" --assignees "{username}"
```

### Add Comment (Note)
```bash
# ALWAYS check remote origin first!
# Add a comment from a file
 glab issue note {iid} -F {file}
```

## Error Handling

If any glab command fails:
1. Show clear error: "❌ GitLab operation failed: {command}"
2. Suggest fix: "Run: glab auth login" or verify the issue IID and project context
3. Don't retry automatically

## Important Notes

- **ALWAYS** check remote origin before ANY write operation to GitLab
- Trust that glab CLI is installed and authenticated
- Use `glab api` for structured JSON output when parsing
- Keep operations atomic - one glab command per action
- Don't check rate limits preemptively
