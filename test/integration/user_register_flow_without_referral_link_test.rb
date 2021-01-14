require "test_helper"

class UserRegisterFlowWithoutReferralLinkTest < ActionDispatch::IntegrationTest
  test "user can register in the API without a referral code and create a session" do
    request_params = {
      name: 'Vasil Rashkov',
      email: 'vas.rashkov@gmail.com',
      password: 'simplepassword!'
    }

    post "/user", params: request_params
    assert_response :success

    my_user_id = JSON.parse(response.body)['data']['id']
    user = User.find(my_user_id)
    session = UserSession.find_by_user_id(my_user_id)
    user_credit = UserCredit.find_by_user_id(my_user_id)

    assert user
    assert_equal session.hash_representation, response.headers['Authorization']
    assert user_credit === nil # no credit is given to the user for registration

    session.expires_on = Time.now - 10
    session.save

    post "/authenticate", params: { email: 'vas.rashkov@gmail.com', password: 'simplepassword!'}
    assert_response :success

    new_session = UserSession.where(user_id: my_user_id).where('expires_on > ?', Time.now).first
    assert_equal new_session.hash_representation, response.headers['Authorization']
  end
end
