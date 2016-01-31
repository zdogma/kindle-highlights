# kindle-highlights

## Description
kindle の highlight ページをスクレイピングして取得する。  
現在は twitter の自分の DM に highlight をランダムで送りつける機能を実装している。

## Environment
```
Ruby >~ 2.3.0
```

## Install
### homebrew
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### rbenv
```
brew install rbenv
brew install ruby-build
brew install rbenv-gem-rehash

mkdir -p ~/.rbenv/plugins; cd ~/.rbenv/plugins
git clone https://github.com/ianheggie/rbenv-binstubs.git
git clone https://github.com/sstephenson/rbenv-default-gems.git

echo 'export PATH="$HOME/.rbenv/bin:$PATH' >> ~/.bash_profile
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
source ~/.bash_profile
```

### ruby
```
rbenv install 2.3.0
rbenv exec gem install bundler
rbenv rehash
```

### GitRepo
```
git clone git@github.com:zdogma/kindle-highlights.git
cd kindle-highlights

bundle install --path vendor/bundle --job 4
```

### env
.env ファイルを作成し、下記を記述する。
```
MAIL_ADDRESS=
PASSWORD=
TWITTER_SELF_SCREEN_NAME=
TWITTER_CONSUMER_KEY=
TWITTER_CONSUMER_SECRET=
TWITTER_ACCESS_TOKEN=
TWITTER_ACCESS_SECRET=
```

## Usage
```
bundle exec ruby kindle_highlight.rb
```

## Contribution
1. Fork it ( https://github.com/zdogma/kindle-highlights/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request
