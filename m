Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B545330F46C
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbhBDN7i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 08:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236532AbhBDN51 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 08:57:27 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8695BC061351
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 05:56:12 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id i9so3074163wmq.1
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 05:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2wWCtLxp198SoW00TGPa5sMcyBJEKQnt27XqwVR48fo=;
        b=gBstv9Mrx8j73VxzYCVmgjB3RPKSWvefOs0OleaHAq3NiMDz2GIA0lvDnosh3EzYsJ
         2ll/QYxdTlPP1rz+0p3NGXqm8u8DqFVkvp9mjxStagxXHfhGqkVZzzxG664aEgNZDkgv
         AlIOHbqNnHpXTUZqJVGpyPary9IUGzP5TtYbUT+nJ7rlPX/migRh6p2/gPlhmaoOCdpZ
         2/LheqJ9fzx9+oIa3htkeZWXRLKH4N/rhmBBhQ68SHJd8FKLESXzun/lD40KLAXpit3G
         cwfrn+LGykwash7nCOEhCaFY9Wf8uiGNvp08G+nc3W+X639zlgHRG6VNAQjyYoC/jzbg
         S1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2wWCtLxp198SoW00TGPa5sMcyBJEKQnt27XqwVR48fo=;
        b=XvvFxP0Cm0Q6BgF49Yqd8MEitMSMJ9FzTcjEogvhEtQzOtq9cWkgmQHGpGs5lNQ8/2
         W7/9jNTQSLHsT+O6uMEqafWvVfJ/OdUsDYadZcKjlEJDTi+Wej6DgcqQCBA3T/8nelpS
         L5lxJr76N5FzeYiqnhGXOTjQRZi3piET4erxxbGFBkY1lDVi3o4S8FlBFGLVaR17pUDi
         74T/fNH+hJnRdQa3D+GoHhNfBLa3WbEnJf1wHHmQQ0SX/pWXDanIbiOddSa6KeINrD+q
         BHT85O2FIfFmZHvV58obJqZjy40bgjgC5Q/Rws/oRfsm1EcNrISJ6SAHJMqFwV3GUNtF
         j3YA==
X-Gm-Message-State: AOAM532NklimVAS4Jyd/ydweoBieiZtMPkvihRywsHOkznjdvlAT0AhS
        Sly847zJR0weD+oyK63u+EGEvVOxWb0QVg==
X-Google-Smtp-Source: ABdhPJxO7w2P41xnS5tgt7DGDagAfDL69GO8l+OdFVGNQamHqTWjuNe7CZKdszpsx4Y6j3l4wwLRXA==
X-Received: by 2002:a05:600c:2742:: with SMTP id 2mr7590420wmw.7.1612446971253;
        Thu, 04 Feb 2021 05:56:11 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id k4sm8910561wrm.53.2021.02.04.05.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 05:56:10 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 10/13] io_uring: treat NONBLOCK and RWF_NOWAIT similarly
Date:   Thu,  4 Feb 2021 13:52:05 +0000
Message-Id: <d8067f0604f06dbda96dca028acd170d024abe52.1612446019.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612446019.git.asml.silence@gmail.com>
References: <cover.1612446019.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make decision making of whether we need to retry read/write similar for
O_NONBLOCK and RWF_NOWAIT. Set REQ_F_NOWAIT when either is specified and
use it for all relevant checks. Also fix resubmitting NOWAIT requests
via io_rw_reissue().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bbf8ea8370d6..ce2ea3f55f65 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2734,7 +2734,9 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
 	if (res != -EAGAIN && res != -EOPNOTSUPP)
 		return false;
 	mode = file_inode(req->file)->i_mode;
-	if ((!S_ISBLK(mode) && !S_ISREG(mode)) || io_wq_current_is_worker())
+	if (!S_ISBLK(mode) && !S_ISREG(mode))
+		return false;
+	if ((req->flags & REQ_F_NOWAIT) || io_wq_current_is_worker())
 		return false;
 
 	lockdep_assert_held(&req->ctx->uring_lock);
@@ -2907,16 +2909,17 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct kiocb *kiocb = &req->rw.kiocb;
+	struct file *file = req->file;
 	unsigned ioprio;
 	int ret;
 
-	if (S_ISREG(file_inode(req->file)->i_mode))
+	if (S_ISREG(file_inode(file)->i_mode))
 		req->flags |= REQ_F_ISREG;
 
 	kiocb->ki_pos = READ_ONCE(sqe->off);
-	if (kiocb->ki_pos == -1 && !(req->file->f_mode & FMODE_STREAM)) {
+	if (kiocb->ki_pos == -1 && !(file->f_mode & FMODE_STREAM)) {
 		req->flags |= REQ_F_CUR_POS;
-		kiocb->ki_pos = req->file->f_pos;
+		kiocb->ki_pos = file->f_pos;
 	}
 	kiocb->ki_hint = ki_hint_validate(file_write_hint(kiocb->ki_filp));
 	kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
@@ -2924,6 +2927,10 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(ret))
 		return ret;
 
+	/* don't allow async punt for O_NONBLOCK or RWF_NOWAIT */
+	if ((kiocb->ki_flags & IOCB_NOWAIT) || (file->f_flags & O_NONBLOCK))
+		req->flags |= REQ_F_NOWAIT;
+
 	ioprio = READ_ONCE(sqe->ioprio);
 	if (ioprio) {
 		ret = ioprio_check_cap(ioprio);
@@ -2934,10 +2941,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	} else
 		kiocb->ki_ioprio = get_current_ioprio();
 
-	/* don't allow async punt if RWF_NOWAIT was requested */
-	if (kiocb->ki_flags & IOCB_NOWAIT)
-		req->flags |= REQ_F_NOWAIT;
-
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		if (!(kiocb->ki_flags & IOCB_DIRECT) ||
 		    !kiocb->ki_filp->f_op->iopoll)
@@ -3546,15 +3549,14 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		/* IOPOLL retry should happen for io-wq threads */
 		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
 			goto done;
-		/* no retry on NONBLOCK marked file */
-		if (req->file->f_flags & O_NONBLOCK)
+		/* no retry on NONBLOCK nor RWF_NOWAIT */
+		if (req->flags & REQ_F_NOWAIT)
 			goto done;
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = 0;
 	} else if (ret <= 0 || ret == io_size || !force_nonblock ||
-		   (req->file->f_flags & O_NONBLOCK) ||
-		   !(req->flags & REQ_F_ISREG)) {
+		   (req->flags & REQ_F_NOWAIT) || !(req->flags & REQ_F_ISREG)) {
 		/* read all, failed, already did sync or don't want to retry */
 		goto done;
 	}
@@ -3675,8 +3677,8 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	 */
 	if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
 		ret2 = -EAGAIN;
-	/* no retry on NONBLOCK marked file */
-	if (ret2 == -EAGAIN && (req->file->f_flags & O_NONBLOCK))
+	/* no retry on NONBLOCK nor RWF_NOWAIT */
+	if (ret2 == -EAGAIN && (req->flags & REQ_F_NOWAIT))
 		goto done;
 	if (!force_nonblock || ret2 != -EAGAIN) {
 		/* IOPOLL retry should happen for io-wq threads */
-- 
2.24.0

