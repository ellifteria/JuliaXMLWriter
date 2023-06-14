include("XMLWriter.jl")

using .XMLWriter

A = xmlwriter_xmldoc_create("hello")

println(A.doc_name)

xmlwriter_xmldoc_add_child!(A, "hi")

println(A.child_nodes[1].name)

