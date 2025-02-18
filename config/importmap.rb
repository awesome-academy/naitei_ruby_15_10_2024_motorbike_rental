# pin "application"
# pin "popper", to: "popper.js", preload: true
# pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "popper", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "vehicle_detail_form", to: "vehicle_detail_form.js"

pin_all_from "app/javascript/controllers", under: "controllers"
