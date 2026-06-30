-- ==========================================================
-- ตารางข้อมูลการผลิต (Production Records) สำหรับ ร่วมมิตรคอนกรีต
-- ใช้กับ Supabase (PostgreSQL)
-- ==========================================================

create table if not exists production_records (
  id                    bigint generated always as identity primary key,
  record_date           date not null,                 -- วันที่บันทึกข้อมูล
  product_type          text not null,                  -- ประเภทสินค้า เช่น เสาเข็ม, แผ่นพื้น, คาน
  shift                 text,                            -- กะ/ยาม เช่น เช้า, บ่าย, ดึก
  planned_qty           numeric(12,2) default 0,         -- คิวผลิตตามแผน (ลบ.ม. หรือหน่วยที่ใช้)
  actual_qty            numeric(12,2) default 0,         -- คิวผลิตจริง
  transport_qty         numeric(12,2) default 0,         -- คิวขนส่ง
  compressive_strength  numeric(8,2),                    -- กำลังอัดคอนกรีต (ksc) มาตรฐาน 350 ksc
  sales_qty             numeric(12,2) default 0,         -- ยอดขาย
  damage_qty            numeric(12,2) default 0,         -- ยอดเสียหาย
  raw_material_usage    numeric(12,2) default 0,         -- การใช้วัตถุดิบ
  stock_remaining       numeric(12,2) default 0,         -- สต็อกคงเหลือ
  created_at            timestamptz default now()
);

-- index สำหรับ query ตามช่วงวันที่ (ใช้บ่อยในแดชบอร์ด)
create index if not exists idx_production_records_date on production_records (record_date);
create index if not exists idx_production_records_product on production_records (product_type);

-- เปิด Row Level Security
alter table production_records enable row level security;

-- อนุญาตให้อ่านข้อมูลแบบ public (เหมาะกับแดชบอร์ดภายในที่ใช้ anon key)
-- หากต้องการความปลอดภัยมากขึ้น ควรเปลี่ยนเป็น authenticated เท่านั้น
create policy "Allow public read access"
  on production_records
  for select
  using (true);

-- ตัวอย่างข้อมูลทดสอบ (ลบออกได้หลังเชื่อมต่อข้อมูลจริง)
insert into production_records
  (record_date, product_type, shift, planned_qty, actual_qty, transport_qty, compressive_strength, sales_qty, damage_qty, raw_material_usage, stock_remaining)
values
  (current_date - 6, 'เสาเข็ม', 'เช้า', 120, 115, 110, 355, 100, 2, 90, 500),
  (current_date - 5, 'แผ่นพื้น', 'บ่าย', 150, 148, 140, 360, 130, 1, 95, 480),
  (current_date - 4, 'เสาเข็ม', 'เช้า', 130, 125, 120, 348, 110, 3, 88, 460),
  (current_date - 3, 'คาน', 'ดึก', 100, 98, 95, 352, 90, 1.5, 70, 450),
  (current_date - 2, 'แผ่นพื้น', 'เช้า', 160, 162, 155, 358, 140, 2, 100, 470),
  (current_date - 1, 'เสาเข็ม', 'บ่าย', 140, 135, 130, 350, 120, 2.5, 92, 440),
  (current_date,     'แผ่นพื้น', 'เช้า', 155, 150, 148, 356, 135, 1, 98, 460);
