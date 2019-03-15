#!bin/sh

set -eu

cat << END
**************************************************
DOTFILES SETUP START!
**************************************************
END

cd $HOME

echo '********* clone 2357gi/dotfiles?'
read ANSWER
case $ANSWER in
	"" | "Y" | "y" )
		git clone https://github.com/2357gi/dotfiles.git $HOME/dotfiles
		DOTFILES_PATH=$HOME/dotfiles ;;
	* ) echo "skip" ;;
esac


echo '********* generate a new SSH key?[Y/n]'
read ANSWER
case $ANSWER in
	"" | "Y" | "y" )
		ssh-keygen -t rsa -b 4096 ;;
	* ) echo 'skip' ;;
esac


echo '********* install homebrew?[Y/n]'
read ANSWER
case $ANSWER in
	"" | "Y" | "y" )
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" ;;
	* ) echo "skip" ;;
esac


cd DOTFILES_PATH

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

eval git config --global commit.template .commit_template
eval git config --global core.excludesfile ~/.gitignore_global

cat << END

**************************************************
DOTFILES SETUP FINISHED! bye.
**************************************************

END
