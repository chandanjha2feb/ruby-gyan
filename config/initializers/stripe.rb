Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials.dig(:stripe, :publish_key),
  secret_key:  Rails.application.credentials.dig(:stripe, :secret_key)
}
Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)