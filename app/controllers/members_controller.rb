class MembersController < ApplicationController

  def index
    render json: Member.all
  end

  def show
    render json: Member.find_by_id(params[:id])
  end

  def create
    member = Member.new(params.permit(:name))
    if member.save
      render json: { success: true, member: member }
    else
      render json: { success: false, message: "Could not create member!" }
    end
  end

  # params @returned [ True / False ]
  def borrows
    borrows = Borrow.includes(:member).includes(:book).where(member_id: params[:id])
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
end
