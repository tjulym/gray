package tju.edu.cn;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.HashMap;
import java.util.Map;

/**
 * Co-locating scheduler strategy
 * 
 * @author DELL
 *
 *         File format requirements: (1)Row double data are separated by ","
 *         (2)Add an infinite number at the end for CPUResourceUsageofServer.txt
 *         (3)Suitable for different key values
 */
public class Control2 {
	public static void main(String[] args) {
		int i, j, k;

		long startTime = System.nanoTime(); // beginTime
		File fileServer = new File("CPUResourceUsageofServer.txt");
		String stringServer = readText(fileServer);
		// System.out.println(stringServer);

		File fileAPP = new File("CPUResourceUsageofAPP.txt");
		String stringAPP = readText(fileAPP);
		// System.out.println(stringAPP);

		Map<String, String> map = new HashMap<String, String>();
		String[] orderServer = bubbleSort(stringServer.split(","));
		String[] orderAPP = bubbleSort(stringAPP.split(","));
		initKeyValue(orderServer, map);

		for (i = orderAPP.length - 1; i >= 0; i--) {
			updateBubbleSort(orderServer, Double.parseDouble(orderAPP[i]), map);
		}
		
		// key
		for (j = 0; j < orderServer.length; j++) {
			if (j == orderServer.length - 1) {
				System.out.println(orderServer[j]);
			} else {
				System.out.print(orderServer[j] + ",");
			}
		}

		// value
		for (k = 0; k < orderServer.length; k++) {
			if (k == orderServer.length - 1) {
				System.out.println(map.get(orderServer[k]));
			} else {
				System.out.print(map.get(orderServer[k]) + ",");
			}
		}

		long endTime = System.nanoTime(); // endTime
		System.out.println("Running Time:" + (endTime - startTime) / 1000000.0 + "ms");
	}

	/**
	 * initKeyValue
	 * 
	 * @param string
	 * @param map
	 */
	public static void initKeyValue(String[] string, Map<String, String> map) {
		for (int i = 0; i < string.length; i++) {
			// map.put(string[i], string[i]);
			map.put(string[i], "0");
		}
	}

	/**
	 * readText
	 * 
	 * @param file
	 * @return
	 */
	public static String readText(File file) {
		StringBuilder result = new StringBuilder();
		BufferedReader br;
		try {
			br = new BufferedReader(new FileReader(file));
			String string = null;
			while ((string = br.readLine()) != null) {
				result.append(string + ",");
			}
			br.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result.toString().substring(0, result.toString().length() - 1);
	}

	/**
	 * bubbleSort
	 * 
	 * @param string
	 * @return
	 */
	public static String[] bubbleSort(String[] string) {
		int i, j;
		String temp;
		// BubbleSort:From small to large
		for (i = 0; i < string.length - 1; i++) {
			for (j = 0; j < string.length - 1; j++) {
				if (Double.parseDouble(string[j]) > Double.parseDouble(string[j + 1])) {
					temp = string[j];
					string[j] = string[j + 1];
					string[j + 1] = temp;
				}
			}
		}
		return string;
	}

	/**
	 * updateBubbleSort
	 * 
	 * @param string
	 * @param d
	 * @param map
	 */
	public static void updateBubbleSort(String[] string, double d, Map<String, String> map) {
		int i;
		String temp, tempValue1, tempValue2, value;
		double updateValue = Double.parseDouble(string[0]) + d;
		value = map.get(string[0]);
		string[0] = String.valueOf(updateValue);
		map.put(string[0], value + "+" + d);
		for (i = 0; i < string.length - 1; i++) {
			if (updateValue > Double.parseDouble(string[i + 1])) {
				tempValue1 = map.get(string[i]);
				tempValue2 = map.get(string[i + 1]);

				temp = String.valueOf(updateValue);
				string[i] = string[i + 1];
				string[i + 1] = temp;

				map.put(string[i], tempValue2);
				map.put(string[i + 1], tempValue1);

				if (Double.parseDouble(string[i + 1]) < Double.parseDouble(string[i + 2])) {
					break;
				}
			} else {
				break;
			}
		}
	}

}
