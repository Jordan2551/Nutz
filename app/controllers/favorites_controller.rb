class FavoritesController < ApplicationController
  before_action :set_favorite, only: [:edit, :update, :destroy]

  # GET /favorites
  # GET /favorites.json
  def index
  end

  # GET /favorites/1
  # GET /favorites/1.json
  def show

    user_favorites = Favorite.where(user_id: params[:id])

    #Set articles to an empty array so that we can push objects into it below
    @articles = []

    user_favorites.each do |favorite|
      @articles << Article.find(favorite.article_id)
    end

  end

  # GET /favorites/new
  def new
    @favorite = Favorite.new
  end

  # GET /favorites/1/edit
  def edit
  end

  def favorite

    params[:user_id] = current_user.id
    params[:article_id] = params[:article_id]
    favorite = Favorite.new(favorite_params)

    #Indicates if like/unlike occurred
    status = "nil"

    #If the like doesn't exist then create it
    if User.find(favorite.user_id).favorites.where(article_id: params[:article_id], user_id: params[:user_id]).empty?
      favorite.save
      status = "favorited"
    #Otherwise, it exists, so we destroy it (remove like)
    else
      favorite_id = Favorite.where(article_id: params[:article_id], user_id: params[:user_id]).ids
      Favorite.destroy(favorite_id)
      status = "unfavorated"
    end

    favorite_count = Favorite.where(article_id: params[:article_id]).count

    result = {status: status, favorite_count: favorite_count}

    respond_to do |format|
      format.json {render json: result, status: :ok}
    end

  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favorite
      @favorite = Favorite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def favorite_params
      params.permit(:article_id, :user_id)
    end
end
