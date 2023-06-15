# XMLWriter | Elli's Julia Tools

## Usage

```text
document = xmlwriter_xmlnode_create("document")

xmlwriter_xmlnode_add_tag!(document, "name", "\"my_document\"")

child1 = xmlwriter_xmlnode_add_child!(document, "child1")

child2 = xmlwriter_xmlnode_add_child!(document, "child2")

child3 = xmlwriter_xmlnode_create("child3")

child4 = xmlwriter_xmlnode_add_child!(child2, "child4", Dict("a"=>"\"A\"", "b" =>"1.0"), [child3])

preamble = xmlwriter_xmlpreamble_create("1.0", "utf-8", "yes")

xmlwriter_xmlnode_write("./test-files/my_file.xml", document, preamble)
```

