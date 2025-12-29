-- CreateTable
CREATE TABLE "Session_UK" (
    "id" TEXT NOT NULL,
    "shop" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "isOnline" BOOLEAN NOT NULL DEFAULT false,
    "scope" TEXT,
    "expires" TIMESTAMP(3),
    "accessToken" TEXT NOT NULL,
    "userId" BIGINT,
    "firstName" TEXT,
    "lastName" TEXT,
    "email" TEXT,
    "accountOwner" BOOLEAN NOT NULL DEFAULT false,
    "locale" TEXT,
    "collaborator" BOOLEAN DEFAULT false,
    "emailVerified" BOOLEAN DEFAULT false,

    CONSTRAINT "Session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ingramCredential_UK" (
    "shopDomain" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "clientSecret" TEXT NOT NULL,
    "customerNumber" TEXT NOT NULL,
    "countryCode" TEXT NOT NULL DEFAULT 'US',
    "contactEmail" TEXT,
    "senderId" TEXT,
    "billToAddressId" TEXT,
    "shipToAddressId" TEXT,
    "sandbox" BOOLEAN NOT NULL DEFAULT true,
    "accessToken" TEXT,
    "accessTokenExpiresAt" TIMESTAMP(3),
    "lastValidatedAt" TIMESTAMP(3),
    "lastValidationStatus" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ingramCredential_UK_pkey" PRIMARY KEY ("shopDomain")
);

-- CreateTable
CREATE TABLE "CarrierConfiguration_UK" (
    "id" TEXT NOT NULL,
    "shopDomain" TEXT NOT NULL,
    "carrierCode" TEXT NOT NULL,
    "carrierName" TEXT NOT NULL,
    "carrierMode" TEXT NOT NULL,
    "displayName" TEXT,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CarrierConfiguration_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RateRequestLog_UK" (
    "id" TEXT NOT NULL,
    "shopDomain" TEXT NOT NULL,
    "correlationId" TEXT NOT NULL,
    "requestType" TEXT NOT NULL,
    "cartItemCount" INTEGER NOT NULL,
    "cartSkus" TEXT NOT NULL,
    "ingramPartNums" TEXT,
    "shipToCity" TEXT,
    "shipToState" TEXT,
    "shipToZip" TEXT,
    "shipToCountry" TEXT,
    "status" TEXT NOT NULL,
    "distributionCount" INTEGER,
    "ratesReturned" INTEGER,
    "ratesData" TEXT,
    "errorMessage" TEXT,
    "errorDetails" TEXT,
    "ingramRawResponse" TEXT,
    "durationMs" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RateRequestLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductMapping_UK" (
    "id" TEXT NOT NULL,
    "shopDomain" TEXT NOT NULL,
    "sku" TEXT NOT NULL,
    "ingramPartNumber" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProductMapping_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductSyncJob_UK" (
    "id" TEXT NOT NULL,
    "shopDomain" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "processed" INTEGER NOT NULL DEFAULT 0,
    "total" INTEGER NOT NULL DEFAULT 0,
    "error" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "finishedAt" TIMESTAMP(3),

    CONSTRAINT "ProductSyncJob_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FallbackRateSettings_UK" (
    "shopDomain" TEXT NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "price" DOUBLE PRECISION NOT NULL DEFAULT 999.00,
    "title" TEXT NOT NULL DEFAULT 'Shipping Unavailable',
    "description" TEXT NOT NULL DEFAULT 'Please contact support before placing this order',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FallbackRateSettings_pkey" PRIMARY KEY ("shopDomain")
);

-- CreateIndex
CREATE INDEX "CarrierConfiguration_shopDomain_idx" ON "CarrierConfiguration_UK"("shopDomain");

-- CreateIndex
CREATE UNIQUE INDEX "CarrierConfiguration_shopDomain_carrierCode_key" ON "CarrierConfiguration_UK"("shopDomain", "carrierCode");

-- CreateIndex
CREATE UNIQUE INDEX "RateRequestLog_correlationId_key" ON "RateRequestLog_UK"("correlationId");

-- CreateIndex
CREATE INDEX "RateRequestLog_shopDomain_idx" ON "RateRequestLog_UK"("shopDomain");

-- CreateIndex
CREATE INDEX "RateRequestLog_createdAt_idx" ON "RateRequestLog_UK"("createdAt");

-- CreateIndex
CREATE INDEX "RateRequestLog_status_idx" ON "RateRequestLog_UK"("status");

-- CreateIndex
CREATE INDEX "ProductMapping_shopDomain_idx" ON "ProductMapping_UK"("shopDomain");

-- CreateIndex
CREATE UNIQUE INDEX "ProductMapping_shopDomain_sku_key" ON "ProductMapping_UK"("shopDomain", "sku");

-- CreateIndex
CREATE INDEX "ProductSyncJob_shopDomain_idx" ON "ProductSyncJob_UK"("shopDomain");

-- CreateIndex
CREATE INDEX "ProductSyncJob_status_idx" ON "ProductSyncJob_UK"("status");

-- CreateIndex
CREATE INDEX "ProductSyncJob_createdAt_idx" ON "ProductSyncJob_UK"("createdAt");
