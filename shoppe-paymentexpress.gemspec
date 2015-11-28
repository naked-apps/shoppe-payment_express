$:.push File.expand_path("../lib", __FILE__)

require "shoppe/paymentexpress/version"

Gem::Specification.new do |s|
  s.name        = "shoppe-paymentexpress"
  s.version     = Shoppe::PaymentExpress::VERSION
  s.authors     = ["Brendan Kilfoil"]
  s.email       = ["brendan@nakedapps.co.nz"]
  s.homepage    = "http://tryshoppe.com"
  s.summary     = "A Payment Express module for Shoppe."
  s.description = "A Payment Express module to assist with the integration of PxPay 2."

  s.files = Dir["{lib}/**/*", "MIT-LICENSE", "README.md"]

  s.add_dependency "shoppe", "~> 1.0.3"
end
