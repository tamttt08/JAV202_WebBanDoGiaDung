package util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailUtil {

    // Cấu hình thông tin email gửi đi
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SENDER_EMAIL = "tamtttts02309@gmail.com";
    private static final String SENDER_PASSWORD = "ttmg qlqs ninj pyex"; // Mật khẩu ứng dụng 16 ký tự

    // 1. Hàm dùng để gửi mã OTP (Định dạng HTML đẹp)
    public static boolean sendOtpEmail(String recipientEmail, String otpCode) {
        String htmlContent = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; border-radius: 8px;'>"
                + "<h2 style='color: #0d6efd;'>Yêu cầu đặt lại mật khẩu</h2>"
                + "<p>Mã xác minh OTP của cậu là:</p>"
                + "<h1 style='color: #dc3545; letter-spacing: 4px;'>" + otpCode + "</h1>"
                + "<p>Mã này có hiệu lực trong <b>5 phút</b>. Vui lòng không chia sẻ mã này cho ai.</p>"
                + "</div>";

        return sendEmail(recipientEmail, "Mã xác minh đặt lại mật khẩu", htmlContent, true);
    }

    // 2. Hàm dùng để gửi thông báo chung (Mật khẩu mới, thông tin đơn hàng...)
    // Tham số isHtml: true nếu muốn gửi nội dung HTML, false nếu chỉ gửi văn bản thuần
    public static boolean sendEmail(String toEmail, String subject, String content, boolean isHtml) {
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL, "Gia Dụng Shop"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject(subject);

            if (isHtml) {
                message.setContent(content, "text/html; charset=UTF-8");
            } else {
                message.setText(content);
            }

            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}