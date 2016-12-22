object Challenge1 {

  val input = "01000100010010111"
  def invertByte(c: Char): Char = {
      if (c == '0'){
         '1'
      }
      else {
          '0'
      }
  }

  def invert(s: String): String = {
      s.map(c=>invertByte(c))
  }

  def dragonize(s: String): String = {
      s + "0" + invert(s reverse)
  }

  val dragonStream: Stream[String] = {
      def loop(s: String): Stream[String] = s #:: loop(dragonize(s))
      loop(input)
  }

  def main(args: Array[String]): Unit = {
    dragonStream take 3 foreach println
  }
}