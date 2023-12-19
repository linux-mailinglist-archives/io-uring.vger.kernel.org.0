Return-Path: <io-uring+bounces-316-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4881B819205
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:06:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3B15283C09
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:06:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CC0940BF2;
	Tue, 19 Dec 2023 21:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="AdL53sTm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D362B405DF
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6d5c4cb8a4cso1857078b3a.3
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019861; x=1703624661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=88y6GqmlC4OquYgwdteTX7sFZdaMlDFOxYfP/ATHY4U=;
        b=AdL53sTmXAOuiJZ0HZu2jKQQj+9POMGtPmzl1IEyLlF1LowjmXhdnVlu1mKcdhfnc2
         qBYU/UAj2+PRoy00+6Y4vCzpDFcq5z69+0PIiZ5XZFCRVLUc6NK5GGQoAgjogllawytu
         WeJTuj7YvAfuuVnNdfZ0sdYEMVR3xhvn1WV1WdPquQyEMCuVUX5lO4FjAZdSm3t8v1Q2
         XwDTQ7/yDilBSgZU5mpa3NQXJ7hSeEX2+IUasxrn+BmLZ0ASQ/n/idbCPdTLj1hIayCy
         ZmlrhaCPU8ybwCGnmgF4+raQuC/TLH8nwtLtGHmKp6hBFgLJYBLNR+fRI9GbE9hKh0/E
         urmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019861; x=1703624661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=88y6GqmlC4OquYgwdteTX7sFZdaMlDFOxYfP/ATHY4U=;
        b=uXSUFFGw5EM/CRB0uJGTIw1s14s2EyeAObHeY45q6X7R6kTmzwH5rqPnduOcSDoUs9
         oSx4mF2JmPQo1NEZWqv7RLSKlDG5vL/TtydNC9dcAklRwkjHO/974U17VhUWjyI+rXOl
         8J7WI/cjFaMnLz2GLAA0WFkYeBFxi8yHss11OUyKxjYCMUQ440dxF9beQE7YysYOJ0NC
         GRj07QySHxUn8ItM6At5nOkcy4wLEZsJZLyvLYqpuNiuHB4Jwm+5V5BEh66DhGcX8xcQ
         D9mmfVapKyZROlarzTGiwSERYQD5WYoFYck4Xh04b4SOZ8eQS3PCsUE2NB7KPQ9V94s3
         OpeA==
X-Gm-Message-State: AOJu0YzW4kvY7hwpVuy52vHtIzeu5iiUYmb8S2Dd0ku5FrvnP+fv9lnd
	/CYP7Iu8D4OBk5PgSu+hY8sHgvGe3V28R3LtF0KVLQ==
X-Google-Smtp-Source: AGHT+IEpQz41IIokOuYaoRjPu5IHvUE6igpmNn5ccwm0j3KSVHCAAgpLK/9gBFnbdEc/qrCQqXJ9+g==
X-Received: by 2002:a17:902:e88f:b0:1d0:7072:e241 with SMTP id w15-20020a170902e88f00b001d07072e241mr12430623plg.49.1703019861044;
        Tue, 19 Dec 2023 13:04:21 -0800 (PST)
Received: from localhost (fwdproxy-prn-010.fbsv.net. [2a03:2880:ff:a::face:b00c])
        by smtp.gmail.com with ESMTPSA id az4-20020a170902a58400b001b7f40a8959sm21395712plb.76.2023.12.19.13.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:20 -0800 (PST)
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
	Mina Almasry <almasrymina@google.com>
Subject: [RFC PATCH v3 17/20] io_uring/zcrx: add copy fallback
Date: Tue, 19 Dec 2023 13:03:54 -0800
Message-Id: <20231219210357.4029713-18-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231219210357.4029713-1-dw@davidwei.uk>
References: <20231219210357.4029713-1-dw@davidwei.uk>
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
That might be too punishing. Add a fallback path, which would allow
drivers to allocate normal pages when there is starvation, then
zc_rx_recv_skb() we'll detect them and copy into the user specified
buffers, when they become available.

That should help with adoption and also help the user striking the right
balance allocating just the right amount of zerocopy buffers but also
being resilient to sudden surges in traffic.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zc_rx.c | 126 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 120 insertions(+), 6 deletions(-)

diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index acb70ca23150..f7d99d569885 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -6,6 +6,7 @@
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
 #include <linux/nospec.h>
+#include <net/busy_poll.h>
 #include <net/tcp.h>
 #include <trace/events/page_pool.h>
 
@@ -21,6 +22,11 @@ struct io_zc_rx_args {
 	struct socket		*sock;
 };
 
+struct io_zc_refill_data {
+	struct io_zc_rx_ifq *ifq;
+	struct io_zc_rx_buf *buf;
+};
+
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 
 static inline u32 io_zc_rx_cqring_entries(struct io_zc_rx_ifq *ifq)
@@ -603,6 +609,39 @@ const struct pp_memory_provider_ops io_uring_pp_zc_ops = {
 };
 EXPORT_SYMBOL(io_uring_pp_zc_ops);
 
+static void io_napi_refill(void *data)
+{
+	struct io_zc_refill_data *rd = data;
+	struct io_zc_rx_ifq *ifq = rd->ifq;
+	void *page;
+
+	if (WARN_ON_ONCE(!ifq->pp))
+		return;
+
+	page = page_pool_dev_alloc_pages(ifq->pp);
+	if (!page)
+		return;
+	if (WARN_ON_ONCE(!page_is_page_pool_iov(page)))
+		return;
+
+	rd->buf = io_iov_to_buf(page_to_page_pool_iov(page));
+}
+
+static struct io_zc_rx_buf *io_zc_get_buf_task_safe(struct io_zc_rx_ifq *ifq)
+{
+	struct io_zc_refill_data rd = {
+		.ifq = ifq,
+	};
+
+	napi_execute(ifq->pp->p.napi, io_napi_refill, &rd);
+	return rd.buf;
+}
+
+static inline void io_zc_return_rbuf_cqe(struct io_zc_rx_ifq *ifq)
+{
+	ifq->cached_cq_tail--;
+}
+
 static inline struct io_uring_rbuf_cqe *io_zc_get_rbuf_cqe(struct io_zc_rx_ifq *ifq)
 {
 	struct io_uring_rbuf_cqe *cqe;
@@ -622,6 +661,51 @@ static inline struct io_uring_rbuf_cqe *io_zc_get_rbuf_cqe(struct io_zc_rx_ifq *
 	return cqe;
 }
 
+static ssize_t zc_rx_copy_chunk(struct io_zc_rx_ifq *ifq, void *data,
+				unsigned int offset, size_t len,
+				unsigned sock_idx)
+{
+	size_t copy_size, copied = 0;
+	struct io_uring_rbuf_cqe *cqe;
+	struct io_zc_rx_buf *buf;
+	int ret = 0, off = 0;
+	u8 *vaddr;
+
+	do {
+		cqe = io_zc_get_rbuf_cqe(ifq);
+		if (!cqe) {
+			ret = -ENOBUFS;
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
+		cqe->region = 0;
+		cqe->off = io_buf_pgid(ifq->pool, buf) * PAGE_SIZE + off;
+		cqe->len = copy_size;
+		cqe->flags = 0;
+		cqe->sock = sock_idx;
+
+		io_zc_rx_get_buf_uref(buf);
+		page_pool_iov_put_many(&buf->ppiov, 1);
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
 			   int off, int len, unsigned sock_idx)
 {
@@ -650,7 +734,22 @@ static int zc_rx_recv_frag(struct io_zc_rx_ifq *ifq, const skb_frag_t *frag,
 		cqe->sock = sock_idx;
 		cqe->flags = 0;
 	} else {
-		return -EOPNOTSUPP;
+		struct page *page = skb_frag_page(frag);
+		u32 p_off, p_len, t, copied = 0;
+		u8 *vaddr;
+		int ret = 0;
+
+		skb_frag_foreach_page(frag, off, len,
+				      page, p_off, p_len, t) {
+			vaddr = kmap_local_page(page);
+			ret = zc_rx_copy_chunk(ifq, vaddr, p_off, p_len, sock_idx);
+			kunmap_local(vaddr);
+
+			if (ret < 0)
+				return copied ? copied : ret;
+			copied += ret;
+		}
+		len = copied;
 	}
 
 	return len;
@@ -665,15 +764,30 @@ zc_rx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	struct socket *sock = args->sock;
 	unsigned sock_idx = sock->zc_rx_idx & IO_ZC_IFQ_IDX_MASK;
 	struct sk_buff *frag_iter;
-	unsigned start, start_off;
+	unsigned start, start_off = offset;
 	int i, copy, end, off;
 	int ret = 0;
 
-	start = skb_headlen(skb);
-	start_off = offset;
+	if (unlikely(offset < skb_headlen(skb))) {
+		ssize_t copied;
+		size_t to_copy;
 
-	if (offset < start)
-		return -EOPNOTSUPP;
+		to_copy = min_t(size_t, skb_headlen(skb) - offset, len);
+		copied = zc_rx_copy_chunk(ifq, skb->data, offset, to_copy,
+					  sock_idx);
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


