Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC4A3689B6
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 02:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236162AbhDWAUW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Apr 2021 20:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236068AbhDWAUW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Apr 2021 20:20:22 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EB7C061574
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:45 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id c15so37605181wro.13
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fWUmFlZZKykaUrgHDNSTsbXcbMtqT1R3Ox7a6yZFJJo=;
        b=N1J2CqoxmzRWBSa0f07sqiiPc3Ixj2sPHTurHGleMdfNcn1lkRzlUDfi/ZyEi/WRYK
         tJTm1jN0X8zb2ScHzU3yamOMiRP3WzRyKP65ChuLovr4y+A6cx8VZUP1AV5F9vq2KhXl
         B6wsC25jhUv6PunF+m4VOIn8KLJsIN1KpLZrDtqpKK4N1Ra/Bwt1eCfyXdDAHVQNdew5
         kG8CoxEar6BQiG1xUq8YGDonLfIiNCATJNR368vb4ANUc7qB7lyk5qlL0Pbk4Yiv1YOl
         RJa15/3OB/aCrbbRksLcxCp9JbB9cJ6vg8kwSwdE++VmOyF/Sp4HsS8lVz14RlMI6goS
         ld7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fWUmFlZZKykaUrgHDNSTsbXcbMtqT1R3Ox7a6yZFJJo=;
        b=k9UZA6Ba5Hz+qkiTsF650d8eIjIviJG0TksIlawbJD5vTZ0gdDIsojyZvd9C2s+cfx
         aiGQmKPj/H+90khUQouR+BScgnSAzsKmI0ko7owt3Ad62dfpEC8f3WIkhf4l86ttWFgD
         gjI/sKL1svW1kyzLSWOey5ldUxWrXhNZaHCYUfTrHYVHrNwCRa97PH+rpcom6BQ0VMoq
         zggg8QfYDTrlgUwdAdQTdZnBIGerD8OCIp2KHBrW6sIfbLmwz05hRro9Pq4Z+tdCTLhN
         qNgpPhnW6bSi9ehcXoeWDvMcknlsY/pTeKOEo7fWdsbT86c3Gu6kz/ZPmk+FCbMXyyaF
         L5yw==
X-Gm-Message-State: AOAM533cdEjjmByx7vNAgaLRHFDQ9I7F+jLjfWynvTrq0taPOpN16tal
        0fBXyK+PvdhwUnn09X3Pt/s=
X-Google-Smtp-Source: ABdhPJypIQ5AwAJH6tRIC663gTN6Em0BjjdADpwbDTH0Fqq2RXW/Ozh9GcbEDjwwgOwGSqevN+VgsA==
X-Received: by 2002:a5d:65d2:: with SMTP id e18mr1066111wrw.31.1619137184499;
        Thu, 22 Apr 2021 17:19:44 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.225])
        by smtp.gmail.com with ESMTPSA id g12sm6369605wru.47.2021.04.22.17.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 17:19:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/11] io_uring: add IORING_REGISTER_RSRC
Date:   Fri, 23 Apr 2021 01:19:24 +0100
Message-Id: <814e128cc072bf0e22836b9cf629822f577625dd.1619128798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619128798.git.asml.silence@gmail.com>
References: <cover.1619128798.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a new io_uring_register() opcode for rsrc registeration. Instead of
accepting a pointer to resources, fds or iovecs, it @arg is now pointing
to a struct io_uring_rsrc_register, and the second argument tells how
large that struct is to make it easily extendible by adding new fields.

All that is done mainly to be able to pass in a pointer with tags. Pass
it in and enable CQE posting for file resources. Doesn't support setting
tags on update yet.

A design choice made here is to not post CQEs on rsrc de-registration,
but only when we updated-removed it by rsrc dynamic update.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 45 +++++++++++++++++++++++++++++++----
 include/uapi/linux/io_uring.h |  8 +++++++
 2 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 856f508a9992..9fddac644f90 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7585,7 +7585,7 @@ static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
 }
 
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
-				 unsigned nr_args)
+				 unsigned nr_args, u64 __user *tags)
 {
 	__s32 __user *fds = (__s32 __user *) arg;
 	struct file *file;
@@ -7612,17 +7612,24 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		goto out_free;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
-		if (copy_from_user(&fd, &fds[i], sizeof(fd))) {
+		u64 tag = 0;
+
+		if ((tags && copy_from_user(&tag, &tags[i], sizeof(tag))) ||
+		    copy_from_user(&fd, &fds[i], sizeof(fd))) {
 			ret = -EFAULT;
 			goto out_fput;
 		}
 		/* allow sparse sets */
-		if (fd == -1)
+		if (fd == -1) {
+			ret = -EINVAL;
+			if (unlikely(tag))
+				goto out_fput;
 			continue;
+		}
 
 		file = fget(fd);
 		ret = -EBADF;
-		if (!file)
+		if (unlikely(!file))
 			goto out_fput;
 
 		/*
@@ -7636,6 +7643,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			fput(file);
 			goto out_fput;
 		}
+		ctx->file_data->tags[i] = tag;
 		io_fixed_file_set(io_fixed_file_slot(&ctx->file_table, i), file);
 	}
 
@@ -9701,6 +9709,29 @@ static int io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 	return __io_register_rsrc_update(ctx, type, &up, nr_args);
 }
 
+static int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
+			    unsigned int size)
+{
+	struct io_uring_rsrc_register rr;
+
+	/* keep it extendible */
+	if (size != sizeof(rr))
+		return -EINVAL;
+
+	memset(&rr, 0, sizeof(rr));
+	if (copy_from_user(&rr, arg, size))
+		return -EFAULT;
+	if (!rr.nr)
+		return -EINVAL;
+
+	switch (rr.type) {
+	case IORING_RSRC_FILE:
+		return io_sqe_files_register(ctx, u64_to_user_ptr(rr.data),
+					     rr.nr, u64_to_user_ptr(rr.tags));
+	}
+	return -EINVAL;
+}
+
 static bool io_register_op_must_quiesce(int op)
 {
 	switch (op) {
@@ -9710,6 +9741,7 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_REGISTER_PROBE:
 	case IORING_REGISTER_PERSONALITY:
 	case IORING_UNREGISTER_PERSONALITY:
+	case IORING_REGISTER_RSRC:
 		return false;
 	default:
 		return true;
@@ -9782,7 +9814,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = io_sqe_buffers_unregister(ctx);
 		break;
 	case IORING_REGISTER_FILES:
-		ret = io_sqe_files_register(ctx, arg, nr_args);
+		ret = io_sqe_files_register(ctx, arg, nr_args, NULL);
 		break;
 	case IORING_UNREGISTER_FILES:
 		ret = -EINVAL;
@@ -9839,6 +9871,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	case IORING_REGISTER_RESTRICTIONS:
 		ret = io_register_restrictions(ctx, arg, nr_args);
 		break;
+	case IORING_REGISTER_RSRC:
+		ret = io_register_rsrc(ctx, arg, nr_args);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d363e0c4fd21..ce7b2fce6713 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -298,6 +298,7 @@ enum {
 	IORING_UNREGISTER_PERSONALITY		= 10,
 	IORING_REGISTER_RESTRICTIONS		= 11,
 	IORING_REGISTER_ENABLE_RINGS		= 12,
+	IORING_REGISTER_RSRC			= 13,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
@@ -320,6 +321,13 @@ enum {
 	IORING_RSRC_FILE		= 0,
 };
 
+struct io_uring_rsrc_register {
+	__u32 type;
+	__u32 nr;
+	__aligned_u64 data;
+	__aligned_u64 tags;
+};
+
 /* Skip updating fd indexes set to this value in the fd table */
 #define IORING_REGISTER_FILES_SKIP	(-2)
 
-- 
2.31.1

