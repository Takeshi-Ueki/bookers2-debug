class BooksController < ApplicationController
  impressionist :acrions => [:show]
  before_action :ensure_correct_user, only:[:edit]

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_post = Book.new
    @book_comment = BookComment.new

    impressionist(@book, nil, unique: [:session_hash.to_s])
  end

  def index
    @books = Book.all.order(params[:sort])
    # to = Time.current.end_of_day
    # from = (to - 6.day).beginning_of_day
    # @books = Book.all.sort { |a,b|
    #   b.favorites.where(created_at: from..to).size <=>
    #   a.favorites.where(created_at: from..to).size
    # }
    @book = Book.new

  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    tag_list = params[:book][:tag_name].split(',')
    if @book.save
      @book.save_tags(tag_list)
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def search_tag
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @books = @tag.books.all
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :star)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
