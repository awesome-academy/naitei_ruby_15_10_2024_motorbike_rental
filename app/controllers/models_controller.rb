class ModelsController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @models = pagy(Model.ordered_by_vehicle_count)

    @models = @models.map do |model|
      model.define_singleton_method(:model_image) do
        images = model.vehicle_details.map(&:image)
        images.find(&:attached?)
      end
      model
    end
  end
end
