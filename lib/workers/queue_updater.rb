
# MiddleMan.worker(:queue_updater).async_create
# MiddleMan.worker(:queue_updater).async_check_queues

class QueueUpdater < BackgrounDRb::MetaWorker
  set_worker_name :queue_updater
  
  def create(args = nil)
    # time argument is in seconds
    time = Rails.env == "production" ? 10 : 2
    add_periodic_timer(time) { check_queues } # configured via backgroundrb.yml
    # check_queues
  end
  
  protected
  
  def check_queues
    puts "checking queues"
    DB::Queue::Building.all.select{|x| x.finished? }.map do |b|
      logger.info "- Building #{b.structure_id} (Level #{b.level}) Finished in City #{b.city_id} for Player #{b.player_id}"
    end
    DB::Queue::Unit.all.select{|x| x.finished? }.map do |u|
      logger.info "- Unit #{u.unit_id} Finished in City #{b.city_id} for Player #{b.player_id}"
    end
    DB::Queue::Tech.all.select{|x| x.finished? }.map do |r|
      logger.info "- Research #{r.tech_id} (Level #{r.level}) Finished in City #{r.city_id} for Player #{r.player_id}"
    end
  end
  
end