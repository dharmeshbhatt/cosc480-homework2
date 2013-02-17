# in app/controllers/movies_controller.rb

class MoviesController < ApplicationController

  def self.ratings
    Movie.uniq.pluck(:rating)
  end

  def index
    @all_ratings = MoviesController.ratings
    @valid_ratings = {}
    redirect = false
    if not session.has_key?(:has_visited_before) 
      session[:has_visited_before] = 1
      @all_ratings.each do |rating|
        @valid_ratings[rating.to_str] = "1"
      end
      session[:ratings] = @valid_ratings
      redirect = true
    else
      if session.has_key?(:sort_by) 
        if params[:sort_by] == nil
          redirect = true
          params[:sort_by] = session[:sort_by]
        else
          session[:sort_by] = params[:sort_by]
        end
      else
        session[:sort_by] = params[:sort_by]
      end
    end
    
    if params.has_key?(:ratings)
      params[:ratings].each_pair do |rating, val|
        @valid_ratings[rating.to_str] = "1"
      end
      session[:ratings] = @valid_ratings
    else
      redirect = true
      params[:ratings] = session[:ratings]
    end

    if redirect
      redirect_to(params)
    end
    
    @sort = params[:sort_by]
    @movies = Movie.where(:rating =>  params[:ratings].keys).order(params[:sort_by])
    
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
    # will render app/views/movies/show.html.haml by default
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
  
end
