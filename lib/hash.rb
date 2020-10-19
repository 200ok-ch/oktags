class Hash
  # like invert but not lossy. possibly a good blog post.
  def safe_invert
    inject({}) do |acc, (k, v)|
      if v.is_a? Array
        v.each do |vx|
          acc[vx] = acc[vx].nil? ? k : [acc[vx], k].flatten
        end
      else
        acc[v] = acc[v].nil? ? k : [acc[v], k].flatten
      end
      acc
    end
  end
end
