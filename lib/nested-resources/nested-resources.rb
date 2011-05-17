

module NestedResources

  class NestedResources
    attr_reader :controller
    attr_reader :resources

    def initialize(params, *resources)
      @controller = params[:controller].split('/').last
      @given = {}
      @given_id = {}
      resources = [] if resources.blank?
      parse(resources)
      params.each { |k,v|
        @resources.each{|resource, resource_id|
          @given_id[resource]= v if resource_id == k.to_sym
        } 
      }
    end

    def parse(resource)
      @resources ||= {}
      if resource.is_a?(Array)
        resource.each{|v| parse(v) }
      elsif resource.is_a?(Hash)
        resource.each{|k, v| @resources[k.to_sym] = (v.to_s.underscore+"_id").to_sym}
      else
        @resources[resource.to_sym] = (resource.to_s.underscore+"_id").to_sym
      end
    end

    def path(original_path)
      original_path.split('/').map { |path|
        if path==controller
          respath=""
          @resources.each { |resource, resource_id|
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
          @resources.each{ |resource, resource_id|
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
