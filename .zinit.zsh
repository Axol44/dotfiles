export EXCLUDE_DIRS="
.git .fnm .cargo .vscode virtualenvs node_modules .cache __pycache__
.fzf-vim-history .rustup .vscode-insiders .zinit .local .vim .nv .config
.sdkman .npm .yay .mysql .yay .pki .gnome cache"

export EXCLUDE_STRING=$(printf $EXCLUDE_DIRS | tr ' ' '\n' | \
                        sed 's/^/--exclude /' | paste -sd' ')

# fzf
export FZF_DEFAULT_COMMAND="fd --type f $EXCLUDE_STRING --hidden --follow"
# FIXME: Choose what is better by default: abort on escape or just cancel
export FZF_BINDINGS="
# Global
esc:abort
ctrl-y:execute-silent(echo {+} | xclip)

# Navigation
ctrl-g:top
ctrl-u:half-page-up
ctrl-d:half-page-down
ctrl-k:up
ctrl-j:down
ctrl-space:jump

# Prompt
alt-h:backward-char
alt-l:forward-char
alt-b:backward-word
alt-f:forward-word
ctrl-a:beginning-of-line
ctrl-e:end-of-line
alt-bs:unix-line-discard
ctrl-w:unix-word-rubout

# Selection
alt-c:clear-selection
alt-e:select-all
alt-t:toggle-all

# Preview
alt-u:preview-page-up
alt-d:preview-page-down
alt-j:preview-down+preview-down+preview-down
alt-k:preview-up+preview-up+preview-up
?:toggle-preview

# History
alt-p:previous-history
alt-n:next-history
"

export FZF_BINDINGS_STRING=$(printf "$FZF_BINDINGS" | grep -e "^[^#]" |
                             tr "\n" "," | sed -E "s/.$//")

export FZF_DEFAULT_OPTS="
  --exit-0 --multi --info=inline
  --no-border --layout=reverse
  --height 99% --no-mouse
  --preview-window='right:95:wrap:noborder'
  --bind='$FZF_BINDINGS_STRING'
"

# fzf-tab
FZF_TAB_COMMAND=(
    fzf
    --ansi
    --expect='$continuous_trigger,$print_query'

    '--color=hl:$(( $#headers == 0 ? 108 : 255 ))'
    --nth=2,3 --delimiter='\x00'  # Don't search prefix
    --layout=reverse --height='${FZF_TMUX_HEIGHT:=75%}'
    --tiebreak=begin -m --cycle
    '--query=$query'
    '--header-lines=$#headers'
    --print-query
    --bind=$FZF_BINDINGS_STRING
)
zstyle ':fzf-tab:*' command $FZF_TAB_COMMAND

# fzf utilities
# open files
ñf() {
  local out file key preview_command
  preview_command="
    [[ \$(file --mime {}) =~ binary ]] \
        && echo {} is a binary file \
        || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null"

  IFS=$'\n'
  out=("$(
      fzf --query="$1" --preview="$preview_command"  \
       --history="$HOME/.fzf-open-file-history")")

  if [[ -n "$out" ]]; then
    xargs -d'\n' ${EDITOR:-nvim} <<< "$out"
  fi
}

# forgit
forgit_log=gitl
forgit_diff=gitd
forgit_add=gita
forgit_restore=gitr
forgit_reset_head=gitu

forgit_ignore=gitignore
forgit_stash_show=gitstash

# vim easymotion
bindkey -M vicmd ' ' vi-easy-motion
export EASY_MOTION_TARGET_KEYS='fasjuirwzmkhdoe'

