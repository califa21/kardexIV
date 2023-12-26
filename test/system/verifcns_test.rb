require "application_system_test_case"

class VerifcnsTest < ApplicationSystemTestCase
  setup do
    @verifcn = verifcns(:one)
  end

  test "visiting the index" do
    visit verifcns_url
    assert_selector "h1", text: "Verifcns"
  end

  test "creating a Verifcn" do
    visit verifcns_url
    click_on "New Verifcn"

    click_on "Create Verifcn"

    assert_text "Verifcn was successfully created"
    click_on "Back"
  end

  test "updating a Verifcn" do
    visit verifcns_url
    click_on "Edit", match: :first

    click_on "Update Verifcn"

    assert_text "Verifcn was successfully updated"
    click_on "Back"
  end

  test "destroying a Verifcn" do
    visit verifcns_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Verifcn was successfully destroyed"
  end
end
