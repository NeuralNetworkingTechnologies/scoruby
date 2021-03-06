# frozen_string_literal: true

require 'scoruby/models/random_forest/data'
require 'forwardable'

module Scoruby
  module Models
    module RandomForest
      class Model
        extend Forwardable
        def_delegators :@data, :decision_trees, :categorical_features,
                       :continuous_features

        def initialize(xml)
          @data = Data.new(xml)
        end

        def score(features)
          decisions_count = decisions_count(features)
          decision = decisions_count.max_by { |_, v| v }
          {
            label: decision[0],
            score: decision[1] / decisions_count.values.reduce(0, :+).to_f
          }
        end

        def decisions_count(features)
          formatted_features = Features.new(features).formatted
          decisions = traverse_trees(formatted_features)
          aggregate_decisions(decisions)
        end

        private

        def traverse_trees(formatted_features)
          decision_trees.map do |decision_tree|
            decision_tree.decide(formatted_features).score
          end
        end

        def aggregate_decisions(decisions)
          decisions.each_with_object(Hash.new(0)) do |score, counts|
            counts[score] += 1
          end
        end
      end
    end
  end
end
