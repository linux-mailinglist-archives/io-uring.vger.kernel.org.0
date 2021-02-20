Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C550F320693
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 19:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhBTSIa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 13:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhBTSIa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 13:08:30 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99F2C06178A
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 10:07:49 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id v1so14402273wrd.6
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 10:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MwM59qdxXrMX0Jf81s4FqPdqlptkYKzyhFsv9q8HTO0=;
        b=saG7c4ohoixu2vnmxut9k27yb/etmAF0sfWdi2b5p/Nu66/jKAbzoKKvZCjXxarLIy
         ElfILEWA7MOrBlOncplZQVVo34BydLif8NuNPnnXQ2eJvhMqqkjUxAAtZCk/tRzntZYq
         7NycWjvNPn81qkjPMcCE5Xowh+MmxaeiSuuxcsnFvMrvDerOkJWc6bNus2enjM9D/LrH
         T1uB5CX4BXntaz5/6wpKuvTY9OpeyV3mijNFVAk5i9iAJWDhFIg0xNCt/NNZlLsqrXic
         klFKF1sqDe536emGU7Qc+oNSsb/f5I0429aF4ZR8JAZXRPjeA7y8V4xL7xV9Pj6yDfqw
         YPag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MwM59qdxXrMX0Jf81s4FqPdqlptkYKzyhFsv9q8HTO0=;
        b=IW6zNzTMjBUi/Zzry6l2+gaRGugr8qu7NvAxmux4KY8dXgbfxd7QUpb5bZGemDgWgA
         MXyMBlJfwd6I9mqPhe5/WxeI4AegnEWu4exJIyn+BWyuZ9lJDMoJjdFHEh9AnLch9f43
         cgrUxH9xyMATMYEcVJdKlqxbEWjmHiOWbNNkK41w3viPFsaG5htclI5cSHWz1cenTSkc
         b0KWosORYfv6hMjPrI60Q8+BizDDPTaOmd4REeIpl6kvPfgybYTq5BjxFasL3iDwxmK6
         QxoWps7qzr9Mo0YxYRiuEKy+ND6whnIDW4nXY5ni1t3fwiLS6vMAvRrpT9ZLjEnMjrnL
         3Gkg==
X-Gm-Message-State: AOAM530A4naWhPdK8l1iTt6y+PK8cYGsR0pmxFXWzIrVmx83IBilkSMT
        PbZV6hhfT4yoVHOwxUrFdSKScazCwwkevw==
X-Google-Smtp-Source: ABdhPJxKlfjgCNrynsNe0e1WRBufb9LlDHA9/iOg1QLhtLjCJ79VkrFY3AcuNmW99KMTdOBpQHwBpw==
X-Received: by 2002:adf:a453:: with SMTP id e19mr6020640wra.283.1613844468559;
        Sat, 20 Feb 2021 10:07:48 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id b83sm13594918wmd.4.2021.02.20.10.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 10:07:48 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 2/4] io_uring: fix io_rsrc_ref_quiesce races
Date:   Sat, 20 Feb 2021 18:03:48 +0000
Message-Id: <1dd1cb80d02c2ac4fc29aa8f280666aa678e7d08.1613844023.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613844023.git.asml.silence@gmail.com>
References: <cover.1613844023.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are different types of races in io_rsrc_ref_quiesce()  between
->release() of percpu_refs and reinit_completion(), fix them by always
resurrecting between iterations. BTW, clean the function up, because
DRY.

Fixes: a4f2225d1cb2 ("io_uring: don't hold uring_lock when calling io_run_task_work*")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 57 +++++++++++++++++++++------------------------------
 1 file changed, 23 insertions(+), 34 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 50d4dba08f82..292fba2b8e36 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -236,6 +236,7 @@ struct fixed_rsrc_data {
 	struct fixed_rsrc_ref_node	*node;
 	struct percpu_ref		refs;
 	struct completion		done;
+	bool				quiesce;
 };
 
 struct io_buffer {
@@ -7316,19 +7317,6 @@ static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
 	percpu_ref_get(&rsrc_data->refs);
 }
 
-static int io_sqe_rsrc_add_node(struct io_ring_ctx *ctx, struct fixed_rsrc_data *data)
-{
-	struct fixed_rsrc_ref_node *backup_node;
-
-	backup_node = alloc_fixed_rsrc_ref_node(ctx);
-	if (!backup_node)
-		return -ENOMEM;
-	init_fixed_file_ref_node(ctx, backup_node);
-	io_sqe_rsrc_set_node(ctx, data, backup_node);
-
-	return 0;
-}
-
 static void io_sqe_rsrc_kill_node(struct io_ring_ctx *ctx, struct fixed_rsrc_data *data)
 {
 	struct fixed_rsrc_ref_node *ref_node = NULL;
@@ -7347,39 +7335,40 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 {
 	int ret;
 
-	io_sqe_rsrc_kill_node(ctx, data);
-	percpu_ref_kill(&data->refs);
+	if (data->quiesce)
+		return -ENXIO;
 
-	/* wait for all refs nodes to complete */
-	flush_delayed_work(&ctx->rsrc_put_work);
+	data->quiesce = true;
 	do {
+		io_sqe_rsrc_kill_node(ctx, data);
+		percpu_ref_kill(&data->refs);
+		flush_delayed_work(&ctx->rsrc_put_work);
+
 		ret = wait_for_completion_interruptible(&data->done);
 		if (!ret)
 			break;
 
-		ret = io_sqe_rsrc_add_node(ctx, data);
-		if (ret < 0)
-			break;
-		/*
-		 * There is small possibility that data->done is already completed
-		 * So reinit it here
-		 */
+		percpu_ref_resurrect(&data->refs);
+		io_sqe_rsrc_set_node(ctx, data, backup_node);
+		backup_node = NULL;
 		reinit_completion(&data->done);
 		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig();
 		mutex_lock(&ctx->uring_lock);
-		io_sqe_rsrc_kill_node(ctx, data);
-	} while (ret >= 0);
 
-	if (ret < 0) {
-		percpu_ref_resurrect(&data->refs);
-		reinit_completion(&data->done);
-		io_sqe_rsrc_set_node(ctx, data, backup_node);
-		return ret;
-	}
+		if (ret < 0)
+			break;
+		backup_node = alloc_fixed_rsrc_ref_node(ctx);
+		ret = -ENOMEM;
+		if (!backup_node)
+			break;
+		init_fixed_file_ref_node(ctx, backup_node);
+	} while (1);
+	data->quiesce = false;
 
-	destroy_fixed_rsrc_ref_node(backup_node);
-	return 0;
+	if (backup_node)
+		destroy_fixed_rsrc_ref_node(backup_node);
+	return ret;
 }
 
 static struct fixed_rsrc_data *alloc_fixed_rsrc_data(struct io_ring_ctx *ctx)
-- 
2.24.0

