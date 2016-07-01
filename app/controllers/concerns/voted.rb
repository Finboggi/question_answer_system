module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: [:vote_for, :vote_against, :unvote]

    include VotesHelper
  end

  def vote_for
    @vote = @votable.vote_for current_user
    vote
  end

  def vote_against
    @vote = @votable.vote_against current_user
    vote
  end

  def unvote
    @vote = @votable.user_vote current_user

    if @vote.destroy!
      flash[:success] = t('votes.unvote.success')
      vote_render_success
    else
      vote_render_error
    end
  end

  private

  def model_klass
    controller_name.singularize.classify.constantize
  end

  def param_id_name
    controller_name.singularize.classify.downcase + '_id'
  end

  def find_votable
    @votable = model_klass.find(params[param_id_name])
  end

  def vote_success_message
    @vote.positive? ? t('votes.for.success') : t('votes.against.success')
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

  def vote
    if @vote.save
      flash[:success] = vote_success_message
      vote_render_success
    else
      vote_render_error
    end
  end
end
