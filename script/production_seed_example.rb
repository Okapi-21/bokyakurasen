# frozen_string_literal: true
# 本番環境用のシードスクリプト例
# 
# 使い方:
#   1. このファイルをコピーして production_seed.rb を作成
#   2. 管理者メールアドレスを実際の値に変更
#   3. 必要な問題データを追加・修正
#   4. 本番環境で実行: RAILS_ENV=production bundle exec rails runner script/production_seed.rb
#
# 注意:
#   - 実行前に必ずデータベースバックアップを取得してください
#   - 開発用のダミーアカウントは作成しないでください
#   - スクリプト実行は1回のみにしてください（重複防止）

# 既存の管理者ユーザーを使用（新規作成しない）
user = User.find_by!(email: 'admin@example.com') # ← 実際の管理者メールアドレスに変更してください
puts "Using user: #{user.email}"

# カテゴリーを取得（存在しない場合はエラー）
git_category = Category.find_by!(name: 'Git')
docker_category = Category.find_by!(name: 'Docker')
rails_category = Category.find_by!(name: 'Ruby on rails')

# 問題データ
data = {
  'Git' => {
    category: git_category,
    questions: [
      {
        q: 'Gitは何を管理するツールですか？',
        choices: ['ファイルの履歴', 'データベース', 'ネットワーク接続', 'OSの設定'],
        correct: 0,
        explanation: 'Gitはファイルの変更履歴を管理するツールです。コミット単位で変更を保存し、過去の状態に戻したり、ブランチで並行作業ができます。'
      },
      {
        q: '新しいリポジトリを作成するコマンドは？',
        choices: ['git init', 'git start', 'git new', 'git create'],
        correct: 0,
        explanation: '`git init` は現在のディレクトリを新しいGitリポジトリとして初期化します。リポジトリを最初に作るときに使います。'
      },
      {
        q: '変更をステージするコマンドは？',
        choices: ['git add', 'git stage', 'git commit', 'git push'],
        correct: 0,
        explanation: '`git add` で変更したファイルを次のコミットに含めるためにステージします。ステージした内容だけがコミットされます。'
      },
      {
        q: 'コミットを作成するコマンドは？',
        choices: ['git commit -m "msg"', 'git save', 'git snapshot', 'git push -m "msg"'],
        correct: 0,
        explanation: '`git commit -m "msg"` でステージ済みの変更を1つのコミット（履歴の単位）として保存します。メッセージは変更内容の要約です。'
      },
      {
        q: 'リモートリポジトリを取得してローカルを更新するコマンドは？',
        choices: ['git pull', 'git push', 'git fetch --all', 'git clone'],
        correct: 0,
        explanation: '`git pull` はリモートの更新を取得（fetch）して自動的にマージし、ローカルを最新にします。共同作業でよく使います。'
      }
      # 他の問題を追加してください
    ]
  },
  'Docker' => {
    category: docker_category,
    questions: [
      {
        q: 'Dockerの主な目的は？',
        choices: ['コンテナでアプリを隔離して実行', '仮想マシンを構築', 'ソース管理', 'ネットワーク監視'],
        correct: 0,
        explanation: 'Dockerはアプリケーションをコンテナとして分離して実行することで、環境差異を減らし、配布やスケーリングを簡単にします。'
      },
      {
        q: 'イメージからコンテナを起動するコマンドは？',
        choices: ['docker run', 'docker start', 'docker build', 'docker create'],
        correct: 0,
        explanation: '`docker run` はイメージから新しいコンテナを作成して実行します。オプションでポートやボリュームを指定します。'
      }
      # 他の問題を追加してください
    ]
  },
  'Ruby on rails' => {
    category: rails_category,
    questions: [
      {
        q: 'Railsで新しいアプリを作るコマンドは？',
        choices: ['rails new myapp', 'rails create myapp', 'rails init myapp', 'rails generate app myapp'],
        correct: 0,
        explanation: '`rails new myapp` で新しいRailsアプリケーションの雛形を生成します。必要なGemfileやディレクトリ構成が作成されます。'
      }
      # 他の問題を追加してください
    ]
  }
}

created_parents = 0
created_children = 0

data.each do |category_name, category_data|
  category = category_data[:category]
  
  # 親問題（問題集）を作成
  parent = user.questions.create!(
    title: "#{category_name} 基礎チャレンジ",
    description: "#{category_name} の初心者向け問題セット",
    explanation: "#{category_name} の基本を学べる問題集です"
  )
  
  # カテゴリーに紐付け
  parent.categories << category unless parent.categories.exists?(category.id)
  created_parents += 1
  
  puts "Created parent: #{parent.title}"
  
  # 子問題（実際の問題）を作成
  category_data[:questions].each do |question_data|
    child = user.questions.create!(
      title: question_data[:q],
      description: question_data[:q],
      parent: parent,
      explanation: question_data[:explanation]
    )
    
    # 選択肢を作成
    question_data[:choices].each_with_index do |choice_text, idx|
      child.choices.create!(
        content: choice_text,
        is_correct: (idx == question_data[:correct])
      )
    end
    
    created_children += 1
  end
end

puts "\n=== 完了 ==="
puts "作成した親問題（問題集）: #{created_parents}個"
puts "作成した子問題: #{created_children}問"
puts "\n確認方法:"
puts "  Question.where(parent_id: nil).pluck(:id, :title)"
puts "  Category.all.each { |c| puts \"#{c.name}: #{c.questions.count}問\" }"
