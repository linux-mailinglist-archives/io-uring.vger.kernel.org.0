Return-Path: <io-uring+bounces-5759-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88759A067D5
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:07:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F1A6167C3A
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 22:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E9F204095;
	Wed,  8 Jan 2025 22:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="VbySEImE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B00204C13
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 22:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736374031; cv=none; b=ohs9b+Rria+MCe9kpijFOPD/5dIST7rmH4b+wlj4/6UCPx5ASz7XAS6hRBTfXYmS62ZoLbVcs4jSH+/7TbDHv+7+1Rk0R0GRmwdjkHcz9sEkUSXR7lQxMLFWHfyDtjOuVvuHyjPSGnyxYkPQYDTlLwOhVUdvtgGCxj1Z3Iber3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736374031; c=relaxed/simple;
	bh=T/WsGe1F3/KANs5Z1NhzY/rCLInIVwIgjCKI35/wAxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=az9WeYZ9JpoSMaquTBQjDL3+e9Pf0UGGPW79AvDbMx2J1J0tT/eDsCAVq5zbFbVOgs4kmiV9G8lTnkgVhrASmj/C1fvhhfccngxSQOBROmEeVSaMOV0PW1yqWT6PHQ+5DGusQmRdPxX2oXLtbSSusPdcpAM+oBpE7ZJNG2d6yW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=VbySEImE; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21a7ed0155cso3485795ad.3
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 14:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736374029; x=1736978829; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pw8qu+SEHYxdEfim8EZqTmfADlQgU2tSEEjaVQVrDsY=;
        b=VbySEImEFu8ErtMw6qdJmJizKgGkhqqky1dxUWdBeL7O+4KDUwB68UcBYX0arqAnW/
         MfaevH8jPujIVYfJyD6qBbQU3GMCiTm3qp8ZPD+/TEsTyu32THEQK17QEsw3ZFekKQHg
         CJOBbWPT0JvftsRRr8dSXzNC0seIb6F0DPpQZAMgPV+ixEPUty+D2s6mDepFNPX4vUGZ
         vuZeILCN5Gnye25e09uaw+/PvRBHCrTvtMZAild+j5DOHzqwhsdSU98mH69wFffBHtGk
         AgBQdWxT5+vb2To2IEeDAwv5meBBJ/btRzOQaneC1y35t/+7cCofxm5JGliaA9ANkh9C
         Jp5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736374029; x=1736978829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pw8qu+SEHYxdEfim8EZqTmfADlQgU2tSEEjaVQVrDsY=;
        b=cDPcAIjSGU17jmfYXxCkt3ucO30miFQUSRhbV9LUCW4pmYOZ/4917aOzuWhAzq6/H0
         aOkbfhWBQR8yly28MbVzJKkPZuui+peo9f+T7V0k4wBF5fuP1dN9T1qnqHHbNg67DSIn
         XYjq21dt+iXSWYTN51LhssWFAphz5AKDhvvsFZUIQLdQlasepC6UhFmeOABVlFcpbitT
         +1BiM39Yet2/z38u/3P99ZXTcN+VYit2cSiHfvsFO3Tayq3gLSfVhQiqH+LRJurYqP7v
         8Q6DzD1Y41EiEKpueNMVNvwJf/Iv4N4R0eQ1gZ+kEcsKCUpwNsvGQyjpD4uGgjzBTA5e
         fe3w==
X-Gm-Message-State: AOJu0YyPkkEoUArB+zbpLuuv13GLBqyDl8uC20jRR4maPoOGnluSI1PW
	Tpa6P9lmeWQQTEwxtQtYSm3EHuUkfDhJkkHNEVs/w2F06XJ0coRqeWGuxf3xgzYOS1/G5O7nqFi
	F
X-Gm-Gg: ASbGncsaYzoHaPdvURuhnJJox0GkshgGXVJd6uiY6rGgqukhM5Om/cxU2xSInenhXWS
	3qRZLUJVbpT0BHvtLAMd6Cohep1aSYaRFTxH+xw0kvwd+wfA4RragYpaSSktOoh7lHBjq2ygFg1
	ayUVr7YB67OWtXqZIbYGOpCDFZtCFhujRPAz3WNanZezzdDcf75VESfOc4yRbFBxWBEQlsuVI8S
	uhvEtXOptFaEWIKGuMZ17tk7nYAbcyfK3Y3feSU
X-Google-Smtp-Source: AGHT+IFxIU0l/blYAReuxBp8Mpq8O4nWukgSD1le7XaZ4bZ2SYdj9HeG5dxmtA5txwPn910KNsQvTA==
X-Received: by 2002:a17:903:2287:b0:212:67a5:ab2d with SMTP id d9443c01a7336-21a83fc9918mr69291195ad.44.1736374029332;
        Wed, 08 Jan 2025 14:07:09 -0800 (PST)
Received: from localhost ([2a03:2880:ff:7::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc962dc0sm333958605ad.32.2025.01.08.14.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 14:07:08 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v10 05/22] net: page pool: export page_pool_set_dma_addr_netmem()
Date: Wed,  8 Jan 2025 14:06:26 -0800
Message-ID: <20250108220644.3528845-6-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250108220644.3528845-1-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Export page_pool_set_dma_addr_netmem() in page_pool/helpers.h. This is
needed by memory provider implementations that are outside of net/ to be
able to set the dma addrs on net_iovs during alloc/free.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/helpers.h | 10 ++++++++++
 net/core/page_pool.c            | 16 ++++++++++++++++
 net/core/page_pool_priv.h       | 17 -----------------
 3 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/include/net/page_pool/helpers.h b/include/net/page_pool/helpers.h
index 582a3d00cbe2..4ecd45646c77 100644
--- a/include/net/page_pool/helpers.h
+++ b/include/net/page_pool/helpers.h
@@ -492,4 +492,14 @@ static inline void page_pool_nid_changed(struct page_pool *pool, int new_nid)
 		page_pool_update_nid(pool, new_nid);
 }
 
+#if defined(CONFIG_PAGE_POOL)
+bool page_pool_set_dma_addr_netmem(netmem_ref netmem, dma_addr_t addr);
+#else
+static inline bool page_pool_set_dma_addr_netmem(netmem_ref netmem,
+						 dma_addr_t addr)
+{
+	return false;
+}
+#endif
+
 #endif /* _NET_PAGE_POOL_HELPERS_H */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9733206d6406..fc3a04823087 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -649,6 +649,22 @@ void page_pool_clear_pp_info(netmem_ref netmem)
 	netmem_set_pp(netmem, NULL);
 }
 
+bool page_pool_set_dma_addr_netmem(netmem_ref netmem, dma_addr_t addr)
+{
+	if (PAGE_POOL_32BIT_ARCH_WITH_64BIT_DMA) {
+		netmem_set_dma_addr(netmem, addr >> PAGE_SHIFT);
+
+		/* We assume page alignment to shave off bottom bits,
+		 * if this "compression" doesn't work we need to drop.
+		 */
+		return addr != (dma_addr_t)netmem_get_dma_addr(netmem)
+				       << PAGE_SHIFT;
+	}
+
+	netmem_set_dma_addr(netmem, addr);
+	return false;
+}
+
 static __always_inline void __page_pool_release_page_dma(struct page_pool *pool,
 							 netmem_ref netmem)
 {
diff --git a/net/core/page_pool_priv.h b/net/core/page_pool_priv.h
index 57439787b9c2..fda9c59ee283 100644
--- a/net/core/page_pool_priv.h
+++ b/net/core/page_pool_priv.h
@@ -13,23 +13,6 @@ int page_pool_list(struct page_pool *pool);
 void page_pool_detached(struct page_pool *pool);
 void page_pool_unlist(struct page_pool *pool);
 
-static inline bool
-page_pool_set_dma_addr_netmem(netmem_ref netmem, dma_addr_t addr)
-{
-	if (PAGE_POOL_32BIT_ARCH_WITH_64BIT_DMA) {
-		netmem_set_dma_addr(netmem, addr >> PAGE_SHIFT);
-
-		/* We assume page alignment to shave off bottom bits,
-		 * if this "compression" doesn't work we need to drop.
-		 */
-		return addr != (dma_addr_t)netmem_get_dma_addr(netmem)
-				       << PAGE_SHIFT;
-	}
-
-	netmem_set_dma_addr(netmem, addr);
-	return false;
-}
-
 static inline bool page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
 {
 	return page_pool_set_dma_addr_netmem(page_to_netmem(page), addr);
-- 
2.43.5


