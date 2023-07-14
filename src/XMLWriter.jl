module XMLWriter

# XMLWriter Constants

STD_INDENT_SIZE = 2

# XMLWriter Types 

export AbstractXmlPreamble,
       AbstractXmlNode,
       XmlPreamble,
       XmlNode

abstract type AbstractXmlPreamble end
abstract type AbstractXmlNode end

Optional{T} = Union{T, Nothing}

XMLTags = Optional{Dict{String,String}}

mutable struct XmlPreamble <: AbstractXmlPreamble
  version::String
  encoding::Optional{String}
  standalone::Optional{String}
end

mutable struct XmlNode <: AbstractXmlNode 
  name::String
  tags::XMLTags
  child_nodes::Optional{Vector{XmlNode}}
end

XMLChildren = Optional{Vector{XmlNode}}

# XMLWriter Internal Helper Functions

function xmlnode_hastags(xmlnode::XmlNode)

  if isnothing(xmlnode.tags)
    return false
  end

  if isempty(xmlnode.tags)
    return false
  end

  return true

end

function xmlnode_haschildren(xmlnode::XmlNode)

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
    xmlnode::XmlNode,
    indent_size::Int64=STD_INDENT_SIZE,
    indent_depth::Int64=0
  )

  depth_indentation = (" " ^ indent_size)^indent_depth
  write(file, "$(depth_indentation)<$(xmlnode.name)")

  if xmlnode_hastags(xmlnode)
    for (key, value) in xmlnode.tags
      write(file, " $(key)=$(value)")
    end
  end

  if xmlnode_haschildren(xmlnode) == false
    write(file, "/>\n")
    return
  end
    
  write(file, ">\n")
  for child in xmlnode.child_nodes
    xmlnode_write(file, child, indent_size, indent_depth+1)
  end

  write(file, "$(depth_indentation)</$(xmlnode.name)>\n")

end

function xmlpreamble_write(
    file::IOStream,
    xmlpreamble::XmlPreamble
  )
  
  write(file, "<?xml ")
  
  write(file, "version=\"$(xmlpreamble.version)\" ")

  if isnothing(xmlpreamble.encoding) == false
    write(file, "encoding=\"$(xmlpreamble.encoding)\" ")
  end

  if isnothing(xmlpreamble.standalone) == false
    write(file, "standalone=\"$(xmlpreamble.standalone)\"")
  end

  write(file, "?>")

end

# XMLWriter Exported Functions

export xmlwriter_xmlnode_create,
       xmlwriter_xmlnode_addchild!,
       xmlwriter_xmlnode_addtag!,
       xmlwriter_xmlnode_write,
       xmlwriter_xmlpreamble_create

function xmlwriter_xmlnode_create(
    name::String,
    tags::XMLTags=nothing,
    child_nodes::XMLChildren=nothing
  )::XmlNode

  return XmlNode(name, tags, child_nodes)

end

function xmlwriter_xmlnode_addchild!(
    xmlnode::XmlNode,
    child::XmlNode
  )

  if isnothing(xmlnode.child_nodes)
    xmlnode.child_nodes = Vector{XmlNode}()
  end

  push!(
        xmlnode.child_nodes,
        child
  )

end

function xmlwriter_xmlnode_addchild!(
    xmlnode::XmlNode,
    child_name::String,
    tags::XMLTags=nothing,
    child_nodes::XMLChildren=nothing
  )::XmlNode

  if isnothing(xmlnode.child_nodes)
    xmlnode.child_nodes = Vector{XmlNode}()
  end

  new_child = XmlNode(
                  child_name,
                  tags,
                  child_nodes
  )
  
  push!(
        xmlnode.child_nodes,
        new_child
  )

  return new_child

end

function xmlwriter_xmlnode_addtag!(
    xmlnode::XmlNode,
    tag_name::String,
    tag_value::String
  )

  if isnothing(xmlnode.tags)
    xmlnode.tags = Dict{String, String}()
  end

  xmlnode.tags[tag_name] = tag_value

end


function xmlwriter_xmlnode_write(
    file_path::String,
    xmlnode::XmlNode,
    xmlpreamble::Optional{XmlPreamble}=nothing
  )

  open(file_path, "w") do file
    if isnothing(xmlpreamble) == false
      xmlpreamble_write(file, xmlpreamble)
      write(file, "\n")
    end

    xmlnode_write(file, xmlnode)
  end

end

function xmlwriter_xmlpreamble_create(
    version::String="1.0",
    encoding::Optional{String}=nothing,
    standalone::Optional{String}=nothing
  )
  
  return XmlPreamble(version, encoding, standalone)

end

end
