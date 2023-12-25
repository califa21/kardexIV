require 'test_helper'

class ExecCnEquipementsControllerTest < ActionController::TestCase
  setup do
    @exec_cn_equipement = exec_cn_equipements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exec_cn_equipements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create exec_cn_equipement" do
    assert_difference('ExecCnEquipement.count') do
      post :create, exec_cn_equipement: {  }
    end

    assert_redirected_to exec_cn_equipement_path(assigns(:exec_cn_equipement))
  end

  test "should show exec_cn_equipement" do
    get :show, id: @exec_cn_equipement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @exec_cn_equipement
    assert_response :success
  end

  test "should update exec_cn_equipement" do
    patch :update, id: @exec_cn_equipement, exec_cn_equipement: {  }
    assert_redirected_to exec_cn_equipement_path(assigns(:exec_cn_equipement))
  end

  test "should destroy exec_cn_equipement" do
    assert_difference('ExecCnEquipement.count', -1) do
      delete :destroy, id: @exec_cn_equipement
    end

    assert_redirected_to exec_cn_equipements_path
  end
end
