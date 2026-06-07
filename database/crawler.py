import urllib.request
import re
import json
import os
import sys
import time

# Sitemap URL for all exams
SITEMAP_URL = "https://baitaptracnghiem.com/sitemap.xml"

USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

def fetch_html(url):
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    try:
        with urllib.request.urlopen(req, timeout=10) as response:
            return response.read().decode("utf-8")
    except Exception as e:
        print(f"Error fetching {url}: {e}")
        return None

def extract_exam_slugs():
    print("Fetching sitemap.xml to extract all exam slugs...")
    content = fetch_html(SITEMAP_URL)
    if not content:
        print("Failed to fetch sitemap.xml.")
        return []
        
    found_slugs = re.findall(r'https?://baitaptracnghiem\.com/lam-bai/([a-zA-Z0-9\-]+)', content)
    found_slugs = list(set(found_slugs))
    print(f"Total exam slugs found in sitemap: {len(found_slugs)}")
    
    # Categorize slugs to ensure we get a balanced mix of subjects
    groups = {
        "toan": [],
        "vat-ly": [],
        "hoa-hoc": [],
        "sinh-hoc": [],
        "tieng-anh": [],
        "lich-su": [],
        "dia-ly": [],
        "gdcd": [],
        "triet-hoc": [],
        "tu-tuong": [],
        "phap-luat": [],
        "xa-hoi-hoc": [],
        "others": []
    }
    
    for slug in found_slugs:
        slug_lower = slug.lower()
        if "toan" in slug_lower or "math" in slug_lower:
            groups["toan"].append(slug)
        elif "vat-ly" in slug_lower or "physics" in slug_lower or "mon-ly" in slug_lower or "vat-li" in slug_lower or "mon-li" in slug_lower:
            groups["vat-ly"].append(slug)
        elif "hoa-hoc" in slug_lower or "chemistry" in slug_lower or "mon-hoa" in slug_lower:
            groups["hoa-hoc"].append(slug)
        elif "sinh-hoc" in slug_lower or "biology" in slug_lower or "mon-sinh" in slug_lower:
            groups["sinh-hoc"].append(slug)
        elif "tieng-anh" in slug_lower or "english" in slug_lower or "tienganh" in slug_lower:
            groups["tieng-anh"].append(slug)
        elif "lich-su" in slug_lower or "history" in slug_lower or "mon-su" in slug_lower or "lichsu" in slug_lower:
            groups["lich-su"].append(slug)
        elif "dia-ly" in slug_lower or "dia-li" in slug_lower or "geography" in slug_lower or "mon-dia" in slug_lower:
            groups["dia-ly"].append(slug)
        elif "gdcd" in slug_lower or "giao-duc-cong-dan" in slug_lower or "giao-duc-dan" in slug_lower:
            groups["gdcd"].append(slug)
        elif "triet-hoc" in slug_lower or "triethoc" in slug_lower:
            groups["triet-hoc"].append(slug)
        elif "tu-tuong" in slug_lower or "tutuong" in slug_lower:
            groups["tu-tuong"].append(slug)
        elif "phap-luat" in slug_lower or "phapluat" in slug_lower:
            groups["phap-luat"].append(slug)
        elif "xa-hoi-hoc" in slug_lower or "xahoihoc" in slug_lower:
            groups["xa-hoi-hoc"].append(slug)
        else:
            groups["others"].append(slug)
            
    print("Subject breakdown in sitemap:")
    for key, val in groups.items():
        print(f"  Subject '{key}': {len(val)} slugs")
        
    selected_slugs = []
    # Balance across categories. We want ~110.
    # We take 9 slugs from each of the 12 specific subject categories (9 * 12 = 108 slugs)
    ordered_keys = ["toan", "vat-ly", "hoa-hoc", "sinh-hoc", "tieng-anh", "lich-su", "dia-ly", "gdcd", "triet-hoc", "tu-tuong", "phap-luat", "xa-hoi-hoc"]
    per_category = 5
    
    for key in ordered_keys:
        category_slugs = groups[key]
        selected_slugs.extend(category_slugs[:per_category])
        
    print(f"Selected {len(selected_slugs)} balanced exam slugs for scraping.")
    return selected_slugs

def decode_escapes(s):
    # Decode \uXXXX escapes
    try:
        s = re.sub(r'\\u([0-9a-fA-F]{4})', lambda m: chr(int(m.group(1), 16)), s)
    except Exception:
        pass
    
    # Decode standard JSON escapes
    escapes = {
        r'\"': '"',
        r'\\': '\\',
        r'\/': '/',
        r'\n': '\n',
        r'\r': '\r',
        r'\t': '\t',
        r'\b': '\b',
        r'\f': '\f'
    }
    for esc, rep in escapes.items():
        s = s.replace(esc, rep)
    return s

def parse_next_hydration_payload(html):
    payloads = []
    for match in re.finditer(r'self\.__next_f\.push\(\[\d+,\s*"(.*?)"\]\)', html):
        escaped_str = match.group(1)
        try:
            unescaped = decode_escapes(escaped_str)
            payloads.append(unescaped)
        except Exception:
            payloads.append(escaped_str)
            
    return "".join(payloads)

def parse_correct_answer(note_text):
    if not note_text:
        return "A"
    
    # Remove HTML tags and spaces
    note_clean = re.sub(r'<[^>]+>', '', note_text).strip()
    
    # Common Vietnamese patterns in baitaptracnghiem explanation notes:
    # "Chọn đáp án B."
    # "Chọn phương án C."
    # "Chọn B."
    # "Đáp án đúng là D."
    # "Đáp án C."
    # "Chọn đáp án đúng: A."
    
    # Try looking for "Chọn đáp án/phương án [A-D]"
    ans_match = re.search(r'(?:ch\u1ecdn|ph\u01b0\u01a1ng\s*\xe1n|d\xe1p\s*\xe1n)\s*(?:d\xe1p\s*\xe1n\s*|ph\u01b0\u01a1ng\s*\xe1n\s*)?([A-D])', note_clean, re.IGNORECASE)
    if ans_match:
        return ans_match.group(1).upper()
        
    # Fallback: find the first occurrence of "Chọn B" or similar
    ans_match2 = re.search(r'\b(?:ch\u1ecdn|d\xe1p|d\xe1p\s*\xe1n)\s*([A-D])\b', note_clean, re.IGNORECASE)
    if ans_match2:
        return ans_match2.group(1).upper()
        
    # Default fallback
    return "A"

def clean_html(text):
    if not text:
        return ""
    # Strip HTML tags
    clean = re.sub(r'<[^>]+>', '', text).strip()
    # Normalize spaces
    clean = re.sub(r'\s+', ' ', clean)
    # Fix escaped quotes
    return clean

def parse_options(answers_list):
    options = {}
    # answers_list format: [{"id": 622147, "name": "A. - 2", ...}]
    # We want to map it to {"A": "- 2", "B": "2", ...}
    for i, ans in enumerate(answers_list):
        name = clean_html(ans.get("name", ""))
        
        # Try to parse choice prefix (A. or B. or C. or D. or A/B/C/D)
        m = re.match(r'^([A-D])\s*[\.\:\-\_]\s*(.*)$', name, re.IGNORECASE)
        if m:
            key = m.group(1).upper()
            val = m.group(2).strip()
            options[key] = val
        else:
            # Fallback based on index (0=A, 1=B, 2=C, 3=D)
            key = chr(65 + i)  # 65 is ASCII for 'A'
            options[key] = name
            
    # Guarantee we have A, B, C, D
    for key in ["A", "B", "C", "D"]:
        if key not in options:
            options[key] = ""
            
    return options

def escape_sql(val):
    if val is None:
        return "NULL"
    # Escape single quotes for SQL
    return "'" + str(val).replace("'", "''") + "'"

def main():
    print("Starting database crawler...")
    slugs = extract_exam_slugs()
    print(f"Collected {len(slugs)} exams to download.")
    
    if not slugs:
        print("No slugs found. Exiting.")
        return

    output_path = r'c:\Users\Huy Khang\Desktop\exam\database\seed.sql'
    
    # Initialize SQL seeder
    sql_file = open(output_path, "w", encoding="utf-8")
    sql_file.write("-- =========================================================================\n")
    sql_file.write("-- FILE SEED TỰ ĐỘNG KHỔNG LỒ (100+ ĐỀ THI TRẮC NGHIỆM ĐA MÔN)\n")
    sql_file.write("-- =========================================================================\n\n")
    sql_file.write("DELETE FROM questions;\n")
    sql_file.write("DELETE FROM exams;\n\n")
    
    exam_id_counter = 1
    question_id_counter = 1
    successful_exams_count = 0
    
    for i, slug in enumerate(slugs):
        print(f"\nProcessing exam {i+1}/{len(slugs)}: {slug}")
        url = f"https://baitaptracnghiem.com/lam-bai/{slug}"
        html = fetch_html(url)
        if not html:
            print("Failed to download page. Skipping.")
            continue
            
        payload = parse_next_hydration_payload(html)
        if not payload:
            print("Failed to find Next.js hydration payload. Skipping.")
            continue
            
        # We need to find the exam details and list of questions
        # To do this, we search for all question dictionaries in the payload:
        # e.g., {"id":158649,"name":"...","answers":[...]}
        # We can extract the question dictionaries using a regex matching the JSON objects
        # that contain "answers" and "question_id"
        
        # Let's first extract the exam title and subject
        # Title is inside <title>...</title>
        title_match = re.search(r'<title>(.*?)</title>', html)
        title = title_match.group(1).replace(" - Baitaptracnghiem.com", "").replace(" - Bài Tập Trắc Nghiệm", "").strip() if title_match else f"Đề thi trắc nghiệm {slug}"
        
        # Subject and duration can be found in Next.js props or guessed
        subject = "Toán"
        if "vat-ly" in slug or "physics" in slug:
            subject = "Vật Lý"
        elif "hoa-hoc" in slug or "chemistry" in slug:
            subject = "Hóa Học"
        elif "sinh-hoc" in slug or "biology" in slug:
            subject = "Sinh Học"
        elif "lich-su" in slug or "history" in slug:
            subject = "Lịch Sử"
        elif "dia-ly" in slug or "geography" in slug:
            subject = "Địa Lý"
        elif "tieng-anh" in slug or "english" in slug:
            subject = "Tiếng Anh"
        elif "triet-hoc" in slug:
            subject = "Triết Học"
        elif "tu-tuong" in slug:
            subject = "Tư tưởng Hồ Chí Minh"
        elif "phap-luat" in slug:
            subject = "Pháp luật đại cương"
        elif "xa-hoi-hoc" in slug:
            subject = "Xã hội học"
        elif "gdcd" in slug or "giao-duc-cong-dan" in slug:
            subject = "Giáo Dục Công Dân"
            
        duration = 45 # Default duration
        duration_match = re.search(r'"time_limit_value":\s*(\d+)', payload)
        if duration_match:
            duration = int(duration_match.group(1))
            
        description = f"Đề thi trắc nghiệm online ôn tập kiểm tra môn {subject}. Làm bài trực tuyến có chấm điểm và lời giải chi tiết."
        
        # Find all question JSON-like blocks in the payload.
        # Structure is like: {"id":158649,"name":"...","note":"...","answers":[...]}
        # Let's search for `{"id":\d+,"name":` or similar patterns, and extract the JSON objects.
        # A simpler way is to find all occurrences of `"id":\d+,"name":` and trace the brace count
        # to extract the complete question object.
        questions_found = []
        q_start_indices = [m.start() for m in re.finditer(r'\{"id":\d+,"name":"', payload)]
        
        for q_idx in q_start_indices:
            # Trace brace count to extract the json string
            brace_count = 0
            in_str = False
            escape = False
            q_json_str = None
            
            for j in range(q_idx, len(payload)):
                char = payload[j]
                if in_str:
                    if escape:
                        escape = False
                    elif char == '\\':
                        escape = True
                    elif char == '"':
                        in_str = False
                else:
                    if char == '"':
                        in_str = True
                    elif char == '{':
                        brace_count += 1
                    elif char == '}':
                        brace_count -= 1
                        if brace_count == 0:
                            q_json_str = payload[q_idx:j+1]
                            break
                            
            if q_json_str:
                try:
                    # Clean double escaped backslashes which can happen in server props stream
                    q_obj = json.loads(q_json_str)
                    # Verify it is indeed a question (has answers and id)
                    if "answers" in q_obj and isinstance(q_obj["answers"], list) and len(q_obj["answers"]) > 0:
                        # Prevent duplicate questions
                        if q_obj["id"] not in [q["id"] for q in questions_found]:
                            questions_found.append(q_obj)
                except Exception:
                    # Sometimes the extraction is not perfect because it is truncated, ignore
                    pass
                    
        if len(questions_found) < 5:
            print(f"Skipping: Exam has too few parsed questions ({len(questions_found)}).")
            continue
            
        print(f"Successfully extracted {len(questions_found)} questions for this exam.")
        
        # Write Exam insert statement
        sql_file.write(f"-- Đề {exam_id_counter}: {title}\n")
        sql_file.write(f"INSERT INTO exams (id, title, subject, duration, description, created_at) VALUES \n")
        sql_file.write(f"({exam_id_counter}, {escape_sql(title)}, {escape_sql(subject)}, {duration}, {escape_sql(description)}, CURRENT_TIMESTAMP());\n\n")
        
        # Write Questions insert statements
        sql_file.write(f"-- Các câu hỏi đề {exam_id_counter}\n")
        for q in questions_found:
            q_text = clean_html(q.get("name", ""))
            # Remove "Câu XX: " prefix if present
            q_text = re.sub(r'^c\u00e2u\s*\d+\s*[\.\:\-\_]\s*', '', q_text, flags=re.IGNORECASE).strip()
            
            # Options Mapping
            opts = parse_options(q.get("answers", []))
            options_json_str = json.dumps(opts, ensure_ascii=False)
            
            # Correct answer & explanation parsing
            correct_ans_letter = parse_correct_answer(q.get("note", ""))
            explanation_clean = clean_html(q.get("note", ""))
            
            sql_file.write(f"INSERT INTO questions (id, question_text, question_type, options_json, correct_answer, explanation, exam_id) VALUES \n")
            sql_file.write(f"({question_id_counter}, {escape_sql(q_text)}, 'SINGLE_CHOICE', {escape_sql(options_json_str)}, {escape_sql(correct_ans_letter)}, {escape_sql(explanation_clean)}, {exam_id_counter});\n")
            
            question_id_counter += 1
            
        sql_file.write("\n-- -------------------------------------------------------------------------\n\n")
        
        exam_id_counter += 1
        successful_exams_count += 1
        
        # Avoid hammering the website
        time.sleep(0.5)
        
        if successful_exams_count >= 50: # Stop at 50 successful exams
            break
            
    # Reset H2 auto-increment sequences at the end of the script
    sql_file.write(f"ALTER TABLE exams ALTER COLUMN id RESTART WITH {exam_id_counter};\n")
    sql_file.write(f"ALTER TABLE questions ALTER COLUMN id RESTART WITH {question_id_counter};\n")
    
    sql_file.close()
    
    print("\n==================================================")
    print("DATABASE CRAWLING COMPLETED SUCCESSFULLY!")
    print(f"Seeded {successful_exams_count} exams in total.")
    print(f"Seeded {question_id_counter - 1} questions in total.")
    print(f"Generated seeder output to: {output_path}")
    print("==================================================")

if __name__ == '__main__':
    main()
