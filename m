Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703FF5576B1
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 11:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiFWJfJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 05:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiFWJfI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 05:35:08 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124D649264
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 02:35:08 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id i10so23316698wrc.0
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 02:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wCYu+CuA4ghhjalWpw26bcKN04Bihmyd2uysIWUIfg4=;
        b=B+CUgVRN3JJj2MplQmOEIjtICVX30As0R3Nbz0XzMW0WFSD/7BpNMZ4DvEcQrB2+OQ
         04Bx42babkeu3tzJTd4xuYTRgnSasZeYB3I/0yldJf3wQfvy2mhzbsoxnUs5s6pzqqqg
         aCHMA8s313pe5e8btuypNtqCnVgKjCweRA+NydDDv1deU9bUxklmZKeE4NXrUVyB3j6A
         i9+FCABN/xs2Bmq+wQHUqCx30hkNuU9EFxheomYz9fZlXKJEi4VQADgjYldL/T5hPmxY
         krshmLLv2RjIHBoWcDeBF2W7XT9LSnMTqRXeE0CWwUIlC6KBb+hrR/FaTfwJXkGYqB8k
         /WCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wCYu+CuA4ghhjalWpw26bcKN04Bihmyd2uysIWUIfg4=;
        b=nT+zkus2JKBo6fFr9VF3Ad1C1f62MiRkx9L+cn68AAzhBAoj3K2sYbzcc0qk0jqSv6
         b9OehJxEFkj3zoHShxAHX5Eif1sqvPJkUB6UC338IUFmaXoraYz8/TwpHRW2Bmx7qJI8
         6fcGy4zLdQ46h6mCcchmwmUcEuvoOKUNB1UaJsQMlAq4p/UGn6hOl3Q8TJVvvc1OKgxK
         7VDLWgmM/kYUrF7qgd9UVBO+YGUpkVAR9fH7nsrxq2y7Pf1Q3FT2sR7QKZcDF/x7fojI
         UpWYbNgI6tZeOhjta260yQWl6aNxjsIlnJK6qmsq3oYNuiNebqJ+ZqeyTXsyhkWtKGWj
         V1Ow==
X-Gm-Message-State: AJIora8bSdMfsuKqa/sBShnXNNoU4C7b/2fivkSwtPqN45umLgLjxIYI
        O9qyPaL0ZXURXE9Av9pdIRrwutYBYtFvVAXK
X-Google-Smtp-Source: AGRyM1vmjIuZNfxAH8/8DmivHenM6MbRmno2m/1058CZvHInInWNnKJoN1X4Z+dYWsxrrDhKACaGmA==
X-Received: by 2002:adf:f411:0:b0:21b:8397:860e with SMTP id g17-20020adff411000000b0021b8397860emr7261681wro.50.1655976906402;
        Thu, 23 Jun 2022 02:35:06 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a02f957245sm2431202wmq.26.2022.06.23.02.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 02:35:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/6] io_uring: remove events caching atavisms
Date:   Thu, 23 Jun 2022 10:34:31 +0100
Message-Id: <12efd4e15c6a90cf9e5b59807cfcb57852b51dc7.1655976119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655976119.git.asml.silence@gmail.com>
References: <cover.1655976119.git.asml.silence@gmail.com>
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

