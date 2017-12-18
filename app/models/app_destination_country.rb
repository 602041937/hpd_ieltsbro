class AppDestinationCountry < ApplicationRecord
  belongs_to :app_user, optional: true
end
