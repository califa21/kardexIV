require 'test_helper'

class BonLancementsControllerTest < ActionController::TestCase
  setup do
    @bon_lancement = bon_lancements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bon_lancements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bon_lancement" do
    assert_difference('BonLancement.count') do
      post :create, bon_lancement: {  }
    end

    assert_redirected_to bon_lancement_path(assigns(:bon_lancement))
  end

  test "should show bon_lancement" do
    get :show, id: @bon_lancement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bon_lancement
    assert_response :success
  end

  test "should update bon_lancement" do
    patch :update, id: @bon_lancement, bon_lancement: {  }
    assert_redirected_to bon_lancement_path(assigns(:bon_lancement))
  end

  test "should destroy bon_lancement" do
    assert_difference('BonLancement.count', -1) do
      delete :destroy, id: @bon_lancement
    end

    assert_redirected_to bon_lancements_path
  end
end
