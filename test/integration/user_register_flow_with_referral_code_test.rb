require "test_helper"

class UserRegisterFlowWithReferralCodeTest < ActionDispatch::IntegrationTest
  test "user can register in the API with a referral code and gain credit" do
    request_params = {
      name: 'Vasil Rashkov',
      email: 'my_email@gmail.com',
      password: 'simplepassword!'
    }

    post "/user", params: request_params
    assert_response :success

    my_user_id = JSON.parse(response.body)['data']['id']
    user = User.find(my_user_id)

    request_params_with_code = {
      name: 'Vasil Rashkov',
      email: 'my_email@ggmail.com',
      password: 'simplepassword!',
      referral_code: user.referral_code
    }

    post "/user", params: request_params_with_code
    assert_response :success

    user_id = JSON.parse(response.body)['data']['id']
    user_with_credit = User.find(user_id)
    user_credit = UserCredit.find_by_user_id(user_id)

    assert user_with_credit
    assert user_credit
    assert_equal user_credit.credit, 10
  end

  test "user will gain credit after 5 people sign up with his referral code" do
    request_params = {
      name: 'Vasil Rashkov',
      email: 'my_email@gmail.com',
      password: 'simplepassword!'
    }

    post "/user", params: request_params
    assert_response :success

    my_user_id = JSON.parse(response.body)['data']['id']
    user = User.find(my_user_id)

    register_user_with_referral_code('my_email@ggmail.com', user.referral_code)
    register_user_with_referral_code('my_email@ggmail.com2', user.referral_code)
    register_user_with_referral_code('my_email@ggmail.com3', user.referral_code)
    register_user_with_referral_code('my_email@ggmail.com4', user.referral_code)

    user_credit = UserCredit.find_by_user_id(my_user_id)
    assert_not user_credit

    register_user_with_referral_code('my_email@ggmail.com5', user.referral_code)

    user_credit = UserCredit.find_by_user_id(my_user_id)

    assert user_credit
    assert_equal user_credit.credit, 10
  end

  private

  def register_user_with_referral_code(email, referral_code)
    request_params_with_code = {
      name: 'Vasil Rashkov',
      email: email,
      password: 'simplepassword!',
      referral_code: referral_code
    }

    post "/user", params: request_params_with_code
    assert_response :success
  end
end
