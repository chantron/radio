# Helpers

module Helpers

  def login_box

    if env['warden'].authenticated?

      @username = env['warden'].user.username

      @message = "Hello #{@username}. <a href=/auth/logout>Logout?</a>"

    else

      erb :login_form

    end

  end

  def success?

   if @user.saved? == true

    flash[:success] = "#{@user.username} has been updated."

  elsif @user.saved? == false

    flash[:error] = "#{@user.username} failed to update."

  else

    flash[:error] = "Something went wrong."

  end


  end

end
