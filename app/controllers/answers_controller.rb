class AnswersController < ApplicationController
    

    def new
        @question = Question.find(params[:question_id])
        @answer = Answer.new
    end

    def create
        @question = Question.find(params[:question_id])
        @answer = current_user.answers.build(
            question: @question,
            choice_id: answer_params[:choice_id]
        )

        if @answer.save
            redirect_to question_path(@question), success: (@answer.is_correct? "正解です!" ; "残念！もう一回")
        else
            render :new, status: :unprocessable_entity
        end
    end

    private

    def answer_params
        params.require(:answer).permit(:choice_id)
    end
end
