Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB0636A78B
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 15:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhDYNdY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 09:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhDYNdY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 09:33:24 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA69C061574
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:44 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id c4so14153468wrt.8
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0W5D6FeAxqjSqR1B0DBN8lwF5eYuUwbFg3G/WXCPGX4=;
        b=t67EVc0OIsRtwrveimnG0tKsyXWhms1sEFJU/ARbXHL0oxlh/yJYChp1uGcS110btV
         wqpfdMpTzhELjgdgI6yMjCwUwDmwyArI5rL7X3PrJmJ250YMcbBH9R8MmJ1fJDckC0/A
         ZTE+CVMj/C4Nta3o+JGowznudZVLU0n4uILaVEIqqdeNM+Ebb5FVLZ3s6ViHMJQ0WUIb
         1ThgxuH7UjpsTuXtjdwHPDrj1GmzF6cKjCP8XwRXQLP3SaSlvVyzDO3W1kGEtTshRzSm
         NmObO/FlqMBoK+zqqzU0dcpM1uo87eEp/ZoTipx8NoY87/u6WqtFHY0RoAxeQjMH/Jo4
         vaaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0W5D6FeAxqjSqR1B0DBN8lwF5eYuUwbFg3G/WXCPGX4=;
        b=j7dmVqp8Cs6xwCslTRdokosNSggk++VFrcXoN6pEmog0O0xYKWiAbXzxLKrjB7Etj4
         yneBpscSrrSZGit2+D6t+NDCV2f1GBqy4yx15dR2PjTL2f3zNyC1lyvTTtSCJmMyWBO5
         lfAkqGm3gWDPh7lrsAee6KmSXG0yTGTZbKA0Avw9LiBnprfPEL7aSq96F09n8F0vPQF3
         qnKhPkcneGgFkO0UTBp3QzKhcjACveMZ7qsshv/lioQGh63vYRjBB43e7GOn+DTRRwei
         kVpLtukLApkJSySuejsGQV/+ynwBzH+R8bY0nSb8j19FJV7WvglWY1HFmTJuwT2is0me
         nrZA==
X-Gm-Message-State: AOAM53166tHMQ92hhiyB3VFpNu+y6xPV+gdEB+0/XM4hAt2c50RDLmD7
        3WkKvPOFrg5p27/0UhaiTK+xSu8ToAw=
X-Google-Smtp-Source: ABdhPJzzqZAgZLYKirGhy9WbaQiFnTUIBNhCJ0zf9lQqytaLqeqO8KzenprBaFgTyWepMG1yPUR/Mw==
X-Received: by 2002:a5d:484c:: with SMTP id n12mr16675536wrs.377.1619357563321;
        Sun, 25 Apr 2021 06:32:43 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.108])
        by smtp.gmail.com with ESMTPSA id a2sm16551552wrt.82.2021.04.25.06.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 06:32:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 08/12] io_uring: add generic rsrc update with tags
Date:   Sun, 25 Apr 2021 14:32:22 +0100
Message-Id: <d4dc66df204212f64835ffca2c4eb5e8363f2f05.1619356238.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619356238.git.asml.silence@gmail.com>
References: <cover.1619356238.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add IORING_REGISTER_RSRC_UPDATE, which also supports passing in rsrc
tags. Implement it for registered files.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 52 +++++++++++++++++++++++++++--------
 include/uapi/linux/io_uring.h | 22 +++++++++++----
 2 files changed, 57 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3e7d96e25ec3..5882303cc84a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1036,7 +1036,7 @@ static void io_put_task(struct task_struct *task, int nr);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
-				     struct io_uring_rsrc_update *up,
+				     struct io_uring_rsrc_update2 *up,
 				     unsigned nr_args);
 static void io_clean_op(struct io_kiocb *req);
 static struct file *io_file_get(struct io_submit_state *state,
@@ -5808,7 +5808,7 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
 static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_uring_rsrc_update up;
+	struct io_uring_rsrc_update2 up;
 	int ret;
 
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -5816,6 +5816,8 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 
 	up.offset = req->rsrc_update.offset;
 	up.data = req->rsrc_update.arg;
+	up.nr = 0;
+	up.tags = 0;
 
 	mutex_lock(&ctx->uring_lock);
 	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
@@ -7727,9 +7729,10 @@ static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 }
 
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
-				 struct io_uring_rsrc_update *up,
+				 struct io_uring_rsrc_update2 *up,
 				 unsigned nr_args)
 {
+	u64 __user *tags = u64_to_user_ptr(up->tags);
 	__s32 __user *fds = u64_to_user_ptr(up->data);
 	struct io_rsrc_data *data = ctx->file_data;
 	struct io_fixed_file *file_slot;
@@ -7744,10 +7747,17 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
-		if (copy_from_user(&fd, &fds[done], sizeof(fd))) {
+		u64 tag = 0;
+
+		if ((tags && copy_from_user(&tag, &tags[done], sizeof(tag))) ||
+		    copy_from_user(&fd, &fds[done], sizeof(fd))) {
 			err = -EFAULT;
 			break;
 		}
+		if ((fd == IORING_REGISTER_FILES_SKIP || fd == -1) && tag) {
+			err = -EINVAL;
+			break;
+		}
 		if (fd == IORING_REGISTER_FILES_SKIP)
 			continue;
 
@@ -7782,6 +7792,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				err = -EBADF;
 				break;
 			}
+			data->tags[up->offset + done] = tag;
 			io_fixed_file_set(file_slot, file);
 			err = io_sqe_file_register(ctx, file, i);
 			if (err) {
@@ -9675,12 +9686,14 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 }
 
 static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
-				     struct io_uring_rsrc_update *up,
+				     struct io_uring_rsrc_update2 *up,
 				     unsigned nr_args)
 {
 	__u32 tmp;
 	int err;
 
+	if (up->resv)
+		return -EINVAL;
 	if (check_add_overflow(up->offset, nr_args, &tmp))
 		return -EOVERFLOW;
 	err = io_rsrc_node_switch_start(ctx);
@@ -9694,18 +9707,31 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 	return -EINVAL;
 }
 
-static int io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
-				   void __user *arg, unsigned nr_args)
+static int io_register_files_update(struct io_ring_ctx *ctx, void __user *arg,
+				    unsigned nr_args)
 {
-	struct io_uring_rsrc_update up;
+	struct io_uring_rsrc_update2 up;
 
 	if (!nr_args)
 		return -EINVAL;
+	memset(&up, 0, sizeof(up));
+	if (copy_from_user(&up, arg, sizeof(struct io_uring_rsrc_update)))
+		return -EFAULT;
+	return __io_register_rsrc_update(ctx, IORING_RSRC_FILE, &up, nr_args);
+}
+
+static int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
+				   unsigned size)
+{
+	struct io_uring_rsrc_update2 up;
+
+	if (size != sizeof(up))
+		return -EINVAL;
 	if (copy_from_user(&up, arg, sizeof(up)))
 		return -EFAULT;
-	if (up.resv)
+	if (!up.nr)
 		return -EINVAL;
-	return __io_register_rsrc_update(ctx, type, &up, nr_args);
+	return __io_register_rsrc_update(ctx, up.type, &up, up.nr);
 }
 
 static int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
@@ -9741,6 +9767,7 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_REGISTER_PERSONALITY:
 	case IORING_UNREGISTER_PERSONALITY:
 	case IORING_REGISTER_RSRC:
+	case IORING_REGISTER_RSRC_UPDATE:
 		return false;
 	default:
 		return true;
@@ -9822,7 +9849,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = io_sqe_files_unregister(ctx);
 		break;
 	case IORING_REGISTER_FILES_UPDATE:
-		ret = io_register_rsrc_update(ctx, IORING_RSRC_FILE, arg, nr_args);
+		ret = io_register_files_update(ctx, arg, nr_args);
 		break;
 	case IORING_REGISTER_EVENTFD:
 	case IORING_REGISTER_EVENTFD_ASYNC:
@@ -9873,6 +9900,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	case IORING_REGISTER_RSRC:
 		ret = io_register_rsrc(ctx, arg, nr_args);
 		break;
+	case IORING_REGISTER_RSRC_UPDATE:
+		ret = io_register_rsrc_update(ctx, arg, nr_args);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ce7b2fce6713..6d8360b5b9c5 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -299,6 +299,7 @@ enum {
 	IORING_REGISTER_RESTRICTIONS		= 11,
 	IORING_REGISTER_ENABLE_RINGS		= 12,
 	IORING_REGISTER_RSRC			= 13,
+	IORING_REGISTER_RSRC_UPDATE		= 14,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
@@ -311,12 +312,6 @@ struct io_uring_files_update {
 	__aligned_u64 /* __s32 * */ fds;
 };
 
-struct io_uring_rsrc_update {
-	__u32 offset;
-	__u32 resv;
-	__aligned_u64 data;
-};
-
 enum {
 	IORING_RSRC_FILE		= 0,
 };
@@ -328,6 +323,21 @@ struct io_uring_rsrc_register {
 	__aligned_u64 tags;
 };
 
+struct io_uring_rsrc_update {
+	__u32 offset;
+	__u32 resv;
+	__aligned_u64 data;
+};
+
+struct io_uring_rsrc_update2 {
+	__u32 offset;
+	__u32 resv;
+	__aligned_u64 data;
+	__aligned_u64 tags;
+	__u32 type;
+	__u32 nr;
+};
+
 /* Skip updating fd indexes set to this value in the fd table */
 #define IORING_REGISTER_FILES_SKIP	(-2)
 
-- 
2.31.1

