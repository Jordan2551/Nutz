class ArticlesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #Used by _search partial.
  #Params: filter_by - used to identify the searching method.
  def filter_articles

      search_query = params[:search_query]
      filter_method = params[:filter_method]

      @articles = []

      #possibly % %
      if filter_method == "0"
        @articles = Article.where('title LIKE ?', "%#{search_query}%")
      elsif filter_method == "1"

        user_likes = Favorite.where(user_id: current_user.id)
        liked_articles = []

        #Find all of the favorited articles
        user_likes.each do |like|
          liked_articles << Article.find(like.article_id)
        end

        #Add the article only if its title contains the search query string
        liked_articles.each do |article|
          @articles << article if article.title.include? search_query
        end

      elsif filter_method == "2"

        user_favorites = Favorite.where(user_id: current_user.id)
        favorited_articles = []

        #Find all of the favorited articles
        user_favorites.each do |favorite|
          favorited_articles << Article.find(favorite.article_id)
        end

        #Add the article only if its title contains the search query string
        favorited_articles.each do |article|
          @articles << article if article.title.include? search_query
        end

      else
      end

      respond_to do |format|
        format.js{}
      end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :description, :img_url, :user_id)
    end
end
