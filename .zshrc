
# ------------------------------------------------------------------------------
# common
# ------------------------------------------------------------------------------
export LANG=ja_JP.UTF-8		# 日本語設定
autoload -U is-at-least		# zsh バージョン切り分けモジュール
export EDITOR=vim			# エディタを vim に設定
export PAGER=lv				# ページャを lv に設定
export LV="-c -Outf8"	# エスケープシーケンス解釈・UTF-8変換

# ------------------------------------------------------------------------------
# 補完
# ------------------------------------------------------------------------------
autoload -U compinit; compinit -u	# 強力な補完機能
setopt auto_cd				# ディレクトリ名のみでcd
setopt correct				# コマンドの間違いを修正する
setopt list_packed			# 候補を詰めて表示する
setopt nolistbeep			# 補完時のビープ音を無効にする
setopt list_types			# 保管候補の表示で ls -F
setopt auto_param_keys			# カッコの対応などを自動的に補完する
setopt auto_param_slash			# ディレクトリの末尾に / 付加
setopt auto_remove_slash		# スペースで / を削除
setopt complete_aliases			# 補完する前にオリジナルコマンドに展開
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}	# カラー表示
setopt noautoremoveslash		# パスの最後の / を自動削除しない
setopt auto_pushd			# cd でディレクトリスタックに自動保存
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'	# 補完で小文字でも大文字にマッチ
setopt pushd_ignore_dups		# 重複してディレクトリスタック保存しない
setopt magic_equal_subst		# 引数の = 以降も補完する
setopt auto_menu			# 補完キー連打で自動で補完
setopt auto_list			# 複数の補完を一行で表示する
setopt complete_in_word			# カーソル位置で補完
setopt glob_complete			# glob を展開しない
setopt numeric_glob_sort		# 辞書順ではなく数字順に並べる
setopt mark_dirs			# ディレクトリにマッチした場合 / を追加
autoload -U bashcompinit; bashcompinit -u	# bash 補完サポート
# ------------------------------------------------------------------------------
# 履歴
# ------------------------------------------------------------------------------
HISTFILE=~/.zsh_history			# 履歴ファイルの保存場所
HISTSIZE=100000000			# 履歴ファイルの最大サイズ
SAVEHIST=100000000			# 履歴ファイルの最大サイズ
setopt auto_pushd			# 移動したディレクトリを自動でpush
setopt hist_expand			# 保管時にヒストリを自動的に展開する
setopt hist_ignore_dups			# 直前と同じ履歴を保存しない
setopt hist_ignore_all_dups		# 重複した履歴を保存しない
setopt append_history			# 複数の履歴を追加で保存
setopt inc_append_history		# 履歴をインクリメンタルに追加
setopt hist_save_no_dups		# 古いコマンドと同じものは無視
setopt hist_no_store			# historyコマンドは履歴に登録しない
setopt hist_reduce_blanks		# 空白を詰めて保存
setopt hist_expire_dups_first		# 履歴削除時に重複行を優先して削除
setopt share_history			# 履歴をプロセスで共有する
setopt hist_verify			# 履歴選択後、実行前に編集可能にする
# ------------------------------------------------------------------------------
# 履歴の検索
# ------------------------------------------------------------------------------
autoload history-search-end		# コマンド履歴の検索(カーソルを行末へ)
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end  history-search-end
bindkey "^P" history-beginning-search-backward-end	# Ctrl+P で前方検索する
bindkey "^N" history-beginning-search-forward-end 	# Ctrl+N で後方検索する

if is-at-least 4.3.10
then
  bindkey '^R' history-incremental-pattern-search-backward
  bindkey '^S' history-incremental-pattern-search-forward
fi

#----- pyenv
export PYENV_ROOT="${HOME}/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
   export PATH=${PYENV_ROOT}/bin:$PATH
   eval "$(pyenv init -)"
fi



#----- rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export PATH=~/vim/src/:$PATH
export PATH=$PATH:/usr/local/bin/
export PATH="/home/gi/anaconda3/bin:$PATH"
export PATH="/usr/local/opt/gettext/bin:$PATH"
export PATH=$HOME/.nodebrew/current/bin:$PATH

if [ -f ~/github.com/dotfiles/.bash_aliases ]; then
    . ~/github.com/dotfiles/.bash_aliases
fi

plugins=(
  git
)


function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

# -----------------------------------------------------------------------
function tmux_automatically_attach_session()
{
	if is_screen_or_tmux_running; then
		! is_exists 'tmux' && return 1

		if is_tmux_runnning; then
			echo "${fg_bold[green]} _____ __  __ _   ___  __ ${reset_color}"
			echo "${fg_bold[green]}|_   _|  \/  | | | \ \/ / ${reset_color}"
			echo "${fg_bold[green]}  | | | |\/| | | | |\  /  ${reset_color}"
			echo "${fg_bold[green]}  | | | |  | | |_| |/  \  ${reset_color}"
			echo "${fg_bold[green]}  |_| |_|  |_|\___//_/\_\ ${reset_color}"
		elif is_screen_running; then
			echo "This is on screen."
		fi
	else
		if shell_has_started_interactively && ! is_ssh_running; then
			if ! is_exists 'tmux'; then
				echo 'Error: tmux command not found' 2>&1
				return 1
			fi

			if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
				# detached session exists
				tmux list-sessions
				echo -n "Tmux: attach? (y/N/num) "
				read
				if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
					tmux attach-session
					if [ $? -eq 0 ]; then
						echo "$(tmux -V) attached session"
						return 0
					fi
				elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
					tmux attach -t "$REPLY"
					if [ $? -eq 0 ]; then
						echo "$(tmux -V) attached session"
						return 0
					fi
				fi
			fi

			if is_osx && is_exists 'reattach-to-user-namespace'; then
				# on OS X force tmux's default command
				# to spawn a shell in the user's namespace
				tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
				tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
			else
				tmux new-session && echo "tmux created new session"
			fi
		fi
	fi
}
tmux_automatically_attach_session



# ------------------------------------------------------------------------------
# 全ての設定が終わってから実行
# ------------------------------------------------------------------------------
typeset -U path cdpath fpath manpath	# パスの重複をなくす
