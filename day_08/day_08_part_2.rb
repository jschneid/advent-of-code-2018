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

def get_node_value(node)
  return 0 if node.nil?
  return node.metadata_sum if node.child_nodes.count.zero?

  total_value = 0
  node.metadata.each do |child_node_index|
    child_node = node.child_nodes[child_node_index - 1]
    total_value += get_node_value(child_node)
  end
  total_value
end

input_queue = File.read('input.txt').split(' ')

head_node = process_node(input_queue)

p get_node_value(head_node)
