Return-Path: <io-uring+bounces-5944-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BAECBA14555
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:19:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2660E7A2941
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:19:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B07A42475DB;
	Thu, 16 Jan 2025 23:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="buEXesAO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049E1242240
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 23:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069450; cv=none; b=gdWugKzcBSMmMj4Qi5JGkiKnEVEiJUuzIX7WzRwfntVLsHmp3olUtL8t+dOcWHV92/1GA5/B10NvIZd7sK4u/dBzRPI36ogB+/PIEa384yCYmuP7TYUK1FXc2VfUzf4caBsfHLxLsdorQIoLB86Hu+lyQUWzeZBzLQ0WaUPZRFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069450; c=relaxed/simple;
	bh=Ikwnka17d1DjjYjVgpxxNA51+/AxFdFK0SnuyJspXJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZi0+rLukr4vTgpmvZHryE7DEyFYIxqMzRcX/q0BoIcSLSC6yhUIm9ur7wc8XasK9SrGUH407Y/b9iJhX5WUJ95RrS/aGNeHVVFYgmNDpb167H7MOaKOMrkHNi85DJf2TAKOZ+FF6Pb3Uf18yaduBxDUDtdOFtsEngMTpfs9duU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=buEXesAO; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21661be2c2dso28583135ad.1
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 15:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737069448; x=1737674248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ft/js0IlZV2ZfLIlKmpUh4bnB486G6Ky3HP+N18d0g=;
        b=buEXesAOu4tVvm1zlvvtO+pxWqIT5dzW4Jg1YXqE+hhW4zYFACrlbVIh/hebRkJJyn
         Jo1vuLejKWfyCzPgQvUuXx3DQPcqcNObwhbekwdo6aGh1/YR8rLVePJvjVxRcgRIWFeB
         OyFp42dpBXSQVvpP9lTpknmt9cZwVWqH/y5WrsWwfSM/Ez9enAOiOyZzMkbN1RpdL4ba
         lUavGXcrfAVT0BUPL4xWEPKLWffTTnYSceJQWHeXqFebEmCXqsCiLBpad64dH+beL3l9
         SECP7vpxFIS8U5aS/ivPWJCcfW9xPr9DNzDkupbpdSuPm2cHSanIzz3jrxtigNKQvtXw
         MQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737069448; x=1737674248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ft/js0IlZV2ZfLIlKmpUh4bnB486G6Ky3HP+N18d0g=;
        b=rO4PJqjUtVzPnsNw7fRHWWv5n4R2BkCWOOFaUZh8kvWa7yfT7VAlYAVfSWFms+6hGV
         EV+hk1x6sBO7ZgGURRPTBRROuNYvstHeEtzkK7OfczH7zzCnavddWrHmd01JmLylnmk5
         +JTBfNT+rxl4nirBqb7M0DghG386pbdFrA/pLtpEFEJKnv+LueYr1z2cmMa3jE/hBOB9
         2LpbyxmPHXZwi0fIuIjbzUBe5FYWS7bJaJWkNaOQE3sWC17QpM8dG3Iyu2iM4aKjwp7c
         +F9tnRpCM4ZZ91/fi7fiEZyZD/nRSyvO/Ib6MMd1aH7KnSciIhZfyGWyg236fANexC0T
         iYAg==
X-Gm-Message-State: AOJu0YyuqlIwxzKnxK0qSN4LIdcOsmn/NzVW7trkSEcQSEgoZzOP53eF
	cUe8OkghFuKlC0QJdwPR1aGtuhab4rudOhCO2vc3bO867rCAicO9P6MoMjSehkXH6ZB+d5XuVKL
	E
X-Gm-Gg: ASbGncvnYrBe2MyNWgS/y8oA247fZnPY1/chdQ7GY3JajsjoLGjJn0+FPnbM2IDUjXC
	wpyuICzRnqUj/UhiFRq+3xIR//kengpd95ORAGQX4dIilj9/XgywUsKYhLg6hbLeTP3bFwxfAC2
	BE22baj5XtFFkbrfJukBv+bEEWQ/kB7oLigGZIFQ/4fZwvGMYtXyhElOgfiPgnWMCCM1qxlZn1a
	rrmFgwueqt4d0m7pNGWVYlO111NfOFUoh7i7f4g
X-Google-Smtp-Source: AGHT+IHTTM5rf+VxVaR+RyHDAh6qHIQxvNvoWjQ++Qdu8aIT/2rRlbgvQ1M8p95XrUhsCEaDqDuJxg==
X-Received: by 2002:a05:6a20:7492:b0:1e1:ae4a:1d42 with SMTP id adf61e73a8af0-1eb2159cc48mr708466637.31.1737069448424;
        Thu, 16 Jan 2025 15:17:28 -0800 (PST)
Received: from localhost ([2a03:2880:ff:d::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dababc169sm555577b3a.172.2025.01.16.15.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:17:28 -0800 (PST)
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
Subject: [PATCH net-next v11 19/21] io_uring/zcrx: add copy fallback
Date: Thu, 16 Jan 2025 15:17:01 -0800
Message-ID: <20250116231704.2402455-20-dw@davidwei.uk>
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
index 6f3fbb9337db..3366f25d53bd 100644
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
@@ -446,6 +454,11 @@ static void io_zcrx_return_niov(struct net_iov *niov)
 {
 	netmem_ref netmem = net_iov_to_netmem(niov);
 
+	if (!niov->pp) {
+		/* copy fallback allocated niovs */
+		io_zcrx_return_niov_freelist(niov);
+		return;
+	}
 	page_pool_put_unrefed_netmem(niov->pp, netmem, -1, false);
 }
 
@@ -679,13 +692,93 @@ static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
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
@@ -712,18 +805,33 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
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


