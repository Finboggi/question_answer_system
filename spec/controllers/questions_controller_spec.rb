require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before {get :index}

    it 'assigns all questions to @questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders :new question view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    before { get :show, id: question }
    it 'assigns the requested Question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders :show question view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    context 'with valid question' do
      it 'saves the new question to the database' do
        expect { post :create, question: attributes_for(:question) }
          .to change(Question, :count).by(1)
      end

      it 'redirect to new Question url' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid question' do
      it 'does not save the new question to the database' do
        expect { post :create, question: attributes_for(:invalid_question) }
          .to_not change(Question, :count)
      end

      it 're-renders :new question view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end
end
