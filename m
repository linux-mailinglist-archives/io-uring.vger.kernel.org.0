Return-Path: <io-uring+bounces-65-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B3BC7E4AFA
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:42:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D804DB20F8C
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D8F22BD11;
	Tue,  7 Nov 2023 21:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="T3es60nL"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289A42BCF4
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:41:10 +0000 (UTC)
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9795910E2
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:41:09 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-6bee11456baso5662587b3a.1
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393269; x=1699998069; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0l/dAFHKr6I2GsT4AxouY6xWEkGOzCExNR1nSE25Ok4=;
        b=T3es60nLsItlyKtIKstM9Dy7R+HMqJjJqNJjyefe8gZ8YcDIlm0KSlczPvWiuep6MX
         NBEGvEvh9ZVML/vw70AKzzjW1F3guPq4L/expG7egO7mdJjP/RT1IHiCYNduBDeqhGkA
         syzSgF1qjFI6/nI+4/pDJQHfGVLIrxQs7nv4nJa/Ih0Avy2XNrVraKNvWZILlhhOZkzT
         HIVhR+eMlaQN5s+mw2M0hiPRzFzonu1InX+3Lj7kd2R2vxDgQdOQM230N1bgyNcryhKk
         a7O8kkRURK00FoBxOuL3WzOXNLkGwuvv6L+fR02gdyUt8tuxD9YEuOcoNLKERLHhiJrD
         SOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393269; x=1699998069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0l/dAFHKr6I2GsT4AxouY6xWEkGOzCExNR1nSE25Ok4=;
        b=GInuArK8Lp0nJwSIyDWcmqokIdIncLwj5QahMz1CDu6b6G52CHJ5cEbtwCHUwN1Bbu
         fb/6uJ2uOIBTTwUvd9CLSsyZaUTQk0uLFM9/ncvXa43Q7WesQsGVF90iXMTXhtFVwoyx
         x1q2iFqsNu6e99iJ2iQQJQ5++FhxZHs7H4yudZRkWVnDeYjC4dFC+nMK2RLzPXTB7o6Q
         dmqE4QvKjq8ocS21+5oQnziEFQ20Y7qCW4Qa0eoV8UzTWMMmoah7anSN5INYLSg1zfFn
         vbVxJrTITbo59LRPo1WnH07OkWbyPYD5dAxWzsftIEXHDD2rZDVvfT4ZLchikU9p1UeJ
         kMbg==
X-Gm-Message-State: AOJu0YxRV6yQyOzHh6QyFTeJM2qe9gzE29ikoJM6wIQGCwyx5zhUMpUg
	IeukUmyGMpgxwX7boJcSqopqqf/AhPc4woEFJRaTuQ==
X-Google-Smtp-Source: AGHT+IGz9RIYPpPmCVytFlwZp2W7Q/hli9aDmu6Xh8XeTH4433Do+Hg+6z+vlEUQAjbpNk149S9u1A==
X-Received: by 2002:a05:6a00:cc6:b0:68e:42c9:74e0 with SMTP id b6-20020a056a000cc600b0068e42c974e0mr339493pfv.3.1699393268935;
        Tue, 07 Nov 2023 13:41:08 -0800 (PST)
Received: from localhost (fwdproxy-prn-017.fbsv.net. [2a03:2880:ff:11::face:b00c])
        by smtp.gmail.com with ESMTPSA id n22-20020a635c56000000b005898e4acf2dsm1804225pgm.49.2023.11.07.13.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:41:08 -0800 (PST)
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
Subject: [PATCH 14/20] io_uring/zcrx: introduce io_zc_get_rbuf_cqe
Date: Tue,  7 Nov 2023 13:40:39 -0800
Message-Id: <20231107214045.2172393-15-dw@davidwei.uk>
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

Add a simple helper for grabbing a new rbuf entry. It greatly helps
zc_rx_recv_frag()'s readability and will be reused later

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zc_rx.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 038692d3265e..c1502ec3e629 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -576,31 +576,43 @@ static struct io_zc_rx_ifq *io_zc_rx_ifq_skb(struct sk_buff *skb)
 	return NULL;
 }
 
+static inline struct io_uring_rbuf_cqe *io_zc_get_rbuf_cqe(struct io_zc_rx_ifq *ifq)
+{
+	struct io_uring_rbuf_cqe *cqe;
+	unsigned int cq_idx, queued, free, entries;
+	unsigned int mask = ifq->cq_entries - 1;
+
+	cq_idx = ifq->cached_cq_tail & mask;
+	smp_rmb();
+	queued = min(io_zc_rx_cqring_entries(ifq), ifq->cq_entries);
+	free = ifq->cq_entries - queued;
+	entries = min(free, ifq->cq_entries - cq_idx);
+	if (!entries)
+		return NULL;
+
+	cqe = &ifq->cqes[cq_idx];
+	ifq->cached_cq_tail++;
+	return cqe;
+}
+
 static int zc_rx_recv_frag(struct io_zc_rx_ifq *ifq, const skb_frag_t *frag,
 			   int off, int len, bool zc_skb)
 {
 	struct io_uring_rbuf_cqe *cqe;
-	unsigned int cq_idx, queued, free, entries;
 	struct page *page;
-	unsigned int mask;
 	u32 pgid;
 
 	page = skb_frag_page(frag);
 	off += skb_frag_off(frag);
 
 	if (likely(zc_skb && is_zc_rx_page(page))) {
-		mask = ifq->cq_entries - 1;
+		cqe = io_zc_get_rbuf_cqe(ifq);
+		if (!cqe)
+			return -ENOBUFS;
+
 		pgid = page_private(page) & 0xffffffff;
 		io_zc_rx_get_buf_uref(ifq->pool, pgid);
-		cq_idx = ifq->cached_cq_tail & mask;
-		smp_rmb();
-		queued = min(io_zc_rx_cqring_entries(ifq), ifq->cq_entries);
-		free = ifq->cq_entries - queued;
-		entries = min(free, ifq->cq_entries - cq_idx);
-		if (!entries)
-			return -ENOBUFS;
-		cqe = &ifq->cqes[cq_idx];
-		ifq->cached_cq_tail++;
+
 		cqe->region = 0;
 		cqe->off = pgid * PAGE_SIZE + off;
 		cqe->len = len;
-- 
2.39.3


