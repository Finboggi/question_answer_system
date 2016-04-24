class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question
  before_action :find_answer, only: [:destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    flash[:success] = I18n.t('answers.new.success') if @answer.save
  end

  def destroy
    @success = false
    if current_user.author_of?(@answer)
      flash[:notice] = I18n.t('answers.delete.success')
      @success = true if @answer.destroy!
    else
      flash[:alert] = I18n.t('answers.delete.not_owner')
    end
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
