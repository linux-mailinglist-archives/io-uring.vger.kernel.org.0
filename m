Return-Path: <io-uring+bounces-6464-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 640F1A369A2
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 01:15:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69F8A188FC91
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 00:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF02024B29;
	Sat, 15 Feb 2025 00:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="XV08BNqg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3879A151998
	for <io-uring@vger.kernel.org>; Sat, 15 Feb 2025 00:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739578212; cv=none; b=JPWOw9YzcGi0iH9fz6ew5IEIOvjWkhzZkjU5BXtXAxdcT+2BvNGbDPCM5HgP3EWfNwXG7OhIjc/bjQRq4TFMkHbIiGNbz/vEcqNmiOY/KJVkf11hfrZIzuklcQIyvCr9iPtaA66uU76pR33xztguiGYG6txKeBSVBxnw7bX8zSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739578212; c=relaxed/simple;
	bh=waZElP+hnGci0XgG5ol4AhH/YpGYtuPpjvD6W8bnmQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7Jq03a4uC9hCmCZETuRauHxHb2uFEULuOsKaXkIYi/yecT5/xXRM1mxWC1WagB3GbJKDbnv8CDtBvKEZ9UbfXXtzROttFKjyg8zECYlpbtm+wVOTyaM2d6BKa94ccHcm/vYo1j7anuoOP0SPODqvAgd+kxIqiXJ6KaaHs5KSNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=XV08BNqg; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-21f7f1e1194so66266525ad.2
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 16:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739578210; x=1740183010; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FmNIyCXXoWBh40mpSPtcuAkEk/iQTmfVKkUBNv+QvTM=;
        b=XV08BNqgAmqqQQTAO2EC9tMpEjcuQVi1emyTROZeUuxdKtdJ+n+tPM+MRI8KvkYjER
         IHMj33JNAItNHoIRPw7ZCyVDyr+lXEzAV2L8NV/p08JR0LjmI2UwkRWHUiB5OeOmcEkL
         TAjLeoYwsQNRO87obRphraHw9XKxMOzGwIEhmK67S2EcvYymoOpHs9qad49qcFZKEbFt
         c1ryKhSeFsb9IPWzeO3CbaFOGk/ple5CsZuEcsCQDfjBK3eLOQ5B0cLbz+Xwhbnd/6eZ
         VEZoK5NxlhTSSPtFHsGEB+ThptdSSe32kz3m3tXzQMyJ4qc2DpzGDy9IAvOrUFEfYnQ0
         L8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739578210; x=1740183010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FmNIyCXXoWBh40mpSPtcuAkEk/iQTmfVKkUBNv+QvTM=;
        b=JQx/S6PqYzZwX4pp4oBadFve9UUk6KK1MVqg7grfFozFnsTO4kbZlLAiw+jFgOGRwE
         hxbZGcGNgvxJ1/XXd29XsXDykaXMjWMVQqv5lvKtyjCVMywj/ui+OlA6jh3d/7xBDL1B
         JxMKoJDV4QnLY8Ii7KQo1eXK2E0R9lU/5yH7eQnHfd+C8b7Er4sbLnwdx8ffc8MWbPlk
         rEKOFpYnvcyP0bOEVzMv6WyN/YYlPagX0NoOBEGlrU+rcpi8iYiGA3VFgBoSzHh3B0iL
         XYFJT6/iewmPyBmw/abF1DznfiEEfvb5XZATV54ULXrXpA0fKp9erbfQX7K9T+Jpksbl
         y5UQ==
X-Gm-Message-State: AOJu0YxJ31Cb71zb3Oj82qcmCbIE/+rAzrzX8fcv+FRAkzqQG6KVj0gD
	G5gKZihnqdvXjqknAGq4UDZaUX8Dyytu8ufrEq2EzztjHEATEn4t54lBCYJTmXyGnoe1Kb3zmam
	E
X-Gm-Gg: ASbGncvm1tZYul1psrAPdOFiHMsPM72ZMJWzIzJjt1cevE7Mxq+8tcJBszhIlFGMNHn
	MqoMAEMDVs4Hmfg+VqoRiEvRdtQiRztv9LZp7YTGPdcVn5sDU3ugMZiAlUyjIAGC7MYQbYZlxB5
	9AIdLqB4vhyqkwcwgvP4SRspm1b5QvYEpR4jOmQIs8WQrpKpiWulT5bvTMHY4nHtTz0Quy31ZHG
	ragwzJUoYiwCIsNVInHPhHMORaIJf1ZDAGM3jUzInqD/use7U11GrTYU2ll5WpsX0IayqnbH0M=
X-Google-Smtp-Source: AGHT+IEinmI6YzYKXk3Kc5KlfdAL6uHZcNBPKDAy0rcbD2dGEYI7Nt2Eoa6T6eOa2HTjIdHra2zZ2Q==
X-Received: by 2002:a05:6a00:1391:b0:72d:9cbc:730d with SMTP id d2e1a72fcca58-732617c4b97mr2151318b3a.11.1739578210384;
        Fri, 14 Feb 2025 16:10:10 -0800 (PST)
Received: from localhost ([2a03:2880:ff:d::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-732621c4762sm342097b3a.172.2025.02.14.16.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 16:10:09 -0800 (PST)
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
	Pedro Tammela <pctammela@mojatatu.com>,
	lizetao <lizetao1@huawei.com>
Subject: [PATCH v14 09/11] io_uring/zcrx: add copy fallback
Date: Fri, 14 Feb 2025 16:09:44 -0800
Message-ID: <20250215000947.789731-10-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250215000947.789731-1-dw@davidwei.uk>
References: <20250215000947.789731-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

There are scenarios in which the zerocopy path can get a kernel buffer
instead of a net_iov and needs to copy it to the user, whether it is
because of mis-steering or simply getting an skb with the linear part.
In this case, grab a net_iov, copy into it and return it to the user as
normally.

At the moment the user doesn't get any indication whether there was a
copy or not, which is left for follow up work.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 120 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 114 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 7e0cba1e0f39..026efb8dd381 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -7,6 +7,7 @@
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
+#include <linux/skbuff_ref.h>
 
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/memory_provider.h>
@@ -134,6 +135,13 @@ static void io_zcrx_get_niov_uref(struct net_iov *niov)
 	atomic_inc(io_get_user_counter(niov));
 }
 
+static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
+{
+	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+
+	return area->pages[net_iov_idx(niov)];
+}
+
 static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 				 struct io_uring_zcrx_ifq_reg *reg,
 				 struct io_uring_region_desc *rd)
@@ -448,6 +456,11 @@ static void io_zcrx_return_niov(struct net_iov *niov)
 {
 	netmem_ref netmem = net_iov_to_netmem(niov);
 
+	if (!niov->pp) {
+		/* copy fallback allocated niovs */
+		io_zcrx_return_niov_freelist(niov);
+		return;
+	}
 	page_pool_put_unrefed_netmem(niov->pp, netmem, -1, false);
 }
 
@@ -686,13 +699,93 @@ static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
 	return true;
 }
 
+static struct net_iov *io_zcrx_alloc_fallback(struct io_zcrx_area *area)
+{
+	struct net_iov *niov = NULL;
+
+	spin_lock_bh(&area->freelist_lock);
+	if (area->free_count)
+		niov = __io_zcrx_get_free_niov(area);
+	spin_unlock_bh(&area->freelist_lock);
+
+	if (niov)
+		page_pool_fragment_netmem(net_iov_to_netmem(niov), 1);
+	return niov;
+}
+
+static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
+				  void *src_base, struct page *src_page,
+				  unsigned int src_offset, size_t len)
+{
+	struct io_zcrx_area *area = ifq->area;
+	size_t copied = 0;
+	int ret = 0;
+
+	while (len) {
+		size_t copy_size = min_t(size_t, PAGE_SIZE, len);
+		const int dst_off = 0;
+		struct net_iov *niov;
+		struct page *dst_page;
+		void *dst_addr;
+
+		niov = io_zcrx_alloc_fallback(area);
+		if (!niov) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		dst_page = io_zcrx_iov_page(niov);
+		dst_addr = kmap_local_page(dst_page);
+		if (src_page)
+			src_base = kmap_local_page(src_page);
+
+		memcpy(dst_addr, src_base + src_offset, copy_size);
+
+		if (src_page)
+			kunmap_local(src_base);
+		kunmap_local(dst_addr);
+
+		if (!io_zcrx_queue_cqe(req, niov, ifq, dst_off, copy_size)) {
+			io_zcrx_return_niov(niov);
+			ret = -ENOSPC;
+			break;
+		}
+
+		io_zcrx_get_niov_uref(niov);
+		src_offset += copy_size;
+		len -= copy_size;
+		copied += copy_size;
+	}
+
+	return copied ? copied : ret;
+}
+
+static int io_zcrx_copy_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
+			     const skb_frag_t *frag, int off, int len)
+{
+	struct page *page = skb_frag_page(frag);
+	u32 p_off, p_len, t, copied = 0;
+	int ret = 0;
+
+	off += skb_frag_off(frag);
+
+	skb_frag_foreach_page(frag, off, len,
+			      page, p_off, p_len, t) {
+		ret = io_zcrx_copy_chunk(req, ifq, NULL, page, p_off, p_len);
+		if (ret < 0)
+			return copied ? copied : ret;
+		copied += ret;
+	}
+	return copied;
+}
+
 static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			     const skb_frag_t *frag, int off, int len)
 {
 	struct net_iov *niov;
 
 	if (unlikely(!skb_frag_is_net_iov(frag)))
-		return -EOPNOTSUPP;
+		return io_zcrx_copy_frag(req, ifq, frag, off, len);
 
 	niov = netmem_to_net_iov(frag->netmem);
 	if (niov->pp->mp_ops != &io_uring_pp_zc_ops ||
@@ -719,18 +812,33 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	struct io_zcrx_ifq *ifq = args->ifq;
 	struct io_kiocb *req = args->req;
 	struct sk_buff *frag_iter;
-	unsigned start, start_off;
+	unsigned start, start_off = offset;
 	int i, copy, end, off;
 	int ret = 0;
 
 	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
 		return -EAGAIN;
 
-	start = skb_headlen(skb);
-	start_off = offset;
+	if (unlikely(offset < skb_headlen(skb))) {
+		ssize_t copied;
+		size_t to_copy;
 
-	if (offset < start)
-		return -EOPNOTSUPP;
+		to_copy = min_t(size_t, skb_headlen(skb) - offset, len);
+		copied = io_zcrx_copy_chunk(req, ifq, skb->data, NULL,
+					    offset, to_copy);
+		if (copied < 0) {
+			ret = copied;
+			goto out;
+		}
+		offset += copied;
+		len -= copied;
+		if (!len)
+			goto out;
+		if (offset != skb_headlen(skb))
+			goto out;
+	}
+
+	start = skb_headlen(skb);
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		const skb_frag_t *frag;
-- 
2.43.5


