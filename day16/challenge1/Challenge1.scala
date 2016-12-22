object Challenge1 {

  val input = "01000100010010111"
  val diskSize = 272
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

  def getDragon(input: String, maxSize: Int) : String = {
      if (input.length >= maxSize) {
          return input.slice(0, maxSize)
      }
      else {
          return getDragon(dragonize(input), maxSize)
      }
  }

  def reduce(s: String): String = {
      s.slice(1,4)
  }

  def condenseBytes(c1: Char, c2: Char): Char = {
      if (c1 == c2) '1' else '0'
  }

  def getChecksum(s: String):String = {
      if (s.length % 2 == 1) {
          s
      }
      else{
          val next:String = s.grouped(2).map(s => condenseBytes(s.charAt(0), s.charAt(1))).mkString
          getChecksum(next)
      }
  }




  def main(args: Array[String]): Unit = {
    val s:String = getDragon(input, diskSize)
    val checksum:String = getChecksum(s)
    println(checksum)
    
  }
}