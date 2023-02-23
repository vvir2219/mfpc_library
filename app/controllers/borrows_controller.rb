class BorrowsController < ApplicationController

  def index
    render json: Borrow.all
  end

  def create
    book = Book.find_by_id(params[:book_id])
    member = Member.find_by_id(params[:member_id])
    return render json: { success: false, message: 'Cannot find book to borrow' } if book.blank?
    return render json: { success: false, message: 'Book is already borrowed' } if !book.available
    return render json: { success: false, message: 'Cannot find member' } if member.blank?

    book.update(available: false)
    borrow = Borrow.new(params.permit(:book_id, :member_id, :expiration_date))
    if borrow.save
      render json: { success: true, borrow: borrow }
    else
      render json: { success: false, message: 'Could not borrow book' }
    end
  end

  def return_book
    borrow = Borrow.find_by_id(params[:id])
    return render json: { success: false, message: 'Borrow cannot be found' } if borrow.blank?
    return render json: { success: false, message: 'Book is already returned' } if borrow.book.available
    return render json: { success: false, message: 'This borrow has already been fulfilled' } if borrow.returned_at.present?

    borrow.book.update(available: true)
    borrow&.update(returned_at: DateTime.now)
    render json: { success: true }
  end
end
