require 'test_helper'

class CnMachinesControllerTest < ActionController::TestCase
  setup do
    @cn_machine = cn_machines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cn_machines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cn_machine" do
    assert_difference('CnMachine.count') do
      post :create, cn_machine: {  }
    end

    assert_redirected_to cn_machine_path(assigns(:cn_machine))
  end

  test "should show cn_machine" do
    get :show, id: @cn_machine
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cn_machine
    assert_response :success
  end

  test "should update cn_machine" do
    patch :update, id: @cn_machine, cn_machine: {  }
    assert_redirected_to cn_machine_path(assigns(:cn_machine))
  end

  test "should destroy cn_machine" do
    assert_difference('CnMachine.count', -1) do
      delete :destroy, id: @cn_machine
    end

    assert_redirected_to cn_machines_path
  end
end
