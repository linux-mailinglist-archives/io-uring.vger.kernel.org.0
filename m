Return-Path: <io-uring+bounces-67-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 146247E4AFC
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:42:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2ED2EB21133
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:42:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 900AC2CCA5;
	Tue,  7 Nov 2023 21:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="hA4BzTZA"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450202B2EE
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:41:11 +0000 (UTC)
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BBA10E9
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:41:10 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id 5614622812f47-3b6ad461599so584857b6e.1
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393270; x=1699998070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K2OFTXg8XBavOP2tPlsdD5TmFis6HNSAe4rWWmEFvho=;
        b=hA4BzTZASh0LLFDHFG6EKQ9H2FUHjdRIwSm2OixwzcTzNh75FNPh4HJ6ts8obetJus
         /s/38G/+HimGJO2TB+5M5ug4uz9VyA4mSBGFepg9ApHbFF1M7pph2oIgVRluDTv8T//j
         D/d5Egl55KD2C8Q2TRsa13A3mpEMU/RL+yPJyOFvZQDFXPDJ84DOBrfceWhCkXPHH5p2
         YVmMOP3QjJZQRmjQRjxPtUbShmxfzCb4Q4VFh2nB48R0E29siuI6Su0gD2tvGvFnQ9Qs
         ykful/SsIvMPJsoAjb8dYkIkI3D27TUYtavyVdcdL7KdDQw/TnUqlYVYEHV6VCGM+GzI
         df0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393270; x=1699998070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K2OFTXg8XBavOP2tPlsdD5TmFis6HNSAe4rWWmEFvho=;
        b=iP5Xr5G2RjhVOQeB1FNKRmoGsd18gJ2qkJgzq9DhyT1KtK/jpubD6yGppTG7U/2EBE
         EOCdOrOkwy/6nh1Z4yd2VGhVCeJxYLw6ZL8JKlyiFJMusAeyvegRDgAL2UaIUuOFCYOJ
         XSOJs47vwuQ1LXLS2XceC/K7igkR1g0Qs9I+8V1+04Me9YWa3OGkQa27c2rFhiaL1Of5
         GT9zS4rdKY3Fko2Yya/UUq/y3Ka176LaVD9hug8fVriD3h7lNEOE4A7Rf9IBXR3LzpnG
         bsLf/CH5XbR0Ax9KUCoVcBDoxBxr1VwNGkem0BZsq3Gwr/BAJjA4yhjszxW3RAPC4TNh
         W16g==
X-Gm-Message-State: AOJu0Yw8JPHI9xPrA/9G+lwdg1AbH9MFyPDESGIOvKcdwxE01ZW5a8E7
	FFLcZuhnKYHluZWRjWNHZQgmb9fmvMApwX4+s5uLVg==
X-Google-Smtp-Source: AGHT+IEaaldIA3iOXxqK2zrInlxpweTaP+yU7mUkStGw/uDeYT3BPBfL6SPP3AY5ubOnpx1g9xzwtg==
X-Received: by 2002:aca:1208:0:b0:3b2:f2a8:1a4c with SMTP id 8-20020aca1208000000b003b2f2a81a4cmr223003ois.44.1699393269875;
        Tue, 07 Nov 2023 13:41:09 -0800 (PST)
Received: from localhost (fwdproxy-prn-018.fbsv.net. [2a03:2880:ff:12::face:b00c])
        by smtp.gmail.com with ESMTPSA id y188-20020a6364c5000000b005b92ba3938dsm1836687pgb.77.2023.11.07.13.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:41:09 -0800 (PST)
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
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>
Subject: [PATCH 15/20] io_uring/zcrx: add copy fallback
Date: Tue,  7 Nov 2023 13:40:40 -0800
Message-Id: <20231107214045.2172393-16-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231107214045.2172393-1-dw@davidwei.uk>
References: <20231107214045.2172393-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Currently, if user fails to keep up with the network and doesn't refill
the buffer ring fast enough the NIC/driver will start dropping packets.
That might be too punishing, so let's fall back to non-zerocopy version
by allowing the driver to do normal kernel allocations. Later, when
we're in the task context doing zc_rx_recv_skb() we'll detect such pages
and copy them into user specified buffers.

This patch implement the second (copy) part. It'll facilitate adoption
and help the user to strike the balance b/w allocation the right amount
of zerocopy buffers and being resilient to surges in traffic.

Note, due to technical reasons for now we're only using buffers from
->freelist, which is unreliably and is likely to fail with time. It'll
be revised in later patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zc_rx.c | 115 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 105 insertions(+), 10 deletions(-)

diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index c1502ec3e629..c2ed600f0951 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -498,6 +498,26 @@ static void io_zc_rx_refill_cache(struct io_zc_rx_ifq *ifq, int count)
 	pool->cache_count += filled;
 }
 
+static struct io_zc_rx_buf *io_zc_get_buf_task_safe(struct io_zc_rx_ifq *ifq)
+{
+	struct io_zc_rx_pool *pool = ifq->pool;
+	struct io_zc_rx_buf *buf = NULL;
+	u32 pgid;
+
+	if (!READ_ONCE(pool->free_count))
+		return NULL;
+
+	spin_lock_bh(&pool->freelist_lock);
+	if (pool->free_count) {
+		pool->free_count--;
+		pgid = pool->freelist[pool->free_count];
+		buf = &pool->bufs[pgid];
+		atomic_set(&buf->refcount, 1);
+	}
+	spin_unlock_bh(&pool->freelist_lock);
+	return buf;
+}
+
 struct io_zc_rx_buf *io_zc_rx_get_buf(struct io_zc_rx_ifq *ifq)
 {
 	struct io_zc_rx_pool *pool = ifq->pool;
@@ -576,6 +596,11 @@ static struct io_zc_rx_ifq *io_zc_rx_ifq_skb(struct sk_buff *skb)
 	return NULL;
 }
 
+static inline void io_zc_return_rbuf_cqe(struct io_zc_rx_ifq *ifq)
+{
+	ifq->cached_cq_tail--;
+}
+
 static inline struct io_uring_rbuf_cqe *io_zc_get_rbuf_cqe(struct io_zc_rx_ifq *ifq)
 {
 	struct io_uring_rbuf_cqe *cqe;
@@ -595,6 +620,51 @@ static inline struct io_uring_rbuf_cqe *io_zc_get_rbuf_cqe(struct io_zc_rx_ifq *
 	return cqe;
 }
 
+static ssize_t zc_rx_copy_chunk(struct io_zc_rx_ifq *ifq, void *data,
+				unsigned int offset, size_t len)
+{
+	size_t copy_size, copied = 0;
+	struct io_uring_rbuf_cqe *cqe;
+	struct io_zc_rx_buf *buf;
+	unsigned int pgid;
+	int ret = 0, off = 0;
+	u8 *vaddr;
+
+	do {
+		cqe = io_zc_get_rbuf_cqe(ifq);
+		if (!cqe) {
+			ret = ENOBUFS;
+			break;
+		}
+		buf = io_zc_get_buf_task_safe(ifq);
+		if (!buf) {
+			io_zc_return_rbuf_cqe(ifq);
+			ret = -ENOMEM;
+			break;
+		}
+
+		vaddr = kmap_local_page(buf->page);
+		copy_size = min_t(size_t, PAGE_SIZE, len);
+		memcpy(vaddr, data + offset, copy_size);
+		kunmap_local(vaddr);
+
+		pgid = page_private(buf->page) & 0xffffffff;
+		io_zc_rx_get_buf_uref(ifq->pool, pgid);
+		io_zc_rx_put_buf(ifq, buf);
+
+		cqe->region = 0;
+		cqe->off = pgid * PAGE_SIZE + off;
+		cqe->len = copy_size;
+		cqe->flags = 0;
+
+		offset += copy_size;
+		len -= copy_size;
+		copied += copy_size;
+	} while (offset < len);
+
+	return copied ? copied : ret;
+}
+
 static int zc_rx_recv_frag(struct io_zc_rx_ifq *ifq, const skb_frag_t *frag,
 			   int off, int len, bool zc_skb)
 {
@@ -618,9 +688,21 @@ static int zc_rx_recv_frag(struct io_zc_rx_ifq *ifq, const skb_frag_t *frag,
 		cqe->len = len;
 		cqe->flags = 0;
 	} else {
-		/* TODO: copy frags that aren't backed by zc pages */
-		WARN_ON_ONCE(1);
-		return -ENOMEM;
+		u32 p_off, p_len, t, copied = 0;
+		u8 *vaddr;
+		int ret = 0;
+
+		skb_frag_foreach_page(frag, off, len,
+				      page, p_off, p_len, t) {
+			vaddr = kmap_local_page(page);
+			ret = zc_rx_copy_chunk(ifq, vaddr, p_off, p_len);
+			kunmap_local(vaddr);
+
+			if (ret < 0)
+				return copied ? copied : ret;
+			copied += ret;
+		}
+		len = copied;
 	}
 
 	return len;
@@ -633,7 +715,7 @@ zc_rx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	struct io_zc_rx_ifq *ifq = desc->arg.data;
 	struct io_zc_rx_ifq *skb_ifq;
 	struct sk_buff *frag_iter;
-	unsigned start, start_off;
+	unsigned start, start_off = offset;
 	int i, copy, end, off;
 	bool zc_skb = true;
 	int ret = 0;
@@ -643,14 +725,27 @@ zc_rx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 		zc_skb = false;
 		if (WARN_ON_ONCE(skb_ifq))
 			return -EFAULT;
-		pr_debug("non zerocopy pages are not supported\n");
-		return -EFAULT;
 	}
-	start = skb_headlen(skb);
-	start_off = offset;
 
-	// TODO: copy payload in skb linear data */
-	WARN_ON_ONCE(offset < start);
+	if (unlikely(offset < skb_headlen(skb))) {
+		ssize_t copied;
+		size_t to_copy;
+
+		to_copy = min_t(size_t, skb_headlen(skb) - offset, len);
+		copied = zc_rx_copy_chunk(ifq, skb->data, offset, to_copy);
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
2.39.3


