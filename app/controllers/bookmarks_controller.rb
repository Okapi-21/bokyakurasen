class BookmarksController < ApplicationController
    def create
        @question = Question.find(params[:question_id])
        current_user.bookmark(@question)
        redirect_to questions_path, success: "ブックマークに登録しました"
    end

    def destroy
        @question = Question.find(params[:question_id])
        current_user.unbookmark(@question)
        redirect_to questions_path, success: "ブックマークから削除しました", status: :see_other
    end
end
