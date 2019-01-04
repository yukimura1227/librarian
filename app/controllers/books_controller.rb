# controller for books
class BooksController < ApplicationController
  before_action :set_book, only: [:edit, :update, :rental, :return]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all.includes(:order).includes(:user)
  end

  # GET /books/1/edit
  def edit
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to books_path, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def rental
    @book.user = current_user
    @book.save
    redirect_to books_path, notice: "#{@book.title}を借りました。"
  end

  def return
    @book.user = nil
    @book.save
    redirect_to books_path, notice: "#{@book.title}を返しました。"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def book_params
    params.require(:book).permit(:location)
  end
end
