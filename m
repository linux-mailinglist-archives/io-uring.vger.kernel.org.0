Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84BB766480B
	for <lists+io-uring@lfdr.de>; Tue, 10 Jan 2023 19:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjAJSDs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Jan 2023 13:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238177AbjAJSDV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Jan 2023 13:03:21 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8A99FD5
        for <io-uring@vger.kernel.org>; Tue, 10 Jan 2023 10:01:02 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 7so8793962pga.1
        for <io-uring@vger.kernel.org>; Tue, 10 Jan 2023 10:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yQjfdBAuI+lCVIhAS7ja+ercSmY/+2TyjJmiFgzuNZM=;
        b=ehO+pW7c9jcZ5X0YHTx2bs3lN8BdFLqIHPcguf/KQk/WuFg8QWIOjQma+kQAR7ImI8
         PbZPlRCqAKEFMxxew+pVxfmpE7IlOReCc5w90lTBYp2O0baHYRWV6uEDzeMNuD2xLbzg
         ZkrkKxK8aOaSRUqkZ0eI577Hfo8R17hm612IhzR2XxW835I19vkblL7zHNDL+IIZAq4+
         jB1NNlpuJ7QXeefjDPJtbSQ0yvrpcmogqLIJqMHhiwBnPaK5ykGROLHFHnBxeJ+DU7Cg
         QkUHqgdQ3/JuSaENOGDQKeb0fhF7/9UoYxPBWajcBKlAe7AAPgUpWf9FcEsCmqEUfXnv
         oshg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yQjfdBAuI+lCVIhAS7ja+ercSmY/+2TyjJmiFgzuNZM=;
        b=FQRrvhZzIPLYQNQE2dzH2OyxehU7z4pfCCmwb1qBMYKjOcs8LBVLMOdvFcxOHPEk/g
         LsrITGCCpx6PQFghqW/clQPho5TIGETAAIR90QEnNOtcJhRE+kYnMZ5dT3/kfJvSWQbY
         Lz6HYbS/JbQpXGJLCFkpGhlp9ecgvn0xdX9uV/xLYbcCi2p75NUNr7oPeDx4rkzYboq0
         eZFs4U9fOTvDi47QmFfk459kF1Rh2S8rpcOr46oA/QyqA+0xye7e36S2gx8fSCNXIlBp
         QvFAihL2d5ZvRmL96F3htfzfn3J80xW2yRN7QzrnDtlqztmDJbOjYnu6qy0G1b4a/yYU
         T7Ag==
X-Gm-Message-State: AFqh2kpnnmnCh70TfKLBqpmKHcP6/E/9+DUwqHZY72FNA3v4oOTYadEm
        7GmWLpHEN7Pbn71qgjVFYh0yP81rME75r17X
X-Google-Smtp-Source: AMrXdXsbK7c7PFA8/80nEZD8iBW5Lp052SkcqSmIAqs7oKHwM2X4HItK1ULxy9XA5m2d5r127W6RnA==
X-Received: by 2002:a62:1695:0:b0:57f:f570:128d with SMTP id 143-20020a621695000000b0057ff570128dmr17615137pfw.1.1673373661385;
        Tue, 10 Jan 2023 10:01:01 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i24-20020a056a00225800b00583698ba91dsm8405877pfu.40.2023.01.10.10.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 10:01:00 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/poll: attempt request issue after racy poll wakeup
Date:   Tue, 10 Jan 2023 11:00:55 -0700
Message-Id: <20230110180055.204657-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180055.204657-1-axboe@kernel.dk>
References: <20230110180055.204657-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we have multiple requests waiting on the same target poll waitqueue,
then it's quite possible to get a request triggered and get disappointed
in not being able to make any progress with it. If we race in doing so,
we'll potentially leave the poll request on the internal tables, but
removed from the waitqueue. That means that any subsequent trigger of
the poll waitqueue will not kick that request into action, causing an
application to potentially wait for completion of a request that will
never happen.

Fix this by adding a new poll return state, IOU_POLL_REISSUE. Rather
than have complicated logic for how to re-arm a given type of request,
just punt it for a reissue.

While in there, move the 'ret' variable to the only section where it
gets used. This avoids confusion the scope of it.

Fixes: 49f1c68e048f ("io_uring: optimise submission side poll_refs")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/poll.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index cf6a70bd54e0..0aca4ee6142b 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -223,21 +223,22 @@ enum {
 	IOU_POLL_DONE = 0,
 	IOU_POLL_NO_ACTION = 1,
 	IOU_POLL_REMOVE_POLL_USE_RES = 2,
+	IOU_POLL_REISSUE = 3,
 };
 
 /*
  * All poll tw should go through this. Checks for poll events, manages
  * references, does rewait, etc.
  *
- * Returns a negative error on failure. IOU_POLL_NO_ACTION when no action require,
- * which is either spurious wakeup or multishot CQE is served.
- * IOU_POLL_DONE when it's done with the request, then the mask is stored in req->cqe.res.
- * IOU_POLL_REMOVE_POLL_USE_RES indicates to remove multishot poll and that the result
- * is stored in req->cqe.
+ * Returns a negative error on failure. IOU_POLL_NO_ACTION when no action
+ * require, which is either spurious wakeup or multishot CQE is served.
+ * IOU_POLL_DONE when it's done with the request, then the mask is stored in
+ * req->cqe.res. IOU_POLL_REMOVE_POLL_USE_RES indicates to remove multishot
+ * poll and that the result is stored in req->cqe.
  */
 static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 {
-	int v, ret;
+	int v;
 
 	/* req->task == current here, checking PF_EXITING is safe */
 	if (unlikely(req->task->flags & PF_EXITING))
@@ -276,10 +277,15 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 		if (!req->cqe.res) {
 			struct poll_table_struct pt = { ._key = req->apoll_events };
 			req->cqe.res = vfs_poll(req->file, &pt) & req->apoll_events;
+			/*
+			 * We got woken with a mask, but someone else got to
+			 * it first. The above vfs_poll() doesn't add us back
+			 * to the waitqueue, so if we get nothing back, we
+			 * should be safe and attempt a reissue.
+			 */
+			if ((unlikely(!req->cqe.res)))
+				return IOU_POLL_REISSUE;
 		}
-
-		if ((unlikely(!req->cqe.res)))
-			continue;
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;
 
@@ -294,7 +300,7 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
 		} else {
-			ret = io_poll_issue(req, locked);
+			int ret = io_poll_issue(req, locked);
 			if (ret == IOU_STOP_MULTISHOT)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			if (ret < 0)
@@ -330,6 +336,8 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 
 			poll = io_kiocb_to_cmd(req, struct io_poll);
 			req->cqe.res = mangle_poll(req->cqe.res & poll->events);
+		} else if (ret == IOU_POLL_REISSUE) {
+			io_req_task_submit(req, locked);
 		} else if (ret != IOU_POLL_REMOVE_POLL_USE_RES) {
 			req->cqe.res = ret;
 			req_set_fail(req);
@@ -342,7 +350,7 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 
 		if (ret == IOU_POLL_REMOVE_POLL_USE_RES)
 			io_req_task_complete(req, locked);
-		else if (ret == IOU_POLL_DONE)
+		else if (ret == IOU_POLL_DONE || ret == IOU_POLL_REISSUE)
 			io_req_task_submit(req, locked);
 		else
 			io_req_defer_failed(req, ret);
-- 
2.39.0

