class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :find_question, only: [:show, :destroy]

  def new
    @question = Question.new
  end

  def index
    @questions = Question.all
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      flash[:notice] = I18n.t 'questions.new.success'
      redirect_to @question
    else
      render :new
    end
  end

  def show
    @answers = @question.answers
  end

  def destroy
    if !current_user.nil? && @question.user_id == current_user.id
      flash[:notice] = I18n.t('questions.delete.success')
      @question.destroy!
      redirect_to root_path
    else
      flash[:alarm] = I18n.t('questions.delete.not_owner')
      redirect_to @question
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, :user_id).merge(user: current_user)
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
