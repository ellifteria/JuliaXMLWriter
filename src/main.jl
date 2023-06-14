include("XMLWriter.jl")

using .XMLWriter

A = xmlwriter_xmlnode_create("hello")

println(A.name)

xmlwriter_xmlnode_add_child!(A, "hi")

println(A.child_nodes[1].name)

C = xmlwriter_xmlnode_create("hihihi", Dict("c"=>"\"C\""))

B = xmlwriter_xmlnode_create("test", Dict("a"=>"\"A\"", "b" =>"1.0"), [A, C])

xmlwriter_xmlnode_write("test.xml", B)

