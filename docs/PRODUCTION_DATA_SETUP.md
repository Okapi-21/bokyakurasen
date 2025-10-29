# 本番環境でのカテゴリー・問題データの投入手順

このドキュメントでは、本番環境にカテゴリーや問題データを投入する方法を初学者向けに説明します。

## 前提条件

- 本番環境にSSHアクセスまたはコンソールアクセスができること
- Railsコンソールまたはrails runnerが使えること
- データベースへの書き込み権限があること

---

## 📋 手順の概要

1. カテゴリーを作成する
2. 問題データ（親・子問題）を作成する
3. 問題に解説を追加する
4. データが正しく投入されたか確認する

---

## 1️⃣ カテゴリーを作成する

### 方法A: Railsコンソールで直接作成（シンプル）

```bash
# 本番環境のコンソールに接続
# Herokuの場合
heroku run rails console -a your-app-name

# Docker/EC2などの場合
RAILS_ENV=production bundle exec rails console
```

コンソール内で以下を実行：

```ruby
# Git カテゴリを作成
Category.create!(
  name: 'Git',
  description: 'Gitの基本的なコマンドやバージョン管理の概念を学べます'
)

# Docker カテゴリを作成
Category.create!(
  name: 'Docker',
  description: 'Dockerコンテナの基本操作やイメージ管理について学べます'
)

# Ruby on Rails カテゴリを作成
Category.create!(
  name: 'Ruby on rails',
  description: 'Ruby on Railsの基礎から応用までを学べます'
)

# 作成されたカテゴリを確認
Category.all.pluck(:id, :name)
```

### 方法B: スクリプトを使って一括作成

本リポジトリには開発環境用のスクリプトがありますが、本番環境では **必ず内容を確認してから実行** してください。

⚠️ **注意**: `script/seed_categories.rb` や `script/seed_more_challenges.rb` は開発用のユーザー（seed@example.com）を作成します。本番では実行前に内容を確認し、必要に応じて修正してください。

---

## 2️⃣ 問題データを作成する

### 問題の構造

- **親問題（Question）**: 問題集のタイトル（例: "Git 基礎チャレンジ"）
- **子問題（Question）**: 実際に解く個別の問題（親問題に紐づく）
- **選択肢（Choice）**: 各子問題に4つ程度の選択肢

### 方法A: Railsコンソールで1問ずつ作成

```ruby
# ユーザーを取得または作成（管理者ユーザーなど）
user = User.find_by(email: 'admin@example.com') || User.create!(
  email: 'admin@example.com',
  name: 'Admin',
  password: 'secure_password_here'
)

# カテゴリーを取得
git_category = Category.find_by(name: 'Git')

# 親問題を作成
parent = user.questions.create!(
  title: 'Git 基礎チャレンジ',
  description: 'Gitの基本コマンドを学べる10問',
  explanation: 'Git初心者向けの問題集です'
)

# カテゴリーに紐付け
parent.categories << git_category

# 子問題を作成
child = user.questions.create!(
  title: 'Gitは何を管理するツールですか？',
  description: 'Gitは何を管理するツールですか？',
  parent: parent,
  explanation: 'Gitはファイルの変更履歴を管理するツールです。コミット単位で変更を保存し、過去の状態に戻したり、ブランチで並行作業ができます。'
)

# 選択肢を作成
child.choices.create!([
  { content: 'ファイルの履歴', is_correct: true },
  { content: 'データベース', is_correct: false },
  { content: 'ネットワーク接続', is_correct: false },
  { content: 'OSの設定', is_correct: false }
])

# 確認
puts "親問題: #{parent.title}"
puts "子問題数: #{parent.children.count}"
puts "選択肢数: #{child.choices.count}"
```

### 方法B: スクリプトを修正して一括投入

#### ステップ1: スクリプトをコピーして本番用に修正

```bash
# ローカルで編集用のスクリプトを作成
cp script/seed_categories.rb script/production_seed.rb
```

#### ステップ2: `script/production_seed.rb` を編集

```ruby
# frozen_string_literal: true

# 本番用: 既存の管理者ユーザーを使う（新規作成しない）
user = User.find_by!(email: 'admin@example.com')
puts "Using user: #{user.email}"

# カテゴリーデータ（必要に応じて追加・修正）
data = {
  'Git' => [
    {q: 'Gitは何を管理するツールですか？', choices: ['ファイルの履歴', 'データベース', 'ネットワーク接続', 'OSの設定'], a:0},
    {q: '新しいリポジトリを作成するコマンドは？', choices: ['git init', 'git start', 'git new', 'git create'], a:0},
    # ... 他の問題を追加
  ],
  # 他のカテゴリーも同様に追加
}

created = 0

data.each do |category_name, items|
  cat = Category.find_by(name: category_name)
  unless cat
    puts "Warning: Category '#{category_name}' not found. Skipping."
    next
  end
  
  parent = user.questions.create!(
    title: "#{category_name} 基礎チャレンジ",
    description: "#{category_name} の初心者向け問題セット",
    explanation: "#{category_name} 基礎問題集"
  )
  parent.categories << cat unless parent.categories.exists?(cat.id)

  items.each do |it|
    child = user.questions.create!(title: it[:q], description: it[:q], parent: parent, explanation: it[:q])
    it[:choices].each_with_index do |c, idx|
      child.choices.create!(content: c, is_correct: (idx == it[:a]))
    end
    created += 1
  end
end

puts "Created #{created} child questions"
```

#### ステップ3: 本番環境でスクリプトを実行

```bash
# Herokuの場合
heroku run rails runner script/production_seed.rb -a your-app-name

# Docker/EC2などの場合
RAILS_ENV=production bundle exec rails runner script/production_seed.rb
```

---

## 3️⃣ 問題に解説を追加する

既存のスクリプト `script/seed_custom_explanations.rb` や `script/fill_more_explanations.rb` を使って解説を追加できます。

```bash
# 本番環境で実行
RAILS_ENV=production bundle exec rails runner script/seed_custom_explanations.rb
```

または、Railsコンソールで個別に編集：

```ruby
# 問題を取得
q = Question.find_by(title: 'Gitは何を管理するツールですか？')

# 解説を更新
q.update!(
  explanation: 'Gitはファイルの変更履歴を管理するツールです。コミット単位で変更を保存し、過去の状態に戻したり、ブランチで並行作業ができます。'
)
```

---

## 4️⃣ データが正しく投入されたか確認

Railsコンソールで確認：

```ruby
# カテゴリー数を確認
Category.count
# => 3

# 各カテゴリーの問題数を確認
Category.all.each do |cat|
  puts "#{cat.name}: #{cat.questions.count}問"
end

# 親問題（問題集）の一覧
Question.where(parent_id: nil).pluck(:id, :title)

# 特定の親問題の子問題数
parent = Question.find_by(title: 'Git 基礎チャレンジ')
puts "子問題数: #{parent.children.count}"
```

---

## 🔒 セキュリティ上の注意事項

1. **本番環境では開発用のダミーアカウントを作成しない**
   - `seed@example.com` のようなアカウントは開発環境のみで使用
   - 本番では既存の管理者アカウントを使う

2. **スクリプト実行前に必ず内容を確認**
   - 特に `User.create!` や `find_or_create_by` がないか確認

3. **本番データベースのバックアップを取る**
   ```bash
   # Herokuの場合
   heroku pg:backups:capture -a your-app-name
   
   # PostgreSQLの場合
   pg_dump your_database > backup_$(date +%Y%m%d).sql
   ```

4. **APIキーや機密情報は環境変数で管理**
   - `.env` ファイルは本番にコミットしない
   - `ENV['LINE_CHANNEL_ID']` などで参照

---

## 📝 トラブルシューティング

### Q: カテゴリーが表示されない

```ruby
# カテゴリーが作成されているか確認
Category.all
```

作成されていない場合は手順1からやり直してください。

### Q: 問題が表示されない

```ruby
# 親問題が存在するか確認
Question.where(parent_id: nil).count

# 特定カテゴリーの問題を確認
Category.find_by(name: 'Git').questions
```

### Q: ユーザーが見つからない

```ruby
# ユーザー一覧
User.pluck(:id, :email)

# 管理者ユーザーを作成
User.create!(email: 'admin@example.com', name: 'Admin', password: 'secure_password')
```

---

## 📚 参考資料

- [Rails Console の使い方](https://guides.rubyonrails.org/command_line.html#bin-rails-console)
- [Rails Runner の使い方](https://guides.rubyonrails.org/command_line.html#bin-rails-runner)
- プロジェクトのER図やモデル関連は `app/models/` を参照

---

## ✅ チェックリスト

本番環境へのデータ投入前に以下を確認してください：

- [ ] データベースのバックアップを取得した
- [ ] 使用するスクリプトの内容を確認した
- [ ] 開発用のダミーアカウントを作成しないようにした
- [ ] カテゴリーが作成されていることを確認した
- [ ] 問題データが正しく投入されたことを確認した
- [ ] ブラウザでカテゴリー一覧が表示されることを確認した
- [ ] 問題が解けることを確認した

---

質問や問題があれば、開発チームに相談してください。
