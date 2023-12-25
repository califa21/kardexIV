require 'test_helper'

class VisiteProtocolaireEquipementsControllerTest < ActionController::TestCase
  setup do
    @visite_protocolaire_equipement = visite_protocolaire_equipements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:visite_protocolaire_equipements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create visite_protocolaire_equipement" do
    assert_difference('VisiteProtocolaireEquipement.count') do
      post :create, visite_protocolaire_equipement: {  }
    end

    assert_redirected_to visite_protocolaire_equipement_path(assigns(:visite_protocolaire_equipement))
  end

  test "should show visite_protocolaire_equipement" do
    get :show, id: @visite_protocolaire_equipement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @visite_protocolaire_equipement
    assert_response :success
  end

  test "should update visite_protocolaire_equipement" do
    patch :update, id: @visite_protocolaire_equipement, visite_protocolaire_equipement: {  }
    assert_redirected_to visite_protocolaire_equipement_path(assigns(:visite_protocolaire_equipement))
  end

  test "should destroy visite_protocolaire_equipement" do
    assert_difference('VisiteProtocolaireEquipement.count', -1) do
      delete :destroy, id: @visite_protocolaire_equipement
    end

    assert_redirected_to visite_protocolaire_equipements_path
  end
end
