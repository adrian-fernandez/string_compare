class String


  # @see https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance
  # @since 0.0.1
  # @param [String] str2 Text string which you want to compare the similarity
  # @return [float]
  def jaro_winkler(str2, winkleradjust=true)
    m = 0
    tr = 0

    s1 = self.strip.split(//)
    s2 = str2.strip.split(//)

    s1l = s1.length
    s2l = s2.length

    if s1l > s2l
      tmp = s2
      s2 = s1
      s1 = tmp
    end

    found = Hash[*s2.uniq.sort.collect { |v| [v,0]}.flatten]

    md = (([s1l,s2l].max / 2) - 1).to_i

    s1.each_with_index do |c,i|

      if !found[c].nil?
        if !s2.aindices(c)[found[c]].nil?
          x = (s2.aindices(c)[found[c]] - i).abs
          if x <= md 
            found[c] += 1
            m += 1
            if (x != 0)
              tr += 1
            end
          end
        end
      end
    end
    tr = (tr/2).to_i

    third = 1.0/3
    jd = (third * m / s1l) + (third * m / s2l) + (third * (m - tr) / m)
    out = jd

    if winkleradjust
      l = 0
      (0..s1l-1).each { |i| s1[i]==s2[i] ? l+=1 : break }
      out = jd + (l * 0.1 * (1 - jd))
    end

  end

  # @see https://en.wikipedia.org/wiki/Hamming_distance https://en.wikipedia.org/wiki/Hamming_distance
  # @since 0.0.1
  # @param [String] str2 Text string which you want to compare the similarity
  # @return [float]
  def hammingDistance(str2)
      raise "ERROR: Hamming: Non equal lengths" if self.length != str2.length
      (self.chars.zip(str2.chars)).count {|l, r| l != r}
  end

  # @see https://es.wikipedia.org/wiki/Distancia_de_Damerau-Levenshtein https://es.wikipedia.org/wiki/Distancia_de_Damerau-Levenshtein
  # @since 0.0.1
  # @param [String] str2 Text string which you want to compare the similarity
  # @return [float]
  def damerau_levenshtein(str2)
    d = Array.new(self.size+1){Array.new(str2.size+1)}
    for i in (0..self.size)
      d[i][0] = i
    end
    for j in (0..str2.size)
      d[0][j] = j 
    end
    self.each_char_with_index do |i,c1|
      str2.each_char_with_index do |j,c2|
        c = (c1 == c2 ? 0 : 1)
        d[i+1][j+1] = [
          d[i][j+1] + 1, #deletion
          d[i+1][j] + 1, #insertion
          d[i][j] + c].min #substitution
        if (i>0) and (j>0) and (self[i]==str2[j-1]) and (self[i-1]==str2[j])
          d[i+1][j+1] = [
            d[i+1][j+1],
            d[i-1][j-1] + c].min #transposition
        end
      end
    end
    d[self.size][str2.size]
  end

  # @since 0.0.1
  # @param [String] str2 Text string which you want to compare the similarity
  # @return [float]
  def dice_coefficient(str2)
    require 'set'

    a_bigrams = self.each_char.each_cons(2).to_set
    b_bigrams = str2.each_char.each_cons(2).to_set

    overlap = (a_bigrams & b_bigrams).size

    total = a_bigrams.size + b_bigrams.size
    dice  = overlap * 2.0 / total

    dice
  end

  # @see https://en.wikipedia.org/wiki/Cosine_similarity https://en.wikipedia.org/wiki/Cosine_similarity
  # @since 0.0.1
  # @param [String] str2 Text string which you want to compare the similarity
  # @return [float]
  def cosine(str2)
    return 1.0 if self == str2
    return 0.0 if self.empty? || str2.empty?

    v1 = Hash.new(0)
    self.each_char { |c| v1[c] += 1 }

    v2 = Hash.new(0)
    str2.each_char { |c| v2[c] += 1 }

    dot_product = 0

    v1.each do |k, v|
      dot_product += v * v2[k]
    end

    mag_v1 = Math.sqrt(v1.values.inject(0) { |a, e| a + e**2 })
    mag_v2 = Math.sqrt(v2.values.inject(0) { |a, e| a + e**2 })

    magnitude = mag_v1 * mag_v2
    dot_product / magnitude
  end

  # @see https://en.wikipedia.org/wiki/Needleman%E2%80%93Wunsch_algorithm https://en.wikipedia.org/wiki/Needleman%E2%80%93Wunsch_algorithm
  # @since 0.0.1
  # @param [String] str2 Text string which you want to compare the similarity
  # @return [float]
  def needle(sequence, reference)
    require 'mdarray'

    gap = -5
    s = { 'AA' => 10,
            'AG' => -1,
            'AC' => -3,
            'AT' => -4,
            'GA' => -1,
            'GG' =>  7,
            'GC' => -5,
            'GT' => -3,
            'CA' => -3,
            'CG' => -5,
            'CC' =>  9,
            'CT' =>  0,
            'TA' => -4,
            'TG' => -3,
            'TC' =>  0,
            'TT' =>  8 }

    rows = reference.length + 1
    cols = sequence.length + 1
    a = MDArray.new(rows, cols)

    for i in 0...(rows) do a[i,0] = 0 end
    for j in 0...(cols) do a[0,j] = 0 end
    for i in 1...(rows)

      for j in 1...(cols)
        choice1 = a[i-1, j-1] + s[(reference[i-1].chr + sequence[j-1].chr).upcase]
        choice2 = a[i-1, j] + gap
        choice3 = a[i, j-1] + gap
        a[i,j] = [choice1, choice2, choice3].max
      end
    end

    ref = ''
    seq = ''

    i = reference.length 
    j = sequence.length

    while (i > 0 and j > 0)
      score = a[i,j]
      score_diag = a[i-1, j-1]
      score_up = a[i, j-1]
      score_left = a[i-1, j]

      if (score == score_diag + s[reference[i-1].chr + sequence[j-1].chr])
        ref = reference[i-1].chr + ref
        seq = sequence[j-1].chr + seq
        i -= 1
        j -= 1
      elsif (score == score_left + gap)
        ref = reference[i-1].chr + ref
        seq = '-' + seq
        i -= 1
      elsif (score == score_up + gap)
        ref = '-' + ref
        seq = sequence[j-1].chr + seq
        j -= 1
      end
    end

    while (i > 0)
      ref = reference[i-1].chr + ref
      seq = '-' + seq
      i -= 1
    end

    while (j > 0)
      ref = '-' + ref
      seq = sequence[j-1].chr + seq
      j -= 1
    end

    [seq, ref] 
  end

  def each_char_with_index
    i = 0
    split(//).each do |c|
      yield i, c
      i += 1
    end
  end
end

class Array
   def select_with_index
     index = -1
     select { |x| index += 1; yield(x, index) }
   end

   def aindices(o)
     out = Array.new
     select_with_index { |x, i| 
       out << i if x == o }
      out
   end
end


