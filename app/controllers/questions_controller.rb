class QuestionsController < ApplicationController
    # before_action :set_question, only: [:show, :edit, :update, :destroy]


    def index
        @parents = Question.where(parent_id: nil).includes(:user)
    end

    def show
        @question = Question.find(params[:id])
    end

    def new
                @question = current_user.questions.build
        3.times do
            child = @question.children.build(user: current_user)
            4.times { child.choices.build }
        end
                # If a category_id is provided (from categories listing), pre-associate it
                if params[:category_id].present?
                    cat = Category.find_by(id: params[:category_id])
                    @question.category_ids = [cat.id] if cat
                    @selected_category = cat
                end
    end

    def create
        @question = current_user.questions.build(question_params)
        @question.children.each do |child|
            child.user = current_user
            child.parent = @question
        end
        if @question.save
            redirect_to categories_path, success: "問題の作成に成功しました"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @question = current_user.questions.find(params[:id])
    end

    def update
        @question = current_user.questions.find(params[:id])
        if @question.update(question_params)
            redirect_to categories_path, success: "問題を更新しました"
        else
            render :edit
        end
    end

    def destroy
        @question = current_user.questions.find(params[:id])
        target =
          if params[:category_id].present?
            category_path(params[:category_id])
          elsif @question.categories.any?
            category_path(@question.categories.first)
          else
            questions_path
          end

        @question.destroy!
        redirect_to target, success: "問題を削除しました"
    end

    def bookmarks
        @bookmarked_questions = current_user.bookmarked_questions
    end

    def start
        # Questionより、params[:id]と合致するものを検索し、@parentへ代入
        @parent = Question.find(params[:id])
        # @parentの子要素を小さい順に@childrenへ代入
        @children = @parent.children.order(:id)
        # 子要素の問題数をセッションで保存しておく
        session[:question_ids] = @children.pluck(:id)
        # 最初の問題へ遷移するために :current_indexは0にする
        session[:current_index] = 0
    # 選択したカテゴリIDをセッションに保存（あれば）
    session[:selected_category_id] = params[:category_id] if params[:category_id].present?
        # 問題解答画面へ遷移する
        redirect_to solve_question_path(@parent, question_id: session[:question_ids][0])
    end

    def solve
        @parent = Question.find(params[:id])
        ids = session[:question_ids]
        idx = session[:current_index]

        # ガード節
        if ids.blank? || idx.blank? || idx >= ids.size
            redirect_to questions_path, alert: "問題が見つかりませんでした。"
            return
        end

        @question = Question.find(ids[idx])
    end

    def answer
        # それぞれの問題、回答、正誤判断を記録する。（説明は一律なのでここで記録する必要はないかもしれない）
        @question = Question.find(params[:question_id])
        @choice = Choice.find(params[:choice_id])
        @is_correct = @choice.is_correct
        @explanation = @question.explanation

        parent_id = @question.parent_id || @question.id

                # summary画面の表示・ログのためにユーザー毎に回答記録保存
                anon_id = session[:anonymous_user_id]
                unless anon_id.present?
                    anon_id = SecureRandom.uuid
                    session[:anonymous_user_id] = anon_id
                end

                Answer.create!(
                        user: current_user,
                        anonymous_id: (current_user ? nil : anon_id),
                        question: @question,
                        choice: @choice,
                        is_correct: @is_correct,
                        parent_question_id: parent_id
                )

        session[:current_index] += 1
        redirect_to result_question_path(@question, choice_id: @choice.id, is_correct: @is_correct, explanation: @explanation)
    end

    def result
        # 回答した子問題（または問題）をIDで取得
        @question = Question.find(params[:id])
        # ユーザーが選んだ選択肢をIDで取得
        @choice = Choice.find(params[:choice_id])
        # パラメータで渡されたis_correct（"true"または"false"の文字列）を真偽値に変換して代入
        @is_correct = params[:is_correct] == "true"
        # 問題の解説文をパラメータから取得
        @explanation = params[:explanation]
        # 親問題（問題集）を取得。子問題ならその親を、親問題自身なら自分自身をセット
        @parent = @question.parent || @question

        # セッションから子問題IDリストと現在のインデックスを取得
        ids = session[:question_ids]
        idx = session[:current_index]
        total = ids&.size || 0

        # 次の子問題があればそのIDをセット、なければnil
        @next_question_id = ids[idx] if ids && idx && idx < total

        # 最後の問題かどうかを判定
        @is_last = (idx >= total)
    end

    def summary
        # 親問題（問題集）をIDで取得
        @parent = Question.find(params[:id])
                # 現在のユーザーがこの問題集で回答した全ての回答を取得
                # logged-in user -> filter by user
                # anonymous user -> filter by session[:anonymous_user_id]
                if current_user
                    answers = Answer.where(user: current_user, parent_question_id: @parent.id)
                elsif session[:anonymous_user_id].present?
                    answers = Answer.where(anonymous_id: session[:anonymous_user_id], parent_question_id: @parent.id)
                else
                    answers = Answer.none
                end
        # 子問題ごとに回答をグループ化し、各子問題について一番新しい（最新の）回答だけを抜き出して配列にする
        @answers = answers.group_by(&:question_id).map { |_, v| v.max_by(&:created_at) }
        # 子問題の数（＝最新回答の数）をカウント
        @total = @answers.count
        # 最新回答のうち正解だったものの数をカウント
        @correct = @answers.count { |a| a.is_correct }
    end

    private

    def question_params
        params.require(:question).permit(
            :title, :description,
            category_ids: [],
            children_attributes: [
              :id, :title, :description, :explanation,
                choices_attributes: [ :id, :content, :is_correct, :_destroy ]
            ]
        )
    end
end
