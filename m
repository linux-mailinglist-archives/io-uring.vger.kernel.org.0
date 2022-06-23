Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466FB557CD9
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 15:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiFWNZ3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 09:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiFWNZ2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 09:25:28 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764DD49C94
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:25:27 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id z9so11021957wmf.3
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wCYu+CuA4ghhjalWpw26bcKN04Bihmyd2uysIWUIfg4=;
        b=le/bjXndQ47SINOsDSDvoHKihIDsOQDSDfGirbOds9niu6E/aAp/qKKjpOPUyeFSCE
         tBnbAQbJM4GAOVUL4PEbyxJSm3InMkuXxx9ZjE2Xk6Qn3DkXkbOXM6DVRCYpr5qqyYDK
         ylO6aJqRu5Cb+rO1bFLB+sn4ZjvcHJ5zSlJ8n6psl+6+hyVjCQHRKhjpXKZfOos/P+RQ
         GYLZKyoznOUqhArJYNA33ltG9pWCTWQmUda/sDS7/ECyzwlScc6wtLAqJbX/S0wXeSGU
         0hzmQJI54lqWs5g22woerMuAr116loCKS/y5Av1B2MgxymhqG71MXSWXxKDlwBKweou0
         fEVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wCYu+CuA4ghhjalWpw26bcKN04Bihmyd2uysIWUIfg4=;
        b=leeGpNlusx5Dz8QNbngiXCfwGSKA9l84d3UnOEBJt/3TH4YVCaceHuE7LIcs2DspXk
         VsGoLtekQeCPtB0OD1EX7v6GSpPdzn8cvslPyTWRkU8PF2zco4tSTn3KtF2RhUeKSo2y
         KvbnjmqEZ3wfgh7Q4f43gVuRJBjcjoWehM25vKWZecUFeoVceKH9aoc9aE13qz9uz4E1
         KCSqP7ARn6kbcLuL1DDL/VT2OhrzNLW1hrwfT5OPsfj+PPMl1YhhNwL2EYhBMlP6RmYV
         UgMXU8Oz3D1S9mTySkxrqeYiqBuN4TpFpGaj6fndOaybgVl41UMwl+EMSbi8WH7XQ4hB
         I6Tw==
X-Gm-Message-State: AJIora8Pk6xnEFkpVQf8QQhCd6kmtakxDopPcA68IIAGKwDzEAbM62ay
        AciPBAJ65R8gSNDoMLck5CVLl8PylF5k1riE
X-Google-Smtp-Source: AGRyM1umSP+E8HKYubWbCxQOXiUubczZe+rnz3iNuY15Y2QwlErP2nTaUhtTAFvputlwk6vJfaatDQ==
X-Received: by 2002:a05:600c:1d12:b0:39c:4307:8b10 with SMTP id l18-20020a05600c1d1200b0039c43078b10mr4148439wms.103.1655990725785;
        Thu, 23 Jun 2022 06:25:25 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id z14-20020a7bc7ce000000b0039c5a765388sm3160620wmk.28.2022.06.23.06.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 06:25:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 2/6] io_uring: remove events caching atavisms
Date:   Thu, 23 Jun 2022 14:24:45 +0100
Message-Id: <12efd4e15c6a90cf9e5b59807cfcb57852b51dc7.1655990418.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655990418.git.asml.silence@gmail.com>
References: <cover.1655990418.git.asml.silence@gmail.com>
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

Remove events argument from *io_poll_execute(), it's not needed and not
used.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 210b174b155b..7de8c52793cd 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -289,8 +289,7 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 		io_req_complete_failed(req, ret);
 }
 
-static void __io_poll_execute(struct io_kiocb *req, int mask,
-			      __poll_t __maybe_unused events)
+static void __io_poll_execute(struct io_kiocb *req, int mask)
 {
 	io_req_set_res(req, mask, 0);
 	/*
@@ -308,18 +307,17 @@ static void __io_poll_execute(struct io_kiocb *req, int mask,
 	io_req_task_work_add(req);
 }
 
-static inline void io_poll_execute(struct io_kiocb *req, int res,
-		__poll_t events)
+static inline void io_poll_execute(struct io_kiocb *req, int res)
 {
 	if (io_poll_get_ownership(req))
-		__io_poll_execute(req, res, events);
+		__io_poll_execute(req, res);
 }
 
 static void io_poll_cancel_req(struct io_kiocb *req)
 {
 	io_poll_mark_cancelled(req);
 	/* kick tw, which should complete the request */
-	io_poll_execute(req, 0, 0);
+	io_poll_execute(req, 0);
 }
 
 #define IO_ASYNC_POLL_COMMON	(EPOLLONESHOT | EPOLLPRI)
@@ -334,7 +332,7 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	if (unlikely(mask & POLLFREE)) {
 		io_poll_mark_cancelled(req);
 		/* we have to kick tw in case it's not already */
-		io_poll_execute(req, 0, poll->events);
+		io_poll_execute(req, 0);
 
 		/*
 		 * If the waitqueue is being freed early but someone is already
@@ -369,7 +367,7 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			else
 				req->flags &= ~REQ_F_SINGLE_POLL;
 		}
-		__io_poll_execute(req, mask, poll->events);
+		__io_poll_execute(req, mask);
 	}
 	return 1;
 }
@@ -487,7 +485,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 			req->apoll_events |= EPOLLONESHOT;
 			ipt->error = 0;
 		}
-		__io_poll_execute(req, mask, poll->events);
+		__io_poll_execute(req, mask);
 		return 0;
 	}
 
@@ -497,7 +495,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	 */
 	v = atomic_dec_return(&req->poll_refs);
 	if (unlikely(v & IO_POLL_REF_MASK))
-		__io_poll_execute(req, 0, poll->events);
+		__io_poll_execute(req, 0);
 	return 0;
 }
 
-- 
2.36.1

