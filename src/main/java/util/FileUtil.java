package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class FileUtil {

    // Thư mục lưu trữ file upload trên Server
    private static final String UPLOAD_DIR = "/uploads";

    /**
     * Upload file từ form (dùng cho upload ảnh sản phẩm, avatar...)
     *
     * @param request HttpServletRequest
     * @param paramName Tên input file trong form (ví dụ: "image")
     * @return Tên file độc nhất đã lưu, hoặc null nếu upload thất bại/không chọn file
     */
    public static String upload(HttpServletRequest request, String paramName) {
        try {
            Part part = request.getPart(paramName);

            // Kiểm tra xem user có chọn file không
            if (part == null || part.getSize() == 0) {
                return null;
            }

            String fileName = part.getSubmittedFileName();
            if (fileName == null || fileName.trim().isEmpty()) {
                return null;
            }

            // Lấy đuôi file (ví dụ: .jpg, .png)
            String ext = "";
            int dotIndex = fileName.lastIndexOf(".");
            if (dotIndex >= 0) {
                ext = fileName.substring(dotIndex);
            }

            // Tạo tên file độc nhất tránh trùng lặp
            String uniqueName = System.currentTimeMillis() + ext;

            // Đường dẫn tuyệt đối đến thư mục uploads trên Tomcat Server
            String realFolder = request.getServletContext().getRealPath(UPLOAD_DIR);

            if (realFolder == null) {
                return null;
            }

            // Đảm bảo thư mục /uploads tồn tại trước khi ghi file
            File uploadDir = new File(realFolder);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Ghi file vào ổ đĩa
            String fullPath = realFolder + File.separator + uniqueName;
            part.write(fullPath);

            // Trả về tên file để lưu vào Database
            return uniqueName;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Xóa file khỏi thư mục /uploads (Dùng khi sửa/xóa sản phẩm)
     *
     * @param request HttpServletRequest
     * @param fileName Tên file cần xóa
     * @return true nếu xóa thành công
     */
    public static boolean delete(HttpServletRequest request, String fileName) {
        try {
            if (fileName == null || fileName.trim().isEmpty()) {
                return false;
            }

            String realFolder = request.getServletContext().getRealPath(UPLOAD_DIR);
            if (realFolder == null) {
                return false;
            }

            File file = new File(realFolder, fileName);
            if (file.exists() && file.isFile()) {
                return file.delete();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}