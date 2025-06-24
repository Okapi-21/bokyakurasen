class QuestionsController < ApplicationController
    # before_action :set_question, only: [:show, :edit, :update, :destroy]
    # before_action :authenticate_user!

    def index
        @parents = Question.where(parent_id: nil).includes(:user)
    end

    def show
        @question = Question.find(params[:id])
    end

    def new
        @question = current_user.questions.build
        2.times do
            child = @question.children.build(user: current_user)
            4.times { child.choices.build }
        end
    end

    def create
        @question = current_user.questions.build(question_params)
        @question.children.each do |child|
            child.user = current_user
            child.parent = @question
        end
        if @question.save
            redirect_to questions_path, success: "問題の作成に成功しました"
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
            redirect_to @question, success: "問題を更新しました"
        else
            render :edit
        end
    end

    def destroy
        @question = current_user.questions.find(params[:id])
        @question.destroy
        redirect_to questions_path, success: "問題を削除しました"
    end

    def start
        @parent = Question.find(params[:id])
        @children = @parent.children.order(:id)
        session[:question_ids] = @children.pluck(:id)
        session[:current_index] = 0
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
        @question = Question.find(params[:question_id])
        @choice = Choice.find(params[:choice_id])
        @is_correct = @choice.is_correct
        @explanation = @question.explanation

        parent_id = @question.parent_id || @question.id

        # summary画面の表示・ログのためにユーザー毎に回答記録保存
        Answer.create!(
            user: current_user,
            question: @question,
            choice: @choice,
            is_correct: @is_correct,
            parent_question_id: parent_id
        )

        session[:current_index] += 1
        redirect_to result_question_path(@question, choice_id: @choice.id, is_correct: @is_correct, explanation: @explanation)
    end

    def result
        @question = Question.find(params[:id])
        @choice = Choice.find(params[:choice_id])
        @is_correct = params[:is_correct] == "true"
        @explanation = params[:explanation]
        @parent = @question.parent || @question

        # セッションから子問題IDリストと現在のインデックスを取得
        ids = session[:question_ids]
        idx = session[:current_index]
        total = ids&.size || 0

        # 次の子問題があればそのIDをセット、なければnil
        @next_question_id = ids[idx] if ids && idx && idx < total
        @is_last = (idx >= total)
    end

    def summary
        @parent = Question.find(params[:id])
        # 各子問題ごとに最新の回答だけ取得
        answers = Answer.where(user: current_user, parent_question_id: @parent.id)
        @answers = answers.group_by(&:question_id).map { |_, v| v.max_by(&:created_at) }
        @total = @answers.count
        @correct = @answers.count { |a| a.is_correct }
    end

    private

    def question_params
        params.require(:question).permit(
            :title, :description,
            children_attributes: [
                :title, :description, :explanation,
                choices_attributes: [ :content, :is_correct, :_destroy ]
            ]
        )
    end
end
