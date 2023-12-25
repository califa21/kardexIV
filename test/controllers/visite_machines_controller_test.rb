require 'test_helper'

class VisiteMachinesControllerTest < ActionController::TestCase
  setup do
    @visite_machine = visite_machines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:visite_machines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create visite_machine" do
    assert_difference('VisiteMachine.count') do
      post :create, visite_machine: {  }
    end

    assert_redirected_to visite_machine_path(assigns(:visite_machine))
  end

  test "should show visite_machine" do
    get :show, id: @visite_machine
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @visite_machine
    assert_response :success
  end

  test "should update visite_machine" do
    patch :update, id: @visite_machine, visite_machine: {  }
    assert_redirected_to visite_machine_path(assigns(:visite_machine))
  end

  test "should destroy visite_machine" do
    assert_difference('VisiteMachine.count', -1) do
      delete :destroy, id: @visite_machine
    end

    assert_redirected_to visite_machines_path
  end
end
