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
	[[ "$f" = ".git" ]] && continue
	[[ "$f" = ".gitconfig.local.template" ]] && continue
	[[ "$f" = ".gitignore" ]] && continue
	[[ "$f" = ".commit_template" ]] $$ continue

	ln -snfv ~/dotfiles/"$f" ~/
done

if [[ -e ~/.gitconfig.local ]];then
   cp -f ~/dotfiles/.gitconfig.local.template ~/.gitconfig
fi

git config commit.template .commit_template

cat << END

**************************************************
DOTFILES SETUP FINISHED! bye.
**************************************************

END
