require 'rails_helper'

feature 'delete answer', %q{
  In order to remove my answer from system
  As an authenticated user
  I want to be able to delete answer
} do

  scenario 'Authenticated user tries to delete answer he created'
  scenario 'Authenticated user tries to delete answer of another user'
  scenario 'Non-authenticated user tries to delete answer'
end