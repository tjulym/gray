package scs.util.tools;

 
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

/**
 * 数据格式化工具类
 * @author YangYanan
 * @desc 进制转换,字符串倒置等
 * @date 2017-8-18
 */
public class DataFormats {
	private static DataFormats dataFormat=null;
     
	private DataFormats(){}

	public synchronized static DataFormats getInstance() {
		if (dataFormat == null) {  
			dataFormat = new DataFormats();
		}  
		return dataFormat;
	}
	public float subFloat(float value,int length){
		System.out.println(value);
		BigDecimal bd=new BigDecimal((double)value);    
		bd=bd.setScale(length,RoundingMode.HALF_UP);
		return bd.floatValue();   
	}
	/**
	 * 2位16进制数转8位2进制
	 * @param hexStr 2位16进制数 例如 1F 
	 * @return 8位2进制,左端补0
	 */
	public String hexToBinary(String hexStr,int binLength){
		StringBuilder zeroStr=new StringBuilder();
		for(int i=0;i<binLength;i++){
			zeroStr.append("0");
		} 
		String binStr = Integer.toBinaryString(Integer.parseInt(hexStr, 16));
		return zeroStr.substring(0, binLength - binStr.length()) + binStr;//进行补位操作,左端补0凑成8位二进制数
	}
	/**
	 * 8位2进制数转2位16进制数
	 * @param binStr 8位2进制,左端补0
	 * @return 2位16进制数 例如 1F 
	 */
	public String binaryToHex(String binStr){
		String zeroStr="00";
		String hexStr=Integer.toHexString(Integer.parseInt(binStr,2));//16进制转2进制
		return zeroStr.substring(0,2-hexStr.length())+hexStr;//进行补位操作,左端补0凑成8位二进制数
	}
	/**
	 * 10进制数转指定位数位数的2进制
	 * @param intStr 2位16进制数 例如 1F 
	 * @param length 2进制字符串的长度
	 * @return 8位2进制,左端补0
	 */
	public String decimalToBinary(int decimal,int length){
		StringBuffer zeroStr=new StringBuffer();
		for(int i=0;i<length;i++){
			zeroStr.append("0");
		}
		String binStr=Integer.toBinaryString(decimal);//10进制转2进制
		return zeroStr.substring(0,length-binStr.length())+binStr;//进行补位操作,左端补0凑成8位二进制数
	}
	/**
	 * 10进制数转3位或8位16进制数
	 * @param decimal 10进制数
	 * @return
	 */
	public String decimalToHex(int decimal){
		String result="";
		String binStr=Integer.toHexString(decimal);//10进制转16进制
		int length=binStr.length();
		if(length>3&&length<=8){
			result="00000000".substring(0,8-length)+binStr;
		}else if(length>=0&&length<=3){
			result="000".substring(0,3-length)+binStr;
		}
		return result;//进行补位操作,左端补0凑成8位二进制数
	}
	/**
	 * 10进制数转指定位数16进制数
	 * @param decimal 10进制数
	 * @return 指定位数16进制数
	 */
	public String decimalToHex(int decimal,int length){
		StringBuffer zeroStr=new StringBuffer();
		for(int i=0;i<length;i++){
			zeroStr.append("0");
		}
		String binStr=Integer.toHexString(decimal).toUpperCase();//10进制转2进制
		return zeroStr.substring(0,length-binStr.length())+binStr;//进行补位操作,左端补0凑成8位二进制数
	}

	/**
	 * 字符串倒置输出 8位一组 倒置输出
	 * @param oldStr 旧字符串 例如:"111111112222222"
	 * @return 倒置后的新字符串 例如:"222222211111111"
	 */
	public String reverseStr(String oldStr){
		char[] tmp=oldStr.toCharArray();
		int length=tmp.length;
		int rows=length>>3;
		List<String> rowsList=new ArrayList<String>();
		for(int i=0;i<rows;i++){
			rowsList.add(oldStr.substring((i<<3),(i<<3)+8));
		}
		StringBuffer newStr=new StringBuffer();
		for(int i=rows-1;i>=0;i--)
			newStr.append(rowsList.get(i));
		return newStr.toString();
	}
	 
	public static void main(String[] args){
		System.out.println(DataFormats.getInstance().decimalToHex(65535,4));
	}

}
