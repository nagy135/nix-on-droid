{
  lib,
  pkgs,
  ...
}:
let
  functionsScript = pkgs.writeShellScript "zsh-functions" ''
    fzfvim() {
      file=$(find -L "$1" | fzf)
      if [[ -n "$file" ]]; then
        nvim "$file"
      fi
      print -r -- "$file"
      command -v termux-clipboard-set >/dev/null && print -rn -- "$file" | termux-clipboard-set
    }

    cf() { fzfvim "$HOME/.config"; }
    cdot() { fzfvim "$HOME/.dots"; }
    sc() { fzfvim "$HOME/.scripts"; }
    co() { fzfvim "$HOME/Code"; }

    c() {
      cd "$@" && ls
    }

    p() {
      pi --thinking "low" -p "$@"
    }

    pbpath() {
      if [[ -z "$1" ]]; then
        print -r -- "usage: pbpath <path>" >&2
        return 1
      fi

      if command -v termux-clipboard-set >/dev/null; then
        print -rn -- "''${1:A}" | termux-clipboard-set
      else
        print -r -- "''${1:A}"
      fi
    }

    gop() {
      choice=$(find "$HOME" -maxdepth 6 \( -type d -o -type l \) | fzf)
      [[ -n "$choice" ]] && cd "$choice" && ls -l
    }

    copy_chmod_chown() {
      sudo chmod --reference="$1" "$2"
      sudo chown --reference="$1" "$2"
    }

    f() {
      q=$(print -r -- "$*" | sed 's/[[:space:]]\+/%20/g')
      if command -v termux-open-url >/dev/null; then
        termux-open-url "https://google.com/search?q=$q"
      else
        print -r -- "https://google.com/search?q=$q"
      fi
    }

    git-last-commits() {
      NL=$'\n'
      branches=$(git branch -r | awk '{print $1}')
      results=""

      while read branch_name; do
        result=$(git show \
          --color=always \
          --pretty=format:"%Cgreen%ci %Cblue%cr %Cred%cn %Creset" "$branch_name" \
          | head -n 1)
        results="$results''${NL}$result#$branch_name"
      done <<< "$branches"

      print -r -- "$results" | sort -r | column -t -s'#' | tr '#' ' '
    }

    video_to_facebook() {
      filename=$(basename "$1" .mp4)
      ffmpeg -i "$1" -c:v libx264 -preset slow -crf 20 -c:a aac -b:a 160k -vf format=yuv420p -movflags +faststart "$filename"_h264.mp4
    }

    proj() {
      folder="$HOME/Apps"
      choice=$(ls "$folder" | fzf)
      [[ -n "$choice" ]] && cd "$folder/$choice" && ls -la
    }

    lfcd() {
      tmp="$(mktemp)"
      lf -last-dir-path="$tmp" "$@"
      if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
      fi
    }
  '';
in
{
  home.packages = [ pkgs.zsh-powerlevel10k ];

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    defaultKeymap = "viins";

    shellAliases = {
      lg = "lazygit --ucf ~/.config/lazygit/config.yml";
      lgs = "lazygit --ucf ~/.config/lazygit/config_side-by-side.yml";
      nix-shell = ''nix-shell --run "$SHELL"'';

      claude = "claude --permission-mode auto";

      cdc = "cd ~/Code";
      cdd = "cd ~/.dots";

      mv = "mv -v";
      cp = "cp -v";
      rm = "rm -v";

      q = "exit";
      ":q" = "exit";

      vim = "nvim";
      cd-nix = "cd ~/Code/nix-on-droid";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./config;
        file = "p10k.zsh";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
    ];

    envExtra = ''
      export EDITOR=nvim
      export HISTFILE=$HOME/.zsh_history
      export PATH=$PATH:$HOME/.scripts
    '';

    initExtra = ''
      source ${functionsScript}

      [ -f ~/.zshenv_secret ] && source ~/.zshenv_secret

      export PATH=~/.npm-packages/bin:$PATH
      export NODE_PATH=~/.npm-packages/lib/node_modules

      bindkey '^R' history-incremental-search-backward
      bindkey '^P' history-search-backward
      bindkey '^N' history-search-forward

      setopt noincappendhistory
      setopt nosharehistory
      setopt appendhistory

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "$''${(s.:.)LS_COLORS}"

      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey '^G' edit-command-line

      bindkey ' ' magic-space

      function clear-screen-and-scrollback() {
        echoti civis >"$TTY"
        printf '%b' '\e[H\e[2J\e[3J' >"$TTY"
        echoti cnorm >"$TTY"
        zle redisplay
      }
      zle -N clear-screen-and-scrollback
      bindkey '^X^L' clear-screen-and-scrollback

      function copy-buffer-to-clipboard() {
        if command -v termux-clipboard-set >/dev/null; then
          print -rn -- "$BUFFER" | termux-clipboard-set
          zle -M "Copied to clipboard"
        else
          zle -M "termux-clipboard-set not found"
        fi
      }
      zle -N copy-buffer-to-clipboard
      bindkey '^X^Y' copy-buffer-to-clipboard

      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';
  };
}
