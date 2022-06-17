Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4F154F87A
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 15:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382122AbiFQNpO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 09:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382116AbiFQNpN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 09:45:13 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0682870D
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 06:45:12 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id z17so4226703pff.7
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 06:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2IGNAsu8KJ6ebnsREWgFXMi+pil2X5QT9U4UryL+mAQ=;
        b=beyPoRsnVjleJVxbkLKyFJWZpGImpEcX8i+5D0Hobu8l4IrXUF+Boky11JHjojwg1R
         dB0b9eAouKsTGifAnPuvzZdqgXrLnAid7CL4YmQL6xlTIkRYlUk2/F4BZt5jLyOiVK2h
         6aGUvm6LtBNu4eNoZ6EubU1yBqLMj18slKW3G3ByjZp6ErhwA5yL1JHx229ur08oOd95
         MCUfXKzt747yxNcGHNXx/cy1XUWX2YAtEQCYUoZTwKHKHfLKUDsO26CpFueyp9rI+xwh
         ILzdTyFnPzTRKAujrr1a9QTyBrFjqDDsc7C8nooGSrRKTQf7WK8073AXsklgx8yIu6qk
         tXrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2IGNAsu8KJ6ebnsREWgFXMi+pil2X5QT9U4UryL+mAQ=;
        b=WnLBN7u7uJtZQK+f1wd4lkItD94WbkhmpH/y5m8Jj0zyLeJS0Re7dXiCVGuI5DdGgk
         WihIzMQWLlULCS4xilqHdiSabsZlV919QEMxmyCrsRLX3E8oRTjLBF5g6voeH1BJap8C
         QaqbcqP4XOILATpOG1FzyjQTR1vARXws3BM71u/XepYez/47IbYTzUGbGBHeihMQANY5
         T7l7k9PTOE98gqJYItopJKCrz92HrybVCyEduN7gf+OMc4RGb3r6OYsMj0SN3Q4C1jIf
         diVO/LZ4D9fQ1f6+mmNVU6AcOfkugoW7Z5aYXNwBDpyLJ40tddehpgvCOyk6Px7ctLyg
         X1zQ==
X-Gm-Message-State: AJIora/9JvcCa40BbxbBSpRYPgSZBMenXhhNo5b54rIhKkTFB06d9M8B
        qYv7XJbSM+RkhlJlzncibzQ0Ns/hW/C9kQ==
X-Google-Smtp-Source: AGRyM1t+S/4Xu0wzux70aBP88qoNXSzaWk73sZsGiDVLEwOCg7SVAU8MhsEqB2R4Jfg22cBDa0AdHA==
X-Received: by 2002:a05:6a00:1d1c:b0:51c:6c4a:45e1 with SMTP id a28-20020a056a001d1c00b0051c6c4a45e1mr10350573pfx.34.1655473511313;
        Fri, 17 Jun 2022 06:45:11 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a1709027fcd00b0016392bd5060sm2214075plb.142.2022.06.17.06.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 06:45:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: split out fixed file installation and removal
Date:   Fri, 17 Jun 2022 07:45:03 -0600
Message-Id: <20220617134504.368706-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220617134504.368706-1-axboe@kernel.dk>
References: <20220617134504.368706-1-axboe@kernel.dk>
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

