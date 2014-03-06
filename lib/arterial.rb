require 'tmpdir'

require 'arterial/graphviz_monkeypatch'
require 'arterial/version'

require 'graphviz'

class Arterial
  def self.version
    '0.0.1'
  end

  attr_reader :graph

  def initialize(root)
    @root = root
    build_graph
    self
  end

  class ArNodePair < Struct.new(:ar, :node)
  end

  def build_graph
    @graph = GraphViz.new(:G, :type => :digraph)

    stack = [@root]
    @pairs = []
    until stack.empty? do
      ar = stack.pop
      source_pair = add_node_pair(ar)
      @pairs << source_pair
      ar.association_cache.each do |name, assoc|
        [assoc.target].flatten.each do |target|
          target_pair = add_node_pair(target)
          @graph.add_edges(source_pair.node, target_pair.node, label: name)
          stack.push target_pair.ar unless already_in_pairs(target_pair)
        end
      end
    end
  end

  def add_node_pair(ar)
    node = @graph.add_nodes("#{ar.class.to_s} #{ar.new_record? ? '[new]' : ar.id}\nobj_id: #{ar.object_id}")
    ArNodePair.new(ar, node)
  end

  # matches on ActiveRecord object_id, because we WANT to see
  # potentially duplicate ARs in different instances
  def already_in_pairs(this_pair)
    @pairs.each do |a_pair|
      return true if a_pair.ar.object_id == this_pair.ar.object_id
    end
    false
  end

  def to_dot
    @graph.to_s
  end

  def to_dot_rendered_dot
    # this is a dot file that dot itself renders, which includes a lot of
    # additional layout data that gets cluttery and not really necessary.
    Dir.mktmpdir('arterial') do |dir|
      fn = File.join(dir, 'dot')
      @graph.output(dot: fn, no_layout: 0)
      return File.read(fn)
    end
  end
end