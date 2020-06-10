# frozen_string_literal: true

# TODO: when finished, run `rake generate_cops_documentation` to update the docs
module RuboCop
  module Cop
    module Decidim
      # This cop replaces all appearances of
      # `translated_attribute(resource.field)` with
      # `translated(resource, :field)`. Note the API change. This cop does not
      # support any alternative style, but supports auto-correct.
      #
      # @example
      #   # bad
      #   translated_attribute(field)
      #
      #   # bad
      #   translated_attribute(resource.field)
      #
      #   # bad
      #   translated_attribute(parent_resource.resource.field)
      #
      #   # good
      #   translated(resource, :field)
      #
      #   # good
      #   translated(parent_resource.resource, :field)
      #
      class TranslatedAttribute < Cop
        # TODO: Implement the cop in here.
        #
        # In many cases, you can use a node matcher for matching node pattern.
        # See https://github.com/rubocop-hq/rubocop/blob/master/lib/rubocop/node_pattern.rb
        #
        # For example
        MSG = 'Use `#translated(resource, :field)` instead of '\
        '`#translated_attribute(resource.field)`.'

        def_node_matcher :translated_attribute?, <<-PATTERN
          (send nil? :translated_attribute ...)
        PATTERN

        def on_send(node)
          return unless translated_attribute?(node)

          add_offense(node)
        end

        def autocorrect(node)
          lambda do |corrector|
            method_param_chain = node.children[2]
            chain_ast = method_param_chain.children

            if chain_ast[0]
              resource = method_param_chain.children[0].source
              attribute_name = method_param_chain.children[1]

              corrector.replace(node, "translated(#{resource}, :#{attribute_name})")
            end
          end
        end
      end
    end
  end
end
