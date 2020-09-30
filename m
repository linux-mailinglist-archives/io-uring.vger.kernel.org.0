Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F91C27F2CF
	for <lists+io-uring@lfdr.de>; Wed, 30 Sep 2020 22:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgI3UAU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Sep 2020 16:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgI3UAU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Sep 2020 16:00:20 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD4AC061755
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 13:00:20 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e17so740546wme.0
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 13:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4MhFWlrSoBrRavWw2vXclH9OKETHzCgxj9nCTyo/HR0=;
        b=BQAGjtaBUGGcEQrPaWgLxeh5B+epGWWrFbrVp1u27YtXJfp6BW3z01fiBLurhvQae6
         577CgoiYI67L0v6hp1XNFaF+pPJ1SJ53PGdX5HMY5f4H6KLnP2Bnkv2YmVbe15wEyid8
         uVWcjAl/WJuee1DxxZg66tGjs4ACSAv2GkRAQzI/IEEMzVmBe3FBnWuyDsvfozHeolGg
         Af9O1ZOMblNk5odj5aRpq8Dx2goqqZwVOuTV3ms3SjHPJjwpQdto2LJR0IqsyGhNr3dZ
         t92wB8DkdkXOJ+WrgA/fZMnqcqsrsEHCYe39vp0o+1rKXdvRwEvYk4uzxr3ajoNeyMCe
         gjGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4MhFWlrSoBrRavWw2vXclH9OKETHzCgxj9nCTyo/HR0=;
        b=OD2K5HXQ1X28jRkfiQPHEsLvgsPh0HSO4YaA65gnCvaGfl5e/GqlFxcuSaX7BvRBGZ
         yYQ7hsV/2T+W+vOPbNUjPgNy/XxG0OY7/e5zNGOWFWCF6UabCRpUJWs+xX6J48t1R8/D
         EHcxFxdtu1hXynuDFIy/hCGFiPO2BbdTlbz56BxCZr3GAbJTV9gmfSfTIjp3V0GV0wAb
         hORhwT9SahuKtmRfuUm5BEVRVIR6LpxHnxjYq3z1aQYllYiXkGzu+U5ExOlYX4bthBWi
         vsoudzgg5TxokXfL9V7BZWjZe8w5/KjPMqZ3XtWHyxCsEW6aJ7dJHOUlhm3QSqna7jI6
         KNuQ==
X-Gm-Message-State: AOAM5335JOlGNONLz3dPDztEEhPhzFTXWV2q9aTezqAkFHFtygnhzRYs
        GuPJkRKMDMAraP1ZOytfcDY=
X-Google-Smtp-Source: ABdhPJw7xuS9cKoMSQdji/Ghr1TuKJw7LHhZB40gZ61nVkst3XKQacoJc7JWImeLUrfaf49MyzExlA==
X-Received: by 2002:a1c:96cf:: with SMTP id y198mr4956606wmd.104.1601496019028;
        Wed, 30 Sep 2020 13:00:19 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-194.range109-152.btcentralplus.com. [109.152.100.194])
        by smtp.gmail.com with ESMTPSA id t17sm4722455wrx.82.2020.09.30.13.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 13:00:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next] io_uring: remove F_NEED_CLEANUP check in *prep()
Date:   Wed, 30 Sep 2020 22:57:35 +0300
Message-Id: <2a5e3d1a3f85acd9481f94cc9636f1b2b7c12ed2.1601492291.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

REQ_F_NEED_CLEANUP is set only by io_*_prep() and they're guaranteed to
be called only once, so there is no one who may have set the flag
before. Kill REQ_F_NEED_CLEANUP check in these *prep() handlers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 631648dd63ac..33892c992b34 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3064,7 +3064,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		return -EBADF;
 
 	/* either don't need iovec imported or already have it */
-	if (!req->async_data || req->flags & REQ_F_NEED_CLEANUP)
+	if (!req->async_data)
 		return 0;
 	return io_rw_prep_async(req, READ, force_nonblock);
 }
@@ -3286,7 +3286,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		return -EBADF;
 
 	/* either don't need iovec imported or already have it */
-	if (!req->async_data || req->flags & REQ_F_NEED_CLEANUP)
+	if (!req->async_data)
 		return 0;
 	return io_rw_prep_async(req, WRITE, force_nonblock);
 }
@@ -3425,8 +3425,6 @@ static int __io_splice_prep(struct io_kiocb *req,
 	unsigned int valid_flags = SPLICE_F_FD_IN_FIXED | SPLICE_F_ALL;
 	int ret;
 
-	if (req->flags & REQ_F_NEED_CLEANUP)
-		return 0;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
@@ -3636,8 +3634,6 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	u64 flags, mode;
 
-	if (req->flags & REQ_F_NEED_CLEANUP)
-		return 0;
 	mode = READ_ONCE(sqe->len);
 	flags = READ_ONCE(sqe->open_flags);
 	req->open.how = build_open_how(flags, mode);
@@ -3650,8 +3646,6 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	size_t len;
 	int ret;
 
-	if (req->flags & REQ_F_NEED_CLEANUP)
-		return 0;
 	how = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	len = READ_ONCE(sqe->len);
 	if (len < OPEN_HOW_SIZE_VER0)
@@ -4160,10 +4154,6 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (!async_msg || !io_op_defs[req->opcode].needs_async_data)
 		return 0;
-	/* iovec is already imported */
-	if (req->flags & REQ_F_NEED_CLEANUP)
-		return 0;
-
 	ret = io_sendmsg_copy_hdr(req, async_msg);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
@@ -4390,10 +4380,6 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 
 	if (!async_msg || !io_op_defs[req->opcode].needs_async_data)
 		return 0;
-	/* iovec is already imported */
-	if (req->flags & REQ_F_NEED_CLEANUP)
-		return 0;
-
 	ret = io_recvmsg_copy_hdr(req, async_msg);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
-- 
2.24.0

