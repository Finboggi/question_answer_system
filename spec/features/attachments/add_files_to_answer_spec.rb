require_relative '../feature_helper'

feature 'add files to answer', %q(
  In order to illustrate my answer
  as answer's author
  I'd like to be able to attach files
) do
  scenario 'User adds files when asks answer', js: true do
    question = create(:question)
    answer = build(:answer)
    sign_in(create(:user))
    visit question_path(question)

    fill_in 'Body', with: answer.body
    all('.upload_file input[type="file"]').each do |input|
      attach_file input[:name], 'Gemfile.lock'
    end
    click_on I18n.t('answers.new.button')

    expect(page).to have_link 'Gemfile.lock', href: '/uploads/attachment/file/1/Gemfile.lock'
  end

  scenario 'Authorized user trying to add file while updating his question', js: true do
    question = create(:question, :with_answers)
    answer = question.answers.first

    login_as(answer.user)
    visit question_path(question)

    within "#answer_#{answer.id}" do
      click_on I18n.t 'answers.edit.link'
    end

    within '#edit_answer' do
      input = find '.upload_file input[type="file"]'
      attach_file input[:name], 'Gemfile.lock'
      click_on I18n.t 'answers.edit.button'
    end

    expect(page).to have_link 'Gemfile.lock', href: '/uploads/attachment/file/1/Gemfile.lock'
  end
end
