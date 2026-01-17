# Custom bash functions

recompute_bin() {
    local claude_dir="$HOME/Claude"
    local bin_dir="$HOME/bin"

    # Ensure ~/bin exists
    mkdir -p "$bin_dir"

    # Find all executable files in ~/Claude
    find "$claude_dir" -type f -executable 2>/dev/null | while read -r exe; do
        local basename=$(basename "$exe")
        local link_path="$bin_dir/$basename"

        if [[ -e "$link_path" ]]; then
            # Check if it's already the correct symlink
            if [[ -L "$link_path" ]] && [[ "$(readlink -f "$link_path")" == "$exe" ]]; then
                [[ -t 1 ]] && echo "✓ $basename already linked"
            else
                [[ -t 1 ]] && echo "⚠ $basename exists (not linking)"
            fi
        else
            ln -s "$exe" "$link_path"
            [[ -t 1 ]] && echo "+ Linked $basename -> $exe"
        fi
    done
}
