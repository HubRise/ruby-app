# frozen_string_literal: true
module HubriseApp
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
