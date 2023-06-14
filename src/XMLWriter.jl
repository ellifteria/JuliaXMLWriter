module XMLWriter

# XMLWriter Internal Types 

abstract type AbstractXmlNode end
abstract type AbstractXmlDoc end

Optional{T} = Union{T, Nothing}

XMLChildren = Optional{Vector{AbstractXmlNode}}
XMLTags = Optional{Dict{String,String}}

# XMLWriter Composite XML Data Types

mutable struct XmlNode <: AbstractXmlNode
  name::String
  tags::XMLTags
  child_nodes::XMLChildren
end

mutable struct XmlDoc <: AbstractXmlDoc
  doc_name::String
  tags::XMLTags
  child_nodes::XMLChildren
end

# XMLWriter Internal Helper Functions

function xmldoc_has_tags(xmldoc::XmlDoc)
  if isnothing(xmldoc.tags)
    return false
  end

  if isempty(xmldoc.tags)
    return false
  end

  return true
end

function xmldoc_has_children(xmldoc::XmlDoc)
  if isnothing(xmldoc.child_nodes)
    return false
  end

  if isempty(xmldoc.child_nodes)
    return false
  end

  return true
end

# XMLWriter Exported Functions

export xmlwriter_xmldoc_create,
       xmlwriter_xmldoc_add_child!,
       xmlwriter_xmlnode_add_child!,
       xmlwriter_xmldoc_add_tag!,
       xmlwriter_xmlnode_add_tag!,
       xmlwriter_xmldoc_write

function xmlwriter_xmldoc_create(
    doc_name::String,
    tags::XMLTags=nothing,
    child_nodes::XMLChildren=nothing
  )
  return XmlDoc(doc_name, tags, child_nodes)
end

function xmlwriter_xmldoc_add_child!(
    xmldoc::XmlDoc,
    child_name::String,
    tags::XMLTags=nothing,
    child_nodes::XMLChildren=nothing
  )

  if isnothing(xmldoc.child_nodes)
    xmldoc.child_nodes = Vector{XmlNode}()
  end

  push!(
        xmldoc.child_nodes,
        XmlNode(
                child_name,
                tags,
                child_nodes
               )
       )
end

function xmlwriter_xmlnode_add_tag!()

end


function xmlwriter_xmldoc_write(
    file_path::String,
    xmldoc::XmlDoc
  )
  open(file_path, "w") do file
    write(file, "<")
    write(file, xmldoc.doc_name)

    if xmldoc_has_children(xmldoc) == false
      write(file, "/>\n")
      return
    end
  end
end

end
