require "spec_helper"

describe "Update Note Spec", type: :feature do
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

    click_link "edit"
    expect(page).to have_content "Edit Note"
    expect(current_path).to eq("/notes/1/edit")

    fill_in "Note Title", with: "Test Note - updated"
    select "Soft-Skills", from: "category"
    fill_in "content", with: "Test content - updated"
    find("input[type='submit']").click

    expect(page).to have_content "Show Note"
    expect(page).to have_content "Test Note - updated"
    expect(page).to have_content "Test content - updated"
    expect(page).to have_content "soft-skills"
    expect(page).to have_content "edit"
    expect(page).to have_content "delete"
    expect(page).to have_selector(".btn")
    expect(current_path).to eq("/notes/1")
  end
end
