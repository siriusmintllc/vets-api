# frozen_string_literal: true
require 'spec_helper'
require 'pdf_fill/hash_converter'

describe PdfFill::HashConverter do
  let(:hash_converter) do
    described_class.new('%m/%d/%Y')
  end

  describe '#set_value' do
    def verify_extras_text(text)
      the_text = hash_converter.instance_variable_get(:@extras_generator).instance_variable_get(:@text)

      expected_text = text.blank? ? '' : "Additional Information\n\n#{text}\n"

      expect(the_text).to eq(expected_text)
    end

    def verify_hash(hash)
      expect(hash_converter.instance_variable_get(:@pdftk_form)).to eq(
        hash
      )
    end

    def verify_text_and_hash(text, hash)
      verify_hash(hash)
      verify_extras_text(text)
    end

    def call_set_value(*args)
      final_args = [:foo, 'bar'] + args
      hash_converter.set_value(*final_args)
    end

    context "with a value that's over limit" do
      it 'should add text to the extras page' do
        call_set_value(
          {
            limit: 2,
            question: 1
          },
          nil
        )

        verify_text_and_hash('1: bar', foo: "See add'l info page")
      end

      context 'with an index' do
        it 'should add text with line number' do
          call_set_value(
            {
              limit: 2,
              question: '1'
            },
            0
          )

          verify_text_and_hash('1 Line 1: bar', foo: "See add'l info page")
        end
      end
    end

    context 'with a value thats under limit' do
      it 'should set the hash to the value' do
        call_set_value(
          {
            limit: 3
          },
          nil
        )

        verify_text_and_hash('', foo: 'bar')
      end
    end
  end

  describe '#transform_data' do
    let(:form_data) do
      {
        toursOfDuty: [
          {
            discharge: 'honorable',
            foo: nil,
            nestedHash: {
              dutyType: 'title 10'
            }
          },
          {
            discharge: 'medical',
            nestedHash: {
              dutyType: 'title 32'
            }
          }
        ],
        date: '2017-06-06',
        veteranFullName: 'bob bob',
        nestedHash: {
          nestedHash: {
            married: true
          }
        },
        bankAccount: {
          accountNumber: 34_343_434,
          checking: true
        }
      }
    end

    let(:pdftk_keys) do
      {
        date: { key: 'form.date'},
        veteranFullName: { key: 'form1[0].#subform[0].EnterNameOfApplicantFirstMiddleLast[0]'},
        bankAccount: {
          accountNumber: {key:'form1[0].#subform[0].EnterACCOUNTNUMBER[0]'},
          checking: {key:'form1[0].#subform[0].CheckBoxChecking[0]'}
        },
        nestedHash: {
          nestedHash: {
            married: {key:'form1[0].#subform[1].CheckBoxYes6B[0]'}
          }
        },
        toursOfDuty: {
          discharge: {key:"form1[0].#subform[1].EnterCharacterD#{PdfFill::HashConverter::ITERATOR}[0]"},
          nestedHash: {
            dutyType: {key:"form1[0].#subform[1].EnterTypeOfDutyE#{PdfFill::HashConverter::ITERATOR}[0]"}
          }
        }
      }
    end

    it 'should convert the hash correctly' do
      expect(
        described_class.new('%m/%d/%Y').transform_data(
          form_data: form_data,
          pdftk_keys: pdftk_keys
        )
      ).to eq(
        'form1[0].#subform[1].EnterCharacterD0[0]' => 'honorable',
        'form1[0].#subform[1].EnterTypeOfDutyE0[0]' => 'title 10',
        'form1[0].#subform[1].EnterCharacterD1[0]' => 'medical',
        'form1[0].#subform[1].EnterTypeOfDutyE1[0]' => 'title 32',
        'form.date' => '06/06/2017',
        'form1[0].#subform[0].EnterNameOfApplicantFirstMiddleLast[0]' => 'bob bob',
        'form1[0].#subform[1].CheckBoxYes6B[0]' => 1,
        'form1[0].#subform[0].EnterACCOUNTNUMBER[0]' => '34343434',
        'form1[0].#subform[0].CheckBoxChecking[0]' => 1
      )
    end
  end
end
