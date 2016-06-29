module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: [:vote, :unvote]

    include VotesHelper
  end

  def vote
    @vote = vote_new

    respond_to do |format|
      if @vote.save
        flash[:success] = vote_success_message
        format.json { vote_render_success }
      else
        format.json { vote_render_error }
      end
    end
  end

  def unvote
    @vote = @votable.user_vote current_user

    respond_to do |format|
      if @vote.destroy!
        flash[:success] = t('votes.unvote.success')
        format.json { vote_render_success }
      else
        format.json { vote_render_error }
      end
    end
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

  def vote_params
    params.require(:vote).permit(:value)
  end

  def vote_success_message
    @vote.positive? ? t('votes.for.success') : t('votes.against.success')
  end

  def vote_new_hash
    {
      votable: @votable,
      user_id: current_user.id,
      value: vote_params[:value]
    }
  end

  def vote_new
    @votable.votes.new vote_new_hash
  end

  def vote_render_error
    render json: { errors: @vote.errors.full_messages },
           status: :unprocessable_entity
  end

  def vote_render_success
    render json: {
      vote: @vote,
      votes_sum: @votable.votes_sum,
      vote_marker: voted_marker(@votable)
    }
  end
end
