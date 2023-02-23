class BooksController < ApplicationController

  def index
    render json: Book.all
  end

  def available_books
    render json: Book.where(available: true)
  end

  # param @query
  # param @available
  def search
    return render json: [] if params[:query].blank?

    query = "%#{params[:query]&.downcase}%"
    books = Book.where('lower(title) like ? or lower(author) like ?', query, query)
    if params[:available].present?
      books = books.where(available: ActiveModel::Type::Boolean.new.cast(params[:available]))
    end

    render json: books
  end

  def show
    render json: Book.find_by_id(params[:id])
  end

  def create
    book = Book.create(params.permit(:title, :author))
    if book.save
      render json: { success: true, book: book }
    else
      render json: { success: false, message: "Book could not be created" }
    end
  end

  def destroy
    book = Book.find_by_id(params[:id])
    if book.present?
      book.destroy
      render json: { success: true }
    else
      render json: { success: false, message: "Book with id #{params[:id]} not found!" }
    end
  end
end
