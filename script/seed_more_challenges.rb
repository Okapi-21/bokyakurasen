# frozen_string_literal: true

user = User.find_or_create_by!(email: 'seed@example.com') do |u|
  u.name = 'Seed User'
  u.password = 'password'
end

puts "Using user: #{user.email}"

sets = {
  'Git' => {
    'ブランチ運用' => [
      { q: 'ブランチを作成して切り替えを一度に行うコマンドは？', choices: [ 'git checkout -b <name>', 'git branch -m <name>', 'git create <name>', 'git switch -c <name>' ], a: 0 },
      { q: '現在のブランチ名を表示するコマンドは？', choices: [ 'git branch --show-current', 'git current', 'git whereami', 'git branch -v' ], a: 0 },
      { q: 'リモートのブランチをローカルに取得するコマンドは？', choices: [ 'git fetch', 'git pull', 'git get', 'git clone' ], a: 0 },
      { q: '不要なローカルブランチを削除するコマンドは？', choices: [ 'git branch -d <name>', 'git delete <name>', 'git remove <name>', 'git branch --remove <name>' ], a: 0 },
      { q: 'ブランチをマージする基本コマンドは？', choices: [ 'git merge <branch>', 'git join <branch>', 'git integrate <branch>', 'git combine <branch>' ], a: 0 },
      { q: 'マージコミットを残さず統合するコマンドは？', choices: [ 'git rebase <branch>', 'git squash <branch>', 'git merge --no-ff <branch>', 'git integrate --fast <branch>' ], a: 0 },
      { q: '現在の作業を一時退避するコマンドは？', choices: [ 'git stash', 'git shelve', 'git hide', 'git save-temp' ], a: 0 },
      { q: 'stashした変更を復元するコマンドは？', choices: [ 'git stash pop', 'git stash apply', 'git stash restore', 'git stash get' ], a: 0 },
      { q: 'ブランチ名を変更するコマンドは？', choices: [ 'git branch -m <old> <new>', 'git rename <old> <new>', 'git mv-branch <old> <new>', 'git switch -m <new>' ], a: 0 },
      { q: 'マージ時の衝突を解決した後、マージを完了するコマンドは？', choices: [ 'git add . && git commit', 'git resolve && git commit', 'git finish-merge', 'git merge --continue' ], a: 0 }
    ],
    '履歴操作' => [
      { q: '過去のコミットログを見るコマンドは？', choices: [ 'git log', 'git history', 'git commits', 'git showlog' ], a: 0 },
      { q: 'コミットを取り消して作業ツリーに戻すコマンドは？', choices: [ 'git reset --soft HEAD~1', 'git undo', 'git revert --soft', 'git back' ], a: 0 },
      { q: '特定ファイルの変更履歴を確認するコマンドは？', choices: [ 'git log -- <file>', 'git history <file>', 'git filelog <file>', 'git view <file>' ], a: 0 },
      { q: '直近の1コミットだけを打ち消すコマンドは？', choices: [ 'git revert HEAD', 'git undo HEAD', 'git reset --hard HEAD~1', 'git remove HEAD' ], a: 0 },
      { q: 'コミットを一つにまとめる操作の名称は？', choices: [ 'squash', 'compress', 'fold', 'bundle' ], a: 0 },
      { q: '履歴を編集するためのインタラクティブなコマンドは？', choices: [ 'git rebase -i', 'git edit-history', 'git amend -i', 'git history -i' ], a: 0 },
      { q: '特定のコミット内容をワークツリーに適用するコマンドは？', choices: [ 'git cherry-pick <commit>', 'git apply-commit <commit>', 'git pick <commit>', 'git checkout <commit> -- .' ], a: 0 },
      { q: 'タグを作成するコマンドは？', choices: [ 'git tag <name>', 'git label <name>', 'git mark <name>', 'git bookmark <name>' ], a: 0 },
      { q: 'ローカルの変更を一時的に破棄するコマンドは？', choices: [ 'git checkout -- <file>', 'git discard <file>', 'git restore <file>', 'git cleanfile <file>' ], a: 0 },
      { q: '大きな変更をコミットせずにテストするための一時ブランチの作成コマンドは？', choices: [ 'git checkout -b temp', 'git temp-branch', 'git test-branch', 'git create-temp' ], a: 0 }
    ],
    'リモートと協業' => [
      { q: 'リモートリポジトリの一覧を表示するコマンドは？', choices: [ 'git remote -v', 'git remotes', 'git list-remote', 'git show-remote' ], a: 0 },
      { q: 'リモートの変更を取得してマージする簡単なコマンドは？', choices: [ 'git pull', 'git fetch && git merge', 'git sync', 'git update' ], a: 0 },
      { q: 'リモートに新しいブランチをプッシュするコマンドは？', choices: [ 'git push -u origin <branch>', 'git push origin:new <branch>', 'git publish <branch>', 'git push --new <branch>' ], a: 0 },
      { q: '他人の変更をレビューするために差分を見るコマンドは？', choices: [ 'git fetch && git diff origin/<branch>', 'git review', 'git see-changes', 'git show-remote-diff' ], a: 0 },
      { q: 'マージリクエスト（PR）作成前に最新を取り込むためによく使うコマンドは？', choices: [ 'git pull --rebase', 'git pull --merge', 'git rebase origin/main', 'git merge origin/main' ], a: 0 },
      { q: 'ローカルのタグをリモートに送るコマンドは？', choices: [ 'git push origin --tags', 'git push --all-tags', 'git push-tags', 'git publish-tags' ], a: 0 },
      { q: 'リモートブランチを削除するコマンドは？', choices: [ 'git push origin --delete <branch>', 'git remote remove-branch <branch>', 'git delete-remote <branch>', 'git push origin :<branch>' ], a: 0 },
      { q: 'リモートのURLを確認するコマンドは？', choices: [ 'git remote get-url origin', 'git remote url', 'git show-remote origin', 'git remote show-url' ], a: 0 },
      { q: '複数人で作業する際の一般的なフローで最後に行う操作は？', choices: [ 'git push', 'git commit', 'git add', 'git pull' ], a: 0 },
      { q: 'リモートとの同期に失敗した場合にまず行うべきコマンドは？', choices: [ 'git fetch', 'git push', 'git reset', 'git clean' ], a: 0 }
    ],
    '基本操作' => [
      { q: '初期設定でユーザ名を設定するコマンドは？', choices: [ 'git config --global user.name "Name"', 'git set user "Name"', 'git init --name "Name"', 'git user add "Name"' ], a: 0 },
      { q: 'コミットメッセージを修正するコマンドは？', choices: [ 'git commit --amend', 'git amend', 'git edit-commit', 'git change-commit' ], a: 0 },
      { q: '変更されたファイルを一覧表示するコマンドは？', choices: [ 'git status --short', 'git list --changes', 'git changed', 'git files-changed' ], a: 0 },
      { q: '直前のコミットを取り消すが履歴は残すコマンドは？', choices: [ 'git revert HEAD', 'git reset --hard HEAD~1', 'git undo HEAD', 'git rollback HEAD' ], a: 0 },
      { q: '全ての未追跡ファイルを削除するコマンドは？', choices: [ 'git clean -f', 'git remove-untracked', 'git purge', 'git clean --all' ], a: 0 },
      { q: 'コミット差分を確認するコマンドは？', choices: [ 'git show <commit>', 'git diff --commit <commit>', 'git view-commit <commit>', 'git changes <commit>' ], a: 0 },
      { q: '履歴の要約表示に使うコマンドは？', choices: [ 'git shortlog', 'git brief', 'git log --oneline', 'git summary' ], a: 2 },
      { q: 'リポジトリをクローンするコマンドは？', choices: [ 'git clone <url>', 'git copy <url>', 'git checkout <url>', 'git fetch <url>' ], a: 0 },
      { q: '複数のファイルを一度にコミットするには？', choices: [ 'git add . && git commit -m "msg"', 'git commit all', 'git addall && git commit', 'git commit -a -m "msg"' ], a: 0 },
      { q: '現在のHEADが指すコミットを表示するコマンドは？', choices: [ 'git rev-parse HEAD', 'git show HEAD', 'git head', 'git current-commit' ], a: 0 }
    ]
  },
  'Docker' => {
    'イメージとDockerfile' => [
      { q: 'Dockerfileでベースイメージを指定する命令は？', choices: [ 'FROM', 'BASE', 'IMAGE', 'USE' ], a: 0 },
      { q: 'ファイルをイメージ内にコピーする命令は？', choices: [ 'COPY', 'ADD', 'PUT', 'MOVE' ], a: 0 },
      { q: 'イメージ作成時にコマンドを実行する命令は？', choices: [ 'RUN', 'CMD', 'EXEC', 'DO' ], a: 0 },
      { q: 'コンテナ起動時のデフォルトコマンドを指定する命令は？', choices: [ 'CMD', 'RUN', 'ENTRYPOINT', 'START' ], a: 0 },
      { q: 'ビルド時に引数を受け取る命令は？', choices: [ 'ARG', 'ENV', 'BUILD_ARG', 'PARAM' ], a: 0 },
      { q: '環境変数を設定する命令は？', choices: [ 'ENV', 'SETENV', 'EXPORT', 'VARIABLE' ], a: 0 },
  { q: '作業ディレクトリを設定する命令は？', choices: [ 'WORKDIR', 'DIR', 'SETWD', 'CD' ], a: 0 },
  { q: '複数行のコマンドを繋げるために使うシェル要素は？', choices: [ "\\", "\\n", '&&', ';' ], a: 0 },
      { q: 'ビルド時のキャッシュを無効化するオプションは？', choices: [ '--no-cache', '--nocache', '--no-cache=true', '--disable-cache' ], a: 0 },
      { q: 'イメージにタグを付けるためのオプションは？', choices: [ '-t', '--tag', '-name', '--label' ], a: 0 }
    ],
    'コンテナ管理' => [
      { q: '実行中のコンテナを停止するコマンドは？', choices: [ 'docker stop <container>', 'docker kill <container>', 'docker end <container>', 'docker halt <container>' ], a: 0 },
      { q: '停止したコンテナを削除するコマンドは？', choices: [ 'docker rm <container>', 'docker delete <container>', 'docker remove <container>', 'docker purge <container>' ], a: 0 },
      { q: 'すべての停止中コンテナを一括削除するコマンドは？', choices: [ 'docker container prune', 'docker rm $(docker ps -a -q)', 'docker clean -a', 'docker prune --all' ], a: 1 },
      { q: '現在のイメージ一覧を表示するコマンドは？', choices: [ 'docker images', 'docker list-images', 'docker image ls', 'docker show-images' ], a: 2 },
      { q: 'コンテナのログを確認するコマンドは？', choices: [ 'docker logs <container>', 'docker show-logs <container>', 'docker tail <container>', 'docker view <container>' ], a: 0 },
      { q: 'コンテナをバックグラウンドで実行するオプションは？', choices: [ '-d', '-bg', '--detach', '--background' ], a: 0 },
      { q: 'ホストとボリュームをマウントするオプションは？', choices: [ '-v host_path:container_path', '--mount', '-m', '--volume' ], a: 0 },
      { q: 'コンテナを一時的に起動して中でコマンドを実行するコマンドは？', choices: [ 'docker run --rm image command', 'docker exec image command', 'docker start image command', 'docker temp image command' ], a: 0 },
      { q: 'コンテナ内でプロセスが停止しているがコンテナは残る状態を確認するコマンドは？', choices: [ 'docker ps -a', 'docker ps', 'docker list -a', 'docker containers -a' ], a: 0 },
      { q: 'イメージを削除するコマンドは？', choices: [ 'docker rmi <image>', 'docker remove-image <image>', 'docker delete-image <image>', 'docker image rm <image>' ], a: 0 }
    ],
    'ネットワークとボリューム' => [
      { q: 'カスタムネットワークを作成するコマンドは？', choices: [ 'docker network create <name>', 'docker net add <name>', 'docker create-network <name>', 'docker network new <name>' ], a: 0 },
      { q: 'ボリュームを作成するコマンドは？', choices: [ 'docker volume create <name>', 'docker vol create <name>', 'docker create-volume <name>', 'docker mkvol <name>' ], a: 0 },
      { q: 'コンテナをネットワークに接続するオプションは？', choices: [ '--network <name>', '-n <name>', '--net <name>', '-network <name>' ], a: 0 },
      { q: 'ボリュームを一覧表示するコマンドは？', choices: [ 'docker volume ls', 'docker volumes', 'docker list-volumes', 'docker vol ls' ], a: 0 },
      { q: 'ネットワーク接続の状態を確認するコマンドは？', choices: [ 'docker network inspect <name>', 'docker net inspect <name>', 'docker inspect-network <name>', 'docker show-network <name>' ], a: 0 },
      { q: 'ボリュームを削除するコマンドは？', choices: [ 'docker volume rm <name>', 'docker rm volume <name>', 'docker delete-volume <name>', 'docker vol rm <name>' ], a: 0 },
      { q: 'コンテナ間で通信ができるようにするために使うのは？', choices: [ 'ネットワーク', 'ボリューム', 'イメージ', 'タグ' ], a: 0 },
      { q: 'docker-composeでサービスをスケールするキーは？', choices: [ 'scale', 'replicas', 'instances', 'service-scale' ], a: 0 },
      { q: 'ホストとコンテナ間でファイル共有する最も一般的な方法は？', choices: [ 'ボリュームマウント', 'ネットワーク共有', '環境変数', 'タグ付け' ], a: 0 },
      { q: 'ネットワークを削除するコマンドは？', choices: [ 'docker network rm <name>', 'docker net rm <name>', 'docker remove-network <name>', 'docker delete-net <name>' ], a: 0 }
    ],
    '基本操作' => [
      { q: 'イメージを取得するコマンドは？', choices: [ 'docker pull <image>', 'docker fetch <image>', 'docker get <image>', 'docker download <image>' ], a: 0 },
      { q: 'コンテナ一覧（実行中）を表示するコマンドは？', choices: [ 'docker ps', 'docker list', 'docker containers', 'docker show' ], a: 0 },
      { q: 'イメージのサイズや情報を確認するコマンドは？', choices: [ 'docker image inspect <image>', 'docker inspect image <image>', 'docker img info <image>', 'docker info image <image>' ], a: 0 },
      { q: 'コンテナの状態を確認するコマンドは？', choices: [ 'docker inspect <container>', 'docker status <container>', 'docker show <container>', 'docker ps -a | grep <container>' ], a: 0 },
      { q: 'コンテナを名前付きで起動するオプションは？', choices: [ '--name <name>', '-n <name>', '--id-name <name>', '--container-name <name>' ], a: 0 },
      { q: 'イメージをタグ付けするコマンドは？', choices: [ 'docker tag <source> <target>', 'docker label <source> <target>', 'docker rename-image', 'docker mark <source> <target>' ], a: 0 },
      { q: '未使用のデータ（ボリューム/ネットワーク/イメージ）を一括クリーンするコマンドは？', choices: [ 'docker system prune', 'docker clean all', 'docker prune --all', 'docker garbage-collect' ], a: 0 },
      { q: 'Dockerのバージョンを確認するコマンドは？', choices: [ 'docker --version', 'docker version', 'docker v', 'docker info --version' ], a: 1 },
      { q: 'イメージのビルドコンテキストを指定するのはどこ？', choices: [ 'コマンドの最後の引数（例: .）', 'Dockerfile内のWORKDIR', '環境変数', '--contextオプション' ], a: 0 },
      { q: 'コンテナのプロセスにアタッチして対話するコマンドは？', choices: [ 'docker exec -it <container> /bin/bash', 'docker attach -it <container>', 'docker enter <container>', 'docker shell <container>' ], a: 0 }
    ]
  },
  'Ruby on rails' => {
    '生成とルーティング' => [
      { q: 'コントローラを単体で生成するコマンドは？', choices: [ 'rails generate controller <name>', 'rails gen controller <name>', 'rails make controller <name>', 'rails create controller <name>' ], a: 0 },
      { q: 'ルーティングでリソースを一括定義するキーワードは？', choices: [ 'resources :posts', 'resource :posts', 'route :posts', 'map :posts' ], a: 0 },
      { q: '名前空間付きルートを作るときに使うのは？', choices: [ 'namespace', 'scope', 'module', 'group' ], a: 0 },
      { q: 'ルートを表示するためのコマンドは？', choices: [ 'rails routes', 'rails rts', 'rails show:routes', 'rails list:routes' ], a: 0 },
      { q: 'GETリクエストをルーティングする記述の例は？', choices: [ 'get "/home", to: "pages#home"', 'route GET /home Pages#home', 'map get "/home" Pages#home', 'get "/home" => Pages#home' ], a: 0 },
      { q: 'ルーティングでパラメータを受け取るパスの例は？', choices: [ 'get "/posts/:id"', 'get "/posts/id"', 'get "/posts/{id}"', 'get "/posts/?id"' ], a: 0 },
      { q: 'ルーティングの優先順位を確認するために使うのは？', choices: [ 'rails routes', 'rails list routes', 'rake routes', 'rails show routes' ], a: 0 },
      { q: '特定アクションのみルーティングする記法は？', choices: [ 'resources :posts, only: [:index, :show]', 'resources :posts, actions: [:index, :show]', 'map :posts, only: [:index, :show]', 'routes resources posts only' ], a: 0 },
      { q: 'ルーティングでHTTPメソッドを指定するキーワードは？', choices: [ 'get/post/put/delete', 'action_get/action_post', 'method_get/method_post', 'verb_get/verb_post' ], a: 0 },
      { q: 'ルートに名前を付けるオプションの例は？', choices: [ 'as: :home', 'name: :home', 'route_name: :home', 'alias: :home' ], a: 0 }
    ],
    'ActiveRecordとモデル' => [
      { q: 'モデルにバリデーションを追加する例は？', choices: [ 'validates :name, presence: true', 'validate name: required', 'check :name, presence', 'ensure :name' ], a: 0 },
      { q: '1対多の関連を定義するのはどれ？', choices: [ 'has_many / belongs_to', 'has_one / belongs_to', 'many_to / one_to', 'link_many / link_one' ], a: 0 },
      { q: 'マイグレーションファイルを生成するコマンドは？', choices: [ 'rails generate migration AddFieldToTable', 'rails g model MigrationName', 'rails create migration', 'rails make:migration' ], a: 0 },
      { q: 'スキーマを最新にするコマンドは？', choices: [ 'rails db:migrate', 'rails db:update', 'rake db:migrate', 'rails migrate' ], a: 0 },
      { q: 'レコードを検索するためのメソッドは？', choices: [ 'where', 'find_by', 'select_by', 'search' ], a: 0 },
      { q: '複数のレコードを一括作成するメソッドは？', choices: [ 'create!', 'insert_all', 'import', 'bulk_create' ], a: 1 },
      { q: 'スコープを定義する際に使うキーワードは？', choices: [ 'scope :published, -> { where(published: true) }', 'define_scope :published', 'scope :published, -> { wherePublished }', 'set_scope :published' ], a: 0 },
      { q: 'バリデーションエラーメッセージを表示するヘルパーは？', choices: [ 'errors.full_messages', 'validation_messages', 'error_list', 'model_errors' ], a: 0 },
      { q: '関連オブジェクトを一括で読み込む手法は？', choices: [ 'includes', 'eager_load', 'joins', 'preload' ], a: 0 },
      { q: 'トランザクションを利用するブロックは？', choices: [ 'ActiveRecord::Base.transaction do ... end', 'db.transaction do ... end', 'transaction { ... }', 'with_transaction do ... end' ], a: 0 }
    ],
    'コントローラとビュー' => [
      { q: 'コントローラでパラメータを安全に扱うには？', choices: [ 'strong parameters (params.require(...).permit(...))', '直接 params を使う', 'unsafe_params', 'permit_all' ], a: 0 },
      { q: 'ビューで部分テンプレートを呼び出す方法は？', choices: [ 'render "shared/header"', 'include "shared/header"', 'partial "shared/header"', 'use "shared/header"' ], a: 0 },
      { q: 'フォームヘルパーでPOST先を指定する簡易的な例は？', choices: [ 'form_with model: @post do |f|', 'form_for @post do |f|', 'form_tag post_path do', 'form action: post_path' ], a: 0 },
      { q: 'フラッシュメッセージをセットするコントローラ側の書き方は？', choices: [ 'flash[:notice] = "msg"', 'set_flash "msg"', 'flash_message "msg"', 'notice_flash "msg"' ], a: 0 },
      { q: 'redirect_to と render の違いは？', choices: [ 'redirect_to は別リクエストに遷移、render は同リクエストでテンプレートを描画する', '両方とも同じ', 'render はリダイレクトする', 'redirect_to はテンプレートを直接描画する' ], a: 0 },
      { q: 'ヘルパーメソッドをビューで使うにはどこに定義する？', choices: [ 'app/helpers', 'app/views/helpers', 'lib/helpers', 'app/controllers/helpers' ], a: 0 },
      { q: '部分テンプレートにローカル変数を渡す方法は？', choices: [ 'render partial: "item", locals: {item: @item}', 'render "item", with: item', 'include partial: "item", locals: item', 'render_local "item"' ], a: 0 },
      { q: 'CSRFトークンは通常どこで扱われる？', choices: [ 'フォームに含まれるhiddenフィールド', 'URLパラメータ', 'ヘッダではない', 'クッキーのみ' ], a: 0 },
      { q: 'ajaxリクエストを受けるアクションでは通常何を返す？', choices: [ 'JSONやJSレスポンス', 'HTMLのみ', 'パスのみ', 'ファイルのみ' ], a: 0 },
      { q: 'ビューのコードを整理するために部分テンプレートを使う利点は？', choices: [ '再利用しやすく、保守性が向上する', 'パフォーマンスが必ず上がる', 'コードが短くなるだけで機能は同じ', 'DBアクセスが減る' ], a: 0 }
    ],
    'デプロイと環境' => [
      { q: 'Railsの環境名で本番環境は通常何と呼ばれる？', choices: [ 'production', 'prod', 'live', 'deploy' ], a: 0 },
      { q: '環境ごとの設定ファイルはどこにある？', choices: [ 'config/environments', 'config/settings', 'env/', 'config/envs' ], a: 0 },
      { q: '本番では通常どのようなwebサーバを使う？', choices: [ 'PumaやUnicornなどのアプリケーションサーバ＋リバースプロキシ', 'WEBrickのみ', 'Rails内蔵のserver', 'sqlite3のみ' ], a: 0 },
      { q: 'シークレットやAPIキーを安全に管理するRailsの仕組みは？', choices: [ 'credentials (Rails credentials) や環境変数', 'config/secret.txt', '公開ファイル', 'アプリ内ハードコード' ], a: 0 },
      { q: 'assetsをプリコンパイルするコマンドは？', choices: [ 'rails assets:precompile', 'rake assets:compile', 'rails precompile', 'assets:build' ], a: 0 },
      { q: 'データベースのバックアップを取る際に一般的に使うのは？', choices: [ 'DBのダンプ（pg_dump等）', 'rails db:dump', 'rails backup', 'db:export' ], a: 0 },
      { q: '本番環境でマイグレーションを行う際の注意点は？', choices: [ '影響範囲やダウンタイムを考慮し、ロールアウト戦略を取る', '即時適用が常に安全', 'テーブルは自動で分割される', 'マイグレーションは不要' ], a: 0 },
      { q: '環境変数を使う利点は？', choices: [ '機密情報をコードベースから分離できる', 'コードが速くなる', 'DBが不要になる', 'テストが自動化される' ], a: 0 },
      { q: 'ログの出力先を制御する設定はどこ？', choices: [ 'config/environments/*.rb や logger の設定', 'app/logs', 'config/logging.yml', 'log/config.rb' ], a: 0 },
      { q: 'デプロイ時にアセットやDBを事前準備するための一般的な手順は？', choices: [ 'assetsプリコンパイル、マイグレーション、サービスの再起動', 'コードをそのままコピーするだけ', 'DBを削除して再作成', '何もしない' ], a: 0 }
    ]
  }
}

created = 0

sets.each do |category_name, groups|
  cat = Category.find_by(name: category_name)
  next unless cat

  groups.each do |group_name, items|
    parent = user.questions.create!(title: "#{category_name} #{group_name} チャレンジ", description: "#{group_name} の問題セット", explanation: "#{group_name} に関する練習問題")
    parent.categories << cat unless parent.categories.exists?(cat.id)

    items.each do |it|
      child = user.questions.create!(title: it[:q], description: it[:q], parent: parent, explanation: it[:q])
      it[:choices].each_with_index do |c, idx|
        child.choices.create!(content: c, is_correct: (idx == it[:a]))
      end
      created += 1
    end
  end
end

puts "Created #{created} child questions across extra challenges"
