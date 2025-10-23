#!/usr/bin/env fish

# Sync .editorconfig from this template repo to other g0t4 repos

set script_dir (dirname (path resolve (status --current-filename)))
set template_repo (dirname $script_dir)
set source_editorconfig "$template_repo/.editorconfig"

set g0t4_repos "$WES_REPOS/github/g0t4"

echo "Template repo: $template_repo"
echo "Source .editorconfig: $source_editorconfig"
echo "Scanning for repos in: $g0t4_repos"
echo ""

function ensure_path_exists
    set p $argv[1]
    if not test -e $p
        echo "Holy crap, $p is missing! Get your shit together."
        exit 1
    end
end

if not path is $source_editorconfig
    echo "Error: source_editorconfig not found at $source_editorconfig"
    exit 1
end

if not path is $g0t4_repos
    echo "Error: g0t4_repos directory not found at $g0t4_repos"
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
