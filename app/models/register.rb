class Register < ApplicationRecord
  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << [ "fistName", "lastName", "birthDay", "gender", "email", "phoneNumber", "subJect" ]
      all.each do |register|
        csv << [
          register.fistName,
          register.lastName,
          register.birthDay,
          register.gender,
          register.email,
          register.phoneNumber,
          register.subJect
        ]
      end
    end
  end
end
