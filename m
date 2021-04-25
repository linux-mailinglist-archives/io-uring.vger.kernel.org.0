Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CB836A78A
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 15:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhDYNdY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 09:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhDYNdX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 09:33:23 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3208C061574
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:43 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id x7so53023348wrw.10
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pbrB4I3LU9mqN0KUAJFL7+jet7mtfBQkfWDEclzq6Ig=;
        b=CKP/+U2esBDvaNdlaDYU8d9sDoz0CBJspALaCGy+PbTnSPPjymlmfN1khtEbAgSTJD
         972CXQJ46jb1DS4S38PtePMyuJUrmPgZgpsLWPdzFsuk5fEUzjRnbjA20+5TX0F9gERD
         EdIh8urI6LWgx1805O4Teg0DMOhEZkYPjw17zH0Nps/s5k2/neMEtBH9xSI1DvVZZbdM
         3uVHxYWUv2MvTcqOACml3l3wt++qCr4JNog6s/yWY9TSJ7ZKMb4QWm9eF3bjZeUVIJB8
         IkiaxCw7kArdj+dFKN6RyOFWKuW22FbxAh0ge5KdH6TUZ/L4t7lJGrb0JaYxP4m7k38a
         2v5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pbrB4I3LU9mqN0KUAJFL7+jet7mtfBQkfWDEclzq6Ig=;
        b=F0lDqOgWsgNIQu2nl7zD65aFUGkCzP3qFe5mTUHCpxmHpm+e9LQGXo9840mCRxNIaA
         ATx/BvH1tqGGliC7/cCmR37VVs70qgOMs5cXGu+ktiFm9VxfiMZpECOpucKAvJYuweF8
         KDGiJg7Q7RuhjrILr73pzWF+9ebKiWs8bwYl0RY+y6DEht2/RHDnReTnV/FvuHHEiiQr
         ZOX7eeryXNRPArK+TQZgciwv5GEGgUVXu/NGCxxjR6tfAo6ibAyEUZlUUzv/DurA1bZZ
         45nFo8fOYouXEojGaZmxSkdf/prwvMrLi2UNdaSeLw0535FMOGInHQya2RmkD+qM8qkh
         cT3Q==
X-Gm-Message-State: AOAM530RXjszTArnNDfhppFeCxOH+4DhPW33MX6h6PtmS25C1ZHZ+pUS
        06JVkPwpoE4DXQZY3lFFwe4=
X-Google-Smtp-Source: ABdhPJymhy7GmuKPkuZNcGkcw/BT09GIRnOcKKTCQprupu4fpO14ynFo8UgnFaalSNfzEAEBWmKSYg==
X-Received: by 2002:a05:6000:192:: with SMTP id p18mr9767246wrx.347.1619357562463;
        Sun, 25 Apr 2021 06:32:42 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.108])
        by smtp.gmail.com with ESMTPSA id a2sm16551552wrt.82.2021.04.25.06.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 06:32:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 07/12] io_uring: add IORING_REGISTER_RSRC
Date:   Sun, 25 Apr 2021 14:32:21 +0100
Message-Id: <c498aaec32a4bb277b2406b9069662c02cdda98c.1619356238.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619356238.git.asml.silence@gmail.com>
References: <cover.1619356238.git.asml.silence@gmail.com>
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
index cfd5164952e8..3e7d96e25ec3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7584,7 +7584,7 @@ static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
 }
 
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
-				 unsigned nr_args)
+				 unsigned nr_args, u64 __user *tags)
 {
 	__s32 __user *fds = (__s32 __user *) arg;
 	struct file *file;
@@ -7611,17 +7611,24 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -7635,6 +7642,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			fput(file);
 			goto out_fput;
 		}
+		ctx->file_data->tags[i] = tag;
 		io_fixed_file_set(io_fixed_file_slot(&ctx->file_table, i), file);
 	}
 
@@ -9700,6 +9708,29 @@ static int io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
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
@@ -9709,6 +9740,7 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_REGISTER_PROBE:
 	case IORING_REGISTER_PERSONALITY:
 	case IORING_UNREGISTER_PERSONALITY:
+	case IORING_REGISTER_RSRC:
 		return false;
 	default:
 		return true;
@@ -9781,7 +9813,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = io_sqe_buffers_unregister(ctx);
 		break;
 	case IORING_REGISTER_FILES:
-		ret = io_sqe_files_register(ctx, arg, nr_args);
+		ret = io_sqe_files_register(ctx, arg, nr_args, NULL);
 		break;
 	case IORING_UNREGISTER_FILES:
 		ret = -EINVAL;
@@ -9838,6 +9870,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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

