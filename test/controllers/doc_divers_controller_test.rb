require 'test_helper'

class DocDiversControllerTest < ActionController::TestCase
  setup do
    @doc_diver = doc_divers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:doc_divers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create doc_diver" do
    assert_difference('DocDiver.count') do
      post :create, doc_diver: {  }
    end

    assert_redirected_to doc_diver_path(assigns(:doc_diver))
  end

  test "should show doc_diver" do
    get :show, id: @doc_diver
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @doc_diver
    assert_response :success
  end

  test "should update doc_diver" do
    patch :update, id: @doc_diver, doc_diver: {  }
    assert_redirected_to doc_diver_path(assigns(:doc_diver))
  end

  test "should destroy doc_diver" do
    assert_difference('DocDiver.count', -1) do
      delete :destroy, id: @doc_diver
    end

    assert_redirected_to doc_divers_path
  end
end
