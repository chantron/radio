require 'bundler'
Bundler.require

# load the db and models
require './models'

# load external Helpers file
require './helpers'


#DataMapper::Model.raise_on_save_failure = true

class LowPowerRadio < Sinatra::Base
  register Sinatra::Flash

  # Set the helpers to the helper Module
  helpers Helpers

  use Rack::Session::Cookie, secret: 'fD0fXJ71YrH5gK6g0O74E57KRc1Iz3AJ'

  use Warden::Manager do | config |
    # Tell Warden how to save our User info into a session.
    # Sessions can only take strings, not Ruby code, we'll store
    # the User's `id`
    config.serialize_into_session{ | user | user.id }
    # Now tell Warden how to take what we've stored in the session
    # and get a User from that information.
    config.serialize_from_session{ | id | User.get( id ) }

    config.scope_defaults :default,
      # "strategies" is an array of named methods with which to
      # attempt authentication. We have to define this later.
      strategies: [:password],
      # The action is a route to send the user to when
      # warden.authenticate! returns a false answer. We'll show
      # this route below.
      action: 'auth/unauthenticated'
    # When a user tries to log in and cannot, this specifies the
    # app to send the user to.
    config.failure_app = self

  end

  Warden::Manager.before_failure do | env, opts |

    env['REQUEST_METHOD'] = "POST"

  end

  # Define the Warden Strategies
  Warden::Strategies.add( :password ) do

    def valid?

      params['user'] && params['user']['username'] && params['user']['password']

    end

    def authenticate!

      user = User.first( username: params['user']['username'] )

      @username = user.username

      if user.nil?
        
        fail!( "That login is incorrect." )
        

      elsif user.authenticate( params['user']['password'] )
        
        success!(user, "Hello #{@username}.")

      else

        fail!( "Could not log in." )

      end

    end

  end

  # Routes

  ## Main Page Routes
  get '/' do
    @title = "LPFM Radio Framework"


    erb :index
  end

  get '/admin/' do

    @title = "Admin"
    env['warden'].authenticate!

    erb :'admin/admin'

  end

  ### Admin Routes

  get '/admin/users' do

    @title = "Admin"

    @users = User.all(:order => [ :id.desc ] )

    erb :'admin/users/users'

  end

  #### Admin User Routes
  ##### Edit User Page
  get '/admin/user/edit/:id' do
    @id = params[:id]
    @title = "Admin"

    @user = User.get(@id)
    
    erb :'admin/users/single_user'

  end

  ##### Edit User Object
  post '/admin/user/edit/:id' do

    @user = User.get(params[:id])

    @user.update( :first_name => params[:first_name], :last_name => params[:last_name])

    success?

    redirect "/admin/user/edit/#{@user.id}"

  end

  ##### Create New User
  post '/admin/user/new' do

    @user = User.create( username: params[:username])
    @user.password = params[:password]
    @user.email = params[:email]
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    @user.save
    @id = @user.id
    redirect "/admin/user/edit/#{@id}"

  end


  ## Authentication Routes

  get '/auth/login' do

    redirect '/'

  end

  post '/auth/login' do

    env['warden'].authenticate!

    flash[:success] = env['warden'].message

    if session[:return_to].nil?

      redirect '/'

    else

      redirect session[:return_to]

    end

  end

  post '/auth/unauthenticated' do

    session[:return_to] = env['warden.options'][:attempted_path]

    puts env['warden.options'][:attempted_path]

    flash[:error] = env['warden'].message || "You must log in"

    redirect '/auth/login'
  end

  get '/auth/logout' do

    env['warden'].raw_session.inspect

    env['warden'].logout

    flash[:success] = 'Successfully logged out'

    redirect '/'

  end



  # Controllers


end