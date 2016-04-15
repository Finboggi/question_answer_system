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
        expect { post :create, format: 'js', question_id: question.id, answer: attributes_for(:answer) }
          .to change(question.answers, :count).by(1)
      end

      it 'render js with new answer' do
        post :create, format: 'js', question_id: question.id, answer: attributes_for(:answer)
        expect(response).to render_template :create
      end

      it 'user authors new answer' do
        post :create, format: 'js', question_id: question.id, answer: attributes_for(:answer)
        expect(assigns(:answer).user_id).to eq @user.id
      end
    end

    context 'with invalid answer' do
      sign_in_user
      it 'does not add answer to database' do
        expect { post :create, format: 'js', question_id: question.id, answer: attributes_for(:invalid_answer) }
          .to_not change(Answer, :count)
      end

      it 're-renders :create answer view' do
        post :create, format: 'js', question_id: question.id, answer: attributes_for(:invalid_question)
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:answer) { create(:answer, user: @user) }
    let!(:answer_not_owned) { create(:answer) }

    context 'answer is deleted by owner' do
      it 'deletes answer' do
        expect { delete :destroy, id: answer, question_id: answer.question }
          .to change(Answer, :count).by(-1)
      end

      it 'renders #question page' do
        delete :destroy, id: answer, question_id: answer.question
        expect(response).to redirect_to question_path(answer.question)
      end
    end
    context 'question is deleted by not owner' do
      it 'deletes question' do
        expect { delete :destroy, id: answer_not_owned, question_id: answer_not_owned.question }
          .to_not change(Answer, :count)
      end

      it 'renders :show view' do
        delete :destroy, id: answer_not_owned, question_id: answer_not_owned.question
        expect(response).to redirect_to question_path(answer_not_owned.question)
      end
    end
  end
end
