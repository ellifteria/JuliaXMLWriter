# XMLWriter | Elli's Julia Tools

## Usage

```julia
include("~/.../XMLWriter.jl")
using .XMLWriter

document = xmlwriter_xmlnode_create("document")

xmlwriter_xmlnode_addtag!(document, "name", "\"my_document\"")

child1 = xmlwriter_xmlnode_addchild!(document, "child1")

child2 = xmlwriter_xmlnode_addchild!(document, "child2")

child3 = xmlwriter_xmlnode_create("child3")

child4 = xmlwriter_xmlnode_addchild!(child2, "child4", Dict("a"=>"\"A\"", "b" =>"1.0"), [child3])

child5 = xmlwriter_xmlnode_create("child5")

xmlwriter_xmlnode_addchild!(child4, child5)

preamble = xmlwriter_xmlpreamble_create("1.0", "utf-8", "yes")

xmlwriter_xmlnode_write("./test-files/my_file.xml", document, preamble)

```

### Output

```xml
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<document name="my_document">
  <child1/>
  <child2>
    <child4 b=1.0 a="A">
      <child3/>
      <child5/>
    </child4>
  </child2>
</document>
```

