# แดชบอร์ดข้อมูลการผลิต — ร่วมมิตรคอนกรีต

แดชบอร์ด HTML/JS ไฟล์เดียว เชื่อมต่อข้อมูลแบบเรียลไทม์จาก Supabase พร้อมรันบน GitHub Pages ได้ทันที

## ขั้นตอนติดตั้ง

### 1. สร้างตารางใน Supabase
1. เข้า Supabase Dashboard → โปรเจกต์ของคุณ → **SQL Editor**
2. คัดลอกเนื้อหาในไฟล์ `schema.sql` แล้วรัน (Run)
   - จะได้ตาราง `production_records` พร้อมข้อมูลตัวอย่าง 7 แถว
   - มี Row Level Security เปิดอยู่ และตั้ง policy ให้อ่านข้อมูลแบบ public (เหมาะกับแดชบอร์ดภายในที่ใช้ anon key)

### 2. ใส่ค่าเชื่อมต่อ Supabase ในไฟล์ index.html
1. ไปที่ Supabase Dashboard → **Settings → API**
2. คัดลอกค่า `Project URL` และ `anon public key`
3. เปิดไฟล์ `index.html` หาบรรทัด:
   ```js
   const SUPABASE_URL = "https://YOUR_PROJECT_REF.supabase.co";
   const SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";
   ```
   แล้วแทนที่ด้วยค่าจริงของคุณ

### 3. อัปโหลดขึ้น GitHub และเปิดใช้งาน GitHub Pages
1. สร้าง repository ใหม่ใน GitHub (เช่น `production-dashboard`)
2. อัปโหลดไฟล์ `index.html` (และ `schema.sql` หากต้องการเก็บไว้อ้างอิง)
3. ไปที่ repository → **Settings → Pages**
4. เลือก Source = `main` branch, โฟลเดอร์ `/ (root)` → กด Save
5. รอสักครู่ จะได้ลิงก์แดชบอร์ดรูปแบบ `https://<username>.github.io/<repo-name>/`

## โครงสร้างตาราง production_records

| คอลัมน์ | ประเภท | ความหมาย |
|---|---|---|
| record_date | date | วันที่บันทึกข้อมูล |
| product_type | text | ประเภทสินค้า เช่น เสาเข็ม, แผ่นพื้น, คาน |
| shift | text | กะ/ยาม |
| planned_qty | numeric | คิวผลิตตามแผน |
| actual_qty | numeric | คิวผลิตจริง |
| transport_qty | numeric | คิวขนส่ง |
| compressive_strength | numeric | กำลังอัดคอนกรีต (ksc) |
| sales_qty | numeric | ยอดขาย |
| damage_qty | numeric | ยอดเสียหาย |
| raw_material_usage | numeric | การใช้วัตถุดิบ |
| stock_remaining | numeric | สต็อกคงเหลือ |

## ฟีเจอร์ในแดชบอร์ด
- การ์ด KPI: คิวผลิตรวม, % สำเร็จตามแผน, กำลังอัดเฉลี่ย, อัตราส่วนเสียหาย, สต็อกคงเหลือ
- กราฟแนวโน้มคิวผลิต (แผน vs จริง)
- กราฟกำลังอัดคอนกรีตรายวัน เทียบเส้นมาตรฐาน 350 ksc
- กราฟยอดขาย vs เสียหาย
- กราฟวงกลมสัดส่วนการผลิตตามประเภทสินค้า
- ตารางข้อมูลดิบ พร้อมตัวกรองตามสินค้าและช่วงวันที่
- รีเฟรชอัตโนมัติทุก 5 นาที + ปุ่มรีเฟรชด้วยตนเอง

## หมายเหตุด้านความปลอดภัย
ไฟล์นี้ใช้ Supabase **anon key** ซึ่งจะถูกฝังในโค้ดฝั่ง client (มองเห็นได้จาก browser) — เหมาะสำหรับข้อมูลที่ไม่อ่อนไหวและตั้งค่า RLS ให้อ่านอย่างเดียว (select only) ตามที่ตั้งไว้ใน schema.sql หากต้องการจำกัดการเข้าถึงเฉพาะผู้ใช้ในองค์กร แนะนำให้เปลี่ยนเป็นใช้ Supabase Auth แทนการเปิด public read
