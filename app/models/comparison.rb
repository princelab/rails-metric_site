class Comparison
  include DataMapper::Resource
  property :id, Serial

  property :start_timestamp, DateTime
  property :end_timestamp, DateTime

  property :taxonomy, String

  has n, :firsts
  has n, :msrun_firsts, 'Msrun', :through => :firsts, :via => :msrun

  has n, :seconds
  has n, :msrun_seconds, 'Msrun', :through => :seconds, :via => :msrun

  #Produce a graph of the metrics in this comparison, or return it if it already exists.
  def graph
    met = ::Ms::NIST::Metric.new("")
    first = met.slice_matches self.msrun_firsts
    second = met.slice_matches self.msrun_seconds
    files = met.graph_matches first, second
  end
end
