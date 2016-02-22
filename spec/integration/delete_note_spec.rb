require "spec_helper"

describe "Delete Note Spec", type: :feature do
  it "updates an existing note" do
    create_note

    visit "/"
    click_link_or_button "All Notes"
    expect(page).to have_content "Existing Notes"
    expect(page).to have_content "Test Note"
    expect(current_path).to eq("/notes")

    click_link "Test Note"
    expect(page).to have_content "Show Note"
    expect(page).to have_content "Test Note"
    expect(current_path).to eq("/notes/1")

    click_link "delete"
    expect(page).to have_content "Existing Notes"
    expect(page).to have_no_content "Test Note"
    expect(current_path).to eq("/notes")
  end
end
