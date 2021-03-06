class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :find_question, only: [:show, :destroy, :edit, :update]

  include Voted

  def new
    @question = Question.new
    @question.attachments.build
  end

  def index
    @questions = Question.all
  end

  def create
    @question = Question.new(question_params.merge(user: current_user))

    if @question.save
      flash[:notice] = t 'questions.new.success'
      redirect_to @question
    else
      render :new
    end
  end

  def show
    @answers = @question.answers
    @answer = Answer.new(question: @question)
    @answer.attachments.build
  end

  def destroy
    if current_user.author_of?(@question)
      flash[:notice] = t('questions.delete.success')
      @question.destroy!
      redirect_to root_path
    else
      flash[:alert] = t('questions.delete.not_owner')
      redirect_to @question
    end
  end

  def edit
    @question.attachments.build
    unless current_user.author_of?(@question)
      flash[:alert] = t('questions.edit.not_owner')
      render status: :forbidden
    end
  end

  def update
    if current_user.author_of?(@question)
      flash[:notice] =
        t('questions.update.success') if @question.update_attributes question_params
    else
      flash[:alert] = t('questions.update.not_owner')
      render status: :forbidden
    end
  end

  private

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      attachments_attributes: [:id, :file, :_destroy]
    )
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
