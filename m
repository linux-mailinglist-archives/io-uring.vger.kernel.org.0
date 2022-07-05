Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925CD5671E8
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 17:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiGEPDA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 11:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiGEPC1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 11:02:27 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0291717040;
        Tue,  5 Jul 2022 08:02:05 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q9so17961048wrd.8;
        Tue, 05 Jul 2022 08:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lC2y6heFTIszSDWCfIFDneSWEpHJYiSq2WiQM7wzmnY=;
        b=MOKOANxSOtxlirWG/N/isvmy1VIyEsi6v+0KsJ485FSPbos+8nR+AMs6DF4MCANC9m
         dL0jTsXbvKsmSmGYO8hzKRQB0nuNaJtigagAKnk4pzyNdAhkjC+U8rhf7J020AfI9lEf
         F2WgSCtoADxMkgIxq1+Ru+gVxk31XQv71+Fde3TMTnY7XnWEvj8zZBAPWlWZTYBQG+3V
         oHDXGwjQwZwZZByb15gKsF3pCRst7DpCM3dZDhsWX1cz8KFI/3UtcRikvI5khV6N8HJM
         96D09dDvqCDx9du+PRp5Y6PXdf//OPGFa3tBmACDAnUMXAIWdPPHNB+dTEpqZah3cgn+
         ng5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lC2y6heFTIszSDWCfIFDneSWEpHJYiSq2WiQM7wzmnY=;
        b=XkcZfT6IFnnZj6l/J5eMJZew8wUkRT/rh5r+5AiQsiQAWrMr2Gm/BB13Fbm4Pp5md7
         w9Swwp6Y0KyvS3d1EQuuKDAfSOCp1NzdAUtWcduk/aQ2AzJFU38tEzah0hSbZBNEnlZs
         0MoexHDMyf2oIMYc6gS+XVXIygvzKuNh/nzmzB6AYJuYDI9kivEnbXH7dvld99d5PQgU
         dbR9QcHmZVNiH0HyXW1my1xtFfN0tX/j4PxxveDWtWCPqbmNYW536/tyuVB3aBHgXKB8
         VI4tOOzC784NDhe9NUdGfnLROkjJJLofWd9/Og8sMu2Loj5/AwRN+mH8vp4Fzecwoc0Z
         SCbQ==
X-Gm-Message-State: AJIora90r0Weh82/dtDzr1TLmTG5k/0MFsjClCyUgnzCuHvIjy2gVSxX
        UTFzmdypzacSFNIyipGdVCVXO259CiC20A==
X-Google-Smtp-Source: AGRyM1vyk37aZ7jDxeoKqJj6qXwBETKD394Mw4M6fvlkmPOliQJkUNnpHAGJPczwkK/+eX9AlSdNbA==
X-Received: by 2002:a5d:58cc:0:b0:21d:6919:7daf with SMTP id o12-20020a5d58cc000000b0021d69197dafmr12176606wrf.434.1657033324881;
        Tue, 05 Jul 2022 08:02:04 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:02:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 14/25] io_uring: cache struct io_notif
Date:   Tue,  5 Jul 2022 16:01:14 +0100
Message-Id: <e31a9d109bfd0cf7926c79ad95a548e905ae033b.1656318994.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656318994.git.asml.silence@gmail.com>
References: <cover.1656318994.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

kmalloc'ing struct io_notif is too expensive when done frequently, cache
them as many other resources in io_uring. Keep two list, the first one
is from where we're getting notifiers, it's protected by ->uring_lock.
The second is protected by ->completion_lock, to which we queue released
notifiers. Then we splice one list into another when needed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  7 +++++
 io_uring/io_uring.c            |  3 ++
 io_uring/notif.c               | 57 +++++++++++++++++++++++++++++-----
 io_uring/notif.h               |  5 +++
 4 files changed, 65 insertions(+), 7 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 26a1504ad24c..0a3fdaa368a4 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -244,6 +244,9 @@ struct io_ring_ctx {
 		struct xarray		io_bl_xa;
 		struct list_head	io_buffers_cache;
 
+		/* struct io_notif cache, protected by uring_lock */
+		struct list_head	notif_list;
+
 		struct io_hash_table	cancel_table_locked;
 		struct list_head	cq_overflow_list;
 		struct list_head	apoll_cache;
@@ -255,6 +258,10 @@ struct io_ring_ctx {
 	struct io_wq_work_list	locked_free_list;
 	unsigned int		locked_free_nr;
 
+	/* struct io_notif cache protected by completion_lock */
+	struct list_head	notif_list_locked;
+	unsigned int		notif_locked_nr;
+
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5fbbdcad14fa..6054e71e6ade 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -318,6 +318,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_WQ_LIST(&ctx->locked_free_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
+	INIT_LIST_HEAD(&ctx->notif_list);
+	INIT_LIST_HEAD(&ctx->notif_list_locked);
 	return ctx;
 err:
 	kfree(ctx->dummy_ubuf);
@@ -2491,6 +2493,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 	WARN_ON_ONCE(ctx->notif_slots || ctx->nr_notif_slots);
 
+	io_notif_cache_purge(ctx);
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
 
diff --git a/io_uring/notif.c b/io_uring/notif.c
index e9e0c5566c4a..ffbd5ce03c36 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -15,10 +15,12 @@ static void __io_notif_complete_tw(struct callback_head *cb)
 
 	io_cq_lock(ctx);
 	io_fill_cqe_aux(ctx, notif->tag, 0, notif->seq);
+
+	list_add(&notif->cache_node, &ctx->notif_list_locked);
+	ctx->notif_locked_nr++;
 	io_cq_unlock_post(ctx);
 
 	percpu_ref_put(&ctx->refs);
-	kfree(notif);
 }
 
 static inline void io_notif_complete(struct io_notif *notif)
@@ -45,21 +47,62 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
 	queue_work(system_unbound_wq, &notif->commit_work);
 }
 
+static void io_notif_splice_cached(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	spin_lock(&ctx->completion_lock);
+	list_splice_init(&ctx->notif_list_locked, &ctx->notif_list);
+	ctx->notif_locked_nr = 0;
+	spin_unlock(&ctx->completion_lock);
+}
+
+void io_notif_cache_purge(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	io_notif_splice_cached(ctx);
+
+	while (!list_empty(&ctx->notif_list)) {
+		struct io_notif *notif = list_first_entry(&ctx->notif_list,
+						struct io_notif, cache_node);
+
+		list_del(&notif->cache_node);
+		kfree(notif);
+	}
+}
+
+static inline bool io_notif_has_cached(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	if (likely(!list_empty(&ctx->notif_list)))
+		return true;
+	if (data_race(READ_ONCE(ctx->notif_locked_nr) <= IO_NOTIF_SPLICE_BATCH))
+		return false;
+	io_notif_splice_cached(ctx);
+	return !list_empty(&ctx->notif_list);
+}
+
 struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
 				struct io_notif_slot *slot)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_notif *notif;
 
-	notif = kzalloc(sizeof(*notif), GFP_ATOMIC | __GFP_ACCOUNT);
-	if (!notif)
-		return NULL;
+	if (likely(io_notif_has_cached(ctx))) {
+		notif = list_first_entry(&ctx->notif_list,
+					 struct io_notif, cache_node);
+		list_del(&notif->cache_node);
+	} else {
+		notif = kzalloc(sizeof(*notif), GFP_ATOMIC | __GFP_ACCOUNT);
+		if (!notif)
+			return NULL;
+		/* pre-initialise some fields */
+		notif->ctx = ctx;
+		notif->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
+		notif->uarg.callback = io_uring_tx_zerocopy_callback;
+	}
 
 	notif->seq = slot->seq++;
 	notif->tag = slot->tag;
-	notif->ctx = ctx;
-	notif->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
-	notif->uarg.callback = io_uring_tx_zerocopy_callback;
 	/* master ref owned by io_notif_slot, will be dropped on flush */
 	refcount_set(&notif->uarg.refcnt, 1);
 	percpu_ref_get(&ctx->refs);
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 3d7a1d242e17..b23c9c0515bb 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -5,6 +5,8 @@
 #include <net/sock.h>
 #include <linux/nospec.h>
 
+#define IO_NOTIF_SPLICE_BATCH	32
+
 struct io_notif {
 	struct ubuf_info	uarg;
 	struct io_ring_ctx	*ctx;
@@ -13,6 +15,8 @@ struct io_notif {
 	u64			tag;
 	/* see struct io_notif_slot::seq */
 	u32			seq;
+	/* hook into ctx->notif_list and ctx->notif_list_locked */
+	struct list_head	cache_node;
 
 	union {
 		struct callback_head	task_work;
@@ -41,6 +45,7 @@ struct io_notif_slot {
 };
 
 int io_notif_unregister(struct io_ring_ctx *ctx);
+void io_notif_cache_purge(struct io_ring_ctx *ctx);
 
 struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
 				struct io_notif_slot *slot);
-- 
2.36.1

