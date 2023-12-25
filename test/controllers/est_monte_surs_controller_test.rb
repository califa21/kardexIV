require 'test_helper'

class EstMonteSursControllerTest < ActionController::TestCase
  setup do
    @est_monte_sur = est_monte_surs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:est_monte_surs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create est_monte_sur" do
    assert_difference('EstMonteSur.count') do
      post :create, est_monte_sur: {  }
    end

    assert_redirected_to est_monte_sur_path(assigns(:est_monte_sur))
  end

  test "should show est_monte_sur" do
    get :show, id: @est_monte_sur
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @est_monte_sur
    assert_response :success
  end

  test "should update est_monte_sur" do
    patch :update, id: @est_monte_sur, est_monte_sur: {  }
    assert_redirected_to est_monte_sur_path(assigns(:est_monte_sur))
  end

  test "should destroy est_monte_sur" do
    assert_difference('EstMonteSur.count', -1) do
      delete :destroy, id: @est_monte_sur
    end

    assert_redirected_to est_monte_surs_path
  end
end
