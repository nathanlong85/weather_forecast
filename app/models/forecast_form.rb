class ForecastForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :address, :string
  attribute :city, :string
  attribute :state, :string
  attribute :zip_code, :string

  VALID_STATES = %w[
    AL AK AS AZ AR CA CO CT DE DC FM FL GA GU HI ID IL IN IA KS KY LA ME MH MD
    MA MI MN MS MO MT NE NV NH NJ NM NY NC ND MP OH OK OR PW PA PR RI SC SD TN
    TX UT VT VI VA WA WV WI WY
  ].freeze

  validates :address, :city, :state, :zip_code, presence: true

  validates :state,
            inclusion: { in: VALID_STATES },
            if: proc { state.present? }

  validates :zip_code,
            format: {
              with: /\A\d{5}(-\d{4})?\z/
            },
            if: proc { zip_code.present? }
end
