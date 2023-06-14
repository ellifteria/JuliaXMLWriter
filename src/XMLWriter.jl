module XMLWriter

# XMLWriter Types 

Optional{T} = Union{T, Nothing}

XMLTags = Optional{Dict{String,String}}

mutable struct XmlNode 
  name::String
  tags::XMLTags
  child_nodes::Optional{Vector{XmlNode}}
end

XMLChildren = Optional{Vector{XmlNode}}

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

function xmlnode_write(
    file::IOStream,
    xmlnode::XmlNode
  )

  write(file, "<$(xmlnode.name)")

  if xmlnode_has_tags(xmlnode)
    for (key, value) in xmlnode.tags
      write(file, " $(key)=$(value)")
    end
  end

  if xmlnode_has_children(xmlnode) == false
    write(file, " />\n")
    return
  end
    
  write(file, ">")
  for child in xmlnode.child_nodes
    write(file, "\n")
    xmlnode_write(file, child)
  end

  write(file, "</$(xmlnode.name)>\n")

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

function xmlwriter_xmlnode_add_tag!(
    xmlnode::XmlNode,
    tag_name::String,
    tag_value::String
  )

  if isnothing(xmlnode.tags)
    xmlnode.child_nodes = Dict{String, String}()
  end

  xmlnode.tags[tag_name] = tag_value

end


function xmlwriter_xmlnode_write(
    file_path::String,
    xmlnode::XmlNode
  )

  open(file_path, "w") do file
    xmlnode_write(file, xmlnode)
  end

end

end
