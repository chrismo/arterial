require 'spec_helper'

describe Arterial do
  def id_re(text)
    /#{Regexp.escape(text)}/
  end

  it 'should render single node if new_record' do
    p = Parent.new
    a = Arterial.new(p)
    a.graph.should_not be_nil

    nodes = a.graph.all_nodes
    nodes.length.should == 1
    nodes[0].id.should =~ /^Parent \[new\]/
  end

  it 'should render single node if persisted' do
    p = Parent.create
    a = Arterial.new(p)
    a.graph.should_not be_nil

    nodes = a.graph.all_nodes
    nodes.length.should == 1
    nodes[0].id.should =~ /^Parent 1/
  end

  it 'should render two new nodes with one edge' do
    c = Child.new
    p = Parent.new(children: [c])
    a = Arterial.new(p)
    a.graph.should_not be_nil

    nodes = a.graph.all_nodes
    nodes.length.should == 2
    nodes[0].id.should =~ /^Parent \[new\]/
    nodes[1].id.should =~ /^Child \[new\]/

    edges = a.graph.each_edge.to_a
    edges.length.should == 1
    edges[0].node_one =~ id_re('Parent [new]')
    edges[0].node_two =~ id_re('Child [new]')
  end
end