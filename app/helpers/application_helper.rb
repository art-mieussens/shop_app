#Encoding: utf-8
module ApplicationHelper
  
  def icon(name)
    image_tag '/images/icons/large/'<<name<<'.png'
  end
  
  def link_back
    link_to (image_tag "icons/large/back.png", :alt => 'regresar'), :back
  end

  def focus_on_load(element)
    javascript_tag "window.onload = function() { document.getElementById('#{element}').focus(); }"
	end
  
  def disable_enter
    javascript_tag %#
      function stopRKey(evt) { 
        var evt = (evt) ? evt : ((event) ? event : null); 
        var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null); 
        if ((evt.keyCode == 13) && (node.type=="text"))  {return false;} 
      } 
      document.onkeypress = stopRKey;
    #
  end
  
  def to_euros(string)
    number_to_currency string,  :unit => "€",
                                :separator => ",",
                                :delimiter => ".",
                                :format => "%n %u",
                                :negative_format => "-%n %u"
  end
  
end
