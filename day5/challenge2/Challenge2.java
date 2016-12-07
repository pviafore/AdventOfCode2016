import java.security.MessageDigest;
import java.util.stream.IntStream;
import java.util.*;

class Challenge2 
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
            return new String(Challenge2.bytesToHex(digest)); 
        }
        catch(Exception e)
        {
            return "";
        }
    }

    public static boolean isValidPosition(char c)
    {
        return c >= '0' && c <= '7';
    }

    public static boolean isAGoodHash(String hash)
    {
        return hash.startsWith("00000") && isValidPosition(hash.charAt(5));
    }


    public static void main(String[] args)
    {
        
        Iterator<String> it = IntStream.iterate(0, i-> i+1)
                                .mapToObj(Challenge2::md5)
                                .filter(Challenge2::isAGoodHash)
                                .iterator();
        List<Character> keys =  Arrays.asList('-', '-','-','-','-','-','-','-');
        while (it.hasNext())
        {
            String s = it.next();
            char pos = (char)(s.charAt(5) - 48);
            char c = s.charAt(6);
            if(keys.get(pos) == '-')
            {
                keys.set(pos,  c);
            }
            if(!keys.contains('-'))
            {
                break;
            }
        }

        keys.stream().forEach(c -> System.out.print(c));
        System.out.println();
    }
}