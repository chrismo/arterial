require 'graphviz'

class GraphViz
  def all_nodes
    self.each_node.to_a.map { |ary| ary[1] }
  end
end