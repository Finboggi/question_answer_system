class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment

  def destroy
    if current_user.author_of?(@attachment.attachable)
      flash[:notice] = t('attachments.delete.success')
      @attachment.destroy!
    else
      flash[:alert] = t('attachments.delete.not_owner')
      render status: :forbidden
    end
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end
end
