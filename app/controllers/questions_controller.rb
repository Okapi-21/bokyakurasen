class QuestionsController < ApplicationController
    # before_action :set_question, only: [:show, :edit, :update, :destroy]
    # before_action :authenticate_user!

    def index
        @questions = Question.includes(:user)
    end

    def show
    end

    def create
    end

    def edit
    end
end
