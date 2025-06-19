class UserSessionsController < ApplicationController
    skip_before_action :require_login, only: %i[new create]

    def new; end

    def create
        @user = login(params[:email], params[:password])

        if @user
            redirect_to questions_path,
            success: "ログインが完了しました"
        else
            flash.now[:danger] = "ログインに失敗しました"
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        logout
        flash[:danger] = "ログアウトが完了しました"
        redirect_to root_path, status: :see_other
    end
end
