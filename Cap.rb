require 'rubygems'
require 'builder'

class Float
  def round_to(x)
    (self * 10**x).round.to_f / 10**x
  end
end

module Cap  
  class Alert
    
    @@FIELDS = [:identifier, :sender, :sent, :status, :msg_type,
                    :source, :scope, :restriction, :addresses, :codes,
                    :note, :references, :incidents]
    
    attr_accessor *@@FIELDS
        
    def initialize
      generate_identifier      
      
      @addresses = []
      @codes = []
      @references = []
      @incidents = []
    end
    
    def add_address(addr)
      @addresses << addr
    end
    
    def add_code(code)
      @codes << code
    end
    
    def add_references(ref)
      @references << ref
    end
    
    def add_incident(inc)
      @incidents << inc
    end
                  
    def generate_identifier
      @identifier = Time.now.to_i.to_s + rand.to_s
    end
    
    def to_xml(x = nil)
      x ||= Builder::XmlMarkup.new(:indent => 4)
      x.alert {
        (@@FIELDS - [:addresses, :codes, :references, :incidents]).each do |f|
          x.send f, instance_variable_get(f)
        end
        x.addresses((@addresses.map {|a| "\"#{a}\""}).join(' '))
        [:codes, :incidents].each do |f|
          instance_variable_get(f).each {|i| x.send f, i }
        end
      }
      x
    end
    
    class Reference
      attr_accessor :sender, :identifier, :sent
      
      def initialize(*params)
        if params[0].is_a? Hash
          @sender = params[:sender]
          @identifier = params[:identifier]
          @sent = params[:sent]
        end
      end
      
      def to_xml(x = nil)
        x ||= Builder::XmlMarkup.new(:indent => 4)
        x.reference "#{@sender},#{@identifier},#{@sent}"
        x
      end
    end
    
    class Info
      
      attr_accessor :language, :categories, :event, :response_types,
                    :urgency, :severity, :certainty, :audience,
                    :event_codes, :effective, :onset, :expires,
                    :sender_name, :headline, :description,
                    :instruction, :web, :contact, :parameters
      def initialize
        @response_types = []
        @event_codes = []
        @parameters = []
      end
      def add_response_type(rt)
        @response_types << rt
      end
      def add_event_code(ec)
        @event_code << ec
      end
      def add_parameter(p)
        @parameters << p
      end
      
      class Resource
        attr_accessor :resource_desc, :mime_type, :size, :uri,
                      :deref_uri, :digest
      end
      class Area
        attr_accessor :area_desc, :polygons, :circles, :geocodes,
                      :altitude, :ceiling
                      
        def initialize
          @polygons = []
          @circles = []
          @geocodes = []
        end
        
        class Coordinate
          attr_accessor :latitude, :longitude
          def initialize(*params)
            if params[0].is_a? Hash
              @latitude = params[0][:latitude]
              @longitude = params[0][:longitude]
            end 
          end
          def to_s
            "#{@latitude.round_to(2).to_s},#{@longitude.round_to(2).to_s}"
          end
        end
        
        class Polygon
          attr_accessor :coordinates
          def initialize(*params)
            @coordinates = params
          end
          def to_xml(x = nil)
            x ||= Builder::XmlMarkup.new(:indent => 4)
            x.polygon @coordinates.join(' ')
            x
          end
        end
      end
    end
  end
end

a = Cap::Alert.new
p a.to_s