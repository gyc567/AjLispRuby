
module AjLisp

class PrimitiveClosure < Primitive
    attr_reader :arguments
    attr_reader :body
    attr_reader :context
    
    def initialize(arguments, body, context=nil)
        @arguments = arguments
        @body = body
        @context = context
    end
    
    def apply(context, args)
        newcontext = context
        
        if @context then
            newcontext = @context
        end
    
        if @arguments
            newcontext = AjLisp::Context.new newcontext
            
            if @arguments.is_a? NamedAtom
                newcontext.setValue @arguments.name, AjLisp::List.make(args)
            else
                names = @arguments
            
                args.each do |arg|
                    name = names.first.name
                    newcontext.setValue name, arg
                    names = names.rest
                end
            end
        end
        
        result = nil

        @body.each do |form|
            result = AjLisp::evaluate newcontext, form
        end
        
        return result
    end
end

end

