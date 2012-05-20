class WordCounter
  def initialize(sentences)
    @sentences = sentences
  end
  
  def sorted_table
    count.to_a.sort_by! {|row| -row[1].count }.collect {|row| {:word => row[0], :counts => row[1].count}}
  end
  
  private
  
  def count
    frequency_table = {}
    
    @sentences.each_with_index do |sentence, i|
      words = sentence.downcase.split(%r{\W+})
      words.each do |word|
        unless word =~ %r{\A\s*\Z}
          frequency_table[word] = frequency_table[word].to_a << (i + 1)
        end
      end
    end
    
    frequency_table
  end
end
