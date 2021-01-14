require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not create a new user without a password" do
    user = User.new

    assert_not user.save
  end

  test "should have valid errors if the validations of the email fail" do
    user = User.new
    user.valid?

    user.errors.errors.each do |error|
      if error.attribute === :email
        assert_equal(:invalid, error.type)
      end
    end
  end

  test "user model validates the email to be unique" do
    user = User.new(
      name: 'test_name',
      email: 'test_email@email.com',
      password: '123456!',
      referral_code: 'code'
    )
    user.save

    user_to_fail = User.new(
      name: 'test_name',
      email: 'test_email@email.com',
      password: '123456!',
      referral_code: 'code'
    )
    user_to_fail.valid?

    assert_equal(:email, user_to_fail.errors.errors[0].attribute, "There should be an error for the email")
    assert_equal(:taken, user_to_fail.errors.errors[0].type, "that it is taken.")
  end

  test "user model validates that the name is not present" do
    user = User.new(
      email: 'test_email@email.com',
      password: '123456!',
      referral_code: 'code'
    )

    user.valid?

    assert_equal(:name, user.errors.errors[0].attribute, "There should be an error for the name")
    assert_equal(:blank, user.errors.errors[0].type, "that it is not present.")
  end

  test "user model validates that the password is not present" do
    user = User.new(
      email: 'test_email@email.com',
      name: '123456!',
      referral_code: 'code'
    )

    user.valid?

    assert_equal(:password, user.errors.errors[0].attribute, "There should be an error for the name")
    assert_equal(:blank, user.errors.errors[0].type, "that it is not present.")
  end

  test "user model validates that the password must include at least 6 symbols" do
    user = User.new(
      email: 'test_email@email.com',
      name: '123456!',
      password: '!2345',
      referral_code: 'code'
    )

    user.valid?

    assert_equal(:password, user.errors.errors[0].attribute, "There should be an error for the name")
    assert_equal("must be at least 6 symbols", user.errors.errors[0].type, "that it is not present.")
  end

  test "user model validates that the password must include at least 1 special symbols" do
    user = User.new(
      email: 'test_email@email.com',
      name: '123456!',
      password: '123456',
      referral_code: 'code'
    )

    user.valid?

    assert_equal(:password, user.errors.errors[0].attribute, "There should be an error for the name")
    assert_equal("must include as least one special symbol", user.errors.errors[0].type, "that it is not present.")
  end

  test "user model will save the user if the validations pass" do
    user = User.new(
      email: 'test_email@email.com',
      name: '123456!',
      password: '123456!',
      referral_code: 'code'
    )

    assert user.valid?
    assert user.save
  end


end
