function highlight(line_number)
  local highlighter = {
    CodeBlock = function(block)
      if block.classes:includes('highlight') then
        block.classes:insert('has-line-highlights')
        block.attributes["code-line-numbers"] = line_number
        return block
      end
  end
  }
  return highlighter
end

function add_highlight_class()
  return {
    CodeBlock = function(cb)
      if not cb.classes:includes('highlight') then
        cb.classes:insert('highlight')
      end
      return cb
    end
  }
end


function add_class_to_cb()
  return {
    Div = function(el)
      if el.classes:includes('cell-output') then
        return el:walk(add_highlight_class())
      end
    end
  }
end

function highlight_output_div()
  return {
    Div = function(div)
      if div.classes:includes('output-highlight') then
        return div:walk(add_class_to_cb())
      end
    end  
  }
end

function add_output_lnum()
  return {
    Div = function(el)
      if el.classes:includes('cell') then
        line_number = tostring(el.attributes["output-line-numbers"])
        return el:walk(highlight(line_number))
      end
    end
  }
end

function Pandoc(doc)
  if FORMAT == 'revealjs' then
    local doc = doc:walk(highlight_output_div())
    return doc:walk(add_output_lnum())
  end
end