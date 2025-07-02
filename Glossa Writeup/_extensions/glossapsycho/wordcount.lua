function Pandoc(doc)
  -- Count all words in the document (only plain text)
  local count = 0
  for _, el in pairs(doc.blocks) do
    if el.t == "Para" or el.t == "Plain" then
      local text = pandoc.utils.stringify(el)
      for _ in string.gmatch(text, "%S+") do
        count = count + 1
      end
    end
  end
  -- Inject the count as a metadata field
  if not doc.meta then doc.meta = {} end
  doc.meta.wordcount = pandoc.MetaString(tostring(count))
  return doc
end
