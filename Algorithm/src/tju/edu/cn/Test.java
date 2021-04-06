package tju.edu.cn;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.HashMap;
import java.util.IdentityHashMap;
import java.util.Map;

public class Test {
	public static void main(String[] args) {
		File fileTest = new File("Test.txt");
		String stringTest = readText(fileTest);
		String[] strings = stringTest.split(",");
		System.out.println(stringTest);

		Map<String, String> map = new HashMap<String, String>();
		for (int i = 0; i < strings.length; i++) {
			map.put(strings[i], strings[i]);
		}
		for (int i = 0; i < strings.length; i++) {
			System.out.print(map.get(strings[i]) + " ");
		}
		
		System.out.println("");
		Map<String, String> identity = new IdentityHashMap<>();
		identity.put("0.5", "0");
		identity.put("0.5", "1");
		for (String key : identity.keySet()) {
			System.out.println(identity.get(key));
		}
	}

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
}
