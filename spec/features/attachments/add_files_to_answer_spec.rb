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
end
