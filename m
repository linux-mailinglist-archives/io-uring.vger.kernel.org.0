Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1138754B398
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349613AbiFNOiQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343850AbiFNOiL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:38:11 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2AC303
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:38:08 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id x6-20020a1c7c06000000b003972dfca96cso4911823wmc.4
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bsOgLB7d4Bz4URPvlQh5dv2DDF4WMnAM31PCgutwcLw=;
        b=NuSyeyulg6Y2OZ/wQmbQWmsij9CuU4jYGYR2cxpLfiKTUosFVoDN4qaJCC6KNo717F
         sYJZa/AY+v12GgnvBn4GOAb2Ay4zOx5/auQN9lB6FwCSulkaZmro3XvO+fXMAOFlDEsu
         VbAGjCOwDRiUuvM+82NWhEABb9O1L2QXMYMwp3Pe6wLhLVkTrgGwEW7VCMJTnZK1Raom
         dBynjR0S/yNPH2rECLkse5qeSzmenL7wr/ciUK76zOWH3drGqbUntCX7//2mk4OAzmao
         9/H3Ii7oIdOQJ3gpZSTyGJO0fvbnLzmPuwN2o7Sakhx0zXhSkyXQyBIE5nteEZD/9TGM
         NLBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bsOgLB7d4Bz4URPvlQh5dv2DDF4WMnAM31PCgutwcLw=;
        b=vs07PWXE/ylujSODn8/BJnTi6ND3qcQQk4J1jOC7LcF5Rm2XlxCzWXfUQgy6riHkTe
         bXqualYGrNG73B9uLIbrrIT8wJYFDRoHszmyaH4CEXZ1NxlP/S4nwdNSTCkZYWz5X454
         huqLV0Kg1I5Y3/TFlVWgAltVK4Sl9o+VdgqwOsyQhyl0OMYGIMF3DNje8Nx4XgX9FZkA
         rSOa1rTzygi9YDYq4gcSJzdaEBQq/ZEMYau/mvRx+FHYhtnOR4eWKDnxdz05Lmiab6qh
         c04pAEi0K8KopEn1Fm3uHYZHwV/raSByG75n734nXNVvaQedrbYqWZB6wAv2vqISe0vv
         TH2A==
X-Gm-Message-State: AOAM533QAn+POha+/sbUUF/l1n+kR95IWr3x5uos0/Zdps73GhYSeviv
        j7SulowFbJ4ToQKOVRZV8cQCXJixqtkgGA==
X-Google-Smtp-Source: ABdhPJw7LkJzdukd5+j5VI2QcQtBkYsZPTDlaznajNdIT54+A9rkYF9n8su+Iap9vf2m3Enem4KPiA==
X-Received: by 2002:a1c:4c0d:0:b0:39c:5233:1873 with SMTP id z13-20020a1c4c0d000000b0039c52331873mr4584737wmf.28.1655217486224;
        Tue, 14 Jun 2022 07:38:06 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:38:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 23/25] io_uring: introduce a struct for hash table
Date:   Tue, 14 Jun 2022 15:37:13 +0100
Message-Id: <3ec530d62e0efac1e50daacaf00c31c2e4a5a48b.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
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

Instead of passing around a pointer to hash buckets, add a bit of type
safety and wrap it into a structure.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/cancel.c         |  6 +++---
 io_uring/cancel.h         |  7 +------
 io_uring/fdinfo.c         |  4 ++--
 io_uring/io_uring.c       | 29 ++++++++++++++++------------
 io_uring/io_uring_types.h | 13 +++++++++++--
 io_uring/poll.c           | 40 +++++++++++++++++++++------------------
 6 files changed, 56 insertions(+), 43 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index a253e2ad22eb..f28f0a7d1272 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -193,12 +193,12 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-void init_hash_table(struct io_hash_bucket *hash_table, unsigned size)
+void init_hash_table(struct io_hash_table *table, unsigned size)
 {
 	unsigned int i;
 
 	for (i = 0; i < size; i++) {
-		spin_lock_init(&hash_table[i].lock);
-		INIT_HLIST_HEAD(&hash_table[i].list);
+		spin_lock_init(&table->hbs[i].lock);
+		INIT_HLIST_HEAD(&table->hbs[i].list);
 	}
 }
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 556a7dcf160e..fd4cb1a2595d 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -4,9 +4,4 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd);
-void init_hash_table(struct io_hash_bucket *hash_table, unsigned size);
-
-struct io_hash_bucket {
-	spinlock_t		lock;
-	struct hlist_head	list;
-} ____cacheline_aligned_in_smp;
+void init_hash_table(struct io_hash_table *table, unsigned size);
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index f941c73f5502..344e7d90d557 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -158,8 +158,8 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 		mutex_unlock(&ctx->uring_lock);
 
 	seq_puts(m, "PollList:\n");
-	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
-		struct io_hash_bucket *hb = &ctx->cancel_hash[i];
+	for (i = 0; i < (1U << ctx->cancel_table.hash_bits); i++) {
+		struct io_hash_bucket *hb = &ctx->cancel_table.hbs[i];
 		struct io_kiocb *req;
 
 		spin_lock(&hb->lock);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4b90439808e3..4bead16e57f7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -697,11 +697,23 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 	percpu_ref_put(&ctx->refs);
 }
 
+static int io_alloc_hash_table(struct io_hash_table *table, unsigned bits)
+{
+	unsigned hash_buckets = 1U << bits;
+	size_t hash_size = hash_buckets * sizeof(table->hbs[0]);
+
+	table->hbs = kmalloc(hash_size, GFP_KERNEL);
+	if (!table->hbs)
+		return -ENOMEM;
+
+	table->hash_bits = bits;
+	init_hash_table(table, hash_buckets);
+	return 0;
+}
+
 static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
 	struct io_ring_ctx *ctx;
-	unsigned hash_buckets;
-	size_t hash_size;
 	int hash_bits;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
@@ -717,16 +729,9 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	 */
 	hash_bits = ilog2(p->cq_entries) - 5;
 	hash_bits = clamp(hash_bits, 1, 8);
-	hash_buckets = 1U << hash_bits;
-	hash_size = hash_buckets * sizeof(struct io_hash_bucket);
-
-	ctx->cancel_hash_bits = hash_bits;
-	ctx->cancel_hash = kmalloc(hash_size, GFP_KERNEL);
-	if (!ctx->cancel_hash)
+	if (io_alloc_hash_table(&ctx->cancel_table, hash_bits))
 		goto err;
 
-	init_hash_table(ctx->cancel_hash, hash_buckets);
-
 	ctx->dummy_ubuf = kzalloc(sizeof(*ctx->dummy_ubuf), GFP_KERNEL);
 	if (!ctx->dummy_ubuf)
 		goto err;
@@ -767,7 +772,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	return ctx;
 err:
 	kfree(ctx->dummy_ubuf);
-	kfree(ctx->cancel_hash);
+	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
@@ -3050,7 +3055,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_req_caches_free(ctx);
 	if (ctx->hash_map)
 		io_wq_put_hash(ctx->hash_map);
-	kfree(ctx->cancel_hash);
+	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->dummy_ubuf);
 	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
index f6d0ad25f377..ce2fbe6749bb 100644
--- a/io_uring/io_uring_types.h
+++ b/io_uring/io_uring_types.h
@@ -7,6 +7,16 @@
 #include "io-wq.h"
 #include "filetable.h"
 
+struct io_hash_bucket {
+	spinlock_t		lock;
+	struct hlist_head	list;
+} ____cacheline_aligned_in_smp;
+
+struct io_hash_table {
+	struct io_hash_bucket	*hbs;
+	unsigned		hash_bits;
+};
+
 struct io_uring {
 	u32 head ____cacheline_aligned_in_smp;
 	u32 tail ____cacheline_aligned_in_smp;
@@ -222,8 +232,7 @@ struct io_ring_ctx {
 		 * manipulate the list, hence no extra locking is needed there.
 		 */
 		struct io_wq_work_list	iopoll_list;
-		struct io_hash_bucket	*cancel_hash;
-		unsigned		cancel_hash_bits;
+		struct io_hash_table	cancel_table;
 		bool			poll_multi_queue;
 
 		struct list_head	io_buffers_comp;
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 5cc03be365e3..9c7793f5e93b 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -73,9 +73,9 @@ static struct io_poll *io_poll_get_single(struct io_kiocb *req)
 
 static void io_poll_req_insert(struct io_kiocb *req)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-	u32 index = hash_long(req->cqe.user_data, ctx->cancel_hash_bits);
-	struct io_hash_bucket *hb = &ctx->cancel_hash[index];
+	struct io_hash_table *table = &req->ctx->cancel_table;
+	u32 index = hash_long(req->cqe.user_data, table->hash_bits);
+	struct io_hash_bucket *hb = &table->hbs[index];
 
 	spin_lock(&hb->lock);
 	hlist_add_head(&req->hash_node, &hb->list);
@@ -84,8 +84,9 @@ static void io_poll_req_insert(struct io_kiocb *req)
 
 static void io_poll_req_delete(struct io_kiocb *req, struct io_ring_ctx *ctx)
 {
-	u32 index = hash_long(req->cqe.user_data, ctx->cancel_hash_bits);
-	spinlock_t *lock = &ctx->cancel_hash[index].lock;
+	struct io_hash_table *table = &req->ctx->cancel_table;
+	u32 index = hash_long(req->cqe.user_data, table->hash_bits);
+	spinlock_t *lock = &table->hbs[index].lock;
 
 	spin_lock(lock);
 	hash_del(&req->hash_node);
@@ -533,13 +534,15 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 			       bool cancel_all)
 {
+	struct io_hash_table *table = &ctx->cancel_table;
+	unsigned nr_buckets = 1U << table->hash_bits;
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
 	bool found = false;
 	int i;
 
-	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
-		struct io_hash_bucket *hb = &ctx->cancel_hash[i];
+	for (i = 0; i < nr_buckets; i++) {
+		struct io_hash_bucket *hb = &table->hbs[i];
 
 		spin_lock(&hb->lock);
 		hlist_for_each_entry_safe(req, tmp, &hb->list, hash_node) {
@@ -556,12 +559,12 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 
 static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 				     struct io_cancel_data *cd,
-				     struct io_hash_bucket hash_table[],
+				     struct io_hash_table *table,
 				     struct io_hash_bucket **out_bucket)
 {
 	struct io_kiocb *req;
-	u32 index = hash_long(cd->data, ctx->cancel_hash_bits);
-	struct io_hash_bucket *hb = &hash_table[index];
+	u32 index = hash_long(cd->data, table->hash_bits);
+	struct io_hash_bucket *hb = &table->hbs[index];
 
 	*out_bucket = NULL;
 
@@ -585,16 +588,17 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 
 static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 					  struct io_cancel_data *cd,
-					  struct io_hash_bucket hash_table[],
+					  struct io_hash_table *table,
 					  struct io_hash_bucket **out_bucket)
 {
+	unsigned nr_buckets = 1U << table->hash_bits;
 	struct io_kiocb *req;
 	int i;
 
 	*out_bucket = NULL;
 
-	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
-		struct io_hash_bucket *hb = &hash_table[i];
+	for (i = 0; i < nr_buckets; i++) {
+		struct io_hash_bucket *hb = &table->hbs[i];
 
 		spin_lock(&hb->lock);
 		hlist_for_each_entry(req, &hb->list, hash_node) {
@@ -622,15 +626,15 @@ static bool io_poll_disarm(struct io_kiocb *req)
 }
 
 static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
-			    struct io_hash_bucket hash_table[])
+			    struct io_hash_table *table)
 {
 	struct io_hash_bucket *bucket;
 	struct io_kiocb *req;
 
 	if (cd->flags & (IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_ANY))
-		req = io_poll_file_find(ctx, cd, ctx->cancel_hash, &bucket);
+		req = io_poll_file_find(ctx, cd, table, &bucket);
 	else
-		req = io_poll_find(ctx, false, cd, ctx->cancel_hash, &bucket);
+		req = io_poll_find(ctx, false, cd, table, &bucket);
 
 	if (req)
 		io_poll_cancel_req(req);
@@ -641,7 +645,7 @@ static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 
 int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 {
-	return __io_poll_cancel(ctx, cd, ctx->cancel_hash);
+	return __io_poll_cancel(ctx, cd, &ctx->cancel_table);
 }
 
 static __poll_t io_poll_parse_events(const struct io_uring_sqe *sqe,
@@ -739,7 +743,7 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	int ret2, ret = 0;
 	bool locked;
 
-	preq = io_poll_find(ctx, true, &cd, ctx->cancel_hash, &bucket);
+	preq = io_poll_find(ctx, true, &cd, &ctx->cancel_table, &bucket);
 	if (preq)
 		ret2 = io_poll_disarm(preq);
 	if (bucket)
-- 
2.36.1

