module XMLWriter

# XMLWriter Internal Types 

abstract type AbstractXmlNode end

Optional{T} = Union{T, Nothing}

XMLChildren = Optional{Vector{AbstractXmlNode}}
XMLTags = Optional{Dict{String,String}}

# XMLWriter Composite XML Data Types

mutable struct XmlNode <: AbstractXmlNode
  name::String
  tags::XMLTags
  child_nodes::XMLChildren
end

# XMLWriter Internal Helper Functions

function xmlnode_has_tags(xmlnode::XmlNode)
  if isnothing(xmlnode.tags)
    return false
  end

  if isempty(xmlnode.tags)
    return false
  end

  return true
end

function xmlnode_has_children(xmlnode::XmlNode)
  if isnothing(xmlnode.child_nodes)
    return false
  end

  if isempty(xmlnode.child_nodes)
    return false
  end

  return true
end

# XMLWriter Exported Functions

export xmlwriter_xmlnode_create,
       xmlwriter_xmlnode_add_child!,
       xmlwriter_xmlnode_add_tag!,
       xmlwriter_xmlnode_write

function xmlwriter_xmlnode_create(
    name::String,
    tags::XMLTags=nothing,
    child_nodes::XMLChildren=nothing
  )
  return XmlNode(name, tags, child_nodes)
end

function xmlwriter_xmlnode_add_child!(
    xmlnode::XmlNode,
    child_name::String,
    tags::XMLTags=nothing,
    child_nodes::XMLChildren=nothing
  )

  if isnothing(xmlnode.child_nodes)
    xmlnode.child_nodes = Vector{XmlNode}()
  end

  push!(
        xmlnode.child_nodes,
        XmlNode(
                child_name,
                tags,
                child_nodes
               )
       )
end

function xmlwriter_xmlnode_add_tag!()

end


function xmlwriter_xmlnode_write(
    file_path::String,
    xmlnode::XmlNode
  )
  open(file_path, "w") do file
    write(file, "<")
    write(file, xmlnode.name)

    if xmlnode_has_children(xmlnode) == false
      write(file, "/>\n")
      return
    end
  end
end

end
