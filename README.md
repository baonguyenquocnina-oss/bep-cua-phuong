# Bếp Của Phương – MVP đặt món

## Chạy thử trên máy tính
1. Cài Node.js bản LTS.
2. Giải nén thư mục dự án.
3. Mở terminal tại thư mục dự án và chạy:
   ```bash
   npm install
   npm run dev
   ```
4. Mở địa chỉ local mà Vite hiển thị.

## Những gì đã có trong MVP
- Website đặt món responsive, ưu tiên điện thoại.
- Thực đơn bánh tráng trộn mẫu, tìm kiếm và món nổi bật.
- Giỏ hàng, tăng/giảm số lượng, ghi chú.
- Form đặt hàng, nhập địa chỉ và lấy tọa độ trình duyệt.
- Chọn giao sớm nhất hoặc đặt ngày/giờ giao.
- Admin: xem đơn, đổi trạng thái, CRUD món.
- Dashboard doanh thu theo các đơn đã hoàn thành.
- Logo SVG và bộ màu thương hiệu khởi tạo.

## Tài khoản demo
- Nhấn “Quản trị” ở đầu trang.
- PIN demo: `246810`.

**Cảnh báo:** Đây chỉ là mã PIN demo phía trình duyệt, không an toàn để vận hành công khai. Không triển khai bản demo này như hệ thống nhận đơn thật khi chưa cấu hình xác thực và database server-side.

## Chế độ dữ liệu
Mặc định dự án chạy DEMO: dữ liệu lưu trong localStorage của trình duyệt hiện tại. Dữ liệu không đồng bộ giữa các thiết bị và có thể mất khi xóa dữ liệu trình duyệt.

Để dùng thực tế:
1. Tạo project Supabase.
2. Chạy `supabase/schema.sql` trong SQL Editor.
3. Tạo tài khoản quản trị bằng Supabase Auth và cấu hình RLS.
4. Điền `VITE_SUPABASE_URL` và `VITE_SUPABASE_ANON_KEY` vào file `.env`.
5. Hoàn thiện tích hợp Auth/CRUD và kiểm thử chính sách RLS trước khi nhận đơn thật.

MVP này đã có nhánh ghi đơn lên bảng `orders` nếu cấu hình Supabase; các phần đồng bộ realtime, đăng nhập Supabase và CRUD sản phẩm qua database là bước tích hợp tiếp theo, chưa bật sẵn.

## Triển khai Cloudflare Pages
- Build command: `npm run build`
- Output directory: `dist`
- Framework preset: Vite
- Thêm biến môi trường trong Cloudflare Pages nếu kết nối Supabase.
- Tên miền thử nghiệm sẽ có dạng `ten-du-an.pages.dev`.

## Thông tin cần xác nhận trước khi public
- Địa chỉ đang được chuẩn hóa tạm thời thành “17 Nguyễn Du, xã Chư Prông, tỉnh Gia Lai”. Vui lòng kiểm tra lại tên xã/địa chỉ hành chính hiện hành.
- Bổ sung số điện thoại quán.
- Thay hình món mẫu bằng ảnh món thật và cập nhật giá.
- Xác nhận giờ nhận đơn, giờ giao và chính sách phí giao hàng.
- Tạo PIN/đăng nhập quản trị an toàn; không dùng PIN demo.
- Cấu hình backup và chính sách quyền truy cập database.
