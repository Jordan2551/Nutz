class LikesController < ApplicationController
  before_action :set_like, only: [:edit, :update, :destroy]

  # GET /likes
  # GET /likes.json
  def index
  end

  def show

    user_likes = Like.where(user_id: params[:id])

    #Set articles to an empty array so that we can push objects into it below
    @articles = []

    user_likes.each do |like|
      @articles << Article.find(like.article_id)
    end

  end


  # GET /likes/new
  def new
    @like = Like.new
  end

  # POST /likes
  # POST /likes.json
  def like

    params[:user_id] = current_user.id
    params[:article_id] = params[:article_id]
    like = Like.new(like_params)

    #Indicates if like/unlike occurred
    status = "nil"

    #If the like doesn't exist then create it
    if User.find(like.user_id).likes.where(article_id: params[:article_id], user_id: params[:user_id]).empty?
      like.save
      status = "liked"
    #Otherwise, it exists, so we destroy it (remove like)
    else
      like_id = Like.where(article_id: params[:article_id], user_id: params[:user_id]).ids
      Like.destroy(like_id)
      status = "unliked"
    end

    like_count = Like.where(article_id: params[:article_id]).count

    result = {status: status, like_count: like_count}

    respond_to do |format|
      format.json {render json: result, status: :ok}
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def like_params
      params.permit(:article_id, :user_id)
    end
end
