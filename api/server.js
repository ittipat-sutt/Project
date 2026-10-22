import 'dotenv/config';
import cors from 'cors';
import express from 'express';
import admin from 'firebase-admin';

const required = [
  'FIREBASE_DATABASE_URL',
  'FIREBASE_SERVICE_ACCOUNT_JSON',
  'ESP32_DEVICE_KEY',
];
for (const name of required) {
  if (!process.env[name]) throw new Error(`Missing environment variable: ${name}`);
}

admin.initializeApp({
  credential: admin.credential.cert(JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_JSON)),
  databaseURL: process.env.FIREBASE_DATABASE_URL,
});

const app = express();
app.use(cors({ origin: process.env.ALLOWED_ORIGIN?.split(',') ?? true }));
app.use(express.json({ limit: '16kb' }));

app.get('/health', (_, response) => response.json({ ok: true }));

app.post('/api/telemetry', async (request, response) => {
  try {
    const bearer = request.headers.authorization;
    const isDevice = request.headers['x-device-key'] === process.env.ESP32_DEVICE_KEY;
    if (!isDevice) {
      if (!bearer?.startsWith('Bearer ')) {
        return response.status(401).json({ error: 'Sign in required' });
      }
      const token = await admin.auth().verifyIdToken(bearer.substring(7));
      const role = (await admin.database().ref(`users/${token.uid}/role`).get()).val();
      if (role !== 'admin') return response.status(403).json({ error: 'Admin role required' });
    }

    const body = request.body ?? {};
    const fields = ['voltage', 'current', 'power', 'energy', 'temperature', 'humidity'];
    const telemetry = {};
    for (const key of fields) {
      if (body[key] == null) continue;
      const value = Number(body[key]);
      if (!Number.isFinite(value)) {
        return response.status(400).json({ error: `Invalid ${key}` });
      }
      telemetry[key] = value;
    }
    if (body.motion != null) telemetry.motion = body.motion === true;
    if (Object.keys(telemetry).length === 0) {
      return response.status(400).json({ error: 'No telemetry values supplied' });
    }
    telemetry.updatedAt = admin.database.ServerValue.TIMESTAMP;
    telemetry.source = isDevice ? 'esp32-dht11' : 'simulator';
    await admin.database().ref('telemetry/latest').update(telemetry);
    response.json({ ok: true });
  } catch (error) {
    console.error(error);
    response.status(500).json({ error: 'Could not save telemetry' });
  }
});

app.listen(process.env.PORT || 3000, () => console.log('API is running'));
