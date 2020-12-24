class MNIST::Image
  getter images : Array(Slice(UInt8)) = [] of Slice(UInt8)
  getter number_images : Int32
  getter number_rows : Int32
  getter number_columns : Int32

  def initialize(pathfile : String)
    file = File.new pathfile
    data = Bytes.new file.size
    file.read data
    file.close
    raise "MNIST wrong magic number" if IO::ByteFormat::BigEndian.decode(Int32, data[0..4]) != 2051
    @number_images = IO::ByteFormat::BigEndian.decode(Int32, data[4..8])
    @number_rows = IO::ByteFormat::BigEndian.decode(Int32, data[8..12])
    @number_columns = IO::ByteFormat::BigEndian.decode(Int32, data[12..16])
    self.load_images data, 16
  end

  private def load_images(data : Bytes, startOffset : UInt32)
    numberPixels = @number_columns * @number_rows
    index = 0_u32
    while index < @number_images -1
      start = startOffset + numberPixels * index
      stop = startOffset + numberPixels * (index + 1)
      @images << data[start..stop]
      index += 1
    end
  end
end
