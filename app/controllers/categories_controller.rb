class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @categories = Category.order(:name)
  end

  def show
    @category = Category.find(params[:id])
    @questions = @category.questions.where(parent_id: nil).includes(:user)
  end
end
