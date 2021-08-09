Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9B43E453E
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbhHIMFi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbhHIMFh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:37 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A24C061798
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:17 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q11so2882308wrr.9
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=d9zE3XesUgxfrdiQY/5s7PLgHEUuv/iJnS1wTjojRbI=;
        b=i7gMnXQF232YHJHd/TUvemZHA1vdhUAiVSpxJkaRlbOML05LNBuyhv/UttPLpZkW8b
         4ljwha13KXMvJJDAazNvrqTlcMBj/jSAHnmk849HP8beaUfc7ODvZngKEm3hB/y6WuvI
         1ZFw597II9Fjc3kopWDMwYC80qgorbay/KLog/53ukhSmPEMKwEZbwXjloWvj9IxqwbK
         0IX2M7USSgNnvsmoPHjsojSgjbQXVZDJjU3Jkq+TOu1Ghlj8DPAlZy3HIRRRULrmqNjC
         CojC4ANUfTcEk4LC0i9GYDjVKry70rpcgSk1WcWen+WDybPMp/AN9L2+mVWcOB7eB9JD
         AQmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d9zE3XesUgxfrdiQY/5s7PLgHEUuv/iJnS1wTjojRbI=;
        b=RvqJN9yhKCUS7crQM51Zy6LOpBpXuIj3hKzirRw8d4FwWrLOkOPmT8xmDhWOhhJZuP
         j4mAaakx0z+6h69vHeuMSE4NdJ/ythmJxMQGBGESkdBNdUWlar02oMWqGCcwKMHdrsow
         uTfKTU8K9oUZT5nr9ql6CVVldR1mAIudQBD7Yvo8aGzXAJ73t+karECXRQ+lMLZxgghl
         SUUaWGRcldBl62zvcVm4zHmsQIntrjOsTlzSokEnShWYDlNImWyas5U62+dkZ/pF8TGQ
         4chGQS7+dZC9LAJH0Y5F9ywpH2bAv3W+oQ8dMoP4SXlj4V9D4y65FSOlonPFRIrhQy2i
         LPsQ==
X-Gm-Message-State: AOAM533bJrxHOVpdwlcIuBK7Roiuncw+i+mMxgEXkLoxQh1C0re8//8/
        K53yRS2GLN3ViS1N3KimvVg63rlw3hE=
X-Google-Smtp-Source: ABdhPJwVyp0Lbx5sVgktSr2tDOJ4a1WwI4xPBrGiKXXL7KgdNi/mJ9S5TArspoieeqBU/YEpXoCusw==
X-Received: by 2002:a5d:6451:: with SMTP id d17mr7560156wrw.154.1628510715945;
        Mon, 09 Aug 2021 05:05:15 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 14/28] io_uring: move io_rsrc_node_alloc() definition
Date:   Mon,  9 Aug 2021 13:04:14 +0100
Message-Id: <4d81f6f833e7d017860b24463a9a68b14a8a5ed2.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move the function together with io_rsrc_node_ref_zero() in the source
file as it is to get rid of forward declarations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 87 +++++++++++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 44 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fc778724acd5..1237e6e87ff2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1044,7 +1044,6 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 bool cancel_all);
 static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
-static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
 
 static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
 				 long res, unsigned int cflags);
@@ -7169,6 +7168,49 @@ static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
 	kfree(ref_node);
 }
 
+static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
+{
+	struct io_rsrc_node *node = container_of(ref, struct io_rsrc_node, refs);
+	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
+	bool first_add = false;
+
+	io_rsrc_ref_lock(ctx);
+	node->done = true;
+
+	while (!list_empty(&ctx->rsrc_ref_list)) {
+		node = list_first_entry(&ctx->rsrc_ref_list,
+					    struct io_rsrc_node, node);
+		/* recycle ref nodes in order */
+		if (!node->done)
+			break;
+		list_del(&node->node);
+		first_add |= llist_add(&node->llist, &ctx->rsrc_put_llist);
+	}
+	io_rsrc_ref_unlock(ctx);
+
+	if (first_add)
+		mod_delayed_work(system_wq, &ctx->rsrc_put_work, HZ);
+}
+
+static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
+{
+	struct io_rsrc_node *ref_node;
+
+	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
+	if (!ref_node)
+		return NULL;
+
+	if (percpu_ref_init(&ref_node->refs, io_rsrc_node_ref_zero,
+			    0, GFP_KERNEL)) {
+		kfree(ref_node);
+		return NULL;
+	}
+	INIT_LIST_HEAD(&ref_node->node);
+	INIT_LIST_HEAD(&ref_node->rsrc_list);
+	ref_node->done = false;
+	return ref_node;
+}
+
 static void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 				struct io_rsrc_data *data_to_kill)
 {
@@ -7681,49 +7723,6 @@ static void io_rsrc_put_work(struct work_struct *work)
 	}
 }
 
-static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
-{
-	struct io_rsrc_node *node = container_of(ref, struct io_rsrc_node, refs);
-	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
-	bool first_add = false;
-
-	io_rsrc_ref_lock(ctx);
-	node->done = true;
-
-	while (!list_empty(&ctx->rsrc_ref_list)) {
-		node = list_first_entry(&ctx->rsrc_ref_list,
-					    struct io_rsrc_node, node);
-		/* recycle ref nodes in order */
-		if (!node->done)
-			break;
-		list_del(&node->node);
-		first_add |= llist_add(&node->llist, &ctx->rsrc_put_llist);
-	}
-	io_rsrc_ref_unlock(ctx);
-
-	if (first_add)
-		mod_delayed_work(system_wq, &ctx->rsrc_put_work, HZ);
-}
-
-static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
-{
-	struct io_rsrc_node *ref_node;
-
-	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
-	if (!ref_node)
-		return NULL;
-
-	if (percpu_ref_init(&ref_node->refs, io_rsrc_node_ref_zero,
-			    0, GFP_KERNEL)) {
-		kfree(ref_node);
-		return NULL;
-	}
-	INIT_LIST_HEAD(&ref_node->node);
-	INIT_LIST_HEAD(&ref_node->rsrc_list);
-	ref_node->done = false;
-	return ref_node;
-}
-
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 				 unsigned nr_args, u64 __user *tags)
 {
-- 
2.32.0

