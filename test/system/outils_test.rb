require "application_system_test_case"

class OutilsTest < ApplicationSystemTestCase
  setup do
    @outil = outils(:one)
  end

  test "visiting the index" do
    visit outils_url
    assert_selector "h1", text: "Outils"
  end

  test "creating a Outil" do
    visit outils_url
    click_on "New Outil"

    click_on "Create Outil"

    assert_text "Outil was successfully created"
    click_on "Back"
  end

  test "updating a Outil" do
    visit outils_url
    click_on "Edit", match: :first

    click_on "Update Outil"

    assert_text "Outil was successfully updated"
    click_on "Back"
  end

  test "destroying a Outil" do
    visit outils_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Outil was successfully destroyed"
  end
end
