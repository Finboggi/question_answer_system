require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  describe 'GET #new' do
    sign_in_user
    before { get :new, question_id: question.id }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders :new answer view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid answer' do
      it 'adds answer to database and assigns it to question' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }
          .to change(question.answers, :count).by(1)
      end

      it 'redirects to question' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid answer' do
      sign_in_user
      it 'does not add answer to database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:invalid_answer) }
          .to_not change(Answer, :count)
      end

      it 're-renders :new answer view' do
        post :create, question_id: question.id, answer: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end
end
