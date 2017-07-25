require 'spec_helper'

describe Arterial do
  def id_re(text)
    /#{Regexp.escape(text)}/
  end

  def assert_node(node, expected_text)
    node.id.should =~ id_re(expected_text)
  end

  def assert_edge(edge, expected_one, expected_two)
    edge.node_one =~ id_re(expected_one)
    edge.node_two =~ id_re(expected_two)
  end

  it 'should render single node if new_record' do
    p = Parent.new
    a = Arterial.new(p)
    a.graph.should_not be_nil

    nodes = a.graph.all_nodes
    nodes.length.should == 1
    assert_node(nodes[0], 'Parent [new]')
  end

  it 'should render single node if persisted' do
    p = Parent.create
    a = Arterial.new(p)
    a.graph.should_not be_nil

    nodes = a.graph.all_nodes
    nodes.length.should == 1
    assert_node(nodes[0], 'Parent 1')
  end

  it 'should render two new nodes with one edge' do
    c = Child.new
    p = Parent.new(children: [c])
    a = Arterial.new(p)
    a.graph.should_not be_nil

    nodes = a.graph.all_nodes
    nodes.length.should == 2
    assert_node(nodes[0], 'Parent [new]')
    assert_node(nodes[1], 'Child [new]')

    edges = a.graph.each_edge.to_a
    edges.length.should == 1
    assert_edge(edges[0], 'Parent [new]', 'Child [new]')
  end

  it 'should render faux blog fixture' do
    setup_faux_blog
    author = BlogAuthor.includes(:blog_posts => [{:blog_comments => :blog_reader}]).first
    author.should_not be_nil
    a = Arterial.new(author)
    a.graph.output(png: 'blog.png')
  end

  it 'should render supplier' do
    Supplier
  end
end