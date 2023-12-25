require 'test_helper'

class PotentielMachinesControllerTest < ActionController::TestCase
  setup do
    @potentiel_machine = potentiel_machines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:potentiel_machines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create potentiel_machine" do
    assert_difference('PotentielMachine.count') do
      post :create, potentiel_machine: {  }
    end

    assert_redirected_to potentiel_machine_path(assigns(:potentiel_machine))
  end

  test "should show potentiel_machine" do
    get :show, id: @potentiel_machine
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @potentiel_machine
    assert_response :success
  end

  test "should update potentiel_machine" do
    patch :update, id: @potentiel_machine, potentiel_machine: {  }
    assert_redirected_to potentiel_machine_path(assigns(:potentiel_machine))
  end

  test "should destroy potentiel_machine" do
    assert_difference('PotentielMachine.count', -1) do
      delete :destroy, id: @potentiel_machine
    end

    assert_redirected_to potentiel_machines_path
  end
end
