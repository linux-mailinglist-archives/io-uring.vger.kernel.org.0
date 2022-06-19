Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27B45507EE
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 03:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiFSB7f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 21:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiFSB7d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 21:59:33 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08CEBCB2
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 18:59:31 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 128so309201pfv.12
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 18:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2IGNAsu8KJ6ebnsREWgFXMi+pil2X5QT9U4UryL+mAQ=;
        b=6pr9Pg4AV1Vud0mqHF5vIIJsrdiVC/mck9BgFX/fQa4h63wBEoc9IMICIQL2AtM8R9
         J0IKn2FdMMTlWiU6/kK04+vzqayk67MceA5PitgSBKgFQmbEexLrT3mQ2cp5mBG6tieJ
         VgHwxuf87s4RAPyXYEnnZ5OFzVYSC04K32KUIqROgwzADwcMePHBINwcgr+c0Zs+Toxh
         qqQ1lWFMoK39/3WXSigqlE1hAV1JxGF6V7+x3BE8dDPhubL3uWNtDSg/a6E2wv1bqUGQ
         JbQ3yoPy3AmTbMyQlUF4RTXe1qWkDcpbBYhE1ZnjRWcbnhSh3d+0aNOH8K8YlgL87qu+
         GSBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2IGNAsu8KJ6ebnsREWgFXMi+pil2X5QT9U4UryL+mAQ=;
        b=CEv9RPwTax8xBh5QVVs6+VL3iZYurVsnuL6+RzvaCHBZeI9iUq01ctHIzaOJM4JCm2
         WeemQSE+8hjxWC8ZqmJv/Om04FWZxvWO5r2JLLtO9NBMYc/TxS/ARZGHeYl5f6pK3zol
         wvPspIrvjvXywhjHm49/32hnTyLR15BcKK9WqhR+KLRjGFxDtEguK6kZTd6oo4HQjdOk
         DLJ91VG2cPURT4/k+sLflwiOlvudjro9dH2IrEMRdZPwGSHb/xqRwLMZ/+XAPDrXIPER
         +5aVli15LHcL81ixUiNAMxFFtsHFvIZDIWAuMfmbFAi4Zzx8vEPg+fy2HIAjiYgua9tl
         9a2w==
X-Gm-Message-State: AJIora8s116CVIOQ9thjn7D5DPJNZITsdvJkBpV1hTedtBkp7fNg+lT9
        DGxTiXplVdDle9GgmscTWPNUbXzgtc0X6w==
X-Google-Smtp-Source: AGRyM1vml3/vNjpqXrEeAcSnV2upZeAohf6w9Hafv47BgL9qTgQV3qI1+3pHPftwtaiaa7NLqBfybg==
X-Received: by 2002:a63:6e89:0:b0:408:c108:16eb with SMTP id j131-20020a636e89000000b00408c10816ebmr15775000pgc.467.1655603971175;
        Sat, 18 Jun 2022 18:59:31 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id im15-20020a170902bb0f00b0016194c1df58sm3526725plb.105.2022.06.18.18.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 18:59:30 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: split out fixed file installation and removal
Date:   Sat, 18 Jun 2022 19:59:21 -0600
Message-Id: <20220619015922.1325241-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220619015922.1325241-1-axboe@kernel.dk>
References: <20220619015922.1325241-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Put it with the filetable code, which is where it belongs. While doing
so, have the helpers take a ctx rather than an io_kiocb. It doesn't make
sense to use a request, as it's not an operation on the request itself.
It applies to the ring itself.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/filetable.c | 72 +++++++++++++++++++++++++++++++++-----------
 io_uring/filetable.h |  3 ++
 io_uring/openclose.c | 35 +++------------------
 io_uring/openclose.h |  2 +-
 io_uring/rsrc.c      |  2 +-
 5 files changed, 63 insertions(+), 51 deletions(-)

diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index 534e1a3c625d..abaa5ba7f655 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -58,11 +58,10 @@ void io_free_file_tables(struct io_file_table *table)
 	table->bitmap = NULL;
 }
 
-static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
-				 unsigned int issue_flags, u32 slot_index)
+static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
+				 u32 slot_index)
 	__must_hold(&req->ctx->uring_lock)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	bool needs_switch = false;
 	struct io_fixed_file *file_slot;
 	int ret;
@@ -108,6 +107,26 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 	return ret;
 }
 
+int __io_fixed_fd_install(struct io_ring_ctx *ctx, struct file *file,
+			  unsigned int file_slot)
+{
+	bool alloc_slot = file_slot == IORING_FILE_INDEX_ALLOC;
+	int ret;
+
+	if (alloc_slot) {
+		ret = io_file_bitmap_get(ctx);
+		if (unlikely(ret < 0))
+			return ret;
+		file_slot = ret;
+	} else {
+		file_slot--;
+	}
+
+	ret = io_install_fixed_file(ctx, file, file_slot);
+	if (!ret && alloc_slot)
+		ret = file_slot;
+	return ret;
+}
 /*
  * Note when io_fixed_fd_install() returns error value, it will ensure
  * fput() is called correspondingly.
@@ -115,27 +134,44 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
 			struct file *file, unsigned int file_slot)
 {
-	bool alloc_slot = file_slot == IORING_FILE_INDEX_ALLOC;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
 	io_ring_submit_lock(ctx, issue_flags);
-
-	if (alloc_slot) {
-		ret = io_file_bitmap_get(ctx);
-		if (unlikely(ret < 0))
-			goto err;
-		file_slot = ret;
-	} else {
-		file_slot--;
-	}
-
-	ret = io_install_fixed_file(req, file, issue_flags, file_slot);
-	if (!ret && alloc_slot)
-		ret = file_slot;
-err:
+	ret = __io_fixed_fd_install(ctx, file, file_slot);
 	io_ring_submit_unlock(ctx, issue_flags);
+
 	if (unlikely(ret < 0))
 		fput(file);
 	return ret;
 }
+
+int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset)
+{
+	struct io_fixed_file *file_slot;
+	struct file *file;
+	int ret;
+
+	if (unlikely(!ctx->file_data))
+		return -ENXIO;
+	if (offset >= ctx->nr_user_files)
+		return -EINVAL;
+	ret = io_rsrc_node_switch_start(ctx);
+	if (ret)
+		return ret;
+
+	offset = array_index_nospec(offset, ctx->nr_user_files);
+	file_slot = io_fixed_file_slot(&ctx->file_table, offset);
+	if (!file_slot->file_ptr)
+		return -EBADF;
+
+	file = (struct file *)(file_slot->file_ptr & FFS_MASK);
+	ret = io_queue_rsrc_removal(ctx->file_data, offset, ctx->rsrc_node, file);
+	if (ret)
+		return ret;
+
+	file_slot->file_ptr = 0;
+	io_file_bitmap_clear(&ctx->file_table, offset);
+	io_rsrc_node_switch(ctx, ctx->file_data);
+	return 0;
+}
diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index 6b58aa48bc45..0b050f3c331e 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -27,6 +27,9 @@ void io_free_file_tables(struct io_file_table *table);
 
 int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
 			struct file *file, unsigned int file_slot);
+int __io_fixed_fd_install(struct io_ring_ctx *ctx, struct file *file,
+				unsigned int file_slot);
+int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset);
 
 unsigned int io_file_get_flags(struct file *file);
 
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 099a5ec84dfd..d1818ec9169b 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -173,42 +173,15 @@ void io_open_cleanup(struct io_kiocb *req)
 		putname(open->filename);
 }
 
-int __io_close_fixed(struct io_kiocb *req, unsigned int issue_flags,
+int __io_close_fixed(struct io_ring_ctx *ctx, unsigned int issue_flags,
 		     unsigned int offset)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_fixed_file *file_slot;
-	struct file *file;
 	int ret;
 
 	io_ring_submit_lock(ctx, issue_flags);
-	ret = -ENXIO;
-	if (unlikely(!ctx->file_data))
-		goto out;
-	ret = -EINVAL;
-	if (offset >= ctx->nr_user_files)
-		goto out;
-	ret = io_rsrc_node_switch_start(ctx);
-	if (ret)
-		goto out;
-
-	offset = array_index_nospec(offset, ctx->nr_user_files);
-	file_slot = io_fixed_file_slot(&ctx->file_table, offset);
-	ret = -EBADF;
-	if (!file_slot->file_ptr)
-		goto out;
-
-	file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-	ret = io_queue_rsrc_removal(ctx->file_data, offset, ctx->rsrc_node, file);
-	if (ret)
-		goto out;
-
-	file_slot->file_ptr = 0;
-	io_file_bitmap_clear(&ctx->file_table, offset);
-	io_rsrc_node_switch(ctx, ctx->file_data);
-	ret = 0;
-out:
+	ret = io_fixed_fd_remove(ctx, offset);
 	io_ring_submit_unlock(ctx, issue_flags);
+
 	return ret;
 }
 
@@ -216,7 +189,7 @@ static inline int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_close *close = io_kiocb_to_cmd(req);
 
-	return __io_close_fixed(req, issue_flags, close->file_slot - 1);
+	return __io_close_fixed(req->ctx, issue_flags, close->file_slot - 1);
 }
 
 int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
diff --git a/io_uring/openclose.h b/io_uring/openclose.h
index 9f578f3fad87..4b1c28d3a66c 100644
--- a/io_uring/openclose.h
+++ b/io_uring/openclose.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
-int __io_close_fixed(struct io_kiocb *req, unsigned int issue_flags,
+int __io_close_fixed(struct io_ring_ctx *ctx, unsigned int issue_flags,
 		     unsigned int offset);
 
 int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index c10c512aa71b..3340aa9e3fab 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -700,7 +700,7 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
 		if (ret < 0)
 			break;
 		if (copy_to_user(&fds[done], &ret, sizeof(ret))) {
-			__io_close_fixed(req, issue_flags, ret);
+			__io_close_fixed(req->ctx, issue_flags, ret);
 			ret = -EFAULT;
 			break;
 		}
-- 
2.35.1

