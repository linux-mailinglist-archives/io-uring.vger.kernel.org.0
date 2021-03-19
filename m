Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544D634234E
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 18:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhCSR1H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 13:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhCSR07 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 13:26:59 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1359FC06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:59 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id z2so9889231wrl.5
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KRgDNqLwVqNIR3OONrC7vTxvacq/9uZCAmTGK9xRFns=;
        b=k/npuGL/kv69b3Ov3NT+BMJHTkB4HC2JGkXyRIvaxnMxYRbqBK0UOPosv2DzxwkeEu
         G8qZ0yF0B/02zoYWz3/Mp7grmsH/1mwNkoaGchK8fUTD9t2k1IJpxZHVLyolbxYLOSw+
         2iihHVj8TizbSbXTm0ekKFgMe5PkJlrgtJNx5Gb+LaVoyrrujhhgMu3cMQBDFwAec3mU
         CK9oZ3WnUhawoWmJXL1/66nTUEQ9gazSx7Jc8ffmIXfr+ik+xPvc+7p0hsQ0IyukTs3z
         t/qyk8cqemaIMFT5Ab993KGIw8hY9t7cNYgmW1ort2bh5LSo0YY9k2ZMLov9b84o6Yrt
         HxCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KRgDNqLwVqNIR3OONrC7vTxvacq/9uZCAmTGK9xRFns=;
        b=lm2vYrTVq8SrxYld9TBC60mAG4i57cpknvPJO3Ay5VmQjeeGb1O1LstALNJzMUKIXU
         UUpxlL4dlCUqYTB3zFs9wIqMAfsYk8g5Ozb/5n8jZHd0vuqABJgLxQGcpf0PnEXxnClL
         lTPgKpLVDDH0JdxGjjxy6e1PYCJrPRjVtCdHmyIu2bvPdZQHSPDfg2H9AC+qtUyoaZQM
         CnZM4G+7izRqsiaKRJq7LA/gOH3czhH8GrxcbTN76020YuB3AROYxS1V6k6gDXW7/u9Q
         G6Yl4adbHAIbVd6FHvL7g39eTTfRE6ylm2/DzlaTb8u9U/ynkDLmGBD/Q3OWFGd7HteV
         pk9A==
X-Gm-Message-State: AOAM5312xaY3MfRRiJQDKAzSIL8Nmrs7t12wlasUYmKJCPP1f2XwRBrM
        agg119FR9cf4rwms1zfylYo=
X-Google-Smtp-Source: ABdhPJypLUi05dcViZ13ERy01ShkY3lRavPTb4U7ragV36NEf2tI+SL4KakryqEmnBFPraZ/9XKJaw==
X-Received: by 2002:adf:f9d0:: with SMTP id w16mr5803503wrr.336.1616174817894;
        Fri, 19 Mar 2021 10:26:57 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id i8sm7112943wmi.6.2021.03.19.10.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:26:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/16] io_uring: refactor rsrc refnode allocation
Date:   Fri, 19 Mar 2021 17:22:36 +0000
Message-Id: <5c10fb87c2dff21e23d40e11904f6d3e1c62d277.1616167719.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616167719.git.asml.silence@gmail.com>
References: <cover.1616167719.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are two problems:
1) we always allocate refnodes in advance and free them if those
haven't been used. It's expensive, takes two allocations, where one of
them is percpu. And it may be pretty common not actually using them.

2) Current API with allocating a refnode and setting some of the fields
is error prone, we don't ever want to have a file node runninng fixed
buffer callback...

Solve both with pre-init/get API. Pre-init just leaves the node for
later if not used, and for get (i.e. io_rsrc_refnode_get()), you need to
explicitly pass all arguments setting callbacks/etc., so it's more
resilient.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 58 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e4c92498a0af..6655246287f3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -443,6 +443,7 @@ struct io_ring_ctx {
 	struct llist_head		rsrc_put_llist;
 	struct list_head		rsrc_ref_list;
 	spinlock_t			rsrc_ref_lock;
+	struct fixed_rsrc_ref_node	*rsrc_backup_node;
 
 	struct io_restriction		restrictions;
 
@@ -7021,12 +7022,36 @@ static void io_sqe_rsrc_kill_node(struct io_ring_ctx *ctx, struct fixed_rsrc_dat
 		percpu_ref_kill(&ref_node->refs);
 }
 
+static int io_rsrc_refnode_prealloc(struct io_ring_ctx *ctx)
+{
+	if (ctx->rsrc_backup_node)
+		return 0;
+	ctx->rsrc_backup_node = alloc_fixed_rsrc_ref_node(ctx);
+	return ctx->rsrc_backup_node ? 0 : -ENOMEM;
+}
+
+static struct fixed_rsrc_ref_node *
+io_rsrc_refnode_get(struct io_ring_ctx *ctx,
+		    struct fixed_rsrc_data *rsrc_data,
+		    void (*rsrc_put)(struct io_ring_ctx *ctx,
+		                     struct io_rsrc_put *prsrc))
+{
+	struct fixed_rsrc_ref_node *node = ctx->rsrc_backup_node;
+
+	WARN_ON_ONCE(!node);
+
+	ctx->rsrc_backup_node = NULL;
+	node->rsrc_data = rsrc_data;
+	node->rsrc_put = rsrc_put;
+	return node;
+}
+
 static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 			       struct io_ring_ctx *ctx,
 			       void (*rsrc_put)(struct io_ring_ctx *ctx,
 			                        struct io_rsrc_put *prsrc))
 {
-	struct fixed_rsrc_ref_node *backup_node;
+	struct fixed_rsrc_ref_node *node;
 	int ret;
 
 	if (data->quiesce)
@@ -7034,13 +7059,9 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 
 	data->quiesce = true;
 	do {
-		ret = -ENOMEM;
-		backup_node = alloc_fixed_rsrc_ref_node(ctx);
-		if (!backup_node)
+		ret = io_rsrc_refnode_prealloc(ctx);
+		if (ret)
 			break;
-		backup_node->rsrc_data = data;
-		backup_node->rsrc_put = rsrc_put;
-
 		io_sqe_rsrc_kill_node(ctx, data);
 		percpu_ref_kill(&data->refs);
 		flush_delayed_work(&ctx->rsrc_put_work);
@@ -7050,17 +7071,16 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 			break;
 
 		percpu_ref_resurrect(&data->refs);
-		io_sqe_rsrc_set_node(ctx, data, backup_node);
-		backup_node = NULL;
+		node = io_rsrc_refnode_get(ctx, data, rsrc_put);
+		io_sqe_rsrc_set_node(ctx, data, node);
 		reinit_completion(&data->done);
+
 		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig();
 		mutex_lock(&ctx->uring_lock);
 	} while (ret >= 0);
 	data->quiesce = false;
 
-	if (backup_node)
-		destroy_fixed_rsrc_ref_node(backup_node);
 	return ret;
 }
 
@@ -7711,11 +7731,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		return -EOVERFLOW;
 	if (done > ctx->nr_user_files)
 		return -EINVAL;
-
-	ref_node = alloc_fixed_rsrc_ref_node(ctx);
-	if (!ref_node)
-		return -ENOMEM;
-	init_fixed_file_ref_node(ctx, ref_node);
+	err = io_rsrc_refnode_prealloc(ctx);
+	if (err)
+		return err;
 
 	fds = u64_to_user_ptr(up->data);
 	for (done = 0; done < nr_args; done++) {
@@ -7768,10 +7786,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
+		ref_node = io_rsrc_refnode_get(ctx, data, io_ring_file_put);
 		io_sqe_rsrc_set_node(ctx, data, ref_node);
-	} else
-		destroy_fixed_rsrc_ref_node(ref_node);
-
+	}
 	return done ? done : err;
 }
 
@@ -8447,6 +8464,9 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
 
+	if (ctx->rsrc_backup_node)
+		destroy_fixed_rsrc_ref_node(ctx->rsrc_backup_node);
+
 #if defined(CONFIG_UNIX)
 	if (ctx->ring_sock) {
 		ctx->ring_sock->file = NULL; /* so that iput() is called */
-- 
2.24.0

