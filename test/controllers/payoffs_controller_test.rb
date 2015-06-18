require 'test_helper'

class PayoffsControllerTest < ActionController::TestCase
  setup do
    @payoff = payoffs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payoffs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create payoff" do
    assert_difference('Payoff.count') do
      post :create, payoff: {  }
    end

    assert_redirected_to payoff_path(assigns(:payoff))
  end

  test "should show payoff" do
    get :show, id: @payoff
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @payoff
    assert_response :success
  end

  test "should update payoff" do
    patch :update, id: @payoff, payoff: {  }
    assert_redirected_to payoff_path(assigns(:payoff))
  end

  test "should destroy payoff" do
    assert_difference('Payoff.count', -1) do
      delete :destroy, id: @payoff
    end

    assert_redirected_to payoffs_path
  end
end
