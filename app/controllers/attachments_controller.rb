class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment

  def destroy
    if current_user.author_of?(@attachment.attachable)
      flash[:notice] = I18n.t('attachments.delete.success')
      @attachment.destroy!
    else
      flash[:alert] = I18n.t('attachments.delete.not_owner')
      render status: :forbidden
    end
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end
end
