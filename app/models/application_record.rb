# frozen_string_literal: true

# The ApplicationRecord class is the base class for all models in the application.
# It inherits from ActiveRecord::Base and serves as the primary abstract class for
# defining common behavior and configurations for models. By marking it as an abstract
# class with `primary_abstract_class`, Rails ensures that it is not instantiated directly.
# Models in the application should inherit from ApplicationRecord to gain the shared behavior.
class ApplicationRecord < ActiveRecord::Base
  # Mark this class as the primary abstract class, so it is not instantiated directly.
  primary_abstract_class
end
