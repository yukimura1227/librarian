# controller for books
class BooksController < ApplicationController
  before_action :set_book, only: [:edit, :update, :rental, :want_to_read, :return]

  # GET /books
  # GET /books.json
  def index
    @q = Book.search(params[:q])
    @books = @q.result.includes(:order).includes(:user).page(params[:page]).per(20)
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
    respond_to do |format|
      if @book.save
        current_user.rental_operations.create(book: @book)
        format.js { render :rental}
        format.html { redirect_to books_path, notice: "#{@book.title}を借りました。" }
      else
        redirect_to books_path, alert: "「#{@book.title}」を借りるのに失敗しました。"
      end
    end
  end

  def want_to_read
    @book.notify_slack_for_want_to_rent(current_user)
    respond_to do |format|
      format.js { render :want_to_read }
    end
  end

  def return
    @book.user = nil
    if @book.save
      current_user.return_operations.create(book: @book)
      redirect_to books_path, notice: "#{@book.title}を返しました。"
    else
      redirect_to books_path, alert: "「#{@book.title}」を返すのに失敗しました。"
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params[:id])
    @book = @book.decorate
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def book_params
    params.require(:book).permit(:location)
  end
end
