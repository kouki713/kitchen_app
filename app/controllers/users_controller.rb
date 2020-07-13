class UsersController < ApplicationController
	before_action :authenticate_user!
	before_action :set_user

	def show
		@recipes = @user.recipes
	end

	def edit
	end

	def update
	end

	def unsubscribe
		if @user != current_user
			flash[:alert] = "不正なアクセスです"
			redirect_to root_path
		end
	end

	def leave
	end

private
	def user_params
		params.require(:user).permit(:name, :email, :image, :introduction)
	end

	def set_user
		@user = User.find(params[:id])
	end

end