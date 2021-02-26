Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452CC326232
	for <lists+io-uring@lfdr.de>; Fri, 26 Feb 2021 12:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhBZLye (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Feb 2021 06:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbhBZLyV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Feb 2021 06:54:21 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC5AC061574
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 03:53:41 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id u14so8318419wri.3
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 03:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L51Ag6auSFtCHJyAD+hefXh7zMJnWLPxQja8aQgSXhw=;
        b=ILEU25/ZUJe91suiB7dZEENTFkm1FTXJoHqX2Wyay9nmqtky7qdm+IWIRrEKbe+HO0
         KksYckeiIuCoFuiYljaCbuVUtg/b2RbzVmt3a+JlpL+Jn8QmbXdAbJxG4V2rqx77fh1V
         sbTEXKzVp8BPLcyqBB1djqIeOVoj3PruaL1RSc1at6L/VMdn37NTPBxWe7pcOXD0gZVx
         wqUyUgO21U2V4oLem006KIOCwd0szSM0j+zFGl2mTzMEWcrKSx9X7FF/NU8x0AWVgaGH
         SINnTEfp5XKQb8bzqQmwMwy8Hqld45fHxGnmmxrl1YtlH4F4tQAVYuN+9Ub25gC7/+BX
         FUiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L51Ag6auSFtCHJyAD+hefXh7zMJnWLPxQja8aQgSXhw=;
        b=HxooIcldwFDeYrvsSdyUx0IbdHGvZDspxaZ//4LPe405+lbWaV9ZlSOY3BD6wJqexj
         4jfxNPXgsZWZpFAg3F5A+PCqS0JqiqMW/QMAglTeCciPRLDiy/4USupe7GbI+SqPD4IZ
         gVfFDhqztsnFXnr0vxj2YXfCk8pc523hI6z2QGTmHxwb3f5zwjEPPVECdCVqtTr9yV4h
         Mei7qo5YQ2JIHpkYiTt84UGxdFLDWSLXCaGqc/+bFp632SbESdSEA9dp22IQKGHuGFSy
         BbM5i26C9L/+cqI3eSA5TQamIS+2ecYTD1Ap3f9r+zUQFqMj3xPGze9bXCGg6tFFdAAO
         IH8w==
X-Gm-Message-State: AOAM532y6sYqks5SYA2WxibJs/YgZMdi2qIRDWq4lrmoyH9jw8/55w+Q
        Yb1oAdFkYsuKnSuJLCtEOoI=
X-Google-Smtp-Source: ABdhPJwYI/cg77xIPUqe2p2Eo2GoMgqtaDbxPAtBvXGBGp5jzq/A4x9MqdcJJzUS1IQ7e2lP7R8XHA==
X-Received: by 2002:adf:d082:: with SMTP id y2mr2814203wrh.293.1614340419832;
        Fri, 26 Feb 2021 03:53:39 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id e12sm13073674wrv.59.2021.02.26.03.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 03:53:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH] io_uring: don't re-read iovecs in iopoll_complete
Date:   Fri, 26 Feb 2021 11:49:38 +0000
Message-Id: <562147f55c4adc3518e26ca2b96daebecc9078c5.1614340011.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Request submission and iopolling might happen from different syscalls,
so iovec backing a request may be already freed by the userspace.

Catch -EAGAIN passed during submission but through ki_complete, i.e.
io_complete_rw_iopoll(), and try to setup an async context there
similarly as we do in io_complete_rw().

Because io_iopoll_req_issued() happens after, just leave it be until
iopoll reaps the request and reissues it, or potentially sees that async
setup failed and post CQE with an error.

Cc: <stable@vger.kernel.org> # 5.9+
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Reported-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Jens, that assumption that -EAGAIN comes only when haven't yet gone
async is on you.

 fs/io_uring.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5c8e24274acf..9fa8ff227f75 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2610,8 +2610,11 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		list_del(&req->inflight_entry);
 
 		if (READ_ONCE(req->result) == -EAGAIN) {
+			bool reissue = req->async_data ||
+				!io_op_defs[req->opcode].needs_async_data;
+
 			req->iopoll_completed = 0;
-			if (io_rw_reissue(req))
+			if (reissue && io_rw_reissue(req))
 				continue;
 		}
 
@@ -2794,9 +2797,9 @@ static void kiocb_end_write(struct io_kiocb *req)
 	file_end_write(req->file);
 }
 
-#ifdef CONFIG_BLOCK
 static bool io_resubmit_prep(struct io_kiocb *req)
 {
+#ifdef CONFIG_BLOCK
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	int rw, ret;
 	struct iov_iter iter;
@@ -2826,8 +2829,9 @@ static bool io_resubmit_prep(struct io_kiocb *req)
 	if (ret < 0)
 		return false;
 	return !io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
-}
 #endif
+	return false;
+}
 
 static bool io_rw_reissue(struct io_kiocb *req)
 {
@@ -2892,8 +2896,14 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
 
-	if (res != -EAGAIN && res != req->result)
+	if (res == -EAGAIN) {
+		if (percpu_ref_is_dying(&req->ctx->refs))
+			res = -EFAULT;
+		else if (!(req->flags & REQ_F_NOWAIT) && !io_wq_current_is_worker())
+			io_resubmit_prep(req);
+	} else if (res != req->result) {
 		req_set_fail_links(req);
+	}
 
 	WRITE_ONCE(req->result, res);
 	/* order with io_poll_complete() checking ->result */
-- 
2.24.0

