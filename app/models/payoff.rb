class Payoff < ActiveRecord::Base

  belongs_to :project
  has_many :regions

  validates_presence_of :name, :url

  before_create :create_remote_payoff
  before_update :update_remote_payoff
  before_destroy :delete_remote_payoff

  def remote_payoff_url
    %(https://www.livepaperapi.com/api/v1/triggers/#{remote_payoff_id})
  end

  private
    def create_remote_payoff
      remote_payoff = live_paper.create_payoff(self.name, self.url)
      self.remote_payoff_id = remote_payoff.id
    end

    def update_remote_payoff
      live_paper.update_payoff(remote_payoff_id, name, url)
    end

    def delete_remote_payoff
      live_paper.delete_payoff(remote_payoff_id)
    end

    def live_paper
      LivePaperWrapper.new
    end
end
