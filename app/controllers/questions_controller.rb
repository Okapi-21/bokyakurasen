class QuestionsController < ApplicationController
    # before_action :set_question, only: [:show, :edit, :update, :destroy]
    # before_action :authenticate_user!

    def index
        @questions = Question.includes(:user)
    end

    def show
        @question = Question.find(params[:id])
    end

    def new
        @question = current_user.questions.build
    end

    def create
        @question = current_user.questions.build(question_params)
        if @question.save
            redirect_to questions_path, success: "問題の作成に成功しました"
        else
            flash.now[:danger] = "問題の作成に失敗しました"
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
        @question.destroy!
        redirect_to questions_path, success: "問題を削除しました"
    end

    private

    def question_params
        params.require(:question).permit(:title, :description)
    end
end
