Return-Path: <io-uring+bounces-3455-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A3EA993A08
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 00:17:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D56A3B23403
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 22:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6B31DACBE;
	Mon,  7 Oct 2024 22:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="U4qCmATg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E4D194AF0
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 22:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728339405; cv=none; b=NY9XwWrfFwJghBBG3c6sK8Mh6HwgIaDSl6LfH8alNjPuMGhzYlR+BmcrlyL/3TiYGf3VNqy8aNXakqxJwPEebVp3EWW+aUgfH41TCxV+dyp9fft9Ab60waewL5AbK/8VdoSWB7qbznbG09j1H16zMcUlIXrOSEuM7txgcBbODGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728339405; c=relaxed/simple;
	bh=4quKQmRDyKq8kxGfVBu+0W6bFSjXmRzSt74BfF/rLpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anqtQ/1kqBhFeubTsX4yLaDC+uZGNAjTrXU4U87UhMRTGa3OZegKB2v2yYqV8IL9g2VbkETdZpBApeyUon3/7ocQXVvgnpAOg7YvehJkqtokoBtYL3yT0vt01MFqcewiT2TbFLvPB6wzwfH1UGvjeuJ3xEICu0w3iwoh3lGNzOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=U4qCmATg; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20b78ee6298so31695045ad.2
        for <io-uring@vger.kernel.org>; Mon, 07 Oct 2024 15:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728339404; x=1728944204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZCpwQIKANo1xda4Ip9Xs5tdX44KYlU32n0KZmCBN9k=;
        b=U4qCmATgT8rplfKGmYwPGuhUhTgAYo/pkALlQsWu4NEdUQO2T2+ok86JLFB3Q8XBtE
         HWJis0crzc4eN/9VnIe7SjCoO3WBgc8p3D4k7ri5iTSqeqp99BJBHGy5uW4r0gPpPUOI
         2Zy0Btd9kFo0Q9nj1RkJwrRf+Axd7F0YBQuBdeHA//fkETfdypsf8weENjmRS4joNRR8
         C1ZXyU2vtMe8tIz5KUnA0k5fa9iuN0ehM5o8xJRJ+8RlR6TOCgWJdBw/F8AMGk+LRnN3
         ON0Ja+tcGS+uAAaMjl0pvIaCPzFusVn7Ln4y6HVTHqD4cYcDtbn+6W0F8nRntCE9Dn3H
         LJxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728339404; x=1728944204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eZCpwQIKANo1xda4Ip9Xs5tdX44KYlU32n0KZmCBN9k=;
        b=pWRGHL+QQc+Fyz/kFE6AqhwTmuMCzV5tjwUvuac207bf5zUCuE9JfL5dYpFH1z0vrt
         q7xYemBmkBUaDKX2Zu6cSlueIgrfpTBibINnIvaiFaMmRk44aV4rlRloObRu2l1D6EA7
         y+hwpqcpRMZwuFzPr4rTX5ez6aij7jx8IiRd8TFW6P5SsUbaTTpKkkH3ZWkAS85PZQr4
         hiKAUzg4iYdHXpqxdWGevQz9hDNuimYf1vlpipKQxgd7Z8JcffepTQ1q/h0NxVr2NEP8
         hGXFt7akX9EnO4Avqg4FPNqPLVP6AA5IPntONfEVnbeTyISGvOlsKsih0AkYNcYvx/0J
         6gew==
X-Gm-Message-State: AOJu0YzWIK5iEzIqbydAqxmwMoSiRYDerDhTkOaR+1EYIeuOcqBG/Np7
	jxgXRhAN5kYCWv36nAPUwzOgn0vzcsdpyk2m9dO083EobZCL8FA0rGUX8seTsZF73VAqDiPYY/d
	M
X-Google-Smtp-Source: AGHT+IEvyVdzwuTNsYLAMar1o1hnlxxWzdcyt4OsBcpoUoFgJvf0/bwT/mqMaRtPmXlPZ3+f5NPabA==
X-Received: by 2002:a17:902:f687:b0:20b:57f0:b392 with SMTP id d9443c01a7336-20bfdff2519mr146303075ad.22.1728339403731;
        Mon, 07 Oct 2024 15:16:43 -0700 (PDT)
Received: from localhost (fwdproxy-prn-057.fbsv.net. [2a03:2880:ff:39::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c138ca835sm44107785ad.68.2024.10.07.15.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 15:16:43 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [PATCH v1 13/15] io_uring/zcrx: add copy fallback
Date: Mon,  7 Oct 2024 15:16:01 -0700
Message-ID: <20241007221603.1703699-14-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241007221603.1703699-1-dw@davidwei.uk>
References: <20241007221603.1703699-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

There are scenarios in which the zerocopy path might get a normal
in-kernel buffer, it could be a mis-steered packet or simply the linear
part of an skb. Another use case is to allow the driver to allocate
kernel pages when it's out of zc buffers, which makes it more resilient
to spikes in load and allow the user to choose the balance between the
amount of memory provided and performance.

At the moment we fail such requests. Instead, grab a buffer from the
page pool, copy data there, and return back to user in the usual way.
Because the refill ring is private to the napi our page pool is running
from, it's done by stopping the napi via napi_execute() helper. It grabs
only one buffer, which is inefficient, and improving it is left for
follow up patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 125 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 118 insertions(+), 7 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 8166d8a2656e..d21e7017deb3 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -5,6 +5,8 @@
 #include <linux/nospec.h>
 #include <linux/netdevice.h>
 #include <linux/io_uring.h>
+#include <linux/skbuff_ref.h>
+#include <net/busy_poll.h>
 #include <net/page_pool/helpers.h>
 #include <trace/events/page_pool.h>
 #include <net/tcp.h>
@@ -28,6 +30,11 @@ struct io_zcrx_args {
 	struct socket		*sock;
 };
 
+struct io_zc_refill_data {
+	struct io_zcrx_ifq *ifq;
+	struct net_iov *niov;
+};
+
 static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *niov)
 {
 	struct net_iov_area *owner = net_iov_owner(niov);
@@ -35,6 +42,13 @@ static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *nio
 	return container_of(owner, struct io_zcrx_area, nia);
 }
 
+static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
+{
+	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+
+	return area->pages[net_iov_idx(niov)];
+}
+
 static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 				 struct io_uring_zcrx_ifq_reg *reg)
 {
@@ -475,6 +489,34 @@ const struct memory_provider_ops io_uring_pp_zc_ops = {
 	.scrub			= io_pp_zc_scrub,
 };
 
+static void io_napi_refill(void *data)
+{
+	struct io_zc_refill_data *rd = data;
+	struct io_zcrx_ifq *ifq = rd->ifq;
+	netmem_ref netmem;
+
+	if (WARN_ON_ONCE(!ifq->pp))
+		return;
+
+	netmem = page_pool_alloc_netmem(ifq->pp, GFP_ATOMIC | __GFP_NOWARN);
+	if (!netmem)
+		return;
+	if (WARN_ON_ONCE(!netmem_is_net_iov(netmem)))
+		return;
+
+	rd->niov = netmem_to_net_iov(netmem);
+}
+
+static struct net_iov *io_zc_get_buf_task_safe(struct io_zcrx_ifq *ifq)
+{
+	struct io_zc_refill_data rd = {
+		.ifq = ifq,
+	};
+
+	napi_execute(ifq->napi_id, io_napi_refill, &rd);
+	return rd.niov;
+}
+
 static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
 			      struct io_zcrx_ifq *ifq, int off, int len)
 {
@@ -498,6 +540,45 @@ static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
 	return true;
 }
 
+static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
+				  void *data, unsigned int offset, size_t len)
+{
+	size_t copy_size, copied = 0;
+	int ret = 0, off = 0;
+	struct page *page;
+	u8 *vaddr;
+
+	do {
+		struct net_iov *niov;
+
+		niov = io_zc_get_buf_task_safe(ifq);
+		if (!niov) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		page = io_zcrx_iov_page(niov);
+		vaddr = kmap_local_page(page);
+		copy_size = min_t(size_t, PAGE_SIZE, len);
+		memcpy(vaddr, data + offset, copy_size);
+		kunmap_local(vaddr);
+
+		if (!io_zcrx_queue_cqe(req, niov, ifq, off, copy_size)) {
+			napi_pp_put_page(net_iov_to_netmem(niov));
+			return -ENOSPC;
+		}
+
+		io_zcrx_get_buf_uref(niov);
+		napi_pp_put_page(net_iov_to_netmem(niov));
+
+		offset += copy_size;
+		len -= copy_size;
+		copied += copy_size;
+	} while (offset < len);
+
+	return copied ? copied : ret;
+}
+
 static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			     const skb_frag_t *frag, int off, int len)
 {
@@ -505,8 +586,24 @@ static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 
 	off += skb_frag_off(frag);
 
-	if (unlikely(!skb_frag_is_net_iov(frag)))
-		return -EOPNOTSUPP;
+	if (unlikely(!skb_frag_is_net_iov(frag))) {
+		struct page *page = skb_frag_page(frag);
+		u32 p_off, p_len, t, copied = 0;
+		u8 *vaddr;
+		int ret = 0;
+
+		skb_frag_foreach_page(frag, off, len,
+				      page, p_off, p_len, t) {
+			vaddr = kmap_local_page(page);
+			ret = io_zcrx_copy_chunk(req, ifq, vaddr, p_off, p_len);
+			kunmap_local(vaddr);
+
+			if (ret < 0)
+				return copied ? copied : ret;
+			copied += ret;
+		}
+		return copied;
+	}
 
 	niov = netmem_to_net_iov(frag->netmem);
 	if (niov->pp->mp_ops != &io_uring_pp_zc_ops ||
@@ -527,15 +624,29 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	struct io_zcrx_ifq *ifq = args->ifq;
 	struct io_kiocb *req = args->req;
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
+		copied = io_zcrx_copy_chunk(req, ifq, skb->data, offset, to_copy);
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


