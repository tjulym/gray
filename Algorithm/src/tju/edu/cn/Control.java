package tju.edu.cn;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

/**
 * Co-locating scheduler strategy
 * 
 * @author DELL
 *
 *         File format requirements: Row double data are separated by ","
 */
public class Control {
	public static void main(String[] args) {
		int i, j;

		long startTime = System.nanoTime(); // beginTime
		File fileServer = new File("CPUResourceUsageofServer.txt");
		String stringServer = readText(fileServer);
		// System.out.println(stringServer);

		File fileAPP = new File("CPUResourceUsageofAPP.txt");
		String stringAPP = readText(fileAPP);
		// System.out.println(stringAPP);

		String[] orderServer = bubbleSort(stringServer.split(","));
		String[] orderAPP = bubbleSort(stringAPP.split(","));
		for (i = orderAPP.length - 1; i >= 0; i--) {
			updateBubbleSort(orderServer, Double.parseDouble(orderAPP[i]));
		}
		for (j = 0; j < orderServer.length; j++) {
			System.out.print(orderServer[j] + " ");
		}

		long endTime = System.nanoTime(); // endTime
		System.out.println("\nRunning Time:" + (endTime - startTime) / 1000000.0 + "ms");
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
	 */
	public static void updateBubbleSort(String[] string, double d) {
		int i;
		String temp;
		double updateValue = Double.parseDouble(string[0]) + d;
		for (i = 0; i < string.length - 1; i++) {
			if (updateValue > Double.parseDouble(string[i + 1])) {
				temp = String.valueOf(updateValue);
				string[i] = string[i + 1];
				string[i + 1] = temp;
			} else {
				string[i] = String.valueOf(updateValue);
				break;
			}
		}
	}

}
