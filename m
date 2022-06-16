Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F08254DE12
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 11:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359505AbiFPJWt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 05:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiFPJWs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 05:22:48 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2218E11174
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:45 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id w17so1041105wrg.7
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u0zSyTW9TLDpn72Kx5d9duay8y2dPXlfqcu88lqUDF4=;
        b=EcISHViODwoq+EyGJDKtcG0B09NTzVc/taDb42qaGsVGq9wm1BT9VVhTvRuqWvDCzU
         GRReTWMh7Z2cZavVWAy0Ke0Pf2Y75Vo3eBAX+T2ewHSsaurRI4bYydKR292/mhzfKDlD
         Zv0772tBG3aBxalPZ9lchHO8ltjutcYzwAEaCafQ7jayAySXOaHW3HPYjb4aMuiBQrR1
         /HzYV+X03nOtzY3ekXU6Hm7h6xlzMA/FRpuI9MSAVyRkOtz+VxyfIR6fxWWGIauqdYtL
         y9QXQAmt2jO5/nPf8tW/wZ9aE/tfq/2QTsmsO9HZSdf8OQWbuUyGdEFjjnJwyOD6ko2h
         ijig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u0zSyTW9TLDpn72Kx5d9duay8y2dPXlfqcu88lqUDF4=;
        b=c1TX7twGd+odRYGl7Ph28ubf1kLGq5BWsz9BUdtwfQGQBj80D4iIZhiltQQFgY69bV
         KiKeHrslQ8aK3gAxx7w+X7SWJGQamUqySIStb6Z+JzqOo9Q/JKqd93LPiQhPvKhtXMSn
         W+MnB8Eq7GXbJcTTT7Zk2MCEvI/Kqb8nKgoAE83ab8igAfGZGn9tcttbQO1/JuMEUQt5
         8XLhF6CNdIy0oWNKJ6XLi/maSeMW9OjEsY4bHLGGEOPajxEjcZaEO/AkFNMN2Jd6ywad
         d4qMB0PPEvqjuU0cVxvi0xh2/7tXqnwJg+DvsT9e0j6tgusnM7+SXNF8JQFS8WNLL3QU
         nihg==
X-Gm-Message-State: AJIora8M6YRedLKYG9SOc8zyZcYcLLbf8qBOg+BVTb3zIXdgC7fHrSHx
        jVadpm1524EgtdLKdyKiUioGVfIH+bka9w==
X-Google-Smtp-Source: AGRyM1ucezeYzxbqo9L5opI51RediPrM4Wt6V8YRIpQNDc/OjLBJWJGhCekbzvMlwddOUCuqKoYqeA==
X-Received: by 2002:adf:fb0b:0:b0:21a:b15:6013 with SMTP id c11-20020adffb0b000000b0021a0b156013mr3608840wrr.268.1655371363799;
        Thu, 16 Jun 2022 02:22:43 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id s6-20020a1cf206000000b0039c975aa553sm1695221wmc.25.2022.06.16.02.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 02:22:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v3 01/16] io_uring: rw: delegate sync completions to core io_uring
Date:   Thu, 16 Jun 2022 10:21:57 +0100
Message-Id: <32ef005b45d23bf6b5e6837740dc0331bb051bd4.1655371007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655371007.git.asml.silence@gmail.com>
References: <cover.1655371007.git.asml.silence@gmail.com>
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

io_issue_sqe() from the io_uring core knows how to complete requests
based on the returned error code, we can delegate io_read()/io_write()
completion to it. Make kiocb_done() to return the right completion
code and propagate it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index fa1063c738f8..818692a83d75 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -207,15 +207,6 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	return false;
 }
 
-static void __io_complete_rw(struct io_kiocb *req, long res,
-			     unsigned int issue_flags)
-{
-	if (__io_complete_rw_common(req, res))
-		return;
-	io_req_set_res(req, req->cqe.res, io_put_kbuf(req, issue_flags));
-	__io_req_complete(req, issue_flags);
-}
-
 static void io_complete_rw(struct kiocb *kiocb, long res)
 {
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
@@ -247,7 +238,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 	smp_store_release(&req->iopoll_completed, 1);
 }
 
-static void kiocb_done(struct io_kiocb *req, ssize_t ret,
+static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		       unsigned int issue_flags)
 {
 	struct io_async_rw *io = req->async_data;
@@ -263,10 +254,15 @@ static void kiocb_done(struct io_kiocb *req, ssize_t ret,
 
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = rw->kiocb.ki_pos;
-	if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw))
-		__io_complete_rw(req, ret, issue_flags);
-	else
+	if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
+		if (!__io_complete_rw_common(req, ret)) {
+			io_req_set_res(req, req->cqe.res,
+				       io_put_kbuf(req, issue_flags));
+			return IOU_OK;
+		}
+	} else {
 		io_rw_done(&rw->kiocb, ret);
+	}
 
 	if (req->flags & REQ_F_REISSUE) {
 		req->flags &= ~REQ_F_REISSUE;
@@ -275,6 +271,7 @@ static void kiocb_done(struct io_kiocb *req, ssize_t ret,
 		else
 			io_req_task_queue_fail(req, ret);
 	}
+	return IOU_ISSUE_SKIP_COMPLETE;
 }
 
 static int __io_import_fixed(struct io_kiocb *req, int ddir,
@@ -846,7 +843,9 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 			goto done;
 		ret = 0;
 	} else if (ret == -EIOCBQUEUED) {
-		goto out_free;
+		if (iovec)
+			kfree(iovec);
+		return IOU_ISSUE_SKIP_COMPLETE;
 	} else if (ret == req->cqe.res || ret <= 0 || !force_nonblock ||
 		   (req->flags & REQ_F_NOWAIT) || !need_read_all(req)) {
 		/* read all, failed, already did sync or don't want to retry */
@@ -904,12 +903,10 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		iov_iter_restore(&s->iter, &s->iter_state);
 	} while (ret > 0);
 done:
-	kiocb_done(req, ret, issue_flags);
-out_free:
 	/* it's faster to check here then delegate to kfree */
 	if (iovec)
 		kfree(iovec);
-	return IOU_ISSUE_SKIP_COMPLETE;
+	return kiocb_done(req, ret, issue_flags);
 }
 
 int io_write(struct io_kiocb *req, unsigned int issue_flags)
@@ -959,8 +956,10 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	ppos = io_kiocb_update_pos(req);
 
 	ret = rw_verify_area(WRITE, req->file, ppos, req->cqe.res);
-	if (unlikely(ret))
-		goto out_free;
+	if (unlikely(ret)) {
+		kfree(iovec);
+		return ret;
+	}
 
 	/*
 	 * Open-code file_start_write here to grab freeze protection,
@@ -1002,15 +1001,13 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		if (ret2 == -EAGAIN && (req->ctx->flags & IORING_SETUP_IOPOLL))
 			goto copy_iov;
 done:
-		kiocb_done(req, ret2, issue_flags);
-		ret = IOU_ISSUE_SKIP_COMPLETE;
+		ret = kiocb_done(req, ret2, issue_flags);
 	} else {
 copy_iov:
 		iov_iter_restore(&s->iter, &s->iter_state);
 		ret = io_setup_async_rw(req, iovec, s, false);
 		return ret ?: -EAGAIN;
 	}
-out_free:
 	/* it's reportedly faster than delegating the null check to kfree() */
 	if (iovec)
 		kfree(iovec);
-- 
2.36.1

