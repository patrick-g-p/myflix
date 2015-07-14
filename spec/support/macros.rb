def set_current_user(user=nil)
  session[:user_id] = user.try(:id) || Fabricate(:user).id
end

def current_user
  @current_user ||= User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def login(a_user=nil)
  a_user ||= Fabricate(:user)

  visit(login_path)
  fill_in('Email', with: a_user.email)
  fill_in('Password', with: a_user.password)
  click_button("Login")
end

def click_video_on_the_homepage(video)
  find("a[href='/videos/#{video.id}']").click
end
