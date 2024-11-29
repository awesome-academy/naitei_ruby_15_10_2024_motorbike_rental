module VehicleDetailsHelper
  def enum_select(form, field, collection, pretranslate, prompt_key)
    form.select(field,
                collection.keys.map { |key| [t("#{pretranslate}.#{key.downcase}"), key] },
                { prompt: t(prompt_key) },
                { class: "form-select" })
  end
end
