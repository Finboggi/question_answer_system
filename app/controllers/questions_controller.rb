class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  def new
    @question = Question.new
  end

  def index
    @questions = Question.all
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      flash[:notice] = I18n.t 'question_created'
      redirect_to @question
    else
      render :new
    end
  end

  def show
    @question = Question.find(params[:id])
    @answers = @question.answers
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
