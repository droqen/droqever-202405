tool
extends Node
func rename_node(node):
	if node == self: return
	node.name = node.filename.rsplit('/',true,1)[1].split('.',true,1)[0]
