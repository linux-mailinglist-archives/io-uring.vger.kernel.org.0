Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B14835B10E
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 02:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234945AbhDKAvT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 20:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbhDKAvT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 20:51:19 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F03C06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:03 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id g18-20020a7bc4d20000b0290116042cfdd8so6671167wmk.4
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=iYskV1jhr/lvYvhYixl6Sgxmmk7vOzRS+S2jyYJvaGY=;
        b=MekDcoxJAY9JfZYqESVbBfWUeUcePK7TZ5lcCT1NKGmDlguWqbaNc4LTqSYc4IHHN1
         5Xb9mypAQOld9bDVdlBJPykdh2OgioCWDNSz32ElZYoFNgKrEj+uX88kxqL5Hm3KZ/Kb
         lT7McpUIAsy6+vabjBf3l7b4MyoTtVAOLhYSLbjKuPmisRtMBLEFOeov9KXGEEawjWTa
         mQ/e9ae80vxRJFBhKltFnSe8a/kzf+ok1H2FiQ5mxxQPxLAmLnICkdxIX175FMnV98LJ
         m/N16eJifi/q2jsGTmkRM0iKD43vLdZ5VW0pcAqCVspZ2diUkeUYgMUrjhri2wMFe8Y9
         b1uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iYskV1jhr/lvYvhYixl6Sgxmmk7vOzRS+S2jyYJvaGY=;
        b=S+corsCJmFez7pZS1I/rd9U6qLzLtC16W457i0C8I1GBFj1pb8jCnGsOAmSrk8TjQK
         W3OKgYKjWsAC4Rn+CW0JzAy/PB2iFMMvD1CqrjzkVDcv5THjQNDVrrLRGNo0pKls5hGk
         QCcqzr2YMM5fffFicj3RCRL/pTITH32H1FLAg5PaIqZSBFor3C4YBZpG05JNAm+AEUBb
         3rmSdatwBALQCOrO9CZjo/CZTn+1H/UyChiGy1YH94xuOglrjCsrqV1PCRG4FuJgO5fN
         Cg3GBIPsUbxaYLQzRZYOQlo8h/7VV98nVR1ucq4hAAFLNk3hB7+ZReAq5fyl/XuKWUHi
         Prpg==
X-Gm-Message-State: AOAM531o8ckV+0iv0O8+dcS72micE9JAKD5jAkq+puQmVUTtTpbzg669
        7hHSIf7l1XTvU3zS1voIqj8=
X-Google-Smtp-Source: ABdhPJylVry1lmZ39RPRld52Mmyzr8yXoPoWe66Bymu5JiQtghPFE/nQAyWOghcOKRhC/2yrg+lg0w==
X-Received: by 2002:a1c:6709:: with SMTP id b9mr7248666wmc.56.1618102262460;
        Sat, 10 Apr 2021 17:51:02 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id y20sm9204735wma.45.2021.04.10.17.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 17:51:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/16] io_uring: simplify io_rsrc_data refcounting
Date:   Sun, 11 Apr 2021 01:46:34 +0100
Message-Id: <1551d90f7c9b183cf2f0d7b5e5b923430acb03fa.1618101759.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618101759.git.asml.silence@gmail.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't take many references of struct io_rsrc_data, only one per each
io_rsrc_node, so using percpu refs is overkill. Use atomic ref instead,
which is much simpler.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 48 ++++++++++++++++--------------------------------
 1 file changed, 16 insertions(+), 32 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a8d6ea1ecd2d..143afe827cad 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -240,7 +240,7 @@ struct io_rsrc_data {
 	struct io_ring_ctx		*ctx;
 
 	rsrc_put_fn			*do_put;
-	struct percpu_ref		refs;
+	atomic_t			refs;
 	struct completion		done;
 	bool				quiesce;
 };
@@ -7082,13 +7082,6 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 #endif
 }
 
-static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
-{
-	struct io_rsrc_data *data = container_of(ref, struct io_rsrc_data, refs);
-
-	complete(&data->done);
-}
-
 static inline void io_rsrc_ref_lock(struct io_ring_ctx *ctx)
 {
 	spin_lock_bh(&ctx->rsrc_ref_lock);
@@ -7119,7 +7112,7 @@ static void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 		list_add_tail(&rsrc_node->node, &ctx->rsrc_ref_list);
 		io_rsrc_ref_unlock(ctx);
 
-		percpu_ref_get(&data_to_kill->refs);
+		atomic_inc(&data_to_kill->refs);
 		percpu_ref_kill(&rsrc_node->refs);
 		ctx->rsrc_node = NULL;
 	}
@@ -7153,14 +7146,17 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ct
 			break;
 		io_rsrc_node_switch(ctx, data);
 
-		percpu_ref_kill(&data->refs);
+		/* kill initial ref, already quiesced if zero */
+		if (atomic_dec_and_test(&data->refs))
+			break;
 		flush_delayed_work(&ctx->rsrc_put_work);
-
 		ret = wait_for_completion_interruptible(&data->done);
 		if (!ret)
 			break;
 
-		percpu_ref_resurrect(&data->refs);
+		atomic_inc(&data->refs);
+		/* wait for all works potentially completing data->done */
+		flush_delayed_work(&ctx->rsrc_put_work);
 		reinit_completion(&data->done);
 
 		mutex_unlock(&ctx->uring_lock);
@@ -7181,23 +7177,13 @@ static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx,
 	if (!data)
 		return NULL;
 
-	if (percpu_ref_init(&data->refs, io_rsrc_data_ref_zero,
-			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
-		kfree(data);
-		return NULL;
-	}
+	atomic_set(&data->refs, 1);
 	data->ctx = ctx;
 	data->do_put = do_put;
 	init_completion(&data->done);
 	return data;
 }
 
-static void io_rsrc_data_free(struct io_rsrc_data *data)
-{
-	percpu_ref_exit(&data->refs);
-	kfree(data);
-}
-
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 	struct io_rsrc_data *data = ctx->file_data;
@@ -7211,7 +7197,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 
 	__io_sqe_files_unregister(ctx);
 	io_free_file_tables(data, ctx->nr_user_files);
-	io_rsrc_data_free(data);
+	kfree(data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
 	return 0;
@@ -7544,7 +7530,8 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 	}
 
 	io_rsrc_node_destroy(ref_node);
-	percpu_ref_put(&rsrc_data->refs);
+	if (atomic_dec_and_test(&rsrc_data->refs))
+		complete(&rsrc_data->done);
 }
 
 static void io_rsrc_put_work(struct work_struct *work)
@@ -7568,10 +7555,8 @@ static void io_rsrc_put_work(struct work_struct *work)
 static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 {
 	struct io_rsrc_node *node = container_of(ref, struct io_rsrc_node, refs);
-	struct io_rsrc_data *data = node->rsrc_data;
-	struct io_ring_ctx *ctx = data->ctx;
+	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
 	bool first_add = false;
-	int delay;
 
 	io_rsrc_ref_lock(ctx);
 	node->done = true;
@@ -7587,9 +7572,8 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 	}
 	io_rsrc_ref_unlock(ctx);
 
-	delay = percpu_ref_is_dying(&data->refs) ? 0 : HZ;
-	if (first_add || !delay)
-		mod_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
+	if (first_add)
+		mod_delayed_work(system_wq, &ctx->rsrc_put_work, HZ);
 }
 
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
@@ -7684,7 +7668,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	io_free_file_tables(file_data, nr_args);
 	ctx->nr_user_files = 0;
 out_free:
-	io_rsrc_data_free(ctx->file_data);
+	kfree(ctx->file_data);
 	ctx->file_data = NULL;
 	return ret;
 }
-- 
2.24.0

