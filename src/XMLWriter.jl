module XMLWriter

export xmlwriter_xmldoc_create,
       xmlwriter_xmldoc_add_child!,
       xmlwriter_xmlnode_add_child!,
       xmlwriter_xmldoc_write,
       xmlwriter_xmlnode_add_tag!

Optional{T} = Union{T, Nothing}

mutable struct XmlNode
  name::String
  tags::Optional{Dict{String,Any}}
  child_nodes::Optional{Vector{XmlNode}}
end

mutable struct XmlDoc
  doc_name::String
  child_nodes::Optional{Vector{XmlNode}}
end

function xmlwriter_xmldoc_create(doc_name::String)
  return XmlDoc(doc_name, nothing)
end

function xmlwriter_xmldoc_add_child!(
    xml_doc::XmlDoc,
    node_name::String,
    tags::Optional{Dict{String, Any}}=nothing,
    child_nodes::Optional{Vector{XmlNode}}=nothing
  )

  if isnothing(xml_doc.child_nodes)
    xml_doc.child_nodes = Vector{XmlNode}()
  end

  push!(
        xml_doc.child_nodes,
        XmlNode(
                node_name,
                tags,
                child_nodes
               )
       )
end

function xmlwriter_xmlnode_add_tag!()

end

function xmlwriter_xmldoc_write(file_path::String, xml_obj::XmlDoc)

end

end
