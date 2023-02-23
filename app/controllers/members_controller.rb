class MembersController < ApplicationController

  def index
    render json: Member.all
  end

  def create
    member = Member.new(params.permit(:name))
    if member.save
      render json: { success: true, member: member }
    else
      render json: { success: false, message: "Could not create member!" }
    end
  end

  def borrows
    render json: Borrow.where(member_id: params[:id])
  end
end
