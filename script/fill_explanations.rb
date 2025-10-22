# frozen_string_literal: true

puts "Filling explanations for seeded questions..."

parents = Question.where("title LIKE ?", "%基礎チャレンジ%")
updated = 0

# simple templates per category
templates = {
  'git' => lambda do |q, correct|
    "正解は「#{correct}」です。Gitはファイルの変更履歴を管理するツールで、commitやbranchなどの操作で履歴を扱います。"
  end,
  'docker' => lambda do |q, correct|
    "正解は「#{correct}」です。Dockerはアプリをコンテナとして分離・実行するための仕組みで、イメージとコンテナの概念を理解しましょう。"
  end,
  'rails' => lambda do |q, correct|
    "正解は「#{correct}」です。RailsはRubyのWebフレームワークで、MVC構造やrake/railsコマンドを使って開発します。"
  end
}

parents.find_each do |parent|
  category_key = if parent.title =~ /git/i
                   'git'
  elsif parent.title =~ /docker/i
                   'docker'
  else
                   'rails'
  end

  parent.children.each do |q|
    # overwrite if explanation is empty, too short, or identical to title
    if q.explanation.present?
      short_or_same = q.explanation.strip.length <= 30 || q.explanation.strip == q.title.strip
      # proceed only if short or same
      unless short_or_same
        next
      end
    end

    correct_choice = q.choices.find_by(is_correct: true)
    if correct_choice
      tmpl = templates[category_key]
      explanation = tmpl.call(q, correct_choice.content)
    else
      explanation = "正解の情報が設定されていません。"
    end

    q.update!(explanation: explanation)
    updated += 1
  end
end

puts "Updated explanations for #{updated} questions"
