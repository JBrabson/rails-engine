class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.pagination(listcount_per_page, page)
    listcount_per_page = 20 if listcount_per_page < 0
    page = 1 if page <= 0
    page = (page - 1) * listcount_per_page if page > 0
    limit(listcount_per_page).offset(page)
  end
end
