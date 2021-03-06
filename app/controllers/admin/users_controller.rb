# frozen_string_literal: true

module Admin
  class UsersController < Admin::BaseController
    before_action :set_user, only: %i[show edit update destroy]

    def index
      @q = User.ransack(params[:q])
      @users = @q.result.page(params[:page])
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_user_path(user), notice: "ユーザーの作成に成功"
      else
        flash.now[:danger] = "ユーザー作成に失敗"
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: "ユーザー情報の更新に成功"
      else
        flash.now[:danger] = "ユーザーの更新に失敗"
        render :edit
      end
    end

    def destroy
      @user.destroy!
      redirect_to admin_users_path, notice: "ユーザーの削除に成功"
    end

    private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        # アクセス制限後:roleを再度追加
        params.require(:user).permit(:name, :email, :password, :password_confirmation,
                                     :gender, :birth, :height, :weight,
                                     :percentage_protein, :percentage_fat, :percentage_protein)
      end
  end
end
