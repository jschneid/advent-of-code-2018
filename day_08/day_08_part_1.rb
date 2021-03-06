class Node
  attr_accessor :child_nodes_quantity
  attr_accessor :metadata_quantity
  attr_accessor :child_nodes
  attr_accessor :metadata

  def metadata_sum
    @metadata.inject(0, :+)
  end
end

def process_node(input_queue)
  node = Node.new
  node.child_nodes_quantity = input_queue.shift.to_i
  node.metadata_quantity = input_queue.shift.to_i
  node.child_nodes = []
  node.child_nodes_quantity.times do
    node.child_nodes << process_node(input_queue)
  end
  node.metadata = []
  node.metadata_quantity.times do
    node.metadata << input_queue.shift.to_i
  end
  node
end

def walk_tree_sum_metadata(node)
  children_metadata_sum = 0
  node.child_nodes.each do |child_node|
    children_metadata_sum += walk_tree_sum_metadata(child_node)
  end
  node.metadata_sum + children_metadata_sum
end

input_queue = File.read('input.txt').split(' ')

head_node = process_node(input_queue)

p walk_tree_sum_metadata(head_node)
