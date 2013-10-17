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

    if env['warden'].authenticated? && admin?

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

  def show_save?
    if @show.saved?

      flash[:success] = "#{@show.title} has been updated."

      redirect "/admin/shows/edit/#{@show.id}"

    elsif !@show.saved?

      flash[:error] = "#{@show.title} could not be updated"

      redirect "/admin/shows/new"
    else

      flash[:error] = "Something horrible went wrong."

      redirect "/admin/shows/new"
    end
  end

  def post_save?
    if @post.saved?

      flash[:success] = "#{@post.title} has been updated."

      redirect "/admin/posts/edit/#{@post.id}"

    elsif !@post.saved?

      flash[:error] = "#{@post.title} could not be updated"

      redirect "/admin/post/new"
    else

      flash[:error] = "Something horrible went wrong."

      redirect "/admin/post/new"
    end
  end

  def admin?

    @admin_role = Role.get(1)
    if env['warden'].user.roles.include?(@admin_role)
      true
    else
      false
    end

  end

  def dj?

    if env['warden'].user.type == 'Dj'

      true

    else

      false

    end
  end

  def extra_info?
    extra_info = false
    if extra_info == true
      erb :extra_info
    end
  end


end
