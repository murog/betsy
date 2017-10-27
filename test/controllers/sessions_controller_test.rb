require "test_helper"

describe SessionsController do
  describe "auth_callback" do
    it "should log in an existing user and redirects them back to the homepage" do
      start_count = User.count
      user = users(:carl)
      #
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      get auth_callback_path(:github)

      #Action
      # log_in(user, :github)
      #Assert
      must_respond_with :redirect
      must_redirect_to root_path
      User.count.must_equal start_count
      session[:user_id].must_equal user.id


    #Assert
    must_respond_with :redirect
    must_redirect_to root_path
    User.count.must_equal (start_count + 1)
    saved_user = User.find_by(username: "Greg")
    session[:user_id].must_equal saved_user.id
  end

  it "can log a user out" do
    log_in(users(:carl), :github)
    session[:user_id].must_equal users(:carl).id

    get logout_path
    must_respond_with :redirect
    must_redirect_to root_path
  end
end


describe "logout" do
  it "should successfully logout" do
    user = users(:carl)
    log_in(user, :github)
    get root_path
    session[:user_id].must_equal user.id

    get logout_path

    get root_path
    session[:user_id].must_equal nil

  end
end
end
