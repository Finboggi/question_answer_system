class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question
  before_action :find_answer, only: [:destroy, :edit, :update]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    flash[:success] = I18n.t('answers.new.success') if @answer.save
  end

  def destroy
    if current_user.author_of?(@answer)
      flash[:notice] = I18n.t('answers.delete.success')
      @answer.destroy!
    else
      flash[:alert] = I18n.t('answers.delete.not_owner')
    end
  end

  def edit
    flash[:alert] = I18n.t('answers.edit.not_owner') unless current_user.author_of?(@answer)
  end

  def update
    if current_user.author_of?(@answer)
      flash[:notice] = I18n.t('answers.update.success') if @answer.update_attributes answer_params
    else
      flash[:alert] = I18n.t('answers.update.not_owner')
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
