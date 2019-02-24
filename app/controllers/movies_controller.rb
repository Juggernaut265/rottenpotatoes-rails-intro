class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index 
    @all_ratings = Movie.all_ratings
    @chosen_ratings = @all_ratings
    @ratings = params[:ratings]


    if session[:ratings] != nil and (@ratings == nil or @ratings.length == 0)
      @ratings = session[:ratings]
      @ratings_hash = {}
      @ratings.each do |i, rating|
        @ratings_hash[i] = rating
      end
      redirect_to movies_path(ratings: @ratings)
    end


    if @ratings != nil
      @chosen_ratings = @ratings.keys
    end

    session[:ratings] = @ratings

    @sortby = params[:sortby]
    if @sortby == nil
      @sortby = session[:sortby]
    end
    if @sortby == "date"
      @movies = Movie.with_ratings(@chosen_ratings).order('release_date ASC')
      session[:sortby] = "date"
    elsif @sortby == "title"
      @movies = Movie.with_ratings(@chosen_ratings).order('title ASC')
      session[:sortby] = "title"
    else
      @movies = Movie.with_ratings(@chosen_ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
