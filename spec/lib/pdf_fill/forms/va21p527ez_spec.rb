# frozen_string_literal: true
require 'spec_helper'
require 'pdf_fill/forms/va21p527ez'

def basic_class
  PdfFill::Forms::VA21P527EZ.new({})
end

describe PdfFill::Forms::VA21P527EZ do
  let(:form_data) do
    get_fixture('pdf_fill/21P-527EZ')
  end

  test_method(
    basic_class,
    'expand_marriages',
    [
      [
        [{}, :a],
        nil
      ],
      [
        [
          {
            a: [{
              "spouseFullName" => {
                "first" => "spouse1",
                "last" => "Olson"
              },
              "otherExplanation" => "other"
            }]
          },
          :a
        ],
        {:a=>[{"spouseFullName"=>"spouse1 Olson", "otherExplanation"=>"other"}], "aExplanations"=>"other"}
      ]
    ]
  )

  test_method(
    basic_class,
    'expand_marital_status',
    [
      [
        [{}, :a],
        nil
      ],
      [
        [{ a: 'Married' }, :a],
        {:a=>"Married", "maritalStatusMarried"=>true}
      ],
      [
        [{ a: 'Never Married' }, :a],
        {:a=>'Never Married', "maritalStatusNeverMarried"=>true}
      ],
      [
        [{ a: 'Separated' }, :a],
        {:a=>'Separated', "maritalStatusSeparated"=>true}
      ],
      [
        [{ a: 'Widowed' }, :a],
        {:a=>'Widowed', "maritalStatusWidowed"=>true}
      ],
      [
        [{ a: 'Divorced' }, :a],
        {:a=>'Divorced', "maritalStatusDivorced"=>true}
      ]
    ]
  )

  test_method(
    basic_class,
    'expand_date_range',
    [
      [
        [nil, 'foo'],
        nil
      ],
      [
        [{}, 'foo'],
        nil
      ],
      [
        [
          {
            'foo' => {
              'from' => '2001',
              'to' => '2002'
            }
          },
          'foo'
        ],
        {"fooStart"=>"2001", "fooEnd"=>"2002"}
      ]
    ]
  )

  test_method(
    basic_class,
    'convert_date',
    [
      [
        [nil],
        nil
      ],
      [
        '1985-03-07',
        '03/07/1985'
      ]
    ]
  )

  test_method(
    basic_class,
    'rearrange_jobs',
    [
      [
        [nil],
        nil
      ],
      [
        [[
          {"dateRange"=>{"from"=>"2012-04-01", "to"=>"2013-05-01"},
          "employer"=>"job1",
          "address"=>{"city"=>"city1", "country"=>"USA", "postalCode"=>"21231", "state"=>"MD", "street"=>"str1"},
          "annualEarnings"=>10,
          "jobTitle"=>"worker1",
          "daysMissed"=>"1"},
         {"dateRange"=>{"from"=>"2012-04-02", "to"=>"2013-05-02"},
          "employer"=>"job2",
          "address"=>{"city"=>"city2", "country"=>"USA", "postalCode"=>"21231", "state"=>"MD", "street"=>"str2"},
          "annualEarnings"=>20,
          "jobTitle"=>"worker2",
          "daysMissed"=>"2"}
        ]],
          [{"daysMissed"=>"1",
         "dateRange"=>{"from"=>"2012-04-01", "to"=>"2013-05-01"},
         "jobTitle"=>"worker2",
         "annualEarnings"=>20,
         "nameAndAddr"=>"job2, str2, city2, MD, 21231, USA"},
        {"daysMissed"=>"2",
         "dateRange"=>{"from"=>"2012-04-02", "to"=>"2013-05-02"},
         "jobTitle"=>"worker1",
         "annualEarnings"=>10,
         "nameAndAddr"=>"job1, str1, city1, MD, 21231, USA"}]
      ]
    ]
  )

  test_method(
    basic_class,
    'get_disability_names',
    [
      [
        [nil],
        nil
      ],
      [
        [[
          { 'name' => 'name1' },
          { 'name' => 'name2' }
        ]],
        [
          'name2', 'name1'
        ]
      ],
      [
        [[
          { 'name' => 'name1' }
        ]],
        [
          nil, 'name1'
        ]
      ]
    ]
  )

  test_method(
    basic_class,
    'rearrange_hospital_dates',
    [
      [
        [[
          0, 1, 2, 3, 4, 5
        ]],
        [
          3, 4, 1, 0, 2, 5
        ]
      ],
      [
        [[
          0, 1, nil, 3, 4, 5
        ]],
        [
          3, 4, 1, 0, nil, 5
        ]
      ]
    ]
  )

  test_method(
    basic_class,
    'combine_va_hospital_dates',
    [
      [
        [[
          {}
        ]],
        [
          nil, nil, nil
        ]
      ],
      [
        [[
          {
            'dates' => ['2017']
          },
          {
            'dates' => ['2001', '2002', '2003']
          }
        ]],
        [
          '2017', nil, nil, '2001', '2002', '2003'
        ]
      ],
    ]
  )

  test_method(
    basic_class,
    'combine_previous_names',
    [
      [
        [[
          {
            'first' => 'first1',
            'last' => 'last'
          },
          {
            'first' => 'first2',
            'last' => 'last'
          }
        ]],
        'first1 last, first2 last'
      ]
    ]
  )

  test_method(
    basic_class,
    'combine_va_hospital_names',
    [
      [
        [[
          {
            'name' => 'hospital1',
            'location' => 'nyc'
          },
          {
            'name' => 'hospital2',
            'location' => 'dc'
          }
        ]],
        [
          'hospital1, nyc',
          'hospital2, dc'
        ]
      ]
    ]
  )

  test_method(
    basic_class,
    'expand_severance_pay',
    [
      [
        [nil],
        {
          'hasSeverancePay' => false,
          'noSeverancePay' => true
        }
      ],
      [
        { 'amount' => 1 },
        {
          'hasSeverancePay' => true,
          'noSeverancePay' => false
        }
      ],
      [
        { 'amount' => 0 },
        {
          'hasSeverancePay' => false,
          'noSeverancePay' => true
        }
      ]
    ]
  )

  test_method(
    basic_class,
    'expand_previous_names',
    [
      [
        [1],
        {
          'hasPreviousNames' => true,
          'noPreviousNames' => false
        }
      ]
    ]
  )

  test_method(
    basic_class,
    'split_phone',
    [
      [
        '0123456789',
        %w(012 3456789)
      ],
      [
        [nil],
        [nil, nil]
      ]
    ]
  )

  test_method(
    basic_class,
    'combine_address',
    [
      [
        [nil],
        nil
      ],
      [
        {
          'street' => 'street',
          'street2' => 'street2'
        },
        'street, street2'
      ]
    ]
  )

  test_method(
    basic_class,
    'combine_city_state',
    [
      [
        [nil],
        nil
      ],
      [
        {
          'city' => 'foo',
          'state' => 'GA',
          'postalCode' => '12345',
          'country' => 'USA'
        },
        'foo, GA, 12345, USA'
      ]
    ]
  )

  test_method(
    basic_class,
    'combine_hash',
    [
      [
        [nil, []],
        nil
      ],
      [
        [
          { 'a' => '1', 'b' => '2' },
          %w(a b)
        ],
        '1 2'
      ],
      [
        [
          { 'a' => '1', 'c' => '2' },
          %w(a b c)
        ],
        '1 2'
      ],
      [
        [
          { 'a' => '1', 'b' => '2' },
          %w(a b),
          ','
        ],
        '1,2'
      ]
    ]
  )

  test_method(
    basic_class,
    'combine_full_address',
    [
      [
        {
          "city" => "Baltimore",
          "country" => "USA",
          "postalCode" => "21231",
          "street" => "street",
          "street2" => "street2",
          "state" => "MD"
        },
        "street, street2, Baltimore, MD, 21231, USA"
      ]
    ]
  )

  test_method(
    basic_class,
    'combine_name_addr',
    [
      [
        {
          'name' => 'name',
          'address' => {
            "city" => "Baltimore",
            "country" => "USA",
            "postalCode" => "21231",
            "street" => "street",
            "street2" => "street2",
            "state" => "MD"
          }
        },
        {"nameAndAddr"=>"name, street, street2, Baltimore, MD, 21231, USA"}
      ]
    ]
  )

  test_method(
    basic_class,
    'combine_hash_and_del_keys',
    [
      [
        [nil, 1, 2],
        nil
      ],
      [
        [{ a: '1', b: '2' }, %i(a b), :ab],
        { ab: '1 2' }
      ]
    ]
  )

  test_method(
    basic_class,
    'expand_gender',
    [
      [
        'M',
        {
          'genderMale' => true,
          'genderFemale' => false
        }
      ],
      [
        'F',
        {
          'genderMale' => false,
          'genderFemale' => true
        }
      ],
      [
        [nil],
        {}
      ]
    ]
  )

  test_method(
    basic_class,
    'replace_phone',
    [
      [
        [{}, 'foo'],
        nil
      ],
      [
        [nil, 'foo'],
        nil
      ],
      [
        [{ 'foo' => '5551110000' }, 'foo'],
        {"foo"=>"1110000", "fooAreaCode"=>"555"}
      ]
    ]
  )

  test_method(
    basic_class,
    'expand_checkbox',
    [
      [
        [true, 'Foo'],
        {
          'hasFoo' => true,
          'noFoo' => false
        }
      ],
      [
        [false, 'Foo'],
        {
          'hasFoo' => false,
          'noFoo' => true
        }
      ]
    ]
  )

  test_method(
    basic_class,
    'expand_va_file_number',
    [
      [
        '123',
        {
          'hasFileNumber' => true,
          'noFileNumber' => false
        }
      ],
      [
        [nil],
        {
          'hasFileNumber' => false,
          'noFileNumber' => true
        }
      ]
    ]
  )

  it 'form data should match json schema' do
    expect(form_data.to_json).to match_vets_schema('21P-527EZ')
  end

  describe '#combine_full_name' do
    let(:full_name) do
      form_data['veteranFullName']
    end

    subject do
      basic_class.combine_full_name(full_name)
    end

    context 'with missing fields' do
      before do
        full_name.delete('middle')
        full_name.delete('suffix')
      end

      it 'should combine a full name' do
        expect(subject).to eq('john smith')
      end
    end

    context 'with nil full name' do
      let(:full_name) { nil }

      it 'should return nil' do
        expect(subject).to eq(nil)
      end
    end

    it 'should combine a full name' do
      expect(subject).to eq('john middle smith Sr.')
    end
  end

  describe '#merge_fields' do
    it 'should merge the right fields' do
      expect(described_class.new(form_data).merge_fields).to eq(
        {"veteranFullName"=>"john middle smith Sr.",
         "maritalStatus"=>"Married",
         "reasonForNotLivingWithSpouse"=>"illness",
         "children"=>
          [{"childFullName"=>"Mark1 Olson",
            "childPlaceOfBirth"=>"place1",
            "attendingCollege"=>true,
            "married"=>true,
            "biological"=>true,
            "stepchild"=>true,
            "disabled"=>true,
            "adopted"=>true,
            "previouslyMarried"=>true,
            "personWhoLivesWithChild"=>nil,
            "childAddress"=>nil},
           {"childFullName"=>"Mark2 Olson",
            "childPlaceOfBirth"=>"place2",
            "attendingCollege"=>true,
            "married"=>true,
            "disabled"=>true,
            "biological"=>true,
            "stepchild"=>true,
            "adopted"=>true,
            "previouslyMarried"=>true,
            "personWhoLivesWithChild"=>nil,
            "childAddress"=>nil},
           {"childFullName"=>"Mark3 Olson",
            "childPlaceOfBirth"=>"place3",
            "attendingCollege"=>true,
            "married"=>true,
            "disabled"=>true,
            "biological"=>true,
            "stepchild"=>true,
            "adopted"=>true,
            "previouslyMarried"=>true,
            "personWhoLivesWithChild"=>nil,
            "childAddress"=>nil}],
         "spouseMarriages"=>
          [{"spouseFullName"=>"spouse1 Olson",
            "otherExplanation"=>"spouse other",
            "dateOfMarriage"=>"1985-03-01",
            "locationOfMarriage"=>"marriagelocation1",
            "locationOfSeparation"=>"location1",
            "marriageType"=>"type1",
            "dateOfSeparation"=>"1985-04-01",
            "reasonForSeparation"=>"divorce1"},
           {"spouseFullName"=>"spouse2 Olson",
            "dateOfMarriage"=>"1985-03-02",
            "dateOfSeparation"=>"1985-04-02",
            "locationOfMarriage"=>"marriagelocation2",
            "locationOfSeparation"=>"location2",
            "marriageType"=>"type2",
            "reasonForSeparation"=>"divorce2"}],
         "marriages"=>
          [{"spouseFullName"=>"Mark1 Olson",
            "otherExplanation"=>"other",
            "dateOfMarriage"=>"1985-03-01",
            "dateOfSeparation"=>"1985-04-01",
            "locationOfMarriage"=>"marriagelocation1",
            "locationOfSeparation"=>"location1",
            "marriageType"=>"type1",
            "reasonForSeparation"=>"divorce1"},
           {"spouseFullName"=>"Mark2 Olson",
            "dateOfMarriage"=>"1985-03-02",
            "dateOfSeparation"=>"1985-04-02",
            "locationOfMarriage"=>"marriagelocation2",
            "locationOfSeparation"=>"location2",
            "marriageType"=>"type2",
            "reasonForSeparation"=>"divorce2"}],
         "veteranDateOfBirth"=>"1985-03-07",
         "veteranSocialSecurityNumber"=>"111223333",
         "spouseAddress"=>"str1, city1, MD, 21231, USA",
         "jobs"=>
          [{"daysMissed"=>"1",
            "jobTitle"=>"worker2",
            "annualEarnings"=>20,
            "nameAndAddr"=>"job2, str2, city2, MD, 21231, USA",
            "dateRangeStart"=>"2012-04-01",
            "dateRangeEnd"=>"2013-05-01"},
           {"daysMissed"=>"2",
            "jobTitle"=>"worker1",
            "annualEarnings"=>10,
            "nameAndAddr"=>"job1, str1, city1, MD, 21231, USA",
            "dateRangeStart"=>"2012-04-02",
            "dateRangeEnd"=>"2013-05-02"}],
         "nationalGuard"=>
          {"date"=>"2013-04-11",
           "phone"=>"3456789",
           "phoneAreaCode"=>"212",
           "nameAndAddr"=>"foo, 111 Uni Drive, Baltimore, MD, 21231, USA"},
         "previousNames"=>"name1 last1, name2 last2",
         "severancePay"=>{"amount"=>1, "type"=>"Longevity"},
         "placeOfSeparation"=>"city, state",
         "serviceBranch"=>"army",
         "email"=>"foo@foo.com",
         "altEmail"=>"alt@foo.com",
         "nightPhone"=>"3456789",
         "dayPhone"=>"3456789",
         "mobilePhone"=>"3456789",
         "spouseVaFileNumber"=>"c22345678",
         "vaFileNumber"=>"c12345678",
         "disabilities"=>[{"disabilityStartDate"=>"2016-12-01"}],
         "gender"=>"M",
         "genderMale"=>true,
         "genderFemale"=>false,
         "hasFileNumber"=>true,
         "noFileNumber"=>false,
         "hasPreviousNames"=>true,
         "noPreviousNames"=>false,
         "hasSeverancePay"=>true,
         "noSeverancePay"=>false,
         "hasPowDateRange"=>true,
         "noPowDateRange"=>false,
         "hasNationalGuardActivation"=>true,
         "noNationalGuardActivation"=>false,
         "hasCombatSince911"=>true,
         "noCombatSince911"=>false,
         "nightPhoneAreaCode"=>"012",
         "maritalStatusMarried" => true,
         "dayPhoneAreaCode"=>"112",
         "noSpouseIsVeteran" => false,
         "mobilePhoneAreaCode"=>"212",
         "vaHospitalTreatmentNames"=>["hospital1, nyc", "hospital2, dc"],
         "vaHospitalTreatmentDates"=>
          ["2016-12-01", "2016-12-02", "2016-01-02", "2016-01-01", nil, "2016-12-03"],
         "disabilityNames"=>[nil, "disability 1"],
         "cityState"=>"Baltimore, MD, 21231, USA",
         "veteranAddressLine1"=>"street, street2",
         "activeServiceDateRangeStart"=>"2012-06-26",
         "activeServiceDateRangeEnd"=>"2013-04-10",
         "powDateRangeStart"=>"2012-04-10",
         "hasLiveWithSpouse" => true,
         "noLiveWithSpouse" => false,
         "powDateRangeEnd"=>"2013-05-10",
         "spouseDateOfBirth" => "2012-06-26",
         "hasSpouseIsVeteran" => true,
         "outsideChildren"=>
          [{"childAddress"=>"str1, city1, MD, 21231, USA",
            "childFullName"=>"outside1 Olson",
            "childNotInHousehold"=>true,
            "personWhoLivesWithChild"=>"person1 Olson",
            "monthlyPayment"=>1},
           {"childAddress"=>"str2, city1, MD, 21231, USA",
            "childFullName"=>"outside2 Olson",
            "personWhoLivesWithChild"=>"person2 Olson",
            "childNotInHousehold"=>true,
            "monthlyPayment"=>2},
           {"childAddress"=>"str3, city1, MD, 21231, USA",
            "childFullName"=>"outside3 Olson",
            "personWhoLivesWithChild"=>"person3 Olson",
            "childNotInHousehold"=>true,
            "monthlyPayment"=>3}],
         "marriagesExplanations"=>"other",
         "spouseMarriagesExplanations"=>"spouse other",
         "spouseMarriageCount"=>2,
         "marriageCount"=>2,
        }
      )
    end
  end
end
