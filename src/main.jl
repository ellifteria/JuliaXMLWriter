include("XMLWriter.jl")

using .XMLWriter

A = xmlwriter_xmlnode_create("hello")

println(A.name)

xmlwriter_xmlnode_add_child!(A, "hi")

println(A.child_nodes[1].name)

B = xmlwriter_xmlnode_create("test")

xmlwriter_xmlnode_write("test.xml", B)

