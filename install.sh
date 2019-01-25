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
	[ "$f" = ".git" ] && continue
	[ "$f" = ".gitconfig.local.template" ] && continue

	ln -snfv ~/dotfiles/"$f" ~/
done

[ -e ~/.gitconfig.local ] || cp ~/dotfiles/.gitconfig.local.template ~/.gitconfig


cat << END

**************************************************
DOTFILES SETUP FINISHED! bye.
**************************************************

END
