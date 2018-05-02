describe VisitorsController do

  render_views

  it 'signing in and out breaks' do
    user = FactoryGirl.create(:user)

    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)

    get :index
    assert_select 'p#policy_context', text: "Policy context: #{user.email}"

    other_user = FactoryGirl.create(:user, email: "definitely_should_be_different@example.com")
    sign_out(user)
    sign_in(other_user)

    get :index
    assert_select 'p#policy_context', text: "Policy context: #{other_user.email}"
    # ☝️ i signed_out(user), then signed_in(user), then went to :index again, but user's email
    #    is still the return of `policy(User).current_user`
  end

  it 'same test works if you clear policy caches' do
    user = FactoryGirl.create(:user)

    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)

    get :index
    assert_select 'p#policy_context', text: "Policy context: #{user.email}"

    other_user = FactoryGirl.create(:user, email: "definitely_should_be_different@example.com")
    sign_out(user)

    # -------- different codes --------
    @controller.policies.clear
    @controller.policy_scopes.clear
    # ---------------------------------

    sign_in(other_user)

    get :index
    assert_select 'p#policy_context', text: "Policy context: #{other_user.email}"
  end
end
