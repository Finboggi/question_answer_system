module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: [:vote]
  end

  def vote
    @vote = @votable.votes.new( {
        votable: @votable,
        user_id: current_user.id,
        value: vote_value
                                } )
    flash[:success] = vote_success_message if @vote.save

    respond_to do |format|
      format.json { render json: { vote: @vote } }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end

  # TODO: в value интересует только знак, на самом деле всегда +/- 1
  def vote_params
    params.require(:vote).permit(:value)
  end

  def vote_value
    vote_params[:value].to_i > 0 ? 1 : -1
  end

  def vote_success_message
    vote_params[:value].to_i > 0 ? t('votes.for.success') : t('votes.against.success')
  end
end