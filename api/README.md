# Smart Room Energy API

This server accepts simulated or ESP32 telemetry and writes it to Firebase at
`telemetry/latest`. It only accepts Firebase-authenticated accounts whose
Realtime Database role is `admin`, or an ESP32 with the configured device key.

## Local run

1. Install Node.js 20 or newer.
2. In this `api` folder run `npm install`.
3. Copy `.env.example` to `.env`.
4. Firebase Console → Project settings → Service accounts → **Generate new
   private key**. Keep the downloaded JSON secret. Put its complete JSON on one
   line in `FIREBASE_SERVICE_ACCOUNT_JSON`.
5. Run `npm start`. Check `http://localhost:3000/health`.

Set `ESP32_DEVICE_KEY` to a long random value. Put the same value in the ESP32
sketch without committing it. This authorizes physical device posts without
giving the ESP32 a human Firebase account.

Do not commit `.env` or the private-key file.

## Deploy

Deploy this folder to any Node.js host such as Render, Railway, Cloud Run, or a
VPS. Add the same `.env` values as the host's secret environment variables.
Set `ALLOWED_ORIGIN` to `https://ssmart-room-energy.web.app`.

After receiving an HTTPS API address, rebuild Flutter with:

```powershell
flutter build web --dart-define=API_BASE_URL=https://YOUR-API-HOST
firebase.cmd deploy --only hosting
```

## ESP32 payload

The ESP32 can send the same JSON to `POST /api/telemetry` once it has an
authenticated way to obtain a Firebase ID token. For the first demo, use the
Simulator page in the Flutter app. For production hardware, create a dedicated
device identity and restrict its permissions separately from human admins.
