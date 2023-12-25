require 'test_helper'

class ExecCnMachinesControllerTest < ActionController::TestCase
  setup do
    @exec_cn_machine = exec_cn_machines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exec_cn_machines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create exec_cn_machine" do
    assert_difference('ExecCnMachine.count') do
      post :create, exec_cn_machine: {  }
    end

    assert_redirected_to exec_cn_machine_path(assigns(:exec_cn_machine))
  end

  test "should show exec_cn_machine" do
    get :show, id: @exec_cn_machine
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @exec_cn_machine
    assert_response :success
  end

  test "should update exec_cn_machine" do
    patch :update, id: @exec_cn_machine, exec_cn_machine: {  }
    assert_redirected_to exec_cn_machine_path(assigns(:exec_cn_machine))
  end

  test "should destroy exec_cn_machine" do
    assert_difference('ExecCnMachine.count', -1) do
      delete :destroy, id: @exec_cn_machine
    end

    assert_redirected_to exec_cn_machines_path
  end
end
