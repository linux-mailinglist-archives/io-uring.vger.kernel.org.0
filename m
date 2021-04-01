Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3D2351B3E
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236321AbhDASHD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 14:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbhDASBg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 14:01:36 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7211FC0045AD
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:43 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j7so2118037wrd.1
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=s22CuATe5GCgeX1rZ2yZpcLd6X6eiNLeecA60QJEAK8=;
        b=cq/65Vw0deQVXsVMF109QEQiKVZ7QdUK65FN2tDW3F8kwm3gotIivUTI+Nz8J3XQnD
         LlkWytSUcIFGLYsy4N+5zUwl566Sq2OR17u6POlRDgO+NaClaBs//wXxsgDnJoSlnuta
         cMIlvfeaao+FKFGXaQOBuWtsCI1hdE2Bnn+NAj6k0MTt+D+7Y90EjpAQ2nvhVWFXs/tR
         tCJG5EUw3HJ3MW63K/OaTmyNczVJ2HfsFIkXQnwk8OKB16YqbJzjU72W2TU9dTZtAqxU
         HvFBkCV5QW5TqzNjCC7TrC2fKpeiXRI5RFW3uP5hu9/wx3YmIUS9Vm/WtzywMJdZ5+0W
         qR4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s22CuATe5GCgeX1rZ2yZpcLd6X6eiNLeecA60QJEAK8=;
        b=mB8l8tmZ0Ik2R/MbRRnKtcNkoZ4ze5wwoXccwbJ3IXLqkIXt9Nb4F0dtm3PT6iAbFq
         t6+8YwNi9nfjVGNfFUR5xUnfMPkOXBm0o3/URhkF23flWny0YRpSyyFeYWIkm7MPbH0s
         /h5dh5MfEW8rJ47asgujZvIe9hc5aN6qSw38vaaZA3ziPMT0hOh/xqF7UKZ4SfkHPaXB
         JZ2gTpDmdCzugNtzmLSDTlX4aER12LVuXv9mEQSiaxU1qAn5Xm1NUntWgYijx7jnHTfm
         cgMts4HBF7yujLctvLNzmHfx14/lMrbuzVr/xXGBFqEoudiPCl88t8myiJISiRLhLNFj
         WL1A==
X-Gm-Message-State: AOAM5316L0tMv0MTq8AhjrKAO21Z/82p6fjITZFhyKLRTNLjFWKr71Gh
        7zTwu7K3o1J82r8tpxR6p0Y=
X-Google-Smtp-Source: ABdhPJwlPoZaZJEwoRS6LNQQykoa3orHDc9i+4DyliSW0sNqW9kL2XHr+ZckMfoMzS7fW0i/WhV0xQ==
X-Received: by 2002:a05:6000:1789:: with SMTP id e9mr10275445wrg.237.1617288522293;
        Thu, 01 Apr 2021 07:48:42 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 25/26] io_uring: encapsulate fixed files into struct
Date:   Thu,  1 Apr 2021 15:44:04 +0100
Message-Id: <78669731a605a7614c577c3de552631cfaf0869a.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add struct io_fixed_file representing a single registered file, first to
hide ugly struct file **, which may be misleading, and secondly to
retype it to unsigned long as conversions to it and back to file * for
handling and masking FFS_* flags are getting nasty.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a9984ca025ba..c1d9fface7f4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -207,6 +207,11 @@ struct io_overflow_cqe {
 	struct list_head list;
 };
 
+struct io_fixed_file {
+	/* file * with additional FFS_* flags */
+	unsigned long file_ptr;
+};
+
 struct io_rsrc_put {
 	struct list_head list;
 	union {
@@ -216,7 +221,7 @@ struct io_rsrc_put {
 };
 
 struct fixed_rsrc_table {
-	struct file		**files;
+	struct io_fixed_file *files;
 };
 
 struct io_rsrc_node {
@@ -6255,8 +6260,8 @@ static void io_wq_submit_work(struct io_wq_work *work)
 #endif
 #define FFS_MASK		~(FFS_ASYNC_READ|FFS_ASYNC_WRITE|FFS_ISREG)
 
-static inline struct file **io_fixed_file_slot(struct io_rsrc_data *file_data,
-					       unsigned i)
+static inline struct io_fixed_file *io_fixed_file_slot(struct io_rsrc_data *file_data,
+						      unsigned i)
 {
 	struct fixed_rsrc_table *table;
 
@@ -6267,12 +6272,12 @@ static inline struct file **io_fixed_file_slot(struct io_rsrc_data *file_data,
 static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
 					      int index)
 {
-	struct file **file_slot = io_fixed_file_slot(ctx->file_data, index);
+	struct io_fixed_file *slot = io_fixed_file_slot(ctx->file_data, index);
 
-	return (struct file *) ((unsigned long) *file_slot & FFS_MASK);
+	return (struct file *) (slot->file_ptr & FFS_MASK);
 }
 
-static void io_fixed_file_set(struct file **file_slot, struct file *file)
+static void io_fixed_file_set(struct io_fixed_file *file_slot, struct file *file)
 {
 	unsigned long file_ptr = (unsigned long) file;
 
@@ -6282,7 +6287,7 @@ static void io_fixed_file_set(struct file **file_slot, struct file *file)
 		file_ptr |= FFS_ASYNC_WRITE;
 	if (S_ISREG(file_inode(file)->i_mode))
 		file_ptr |= FFS_ISREG;
-	*file_slot = (struct file *)file_ptr;
+	file_slot->file_ptr = file_ptr;
 }
 
 static struct file *io_file_get(struct io_submit_state *state,
@@ -6297,7 +6302,7 @@ static struct file *io_file_get(struct io_submit_state *state,
 		if (unlikely((unsigned int)fd >= ctx->nr_user_files))
 			return NULL;
 		fd = array_index_nospec(fd, ctx->nr_user_files);
-		file_ptr = (unsigned long) *io_fixed_file_slot(ctx->file_data, fd);
+		file_ptr = io_fixed_file_slot(ctx->file_data, fd)->file_ptr;
 		file = (struct file *) (file_ptr & FFS_MASK);
 		file_ptr &= ~FFS_MASK;
 		/* mask in overlapping REQ_F and FFS bits */
@@ -7733,7 +7738,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 unsigned nr_args)
 {
 	struct io_rsrc_data *data = ctx->file_data;
-	struct file *file, **file_slot;
+	struct io_fixed_file *file_slot;
+	struct file *file;
 	__s32 __user *fds;
 	int fd, i, err;
 	__u32 done;
@@ -7760,12 +7766,12 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		i = array_index_nospec(up->offset + done, ctx->nr_user_files);
 		file_slot = io_fixed_file_slot(ctx->file_data, i);
 
-		if (*file_slot) {
-			file = (struct file *) ((unsigned long) *file_slot & FFS_MASK);
+		if (file_slot->file_ptr) {
+			file = (struct file *)(file_slot->file_ptr & FFS_MASK);
 			err = io_queue_rsrc_removal(data, ctx->rsrc_node, file);
 			if (err)
 				break;
-			*file_slot = NULL;
+			file_slot->file_ptr = 0;
 			needs_switch = true;
 		}
 		if (fd != -1) {
@@ -7790,7 +7796,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			io_fixed_file_set(file_slot, file);
 			err = io_sqe_file_register(ctx, file, i);
 			if (err) {
-				*file_slot = NULL;
+				file_slot->file_ptr = 0;
 				fput(file);
 				break;
 			}
-- 
2.24.0

