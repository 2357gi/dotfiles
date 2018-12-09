#!/usr/bin/env bash

# -----------------------------------------------------------------------
# 基本形
# スクロールバーの常時表示
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# コンソールアプリケーションの画面サイズ変更を高速にする
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# 自動大文字の無効化
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# -----------------------------------------------------------------------
# dock関連

# window効果の最大/最小を変更
defaults write com.apple.dock mineffect -string "scale"

# Dockで開いているアプリケーションのインジケータライトを表示する
defaults write com.apple.dock show-process-indicators -bool true

# アプリケーション起動時のアニメーションを無効化
defaults write com.apple.dock launchanim -bool false

# すべての（デフォルトの）アプリアイコンをDockから消去する
defaults write com.apple.dock persistent-apps -array

# Dashboard無効化
defaults write com.apple.dashboard mcx-disabled -bool true


# -----------------------------------------------------------------------
# Finder関連

# アニメーションを無効化する
defaults write com.apple.finder DisableAllAnimations -bool true

# デフォルトで隠しファイルを表示する
defaults write com.apple.finder AppleShowAllFiles -bool true

# 全ての拡張子のファイルを表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# ステータスバーを表示
defaults write com.apple.finder ShowStatusBar -bool true

# パスバーを表示
defaults write com.apple.finder ShowPathbar -bool true

# 検索時にデフォルトでカレントディレクトリを検索
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# 拡張子変更時の警告を無効化
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# USBやネットワークストレージに.DS_Storeファイルを作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ボリュームマウント時に自動的にFinderを表示
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# ゴミ箱を空にする前の警告の無効化
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# -----------------------------------------------------------------------
# スクショの場所変更
mkdir ~/Pictures/screenshots
defaults write com.apple.screencapture location ~/Pictures/screenshots



