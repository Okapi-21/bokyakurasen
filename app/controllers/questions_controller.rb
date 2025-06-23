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
        4.times { @question.choices.build }
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
        @question = Question.find(ids[idx])
    end

    def answer
        session[:current_index] += 1
        if session[:current_index] < session[:question_ids].size
            redirect_to solve_question_path(params[:id], question_id: session[:question_ids][session[:current_index]])
        else
            redirect_to result_question_path(params[:id])
        end
    end

    def result
    end

    private

    def question_params
        params.require(:question).permit(
            :title, :description,
            choices_attributes: [ :id, :content, :is_correct, :_destroy ]
            )
    end
end
