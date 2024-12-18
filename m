Return-Path: <io-uring+bounces-5546-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F5E9F5BC1
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:40:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02F431889860
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FEFC70831;
	Wed, 18 Dec 2024 00:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="wlYzYFlw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8ED06026A
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482287; cv=none; b=e6fXSRsZ4uCP5Ww9FJvISlGGYs6BqUk0ROEaw8cN36lf13xVTAFr5K0BQABxPFNVZ9nsWXQzZog/uTgvJRku6NqpAMiNzkP6h1ZGWmVWMAILvCke2VYFMWEdOroZ5EUt/Fb1z6nJF6rCOAeEVgITTSIRu1Yy+XhioIt6D2gSbe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482287; c=relaxed/simple;
	bh=uPSiaeh6DtHd5VRMdyGgXwFwrt2HnMjLjuGJrg5Ylco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfCQOEa9EYwY8zu5lrWJAq3oXY4WUR9S5U+srjZe4QppiFlHm732G5uQKHoZAkCopu+94wQMzMWWB6SEA/SRvxQRQDet+/L56EZA3lA2suj5d5r2wP7WfrgFvSV5PJDe35KMHL1dxnyeFOZURLJ9L6scu2xW+bDYM+OjM++ZvEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=wlYzYFlw; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-216401de828so47565045ad.3
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482285; x=1735087085; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GQ0gxue1w/Dl+jX0cfhVJPh/MBAFHEZUjUzY9/gknQk=;
        b=wlYzYFlwzC7B7N1t+bkxXGKgez2Qq78Q5HHqq/NGw35f0VrYNJPz8WiSa7LrfWkbBU
         dhGWORqE1kUYn7wb7yc2eiJ3PVnvF3mPTqV/BEdNBEY4qrGiWGLmsgOcLgzqdT7iGQcb
         dvUp8+mnkuvh1xUQ8PL4zYPg2CzW4yZSZpw4pJLRVN6vijHhgc3P/haRJkoeP+hEiQzQ
         AAMitippFXNiX8gKaePp/qrMqZIRKc3ZCtcetSbHvIOPIsWcSg/S7MxPXiPlEIt2DLjU
         H5uTavLV7sap3SUugaEoKRRh3ijjt0+HvQvG5Q7lzYcIatSxYzsKDn1EqNG/KrqDsPNM
         cZ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482285; x=1735087085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GQ0gxue1w/Dl+jX0cfhVJPh/MBAFHEZUjUzY9/gknQk=;
        b=c9C/DOGi+YLW7zu5ierLp6UUJMN43G+MBEHSV+JJAC8sRNtmP1jteGT32J3+YvQ3A8
         PtRANtwGIgTb8Qx2coWdPlZxrMFB7Tx58pD4HZeu2ugtzxMa7CGvXv2YgXyobOf4P6uS
         6zpbUGrNISwDS2BsRqMDB2oFySDxxz5Q/TNF9J4VySfMJW2HpQhD7WxTmKmD/vNkrqZz
         m7FQNY8NGHTZNK4NJf6pNRS51ipl5+MoJOs+iMOY5VnhxFWmbeiQIc20EPFEq2UZ2cJR
         MFP5gsUrkH3tHsncMsbeHomHHvlNPCQG2ClMLUlpu8q0ZRjv3FBQFp/MjZKPMPeDRK08
         jOXg==
X-Gm-Message-State: AOJu0Yxr7LLi8FYN4OgVH9Fxw2UpfomuE6uSmMEXvcSbeiT5l9BLsBlo
	axU7DpjtzGZ5NCQQpVcWiMgqX2zbZq9PrHJMjG/n4BvEr3dj449aH5JASypKX2FuZ9LgWOx2jGO
	A
X-Gm-Gg: ASbGnct7wzA0MS6CyXQvRYmu2QB3/iJWNp19DDrkGQuVJKeOIcUYjPE9RbS8h1ImEle
	JNHysAtlX+dgmc2WZg0LpRvkZw/6eL6WmH9Xj5oO4wsoBkNd9fknyST8u4HfQf+y8oBSt9wnn0r
	hSTgdzDWuYapjz2uutWI1u+34izsFa+o+4PlcrXcZyPhnuOgU36n153PQ86TRBhW+AOVaq7p0NU
	TJD0euKyVd1rGC8CAY4tfU1wRNdYBwUvFjHCv+hpw==
X-Google-Smtp-Source: AGHT+IF263LqxEpg2kL0USvJQC0hWKInn1I93+k0bqBXdHYZk1LYQyelqDgccvsESwAXqztJWYW15A==
X-Received: by 2002:a17:902:e5ca:b0:216:3436:b87e with SMTP id d9443c01a7336-218d72437ccmr11411065ad.44.1734482285091;
        Tue, 17 Dec 2024 16:38:05 -0800 (PST)
Received: from localhost ([2a03:2880:ff:20::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-218a1e5011bsm65265705ad.152.2024.12.17.16.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:38:04 -0800 (PST)
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
Subject: [PATCH net-next v9 08/20] net: expose page_pool_{set,clear}_pp_info
Date: Tue, 17 Dec 2024 16:37:34 -0800
Message-ID: <20241218003748.796939-9-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241218003748.796939-1-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Memory providers need to set page pool to its net_iovs on allocation, so
expose page_pool_{set,clear}_pp_info to providers outside net/.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/helpers.h | 13 +++++++++++++
 net/core/page_pool_priv.h       |  9 ---------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/net/page_pool/helpers.h b/include/net/page_pool/helpers.h
index e555921e5233..872947179bae 100644
--- a/include/net/page_pool/helpers.h
+++ b/include/net/page_pool/helpers.h
@@ -483,4 +483,17 @@ static inline void page_pool_nid_changed(struct page_pool *pool, int new_nid)
 		page_pool_update_nid(pool, new_nid);
 }
 
+#if defined(CONFIG_PAGE_POOL)
+void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem);
+void page_pool_clear_pp_info(netmem_ref netmem);
+#else
+static inline void page_pool_set_pp_info(struct page_pool *pool,
+					 netmem_ref netmem)
+{
+}
+static inline void page_pool_clear_pp_info(netmem_ref netmem)
+{
+}
+#endif
+
 #endif /* _NET_PAGE_POOL_HELPERS_H */
diff --git a/net/core/page_pool_priv.h b/net/core/page_pool_priv.h
index 57439787b9c2..11a45a5f3c9c 100644
--- a/net/core/page_pool_priv.h
+++ b/net/core/page_pool_priv.h
@@ -36,18 +36,9 @@ static inline bool page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
 }
 
 #if defined(CONFIG_PAGE_POOL)
-void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem);
-void page_pool_clear_pp_info(netmem_ref netmem);
 int page_pool_check_memory_provider(struct net_device *dev,
 				    struct netdev_rx_queue *rxq);
 #else
-static inline void page_pool_set_pp_info(struct page_pool *pool,
-					 netmem_ref netmem)
-{
-}
-static inline void page_pool_clear_pp_info(netmem_ref netmem)
-{
-}
 static inline int page_pool_check_memory_provider(struct net_device *dev,
 						  struct netdev_rx_queue *rxq)
 {
-- 
2.43.5


