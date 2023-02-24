class BorrowsController < ApplicationController

  # params @returned [ True / False ]
  def index
    borrows = Borrow.includes(:member).includes(:book)
    if params[:returned].present?
      returned = ActiveModel::Type::Boolean.new.cast(params[:returned])
      if returned
        borrows = borrows.where.not(returned_at: nil)
      else
        borrows = borrows.where(returned_at: nil)
      end
    end

    borrows = borrows.map do |borrow|
      {
        id: borrow.id,
        book_id: borrow.book_id,
        book_title: borrow.book.title,
        member_id: borrow.member_id,
        member_name: borrow.member.name,
        created_at: borrow.created_at,
        expiration_date: borrow.expiration_date,
        returned_at: borrow.returned_at
      }.compact
    end

    render json: borrows
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
