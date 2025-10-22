# frozen_string_literal: true

puts "Generating custom explanations for additional questions..."

parents = Question.where("title LIKE ?", "%チャレンジ%")
updated = 0

parents.find_each do |parent|
  parent.children.each do |q|
    next unless q.explanation.blank? || q.explanation.strip == q.title.strip || q.explanation.strip.length <= 30
    correct = q.choices.find_by(is_correct: true)
    next unless correct
    c = correct.content.to_s
    title = q.title.to_s
    ptitle = parent.title.to_s

    expl = nil

    # Git-related
    if ptitle.match?(/git/i) || title.match?(/git/i) || c.match?(/git/i)
      case c
      when /git init/i
        expl = "正解は「git init」です。現在のディレクトリを新しいGitリポジトリとして初期化し、履歴管理が可能になります。"
      when /git add/i
        expl = "正解は「git add」です。ファイルをステージに追加し、次のコミットに含める準備をします。"
      when /git commit/i
        expl = "正解は「git commit」です。ステージされた変更を1つの履歴（コミット）として保存します。コメントで変更内容を説明しましょう。"
      when /git push/i
        expl = "正解は「git push」です。ローカルのコミットをリモートリポジトリに送信し、他の人と共有します。"
      when /git pull/i
        expl = "正解は「git pull」です。リモートの更新を取得してローカルブランチに反映します（fetch + merge）。"
      when /git clone/i
        expl = "正解は「git clone」です。リモートリポジトリを複製してローカルにコピーします。"
      when /git status/i
        expl = "正解は「git status」です。作業ツリーとステージの状態を確認して、何をコミットすべきか把握できます。"
      when /git branch -d/i
        expl = "正解は「git branch -d <name>」です。指定したローカルブランチを削除します。安全に削除するにはマージ済みか確認しましょう。"
      when /git checkout -b/i
        expl = "正解は「git checkout -b <name>」です。新しいブランチを作成してすぐに切り替えます。並行作業に便利です。"
      when /git merge --no-ff/i, /git rebase/i
        expl = "正解はマージやリベースに関する操作です。マージはブランチを統合し、リベースは履歴を書き換えて直線的に統合します。用途に応じて使い分けます。"
      when /stash/i
        expl = "正解はstash操作です。作業途中の変更を一時的に退避し、別の作業へ切り替えられます。復元はgit stash popなどで行います。"
      when /git log/i, /log/i
        expl = "正解はログ表示のコマンドです。git logで履歴を確認し、どのコミットで何が変わったか追跡できます。"
      when /revert/i
        expl = "正解はリバート操作です。指定したコミットの変更を打ち消す新しいコミットを作成し、安全に取り消せます。"
      when /cherry-pick/i
        expl = "正解はgit cherry-pickです。特定のコミットだけを現在のブランチに適用するときに使います。"
      when /tag/i
        expl = "正解はタグ操作です。git tagで特定のコミットに名前（タグ）を付け、リリースなどを管理します。"
      when /shortlog/i, /oneline/i
        expl = "正解は履歴の要約表示に関する操作です。短い形式で履歴を一覧しやすくします。"
      else
        expl = "正解は「#{c}」です。Gitのコマンドで、履歴管理やブランチ操作に関係します。具体的にはそのコマンドがどのような役割かを確認しましょう。"
      end

    # Docker-related
    elsif ptitle.match?(/docker/i) || title.match?(/docker/i) || c.match?(/docker/i) || c.upcase.strip.match?(/FROM|COPY|RUN|CMD|ARG|ENV|WORKDIR/)
      case c.upcase
      when /FROM/
        expl = "正解はFROMです。Dockerfileでベースとなるイメージを指定します。どの環境を元にビルドするかを決めます。"
      when /COPY/, /ADD/
        expl = "正解はCOPY/ADDです。ファイルをホストからイメージ内へコピーします。ビルド時にファイルを含めたいときに使います。"
      when /RUN/
        expl = "正解はRUNです。イメージ作成時にコマンドを実行し、必要なパッケージのインストールなどを行います。"
      when /CMD/, /ENTRYPOINT/
        expl = "正解はCMD/ENTRYPOINTです。コンテナ起動時に実行されるデフォルトコマンドを指定します。"
      when /-D/, /-d/
        expl = "正解は-dオプションです。コンテナをデタッチ（バックグラウンド）で実行します。"
      when /DOCKER PS/i, /PS/
        expl = "正解はdocker psです。実行中のコンテナ一覧を表示します。停止済みも見たい場合は -a を付けます。"
      when /BUILD/, /docker build/i
        expl = "正解はdocker buildです。Dockerfileを元にイメージを作成します。タグ付けは -t オプションで行います。"
      when /--NO-?CACHE/, /--no-cache/
        expl = "正解は --no-cache です。ビルド時にキャッシュを使わずクリーンにビルドしたいときに使います。"
      when /VOLUME|VOLUMES|-V/, /-v/
        expl = "正解はボリュームマウントです。コンテナのデータをホストに永続化するために使います。"
      when /NETWORK|docker network/i
        expl = "正解はネットワーク操作です。カスタムネットワークを作成するとコンテナ間の通信を制御できます。"
      when /docker logs/i, /logs/i
        expl = "正解はdocker logsです。コンテナの標準出力/標準エラーを確認して動作やエラーを調べます。"
      else
        expl = "正解は「#{c}」です。Docker関連のコマンドや設定で、イメージやコンテナの管理に関する操作です。"
      end

    # Rails-related
    else
      case c
      when /rails new/i
        expl = "正解はrails newです。新しいRailsアプリケーションの雛形を生成します。必要なファイルやGemfileが作成されます。"
      when /scaffold/i
        expl = "正解はscaffoldです。モデル・コントローラ・ビューを一括生成して基本的なCRUDを素早く作れます。"
      when /db:migrate/i
        expl = "正解はrails db:migrateです。マイグレーションを適用してデータベーススキーマを更新します。"
      when /config\/routes.rb/, /routes/i
        expl = "正解はroutesに関する項目です。ルーティング設定はconfig/routes.rbに記述し、URLとコントローラを紐付けます。"
      when /strong parameters|permit|require/i
        expl = "正解はStrong Parametersに関する操作です。params.require(...).permit(...)のように許可されたパラメータのみを受け取ることで安全に処理します。"
      when /has_many|belongs_to/i
        expl = "正解はモデル間の関連です。has_many/belongs_toで1対多などの関連を定義し、関連オブジェクトを扱います。"
      when /rails console/i, /rails c/i
        expl = "正解はrails consoleです。アプリケーションコンテキストでデータ操作やデバッグができるREPL環境です。"
      when /render partial/i, /partial/i
        expl = "正解は部分テンプレート（パーシャル）に関するものです。renderで共通のビューを再利用し、コードを整理します。"
      when /validates/i
        expl = "正解はバリデーションに関する記述です。モデルに validates を書くことでデータ保存前にチェックできます。"
      when /rails server|rails s/i
        expl = "正解はrails serverです。開発用サーバを起動してブラウザからアプリを確認できます。"
      else
        expl = "正解は「#{c}」です。Railsの開発でよく使うコマンドや機能なので、公式ドキュメントで詳細を確認しましょう。"
      end
    end

    q.update!(explanation: expl)
    updated += 1
  end
end

puts "Generated explanations for #{updated} questions"
