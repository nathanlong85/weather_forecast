class ForecastForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :address, :string
  attribute :city, :string
  attribute :state, :string
  attribute :zip_code, :string

  VALID_STATES = %w[
    AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN
    MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA
    WI WV WY
  ].freeze

  validates :address, :city, :state, :zip_code, presence: true

  validates :state,
    inclusion: { in: VALID_STATES },
    if: proc { state.present? }

  validates :zip_code,
    format: { with: /\A\d{5}(-\d{4})?\z/ },
    if: proc { zip_code.present? }
end
