import 'dotenv/config';
import cors from 'cors';
import express from 'express';
import admin from 'firebase-admin';

const required = ['FIREBASE_DATABASE_URL', 'FIREBASE_SERVICE_ACCOUNT_JSON'];
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
    if (!bearer?.startsWith('Bearer ')) return response.status(401).json({ error: 'Sign in required' });
    const token = await admin.auth().verifyIdToken(bearer.substring(7));
    const role = (await admin.database().ref(`users/${token.uid}/role`).get()).val();
    if (role !== 'admin') return response.status(403).json({ error: 'Admin role required' });

    const body = request.body ?? {};
    const fields = ['voltage', 'current', 'power', 'energy', 'temperature', 'humidity'];
    const telemetry = Object.fromEntries(fields.map((key) => [key, Number(body[key])]));
    if (Object.values(telemetry).some((value) => !Number.isFinite(value))) {
      return response.status(400).json({ error: 'Invalid telemetry values' });
    }
    telemetry.motion = body.motion === true;
    telemetry.updatedAt = admin.database.ServerValue.TIMESTAMP;
    telemetry.source = 'simulator';
    await admin.database().ref('telemetry/latest').set(telemetry);
    response.json({ ok: true });
  } catch (error) {
    console.error(error);
    response.status(500).json({ error: 'Could not save telemetry' });
  }
});

app.listen(process.env.PORT || 3000, () => console.log('API is running'));
