class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find params[:id]
  end

  def new
    @book = Book.new
  end

  def create
    Book.create params[:book]
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
end
