# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/decidim'
require_relative 'rubocop/decidim/version'
require_relative 'rubocop/decidim/inject'

RuboCop::Decidim::Inject.defaults!

require_relative 'rubocop/cop/decidim_cops'
