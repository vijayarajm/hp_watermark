module RegionsHelper

  def payoffs_list(project_id)
    Project.find(project_id).payoffs.map{ |payoff| [payoff.name, payoff.id] }
  end
end
