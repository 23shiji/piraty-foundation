require 'nokogiri'
doc = Nokogiri::XML.parse File.read 'src.svg'
cx = cy = 1024
r_out = 1024
r_in  = 512
doc.css("//path").each do |pt|
    # next unless /^path(\d+)$/ === pt[:id]
    id = $1.to_i
    vs = pt[:d].scan(/((?<t>M|L)(?<v1>-?\d+),(?<v2>-?\d+))/).map do |t, v1, v2|
        [v1, v2].map(&:to_i)
    end
    x, y = vs.transpose.map{|x| x.reduce(&:+) / x.length}
    dist = Math.sqrt((cx - x) ** 2 + (cy - y) ** 2)
    pt['fill']="#000000"
    pt['stroke']="#000000" 
    pt['stroke-width']="1.3"
    if dist < r_in || dist > r_out || rand < 0.6
        pt.remove
    end
end
File.write 'dst.svg', doc.to_xml