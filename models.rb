DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/db.sqlite3")
# Models

class SiteOptions

  include DataMapper::Resource

  property :id, Serial
  property :name, Text
  property :about, Text
  property :tagline, Text
  property :admin, String
  property :address1, String
  property :address2, String
  property :city, String
  property :state, String, :length => 2
  property :zip, String
  #property :logo, 

end

class User

  include DataMapper::Resource
  include BCrypt

  property :id, Serial
  property :username, String, :length => 3..50
  property :first_name, String
  property :last_name, String
  property :email, String
  property :password, BCryptHash
  property :created_at, DateTime
  property :type, Discriminator
  
  # associations
  # has n, :images
  has n, :roles, :through => DataMapper::Resource
  has n, :posts

  def name

    name = "#{first_name}" + " " + "#{last_name}"

    name

  end

  def authenticate(attempted_password)

    if self.password == attempted_password

      true

    else
      false


    end

  end

end


class Dj < User

  property :bio, Text
  has n, :shows

end

class Role

  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :description, Text

  has n, :users, :through => Resource

end


class Show

  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :date, DateTime
  property :filepath, FilePath
  property :description, Text
  property :blurb, Text, :length => 10..250

  has n, :playlists
  #has 1, :schedule
  belongs_to :dj, :required => false

end

# class Schedule

#   include Datamapper::Resource

#   property :id
#   property :sunday, Boolean
#   property :monday, Boolean
#   property :tuesday, Boolean
#   property :wednesday, Boolean
#   property :thursday, Boolean
#   property :friday, Boolean
#   property :saturday, Boolean
#   property :start_time, Time
#   property :end_time, Time

#   belongs_to :show, :required => false

# end

class Playlist

  include DataMapper::Resource

  property :id, Serial
  property :date, DateTime
  property :created_at, DateTime

  has n, :songs
  belongs_to :show, :required => false

  def date_format


  end

end

class Song

  include DataMapper::Resource

  property :id, Serial
  property :artist, String
  property :title, String
  property :album, String
  property :year, Date

  has n, :playlists, :required => false

end

class Post

  include DataMapper::Resource
  
  property :id, Serial
  property :title, Text
  property :content, Text
  property :created_at, DateTime
  property :updated_at, DateTime
  belongs_to :user, :required => false

end

class Image

  include DataMapper::Resource
  
  property :id, Serial
  property :title, String
  property :description, Text
  property :filepath, FilePath

end


DataMapper.finalize.auto_upgrade!

# Create Test Stuff

if SiteOptions.count == 0 

  @site = SiteOptions.create(
    name: "RadioBPT",
    about: "Default about! This should explain what exactly the site is all about."
  )

end

if User.count == 0

  @user = User.create(
    username: "admin",
    first_name: "Admin",
    last_name: "Boss",
    email: "admin@something.com",
    password: "test"
  )

end

if Role.count == 0 

  @role = Role.create(
    title: "admin",
    description: "Top level admin."
  )
  @role = Role.get(1)
  @user = User.get(1)
  @user.roles << @role

end

if Dj.count == 0 

  @dj = Dj.create(
    username: "dee-jay",
    first_name: "Dee",
    last_name: "Jay",
    email: "deejay@something.com",
    password: "testing",
    bio: "Dee Jay playing all the big tunes."
  )

end

if Show.count == 0

  @show = Show.create(
    title: "Test Show",
    date: Time.now,
    filepath: nil,
    description: "This is a test Show."
  )

  @dj = Dj.get(1)
  @show = Show.get(1)
  @dj.shows << @show

end

module ModuleTemplate

  def self.included(base)

    base.class_eval do
      # methods to include
    end

  end

end