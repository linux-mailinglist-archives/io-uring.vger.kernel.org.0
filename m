Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B8D2F82B3
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 18:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729435AbhAORmT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 12:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbhAORmT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 12:42:19 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77F0C061794
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:38 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id r4so8290983wmh.5
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=CxKgbvv1FQoZNwPFJj7WbYTILYig6gN7xjICp/UyWjA=;
        b=hrC/OSPvo/lWAZMLSR0fVshn0pd9qbtDjQlWtY+OeesuRyxDh2M+wE68XXSzuMZEGT
         1cDcL8LifT8DL5f0Ra/pCLhZqiAmAYZXTes/zRar4OvsxXQOAgQUIldJybuwvIk5vaAZ
         j5H3GbgecWXVbWrH9zNoz1ED4GPGI0a7sZqBDJH2AomIT/avQSpJvotexD0vTpHpDtQq
         sww2TPT3wjxt9YRJ0EbViqvLruLbzoM35vHV4cpGcdopY6AerZCAtae5KC+HvoN3WCam
         owsVf1bP3mpzfsPOu4MrBn5obCvNa6o5ziA+ZK70otT7KIwVzPRNhEAwR30P32BPkumx
         sFng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CxKgbvv1FQoZNwPFJj7WbYTILYig6gN7xjICp/UyWjA=;
        b=MwsUacZytaAd40FLJ7cx6kwcFc7q9MYE+1yj5008/tZ6gcOWjyoNeNEYFFtAPlnSsk
         SmB7QETb/bbqEEyUvrY6MHYCRLn2T0KhKN6baIOM5U9o7aARBk2uM02W+Iel05BUitfA
         v7MFW7OMzR19SUgIoO9jU6VYhOGs5nZdoiChlSVbFAAJxqFF5qUfS4Tq3IAh8meCqKnT
         aX3BzEGQhXpHmEqVR5RHgiy7mapxMH1frJritjvmM+MlpCktN9YLALgLZ2xFduNlplIz
         BP/Gf6N6RjTzcRSpt0ja+O/WL1n7ntN/n5bxoA/UuGbwPvESzccF18UjdQgLG1X/LFvB
         tWvA==
X-Gm-Message-State: AOAM533Ly+QG0++daHMam4N2/RbJaEsFBX57HA8d2bvV1RJ2bGGwAX+Y
        sG8Dlqct2gvKkuCwatDY+eYNH6eb9XE=
X-Google-Smtp-Source: ABdhPJzizW9R0AxBp1vhbTnVCK8+Hf9eyyK/V6aWP4SYGNZHphabvjxn6/AEcjCwjvB6lVQM2379SQ==
X-Received: by 2002:a7b:c018:: with SMTP id c24mr8656339wmb.41.1610732497549;
        Fri, 15 Jan 2021 09:41:37 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id f7sm2060426wmg.43.2021.01.15.09.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 09:41:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [PATCH 3/9] io_uring: separate ref_list from fixed_rsrc_data
Date:   Fri, 15 Jan 2021 17:37:46 +0000
Message-Id: <9eccb46dee6c4f3e24d0790389f216856edf8763.1610729503.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610729502.git.asml.silence@gmail.com>
References: <cover.1610729502.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>

Uplevel ref_list and make it common to all resources.  This is to
allow one common ref_list to be used for both files, and buffers
in upcoming patches.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 35b4440ca7f0..b46710e88c35 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -227,8 +227,6 @@ struct fixed_rsrc_data {
 	struct fixed_rsrc_ref_node	*node;
 	struct percpu_ref		refs;
 	struct completion		done;
-	struct list_head		ref_list;
-	spinlock_t			lock;
 };
 
 struct io_buffer {
@@ -396,6 +394,8 @@ struct io_ring_ctx {
 
 	struct delayed_work		rsrc_put_work;
 	struct llist_head		rsrc_put_llist;
+	struct list_head		rsrc_ref_list;
+	spinlock_t			rsrc_ref_lock;
 
 	struct work_struct		exit_work;
 	struct io_restriction		restrictions;
@@ -1324,6 +1324,8 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	spin_lock_init(&ctx->inflight_lock);
 	INIT_LIST_HEAD(&ctx->inflight_list);
+	spin_lock_init(&ctx->rsrc_ref_lock);
+	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
 	init_llist_head(&ctx->rsrc_put_llist);
 	return ctx;
@@ -7272,13 +7274,14 @@ static void io_rsrc_ref_kill(struct percpu_ref *ref)
 	complete(&data->done);
 }
 
-static void io_sqe_rsrc_set_node(struct fixed_rsrc_data *rsrc_data,
+static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
+				 struct fixed_rsrc_data *rsrc_data,
 				 struct fixed_rsrc_ref_node *ref_node)
 {
-	spin_lock_bh(&rsrc_data->lock);
+	spin_lock_bh(&ctx->rsrc_ref_lock);
 	rsrc_data->node = ref_node;
-	list_add_tail(&ref_node->node, &rsrc_data->ref_list);
-	spin_unlock_bh(&rsrc_data->lock);
+	list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
 	percpu_ref_get(&rsrc_data->refs);
 }
 
@@ -7295,9 +7298,9 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	if (!backup_node)
 		return -ENOMEM;
 
-	spin_lock_bh(&data->lock);
+	spin_lock_bh(&ctx->rsrc_ref_lock);
 	ref_node = data->node;
-	spin_unlock_bh(&data->lock);
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
 
@@ -7313,7 +7316,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 		if (ret < 0) {
 			percpu_ref_resurrect(&data->refs);
 			reinit_completion(&data->done);
-			io_sqe_rsrc_set_node(data, backup_node);
+			io_sqe_rsrc_set_node(ctx, data, backup_node);
 			return ret;
 		}
 	} while (1);
@@ -7687,11 +7690,11 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 	data = ref_node->rsrc_data;
 	ctx = data->ctx;
 
-	spin_lock_bh(&data->lock);
+	spin_lock_bh(&ctx->rsrc_ref_lock);
 	ref_node->done = true;
 
-	while (!list_empty(&data->ref_list)) {
-		ref_node = list_first_entry(&data->ref_list,
+	while (!list_empty(&ctx->rsrc_ref_list)) {
+		ref_node = list_first_entry(&ctx->rsrc_ref_list,
 					struct fixed_rsrc_ref_node, node);
 		/* recycle ref nodes in order */
 		if (!ref_node->done)
@@ -7699,7 +7702,7 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 		list_del(&ref_node->node);
 		first_add |= llist_add(&ref_node->llist, &ctx->rsrc_put_llist);
 	}
-	spin_unlock_bh(&data->lock);
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
 
 	if (percpu_ref_is_dying(&data->refs))
 		delay = 0;
@@ -7760,8 +7763,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -ENOMEM;
 	file_data->ctx = ctx;
 	init_completion(&file_data->done);
-	INIT_LIST_HEAD(&file_data->ref_list);
-	spin_lock_init(&file_data->lock);
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
 	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
@@ -7822,7 +7823,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -ENOMEM;
 	}
 
-	io_sqe_rsrc_set_node(file_data, ref_node);
+	io_sqe_rsrc_set_node(ctx, file_data, ref_node);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7983,7 +7984,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
-		io_sqe_rsrc_set_node(data, ref_node);
+		io_sqe_rsrc_set_node(ctx, data, ref_node);
 	} else
 		destroy_fixed_rsrc_ref_node(ref_node);
 
-- 
2.24.0

