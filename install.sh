# This script will copy all files to home directory
# To install Vundle for vim you can use 

cp ./.bash_profile ~
cp ./.tmux.conf ~
cp ./.vimrc ~

# Install Vundle for vim plugin management
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# use $ vim +PluginInstall +qall
# to install all plugins from .vimrc

# Install Tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# use prefix{`} + I for installing plugins from .tmux.conf
