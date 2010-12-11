module Lokka
  module GreeSocialFeedback
    def self.registered(app)
      app.get '/admin/plugins/gree_social_feedback' do
        haml :"plugin/lokka-gree_social_feedback/views/index", :layout => :"admin/layout"
      end 

      app.put '/admin/plugins/gree_social_feedback' do
        params.each_pair do |key, value|
          eval("Option.#{key}='#{value}'")
        end 
        flash[:notice] = t.gree_social_feedback_updated
        redirect '/admin/plugins/gree_social_feedback'
      end 

      app.get %r{^/([0-9a-zA-Z-]+)/gree_social_feedback$} do |id_or_slug|
        @url = "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}/#{id_or_slug}"
        @entry = Entry.get_by_fuzzy_slug(id_or_slug)
        return 404 if @entry.blank?
        haml :"plugin/lokka-gree_social_feedback/views/gree_social_feedback", :layout => false
      end
    end
  end

  module Helpers
    def html_properties 
      s = yield_content :html_properties
      s unless s.blank?
    end

    def gree_social_feedback
      url = URI.encode("#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}#{env['PATH_INFO']}/gree_social_feedback")
      type = Option.gree_social_feedback_button
      height = Option.gree_social_feedback_height
      %Q(<iframe src="http://share.gree.jp/share?url=#{url}&type=#{type}&height=#{height}" scrolling="no" frameborder="0" marginwidth="0" marginheight="0" style="border:none; overflow:hidden; width:100px; height:#{height}px;" allowTransparency="true"></iframe>)
    end
  end
end

class String
  def jleft(len)
    return "" if len <= 0

    str = self[0,len]
    if /.\z/ !~ str
      str[-1,1] = ''
    end
    str
  end
end

