shared_examples 'require_logged_in_user' do
  it 'redirects to the login page' do
    clear_current_user
    action
    expect(response).to redirect_to login_path
  end
end

shared_examples 'require_admin' do
  it 'redirects normal user back to the homepage' do
    set_current_user
    action
    expect(response).to redirect_to root_path
  end
end
