Return-Path: <io-uring+bounces-61-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11B497E4AEF
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:41:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF732281494
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E523A450CF;
	Tue,  7 Nov 2023 21:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="WCF6h/UL"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8515F2B2D3
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:41:06 +0000 (UTC)
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2691C10E9
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:41:06 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1cc1ee2d8dfso55984255ad.3
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393265; x=1699998065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CEGEZSeHFsNXXDjUe7hxxYXsucH5o3pVw1oTNiKf1kY=;
        b=WCF6h/UL4Sl04sCFRepXbhFMm9+IC+OEifYNyXrap4HiP9asilQIBgb1tTzuEYOjd1
         eaTh1XcCOlCWTn35sPj+wA4jRNZrwj6RQuXEcJgLLnZckuLINceRJdhXya7kHo4v8oUK
         X1VLiAtJZegyM8cAaaR4SHn/EqQ9Rpq7a3pz8rs6mOI+4C6BBq3l3Sua+8uOoNYGaTFe
         coaCt+lfiUuhtHLlhz8b36EYEXVsTbIBRndZY3VQ1weTowlmAo7FU5tkCYAEPywP0K1O
         sa1NWcyd36e121818PaGCcqWnOAvwTVKBD7XfN3TRyFwIqpy0T4AN2Ai4zd0wYpD93id
         r5pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393265; x=1699998065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CEGEZSeHFsNXXDjUe7hxxYXsucH5o3pVw1oTNiKf1kY=;
        b=fhE65SYW1dGxtypCUb31OwbxqQMMwIOgSjyeoE+Ajb4xeju4vWFBJKv3YyE0PyVc4Z
         xSyAK26yRGMyk32OBfeWM2cvjI5VxCBojQ3DZeoX36ZzjpM6k19aaTIOHeyhY0n0K8j+
         ydK+yjPgJs8ubFmEX1+btzPMsE+VXu7nUoIS7ajKhIAQSB2+g9CQ70ijAPoz7hRBaqTl
         MjR9B4hE7RORC/ruRFMWlRO9RyvrBkgC4Gmi8CLyq8v2kAhO/kc9t0Ktol9TmXIwWm0V
         IEIUxA6Wx5+uJOybgtxSMV6X+oufSCiw8b6io8hr2k/v3rt4Or+NvYN0d47PS//y5S8P
         z04g==
X-Gm-Message-State: AOJu0YyXFrqCZARZ81wbEdxgpI9i/FzIr/U1XdVe7SoPZrYYfv9l0Uh8
	xX+V+F8AgNqwkGhUJk0ApIiZ+1ZaNEB7TolF9PnBbg==
X-Google-Smtp-Source: AGHT+IHSl06XpdqPfoK/SHJali+kSRHZLDIfMQko+YfURseQXsqMuGdK6iNbBkPuUdvA0ZQOM6VlNA==
X-Received: by 2002:a17:902:9b90:b0:1c3:3b5c:1fbf with SMTP id y16-20020a1709029b9000b001c33b5c1fbfmr283461plp.10.1699393265443;
        Tue, 07 Nov 2023 13:41:05 -0800 (PST)
Received: from localhost (fwdproxy-prn-018.fbsv.net. [2a03:2880:ff:12::face:b00c])
        by smtp.gmail.com with ESMTPSA id o7-20020a1709026b0700b001c739768214sm280417plk.92.2023.11.07.13.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:41:05 -0800 (PST)
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
Subject: [PATCH 10/20] io_uring: delay ZC pool destruction
Date: Tue,  7 Nov 2023 13:40:35 -0800
Message-Id: <20231107214045.2172393-11-dw@davidwei.uk>
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

At a point in time, a ZC buf may be in:

* Rx queue
* Socket
* One of the ifq ringbufs
* Userspace

The ZC pool region and the pool itself cannot be destroyed until all
bufs have been returned.

This patch changes the ZC pool destruction to be delayed work, waiting
for up to 10 seconds for bufs to be returned before unconditionally
destroying the pool.

Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zc_rx.c | 51 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 59f279486e9a..bebcd637c893 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -30,6 +30,10 @@ struct io_zc_rx_pool {
 	u32			cache_count;
 	u32			cache[POOL_CACHE_SIZE];
 
+	/* delayed destruction */
+	unsigned long		delay_end;
+	struct delayed_work	destroy_work;
+
 	/* freelist */
 	spinlock_t		freelist_lock;
 	u32			free_count;
@@ -224,20 +228,57 @@ static int io_zc_rx_create_pool(struct io_ring_ctx *ctx,
 	return ret;
 }
 
-static void io_zc_rx_destroy_pool(struct io_zc_rx_pool *pool)
+static void io_zc_rx_destroy_ifq(struct io_zc_rx_ifq *ifq)
+{
+	if (ifq->dev)
+		dev_put(ifq->dev);
+	io_free_rbuf_ring(ifq);
+	kfree(ifq);
+}
+
+static void io_zc_rx_destroy_pool_work(struct work_struct *work)
 {
+	struct io_zc_rx_pool *pool = container_of(
+			to_delayed_work(work), struct io_zc_rx_pool, destroy_work);
 	struct device *dev = netdev2dev(pool->ifq->dev);
 	struct io_zc_rx_buf *buf;
+	int i, refc, count;
 
-	for (int i = 0; i < pool->nr_pages; i++) {
+	for (i = 0; i < pool->nr_pages; i++) {
 		buf = &pool->bufs[i];
+		refc = atomic_read(&buf->refcount) & IO_ZC_RX_KREF_MASK;
+		if (refc) {
+			if (time_before(jiffies, pool->delay_end)) {
+				schedule_delayed_work(&pool->destroy_work, HZ);
+				return;
+			}
+			count++;
+		}
+	}
+
+	if (count) {
+		pr_debug("freeing pool with %d/%d outstanding pages\n",
+			 count, pool->nr_pages);
+		return;
+	}
 
+	for (i = 0; i < pool->nr_pages; i++) {
+		buf = &pool->bufs[i];
 		io_zc_rx_unmap_buf(dev, buf);
 	}
+
+	io_zc_rx_destroy_ifq(pool->ifq);
 	kvfree(pool->bufs);
 	kvfree(pool);
 }
 
+static void io_zc_rx_destroy_pool(struct io_zc_rx_pool *pool)
+{
+	pool->delay_end = jiffies + HZ * 10;
+	INIT_DELAYED_WORK(&pool->destroy_work, io_zc_rx_destroy_pool_work);
+	schedule_delayed_work(&pool->destroy_work, 0);
+}
+
 static struct io_zc_rx_ifq *io_zc_rx_ifq_alloc(struct io_ring_ctx *ctx)
 {
 	struct io_zc_rx_ifq *ifq;
@@ -258,10 +299,8 @@ static void io_zc_rx_ifq_free(struct io_zc_rx_ifq *ifq)
 		io_close_zc_rxq(ifq);
 	if (ifq->pool)
 		io_zc_rx_destroy_pool(ifq->pool);
-	if (ifq->dev)
-		dev_put(ifq->dev);
-	io_free_rbuf_ring(ifq);
-	kfree(ifq);
+	else
+		io_zc_rx_destroy_ifq(ifq);
 }
 
 int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
-- 
2.39.3


