require 'json'

class UserService
  def initialize(db)
    @db = db
  end

  def find_user(id)
    user = @db.query("SELECT * FROM users WHERE id = ?", id)
    if user.nil?
      raise "User not found"
    end
    return user
  end

  def create_user(name, email)
    validate_email(email)
    @db.insert("users", { name: name, email: email })
  end

  def validate_email(email)
    unless email.include?("@")
      raise "Invalid email"
    end
  end
end
