# Code Reusability Guide: Creating Another App

This guide shows **exactly where to change code** when creating a new app with the same functionality. These are the **app-specific** configurations that must be updated.

## 🎯 Quick Summary

When creating a new app, you need to change:
1. **Shopify App Credentials** (API keys, client IDs)
2. **App URLs** (deployment URLs, callback URLs)
3. **App Name** (package.json, config files)
4. **Database** (if using separate database)
5. **Environment Variables** (in Vercel/local .env)

---

## 📋 Detailed Change List

### 1. **Shopify Configuration Files**

#### `shopify.app.toml`
```toml
# CHANGE THESE:
client_id = "YOUR_NEW_CLIENT_ID"           # From Shopify Partner Dashboard
name = "your-new-app-name"                  # Your app name
application_url = "https://your-new-app.vercel.app"  # Your deployment URL

# CHANGE THIS:
[auth]
redirect_urls = [ "https://your-new-app.vercel.app/auth/callback" ]
```

#### `shopify.app.ingram-micro.toml` (if exists)
```toml
# CHANGE THESE:
client_id = "YOUR_NEW_CLIENT_ID"
application_url = "https://your-new-app.vercel.app"
```

---

### 2. **Environment Variables** (`.env` and Vercel)

Create a new `.env` file with:

```bash
# Shopify App Credentials (MUST CHANGE)
SHOPIFY_API_KEY=your_new_api_key
SHOPIFY_API_SECRET=your_new_api_secret
SHOPIFY_APP_URL=https://your-new-app.vercel.app

# Scopes (may need to adjust based on your needs)
SCOPES=write_shipping,read_shipping,read_products,write_products,...

# Database (CHANGE if using separate database)
DATABASE_URL="postgres://user:pass@host:port/db?pgbouncer=true"
DIRECT_URL="postgresql://user:pass@host:port/db"

# Supabase (CHANGE if using different Supabase project)
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# Optional
APP_BACKEND_TOKEN=your-secret-token
CRON_SECRET=your-cron-secret
```

**In Vercel Dashboard:**
- Go to Settings → Environment Variables
- Update all the above variables for your new app

---

### 3. **Package Configuration**

#### `package.json`
```json
{
  "name": "your-new-app-name",  // CHANGE THIS
  "author": "your-name"          // CHANGE THIS (optional)
}
```

---

### 4. **Code Files (if app name is referenced)**

#### `app/routes/app.tsx`
```typescript
// Line 12 - This reads from env, so no code change needed
// Just make sure SHOPIFY_API_KEY is set correctly
```

#### `app/shopify.server.ts`
```typescript
// Lines 11-15 - These read from env variables
// No code change needed, just update .env file
```

---

### 5. **Database Schema** (if using separate database)

#### `prisma/schema.prisma`
- **No changes needed** - Schema is reusable
- **BUT**: Run migrations on your new database:
  ```bash
  npx prisma generate
  npx prisma db push
  ```

---

### 6. **Vercel Configuration**

#### `vercel.json`
```json
{
  "crons": [
    {
      "path": "/api/cron/sync-products",
      "schedule": "0 3 * * 1"  // Can keep same or change schedule
    }
  ]
}
```
- **No changes needed** unless you want different cron schedule

---

### 7. **Extension Configuration** (if creating new extension)

#### `extensions/shipping-calculator/shopify.extension.toml`
- **No changes needed** - Extension code is reusable
- But you'll need to deploy it separately for the new app

---

## 🔄 What You DON'T Need to Change

These files are **reusable as-is**:

✅ **All service files** (`app/services/*.ts`)
- `ingram.server.ts` - Reusable
- `product-sync.server.ts` - Reusable
- `product-mapping.server.ts` - Reusable
- `fallback-rate.server.ts` - Reusable
- `rate-combiner.server.ts` - Reusable
- `supabase.server.ts` - Reusable (just change env vars)

✅ **All route files** (`app/routes/*.tsx`)
- All API endpoints - Reusable
- All UI components - Reusable

✅ **Database schema** (`prisma/schema.prisma`)
- Schema is reusable (just use different database)

✅ **Utility files** (`app/utils/*.ts`)
- All utilities - Reusable

✅ **TypeScript config** (`tsconfig.json`)
- Reusable

✅ **Vite config** (`vite.config.ts`)
- Reusable (reads from env vars)

---

## 📝 Step-by-Step Checklist for New App

### Initial Setup
- [ ] Create new Shopify app in Partner Dashboard
- [ ] Get new `SHOPIFY_API_KEY` and `SHOPIFY_API_SECRET`
- [ ] Get new `client_id` from app settings
- [ ] Set up new Vercel project (or deployment URL)
- [ ] Set up new database (or use existing)

### Configuration Changes
- [ ] Update `shopify.app.toml` with new `client_id` and `application_url`
- [ ] Update `package.json` with new app name
- [ ] Create `.env` file with all new credentials
- [ ] Set environment variables in Vercel dashboard

### Database Setup
- [ ] Run `npx prisma generate`
- [ ] Run `npx prisma db push` (or migrations)
- [ ] Verify tables are created

### Deployment
- [ ] Deploy to Vercel
- [ ] Run `shopify app deploy` to update Shopify app config
- [ ] Test OAuth flow
- [ ] Test carrier service registration

### Testing
- [ ] Install app on test shop
- [ ] Configure Ingram credentials
- [ ] Test shipping rate calculation
- [ ] Test product sync
- [ ] Verify webhooks are working

---

## 🎨 Best Practices for Code Reusability

### 1. **Use Environment Variables**
All app-specific values should be in `.env`:
- ✅ `SHOPIFY_API_KEY` (not hardcoded)
- ✅ `SHOPIFY_APP_URL` (not hardcoded)
- ✅ Database URLs (not hardcoded)

### 2. **Keep Business Logic Separate**
- Service files contain reusable business logic
- Configuration files contain app-specific settings
- This separation makes code easy to reuse

### 3. **Database Per App (Recommended)**
- Use separate database for each app instance
- Prevents data conflicts
- Easier to manage and scale

### 4. **Shared Libraries (Future)**
If creating many apps, consider:
- Creating a shared npm package for services
- Using monorepo structure
- Sharing database schema via package

---

## 🔍 Finding App-Specific Values

### Where to find Shopify credentials:
1. Go to [Shopify Partner Dashboard](https://partners.shopify.com)
2. Select your app
3. Go to "App setup" tab
4. Find:
   - **Client ID** → Use in `shopify.app.toml`
   - **API key** → Use in `SHOPIFY_API_KEY`
   - **API secret** → Use in `SHOPIFY_API_SECRET`

### Where to find deployment URL:
- Vercel: Check your project's deployment URL
- Or set custom domain in Vercel settings

---

## ⚠️ Common Mistakes to Avoid

1. **Forgetting to update `shopify.app.toml`**
   - OAuth will fail if client_id doesn't match

2. **Using same database for multiple apps**
   - Sessions will conflict
   - Use separate database per app

3. **Not updating Vercel environment variables**
   - App will use old credentials
   - Always update in Vercel dashboard

4. **Forgetting to run `shopify app deploy`**
   - Shopify won't know about URL changes
   - Run after every URL/scope change

---

## 📚 Summary

**Files to Change:**
1. `shopify.app.toml` - Client ID, app name, URLs
2. `package.json` - App name
3. `.env` - All credentials and URLs
4. Vercel environment variables - Same as .env

**Files NOT to Change:**
- All service files (`app/services/*`)
- All route files (`app/routes/*`)
- Database schema (`prisma/schema.prisma`)
- Utility files (`app/utils/*`)
- Config files (`tsconfig.json`, `vite.config.ts`)

**Total files to modify: ~3-4 files**
**Total code changes: ~10-15 lines**

The codebase is designed to be highly reusable! 🎉

