Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35937892FC
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 03:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbjHZBWG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 21:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjHZBVk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 21:21:40 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A194A1FF7
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 18:21:34 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 46e09a7af769-6b9a2416b1cso1134110a34.2
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 18:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1693012894; x=1693617694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CkPCZybv2QToUQGiLBLfHjAvQGjKHNqxFqhs5mZLvj0=;
        b=g60xH4uuHwp/zHzUcBKlgnbNUm5LMwNlmczo93z0rvRylNFFHxf7Tn5F7D9BBrW/kX
         JMf1h+oPTMILsSXvXIFOCT5CJwQNUujhqdYS6dGG161XHpwey9W3mxEYFclvfPLvhy+r
         ZzkXgVDKrKhnELB9KeaG0sXzgH7HM657r6tLoIu65UCPZAuFik9Jr/wXQVUrKgiL+uqG
         lbS4bNYKsdxen3429LRM9mzT645sfw2mDqOF8MaYYfh8pC8NSu7R6QGlAqtb/RuGyqr9
         +YkpoqoB8b2D4IX9I5KDHII6phFJt2VWMp+sUbmLT+CrTUIh/iW7TmFvZPdntq1HtHX/
         Kb3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693012894; x=1693617694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CkPCZybv2QToUQGiLBLfHjAvQGjKHNqxFqhs5mZLvj0=;
        b=jseziqyluFthTW+isVaSXnd6ZXzXPjDFv4jHZL+dD7lIBQXBTLFjq9C/ucSejCL6yw
         oQ/1rFK2Rk1dekX0EsXQWurUzvkjr7NYSN80A7erDmV4M/JDrN6Hu6boU1Zipya5gYP1
         +/Qvo0DdZQtme90kEknAgBW5nbHJ5wuowjdQ2c5GOYHho27cE4mU0OuPAxxTSZpnlvT+
         Pdycp3iSrW74d28q721FKEtVdBziAvIYfE+P7l55XHk1aBhSrtDFu4GW7g8jogNQPZ9o
         C4L+0LhJh0B67ajxxXia/9iFJNPuG5B0APSiHUCmlfVW2EOjyS+b2lJxcZfcr1xURrqf
         OYaQ==
X-Gm-Message-State: AOJu0YzbaVSsgAQQcCxLFARrWNRwkknADRHjJSvbT2HdPdcsCBvwhS1Q
        nY/+L+bff2YmLJTkyH0fHnuaWrvEEg9L0vwWAALleA==
X-Google-Smtp-Source: AGHT+IFFeLOrWoee3AhQEEGp2q6xYvsabd0OkckOV3EsN9DbDmlj5tHN86cRjsJzxIZyeDM9w3ioNA==
X-Received: by 2002:a9d:6314:0:b0:6bd:be5:daa2 with SMTP id q20-20020a9d6314000000b006bd0be5daa2mr6428327otk.33.1693012893949;
        Fri, 25 Aug 2023 18:21:33 -0700 (PDT)
Received: from localhost (fwdproxy-prn-000.fbsv.net. [2a03:2880:ff::face:b00c])
        by smtp.gmail.com with ESMTPSA id i4-20020a63b304000000b0054fe7736ac1sm2113783pgf.76.2023.08.25.18.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 18:21:33 -0700 (PDT)
From:   David Wei <dw@davidwei.uk>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 06/11] io_uring: add ZC pool API
Date:   Fri, 25 Aug 2023 18:19:49 -0700
Message-Id: <20230826011954.1801099-7-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230826011954.1801099-1-dw@davidwei.uk>
References: <20230826011954.1801099-1-dw@davidwei.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: David Wei <davidhwei@meta.com>

This patch adds an API to get/put bufs from a ZC pool added in the
previous patch.

Recall that there is an rbuf refill ring in an ifq that is shared w/
userspace, which puts bufs it is done with back into it. A new tier is
added to the ZC pool that drains entries from the refill ring to put
into the cache. So when the cache is empty, it is refilled from the
refill ring first, then the freelist.

ZC bufs are refcounted, with both a kref and a uref. Userspace is given
an off + len into the entire ZC pool region, not individual pages from
ZC bufs. A net device may pack multiple packets into the same page it
gets from a ZC buf, so it is possible for the same ZC buf to be handed
out to userspace multiple times.

This means it is possible to drain the entire refill ring, and have no
usable free bufs. Suggestions for dealing w/ this are very welcome!

Only up to POOL_REFILL_COUNT entries are refilled from the refill ring.
Given the above, we may want to limit the amount of work being done
since refilling happens inside the NAPI softirq context.

Signed-off-by: David Wei <davidhwei@meta.com>
Co-developed-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/io_uring.h | 18 ++++++++
 io_uring/zc_rx.c         | 98 ++++++++++++++++++++++++++++++++++++++++
 io_uring/zc_rx.h         | 13 ++++++
 3 files changed, 129 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index cf1993befa6a..61eae25a8f1d 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -60,6 +60,17 @@ void __io_uring_free(struct task_struct *tsk);
 void io_uring_unreg_ringfd(void);
 const char *io_uring_get_opcode(u8 opcode);
 
+struct io_zc_rx_ifq;
+struct io_zc_rx_buf *io_zc_rx_get_buf(struct io_zc_rx_ifq *ifq);
+void io_zc_rx_put_buf(struct io_zc_rx_ifq *ifq, struct io_zc_rx_buf *buf);
+static inline dma_addr_t io_zc_rx_buf_dma(struct io_zc_rx_buf *buf)
+{
+	return buf->dma;
+}
+static inline struct page *io_zc_rx_buf_page(struct io_zc_rx_buf *buf)
+{
+	return buf->page;
+}
 static inline void io_uring_files_cancel(void)
 {
 	if (current->io_uring) {
@@ -108,6 +119,13 @@ static inline const char *io_uring_get_opcode(u8 opcode)
 {
 	return "";
 }
+static inline struct io_zc_rx_buf *io_zc_rx_get_buf(struct io_zc_rx_ifq *ifq)
+{
+	return NULL;
+}
+void io_zc_rx_put_buf(struct io_zc_rx_ifq *ifq, struct io_zc_rx_buf *buf)
+{
+}
 #endif
 
 #endif
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 317127d0d4e7..14bc063f1c6c 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -14,6 +14,9 @@
 #include "zc_rx.h"
 
 #define POOL_CACHE_SIZE	128
+#define POOL_REFILL_COUNT	64
+#define IO_ZC_RX_UREF		0x10000
+#define IO_ZC_RX_KREF_MASK	(IO_ZC_RX_UREF - 1)
 
 struct io_zc_rx_pool {
 	struct io_zc_rx_ifq  	*ifq;
@@ -267,6 +270,8 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 
 	ifq->rq_entries = reg.rq_entries;
 	ifq->cq_entries = reg.cq_entries;
+	ifq->cached_rq_head = 0;
+	ifq->cached_cq_tail = 0;
 	ifq->if_rxq_id = reg.if_rxq_id;
 	ctx->ifq = ifq;
 
@@ -309,3 +314,96 @@ int io_unregister_zc_rx_ifq(struct io_ring_ctx *ctx)
 
 	return 0;
 }
+
+static bool io_zc_rx_put_buf_uref(struct io_zc_rx_buf *buf)
+{
+	if (atomic_read(&buf->refcount) < IO_ZC_RX_UREF)
+		return false;
+
+	return atomic_sub_and_test(IO_ZC_RX_UREF, &buf->refcount);
+}
+
+static void io_zc_rx_refill_cache(struct io_zc_rx_ifq *ifq, int count)
+{
+	unsigned int entries = io_zc_rx_rqring_entries(ifq);
+	unsigned int mask = ifq->rq_entries - 1;
+	struct io_zc_rx_pool *pool = ifq->pool;
+	struct io_uring_rbuf_rqe *rqe;
+	struct io_zc_rx_buf *buf;
+	int i, filled;
+
+	if (!entries)
+		return;
+
+	for (i = 0, filled = 0; i < entries && filled < count; i++) {
+		unsigned int rq_idx = ifq->cached_rq_head++ & mask;
+		u32 pgid;
+
+		rqe = &ifq->rqes[rq_idx];
+		pgid = rqe->off / PAGE_SIZE;
+		buf = &pool->bufs[pgid];
+		if (!io_zc_rx_put_buf_uref(buf))
+			continue;
+		pool->cache[filled++] = pgid;
+	}
+
+	smp_store_release(&ifq->ring->rq.head, ifq->cached_rq_head);
+	pool->cache_count += filled;
+}
+
+struct io_zc_rx_buf *io_zc_rx_get_buf(struct io_zc_rx_ifq *ifq)
+{
+	struct io_zc_rx_pool *pool;
+	struct io_zc_rx_buf *buf;
+	int count;
+	u16 pgid;
+
+	pool = ifq->pool;
+	if (pool->cache_count)
+		goto out;
+
+	io_zc_rx_refill_cache(ifq, POOL_REFILL_COUNT);
+	if (pool->cache_count)
+		goto out;
+
+	spin_lock(&pool->freelist_lock);
+
+	count = min_t(u32, pool->free_count, POOL_CACHE_SIZE);
+	pool->free_count -= count;
+	pool->cache_count += count;
+	memcpy(pool->cache, &pool->freelist[pool->free_count],
+	       count * sizeof(u32));
+
+	spin_unlock(&pool->freelist_lock);
+
+	if (pool->cache_count)
+		goto out;
+
+	return NULL;
+out:
+	pgid = pool->cache[--pool->cache_count];
+	buf = &pool->bufs[pgid];
+	atomic_set(&buf->refcount, 1);
+
+	return buf;
+}
+EXPORT_SYMBOL(io_zc_rx_get_buf);
+
+static void io_zc_rx_recycle_buf(struct io_zc_rx_pool *pool,
+				 struct io_zc_rx_buf *buf)
+{
+	spin_lock(&pool->freelist_lock);
+	pool->freelist[pool->free_count++] = buf - pool->bufs;
+	spin_unlock(&pool->freelist_lock);
+}
+
+void io_zc_rx_put_buf(struct io_zc_rx_ifq *ifq, struct io_zc_rx_buf *buf)
+{
+	struct io_zc_rx_pool *pool = ifq->pool;
+
+	if (!atomic_dec_and_test(&buf->refcount))
+		return;
+
+	io_zc_rx_recycle_buf(pool, buf);
+}
+EXPORT_SYMBOL(io_zc_rx_put_buf);
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
index 3cd0e730115d..b063a3c81ccb 100644
--- a/io_uring/zc_rx.h
+++ b/io_uring/zc_rx.h
@@ -2,6 +2,8 @@
 #ifndef IOU_ZC_RX_H
 #define IOU_ZC_RX_H
 
+#include <linux/io_uring_types.h>
+
 struct io_zc_rx_ifq {
 	struct io_ring_ctx	*ctx;
 	struct net_device	*dev;
@@ -9,12 +11,23 @@ struct io_zc_rx_ifq {
 	struct io_uring_rbuf_rqe *rqes;
 	struct io_uring_rbuf_cqe *cqes;
 	u32			rq_entries, cq_entries;
+	u32			cached_rq_head;
+	u32			cached_cq_tail;
 	void			*pool;
 
 	/* hw rx descriptor ring id */
 	u32			if_rxq_id;
 };
 
+static inline u32 io_zc_rx_rqring_entries(struct io_zc_rx_ifq *ifq)
+{
+	struct io_rbuf_ring *ring = ifq->ring;
+	u32 entries;
+
+	entries = smp_load_acquire(&ring->rq.tail) - ifq->cached_rq_head;
+	return min(entries, ifq->rq_entries);
+}
+
 int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zc_rx_ifq_reg __user *arg);
 int io_unregister_zc_rx_ifq(struct io_ring_ctx *ctx);
-- 
2.39.3

