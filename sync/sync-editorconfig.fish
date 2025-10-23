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
    set _path $argv[1]
    if not test -e $_path
        echo "Holy crap, $_path is missing! Get your shit together."
        exit 1
    end
end

ensure_path_exists $source_editorconfig
ensure_path_exists $g0t4_repos


set synced_count 0
set skipped_count 0

# Iterate through each directory in g0t4 repos
for repo in $g0t4_repos/*
    if not path is $repo
        continue
    end

    if test $repo = $template_repo
        continue
    end

    if not path is "$repo/.git"
        continue
    end

    set repo_name (basename $repo)

    # ? skip if it is a fork
    # OR, should I allowlist what to replace? script could even ask and store the results in a file in sync dir (for new repos since last run)
    # TODO THIS IS NOT READY... just an idea

    if path is "$repo/.editorconfig"
        echo "✓ $repo_name"
        # echo cp $source_editorconfig "$repo/.editorconfig"
        set synced_count (math $synced_count + 1)
    else
        set skipped_count (math $skipped_count + 1)
    end
end

echo ""
echo "Synced $synced_count repos, skipped $skipped_count repos"
