# Helpers

module Helpers

  def login_box

    if env['warden'].authenticated?

      erb :logout_box

    else

      erb :login_form

    end

  end

  def admin_links?

    @admin_role = Role.get(1)

    if env['warden'].authenticated? && env['warden'].user.roles.include?(@admin_role)

      erb :'/admin/admin_links'

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

  def extra_info?
    extra_info = true
    if extra_info == true
      erb :extra_info
    end
  end


end
