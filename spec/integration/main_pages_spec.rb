require "spec_helper"

describe "Main Application Pages", type: :feature do
  it "has index page" do
    visit "/"
    expect(page).to have_content "iNoteBook"
    expect(page).to have_content "iNote Book"
    expect(page).to have_content "Keep Them Organized"
    expect(page).to have_content "Responsive Design"
    expect(page).to have_selector("a.btn")
  end

  it "has 'about' page" do
    visit "/"
    click_link "About"
    expect(page).to have_content "iNoteBook"
    expect(current_path).to eq("/about")
  end

  it "has 'about' page" do
    visit "/page/not/found"
    expect(page).to have_content "404 Error"
    expect(page).to have_content "Page not found"
    expect(current_path).to eq("/page/not/found")
  end
end
