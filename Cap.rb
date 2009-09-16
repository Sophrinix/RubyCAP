module Cap
  class Alert
    
   attr_accessor  :identifier, :sender, :sent, :status, :msg_type,
                  :source, :scope, :restriction, :addresses, :codes,
                  :note, :references, :incidents
    
    @addresses = []
    
    def initialize
      generate_identifier      
      
      @addresses = []
      @codes = []
      @references = []
      @incidents = []
    end           
                  
    def generate_identifier
      @identifier = Time.now.to_i.to_s + rand.to_s
    end 
    
    class Info
      
      attr_accessor :language, :categories, :event, :response_types,
                    :urgency, :severity, :certainty, :audience,
                    :event_codes, :effective, :onset, :expires,
                    :sender_name, :headline, :description,
                    :instruction, :web, :contact, :parameters
      
      class Resource
        attr_accessor :resource_desc, :mime_type, :size, :uri,
                      :deref_uri, :digest
      end
      class Area
        attr_accessor :area_desc, :polygons, :circles, :geocodes,
                      :altitude, :ceiling
      end
    end
  end
end