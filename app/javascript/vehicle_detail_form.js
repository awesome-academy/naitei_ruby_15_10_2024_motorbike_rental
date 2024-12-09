document.addEventListener("DOMContentLoaded", function () {
  const brandSelect = document.getElementById("brand-select");
  const modelSelect = document.getElementById("model-select");

  if (brandSelect && modelSelect) {
    brandSelect.addEventListener("change", function () {
      const brandId = this.value;

      if (brandId) {
        fetch(`/vehicle_details/models?brand_id=${brandId}`)
          .then((response) => response.json())
          .then((models) => {
            modelSelect.innerHTML = '<option value="">Select a Model</option>';

            models.forEach((model) => {
              const option = document.createElement("option");
              option.value = model.id;
              option.textContent = model.name;
              modelSelect.appendChild(option);
            });

            modelSelect.disabled = false;
          })
          .catch((error) => {
            console.error("Error fetching models:", error);
            modelSelect.disabled = true;
          });
      } else {
        modelSelect.innerHTML = '<option value="">Select a Model</option>';
        modelSelect.disabled = true;
      }
    });
  }
});
