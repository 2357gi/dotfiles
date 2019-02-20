#!bin/sh
# its one line installer

set -eu

cat << END

**************************************************
DOTFILES SETUP START!
**************************************************

END

# 実行場所のディレクトリを取得
THIS_DIR=$(cd $(dirname $0); pwd)

cd $THIS_DIR

echo "start setup..."
for f in .??*; do
	[[ "$f" = ".tmux" ]] && continue
	[[ "$f" = ".git" ]] && continue
	[[ "$f" = ".gitconfig.local.template" ]] && continue
	[[ "$f" = ".gitignore" ]] && continue
	[[ "$f" = ".commit_template" ]] && continue

	ln -snfv ~/dotfiles/"$f" ~/
done

if [[ -e ~/.gitconfig.local ]];then
   cp -f ~/dotfiles/.gitconfig.local.template ~/.gitconfig.local
fi

eval git config commit.template .commit_template
eval git config --global core.excludesfile ~/.gitignore_global

cat << END

**************************************************
DOTFILES SETUP FINISHED! bye.
**************************************************

END
