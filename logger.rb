module Logger
  def self.included(base)
    base.class_eval do
      def self.log_around(message, *args)
        names = args.flatten.map(&:to_sym)
        names.each do |name|
          alias_method "log_#{name}".to_sym, name.to_sym
          define_method(name) do |*args, &blck|
            start_time = Time.now
            puts "call #{name} with args #{args.inspect} #{'and a block if blck'}"
            result = send "log_#{name}".to_sym, *args, &blck
            end_time = Time.now - start_time
            puts "called #{name} with args #{args.inspect} (#{end_time}s)"
            result
          end
        end
      end
    end
  end
end