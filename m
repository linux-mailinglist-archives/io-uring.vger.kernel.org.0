Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5AE520198
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 17:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238658AbiEIPzD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 11:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238659AbiEIPy6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 11:54:58 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF064E3B7
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 08:51:04 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id f4so15777274iov.2
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 08:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rDq+G0RCABvfcA1fnVHDsZduwUR3ZI3hWGksraQbEsQ=;
        b=Bs4IoYUjFFJgkbXhKyT2dD4mNFc0b2qRSlb1R8m5kmlORDGyMSGnlq3xLp6wMO+FGz
         C01RPFPdd2bqKGoTlDQKfTbgM1zuGPCHOnAy+AxKwKttZ1klAr2aE+7cbqOpgNjBgVJh
         O4jNWueoAUHL8fj8LBtJoe7T/sq920QdFzGeq11kZlM9jWhN9yqCpleQ/SvBKznOZG7s
         Ip3JRNKdNar52/fhlxbntPhcz46WsetJI3NU2xa1QFWHCb0CdMsYjUWVLzmLGU3Uw4zc
         x6ZOw7OncdT73cysP45rRwNztI6vtivQyYfIUpwzg01b4Kjd7L41DTXtw6w4GPqFe7cZ
         Nclw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rDq+G0RCABvfcA1fnVHDsZduwUR3ZI3hWGksraQbEsQ=;
        b=LO0dlFb2w34xSnxaBX3OnFewM+D023dzChWGPD/XukUMjsgaU1DMURkKQD+gq0lRC5
         qBnXIfs4M1ey+9/L5uaQVCtqR56D0SuMqhDauGrPR7C30JfwEy1SEKu5z1FKtTmMGmuD
         1sDlSBjFheSZFbqsKZnSEvtrq0V7jlfKw911sPJpNPDGVjdf3dxS8fYSjhKZnvSBI5DA
         W0WU2s5RoWawIFv0S7pVc80TymlkYmfOS7ZykGTtsGtsFt0/OUF3ODKpnw6DUtdHmC3e
         HeB4t9P6F7pM0VYz8fd/zbDzhqYY031CPqB5ptN1vihZZLwilhVzBwr0iGZd2tqmjCta
         wOhw==
X-Gm-Message-State: AOAM530kWTCk7cx8xW2qC3FupkCh+nS9urzw3QNuejhMIe0pX/njwttV
        yOexjrshSFT4KeE8QtCb/UH82tTaa6gtYw==
X-Google-Smtp-Source: ABdhPJyqCUBDvNL4dLHrscE20bCFHw+lbJLSoIEc4hkYN4l4srntaMx6+CyqIxVVIc2do/v0Ao+V5w==
X-Received: by 2002:a5d:8504:0:b0:657:724e:5420 with SMTP id q4-20020a5d8504000000b00657724e5420mr6539385ion.147.1652111463150;
        Mon, 09 May 2022 08:51:03 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a1-20020a056638004100b0032b3a78177esm3696499jap.66.2022.05.09.08.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 08:51:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, haoxu.linux@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring: add flag for allocating a fully sparse direct descriptor space
Date:   Mon,  9 May 2022 09:50:55 -0600
Message-Id: <20220509155055.72735-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220509155055.72735-1-axboe@kernel.dk>
References: <20220509155055.72735-1-axboe@kernel.dk>
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

Currently to setup a fully sparse descriptor space upfront, the app needs
to alloate an array of the full size and memset it to -1 and then pass
that in. Make this a bit easier by allowing a flag that simply does
this internally rather than needing to copy each slot separately.

This works with IORING_REGISTER_FILES2 as the flag is set in struct
io_uring_rsrc_register, and is only allow when the type is
IORING_RSRC_FILE as this doesn't make sense for registered buffers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 15 ++++++++++++---
 include/uapi/linux/io_uring.h |  8 +++++++-
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 644f57a46c5f..fe67fe939fac 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9107,12 +9107,12 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
 		struct io_fixed_file *file_slot;
 
-		if (copy_from_user(&fd, &fds[i], sizeof(fd))) {
+		if (fds && copy_from_user(&fd, &fds[i], sizeof(fd))) {
 			ret = -EFAULT;
 			goto fail;
 		}
 		/* allow sparse sets */
-		if (fd == -1) {
+		if (!fds || fd == -1) {
 			ret = -EINVAL;
 			if (unlikely(*io_get_tag_slot(ctx->file_data, i)))
 				goto fail;
@@ -11755,14 +11755,20 @@ static __cold int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 	memset(&rr, 0, sizeof(rr));
 	if (copy_from_user(&rr, arg, size))
 		return -EFAULT;
-	if (!rr.nr || rr.resv || rr.resv2)
+	if (!rr.nr || rr.resv2)
+		return -EINVAL;
+	if (rr.flags & ~IORING_RSRC_REGISTER_SPARSE)
 		return -EINVAL;
 
 	switch (type) {
 	case IORING_RSRC_FILE:
+		if (rr.flags & IORING_RSRC_REGISTER_SPARSE && rr.data)
+			break;
 		return io_sqe_files_register(ctx, u64_to_user_ptr(rr.data),
 					     rr.nr, u64_to_user_ptr(rr.tags));
 	case IORING_RSRC_BUFFER:
+		if (rr.flags & IORING_RSRC_REGISTER_SPARSE)
+			break;
 		return io_sqe_buffers_register(ctx, u64_to_user_ptr(rr.data),
 					       rr.nr, u64_to_user_ptr(rr.tags));
 	}
@@ -11931,6 +11937,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = io_sqe_buffers_unregister(ctx);
 		break;
 	case IORING_REGISTER_FILES:
+		ret = -EFAULT;
+		if (!arg)
+			break;
 		ret = io_sqe_files_register(ctx, arg, nr_args, NULL);
 		break;
 	case IORING_UNREGISTER_FILES:
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b7f02a55032a..d09cf7c0d1fe 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -396,9 +396,15 @@ struct io_uring_files_update {
 	__aligned_u64 /* __s32 * */ fds;
 };
 
+/*
+ * Register a fully sparse file sparse, rather than pass in an array of all
+ * -1 file descriptors.
+ */
+#define IORING_RSRC_REGISTER_SPARSE	(1U << 0)
+
 struct io_uring_rsrc_register {
 	__u32 nr;
-	__u32 resv;
+	__u32 flags;
 	__u64 resv2;
 	__aligned_u64 data;
 	__aligned_u64 tags;
-- 
2.35.1

