

module NestedResources

  class NestedResources
    attr_reader :controller
    attr_reader :resources

    def initialize(params, resources)
      @controller = params[:controller].split('/').last
      @given = {}
      @given_id = {}
      resources = [] if resources.blank?
      resources = [resources] unless resources.is_a?(Array)
      @resources  = resources.map{|v|
        v = v.to_s.underscore if v.is_a?(Class)
        v.to_sym
      }
      params.each { |k,v|
        @resources.each{|resource|
          key = (resource.to_s+"_id").to_sym
          @given_id[resource]= v if key == k.to_sym
        } 
      }
    end

    def path(original_path)
      original_path.split('/').map { |path|
        if path==controller
          respath=""
          @resources.each { |resource|
            respath += resource.to_s.pluralize+"/"+@given_id[resource].to_s+"/" unless @given_id[resource].blank?
          }
          respath+path
        else
          path
        end
      }.join("/")
    end

    def object(res)
      res = [res] if res.class != Array
      result = []
      res.each_index { |i|
        if i==res.length-1
          @resources.each{ |resource|
            result.push instance(resource) unless @given_id[resource].blank?
          }
        end
        result.push res[i]
      }
      result
    end

    alias_method :resource, :object
    alias_method :resources, :object

    def instance(name)
      name = name.to_s.underscore
      @given[name.to_sym] ||= name.to_s.camelize.constantize.find(@given_id[name.to_sym])
    end

    def exists?(name)
      name = name.to_s.underscore
      !!@given_id[name.to_sym]
    end

  end

end
