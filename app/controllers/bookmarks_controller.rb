class BookmarksController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    current_user.bookmark(@question)

    redirect_to redirect_target_for(@question), success: "ブックマークに登録しました"
  end

  def destroy
    @question = Question.find(params[:question_id])
    current_user.unbookmark(@question)

    redirect_to redirect_target_for(@question), success: "ブックマークから削除しました", status: :see_other
  end

  private

  def redirect_target_for(question)
    if params[:category_id].present?
      category_path(params[:category_id])
    elsif question.categories.any?
      category_path(question.categories.first)
    else
      questions_path
    end
  end
end
