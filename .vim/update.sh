#!/usr/bin/env zsh
# (this can run in bash without modification)

#
# Usage: ./update.sh [pattern]
#
# Specify [pattern] to update only repos that match the pattern.

plugins=(

  # Functionality
  airblade/vim-gitgutter
  docunext/closetag.vim
  ervandew/supertab
  haya14busa/incsearch.vim
  itchyny/lightline.vim
  junegunn/fzf.vim
  junegunn/goyo.vim
  junegunn/limelight.vim
  qpkorr/vim-bufkill
  scrooloose/nerdtree
  tpope/vim-commentary
  tpope/vim-endwise
  tpope/vim-eunuch
  tpope/vim-fugitive
  tpope/vim-pathogen
  tpope/vim-repeat
  tpope/vim-sleuth
  tpope/vim-surround
  tpope/vim-unimpaired
  wellle/targets.vim

  # Syntax (polyglot being the most important)
  alampros/vim-styled-jsx
  ledger/vim-ledger
  sheerun/vim-polyglot
  statico/vim-inform7

  # Colors
  arcticicestudio/nord-vim
  ntk148v/vim-horizon
  tomasr/molokai
)

set -e
dir=~/.dotfiles/.vim/bundle

if [ -d "$dir" -a -z "$1" ]; then
  if which trash &>/dev/null; then
    echo "▲ Moving old bundle dir to trash"
    trash "$dir"
  elif which gio &>/dev/null; then
    echo "▲ Moving old bundle dir to trash"
    gio trash "$dir"
  else
    temp="$(mktemp -d)"
    echo "▲ Moving old bundle dir to $temp"
    mv "$dir" "$temp"
  fi
fi

mkdir -p "$dir"

for repo in ${plugins[@]}; do
  if [ -n "$1" ]; then
    if ! (echo "$repo" | grep -i "$1" &>/dev/null) ; then
      continue
    fi
  fi
  plugin="$(basename $repo | sed -e 's/\.git$//')"
  [ "$plugin" = "vim-styled-jsx" ] && plugin="000-vim-styled-jsx" # https://goo.gl/tJVPja
  dest="$dir/$plugin"
  rm -rf "$dest"
  (
    git clone --depth=1 -q "https://github.com/$repo" "$dest"
    rm -rf "$dest/.git"
    echo "· Cloned $repo"
    [ "$plugin" = "onehalf" ] && (mv "$dest" "$dest.TEMP" && mv "$dest.TEMP/vim" "$dest" && rm -rf "$dest.TEMP")
  ) &
done
wait
