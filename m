Return-Path: <io-uring+bounces-5986-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AF13AA153D9
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 17:12:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01F287A2CBA
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 16:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AB621A073F;
	Fri, 17 Jan 2025 16:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kv3IhusW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8CA19F436;
	Fri, 17 Jan 2025 16:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737130290; cv=none; b=a727DQBIWoM0VxOKE9dGQ2tSYVJVWZFAwG7vBpkaLCmw7SvtpVFEXEOiK5zsxKXvbuKxzjyAK4azY0EA8+KRgdkzwGB3Hvs+hBptP+fMlgF/TN0aEhvL3UU+5fEXhokTw+JbVELIbnZG2R7GzflOSIVlCjAIwIgsYdg/GNiKvpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737130290; c=relaxed/simple;
	bh=6uXEcPOcqpwPfawayspj5a99uUO8shn7CTEhuQt498k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwxEwCt0xt1mZ1s+ap2Eu5kXPVKJyhfCO76EOGapyi+CQfrQkZk/aN69rsKOmqkkOZQyZwTJGEtJi21/3snaxBXzfRVPaFFkFFfzqChfnzh7pbGXH8i9WGYsumJuHtp9ImBc7kUuuUCIe80UqZXqHad64fkE4ywapDR1SfMqa0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kv3IhusW; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aaeecbb7309so434035466b.0;
        Fri, 17 Jan 2025 08:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737130286; x=1737735086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fiOiGdhB+hlFZy1AjRpHYrKJqzKugrGCkwNAf4xmJas=;
        b=Kv3IhusW3ievo1heCqdL4Hxcj+W8kGYB64kuaSlnd6BzAqL+/VTvJTp6VLHajnrmMz
         vxjMa0b2Crx6IFZ8Qc9i50z38JPu2lxAqlVwUq6os/p70UjEwaDjejOuXKimhdTUpWYx
         OaYO5kOs1NdZvZzBJJsw0tgGvpm5iopOb7gUsaHOOGvccr1yj0zoXqDRbHB2lMgYEPJv
         U958Bmz1gJrOB9LYCzi5aplvx37oWgwlSAwhxs30y7B64jklE9YKW90hiMrze++ybjWB
         bVXgV7Ktak1cC5FmKNiqrT/sEfu4lFbZMRJjf6/C1kZqrVN76t8K+XIu3Dcp6svWY/o3
         VO5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737130286; x=1737735086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fiOiGdhB+hlFZy1AjRpHYrKJqzKugrGCkwNAf4xmJas=;
        b=j1y4s/0w5UmtjvLJRsRqRuS5tBBufrfSPzKhH+8YXhi7Aa7qo/arIBhxBjbyR+vqAG
         3DV1sIuseERxZLeECLH2jbxYoixjr5TN1HvdIQrYoO1GPYWGwI6av8tR6f4Ne+5o58J4
         HCxR4V5+0n2uAkb6rdXg/yHC5RBHPUIqUpKOs15nZHdZLV/YdyT5IMZFM0kjXoMIGDxV
         V438AxKnBlKYdsRJNs3hRK2pK8eWpgiGS3mFwPgcRlTjEZPxegHT+6P2FX8JKyb8wlyk
         QhEseZB7Z1tRSPXstJcOEKJon9vHYOEZ11pXZPsxETHG4d/WKI3RTCamJroA5lKWt3YW
         JWyg==
X-Forwarded-Encrypted: i=1; AJvYcCXaBUTbe3SmHcL760Hk3JH6CeOwoa393YW9lnGcGMk0a7AJRrOdpcwfSSXaoP1tT0w+dz67UHs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb9JQ5ZWh2zoQFobhqnRO3dNzePzG1EqeQkmK5ymP0pXkvatJQ
	fg9oeqxUkatoaWBWKLbmu8cXTLofv4/KPiFb/JqwqOSLB8+FF4QEmi/cZw==
X-Gm-Gg: ASbGncv1PbamY1U6vo7N36CWMcOGVey00RXLutxOe97cRJKMvoc80Nxj02IbcXjCoCc
	HBtWihxEp4f0xR2itNlOrVKqHzyvfdnh20aecuu219zBLQP37sPvDK3d8zr+Ixfa/gG1R3zsGJS
	j87ShiWBWLBXZz0bfS5LGYCkkp/9qaWujC+G2IdAWVXzGvvDlgs4ldG3VQtTXRi5FcOLXMPJ+r1
	CCEpIIoH5cMmDuNzNv+wenYYdKeSQRb9zeIsadr
X-Google-Smtp-Source: AGHT+IF0npe3FHCddSILmUrjvtMDQxHQIYEw/5sx671zsUYbbUQJYcuc7cpfvyKQg2zisQYADzRLHw==
X-Received: by 2002:a17:907:1c0a:b0:aa6:abb2:be12 with SMTP id a640c23a62f3a-ab38b42ae4bmr289013466b.37.1737130286267;
        Fri, 17 Jan 2025 08:11:26 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:56de])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f23007sm193716366b.96.2025.01.17.08.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 08:11:25 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	David Wei <dw@davidwei.uk>
Subject: [PATCH net-next v12 09/10] net: page_pool: add memory provider helpers
Date: Fri, 17 Jan 2025 16:11:47 +0000
Message-ID: <3899b385936a398bf562e184db3e296566f7fcf8.1737129699.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1737129699.git.asml.silence@gmail.com>
References: <cover.1737129699.git.asml.silence@gmail.com>
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

Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
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
index 199564b03533..c003b9263bd3 100644
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
2.47.1


