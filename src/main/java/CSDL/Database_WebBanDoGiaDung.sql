DROP DATABASE IF EXISTS JAV202_WebBanDoGiaDung; -- Tên DB của cậu
CREATE DATABASE JAV202_WebBanDoGiaDung CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE JAV202_WebBanDoGiaDung;

-- ========================================================
-- 1. TÀI KHOẢN & PHÂN QUYỀN
-- ========================================================
CREATE TABLE Accounts (
                          AccountID INT AUTO_INCREMENT PRIMARY KEY,
                          Username VARCHAR(50) NOT NULL UNIQUE,
                          Password VARCHAR(255) NOT NULL,
                          Role ENUM('Customer', 'Staff', 'Manager') NOT NULL DEFAULT 'Customer',
                          Active BOOLEAN DEFAULT TRUE,
                          CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Customers (
                           CustomerID INT AUTO_INCREMENT PRIMARY KEY,
                           AccountID INT UNIQUE,
                           FullName NVARCHAR(100) NOT NULL,
                           Email VARCHAR(100) UNIQUE,
                           Phone VARCHAR(15),
                           FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) ON DELETE CASCADE
);

-- Sổ địa chỉ nhận hàng (Khách hàng có thể lưu nhiều địa chỉ)
CREATE TABLE CustomerAddresses (
                                   AddressID INT AUTO_INCREMENT PRIMARY KEY,
                                   CustomerID INT NOT NULL,
                                   ReceiverName NVARCHAR(100) NOT NULL,
                                   ReceiverPhone VARCHAR(15) NOT NULL,
                                   DetailAddress NVARCHAR(255) NOT NULL, -- Số nhà, tên đường
                                   Wards NVARCHAR(100),                  -- Phường / Xã
                                   District NVARCHAR(100),               -- Quận / Huyện
                                   Province NVARCHAR(100),               -- Tỉnh / Thành phố
                                   IsDefault BOOLEAN DEFAULT FALSE,
                                   FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

CREATE TABLE Staffs (
                        StaffID INT AUTO_INCREMENT PRIMARY KEY,
                        AccountID INT UNIQUE,
                        FullName NVARCHAR(100) NOT NULL,
                        Email VARCHAR(100) UNIQUE,
                        Phone VARCHAR(15),
                        Position NVARCHAR(50),
                        FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) ON DELETE CASCADE
);

-- ========================================================
-- 2. DANH MỤC, SẢN PHẨM & MÃ GIẢM GIÁ
-- ========================================================
CREATE TABLE Categories (
                            CategoryID INT AUTO_INCREMENT PRIMARY KEY,
                            CategoryCode VARCHAR(20) NOT NULL UNIQUE,
                            CategoryName NVARCHAR(100) NOT NULL,
                            Description TEXT
);

CREATE TABLE Products (
                          ProductID INT AUTO_INCREMENT PRIMARY KEY,
                          ProductCode VARCHAR(20) NOT NULL UNIQUE,
                          ProductName NVARCHAR(150) NOT NULL,
                          Price DECIMAL(12, 2) NOT NULL,
                          StockQuantity INT NOT NULL DEFAULT 0, -- Quản lý / sửa thẳng số lượng ở đây
                          CategoryID INT,
                          Description TEXT,
                          MainImage VARCHAR(255),               -- Ảnh đại diện chính
                          Active BOOLEAN DEFAULT TRUE,
                          CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) ON DELETE SET NULL
);

-- Album ảnh chi tiết của sản phẩm (Nhiều ảnh cho 1 sản phẩm)
CREATE TABLE ProductImages (
                               ImageID INT AUTO_INCREMENT PRIMARY KEY,
                               ProductID INT NOT NULL,
                               ImageURL VARCHAR(255) NOT NULL,
                               FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);

-- Bảng Mã giảm giá / Voucher
CREATE TABLE Coupons (
                         CouponID INT AUTO_INCREMENT PRIMARY KEY,
                         Code VARCHAR(50) NOT NULL UNIQUE,
                         DiscountPercent INT DEFAULT 0,             -- Giảm theo % (0 - 100)
                         MaxDiscountAmount DECIMAL(12, 2) DEFAULT 0, -- Số tiền giảm tối đa
                         MinOrderAmount DECIMAL(12, 2) DEFAULT 0,    -- Đơn hàng tối thiểu để áp dụng
                         UsageLimit INT DEFAULT 100,                -- Giới hạn số lượt dùng
                         StartDate DATETIME,
                         EndDate DATETIME,
                         Active BOOLEAN DEFAULT TRUE
);

-- ========================================================
-- 3. GIỎ HÀNG, ĐƠN HÀNG & THANH TOÁN
-- ========================================================
CREATE TABLE Carts (
                       CartID INT AUTO_INCREMENT PRIMARY KEY,
                       CustomerID INT NOT NULL,
                       ProductID INT NOT NULL,
                       Quantity INT NOT NULL DEFAULT 1,
                       FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
                       FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);

CREATE TABLE Orders (
                        OrderID INT AUTO_INCREMENT PRIMARY KEY,
                        OrderCode VARCHAR(30) UNIQUE,              -- Mã đơn hàng (VD: DH20260803-001)
                        CustomerID INT,
                        StaffID INT,
                        CouponID INT,                             -- Mã giảm giá áp dụng (nếu có)

                        ReceiverName NVARCHAR(100) NOT NULL,
                        ReceiverPhone VARCHAR(15) NOT NULL,
                        ShippingAddress NVARCHAR(255) NOT NULL,
                        Note NVARCHAR(255),

                        OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
                        SubTotal DECIMAL(12, 2) NOT NULL,         -- Tiền hàng chưa giảm
                        DiscountAmount DECIMAL(12, 2) DEFAULT 0,    -- Số tiền được giảm
                        TotalAmount DECIMAL(12, 2) NOT NULL,      -- Tổng tiền cuối cùng thanh toán

                        Status ENUM('Pending', 'Paid', 'Shipping', 'Delivered', 'Cancelled') NOT NULL DEFAULT 'Pending',

                        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE SET NULL,
                        FOREIGN KEY (StaffID) REFERENCES Staffs(StaffID) ON DELETE SET NULL,
                        FOREIGN KEY (CouponID) REFERENCES Coupons(CouponID) ON DELETE SET NULL
);

CREATE TABLE OrderDetails (
                              OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
                              OrderID INT NOT NULL,
                              ProductID INT NOT NULL,
                              Quantity INT NOT NULL,
                              UnitPrice DECIMAL(12, 2) NOT NULL,
                              FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
                              FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);

-- Lịch sử giao dịch thanh toán (COD / VNPay / MoMo)
CREATE TABLE Payments (
                          PaymentID INT AUTO_INCREMENT PRIMARY KEY,
                          OrderID INT UNIQUE NOT NULL,
                          PaymentMethod ENUM('COD', 'VNPAY', 'MOMO', 'BANK_TRANSFER') NOT NULL DEFAULT 'COD',
                          PaymentStatus ENUM('Pending', 'Success', 'Failed') NOT NULL DEFAULT 'Pending',
                          TransactionNo VARCHAR(100),               -- Mã phản hồi từ cổng thanh toán
                          PaymentDate DATETIME,
                          Amount DECIMAL(12, 2) NOT NULL,
                          FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);

-- ========================================================
-- 4. ĐÁNH GIÁ & PHẢN HỒI
-- ========================================================
CREATE TABLE Feedbacks (
                           FeedbackID INT AUTO_INCREMENT PRIMARY KEY,
                           CustomerID INT NOT NULL,
                           ProductID INT NOT NULL,
                           Rating INT CHECK (Rating BETWEEN 1 AND 5),
                           Comment TEXT,
                           CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
                           FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);

select * from Orders;
select * from OrderDetails;
select * from Customers;
select * from Accounts;