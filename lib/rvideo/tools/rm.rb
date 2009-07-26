module RVideo
  module Tools
    class Rm
      include AbstractTool::InstanceMethods
      
      attr_reader :raw_metadata
      
      def tool_command
        'rm'
      end
      
      private
      
      def parse_result(result)
        if result.empty?
          @raw_metadata = "OK"
          return true
        end
        
        raise TranscoderError::UnexpectedResult, result
      end
      
    end
  end
end

