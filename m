Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01AAA40C332
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 12:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbhIOKCJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 06:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbhIOKCH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 06:02:07 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A10C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 03:00:48 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id q26so2908377wrc.7
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 03:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dIdbRJ3POeT5ftza9YtgdZF8EiZRmDjuXQPJwHCNHJ8=;
        b=eY3b0XdB8F6CUQ+pkQEln4hmwHMeRqkYCnfaBLAHMaPovjhnyB02l4wj+J3x6nxLwk
         bKyoWdsdbhud3sUsBPlzZ36IXK3HsAqi41Km8KRQFotJtJDn6kHKBLtZithZkVqQlKMI
         rUV+3l7nOwqihJSstq5HdIwizldI6roBrDIwwkD4uNccu98SJdknF8qE3ILvseTQG8rM
         N2HI2j1Q7fwXE445KmKaF1RSW/TyP/ehxYonNsdRdbhjFNhBKu/Pk18yZ1bHyuz80kcA
         LW7Re4CQbr1HFW/GnvI86kzayqzpSq6JmIc5vYPOWy3RXLsCgV1k+8wwTdr9YCjkYl5L
         ugtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dIdbRJ3POeT5ftza9YtgdZF8EiZRmDjuXQPJwHCNHJ8=;
        b=vfezQSA+u7tfWQlQRZnKdR18e01OoidrACGAnTBpckfCEfIkLOu07kpY61y5KsaTT7
         I22lGgMDOVMYHKEuV6qUbuv+Th5pctKZeg49PYBH7yeUJMFs65zyUGuar5hZ2tmdlTKQ
         PSbk1mot8y+5ztJcW6st6pXHjfVRFE4hNxBi8F+7CQo6T1Jmkb9naUoG3vNCQ0/1n5cs
         uneS6lg2yOdbWrdfElaVmkN/EX/8aXfiLPRDj+YXpFWWQwzjutbmTapqfb1+BQpxvtIP
         HbnajQTp/ZMaH1eX42Eo0j689OzJAkHfupEbKIfwzvVrQj3tPq3eshqPuWoPrsqV54Zs
         j0ww==
X-Gm-Message-State: AOAM533Ua9SkWqo8Qw6TEpxYAIGFZ44YmYn6wiQwpjvT6vAJJSvedUCY
        Ba+F0hv8PNnM0zABMaQb/nUC+/Az1ls=
X-Google-Smtp-Source: ABdhPJwZWJFBTNFbZKeVOwQft2mf/i3z2oXeGzuwMDFDwrI7kOzHx1XuJpRDSeGJ/p58HmM4MQk3YA==
X-Received: by 2002:a5d:59ad:: with SMTP id p13mr3916424wrr.253.1631700046750;
        Wed, 15 Sep 2021 03:00:46 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.239])
        by smtp.gmail.com with ESMTPSA id g1sm3873931wrr.2.2021.09.15.03.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 03:00:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2] io_uring: move iopoll reissue into regular IO path
Date:   Wed, 15 Sep 2021 11:00:05 +0100
Message-Id: <f80dfee2d5fa7678f0052a8ab3cfca9496a112ca.1631699928.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

230d50d448acb ("io_uring: move reissue into regular IO path")
made non-IOPOLL I/O to not retry from ki_complete handler. Follow it
steps and do the same for IOPOLL. Same problems, same implementation,
same -EAGAIN assumptions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: rebase, kiocb_done() locking for iopoll completion

 fs/io_uring.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ae489ab275dd..a736a7826a36 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -735,7 +735,6 @@ enum {
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_COMPLETE_INLINE_BIT,
 	REQ_F_REISSUE_BIT,
-	REQ_F_DONT_REISSUE_BIT,
 	REQ_F_CREDS_BIT,
 	REQ_F_REFCOUNT_BIT,
 	REQ_F_ARM_LTIMEOUT_BIT,
@@ -782,8 +781,6 @@ enum {
 	REQ_F_COMPLETE_INLINE	= BIT(REQ_F_COMPLETE_INLINE_BIT),
 	/* caller should reissue async */
 	REQ_F_REISSUE		= BIT(REQ_F_REISSUE_BIT),
-	/* don't attempt request reissue, see io_rw_reissue() */
-	REQ_F_DONT_REISSUE	= BIT(REQ_F_DONT_REISSUE_BIT),
 	/* supports async reads */
 	REQ_F_NOWAIT_READ	= BIT(REQ_F_NOWAIT_READ_BIT),
 	/* supports async writes */
@@ -2444,13 +2441,6 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
 
-		if (READ_ONCE(req->result) == -EAGAIN &&
-		    !(req->flags & REQ_F_DONT_REISSUE)) {
-			req->iopoll_completed = 0;
-			io_req_task_queue_reissue(req);
-			continue;
-		}
-
 		__io_cqring_fill_event(ctx, req->user_data, req->result,
 					io_put_rw_kbuf(req));
 		(*nr_events)++;
@@ -2714,10 +2704,9 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
 	if (unlikely(res != req->result)) {
-		if (!(res == -EAGAIN && io_rw_should_reissue(req) &&
-		    io_resubmit_prep(req))) {
-			req_set_fail(req);
-			req->flags |= REQ_F_DONT_REISSUE;
+		if (res == -EAGAIN && io_rw_should_reissue(req)) {
+			req->flags |= REQ_F_REISSUE;
+			return;
 		}
 	}
 
@@ -2931,7 +2920,6 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 	struct io_async_rw *io = req->async_data;
-	bool check_reissue = kiocb->ki_complete == io_complete_rw;
 
 	/* add previously done IO, if any */
 	if (io && io->bytes_done > 0) {
@@ -2943,19 +2931,27 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = kiocb->ki_pos;
-	if (ret >= 0 && check_reissue)
+	if (ret >= 0 && (kiocb->ki_complete == io_complete_rw))
 		__io_complete_rw(req, ret, 0, issue_flags);
 	else
 		io_rw_done(kiocb, ret);
 
-	if (check_reissue && (req->flags & REQ_F_REISSUE)) {
+	if (req->flags & REQ_F_REISSUE) {
 		req->flags &= ~REQ_F_REISSUE;
 		if (io_resubmit_prep(req)) {
 			io_req_task_queue_reissue(req);
 		} else {
+			unsigned int cflags = io_put_rw_kbuf(req);
+			struct io_ring_ctx *ctx = req->ctx;
+
 			req_set_fail(req);
-			__io_req_complete(req, issue_flags, ret,
-					  io_put_rw_kbuf(req));
+			if (issue_flags & IO_URING_F_NONBLOCK) {
+				mutex_lock(&ctx->uring_lock);
+				__io_req_complete(req, issue_flags, ret, cflags);
+				mutex_unlock(&ctx->uring_lock);
+			} else {
+				__io_req_complete(req, issue_flags, ret, cflags);
+			}
 		}
 	}
 }
-- 
2.33.0

