class MNIST::Label
  getter items : Array(UInt8) = [] of UInt8
  getter number_items : Int32

  def initialize(pathfile : String)
    file = File.new pathfile
    data = Bytes.new file.size
    file.read data
    file.close
    raise "MNIST wrong magic number" if IO::ByteFormat::BigEndian.decode(Int32, data[0..4]) != 2049
    @number_items = IO::ByteFormat::BigEndian.decode(Int32, data[4..8])
    self.load_items data, 8
  end

  private def load_items(data : Bytes, startOffset : UInt32)
    index = 0_u32
    while index < @number_items
      @items << data[startOffset + index]
      index += 1
    end
  end
end
