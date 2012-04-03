package org.vufind;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.channels.FileChannel;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import org.apache.log4j.Logger;
import org.marc4j.marc.Record;
import org.solrmarc.tools.Utils;

public class Util {
	public static String convertStreamToString(InputStream is) throws IOException {
		/*
		 * To convert the InputStream to String we use the Reader.read(char[]
		 * buffer) method. We iterate until the Reader return -1 which means there's
		 * no more data to read. We use the StringWriter class to produce the
		 * string.
		 */
		if (is != null) {
			Writer writer = new StringWriter();

			char[] buffer = new char[1024];
			try {
				Reader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
				int n;
				while ((n = reader.read(buffer)) != -1) {
					writer.write(buffer, 0, n);
				}
			} finally {
				is.close();
			}
			return writer.toString();
		} else {
			return "";
		}
	}

	public static boolean doSolrUpdate(String baseIndexUrl, String body) {
		try {
			HttpURLConnection conn = null;
			OutputStreamWriter wr = null;
			URL url = new URL(baseIndexUrl + "/update/");
			conn = (HttpURLConnection) url.openConnection();
			conn.setDoOutput(true);
			conn.addRequestProperty("Content-Type", "text/xml");
			wr = new OutputStreamWriter(conn.getOutputStream());
			wr.write(body);
			wr.flush();

			// Get the response
			InputStream _is;
			boolean doOuptut = false;
			if (conn.getResponseCode() == 200) {
				_is = conn.getInputStream();
			} else {
				System.out.println("Error in update");
				System.out.println("  " + body);
				/* error from server */
				_is = conn.getErrorStream();
				doOuptut = true;
			}
			BufferedReader rd = new BufferedReader(new InputStreamReader(_is));
			String line;
			while ((line = rd.readLine()) != null) {
				if (doOuptut) System.out.println(line);
			}
			wr.close();
			rd.close();
			conn.disconnect();

			return true;
		} catch (MalformedURLException e) {
			System.out.println("Invalid url optimizing genealogy index " + e.toString());
			return false;
		} catch (IOException e) {
			System.out.println("IO Exception optimizing genealogy index " + e.toString());
			e.printStackTrace();
			return false;
		}
	}

	public static String getCRSeparatedString(List<String> values) {
		StringBuffer crSeparatedString = new StringBuffer();
		for (String curValue : values) {
			if (crSeparatedString.length() > 0) {
				crSeparatedString.append("\r\n");
			}
			crSeparatedString.append(curValue);
		}
		return crSeparatedString.toString();
	}

	public static String getCRSeparatedString(HashSet<String> values) {
		StringBuffer crSeparatedString = new StringBuffer();
		for (String curValue : values) {
			if (crSeparatedString.length() > 0) {
				crSeparatedString.append("\r\n");
			}
			crSeparatedString.append(curValue);
		}
		return crSeparatedString.toString();
	}

	public static void copyFile(File sourceFile, File destFile) throws IOException {
		if (!destFile.exists()) {
			destFile.createNewFile();
		}

		FileChannel source = null;
		FileChannel destination = null;

		try {
			source = new FileInputStream(sourceFile).getChannel();
			destination = new FileOutputStream(destFile).getChannel();
			destination.transferFrom(source, 0, source.size());
		} finally {
			if (source != null) {
				source.close();
			}
			if (destination != null) {
				destination.close();
			}
		}
	}

	public static String encodeString(String originalString) {
		// System.out.println(originalString);
		return originalString;
		/*
		 * Charset charset = Charset.forName("US-ASCII"); CharsetEncoder encoder =
		 * charset.newEncoder(); ByteBuffer bb = null;
		 * 
		 * encoder.onUnmappableCharacter(CodingErrorAction.IGNORE); try { CharBuffer
		 * cb = CharBuffer.wrap(originalString); bb = encoder.encode(cb); } catch
		 * (CharacterCodingException e) { e.printStackTrace(); }
		 * 
		 * CharBuffer cbb = bb.asCharBuffer(); return cbb.toString();
		 */
	}

	public static String cleanIniValue(String value) {
		if (value == null) {
			return null;
		}
		value = value.trim();
		if (value.startsWith("\"")) {
			value = value.substring(1);
		}
		if (value.endsWith("\"")) {
			value = value.substring(0, value.length() - 1);
		}
		return value;
	}

	public static String trimTo(int maxCharacters, String stringToTrim) {
		if (stringToTrim == null) {
			return null;
		}
		if (stringToTrim.length() > maxCharacters) {
			stringToTrim = stringToTrim.substring(0, maxCharacters);
		}
		return stringToTrim;
	}

	public static HashMap<String, String> readPropertiesFile(File formatMapFile) throws IOException {
		HashMap<String, String> formatMap = new HashMap<String, String>();
		BufferedReader reader = new BufferedReader(new FileReader(formatMapFile));
		String inputLine = reader.readLine();
		while (inputLine != null) {
			inputLine = inputLine.trim();
			if (inputLine.length() == 0 || inputLine.startsWith("#")) {
				inputLine = reader.readLine();
				continue;
			}
			String[] property = inputLine.split("\\s*=\\s*");
			if (property.length == 2) {
				formatMap.put(property[0], property[1]);
			} else {
				System.out.println("Could not find a property in line " + property);
			}
			inputLine = reader.readLine();
		}
		return formatMap;
	}

	public static String postToURL(String url, String postData, Logger logger) {
		try {
			URL emptyIndexURL = new URL(url);
			HttpURLConnection conn = (HttpURLConnection) emptyIndexURL.openConnection();
			conn.setDoInput(true);
			if (postData != null && postData.length() > 0) {
				conn.setRequestMethod("POST");
				conn.setRequestProperty("Content-Type", "text/xml");

				conn.setRequestProperty("Content-Language", "en-US");

				conn.setDoOutput(true);
				OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
				wr.write(postData);
				wr.flush();
				wr.close();
			}

			StringBuffer response = new StringBuffer();
			if (conn.getResponseCode() == 200) {
				// Get the response
				BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				String line;
				while ((line = rd.readLine()) != null) {
					response.append(line);
				}

				rd.close();
			} else {
				logger.error("Received error " + conn.getResponseCode() + " posting to " + url);
				logger.info(postData);
				// Get any errors
				BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
				String line;
				while ((line = rd.readLine()) != null) {
					response.append(line);
				}

				rd.close();
			}

			return response.toString();
		} catch (MalformedURLException e) {
			logger.error("URL to post (" + url + ") is malformed", e);
			return "";
		} catch (IOException e) {
			logger.error("Error posting to url \r\n" + url, e);
			System.exit(1);
			return "";
		}
	}

	public static boolean deleteDirectory(File dirToDelete) {
		File[] files = dirToDelete.listFiles();
		if (files != null) {
			for (File curFile : files) {
				if (curFile.isDirectory()) {
					deleteDirectory(curFile);
				} else {
					curFile.delete();
				}
			}
		}
		return dirToDelete.delete();
	}

	public static boolean copyDir(File source, File dest) {
		if (!dest.exists()) {
			dest.mkdir();
		}
		if (source.exists() == false) {
			return false;
		}
		File[] sourceFiles = source.listFiles();
		for (File curFile : sourceFiles) {
			File destFile = new File(dest.getAbsolutePath() + "/" + curFile.getName());
			if (curFile.isDirectory()) {
				copyDir(curFile, destFile);
			} else {
				try {
					Util.copyFile(curFile, destFile);
				} catch (IOException e) {
					return false;
				}
			}
		}
		return true;
	}

	/**
	 * Returns the string where all non-ascii and <, &, > are encoded as numeric
	 * entities. I.e. "&lt;A &amp; B &gt;" .... (insert result here). The result
	 * is safe to include anywhere in a text field in an XML-string. If there was
	 * no characters to protect, the original string is returned.
	 * 
	 * @param originalUnprotectedString
	 *          original string which may contain characters either reserved in
	 *          XML or with different representation in different encodings (like
	 *          8859-1 and UFT-8)
	 * @return
	 */
	public static String encodeSpecialCharacters(String originalUnprotectedString) {
		if (originalUnprotectedString == null) {
			return null;
		}
		boolean anyCharactersProtected = false;

		StringBuffer stringBuffer = new StringBuffer();
		for (int i = 0; i < originalUnprotectedString.length(); i++) {
			char ch = originalUnprotectedString.charAt(i);

			boolean controlCharacter = ch < 32;
			boolean unicodeButNotAscii = ch > 126;
			boolean characterWithSpecialMeaningInXML = ch == '<' || ch == '&' || ch == '>';

			if (characterWithSpecialMeaningInXML || unicodeButNotAscii || controlCharacter) {
				stringBuffer.append("#" + (int) ch + ";");
				anyCharactersProtected = true;
			} else {
				stringBuffer.append(ch);
			}
		}
		if (anyCharactersProtected == false) {
			return originalUnprotectedString;
		}

		return stringBuffer.toString();
	}

}
