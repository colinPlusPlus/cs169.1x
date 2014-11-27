class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
    
  end
  
  def index
    id = params[:id]
    ratings = params[:ratings]
    session[:id] = id
    session[:ratings] = ratings
    @all_ratings = MoviesController.Movie(Movie.all)
    @checked = ratings ? ratings.keys : @all_ratings
    @date_hilite = false
    @title_hilite = false
    
    if !ratings.nil?
      redirect_to movies_path(:id => session[:id])  
    end
    #Set ASC order of title or release date
    case id
      when 'title_header'
      @movies = Movie.order(:title)
      @title_hilite = true
      when 'release_date_header'
      @movies = Movie.order(:release_date)
      @date_hilite = true
      when nil
      @movies = Movie.all
    end
    #Set View to only show selected rating
 
    @movies = Movie.find(:all, :conditions => {:rating => @checked} ) if ratings
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def self.Movie(movies)
    ratings = []
    movies.each { |movie| ratings << movie.rating }
    return ratings.uniq
  end
end
