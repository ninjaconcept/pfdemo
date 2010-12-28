module ApplicationHelper
  def flash_messages
    msg = ''
    flash.each do |key, value|
      msg << <<-EOF
        <div id="flash-#{key}" class="flash-message #{key}">#{value}</div>
      EOF
    end
    msg.html_safe
  end
    
  # REVISION file is created while deploying
  def revision_string
    unless defined? @revision_string
      revision_file = File::join( Rails.root.to_s, 'REVISION' )
      @revision_string = if File.exists? revision_file
        File.open( revision_file ) do |file|
          file.readlines.first
        end
      end
    end
    @revision_string
  end
end
