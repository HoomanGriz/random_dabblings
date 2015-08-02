require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt
  has_many :recipe_lists

  validates :username, uniqueness: true, presence: true


  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end


  def create
    @user = User.new(params[:user])
    @user.password = params[:password]
    @user.save!
  end

  def login
    @user = User.find_by_email(params[:email])
    if @user.password == params[:password]
      give_token
    else
     redirect_to home_url
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end
end