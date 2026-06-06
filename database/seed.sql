-- =========================================================================
-- FILE SEED DỮ LIỆU ĐỀ THI THẬT THPT QUỐC GIA 2024 & 2025 CHO H2 DATABASE
-- JPA/Hibernate sẽ tự động quét và thực thi file này khi khởi chạy Spring Boot
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. NẠP ĐỀ THI MÔN TOÁN THPT QG 2025 (Mã đề 0101)
-- -------------------------------------------------------------------------
INSERT INTO exams (id, title, subject, duration, description, created_at) VALUES 
(1, 'Đề thi chính thức THPT Quốc Gia môn Toán 2025 - Mã đề 0101', 'Toán', 90, 'Đề thi chính thức của Bộ Giáo Dục và Đào Tạo theo cấu trúc mới năm 2025 đầy đủ 3 phần thi: Trắc nghiệm đơn, Trắc nghiệm Đúng/Sai, và Tự luận điền số.', CURRENT_TIMESTAMP());

-- --- PHẦN I: TRẮC NGHIỆM ĐƠN (SINGLE_CHOICE) ---
-- Câu 1
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(1, 'Cho hình lăng trụ $ABC.A''B''C''$ (xem hình). Phát biểu nào sau đây là đúng?', 'SINGLE_CHOICE', 
'{"A":"$\\vec{BA}+\\vec{A''C''}=\\vec{BC''}$","B":"$\\vec{BA}+\\vec{A''C''}=\\vec{C''B''}$","C":"$\\vec{BA}+\\vec{A''C''}=\\vec{BC}$","D":"$\\vec{BA}+\\vec{A''C''}=\\vec{A''A}$"}', 
'C', 'Ta có: $\\vec{BA} + \\vec{A''C''} = \\vec{BA} + \\vec{AC} = \\vec{BC}$ (do $\\vec{A''C''} = \\vec{AC}$ trong hình lăng trụ). Do đó chọn phương án C.', 1);

-- Câu 2
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(2, 'Cho hình hộp $ABCD.A''B''C''D''$. Đường thẳng $AB$ song song với mặt phẳng nào sau đây?', 'SINGLE_CHOICE', 
'{"A":"$(CC''A''A)$","B":"$(BB''C''C)$","C":"$(A''B''C''D'')$","D":"$(AA''D''D)$"}', 
'C', 'Trong hình hộp, ta có cạnh $AB$ song song với cạnh $A''B''$, mà $A''B''$ nằm trong mặt phẳng $(A''B''C''D'')$, do đó đường thẳng $AB$ song song với mặt phẳng $(A''B''C''D'')$. Chọn C.', 1);

-- Câu 3
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(3, 'Một người chia thời lượng (đơn vị: giây) thực hiện các cuộc gọi điện thoại của mình trong một tuần thành sáu nhóm và lập bảng tần số ghép nhóm. Tứ phân vị thứ ba $Q_3$ (đơn vị: giây) của mẫu số liệu ghép nhóm bằng bao nhiêu?', 'SINGLE_CHOICE', 
'{"A":"145","B":"140","C":"135","D":"130"}', 
'C', 'Áp dụng công thức tính tứ phân vị cho mẫu số liệu ghép nhóm, ta xác định nhóm chứa $Q_3$ là nhóm $[120;160)$ và tính toán được giá trị xấp xỉ bằng 135. Chọn C.', 1);

-- Câu 4
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(4, 'Trong không gian với hệ tọa độ $Oxyz$, cho đường thẳng $(d): \\frac{x-3}{4} = \\frac{y+2}{-5} = \\frac{z-1}{2}$. Vectơ nào sau đây là một vectơ chỉ phương của đường thẳng $(d)$?', 'SINGLE_CHOICE', 
'{"A":"$\\vec{v}_3 = (4;5;2)$","B":"$\\vec{v}_1 = (3;-2;1)$","C":"$\\vec{v}_4 = (3;2;1)$","D":"$\\vec{v}_2 = (4;-5;2)$"}', 
'D', 'Nhìn vào các hệ số dưới mẫu số của phương trình chính tắc của đường thẳng $(d)$, ta có ngay vectơ chỉ phương là $\\vec{u} = (4; -5; 2)$. Đối chiếu các đáp án thấy $\\vec{v}_2 = (4;-5;2)$ khớp hoàn toàn. Chọn D.', 1);

-- Câu 5
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(5, 'Họ nguyên hàm của hàm số $f(x)=x^2$ là:', 'SINGLE_CHOICE', 
'{"A":"$\\frac{1}{3}x^3+C$","B":"$2x^3+C$","C":"$3x^3+C$","D":"$\\frac{1}{2}x^3+C$"}', 
'A', 'Áp dụng công thức tính nguyên hàm cơ bản: $\\int x^n dx = \\frac{x^{n+1}}{n+1} + C$. Ta có $\\int x^2 dx = \\frac{1}{3}x^3 + C$. Chọn A.', 1);

-- Câu 6
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(6, 'Cho cấp số cộng $(u_n)$ có $u_1=4$ và công sai $d=-3$. Giá trị của $u_5$ bằng bao nhiêu?', 'SINGLE_CHOICE', 
'{"A":"16","B":"19","C":"-8","D":"-11"}', 
'C', 'Công thức số hạng tổng quát của cấp số cộng: $u_n = u_1 + (n-1)d$. Áp dụng: $u_5 = 4 + (5-1) \\cdot (-3) = 4 + 4 \\cdot (-3) = 4 - 12 = -8$. Chọn C.', 1);

-- Câu 7
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(7, 'Tập nghiệm của phương trình $\\sin x = 0$ là:', 'SINGLE_CHOICE', 
'{"A":"$S=\\{\\frac{\\pi}{2}+k\\pi|k\\in\\mathbb{Z}\\}$","B":"$S=\\{k2\\pi|k\\in\\mathbb{Z}\\}$","C":"$S=\\{\\frac{\\pi}{2}+k2\\pi|k\\in\\mathbb{Z}\\}$","D":"$S=\\{k\\pi|k\\in\\mathbb{Z}\\}$"}', 
'D', 'Phương trình lượng giác cơ bản: $\\sin x = 0 \\Leftrightarrow x = k\\pi$ với $k \\in \\mathbb{Z}$. Vậy tập nghiệm là $S=\\{k\\pi|k\\in\\mathbb{Z}\\}$. Chọn D.', 1);

-- Câu 8
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(8, 'Trong mặt phẳng với hệ tọa độ $Oxy$, diện tích $S$ của hình phẳng giới hạn bởi đồ thị của hàm số $y=2x-3$, trục hoành và hai đường thẳng $x=1$, $x=2$ được xác định bằng công thức:', 'SINGLE_CHOICE', 
'{"A":"$S=\\pi\\int_1^2|2x-3|dx$","B":"$S=\\int_1^2|2x-3|dx$","C":"$S=\\pi\\int_1^2(2x-3)^2dx$","D":"$S=|\\int_1^2(2x-3)dx|$"}', 
'B', 'Theo định nghĩa, diện tích hình phẳng giới hạn bởi đồ thị hàm số $y=f(x)$, trục hoành và hai đường thẳng $x=a, x=b$ là $S = \\int_a^b |f(x)|dx$. Áp dụng ta có $S = \\int_1^2 |2x-3|dx$. Chọn B.', 1);

-- Câu 9
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(9, 'Trong không gian với hệ tọa độ $Oxyz$, mặt phẳng đi qua điểm $A(2;1;-4)$ nhận $\\vec{n}=(3;2;-1)$ làm một vectơ pháp tuyến có phương trình là:', 'SINGLE_CHOICE', 
'{"A":"$3(x-2)+2(y-1)-(z+4)=0$","B":"$2(x+3)+(y+2)-4(z-1)=0$","C":"$3(x+2)+2(y+1)-(z-4)=0$","D":"$2(x-3)+(y-2)-4(z+1)=0$"}', 
'A', 'Phương trình tổng quát mặt phẳng qua $M(x_0; y_0; z_0)$ có VTPT $\\vec{n}=(A;B;C)$ là $A(x-x_0) + B(y-y_0) + C(z-z_0) = 0$. Áp dụng: $3(x-2) + 2(y-1) - 1(z - (-4)) = 0 \\Leftrightarrow 3(x-2)+2(y-1)-(z+4)=0$. Chọn A.', 1);

-- Câu 10
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(10, 'Nghiệm của phương trình $\\log_3(2x-1)=2$ là:', 'SINGLE_CHOICE', 
'{"A":"$x=\\frac{7}{2}$","B":"$x=\\frac{5}{2}$","C":"$x=5$","D":"$x=4$"}', 
'C', 'Điều kiện: $2x-1 > 0 \\Leftrightarrow x > 1/2$. Ta có $\\log_3(2x-1) = 2 \\Leftrightarrow 2x-1 = 3^2 \\Leftrightarrow 2x-1 = 9 \\Leftrightarrow 2x=10 \\Leftrightarrow x=5$ (thỏa mãn). Chọn C.', 1);

-- Câu 11
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(11, 'Cho hàm số $y=\\frac{ax+b}{cx+d}$ có đồ thị như hình dưới. Đường tiệm cận đứng của đồ thị hàm số đã cho có phương trình là:', 'SINGLE_CHOICE', 
'{"A":"$y=2$","B":"$x=-1$","C":"$y=-1$","D":"$x=2$"}', 
'B', 'Nhìn vào đồ thị, ta thấy nhánh đồ thị tiến về vô cùng dọc theo đường thẳng đứng $x=-1$. Do đó phương trình tiệm cận đứng là $x=-1$. Chọn B.', 1);

-- Câu 12
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(12, 'Cho hình chóp $S.ABC$ có $SA$ vuông góc với mặt phẳng $(ABC)$, tam giác $ABC$ vuông tại $A$ và $SA=3, AB=4, AC=5$. Thể tích của khối chóp $S.ABC$ bằng:', 'SINGLE_CHOICE', 
'{"A":"30","B":"20","C":"60","D":"10"}', 
'D', 'Thể tích khối chóp là $V = \\frac{1}{3} S_{ đáy} \\cdot h$. Ta có đáy là tam giác vuông tại $A$ nên $S_{ABC} = \\frac{1}{2} AB \\cdot AC = \\frac{1}{2} \\cdot 4 \\cdot 5 = 10$. Thể tích $V = \\frac{1}{3} \\cdot 10 \\cdot SA = \\frac{1}{3} \\cdot 10 \\cdot 3 = 10$. Chọn D.', 1);


-- --- PHẦN II: TRẮC NGHIỆM ĐÚNG/SAI (TRUE_FALSE) ---
-- Câu 13 (Câu 1 Phần II)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(13, 'Cho hàm số $f(x)=x^3-12x-8$.', 'TRUE_FALSE', 
'{"a":"Hàm số đã cho có đạo hàm là $f''(x)=3x^2-12$.","b":"Phương trình $f''(x)=0$ có tập nghiệm là $S=\\{2\\}$.","c":"Giá trị cực tiểu của hàm số $f(2)=24$.","d":"Giá trị lớn nhất của hàm số $f(x)$ trên đoạn $[-3;3]$ bằng 24."}', 
'{"a":"T","b":"F","c":"F","d":"F"}', 
'a) Đúng vì $f''(x)=3x^2-12$. b) Sai vì nghiệm là $x = \\pm 2$ nên tập nghiệm là $S=\\{-2; 2\\}$. c) Sai vì cực tiểu tại $x=2$ có giá trị $f(2) = 2^3-12(2)-8 = -24$ chứ không phải $24$. d) Sai vì giá trị lớn nhất của hàm số trên đoạn $[-3;3]$ đạt tại điểm cực đại $x=-2$ có giá trị $f(-2)=8$.', 1);

-- Câu 14 (Câu 2 Phần II)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(14, 'Nồng độ thuốc tồn dư $y(t)$ (đơn vị: mg/lít) trong nước tại thời điểm $t$ ngày kể từ lúc sử dụng thỏa mãn $y''(t) = k \\cdot y(t)$ ($t \\ge 0$). Biết nồng độ đo được tại các ngày $t=6$ và $t=12$ lần lượt là 2 mg/lít và 1 mg/lít. Giả sử $y(t) = e^{g(t)}$.', 'TRUE_FALSE', 
'{"a":"$g(t)=kt+C$ ($t \\ge 0$) với C là một hằng số xác định.","b":"$k=\\frac{\\ln 2}{6}$","c":"$C=2\\ln 2$","d":"Nồng độ thuốc tồn dư trong nước tại thời điểm $t=25$ (ngày) kể từ lúc sử dụng lớn hơn $0,25$ mg/lít."}', 
'{"a":"T","b":"F","c":"T","d":"F"}', 
'a) Đúng vì $y''(t)/y(t) = k \\Rightarrow \\ln y(t) = kt + C \\Rightarrow g(t) = kt+C$. b) Sai vì $y(12)/y(6) = e^{6k} = 1/2 \\Rightarrow k = -\\frac{\\ln 2}{6}$. c) Đúng vì $y(6) = e^{6k+C} = 2 \\Rightarrow -\\ln 2 + C = \\ln 2 \\Rightarrow C = 2\\ln 2$. d) Sai vì $y(25) = e^{25k+C} = e^{-25/6\\ln 2 + 2\\ln 2} = 2^{-13/6} \\approx 0.22 < 0.25$ mg/lít.', 1);

-- Câu 15 (Câu 3 Phần II)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(15, 'Một hạt chuyển động thẳng có tốc độ phụ thuộc thời gian $t$ (giây) theo công thức $v(t) = \\beta t + 300$ ($0 \\le t \\le 6$, $\\beta$ là hằng số dương). Sau 2 giây đầu vật đi được quãng đường $s(2) = 604$ m. Gọi $\\vec{u}=(a;b;c)$ là vectơ cùng hướng với vectơ $\\vec{AB}$ có độ dài bằng 1, biết góc giữa $\\vec{u}$ lần lượt với các trục $Ox, Oy, Oz$ có số đo lần lượt bằng $60^\\circ, 60^\\circ, 45^\\circ$.', 'TRUE_FALSE', 
'{"a":"$a=\\cos 60^\\circ$.","b":"Phương trình đường thẳng AB là $\\frac{x-5}{1}=\\frac{y-5}{1}=\\frac{z}{2}$.","c":"$\\beta=2$.","d":"Giả sử sau 5 giây kể từ lúc bắt đầu, vật đến điểm $B(x_B; y_B; z_B)$. Khi đó $x_B > 768$."}', 
'{"a":"T","b":"F","c":"T","d":"F"}', 
'a) Đúng theo công thức cosin hướng. b) Sai vì vectơ chỉ phương là $(1/2; 1/2; \\sqrt{2}/2)$. c) Đúng vì tích phân $s(2) = \\int_0^2 v(t)dt = 2\\beta + 600 = 604 \\Rightarrow \\beta = 2$. d) Sai vì quãng đường sau 5s là $s(5) = 1525$ m, khi đó $x_B = x_A + s(5) \\cdot a = 5 + 1525 \\cdot 0.5 = 767.5 < 768$.', 1);

-- Câu 16 (Câu 4 Phần II)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(16, 'Một phần mềm nhận dạng tin nhắn quảng cáo dựa theo từ khóa. Kết quả thực tế cho thấy có 15% số tin nhắn bị đánh dấu. Trong số các tin nhắn bị đánh dấu, có 10% không phải quảng cáo. Trong số các tin nhắn không bị đánh dấu, có 5% là tin nhắn quảng cáo. Chọn ngẫu nhiên một tin nhắn.', 'TRUE_FALSE', 
'{"a":"Xác suất để tin nhắn đó không bị đánh dấu bằng 0,85.","b":"Xác suất để tin nhắn đó không phải quảng cáo, biết nó không bị đánh dấu, bằng 0,95.","c":"Xác suất để tin nhắn đó không phải quảng cáo bằng 0,85.","d":"Xác suất để tin nhắn đó không bị đánh dấu, biết rằng nó không phải là quảng cáo, lớn hơn 0,95."}', 
'{"a":"T","b":"T","c":"F","d":"T"}', 
'a) Đúng vì $P(\\text{Không đánh dấu}) = 1 - 0.15 = 0.85$. b) Đúng trực tiếp theo đề bài. c) Sai vì $P(\\text{Không QC}) = 0.10 \\cdot 0.15 + 0.95 \\cdot 0.85 = 0.8225 \\neq 0.85$. d) Đúng vì $P(\\text{Không đánh dấu}|\\text{Không QC}) = \\frac{0.95 \\cdot 0.85}{0.8225} \\approx 0.9817 > 0.95$.', 1);


-- --- PHẦN III: TRẮC NGHIỆM ĐIỀN ĐÁP SỐ (SHORT_ANSWER) ---
-- Câu 17 (Câu 1 Phần III)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(17, 'Bạn Nam chọn ngẫu nhiên sáu số từ tập $S=\\{11;12;13;14;15;16;17;18;19\\}$ để xếp vào sáu vị trí $A, B, C, M, N, P$ trên sơ đồ tam giác. Mật thư giải được nếu bộ ba số tại $(A,M,B); (B,N,C); (C,P,A)$ đều lập thành cấp số cộng theo thứ tự đó. Gọi $a$ là xác suất để Nam giải được mật thư ở lần xếp ngẫu nhiên đầu tiên. Tính giá trị biểu thức $\\frac{1}{a}$. (Làm tròn kết quả đến hàng phần mười).', 'SHORT_ANSWER', 
NULL, '95.9', 'Bằng cách sử dụng phương pháp tổ hợp để tính số cách xếp thuận lợi cho cấp số cộng chia cho tổng số cách xếp ngẫu nhiên $P(S) = A_9^6$, ta tính ra xác suất $a$. Giá trị nghịch đảo $1/a \\approx 95.9$.', 1);

-- Câu 18 (Câu 2 Phần III)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(18, 'Một doanh nghiệp có doanh thu tháng đạt $F(x) = -0.01x^2 + 300x$ (nghìn đồng) và chi phí bình quân mỗi sản phẩm là $G(x) = \\frac{30000}{x} + 200$ (nghìn đồng), với $x$ là số sản phẩm sản xuất ($1 \\le x \\le 4500$). Doanh nghiệp cần sản xuất tối thiểu bao nhiêu sản phẩm để lợi nhuận thu được lớn hơn 100 triệu đồng?', 'SHORT_ANSWER', 
NULL, '1536', 'Lợi nhuận $P(x) = F(x) - x \\cdot G(x) = -0,01x^2 + 100x - 30000$ (nghìn đồng). Để lợi nhuận lớn hơn 100 triệu (tương đương 100,000 nghìn đồng), giải bất phương trình: $-0,01x^2 + 100x - 30000 > 100000 \\Leftrightarrow 1535.9 < x < 8464.1$. Do $x \\in \\mathbb{N}^*$, giá trị tối thiểu của $x$ là 1536.', 1);

-- Câu 19 (Câu 3 Phần III)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(19, 'Câu lạc bộ bán nước chanh và khoai chiên. Thực đơn 1: 30 nghìn đồng (2 nước chanh + 1 khoai). Thực đơn 2: 50 nghìn đồng (3 nước chanh + 2 khoai). Biết rằng tối đa chỉ chuẩn bị được 165 cốc nước chanh và 100 túi khoai chiên. Số tiền lớn nhất câu lạc bộ có thể nhận được sau khi bán hết hàng là bao nhiêu nghìn đồng?', 'SHORT_ANSWER', 
NULL, '2520', 'Gọi $a$ và $b$ lần lượt là số lượng thực đơn 1 và thực đơn 2 bán ra. Ta có hệ phương trình ràng buộc: $2a + 3b \\le 165$ (nước chanh) và $a + 2b \\le 100$ (khoai chiên) với $a, b \\ge 0$. Hàm tối ưu doanh thu: $T(a,b) = 30a + 50b$. Áp dụng quy hoạch tuyến tính, doanh thu lớn nhất đạt được là 2,520 nghìn đồng tại đỉnh $(30, 45)$.', 1);

-- Câu 20 (Câu 4 Phần III)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(20, 'Cho hình chóp $S.ABCD$ có đáy là hình thoi cạnh bằng 2, góc $\\hat{ABC} = 60^\\circ$. Hình chiếu của $S$ lên mặt đáy là trọng tâm $H$ của tam giác $ABC$, và $SH = \\sqrt{3}$. Tính khoảng cách giữa hai đường thẳng $AC$ và $SD$. (Làm tròn kết quả đến 2 chữ số thập phân).', 'SHORT_ANSWER', 
NULL, '1.04', 'Dựng hệ trục tọa độ hoặc dùng hình học không gian thuần túy để tính khoảng cách giữa hai đường thẳng chéo nhau $AC$ và $SD$. Kết quả tính toán khoảng cách bằng $\\frac{3\\sqrt{21}}{14} \\approx 1.04$.', 1);

-- Câu 21 (Câu 5 Phần III)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(21, 'An xếp 7 quyển sách khác nhau vào 4 ngăn sách được đánh số 1, 2, 3, 4 sao cho mỗi ngăn có ít nhất 1 quyển sách. Sách được xếp thẳng đứng thành hàng quang. Gọi $T$ là số cách xếp khác nhau. Tính giá trị $\\frac{T}{100}$.', 'SHORT_ANSWER', 
NULL, '1008', 'Áp dụng bài toán chia kẹo Euler cải tiến kết hợp hoán vị các quyển sách khác nhau, ta tính được tổng số cách xếp sách hợp lệ là $T = 100,800$ cách. Giá trị $\\frac{T}{100} = 1008$.', 1);

-- Câu 22 (Câu 6 Phần III)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(22, 'Thiết kế chân đế bằng gỗ hình chóp cụt tứ giác đều có hai cạnh đáy lần lượt là 7,4 cm và 10,4 cm, bề dày là 1,5 cm. Khoét bỏ đi phần vật thể $H$ có dạng chỏm cầu bán kính 5,8 cm bị cắt bởi mặt phẳng tạo ra đường tròn bán kính 3,5 cm. Thể tích thực tế của chân đế bằng bao nhiêu $cm^3$? (Làm tròn đến hàng phần mười).', 'SHORT_ANSWER', 
NULL, '96.5', 'Thể tích hình chóp cụt đều $V_{c} = \\frac{1}{3}h(S_1 + S_2 + \\sqrt{S_1S_2}) \\approx 120.53$ $cm^3$. Thể tích chỏm cầu bị khoét $V_h = \\pi h_c^2(R - \\frac{h_c}{3})$ với chiều cao chỏm cầu $h_c = R - \\sqrt{R^2 - r^2} = 5.8 - 4.63 = 1.17$ cm $\\Rightarrow V_h \\approx 23.99$ $cm^3$. Thể tích thực tế $V = V_c - V_h \\approx 96.5$ $cm^3$.', 1);


-- -------------------------------------------------------------------------
-- 2. NẠP ĐỀ THI MÔN VẬT LÝ THPT QG 2024 (Đề tham khảo)
-- -------------------------------------------------------------------------
INSERT INTO exams (id, title, subject, duration, description, created_at) VALUES 
(2, 'Đề thi tham khảo THPT Quốc Gia môn Vật Lý 2024', 'Vật Lý', 50, 'Đề thi thử nghiệm đánh giá năng lực môn Vật Lý chuẩn cấu trúc kì thi THPT Quốc Gia năm 2024 do Bộ Giáo Dục và Đào Tạo công bố.', CURRENT_TIMESTAMP());

-- --- PHẦN I: TRẮC NGHIỆM ĐƠN ---
-- Câu 1 (Physics ID = 23)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(23, 'Đặt điện áp xoay chiều vào hai đầu đoạn mạch chỉ có cuộn cảm thuần. So với điện áp giữa hai đầu đoạn mạch, cường độ dòng điện trong đoạn mạch:', 'SINGLE_CHOICE', 
'{"A":"trễ pha $\\frac{\\pi}{2}$","B":"cùng pha","C":"ngược pha","D":"sớm pha $\\frac{\\pi}{2}$"}', 
'A', 'Trong đoạn mạch xoay chiều chỉ chứa cuộn cảm thuần, cường độ dòng điện $i$ luôn biến thiên trễ pha $\\frac{\\pi}{2}$ so với điện áp hai đầu đoạn mạch $u$. Chọn A.', 2);

-- Câu 2 (Physics ID = 24)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(24, 'Một hạt nhân ${}^{13}_{6}C$ có số nuclôn bằng bao nhiêu?', 'SINGLE_CHOICE', 
'{"A":"13","B":"7","C":"19","D":"6"}', 
'A', 'Số nuclôn trong một hạt nhân ${}^A_Z X$ chính là số khối $A$ (nằm ở phía trên kí hiệu). Với hạt nhân ${}^{13}_{6}C$, số nuclôn bằng 13. Chọn A.', 2);

-- Câu 3 (Physics ID = 25)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(25, 'Đặt điện áp xoay chiều vào hai đầu đoạn mạch gồm điện trở $R$, cuộn cảm thuần và tụ điện mắc nối tiếp thì cảm kháng và dung kháng lần lượt là $Z_L$ và $Z_C$. Độ lệch pha $\\varphi$ của điện áp so với cường độ dòng điện thỏa mãn công thức nào sau đây?', 'SINGLE_CHOICE', 
'{"A":"$\\tan \\varphi = \\frac{R}{Z_L+Z_C}$","B":"$\\tan \\varphi = \\frac{Z_L+Z_C}{R}$","C":"$\\tan \\varphi = \\frac{R}{Z_L-Z_C}$","D":"$\\tan \\varphi = \\frac{Z_L-Z_C}{R}$"}', 
'D', 'Công thức tính độ lệch pha của điện áp hai đầu đoạn mạch so với dòng điện trong mạch RLC nối tiếp là $\\tan \\varphi = \\frac{Z_L - Z_C}{R}$. Chọn D.', 2);

-- Câu 4 (Physics ID = 26)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(26, 'Tốc độ truyền âm nhỏ nhất trong môi trường nào sau đây?', 'SINGLE_CHOICE', 
'{"A":"Sắt (rắn)","B":"Nước biển ở $15^\\circ C$ (lỏng)","C":"Nhôm (rắn)","D":"Không khí ở $0^\\circ C$ (khí)"}', 
'D', 'Tốc độ truyền âm phụ thuộc vào mật độ vật chất của môi trường, truyền tốt nhất trong chất rắn, tiếp đến là chất lỏng, và kém nhất là chất khí. Do đó tốc độ truyền âm nhỏ nhất là trong môi trường Không khí (khí). Chọn D.', 2);

-- Câu 5 (Physics ID = 27)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(27, 'Hệ vật cô lập về điện là hệ vật:', 'SINGLE_CHOICE', 
'{"A":"có trao đổi điện tích dương với các vật khác ngoài hệ.","B":"không có trao đổi điện tích giữa các vật trong hệ.","C":"có trao đổi điện tích âm với các vật khác ngoài hệ.","D":"không có trao đổi điện tích với các vật khác ngoài hệ."}', 
'D', 'Theo định nghĩa trong chương trình Vật lý 11, hệ vật cô lập về điện là hệ vật không có sự trao đổi điện tích với các vật bên ngoài hệ. Chọn D.', 2);

-- Câu 6 (Physics ID = 28)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(28, 'Kim loại đồng ($Cu$) là chất:', 'SINGLE_CHOICE', 
'{"A":"dẫn điện tốt.","B":"có điện trở suất không thay đổi theo nhiệt độ.","C":"không dẫn điện.","D":"có điện trở suất giảm khi nhiệt độ tăng."}', 
'A', 'Đồng là kim loại có mật độ electron tự do rất lớn, là chất dẫn điện rất tốt (chỉ đứng sau bạc). Chọn A.', 2);

-- Câu 7 (Physics ID = 29)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(29, 'Một vật dao động điều hòa với phương trình $x=A\\cos(\\omega t+\\varphi)$ ($t$ tính bằng giây). Tần số góc $\\omega$ có đơn vị là:', 'SINGLE_CHOICE', 
'{"A":"rad/s","B":"rad/$s^2$","C":"s/rad","D":"$s^2$/rad"}', 
'A', 'Tần số góc $\\omega$ trong dao động điều hòa đặc trưng cho tốc độ thay đổi pha dao động và có đơn vị đo chuẩn là radian trên giây (rad/s). Chọn A.', 2);

-- Câu 8 (Physics ID = 30)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(30, 'Một con lắc lò xo gồm lò xo nhẹ có độ cứng $k$ và vật nhỏ có khối lượng $m$. Tần số dao động tự do $f$ của con lắc lò xo được xác định bằng công thức:', 'SINGLE_CHOICE', 
'{"A":"$f = \\frac{1}{2\\pi}\\sqrt{\\frac{m}{k}}$","B":"$f = \\frac{1}{2\\pi}\\sqrt{\\frac{k}{m}}$","C":"$f = \\sqrt{\\frac{m}{k}}$","D":"$f = \\sqrt{\\frac{k}{m}}$"}', 
'B', 'Tần số góc $\\omega = \\sqrt{\\frac{k}{m}}$. Tần số dao động điều hòa $f = \\frac{\\omega}{2\\pi} = \\frac{1}{2\\pi}\\sqrt{\\frac{k}{m}}$. Chọn B.', 2);

-- Câu 9 (Physics ID = 31)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(31, 'Hạt nhân nào sau đây bền vững nhất?', 'SINGLE_CHOICE', 
'{"A":"${}^{235}_{92}U$","B":"${}^4_2He$","C":"${}^{56}_{28}Fe$","D":"${}^3_1H$"}', 
'C', 'Các hạt nhân có số khối nằm trong khoảng trung bình từ 50 đến 95 có năng lượng liên kết riêng lớn nhất nên bền vững nhất. Trong các hạt nhân trên, sắt (${}^{56}_{28}Fe$) là bền vững nhất. Chọn C.', 2);

-- Câu 10 (Physics ID = 32)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(32, 'Hiện tượng nhiễu xạ ánh sáng và giao thoa ánh sáng chứng tỏ ánh sáng:', 'SINGLE_CHOICE', 
'{"A":"là sóng cơ.","B":"là chùm hạt electron.","C":"có tính chất sóng.","D":"có tính chất hạt."}', 
'C', 'Các hiện tượng đặc trưng như nhiễu xạ, giao thoa và phản xạ/khúc xạ chứng tỏ ánh sáng có bản chất là sóng (sóng điện từ). Chọn C.', 2);

-- Câu 11 (Physics ID = 33)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(33, 'Theo thuyết lượng tử ánh sáng, phát biểu nào sau đây là sai?', 'SINGLE_CHOICE', 
'{"A":"Trong chân không, phôtôn bay với tốc độ $3.10^8$ m/s dọc theo tia sáng.","B":"Năng lượng của các phôtôn ứng với các ánh sáng đơn sắc khác nhau luôn bằng nhau.","C":"Ánh sáng được tạo thành bởi các hạt gọi là phôtôn.","D":"Phôtôn chỉ tồn tại trong trạng thái chuyển động. Không có phôtôn đứng yên."}', 
'B', 'Năng lượng phôtôn được tính bằng công thức $\\varepsilon = hf = \\frac{hc}{\\lambda}$. Do các ánh sáng đơn sắc khác nhau có tần số $f$ khác nhau nên năng lượng phôtôn của chúng cũng khác nhau. Phát biểu B sai. Chọn B.', 2);

-- Câu 12 (Physics ID = 34)
INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES 
(34, 'Trên một sợi dây đàn hồi đang có sóng dừng ổn định, nút sóng là các điểm trên dây mà phần tử ở đó:', 'SINGLE_CHOICE', 
'{"A":"luôn luôn đứng yên.","B":"dao động với biên độ bằng một bước sóng.","C":"dao động với biên độ bằng nửa bước sóng.","D":"dao động với biên độ lớn nhất."}', 
'A', 'Trong sóng dừng, nút sóng là vị trí hai sóng ngược pha nhau hoàn toàn và triệt tiêu nhau, khiến phần tử tại nút luôn luôn đứng yên (biên độ dao động bằng 0). Chọn A.', 2);

-- Reset sequence values so subsequent JPA inserts do not conflict
ALTER TABLE exams ALTER COLUMN id RESTART WITH 3;
ALTER TABLE questions ALTER COLUMN id RESTART WITH 35;
