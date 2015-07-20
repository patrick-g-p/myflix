shared_examples 'require_logged_in_user' do
  it 'redirects to the login page' do
    clear_current_user
    action
    expect(response).to redirect_to login_path
  end
end

shared_examples 'generates_a_token' do
  it 'has a token' do
    expect(object.invitation_token).to be_present
  end
end
