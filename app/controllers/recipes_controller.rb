class RecipesController < ApplicationController

	def index
		@genres = Genre.all
		@types = Type.all
		@tags = Tag.all
		if params[:genre_id]
			@genre = Genre.find(params[:genre_id])
			@recipes = @genre.recipes
			@title = @genre.name
		elsif params[:type_id]
			@type = Type.find(params[:type_id])
			@recipes = @type.recipes
			@title = @type.name
		else
			@recipes = Recipe.find(Like.group(:recipe_id).order('count(recipe_id) desc').pluck(:recipe_id))
			@title = "全てのレシピ"
		end
	end

	def show
		@recipe = Recipe.find(params[:id])
		@comment = Comment.new
		@comments = @recipe.comments
	end

	def new
		@recipe = Recipe.new
		@genres = Genre.all
		@types = Type.all
	end

# 確認画面
	def confirm
		@recipe = Recipe.new(recipe_params)
		@genre = Genre.find_by(id: @recipe.genre_id)
		@type = Type.find_by(id: @recipe.type_id)
	end

	def edit_confirm
		@recipe = Recipe.find(params[:id])
		@genre = Genre.find_by(id: @recipe.genre_id)
		@type = Type.find_by(id: @recipe.type_id)
	end

	def create
		@recipe = Recipe.new(recipe_params)
		@recipe.user_id = current_user.id
		if @recipe.save
			flash[:notice] = "レシピを投稿しました"
			redirect_to user_path(@recipe.user)
		else
			flash[:alert] = "入力内容を確認したください"
			render "new"
		end
	end

	def edit
		@recipe = Recipe.find(params[:id])
		@genres = Genre.all
		@types = Type.all
	end

	def update
		@recipe = Recipe.find(params[:id])
		if @recipe.update(recipe_params)
			flash[:notice] = "レシピを更新しました"
			redirect_to recipe_path(@recipe.id)
		else
			flash[:alert] = "入力内容を確認してください"
			render "edit"
		end
	end

	def destroy
		@recipe = Recipe.find(params[:id])
		@recipe.destroy
		redirect_to user_path(current_user.id)
	end

	private

	def recipe_params
		params.require(:recipe).permit(:title, :image, :body, :price, :quantity, :material, :make, :genre_id, :type_id, :user_id)
	end

end