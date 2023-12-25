require 'test_helper'

class PageAccesControllerTest < ActionController::TestCase
  setup do
    @page_acce = page_acces(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:page_acces)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page_acce" do
    assert_difference('PageAcce.count') do
      post :create, page_acce: {  }
    end

    assert_redirected_to page_acce_path(assigns(:page_acce))
  end

  test "should show page_acce" do
    get :show, id: @page_acce
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @page_acce
    assert_response :success
  end

  test "should update page_acce" do
    patch :update, id: @page_acce, page_acce: {  }
    assert_redirected_to page_acce_path(assigns(:page_acce))
  end

  test "should destroy page_acce" do
    assert_difference('PageAcce.count', -1) do
      delete :destroy, id: @page_acce
    end

    assert_redirected_to page_acces_path
  end
end
