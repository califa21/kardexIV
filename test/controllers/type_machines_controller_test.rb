require 'test_helper'

class TypeMachinesControllerTest < ActionController::TestCase
  setup do
    @type_machine = type_machines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:type_machines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create type_machine" do
    assert_difference('TypeMachine.count') do
      post :create, type_machine: {  }
    end

    assert_redirected_to type_machine_path(assigns(:type_machine))
  end

  test "should show type_machine" do
    get :show, id: @type_machine
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @type_machine
    assert_response :success
  end

  test "should update type_machine" do
    patch :update, id: @type_machine, type_machine: {  }
    assert_redirected_to type_machine_path(assigns(:type_machine))
  end

  test "should destroy type_machine" do
    assert_difference('TypeMachine.count', -1) do
      delete :destroy, id: @type_machine
    end

    assert_redirected_to type_machines_path
  end
end
