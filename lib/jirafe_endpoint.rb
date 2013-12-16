require_relative './jirafe_endpoint/hash_helpers'
require_relative './jirafe_endpoint/error_parser'
require_relative './jirafe_endpoint/client'
require_relative './jirafe_endpoint/cart_builder'
require_relative './jirafe_endpoint/order_builder'
require_relative './jirafe_endpoint/category_builder'

class JirafeEndpointError < StandardError; end
