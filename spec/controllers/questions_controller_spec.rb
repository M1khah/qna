require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do

    before { get :show, id: question }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attr' do
      it 'saves the new question in DB' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with not valid attr' do
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
        expect(response).to render_template :new
      end
    end
  end


  describe 'PATCH #update' do
    sign_in_user
    context 'valid attr' do
      it 'assigns requested question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end

      it 'changes question attrs' do
        patch :update, id: question,  question: { title:'new title', body:'new body' }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to the updated page' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to question
      end
    end

    context 'invalid attrs' do
      before { patch :update, id: question,  question: { title:'new title', body: nil } }
      it 'does not changes question attrs' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before { question }
    it 'deletes question' do
      expect { delete :destroy,id: question }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
        delete :destroy,id: question
        expect(response).to redirect_to questions_path
    end
  end
end
