require 'rails_helper'

feature 'user can see all proposals' do
  scenario 'sucessfully' do
    user = create(:user)
    another_user = create(:user)
    owner = create(:user, email: 'owner@teste.com')
    profile = create(:profile, name: 'Joao', user: user)
    profile = create(:profile, name: 'Joao', user: owner)
    create(:profile, name: 'Joao', user: another_user)

    ad = create(:ad, user: another_user, requested_knowledge: 'aprender Ruby on Rails!',
                     status: :active)
    create(:proposal, ad: ad, status: :approved,
                      requested_knowledge: 'aprender Ruby on Rails!')

    ad2 = create(:ad, user: another_user, requested_knowledge: 'Quero aprender Piano!',
                      status: :active)
    create(:proposal, ad: ad2, status: :pending,
                      requested_knowledge: 'Quero aprender Piano!')

    ad3 = create(:ad, user: another_user, requested_knowledge: 'aprender guitarra!',
                      status: :active)
    create(:proposal, ad: ad3, status: :rejected,
                      requested_knowledge: 'aprender guitarra!')

    login_as(another_user)
    visit root_path
    click_on 'Propostas recebidas'

    expect(page).to have_css('h2', text: 'Minhas propostas')

    within("div\#proposal-approved") do
      expect(page).to have_content('aprender Ruby on Rails!')
      expect(page).not_to have_content('Quero aprender Piano!')
      expect(page).not_to have_content('aprender guitarra!')
      expect(page).to have_css('h3', text: 'Aprovadas')
    end

    within("div\#proposal-pending") do
      expect(page).to have_content('Quero aprender Piano!')
      expect(page).not_to have_content('aprender Ruby on Rails!')
      expect(page).not_to have_content('aprender guitarra!')
      expect(page).to have_css('h3', text: 'Pendentes')
    end

    within("div\#proposal-rejected") do
      expect(page).to have_content('aprender guitarra!')
      expect(page).not_to have_content('Quero aprender Piano!')
      expect(page).not_to have_content('aprender Ruby on Rails!')
      expect(page).to have_css('h3', text: 'Rejeitadas')
    end
  end
end
