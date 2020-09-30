Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F0C27F2D5
	for <lists+io-uring@lfdr.de>; Wed, 30 Sep 2020 22:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbgI3UAq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Sep 2020 16:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3UAp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Sep 2020 16:00:45 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FCFC061755
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 13:00:44 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id k18so731095wmj.5
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 13:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=S0pccyFfALH5e23YlFipnPD7zBuh/aMICPMSrVqfd8w=;
        b=gf/lQ6Rn+3Wco/Nrcj6bJJ0qMxLn7jlVXQCOfVtjTkJdxP7vp0M+eEr8wB+WPkHG44
         5kJHyXuD+dDD5b32AX6alrwf3pJghIGMvqzzjmps96LP9VUDg2N8TxB02va76+t4T5T3
         yHvk346P9lrg3yZl5vFPbEvAE1FcuQpN4zTUFJqqN2QS1g+24Ei2WmIX/vreMfctDQw3
         T2tBeKlqfyqLlE5VoX9F/WaqxyvYV5E1+V3ziX8r1aIVQekxSWB32ryhbVWC0nOVpOBi
         2AVI2+X1PuIb6fzjV/9xL/BtbFxAmahKdVjo79jlJ6quD3/edREznow3YnAv56W+L3mN
         Vg9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S0pccyFfALH5e23YlFipnPD7zBuh/aMICPMSrVqfd8w=;
        b=UdfAFJHq18Gdjf1tkJNSbuU5hcjvP5zoXusnEO2drDdcFF9c9a4VuRjHPJYSXSZ2vC
         gCUJT1piMR5LRFRIJdlCjU2g8RoMagJf123bYfAsHilawSjdilEXhfaIjO4WXU30P9ZP
         W5ix8mPS2zmxh5MSwySmiOZKgbQQML4xYZbbWRD/9aTomR8AM3JxP7jiITAqzVez4j/s
         /WRNjxDy3viJ+qzHhUc1FSCCv9ZiE6S1WsbYTeFsWeAAzrdF7I0vqAaTmVzzxsHuNSTK
         qifZLyTwBoU3UJ75gG1nxKTyx3kGh/pRQzzRcQbnotDf9qYEFNDOpaWurUEOnchoXS58
         f49A==
X-Gm-Message-State: AOAM53036KkOLTPEvTR6y3LlybNoKtP6fxXa0WuKesWlh+AuqtFFKsTW
        6XxUS04XU0Y7n1+H2qxIbm223Jj0wi8=
X-Google-Smtp-Source: ABdhPJyVV0BP9NPY3go6eYTv36gtA4tXd7uc9MhUH5NDI24C+vsr+D0s/qQDZ5MWIXcPTlRJ67+DCA==
X-Received: by 2002:a7b:cd8b:: with SMTP id y11mr4804571wmj.172.1601496042824;
        Wed, 30 Sep 2020 13:00:42 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-194.range109-152.btcentralplus.com. [109.152.100.194])
        by smtp.gmail.com with ESMTPSA id x17sm5127176wrg.57.2020.09.30.13.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 13:00:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/4] io_uring: set/clear IOCB_NOWAIT into io_read/write
Date:   Wed, 30 Sep 2020 22:57:53 +0300
Message-Id: <84661a5e2224327d0e936639aaa996134d984515.1601495335.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1601495335.git.asml.silence@gmail.com>
References: <cover.1601495335.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move setting IOCB_NOWAIT from io_prep_rw() into io_read()/io_write(), so
it's set/cleared in a single place. Also remove @force_nonblock
parameter from io_prep_rw().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e13692f692f5..2256ecec7299 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2531,8 +2531,7 @@ static bool io_file_supports_async(struct file *file, int rw)
 	return file->f_op->write_iter != NULL;
 }
 
-static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-		      bool force_nonblock)
+static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -2570,9 +2569,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (kiocb->ki_flags & IOCB_DIRECT)
 		io_get_req_task(req);
 
-	if (force_nonblock)
-		kiocb->ki_flags |= IOCB_NOWAIT;
-
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		if (!(kiocb->ki_flags & IOCB_DIRECT) ||
 		    !kiocb->ki_filp->f_op->iopoll)
@@ -3051,7 +3047,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 {
 	ssize_t ret;
 
-	ret = io_prep_rw(req, sqe, force_nonblock);
+	ret = io_prep_rw(req, sqe);
 	if (ret)
 		return ret;
 
@@ -3185,6 +3181,9 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	/* Ensure we clear previously set non-block flag */
 	if (!force_nonblock)
 		kiocb->ki_flags &= ~IOCB_NOWAIT;
+	else
+		kiocb->ki_flags |= IOCB_NOWAIT;
+
 
 	/* If the file doesn't support async, just async punt */
 	if (force_nonblock && !io_file_supports_async(req->file, READ))
@@ -3273,7 +3272,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 {
 	ssize_t ret;
 
-	ret = io_prep_rw(req, sqe, force_nonblock);
+	ret = io_prep_rw(req, sqe);
 	if (ret)
 		return ret;
 
@@ -3308,7 +3307,9 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 
 	/* Ensure we clear previously set non-block flag */
 	if (!force_nonblock)
-		req->rw.kiocb.ki_flags &= ~IOCB_NOWAIT;
+		kiocb->ki_flags &= ~IOCB_NOWAIT;
+	else
+		kiocb->ki_flags |= IOCB_NOWAIT;
 
 	/* If the file doesn't support async, just async punt */
 	if (force_nonblock && !io_file_supports_async(req->file, WRITE))
-- 
2.24.0

