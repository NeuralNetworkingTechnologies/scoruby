require 'spec_helper'

describe Scoruby::Predicates::SimpleSetPredicate do
  let(:pred_xml) { Scoruby.xml_from_string(pred_string) }
  let(:relevant_pred_xml) { pred_xml.children[0] }
  let(:categorical_predicate) { described_class.new(relevant_pred_xml) }

  context 'quotes' do
    let(:pred_string) do
      <<-XML
        <SimpleSetPredicate field="f36" booleanOperator="isIn">
          <Array n="6" type="string">&quot;Missing&quot;   &quot;No Match&quot;</Array>
        </SimpleSetPredicate>
      XML
    end

    it 'returns true' do
      expect(categorical_predicate.true?(f36: 'No Match')).to eq true
    end

    it 'returns false' do
      expect(categorical_predicate.true?(f36: 'Match')).to eq false
    end
  end

  context 'no quotes' do
    let(:pred_string) do
      <<-XML
        <SimpleSetPredicate field="f36" booleanOperator="isIn">
          <Array n="6" type="string">f2v1 f2v2 f2v3</Array>
        </SimpleSetPredicate>
      XML
    end

    it 'returns true' do
      expect(categorical_predicate.true?(f36: 'f2v2')).to eq true
    end

    it 'returns false' do
      expect(categorical_predicate.true?(f36: 'f2v4')).to eq false
    end
  end
end
