require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let!(:questions) { create_pair(:question) }
    before { get :index }

    it 'assigns all questions to @questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    create_user_and_sign_in
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds a new Attachment for @question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
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

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders :show question view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    create_user_and_sign_in
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

      it 'user authors new answer' do
        post :create, question: question_attributes
        expect(assigns(:question).user_id).to eq @user.id
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

  describe 'Questions manipulation' do
    create_user_and_sign_in
    let!(:question) { create(:question, user: @user) }
    let!(:question_not_owned) { create(:question) }

    describe 'DELETE #destroy' do
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
            .to_not change(Question, :count)
        end

        it 'renders :show view' do
          delete :destroy, id: question_not_owned
          expect(response).to redirect_to question_path(question_not_owned)
        end
      end
    end

    describe 'GET #edit' do
      context 'question is edited by owner' do
        before { xhr :get, :edit, format: :js, id: question }

        it 'assigns the requested Question to @question' do
          expect(assigns(:question)).to eq question
        end

        it 'renders :show question view' do
          expect(response).to render_template :edit
        end

        it { should_not set_flash.now[:alert] }
      end

      context 'question is edited by not owner' do
        before { xhr :get, :edit, format: :js, id: question_not_owned }

        it_has_403_answer
      end
    end

    describe 'PUT #update' do
      context 'question is updated by owner' do
        before { question.body = 'Alter question body' }
        before { xhr :put, :update, format: :js, id: question.id, question: question.attributes }

        it 'assigns the sended Question to @question' do
          expect(assigns(:question)).to eq question
          expect(assigns(:question).reload.body).to eq question.body
        end

        it 'renders :update question view' do
          expect(response).to render_template :update
        end

        it { should_not set_flash.now[:alert] }
      end

      context 'question is updated by not owner' do
        before do
          question_not_owned.body = 'Alter question body'
          xhr :put,
              :update,
              format: :js, id: question_not_owned.id, question: question_not_owned.attributes
        end

        it 'assigns the old Question to @question' do
          expect(assigns(:question)).to eq question_not_owned
          expect(assigns(:question).reload.body).to_not eq question_not_owned.body
        end

        it_has_403_answer
      end
    end
  end
end
