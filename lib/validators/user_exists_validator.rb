class UserExistsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      User.find(value)
    rescue => e
      record.errors[attribute] << "User with id #{record.user_id} doesn't exist"
    end
  end
end
