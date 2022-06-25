Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5D755A91B
	for <lists+io-uring@lfdr.de>; Sat, 25 Jun 2022 12:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbiFYK4G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jun 2022 06:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbiFYK4G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jun 2022 06:56:06 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DEE3120E
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 03:56:01 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q5so1023195wrc.2
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 03:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aJtpBgSP2TqUqnbvyncOrTi1mebinj8se3WFD9pNmyM=;
        b=nG+ox4KJtm/GQA4CGK7A/QS5xB1D+XO9GI6Ol+BghAtWddz1mdVzF7SBjQEi/2qVoU
         UD1sD7E9c+7lLjj4HMKtTZ/+SbOmDV53dXg0xcvrs+VmfWp7CbW5O2xJ9tB+aRx79cJY
         g6Fx0JR/CYFhdzlH8FJGCvdadx2iKJfk2PR8LnpD/YMf93HrHXyx3rhJVuHQIM6B1iPS
         YkCs3gx5ta6OBiTCaJ2SvtfP7zVVtuY+2VBGmqicsE8nHEH9A5BviAuzUTpl0QZYgQjj
         pXXF1iSaqMRViLf+cL9zv50XskTR0Xp6LRU+VXQRB/A0QCHfRZzNox3BparxUmugFvTF
         X+TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aJtpBgSP2TqUqnbvyncOrTi1mebinj8se3WFD9pNmyM=;
        b=0nesfxuldVQfW6w1O2bFjXWRsRuLvoiNqESawNSejaK6D6lNR7exJGPrajXQq1cJwO
         pjflzjxAjtEevbkG3zR3CBxmo4oupNjYx44vBi5s5yPz2HuTAGs+ca0j0MoFJR1URu7z
         YysEkNkSlb56b9pgrQ5JibTY2zcAy/r7nugQzhHDZU9yQzKniQyO3uTN07TpgwZAry1Y
         98c3umwyB3S4VTgPXvfnyybmwth1/TKcZ65VTCllTCFzIgrEzD+DZsGZzAytQkmagbZK
         nKD4EVOo5Xvuv3BVpvXIkUMhV8cyK2pTHl+6X7kf7qKRAr9K/rdbgVlWnkdIEzjXv9XZ
         uI0Q==
X-Gm-Message-State: AJIora/Ighw4ixUF5K0CSLJX+LAJb3I3BsVazy02PKy0aegr6izOqEpf
        slIECNoOTU9aj9ODZf6SfxeQiSzpSdFF2w==
X-Google-Smtp-Source: AGRyM1uGKRBARfzCZlMyZiw7xHh0z2Sc2O/1hDdDlb7mEvFJiXqI8+5MBcENaV88HvziDPe2v7Ci/Q==
X-Received: by 2002:a05:6000:18c4:b0:21b:8b8e:4994 with SMTP id w4-20020a05600018c400b0021b8b8e4994mr3168739wrq.122.1656154560073;
        Sat, 25 Jun 2022 03:56:00 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id h13-20020adff4cd000000b002103aebe8absm4800939wrp.93.2022.06.25.03.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 03:55:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next] io_uring: let to set a range for file slot allocation
Date:   Sat, 25 Jun 2022 11:55:38 +0100
Message-Id: <66ab0394e436f38437cf7c44676e1920d09687ad.1656154403.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From recently io_uring provides an option to allocate a file index for
operation registering fixed files. However, it's utterly unusable with
mixed approaches when for a part of files the userspace knows better
where to place it, as it may race and users don't have any sane way to
pick a slot and hoping it will not be taken.

Let the userspace to register a range of fixed file slots in which the
auto-allocation happens. The use case is splittting the fixed table in
two parts, where on of them is used for auto-allocation and another for
slot-specified operations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Some quick tests:
https://github.com/isilence/liburing/tree/range-file-alloc

 include/linux/io_uring_types.h |  3 +++
 include/uapi/linux/io_uring.h  | 13 +++++++++++++
 io_uring/filetable.c           | 24 ++++++++++++++++++++----
 io_uring/filetable.h           | 20 +++++++++++++++++---
 io_uring/io_uring.c            |  6 ++++++
 io_uring/rsrc.c                |  2 ++
 6 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 918165a20053..1054b8b1ad69 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -233,6 +233,9 @@ struct io_ring_ctx {
 
 	unsigned long		check_cq;
 
+	unsigned int		file_alloc_start;
+	unsigned int		file_alloc_end;
+
 	struct {
 		/*
 		 * We cache a range of free CQEs we can use, once exhausted it
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 09e7c3b13d2d..84dd240e7147 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -429,6 +429,9 @@ enum {
 	/* sync cancelation API */
 	IORING_REGISTER_SYNC_CANCEL		= 24,
 
+	/* register a range of fixed file slots for automatic slot allocation */
+	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -575,4 +578,14 @@ struct io_uring_sync_cancel_reg {
 	__u64				pad[4];
 };
 
+/*
+ * Argument for IORING_REGISTER_FILE_ALLOC_RANGE
+ * The range is specified as [off, off + len)
+ */
+struct io_uring_file_index_range {
+	__u32	off;
+	__u32	len;
+	__u64	resv;
+};
+
 #endif
diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index 534e1a3c625d..5d2207654e0e 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -16,7 +16,7 @@
 static int io_file_bitmap_get(struct io_ring_ctx *ctx)
 {
 	struct io_file_table *table = &ctx->file_table;
-	unsigned long nr = ctx->nr_user_files;
+	unsigned long nr = ctx->file_alloc_end;
 	int ret;
 
 	do {
@@ -24,11 +24,10 @@ static int io_file_bitmap_get(struct io_ring_ctx *ctx)
 		if (ret != nr)
 			return ret;
 
-		if (!table->alloc_hint)
+		if (table->alloc_hint == ctx->file_alloc_start)
 			break;
-
 		nr = table->alloc_hint;
-		table->alloc_hint = 0;
+		table->alloc_hint = ctx->file_alloc_start;
 	} while (1);
 
 	return -ENFILE;
@@ -139,3 +138,20 @@ int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
 		fput(file);
 	return ret;
 }
+
+int io_register_file_alloc_range(struct io_ring_ctx *ctx,
+				 struct io_uring_file_index_range __user *arg)
+{
+	struct io_uring_file_index_range range;
+	u32 end;
+
+	if (copy_from_user(&range, arg, sizeof(range)))
+		return -EFAULT;
+	if (check_add_overflow(range.off, range.len, &end))
+		return -EOVERFLOW;
+	if (range.resv || end > ctx->nr_user_files)
+		return -EINVAL;
+
+	io_file_table_set_alloc_range(ctx, range.off, range.len);
+	return 0;
+}
diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index fb5a274c08ff..acd5e6463733 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -3,9 +3,7 @@
 #define IOU_FILE_TABLE_H
 
 #include <linux/file.h>
-
-struct io_ring_ctx;
-struct io_kiocb;
+#include <linux/io_uring_types.h>
 
 /*
  * FFS_SCM is only available on 64-bit archs, for 32-bit we just define it as 0
@@ -30,6 +28,9 @@ void io_free_file_tables(struct io_file_table *table);
 int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
 			struct file *file, unsigned int file_slot);
 
+int io_register_file_alloc_range(struct io_ring_ctx *ctx,
+				 struct io_uring_file_index_range __user *arg);
+
 unsigned int io_file_get_flags(struct file *file);
 
 static inline void io_file_bitmap_clear(struct io_file_table *table, int bit)
@@ -68,4 +69,17 @@ static inline void io_fixed_file_set(struct io_fixed_file *file_slot,
 	file_slot->file_ptr = file_ptr;
 }
 
+static inline void io_reset_alloc_hint(struct io_ring_ctx *ctx)
+{
+	ctx->file_table.alloc_hint = ctx->file_alloc_start;
+}
+
+static inline void io_file_table_set_alloc_range(struct io_ring_ctx *ctx,
+						 unsigned off, unsigned len)
+{
+	ctx->file_alloc_start = off;
+	ctx->file_alloc_end = off + len;
+	io_reset_alloc_hint(ctx);
+}
+
 #endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 45538b3c3a76..8ab17e2325bc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3877,6 +3877,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_sync_cancel(ctx, arg);
 		break;
+	case IORING_REGISTER_FILE_ALLOC_RANGE:
+		ret = -EINVAL;
+		if (!arg || nr_args)
+			break;
+		ret = io_register_file_alloc_range(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 3a2a5ef263f0..edca7c750f99 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1009,6 +1009,8 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		io_file_bitmap_set(&ctx->file_table, i);
 	}
 
+	/* default it to the whole table */
+	io_file_table_set_alloc_range(ctx, 0, ctx->nr_user_files);
 	io_rsrc_node_switch(ctx, NULL);
 	return 0;
 fail:
-- 
2.36.1

