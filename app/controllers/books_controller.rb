class BooksController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]

  def index
    @books = Book.order("cached_votes_score DESC")
    @books.sort! {|a,b|
      rel = b.book_score <=> a.book_score 
      rel == 0 ? a.cached_votes_score <=> b.cached_votes_score : rel
    } 
  end

  def show
    @book = Book.find params[:id]
    @review = Review.new
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

  def excerpt
    @book = Book.find params[:id]
  end

  def vote
    if params[:type] == "book"
    obj = Book.find params[:id]
    elsif params[:type] == "review"
      obj = Review.find params[:id]
    end
    vote = params[:vote]
    if vote == "up"
      current_user.up_votes(obj)
      redirect_to :back
    else
      current_user.down_votes(obj)
      redirect_to :back
    end
  end
  
  def comment
    book = Book.find params[:id]
    text = params[:comment_text]    
    comment = Comment.build_from( book, current_user.id, text )
    if comment.save 
      if(params[:parent])
        comment.move_to_child_of(Comment.find params[:parent])
      end
      redirect_to :back, notice: "Comment added successfully"
    else
      redirect_to :back, error: "Failed to add comment"
    end
  end

  def review
    user = current_user
    book = Book.find params[:id]
    review = Review.create params[:review]
    if review
      book.reviews << review
      user.reviews << review
      redirect_to :back, notice: "Review added successfully"
    else
      redirect_to :back, notice: "Failed to add review"
    end
  end

end
