class ComparisonsController < ApplicationController
  def index
    @comparisons = Comparison.all
  end

  def show
    @comparison = Comparison.get(params[:id])
  end

  def create
    #TODO: first check if one exists already, and redirect to it.
    first_set = get_msruns_from_array_of_ids(params[:comparison1])
    second_set = get_msruns_from_array_of_ids(params[:comparison2])

    # comp = Comparison.create

    comp = Comparison.new
    comp.msrun_firsts = first_set
    comp.msrun_seconds = second_set
    comp.save

    #Do this in a thread, and show a flash message saying it was
    #started.
    # Thread.new(comp) do |comparison|
      #TODO: make it return some kind of status
      result = comp.graph
      puts "DONE GRAPHING"
      a = Alert.create({ :email => false, :show => true, :description => "DONE WITH THE COMPARISON" })
    # end

    flash[:notice] = "Comparison started. You will be notified when it completes."
    redirect_to :action => "show", :id => comp.id
  end

  def get_graph_at_path
    #TODO: what if they are requesting just an image?
    if comparison = Comparison.get(params[:id]) then
      path = File.join(comparison.location_of_graphs, params[:graph_path])
      relative_path = path.gsub("#{File.join(Rails.root, 'public')}", "")
      #TODO: this is wildly insecure, and pretty shoddy design as well
      if Dir.exist? path
        @graph_directories = []
        @graph_files = []
        # Each file in the requested directory relative to the public/ directory
        Dir.new(path).entries.reject { |entry| %w( . .. ).include? entry }.map { |entry| File.join(relative_path, entry) }.each do |f|
          File.directory? f ? @graph_directories << f : @graph_files << f
        end
      else
        #TODO: how to render a default 404 template?
        @title = "404 Page Not Found"
        render :template => "public/404.html.haml", :layout => false, :status => 404
      end

    end
    #make sure it exists
  end

  private
  def get_msruns_from_array_of_ids(ids)
    ret = ids.map do |id|
      Msrun.get(id)
    end
    ret
  end
end
