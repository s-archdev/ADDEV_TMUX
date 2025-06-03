#!/bin/sh
# Git branch widget for cyberpunk-tmux
# chmod +x widgets/git_branch.sh

get_git_info() {
    # Check if we're in a git repository
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        return
    fi
    
    # Get current branch or commit
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    
    if [ -z "$branch" ]; then
        # We're in detached HEAD state
        commit=$(git rev-parse --short HEAD 2>/dev/null)
        if [ -n "$commit" ]; then
            printf "⚡ %s" "$commit"
        fi
    else
        # Get repository status
        status=""
        
        # Check for staged changes
        if ! git diff --cached --quiet 2>/dev/null; then
            status="${status}+"
        fi
        
        # Check for unstaged changes
        if ! git diff --quiet 2>/dev/null; then
            status="${status}!"
        fi
        
        # Check for untracked files
        if [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
            status="${status}?"
        fi
        
        # Check if branch is ahead/behind
        upstream=$(git rev-parse --abbrev-ref @{upstream} 2>/dev/null)
        if [ -n "$upstream" ]; then
            ahead=$(git rev-list --count HEAD..@{upstream} 2>/dev/null || echo "0")
            behind=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
            
            if [ "$ahead" -gt 0 ]; then
                status="${status}↓${ahead}"
            fi
            if [ "$behind" -gt 0 ]; then
                status="${status}↑${behind}"
            fi
        fi
        
        # Format output
        if [ -n "$status" ]; then
            printf "🌿 %s %s" "$branch" "$status"
        else
            printf "🌿 %s" "$branch"
        fi
    fi
}

main() {
    get_git_info
}

main