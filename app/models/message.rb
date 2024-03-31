class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :chat 
  validates :message_number, uniqueness:{scope: :chat_id},
  numericality: {only_integer: true, greater_than_or_equal_to: 1}
  
  settings do
    mapping dynamic: false do
      indexes :body, type: :text, analyzer: :english
      indexes :chat_id
    end
  end

  def as_indexed_json(options={})
    self.as_json(only: [:body, :message_number, :chat_id])
  end

  def self.search(term, chat_id)
    response = __elasticsearch__.search(
        query: {
            bool: {
                must: [
                    { match: { chat_id: chat_id } },
                    { query_string: { query: "*#{term}*", fields: [:body] } }
                ]
            }
        }
    )
    response.results.map { |r| {body: r._source.body, message_number: r._source.message_number} }
  end
end
