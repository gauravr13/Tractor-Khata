# 🚜 Tractor Khata - ट्रैक्टर खाता

**Version:** 1.1.0  
**Language:** Hindi (हिंदी)  
**Platform:** Android

---

## 📱 About / परिचय

**Tractor Khata** ट्रैक्टर चालकों के लिए बनाया गया एक सरल और उपयोगी ऐप है जो आपको अपने काम और पेमेंट का हिसाब-किताब रखने में मदद करता है। यह ऐप पूरी तरह से **हिंदी भाषा** में है और ट्रैक्टर ड्राइवरों की ज़रूरतों को ध्यान में रखकर बनाया गया है।

A simple and powerful work and payment management app designed specifically for tractor drivers. The app is fully in **Hindi language** and helps you manage farmer accounts, work records, and payment tracking efficiently.

---

## ✨ Features / विशेषताएं

### 👨‍🌾 Farmer Management / किसान प्रबंधन
- ✅ किसानों की सूची बनाएं और प्रबंधित करें
- ✅ नाम, फ़ोन नंबर और नोट्स के साथ किसान जोड़ें
- ✅ किसान की प्रोफाइल देखें और संपादित करें
- ✅ Search functionality - नाम या फ़ोन से किसान ढूंढें

### 💼 Work Tracking / काम का हिसाब
- ✅ अलग-अलग काम के प्रकार बनाएं (जैसे जुताई, बुआई, आदि)
- ✅ Custom work names - अपना खुद का काम का नाम भी डाल सकते हैं
- ✅ Start time और End time के साथ काम record करें
- ✅ Automatic duration calculation - टाइम अपने आप calculate हो जाता है
- ✅ Per hour rate set करें
- ✅ Total amount automatically calculate होता है
- ✅ काम की तारीख़ और नोट्स add करें

### 💰 Payment Management / पेमेंट का हिसाब  
- ✅ किसानों से मिली पेमेंट record करें
- ✅ बाकी (pending) और मिला हुआ (received) amount देखें
- ✅ Payment date और notes add करें
- ✅ Complete transaction history

### 📊 Dashboard & Reports / डैशबोर्ड
- ✅ हर किसान का अलग dashboard
- ✅ Total pending amount दिखता है
- ✅ Total received amount दिखता है  
- ✅ काम की गिनती (work count)
- ✅ Complete transaction timeline

### 📝 Rate Card / रेट कार्ड
- ✅ अलग-अलग कामों के लिए rate set करें
- ✅ Rate card देखें और edit करें
- ✅ New work types add करें

### 👤 Driver Profile / ड्राइवर प्रोफाइल
- ✅ अपनी प्रोफाइल बनाएं
- ✅ नाम, फ़ोन, email add करें
- ✅ Profile photo upload करें

### 🌐 Language / भाषा
- ✅ **पूरी तरह से हिंदी में**
- ✅ English भी available है
- ✅ Settings से language बदल सकते हैं

### 🎨 Modern UI/UX
- ✅ Clean और simple interface
- ✅ बड़े और साफ़ cards
- ✅ Easy navigation
- ✅ Touch-friendly design
- ✅ Smooth animations

---

## 🔧 Technical Features / तकनीकी विशेषताएं

### Database
- **Local SQLite Database** - सारा data आपके phone में safely store होता है
- **Drift ORM** - Fast और reliable database operations

### Authentication  
- **Google Sign-In** - Google account से Login करें
- **Firebase Authentication** - Secure login system

### Performance
- ⚡ 60 FPS smooth animations
- ⚡ Optimized scrolling with `cacheExtent`
- ⚡ Fast app startup
- ⚡ Lightweight app size (< 65 MB)

### Architecture
- 🏗️ **Provider State Management** - Efficient state handling
- 🏗️ **Repository Pattern** - Clean code structure
- 🏗️ **Material Design 3** - Modern UI components

---

## ⚠️ Important Notes / महत्वपूर्ण नोट्स

### 📌 Offline App
- यह ऐप **पूरी तरह से Offline** काम करता है
- इंटरनेट की ज़रूरत सिर्फ पहली बार Login करने के लिए है
- सारा data आपके phone में locally store होता है

### 🚨 Data Backup Warning
> **ध्यान दें:** यह ऐप offline है इसलिए **app uninstall करने पर सारा data delete हो जाएगा।**  
> 
> **Warning:** This is an offline app, so **all data will be cleared if you uninstall the app.**
> 
> 💾 **सुझाव:** Important data का regular backup लेते रहें।

### 📱 Future Updates में आएगा:
- ☁️ Cloud backup feature
- 📊 Excel/PDF export
- 📤 WhatsApp share feature

---

## 📥 Download / डाउनलोड

### Latest Release: v1.1.0

**Download APK:**  
👉 [TractorKhata_v1.1.apk](https://github.com/YOUR_USERNAME/tractor-khata/releases/download/v1.1.0/TractorKhata_v1.1.apk)

**What's New in v1.1.0:**
- ✨ Redesigned work and payment cards
- ✨ Better space management for long text
- ✨ Improved Hindi localization (dates in Hindi)
- ✨ Safer delete workflow (delete from edit screen)
- ✨ Cleaner and more modern UI

---

## 🛠️ Installation / इंस्टॉल करना

1. Download करें **TractorKhata_v1.1.apk** file
2. अगर "Unknown sources" warning आए तो Settings में जाकर allow करें
3. APK install करें
4. App खोलें और Google से Login करें
5. शुरू करें! 🎉

---

## 📸 Screenshots / स्क्रीनशॉट्स

_Coming soon..._

---

## 🔒 Privacy & Security / गोपनीयता

- ✅ सारा data आपके phone में locally store होता है
- ✅ कोई data server पर नहीं जाता
- ✅ Login के लिए सिर्फ Google authentication use होता है
- ✅ कोई ads नहीं
- ✅ कोई tracking नहीं

---

## 💻 Tech Stack

- **Framework:** Flutter 3.9+
- **Language:** Dart
- **Database:** SQLite (Drift ORM)
- **State Management:** Provider
- **Authentication:** Firebase Auth + Google Sign-In
- **UI:** Material Design 3
- **Fonts:** Google Fonts (Poppins)

---

## 📄 License

This project is licensed under the MIT License.

---

## 👨‍💻 Developer

Made with ❤️ for Tractor Drivers of India 🇮🇳

---

## 📞 Contact / संपर्क

For issues, suggestions, or feedback:
- 📧 Create an issue on GitHub
- 💬 Send your feedback

---

## 🙏 Support

अगर यह app आपके काम आया तो:
- ⭐ Star दें GitHub पर
- 📤 Share करें दूसरे ट्रैक्टर चालकों के साथ
- 💬 Feedback दें

---

**Version History:**
- **v1.1.0** (25 Nov 2024) - UI improvements, Hindi localization, safer delete
- **v1.0.0** (24 Nov 2024) - Initial release

---

Made in India 🇮🇳 | हिंदी में बनाया गया 🚜
