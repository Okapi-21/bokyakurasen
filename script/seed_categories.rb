# frozen_string_literal: true

user = User.find_or_create_by!(email: 'seed@example.com') do |u|
  u.name = 'Seed User'
  u.password = 'password'
end

puts "Using user: #{user.email}"

data = {
  'Git' => [
    { q: 'Gitは何を管理するツールですか？', choices: [ 'ファイルの履歴', 'データベース', 'ネットワーク接続', 'OSの設定' ], a: 0 },
    { q: '新しいリポジトリを作成するコマンドは？', choices: [ 'git init', 'git start', 'git new', 'git create' ], a: 0 },
    { q: '変更をステージするコマンドは？', choices: [ 'git add', 'git stage', 'git commit', 'git push' ], a: 0 },
    { q: 'コミットを作成するコマンドは？', choices: [ 'git commit -m "msg"', 'git save', 'git snapshot', 'git push -m "msg"' ], a: 0 },
    { q: 'リモートリポジトリを取得してローカルを更新するコマンドは？', choices: [ 'git pull', 'git push', 'git fetch --all', 'git clone' ], a: 0 },
    { q: 'ブランチを新規作成するコマンドは？', choices: [ 'git branch <name>', 'git create <name>', 'git checkout -b', 'git switch -c <name>' ], a: 0 },
    { q: '現在の変更状態を確認するコマンドは？', choices: [ 'git status', 'git info', 'git show', 'git list' ], a: 0 },
    { q: 'リモートを追加するコマンドは？', choices: [ 'git remote add origin <url>', 'git add remote <url>', 'git link <url>', 'git origin add <url>' ], a: 0 },
    { q: 'ブランチを切り替えるコマンドは？', choices: [ 'git checkout <branch>', 'git change <branch>', 'git switchto <branch>', 'git go <branch>' ], a: 0 },
    { q: 'コミットをリモートへ送るコマンドは？', choices: [ 'git push', 'git send', 'git upload', 'git publish' ], a: 0 }
  ],
  'Docker' => [
    { q: 'Dockerの主な目的は？', choices: [ 'コンテナでアプリを隔離して実行', '仮想マシンを構築', 'ソース管理', 'ネットワーク監視' ], a: 0 },
    { q: 'イメージからコンテナを起動するコマンドは？', choices: [ 'docker run', 'docker start', 'docker build', 'docker create' ], a: 0 },
    { q: 'Dockerfileは何を定義するファイルですか？', choices: [ 'イメージのビルド手順', 'コンテナのログ', 'ネットワーク設定', 'ユーザー情報' ], a: 0 },
    { q: 'バックグラウンドでコンテナを実行するオプションは？', choices: [ '-d', '-b', '-bg', '--detach' ], a: 0 },
    { q: '現在のコンテナ一覧を表示するコマンドは？', choices: [ 'docker ps', 'docker list', 'docker containers', 'docker show' ], a: 0 },
    { q: 'イメージをビルドするコマンドは？', choices: [ 'docker build -t name .', 'docker make', 'docker image build', 'docker create-image' ], a: 0 },
    { q: 'ホストとコンテナのポートをマッピングするオプションは？', choices: [ '-p ホスト:コンテナ', '-P', '--port', '--map-port' ], a: 0 },
    { q: '永続化のためにホストとマウントするのは？', choices: [ 'ボリューム (volumes)', 'イメージ', 'ネットワーク', 'コンテナID' ], a: 0 },
    { q: 'docker-composeは何のためのツール？', choices: [ '複数コンテナを定義して起動する', 'イメージを圧縮する', 'ログを集約する', 'コンテナを監視する' ], a: 0 },
    { q: '実行中のコンテナに入るコマンドは？', choices: [ 'docker exec -it <container> /bin/bash', 'docker enter <container>', 'docker shell <container>', 'docker attach -i <container>' ], a: 0 }
  ],
  'Ruby on rails' => [
    { q: 'Railsで新しいアプリを作るコマンドは？', choices: [ 'rails new myapp', 'rails create myapp', 'rails init myapp', 'rails generate app myapp' ], a: 0 },
    { q: 'モデル、コントローラ、ビュー等を一括生成するコマンドは？', choices: [ 'rails generate scaffold <name>', 'rails scaffold <name>', 'rails gen all <name>', 'rails make scaffold <name>' ], a: 0 },
    { q: 'データベースのマイグレーションを実行するコマンドは？', choices: [ 'rails db:migrate', 'rails migrate', 'rake db:migrate', 'rails db:update' ], a: 0 },
    { q: 'Railsのルーティング設定はどのファイルに書く？', choices: [ 'config/routes.rb', 'app/routes.rb', 'config/routing.rb', 'routes/config.rb' ], a: 0 },
    { q: 'コントローラのアクションでビューに渡すパラメータを安全に受け取る仕組みは？', choices: [ 'Strong Parameters', 'Permitted Params', 'Safe Params', 'Filtered Params' ], a: 0 },
    { q: 'モデルの関連を定義するメソッドは？', choices: [ 'has_many / belongs_to', 'connect / linked_to', 'associate / linked', 'many_to / one_to' ], a: 0 },
    { q: 'Railsコンソールを起動するコマンドは？', choices: [ 'rails console', 'rails c', 'rails console --sandbox', 'rails repl' ], a: 0 },
    { q: '部分テンプレート（パーシャル）はどのように呼び出す？', choices: [ 'render partial: "name"', 'include "name"', 'import "name"', 'use_partial "name"' ], a: 0 },
    { q: 'バリデーションをモデルに追加するには？', choices: [ 'validates :name, presence: true', 'validate :name, required', 'check :name, presence', 'ensure :name' ], a: 0 },
    { q: 'Railsサーバーを起動するコマンドは？', choices: [ 'rails server', 'rails s', 'rails start', 'rails run' ], a: 0 }
  ]
}

created = 0

data.each do |category_name, items|
  cat = Category.find_by(name: category_name)
  next unless cat
  parent = user.questions.create!(title: "#{category_name} 基礎チャレンジ", description: "#{category_name} の初心者向け10問セット", explanation: "#{category_name} 基礎問題集")
  parent.categories << cat unless parent.categories.exists?(cat.id)

  items.each do |it|
    child = user.questions.create!(title: it[:q], description: it[:q], parent: parent, explanation: it[:q])
    it[:choices].each_with_index do |c, idx|
      child.choices.create!(content: c, is_correct: (idx == it[:a]))
    end
    created += 1
  end
end

puts "Created #{created} child questions across categories"
