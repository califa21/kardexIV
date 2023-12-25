require 'test_helper'

class VisiteProtocolairesControllerTest < ActionController::TestCase
  setup do
    @visite_protocolaire = visite_protocolaires(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:visite_protocolaires)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create visite_protocolaire" do
    assert_difference('VisiteProtocolaire.count') do
      post :create, visite_protocolaire: {  }
    end

    assert_redirected_to visite_protocolaire_path(assigns(:visite_protocolaire))
  end

  test "should show visite_protocolaire" do
    get :show, id: @visite_protocolaire
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @visite_protocolaire
    assert_response :success
  end

  test "should update visite_protocolaire" do
    patch :update, id: @visite_protocolaire, visite_protocolaire: {  }
    assert_redirected_to visite_protocolaire_path(assigns(:visite_protocolaire))
  end

  test "should destroy visite_protocolaire" do
    assert_difference('VisiteProtocolaire.count', -1) do
      delete :destroy, id: @visite_protocolaire
    end

    assert_redirected_to visite_protocolaires_path
  end
end
