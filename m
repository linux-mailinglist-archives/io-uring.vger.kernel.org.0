Return-Path: <io-uring+bounces-5934-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B7C4A14546
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:18:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAD1816B9C9
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D13E244F93;
	Thu, 16 Jan 2025 23:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="zlOixvM1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1A32442E3
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 23:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069441; cv=none; b=DOQs4VUalfDbTrg9TRia1R1Mq0Bo7vmq8adMEgTzgxhKteYhrHJeWRzspSDmQrGDwtvAONPZTufOIDXmTVPkKuddUBzLwEL74leW1zatxL6wavIcqdPjw31YC1deFOM60cuOQo74YcZjXYtmtxJi4WP+8ZH+efKuRGEwB8N4vJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069441; c=relaxed/simple;
	bh=Wu2YRL7RxGBa3+VVAsLlSidmaKFoJfO1MRmnPiP9er0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5QTT/Ld+4OFGOZauzJM2BEukbeF6ZhuF+4eMEdX0bbg6y4LcWrsT098bu7kWhH+OYylOGnqw9wccrNYEqrqRpk9BA5d0HPOrSLww3JtlKvVMATWAG3IAIJ7QhWBMxV2TIpusCGzhr8rYnkPD1DpEDGAknLumgQqDidwmmwSLTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=zlOixvM1; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2166022c5caso25446715ad.2
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 15:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737069439; x=1737674239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Be6ZuIxyPYoB8SUKHgFZ6AvvdZELR/KF5QFQIGoyyg=;
        b=zlOixvM1pO1OvomSXVs87T2Y8l4g7F2wxU2ukXBMNgomPNcAoQ2YMW2Zo0oeGC7Yl8
         /+NKcXm7BCfVOEF0mrkAzHxmBJkHgvELQqwRNSI+DkyCcPyVYPNdKXJ3M9/trktLBw2r
         SfqUFxtA2B73EfMi2qUhluiB9kRCyswnb3Kss2sETWxnLoIw7V1i+auY87JYAP2IYEvX
         a1hcnFwJPtaF1twfjQjhNbXX3yGkyCxd8VwadR8STNmZkVVbd3/euuXZguNpq4BTvqB4
         hpyvbObmo+hhRPc+XRXW19VjHndAYZoiskSVKbQWbXHlV6GlKjaND9hYCiBpm8kekgVX
         mThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737069439; x=1737674239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Be6ZuIxyPYoB8SUKHgFZ6AvvdZELR/KF5QFQIGoyyg=;
        b=icYA0l3Z/WBqZh8eJBoAjpzQDzBsDvt3UtTDyMaCBa1X0rsCgAyBFUY4/kQm6bB3uW
         F9XYTWuW5UsKA1b1FPTwOhR7K2GveEs8oMxD5W+yN4F5HCBhZi447leaV1Nvs5CwFdtk
         dRCkiBwUayCO8cJArysuCjjffpt6RxlP0sysSXMow/1db4j25EQwgvqZzXPufnTzavIr
         BVP163CcE+TV3nmt4iKzbw/EGISYsgmz6preyWOL6yJbF8wONOzMHvpzRmUHi3NCjO4g
         cf00zdRPvzJzEEupG4o1vaD34dKPxlH5QQbkluLBtobCRz/Ie39Kd/exZ4DS+NaqxF05
         906A==
X-Gm-Message-State: AOJu0YxfLEGgQwShyI5lTvkS9j52Jzl1ihMrnTSIt5YSAvgM5xhjj/Z8
	HXbLvObrkpYzPUgTNDnq8B1NeRlxRy/+/kKsd83GiOayl2It91eUuFMjtFiuFHTokS0uW4j556c
	L
X-Gm-Gg: ASbGncuXqdtggdzUmUzzMgURuHBGv2XU6mdJ9c6d29Nonwfjpu2i60RwyrhiEJ3g3G8
	jC3kQAAnm/qnlCuNnQQypY0v22m+qCAnq8Arpkc8h+PbiSGPB44OPJWqBGwiB8zrmhmEzznO/xW
	8c/nik2rgJ1sPuNu55jYBd5wqAJ0Wm1KInTpKQfT209FR54LcgTtiDdKx207kSYVNvEbS+5SwO5
	VjWK9PkicWj+4KLjg1/ULAKVi6NxX4UlDs/wXro
X-Google-Smtp-Source: AGHT+IG4BvB515N3766JxYciwfUXHMvi1fRLt7Mh9m0zlJqgYdA6QEwqcr09WZiN+pXYGb6wkv8pFg==
X-Received: by 2002:a17:903:234b:b0:216:7aab:71f0 with SMTP id d9443c01a7336-21c355c0810mr9551615ad.38.1737069438863;
        Thu, 16 Jan 2025 15:17:18 -0800 (PST)
Received: from localhost ([2a03:2880:ff:6::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2ceb76dfsm5199635ad.61.2025.01.16.15.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:17:18 -0800 (PST)
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
Subject: [PATCH net-next v11 09/21] net: page_pool: add memory provider helpers
Date: Thu, 16 Jan 2025 15:16:51 -0800
Message-ID: <20250116231704.2402455-10-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250116231704.2402455-1-dw@davidwei.uk>
References: <20250116231704.2402455-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add helpers for memory providers to interact with page pools.
net_mp_niov_{set,clear}_page_pool() serve to [dis]associate a net_iov
with a page pool. If used, the memory provider is responsible to match
"set" calls with "clear" once a net_iov is not going to be used by a page
pool anymore, changing a page pool, etc.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/memory_provider.h | 19 +++++++++++++++++
 net/core/page_pool.c                    | 28 +++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_pool/memory_provider.h
index 36469a7e649f..4f0ffb8f6a0a 100644
--- a/include/net/page_pool/memory_provider.h
+++ b/include/net/page_pool/memory_provider.h
@@ -18,4 +18,23 @@ struct memory_provider_ops {
 	void (*uninstall)(void *mp_priv, struct netdev_rx_queue *rxq);
 };
 
+bool net_mp_niov_set_dma_addr(struct net_iov *niov, dma_addr_t addr);
+void net_mp_niov_set_page_pool(struct page_pool *pool, struct net_iov *niov);
+void net_mp_niov_clear_page_pool(struct net_iov *niov);
+
+/**
+  * net_mp_netmem_place_in_cache() - give a netmem to a page pool
+  * @pool:      the page pool to place the netmem into
+  * @netmem:    netmem to give
+  *
+  * Push an accounted netmem into the page pool's allocation cache. The caller
+  * must ensure that there is space in the cache. It should only be called off
+  * the mp_ops->alloc_netmems() path.
+  */
+static inline void net_mp_netmem_place_in_cache(struct page_pool *pool,
+						netmem_ref netmem)
+{
+	pool->alloc.cache[pool->alloc.count++] = netmem;
+}
+
 #endif
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 24e2e2efb1eb..6a9eb2da5f6d 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -1196,3 +1196,31 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
 	}
 }
 EXPORT_SYMBOL(page_pool_update_nid);
+
+bool net_mp_niov_set_dma_addr(struct net_iov *niov, dma_addr_t addr)
+{
+	return page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov), addr);
+}
+
+/* Associate a niov with a page pool. Should follow with a matching
+ * net_mp_niov_clear_page_pool()
+ */
+void net_mp_niov_set_page_pool(struct page_pool *pool, struct net_iov *niov)
+{
+	netmem_ref netmem = net_iov_to_netmem(niov);
+
+	page_pool_set_pp_info(pool, netmem);
+
+	pool->pages_state_hold_cnt++;
+	trace_page_pool_state_hold(pool, netmem, pool->pages_state_hold_cnt);
+}
+
+/* Disassociate a niov from a page pool. Should only be used in the
+ * ->release_netmem() path.
+ */
+void net_mp_niov_clear_page_pool(struct net_iov *niov)
+{
+	netmem_ref netmem = net_iov_to_netmem(niov);
+
+	page_pool_clear_pp_info(netmem);
+}
-- 
2.43.5


