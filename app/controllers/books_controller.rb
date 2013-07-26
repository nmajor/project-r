class BooksController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]

  def index
    #@books = Book.all
    @books = Book.find_with_reputation(:votes, :all, order: "votes desc")
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
    if book.update_attributes params[:book]
      redirect_to books_path
    else
      redirect_to :back
    end
  end

  def destroy
    Book.destroy params[:id]
    redirect_to books_path
  end

  def vote
    value = params[:type] == "up" ? 1 : -1
    @book = Book.find params[:id]
    @book.add_or_update_evaluation(:votes, value, current_user)
    redirect_to :back, notice: "you just " + params[:type] + "voted " + @book.title
  end

end
