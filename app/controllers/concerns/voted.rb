module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: [:vote, :unvote]
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

  def unvote
    @vote = @votable.votes.where(user: current_user).first
    flash[:success] = t('votes.unvote.success') if @vote.destroy!
    render :text => '', :layout => nil
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def param_id_name
    controller_name.classify.downcase + '_id'
  end

  def find_votable
    @votable = model_klass.find(params[param_id_name])
  end

  # TODO: в value интересует только знак, на самом деле всегда +/- 1
  def vote_params
    params.require(:vote).permit(:value)
  end

  def vote_value
    vote_positive? ? 1 : -1
  end

  def vote_success_message
    vote_positive? ? t('votes.for.success') : t('votes.against.success')
  end

  def vote_positive?
    vote_params[:value].to_i > 0
  end
end