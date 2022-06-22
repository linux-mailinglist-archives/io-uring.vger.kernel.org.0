Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FD5556EE9
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 01:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357288AbiFVXQR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 19:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbiFVXQR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 19:16:17 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A67741FB5
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 16:16:16 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id k14so5162872plh.4
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 16:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X43Qh2zGElNDiEpfHb6zUBIKhovFHHW8Tjc/KQjCIN0=;
        b=Qz9tnyTgrNw0NmG3Oc848oAG59YSWJvplb4NzP4xL7/QHLd2y+3cPhSKz2FsHEF92O
         ZXGSkzfZP1n20ByFhuxVfeHanaXaXJ3mvqavUoH6nOjTFQRVHyW9mDAMuYdFcNxH7/wL
         7U6T2LbI3iAtKRloe0meFgLFbZYodAW7dBnk4mp6XYm5tMxBMY1lCxrAoyrn3uQyNKh4
         LeVf+Sslr2wIZPEHh5PjfVN0dZd7ud9vhhia2pGdzRgQymP/4WqxLr0SW/yw3wHkBw98
         ecXGp2yUv+HU8eCDd3G1LzJYOy6R7pS2qZz5lkq8jFVWknBTJWcUusEj+fn+zeeKK16Q
         WgVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X43Qh2zGElNDiEpfHb6zUBIKhovFHHW8Tjc/KQjCIN0=;
        b=EV+LjLNW4+T7O6jF2fZ09ezR/x4ioGUPocqrchKYcvWXACePAnOtdoJQbf8ZFByEZW
         0FBvsxtotDAVdS6Icb0pc5TFfFZk9OEpq1VQBwD8Vp5o9OSeSTYd+KOoQ7RjULwQuFcU
         iiIZ9wp5EDKMsZL29rYAKO5o/cpcFjqg379J2cjvhe/cp6LphROoOEn5xFhE9eopbvO1
         tQYLfFKunNA/U4mqLXZvKxB3Soa7FQ8BzgNBINGns6knLJprMWMR98e/mGJ3rYT2dPRc
         DlRe3u8Ty33UDKH+yMkKIH/rIJWtuXhfxsK5DQbSx3YqQQfUniDHzeOnWZc0Zsb3G2v4
         Ieog==
X-Gm-Message-State: AJIora90Vrv9moT559QoMXk3f3fXGPApH857CCpNhY6Ep8HeukLhsvlK
        ZsKzmIKOjRCZxd75bqK+vT9sW/OKo+RtKA==
X-Google-Smtp-Source: AGRyM1tvtZOYfiAa0xIw7PNXzexoJ5M7+nZXNP/oxWgcorxKWGoKGFOTQU5pXVt/Aj3cs82jXKlUqw==
X-Received: by 2002:a17:902:a50a:b0:162:3488:27c4 with SMTP id s10-20020a170902a50a00b00162348827c4mr35532339plq.109.1655939775763;
        Wed, 22 Jun 2022 16:16:15 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2-20020a056a00198200b0051b9ecb53e6sm13947437pfl.105.2022.06.22.16.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 16:16:15 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, carter.li@eoitek.com, hao.xu@linux.dev,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: split out fixed file installation and removal
Date:   Wed, 22 Jun 2022 17:16:10 -0600
Message-Id: <20220622231611.178300-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220622231611.178300-1-axboe@kernel.dk>
References: <20220622231611.178300-1-axboe@kernel.dk>
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
index fb5a274c08ff..79eb50c1980e 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -29,6 +29,9 @@ void io_free_file_tables(struct io_file_table *table);
 
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
index 3a2a5ef263f0..c49217f9cfc6 100644
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

