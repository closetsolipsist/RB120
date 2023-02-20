class Banner
  def initialize(message, banner_width = nil)
    @message = message
    if banner_width
      @box_width = [@message.size + 4, banner_width].max
    else
      @box_width = @message.size + 4
    end
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    '+' + '-' * (@box_width - 2) + '+'
  end

  def empty_line
    '|' + ' ' * (@box_width - 2) + '|'
  end

  def message_line
    "|" + @message.center(@box_width - 2) + "|"
  end
end

banner = Banner.new('To boldly go where no one has gone before.')
puts banner
=begin
+--------------------------------------------+
|                                            |
| To boldly go where no one has gone before. |
|                                            |
+--------------------------------------------+
=end
banner = Banner.new('')
puts banner
=begin
+--+
|  |
|  |
|  |
+--+
=end