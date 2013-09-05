module ApplicationHelper
  def split_str(str, len = 5)
    fragment = /.{#{len}}/
    str.split(/(\s+)/).map! { |word|
      (/\s/ === word) ? word : word.gsub(fragment, '\0<wbr />')
    }.join.html_safe
  end
  
  def html_format(string, max_width=5)
    text = string.gsub("\n", '<br />').html_safe.strip

    (text.length < max_width) ?
    text :
    text.scan(/.{1,#{max_width}}/).join("<wbr>")

    return text
  
  end

end
