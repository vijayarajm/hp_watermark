class LivePaperWrapper

  def initialize
    LivePaper.auth(id: User.current.client_id, secret: User.current.client_secret)
  end

  def upload_image(image_location)
    LivePaper::Image.upload image_location
  end

  # Trigger API
  def create_trigger(name, strength, resolution, image_url)
    LivePaper::WmTrigger.create(trigger_params(name, strength, resolution, image_url))
  end

  def update_trigger(trigger_id, name, strength, resolution, image_url)
    trigger = get_trigger(trigger_id)
    trigger.name = name
    trigger.watermark = { 
      :strength => strength, 
      :resolution => resolution,
      :imageURL => image_url
    }
    trigger.update
  end

  def get_trigger(trigger_id)
    LivePaper::WmTrigger.get(trigger_id)
  end

  def delete_trigger(trigger_id)
    get_trigger(trigger_id).delete
  end


  # Payoff API
  def create_payoff(name, url)
    LivePaper::Payoff.create(payoff_params(name, url))
  end

  def update_payoff(payoff_id, name, url)
    payoff = get_payoff(payoff_id)
    payoff.name = name
    payoff.url = url
    payoff.update
  end

  def get_payoff(payoff_id)
    LivePaper::Payoff.get(payoff_id)
  end

  def delete_payoff(payoff_id)
    get_trigger(payoff_id).delete
  end


  # Link API
  def create_link(name, trigger, payoff)
    LivePaper::Link.create(link_params(name, trigger, payoff))
  end

  def update_link(link_id, trigger, payoff)
    link = get_link(link_id)
    link.payoff_id = payoff.id
    link.trigger_id = trigger.id
    link.update
  end

  def get_link(link_id)
    LivePaper::Link.get(link_id)
  end

  def delete_link(link_id)
    get_link(link_id).delete
  end

  private
    def trigger_params(name, strength, resolution, image_url)
      {
        name: name, 
        watermark: {
          strength: strength, 
          resolution: resolution, 
          imageURL: image_url
        }
      }
    end

    def payoff_params(name, url)
      {
        name: name,
        type: LivePaper::Payoff::TYPE[:WEB], 
        url: url
      }
    end

    def link_params(name, trigger, payoff)
      {
        payoff_id: payoff.id, 
        trigger_id: trigger.id, 
        name: name
      }
    end
end