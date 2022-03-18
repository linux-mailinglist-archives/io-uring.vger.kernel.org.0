Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5364DDAF9
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 14:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbiCRNzK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Mar 2022 09:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236896AbiCRNzJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Mar 2022 09:55:09 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CB5192365
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 06:53:50 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id p184-20020a1c29c1000000b0037f76d8b484so4817289wmp.5
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 06:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bl5oIFrNHH1R/iKO7J+lN5DTRcvrejwIqPo24F/1sMw=;
        b=K2oRb8deflm9WOnlpgfDajJeOwTDvbZI+rQJO5Pdd1hmSydqWTCPZCSOsAdqQHB+2m
         mB2YMKXiGfNhenKCGVic8spxd78DIC/gfT8e1F1dM7A9xFc35LYnyFMWlG8f0rFkoDTW
         ENOzw1ghogkmmXx+WWTy9zVV/JXjjhbH9SQ2Ry+LZlGlLwz3RmgvrV1kVuhWeUVX9o3E
         V862u6QiBXk/QSuWiv4i1qtpEarlqEghOP8dPEwYR7GoUflWds++bus2rMw+A3aFAN//
         OFtIlG6iPH5vz8Oxahb0pzhe+xpe995BwTGjTys1/8H1LXRrYUtmhymf5MnKcb0oRon+
         nITw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bl5oIFrNHH1R/iKO7J+lN5DTRcvrejwIqPo24F/1sMw=;
        b=03S+fAQ4MYfZhWNMsV0IxpBXGqPcmDEYmvmwu7v3WJTC1kPsKJlR3oG3rRY5mddm6I
         HSkj6zaAU3mCUJbEkjaI83pUUbwKGdgXn5hiMgjEZ3Cq8c2Dv118Tetsn3o3cBQuZXxq
         fIqvUK30zhRbsW7Df5USrvH5LvnscJVIvfsS2L/iF8aRq6Dy0cy+gBEGUdKyVcEmkw9s
         5Vw9R++DHa98HL3AIy8qDu39o4/KXel/Yng1+5ZT8yVVgeOQOQMCMBzAwh9ZXDRTNFzC
         Cy5jxNDHrqxcAwcEpciyb5VbmGmSq1j/zjb6ay8mS/obSLXK5jdFzH2hmwHUTVVgwKbl
         yvhQ==
X-Gm-Message-State: AOAM533uGyJZQLYA6cMocQK7uve0WG266pvSv8ePtVQfXaiY5vJE8k7D
        u3JAzz8Rxpj0+Yqea58i4t+iGqYdc/eJwg==
X-Google-Smtp-Source: ABdhPJwpN+vYqWQ3Dss7zbswFPh8mM12IiUVZ+9gohUCa1q/VvZvKJoOeQw/6NMpSJC/1Tkkaqtm8g==
X-Received: by 2002:a1c:f30b:0:b0:380:e444:86b9 with SMTP id q11-20020a1cf30b000000b00380e44486b9mr8334370wmq.81.1647611628499;
        Fri, 18 Mar 2022 06:53:48 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.70])
        by smtp.gmail.com with ESMTPSA id j8-20020a05600c1c0800b0038c8da4d9b8sm1290375wms.30.2022.03.18.06.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 06:53:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/4] io_uring: get rid of raw fill cqe in kill_timeout
Date:   Fri, 18 Mar 2022 13:52:20 +0000
Message-Id: <54b5facc9f4d30822f7fd6a87baaf26cc279c921.1647610155.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647610155.git.asml.silence@gmail.com>
References: <cover.1647610155.git.asml.silence@gmail.com>
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

We don't want raw fill_cqe calls. In preparation for upcoming features,
get rid of fill cqe by using io_req_task_complete

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 690bfeaa609a..0e04e0997d7d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1191,6 +1191,7 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags);
 
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer);
 static void io_eventfd_signal(struct io_ring_ctx *ctx);
+static void io_req_tw_queue_complete(struct io_kiocb *req, u32 res);
 
 static struct kmem_cache *req_cachep;
 
@@ -1746,8 +1747,7 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-		io_fill_cqe_req(req, status, 0);
-		io_put_req_deferred(req);
+		io_req_tw_queue_complete(req, status);
 	}
 }
 
@@ -2595,6 +2595,19 @@ static void io_req_task_submit(struct io_kiocb *req, bool *locked)
 		io_req_complete_failed(req, -EFAULT);
 }
 
+static void io_req_task_complete(struct io_kiocb *req, bool *locked)
+{
+	int res = req->result;
+
+	if (*locked) {
+		io_req_complete_state(req, res, io_put_kbuf(req, 0));
+		io_req_add_compl_list(req);
+	} else {
+		io_req_complete_post(req, res,
+					io_put_kbuf(req, IO_URING_F_UNLOCKED));
+	}
+}
+
 static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 {
 	req->result = ret;
@@ -2602,6 +2615,13 @@ static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 	io_req_task_work_add(req, false);
 }
 
+static void io_req_tw_queue_complete(struct io_kiocb *req, u32 res)
+{
+	req->result = res;
+	req->io_task_work.func = io_req_task_complete;
+	io_req_task_work_add(req, false);
+}
+
 static void io_req_task_queue(struct io_kiocb *req)
 {
 	req->io_task_work.func = io_req_task_submit;
@@ -2987,19 +3007,6 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	return false;
 }
 
-static inline void io_req_task_complete(struct io_kiocb *req, bool *locked)
-{
-	int res = req->result;
-
-	if (*locked) {
-		io_req_complete_state(req, res, io_put_kbuf(req, 0));
-		io_req_add_compl_list(req);
-	} else {
-		io_req_complete_post(req, res,
-					io_put_kbuf(req, IO_URING_F_UNLOCKED));
-	}
-}
-
 static void __io_complete_rw(struct io_kiocb *req, long res,
 			     unsigned int issue_flags)
 {
@@ -6458,9 +6465,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	if (!(data->flags & IORING_TIMEOUT_ETIME_SUCCESS))
 		req_set_fail(req);
 
-	req->result = -ETIME;
-	req->io_task_work.func = io_req_task_complete;
-	io_req_task_work_add(req, false);
+	io_req_tw_queue_complete(req, -ETIME);
 	return HRTIMER_NORESTART;
 }
 
-- 
2.35.1

