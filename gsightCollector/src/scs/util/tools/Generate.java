package scs.util.tools;

import java.io.FileWriter;
import java.io.IOException;
import java.util.Random;
 

public class Generate {
	private Random rand=new Random();
    public static final String SOURCES =
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";
 
    
	public static void main(String[] args) throws IOException {
		if(args.length!=3){
			System.out.println("[startId endId filePath]");
		}else{
			new Generate().generate(Integer.parseInt(args[0]),Integer.parseInt(args[1]),args[2]);
		}
	

	}
	public void generate(int startId,int endId,String filePath) throws IOException{
		FileWriter writer = new FileWriter(filePath);
		StringBuilder sBuilder=new StringBuilder();
		for(int i=startId;i<endId;i++){
			sBuilder.append("{\"index\":{\"_id\":\"").append(i).append("\"}}\r\n");
			writer.write(sBuilder.toString());
			sBuilder.setLength(0);
			sBuilder.append("{\"account_number\":").append(rand.nextInt(9999)).append(",\"balance\":").append(rand.nextInt(9999))
			.append(",\"firstname\":\"").append(generateSpaceString(30)).append("\",\"lastname\":\"").append(generateSpaceString(30)).append("\",\"age\":").append(rand.nextInt(99))
			.append(",\"gender\":\"F\",\"address\":\"677 Hope Street\",\"employer\":\"Fortean\",\"email\":\"wheelerayers@fortean.com\",\"city\":\"Ironton\",\"state\":\"PA\"}\r\n");
			writer.write(sBuilder.toString());
			sBuilder.setLength(0);
		}
		
		
		 
		writer.flush();
		writer.close();
		
	}

    /**
     * Generate a random string.
     *
     * @param random the random number generator.
     * @param characters the characters for generating string.
     * @param length the length of the generated string.
     * @return
     */
    public String generateString(int length) {
        char[] text = new char[length];
        for (int i = 0; i < length; i++) {
            text[i] = SOURCES.charAt(rand.nextInt(62));
        }
        return new String(text);
    }
    public String generateSpaceString(int length) {
    	StringBuilder sBuilder=new StringBuilder();
        for (int i = 0; i < length; i++) {
            sBuilder.append(SOURCES.charAt(rand.nextInt(62))).append(" ");
        }
        return sBuilder.toString();
    }
}
