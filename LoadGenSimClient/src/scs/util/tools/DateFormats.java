package scs.util.tools;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 自定义日期格式化类
 * @author YangYanan
 * @desc 
 * @date 2017-8-18
 */
public class DateFormats {
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyyMMddhhmmssSSS");

	private Calendar calendar = Calendar.getInstance();
	
	private static DateFormats dateFormat=null;
	
	private DateFormats(){}
	
	public synchronized static DateFormats getInstance() {
		if (dateFormat == null) {  
			dateFormat = new DateFormats();
		}  
		return dateFormat;
	}
	/**
	 * 日期格式转换
	 * @param date 时间字符串
	 * @return 时间格式 yyyy-MM-dd HH:mm:ss
	 */
	public String getNowDate(){
		Date d=new Date();
		try{
			return sdf.format(d);
		}catch(Exception e){
			return "";
		}
	}
	public static void main(String args[]){
		System.out.println(new DateFormats().getNowDate1());
		System.out.println(new DateFormats().getNowDate1());
	}
	/**
	 * 日期格式转换
	 * @param date 时间字符串
	 * @return 时间格式 yyyyMMddHHmmssSSS
	 */
	public String getNowDate1(){
		Date d=new Date();
		try{
			return sdf1.format(d);
		}catch(Exception e){
			return "";
		}
	}

	/**
	 * 日期字符串转换成时间
	 * @param date
	 * @return
	 */
	public long dateStringToTime(String date){

		try {
			String hourEL = "^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}$";
			String dateEL = "^[0-9]{4}-[0-9]{2}-[0-9]{2}$";
			String mouthEL = "^[0-9]{4}-[0-9]{2}$";
			Pattern ph = Pattern.compile(hourEL);

			Matcher mh = ph.matcher(date);
			boolean dateFlagH = mh.matches();

			Pattern pd = Pattern.compile(dateEL);
			Matcher md = pd.matcher(date);
			boolean dateFlagD = md.matches();

			Pattern pm = Pattern.compile(mouthEL);
			Matcher mm = pm.matcher(date);
			boolean dateFlagM = mm.matches();

			SimpleDateFormat s=null;
			Date d =null;

			if (dateFlagH) {
				s = new SimpleDateFormat("yyyy-MM-dd HH");
				d = s.parse(date);
			}else if(dateFlagD) {
				s = new SimpleDateFormat("yyyy-MM-dd");
				d = s.parse(date);
			}else if(dateFlagM) {
				s = new SimpleDateFormat("yyyy-MM");
				d = s.parse(date);
			}else {
				s = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				d = s.parse(date);
			}
			return d.getTime();	
		} catch (ParseException e) {		
			e.printStackTrace();
		}	
		return 0;	
	}

	/**
	 * 把毫秒数转换成日期格式
	 * @param now 当前时间的毫秒数
	 * @return yyyy-MM-dd HH:mm:ss
	 */
	public String LongToDate(long now){
		calendar.setTimeInMillis(now);
		return sdf.format(calendar.getTime());
	}
	/**
	 * 获取指定年份某个月份的天数
	 * @param year
	 * @param month
	 * @return 月份的天数
	 */
	public int getDaysByYearMonth(String year, String month){  
		if(month.length()==2&&month.startsWith("0"))
			month=month.substring(1,2);
		calendar.set(Calendar.YEAR,Integer.parseInt(year));  
		calendar.set(Calendar.MONTH,Integer.parseInt(month)-1);  
		calendar.set(Calendar.DATE,1);  
		calendar.roll(Calendar.DATE,-1);  

		return calendar.get(Calendar.DATE);  
	}  
	/**
	 * 获取指定年份的天数
	 * @param year
	 * @return 年份的天数 平年365 闰年366
	 */
	public int getDaysByYear(String year){  
		return new GregorianCalendar().isLeapYear(Integer.parseInt(year)) ? 366 : 365;
	}  

}	

