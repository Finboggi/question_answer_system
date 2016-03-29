require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let!(:questions) {create_pair(:question) }
    before {get :index}

    it 'assigns all questions to @questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    sign_in_user
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
    sign_in_user
    let(:question_attributes) { build(:question).attributes }

    context 'with valid question' do
      it 'saves the new question to the database' do
        expect { post :create, question: question_attributes }
          .to change(Question, :count).by(1)
      end

      it 'redirect to new Question url' do
        post :create, question: question_attributes
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid question' do
      it 'does not save the new question to the database' do
        expect { post :create, question: build(:invalid_question).attributes }
          .to_not change(Question, :count)
      end

      it 're-renders :new question view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:question) {create(:question, user: @user) }
    let!(:question_not_owned) {create(:question) }

    context 'question is deleted by owner' do
      it 'deletes question' do
        expect { delete :destroy, id: question }
          .to change(Question, :count).by(-1)
      end

      it 'renders #index page' do
        delete :destroy, id: question
        expect(response).to redirect_to root_path
      end
    end
    context 'question is deleted by not owner' do
      it 'deletes question' do
        expect { delete :destroy, id: question_not_owned }
          .to change(Question, :count).by(0)
      end

      it 'renders :show view' do
        delete :destroy, id: question_not_owned
        expect(response).to redirect_to question_path(question_not_owned)
      end
    end
  end
end
