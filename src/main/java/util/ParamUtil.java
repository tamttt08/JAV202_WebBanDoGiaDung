package util;

import jakarta.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ParamUtil {

    // 1. Đọc String (Trả về defaultValue nếu null)
    public static String getString(HttpServletRequest request, String name, String defaultValue) {
        String value = request.getParameter(name);
        return (value != null && !value.trim().isEmpty()) ? value.trim() : defaultValue;
    }

    public static String getString(HttpServletRequest request, String name) {
        return getString(request, name, "");
    }

    // 2. Đọc Integer (Trả về defaultValue nếu lỗi hoặc null)
    public static int getInt(HttpServletRequest request, String name, int defaultValue) {
        try {
            return Integer.parseInt(request.getParameter(name));
        } catch (Exception e) {
            return defaultValue;
        }
    }

    public static int getInt(HttpServletRequest request, String name) {
        return getInt(request, name, 0);
    }

    // 3. Đọc Double (Dùng cho Giá tiền/Số thực)
    public static double getDouble(HttpServletRequest request, String name, double defaultValue) {
        try {
            return Double.parseDouble(request.getParameter(name));
        } catch (Exception e) {
            return defaultValue;
        }
    }

    public static double getDouble(HttpServletRequest request, String name) {
        return getDouble(request, name, 0.0);
    }

    // 4. Đọc BigDecimal (Khớp chính xác với kiểu Price/TotalAmount trong Entity Product & Order)
    public static BigDecimal getBigDecimal(HttpServletRequest request, String name, BigDecimal defaultValue) {
        try {
            String value = request.getParameter(name);
            return (value != null && !value.trim().isEmpty()) ? new BigDecimal(value) : defaultValue;
        } catch (Exception e) {
            return defaultValue;
        }
    }

    public static BigDecimal getBigDecimal(HttpServletRequest request, String name) {
        return getBigDecimal(request, name, BigDecimal.ZERO);
    }

    // 5. Đọc Boolean (Dùng cho Checkbox/Radio button)
    public static boolean getBoolean(HttpServletRequest request, String name, boolean defaultValue) {
        String value = request.getParameter(name);
        if (value == null) return defaultValue;
        return value.equalsIgnoreCase("true") || value.equalsIgnoreCase("on") || value.equals("1");
    }

    public static boolean getBoolean(HttpServletRequest request, String name) {
        return getBoolean(request, name, false);
    }

    // 6. Đọc Date theo Pattern (Ví dụ: "yyyy-MM-dd")
    public static Date getDate(HttpServletRequest request, String name, String pattern, Date defaultValue) {
        try {
            String value = request.getParameter(name);
            if (value != null && !value.trim().isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat(pattern);
                return sdf.parse(value);
            }
        } catch (Exception e) {
            // Log lỗi nếu cần
        }
        return defaultValue;
    }

    public static Date getDate(HttpServletRequest request, String name, String pattern) {
        return getDate(request, name, pattern, null);
    }
}