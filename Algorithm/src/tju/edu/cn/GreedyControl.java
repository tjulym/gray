package tju.edu.cn;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.HashMap;
import java.util.Map;

/**
 * Greedy scheduler strategy
 * 
 * @author DELL
 *
 *         File format requirements: (1)Row double data are separated by ","
 *         (2)Add an infinite number at the end for CPUResourceUsageofServer.txt
 *         (3)Suitable for different key values
 */
public class GreedyControl {
	public static void main(String[] args) {
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

		float targetSLA = 0;
		boolean SLA_violation = false;
		for (int i = orderAPP.length - 1; i >= 0; i--) {
			SLA_violation = compareSLA(orderServer, orderAPP[i], targetSLA);
			if (!SLA_violation) {
				updateBubbleSort(orderServer, Double.parseDouble(orderAPP[i]), map);
			} else {
				continue;
			}
		}
		getSchedulerResult(orderServer, map);

		long endTime = System.nanoTime(); // endTime
		System.out.println("Running Time:" + (endTime - startTime) / 1000000.0 + "ms");
	}

	/**
	 * compareSLA
	 * 
	 * @param orderServer
	 * @param stringAPP
	 * @param targetSLA
	 * @return
	 */
	public static boolean compareSLA(String[] orderServer, String stringAPP, float targetSLA) {
		// It can infer by predictor
		return true;
	}

	/**
	 * getSchedulerResult
	 * 
	 * @param orderServer
	 * @param map
	 */
	public static void getSchedulerResult(String[] orderServer, Map<String, String> map) {
		// key
		for (int i = 0; i < orderServer.length; i++) {
			if (i == orderServer.length - 1) {
				System.out.println(orderServer[i]);
			} else {
				System.out.print(orderServer[i] + ",");
			}
		}

		// value
		for (int j = 0; j < orderServer.length; j++) {
			if (j == orderServer.length - 1) {
				System.out.println(map.get(orderServer[j]));
			} else {
				System.out.print(map.get(orderServer[j]) + ",");
			}
		}
	}

	/**
	 * initKeyValue
	 * 
	 * @param orderServer
	 * @param map
	 */
	public static void initKeyValue(String[] orderServer, Map<String, String> map) {
		for (int i = 0; i < orderServer.length; i++) {
			map.put(orderServer[i], orderServer[i]);
			// map.put(orderServer[i], "0");
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
	 * @param orderServer
	 * @param d
	 * @param map
	 */
	public static void updateBubbleSort(String[] orderServer, double d, Map<String, String> map) {
		int i;
		String temp, tempValue1, tempValue2, value;
		double updateValue = Double.parseDouble(orderServer[0]) + d;
		value = map.get(orderServer[0]);
		orderServer[0] = String.valueOf(updateValue);
		map.put(orderServer[0], value + "+" + d);
		for (i = 0; i < orderServer.length - 1; i++) {
			if (updateValue > Double.parseDouble(orderServer[i + 1])) {
				tempValue1 = map.get(orderServer[i]);
				tempValue2 = map.get(orderServer[i + 1]);

				temp = String.valueOf(updateValue);
				orderServer[i] = orderServer[i + 1];
				orderServer[i + 1] = temp;

				map.put(orderServer[i], tempValue2);
				map.put(orderServer[i + 1], tempValue1);

				if (Double.parseDouble(orderServer[i + 1]) < Double.parseDouble(orderServer[i + 2])) {
					break;
				}
			} else {
				break;
			}
		}
	}

}
