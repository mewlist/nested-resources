

module NestedResources

  class NestedResources
    attr_reader :controller
    attr_reader :resources

    def initialize(params, *resources)
      @controller = params[:controller].split('/').last
      @given = {}
      resources = [] if resources.blank?
      resources = [resources] if resources.class != Array
      @resources  = resources.map{|v| v.to_sym }
      params.each { |k,v|
        @resources.each{|resource|
          key = (resource.to_s+"_id").to_sym
          @given[resource]= eval(resource.to_s.camelize).find(v) if key == k.to_sym
        } 
      }
    end

    def path(original_path)
      original_path.split('/').map { |path|
        if path==controller
          respath=""
          @resources.each { |resource|
            respath += resource.to_s.pluralize+"/"+@given[resource].id.to_s+"/" unless @given[resource].blank?
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
            result.push @given[resource] unless @given[resource].blank?
          }
        end
        result.push res[i]
      }
      result
    end

    def instance(name)
      @given[name.to_sym]
    end

    def exists?(name)
      !!@given[name.to_sym]
    end

  end

end
