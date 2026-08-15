# Sadat Mobile Center — نسخه واقعی حساب کاربران

این نسخه برای احراز هویت واقعی از Supabase استفاده می‌کند. Supabase از ثبت‌نام ایمیل/رمز عبور و تأیید ایمیل پشتیبانی می‌کند؛ وقتی تأیید ایمیل روشن باشد، کاربر تا تأیید ایمیل وارد حساب نمی‌شود. citeturn0search2turn0search11

## 1) ساخت پروژه Supabase
1. وارد Supabase شو و یک Project بساز.
2. در Authentication > Providers > Email، Email provider را فعال و Email confirmations را روشن نگه دار.
3. در Project Settings / API، Project URL و Publishable key (یا anon key در پروژه‌های قدیمی) را بردار.
4. در Authentication > URL Configuration، آدرس سایت GitHub Pages خودت را به عنوان Site URL و Redirect URL اضافه کن؛ مثلاً:
   https://USERNAME.github.io/REPOSITORY/

## 2) ساخت جداول
فایل `supabase-schema.sql` را در SQL Editor قرار بده و Run کن.
این SQL جدول پروفایل، پیشرفت درس‌ها، RLS و تابع افزایش XP را می‌سازد.

## 3) وصل کردن سایت
در `index.html` این دو خط را پیدا کن:
const SUPABASE_URL = "YOUR_SUPABASE_URL";
const SUPABASE_KEY = "YOUR_SUPABASE_PUBLISHABLE_KEY";

آنها را با اطلاعات پروژه خودت جایگزین کن.

مهم: هرگز `service_role` key را داخل index.html قرار نده. کلید service_role فقط برای محیط سرور است و نباید در مرورگر منتشر شود. citeturn0search14

## 4) قرار دادن در GitHub Pages
فقط `index.html` را می‌توانی در ریشه repository قرار بده. فایل SQL را برای خودت نگه دار و لازم نیست روی سایت عمومی منتشرش کنی.

## 5) نتیجه
کاربر:
- ثبت‌نام با ایمیل و رمز عبور می‌کند.
- ایمیل تأیید دریافت می‌کند.
- بعد از تأیید وارد می‌شود.
- جلسه ورود در مرورگر حفظ می‌شود.
- می‌تواند خارج شود.
- پروفایل و XP دارد.
- تکمیل درس‌ها در `lesson_progress` ذخیره می‌شود.
- XP در `profiles` ذخیره می‌شود.

Supabase برای ورود ایمیل/رمز عبور از `signInWithPassword` و برای خروج از `signOut` استفاده می‌کند. citeturn0search0turn0search6

برای تولید واقعی، سرویس ایمیل سفارشی/SMTP هم توصیه می‌شود؛ سرویس ایمیل پیش‌فرض Supabase محدودیت ارسال دارد. citeturn0search11
