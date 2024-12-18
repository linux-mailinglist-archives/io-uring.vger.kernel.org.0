Return-Path: <io-uring+bounces-5551-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 320D49F5BCD
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:41:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5103118875CA
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63C8E13D8A3;
	Wed, 18 Dec 2024 00:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="SMaVC01T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E238B13BAEE
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482293; cv=none; b=BdFnN4I6nUBKOLdmNcsphOzg0ToGuPe2GFE5qebwqBjftOT1XEqa/EX6+jwm3JMxs6k3vsg+rgetVTOGC9dBjMpJrecxo2dUFKyihaNGsvoi6XV8ffTOkOUMfySAK0I43f+NElUYxNcx9Q0NRmHkH43VlgR2Li5itCcZd++TlJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482293; c=relaxed/simple;
	bh=3FYWOzv7GI9lx7mwhuutMTOmOihGpo6sHz92R4r6kzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxcfXF03ivpdbliLRR/1rUg/2GlOGT98uCEhrD9p5ANyzvpCppMdND67EgSjGWbeFporE3PSeAn5n2WQ5mUX2dr9yR6kl41PHGbkbgpZC+ym6QTEabGG8Rk0d9jgAyxGYjsnwiJZ5+VaauAicvCq5goKei3pwM/gafVD7mtlHro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=SMaVC01T; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-728e3826211so4743354b3a.0
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482291; x=1735087091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VHQGzO085Dbg8z+SUztmKbhehQYfjKmzsCXFZJE+G38=;
        b=SMaVC01TISE3JoQWpkZqkJYEoFnnpLfZjmHua9Vb+iNL3VZwPIB0FiyLWE+o7kL8Sz
         2O1ZNkoqDBWxxFJVmdDOHrtSS5GDMwLr5ABlNo/xQJbaQkokOJQ2O1QRumH4DHIQuoLy
         dVs7s6nDl/l7hbYbqt5tYMuSTk+4WhJexLymhWD2lb95ChbpB57h5I++/Dz3KLm1maIW
         ZRvPjWkMch/XGoUXM3E5nCIHwJLJR8xniCFvxLcqRUHZMKU8KO5fwVuQasXj77C0stKT
         iopwfmt9pl4TMJKviUbLSIgHY+bRqCKjM9rMXI7xN143IVW90U85YKyzX52S0YwTvsTw
         NIjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482291; x=1735087091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VHQGzO085Dbg8z+SUztmKbhehQYfjKmzsCXFZJE+G38=;
        b=AKnxJO6Rd1JKhk8gQtA3yYFM9E5dY+JUQwheHXumjVJ3Og5yckIo1rd9DrBnuEamot
         DKT1iHOXC0OlnKEwGReCQ374VfEcYDos9uboPLS5kNxmnrEK8+JclXAbS3YGDyX/rhrY
         nRIQERIaATKixHnRj9W42k3u3L9MmbvdE9t2SKCD1cUrGr1d9Z1akW1qz5LzL/Yh6Wsr
         WP4bBhnxSR2LbI+D0dvuyHjqt6riwlJGSp8nq7w9fsXeVTa+iue8KB8Ygv8BGCVgBXM4
         TIWCbyvKX9RbBmrlg4AEV5ZveUOnNXBFF132OiLk4Mo2T4mOb9QsW1d9NZPemX1S87to
         Xvpw==
X-Gm-Message-State: AOJu0Yyu5Kvgf5B8PnqyE9LaYu4WmM2SfJK0Fjjz1YxjZ3keSGOMRbSS
	OXcE75eVamI3lRmE/OwrhlvUxPaIYzBr/xKf7HmSHQCJzQXarXjoVQgFYbsRGr6GDdKiTqCQtQR
	5
X-Gm-Gg: ASbGnct5gdLb5dC6/7OvXVmDZV9EvlSNa9s593stZx+HJilRgffecx5NofZGR67Avad
	N9YAMdW+Hn7i+EOknESYIcyOfDvFvoxlYhPqLRxtvfKfUQM9kNzsb3iKZW1JWVoC3deJDUEBeJd
	C7qQ68oe4oeHHQXImo8mmTHa4zjCPbDDCM4Qnqv8hgkBM23yM9j+WNuidU9LFRfxJ05r34MX2qe
	853k/3TT9tT2NIW8c7jvZE7kLIsiW6yPLNLQgOxcw==
X-Google-Smtp-Source: AGHT+IHyJo80ER+2cYHjOYQYCiTLHf0WPuVqPkbdGqdarTU8UyCaxQIIjztwSgcQbCsUmwCDhcsOoA==
X-Received: by 2002:a17:90a:d00b:b0:2ee:ba84:5cac with SMTP id 98e67ed59e1d1-2f2e91a9adbmr1275798a91.7.1734482291218;
        Tue, 17 Dec 2024 16:38:11 -0800 (PST)
Received: from localhost ([2a03:2880:ff:74::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f2ed62cdabsm131945a91.14.2024.12.17.16.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:38:10 -0800 (PST)
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
Subject: [PATCH net-next v9 13/20] net: page pool: export page_pool_set_dma_addr_netmem()
Date: Tue, 17 Dec 2024 16:37:39 -0800
Message-ID: <20241218003748.796939-14-dw@davidwei.uk>
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

Export page_pool_set_dma_addr_netmem() in page_pool/helpers.h. This is
needed by memory provider implementations that are outside of net/ to be
able to set the dma addrs on net_iovs during alloc/free.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/helpers.h |  5 +++++
 net/core/page_pool.c            | 16 ++++++++++++++++
 net/core/page_pool_priv.h       | 17 -----------------
 3 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/include/net/page_pool/helpers.h b/include/net/page_pool/helpers.h
index d968eebc4322..00eea5dd6f88 100644
--- a/include/net/page_pool/helpers.h
+++ b/include/net/page_pool/helpers.h
@@ -486,6 +486,7 @@ static inline void page_pool_nid_changed(struct page_pool *pool, int new_nid)
 #if defined(CONFIG_PAGE_POOL)
 void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem);
 void page_pool_clear_pp_info(netmem_ref netmem);
+bool page_pool_set_dma_addr_netmem(netmem_ref netmem, dma_addr_t addr);
 
 void page_pool_mp_return_in_cache(struct page_pool *pool, netmem_ref netmem);
 #else
@@ -493,6 +494,10 @@ static inline void page_pool_set_pp_info(struct page_pool *pool,
 					 netmem_ref netmem)
 {
 }
+static inline bool page_pool_set_dma_addr_netmem(netmem_ref netmem,
+						 dma_addr_t addr)
+{
+}
 static inline void page_pool_clear_pp_info(netmem_ref netmem)
 {
 }
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index bd7f33d02652..3d1ed8b8f79e 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -655,6 +655,22 @@ void page_pool_clear_pp_info(netmem_ref netmem)
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
index 11a45a5f3c9c..cac300c83e29 100644
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


