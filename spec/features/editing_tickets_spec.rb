require "rails_helper"

RSpec.feature "Users can edting existing tickets" do
  let(:author) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project)}
  let(:ticket) { FactoryBot.create(:ticket, project: project, author: author)}
  
  before do
    assign_role!(author, :editor, project)
    login_as(author)
    visit project_ticket_path(project, ticket)
    click_link "Edit Ticket"
  end
  
  scenario "With valid attributes" do
    fill_in "Name", with: "Make it really shiny!"
    click_button "Update Ticket"
    
    expect(page).to have_content "Ticket has been updated."
    
    within("#ticket h2") do
      expect(page).to have_content "Make it really shiny!"
      expect(page).to_not have_content ticket.name
    end
  end
  
  scenario "with invalid attributes" do
    fill_in "Name", with: ""
    click_button "Update Ticket"
    
    expect(page).to have_content "Ticket has not been updated."
  end
end