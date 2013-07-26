class BooksController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]

  def index
    @books = Book.order("cached_votes_score DESC")
  end

  def show
    @book = Book.find params[:id]
  end

  def new
    @book = Book.new
  end

  def create
    user = current_user
    book = Book.create params[:book]
    user.books << book
    redirect_to books_path
  end

  def edit
    @book = Book.find params[:id]
  end

  def update
    book = Book.find params[:id]
    if book.user == current_user
      if book.update_attributes params[:book]
        redirect_to books_path
      else
        redirect_to :back
      end
    end
  end

  def destroy
    book = Book.find params[:id]
    if book.user == current_user
      book.destroy
      redirect_to books_path
    end
  end

  def vote
    book = Book.find params[:id]
    type = params[:type]
    last_vote = current_user.voted_as_when_voted_for(book)
    if type == "up"
      current_user.up_votes(book)
      redirect_to :back
    else
      current_user.down_votes(book)
      redirect_to :back
    end
  end

end
