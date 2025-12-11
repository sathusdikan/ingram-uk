const fs = require('fs');
const { Client } = require('pg');

function readEnv(path) {
  const text = fs.readFileSync(path, 'utf8');
  const lines = text.split(/\r?\n/);
  const env = {};
  for (const line of lines) {
    const m = line.match(/^\s*([A-Za-z0-9_]+)=(?:"([^"]*)"|'([^']*)'|(.*))\s*$/);
    if (m) {
      env[m[1]] = m[2] ?? m[3] ?? m[4] ?? '';
    }
  }
  return env;
}

(async function(){
  try {
    const env = readEnv('./.env');
    const url = env.DATABASE_URL;
    if (!url) {
      console.error('DATABASE_URL not found in .env');
      process.exit(2);
    }

    const client = new Client({ connectionString: url });
    await client.connect();

    const res = await client.query(
      `select tablename from pg_catalog.pg_tables where tablename = $1 or tablename = lower($1)`,
      ['ingramCredential_UK']
    );

    if (res.rows.length === 0) {
      console.log('Table not found: ingramCredential_UK');
    } else {
      console.log('Found tables:');
      for (const r of res.rows) console.log(' -', r.tablename);

      // show a couple of rows if exists
      try {
        const sample = await client.query('select shopDomain, clientId from "ingramCredential_UK" limit 5');
        console.log('Sample rows:', sample.rows);
      } catch (e) {
        console.error('Could not query sample rows (maybe permissions or column mismatch):', e.message);
      }
    }

    await client.end();
  } catch (err) {
    console.error('Error:', err.message || err);
    process.exit(1);
  }
})();
