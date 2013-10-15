
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/db.sqlite3")
# Models

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

  # associations
  # has n, :images

  def authenticate(attempted_password)
    if self.password == attempted_password
      true
    else
      false
    end
  end

end


class DJ < User

  property :bio, Text
  has n, :shows

end

class Show

  include DataMapper::Resource

  property :id, Serial
  property :date, DateTime
  property :filepath, FilePath

  has n, :playlists

end

class Playlist

  include DataMapper::Resource

  property :id, Serial

  has n, :songs
  belongs_to :show

end

class Song

  include DataMapper::Resource

  property :id, Serial
  property :artist, String
  property :title, String
  property :album, String
  property :year, Date

  has n, :playlists

end

class Post

  include DataMapper::Resource
  
  property :id, Serial

end

class Image

  include DataMapper::Resource
  
  property :id, Serial
  property :filepath, FilePath

end


DataMapper.finalize.auto_upgrade!

# Create a test User
if User.count == 0

  @user = User.create( username: "admin" )
  @user.password = "test"
  @user.save

end