#!/usr/bin/env fish

# Sync .editorconfig from this template repo to other g0t4 repos

# Get the directory of this script and the template repo
set script_dir (dirname (status --current-filename))
set template_repo (dirname $script_dir)
set source_editorconfig "$template_repo/.editorconfig"

# Navigate to parent directory where github/g0t4 repos are located
set repos_root (dirname (dirname $template_repo))
set g0t4_repos "$repos_root/github/g0t4"

echo "Template repo: $template_repo"
echo "Source .editorconfig: $source_editorconfig"
echo "Scanning for repos in: $g0t4_repos"
echo ""

# Check if source .editorconfig exists
if not test -f $source_editorconfig
    echo "Error: Source .editorconfig not found at $source_editorconfig"
    exit 1
end

# Check if g0t4 repos directory exists
if not test -d $g0t4_repos
    echo "Error: g0t4 repos directory not found at $g0t4_repos"
    exit 1
end

set synced_count 0
set skipped_count 0

# Iterate through each directory in g0t4 repos
for repo in $g0t4_repos/*
    # Skip if not a directory
    if not test -d $repo
        continue
    end

    # Skip the template repo itself
    if test $repo = $template_repo
        continue
    end

    # Check if it's a git repo
    if not test -d "$repo/.git"
        continue
    end

    set repo_name (basename $repo)

    # Check if repo has .editorconfig
    if test -f "$repo/.editorconfig"
        echo "✓ Syncing .editorconfig to: $repo_name"
        cp $source_editorconfig "$repo/.editorconfig"
        set synced_count (math $synced_count + 1)
    else
        echo "  Skipping $repo_name (no .editorconfig found)"
        set skipped_count (math $skipped_count + 1)
    end
end

echo ""
echo "Summary: Synced $synced_count repos, skipped $skipped_count repos"
