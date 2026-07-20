-- Tạo cơ sở dữ liệu cho hệ thống bán đồ gia dụng
CREATE DATABASE IF NOT EXISTS QuanLyDoGiaDung;
USE QuanLyDoGiaDung;

-- 1. Bảng Tài khoản (Lưu thông tin đăng nhập dùng chung cho tất cả các đối tượng)
CREATE TABLE Accounts (
    AccountID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Role ENUM('Customer', 'Staff', 'Manager') NOT NULL DEFAULT 'Customer',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bảng Khách hàng (Lưu riêng thông tin chi tiết của Khách hàng, liên kết với Account)
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    AccountID INT UNIQUE, -- Liên kết 1-1 với bảng Accounts
    FullName NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    Address TEXT,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) ON DELETE CASCADE
);

-- 3. Bảng Nhân viên (Lưu riêng thông tin chi tiết của Nhân viên và Quản lý, liên kết với Account)
CREATE TABLE Staffs (
    StaffID INT AUTO_INCREMENT PRIMARY KEY,
    AccountID INT UNIQUE, -- Liên kết 1-1 với bảng Accounts
    FullName NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    Position NVARCHAR(50), -- Chức vụ (Ví dụ: Nhân viên bán hàng, Quản lý kho, Quản lý cửa hàng...)
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) ON DELETE CASCADE
);

-- 4. Bảng Quản lý loại sản phẩm (Danh mục đồ gia dụng)
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description TEXT
);

-- 5. Bảng Quản lý sản phẩm (Đồ gia dụng)
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName NVARCHAR(150) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL DEFAULT 0,
    CategoryID INT,
    Description TEXT,
    Image VARCHAR(255),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) ON DELETE SET NULL
);

-- 6. Bảng Giỏ hàng (Hỗ trợ chức năng Quản lý giỏ hàng của Khách hàng)
CREATE TABLE Carts (
    CartID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);

-- 7. Bảng Hóa đơn / Phiếu bán hàng (Lưu thông tin ai là người mua hoặc nhân viên nào tạo phiếu)
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT, -- Khách hàng mua hàng (nếu khách tự đặt online)
    StaffID INT,    -- Nhân viên lập phiếu (nếu bán tại quầy / nhân viên tạo phiếu giúp)
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    Status ENUM('Pending', 'Paid', 'Cancelled') NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE SET NULL,
    FOREIGN KEY (StaffID) REFERENCES Staffs(StaffID) ON DELETE SET NULL
);

-- 8. Bảng Chi tiết hóa đơn (Sản phẩm và số lượng trong phiếu bán hàng)
CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);

-- 9. Bảng Đánh giá / Phản hồi (Khách hàng đánh giá sản phẩm gia dụng)
CREATE TABLE Feedbacks (
    FeedbackID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);