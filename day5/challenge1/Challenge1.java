import java.security.MessageDigest;
import java.util.stream.IntStream;
class Challenge1 
{
    static String doorId = "ffykfhsq";

    final protected static char[] hexArray = "0123456789ABCDEF".toCharArray();
    public static String bytesToHex(byte[] bytes) 
    {
        char[] hexChars = new char[bytes.length * 2];
        for ( int j = 0; j < bytes.length; j++ ) {
            int v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[v >>> 4];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return new String(hexChars);
    }

    public static String md5(int index)
    {
        try
        {
            MessageDigest md = MessageDigest.getInstance("MD5");
            String str = doorId+new Integer(index).toString();
            byte[] digest = md.digest(str.getBytes("UTF-8"));
            return new String(Challenge1.bytesToHex(digest)); 
        }
        catch(Exception e)
        {
            return "";
        }
    }

    public static boolean isAGoodHash(int index)
    {
        String hash = Challenge1.md5(index);
        return hash.startsWith("00000");
    }

    public static int getKey(int index)
    {
        String hash = Challenge1.md5(index);
        return hash.charAt(5);
    }

    public static void main(String[] args)
    {
        
        IntStream.iterate(0, i-> i+1)
                 .filter(Challenge1::isAGoodHash)
                 .limit(8)
                 .map(Challenge1::getKey)
                 .forEach(i -> System.out.print((char)i));
        System.out.println();
    }
}