require "spec_helper"

describe "Create Note Spec", type: :feature do
  it "should create a note and redirect to the 'show page' of the note" do
    visit "/"
    click_link_or_button "Create Note"
    expect(page).to have_content "Create a Note"
    expect(current_path).to eq("/notes/new")

    fill_in "Note Title", with: "Test Note"
    select "Soft-Skills", from: "category"
    fill_in "content", with: "Note content"
    find("input[type='submit']").click

    expect(page).to have_content "Show Note"
    expect(page).to have_content "Test Note"
    expect(page).to have_content "Note content"
    expect(page).to have_content "soft-skills"
    expect(page).to have_content "edit"
    expect(page).to have_content "delete"
    expect(page).to have_selector(".btn")
    expect(current_path).to eq("/notes/1")
  end
end
