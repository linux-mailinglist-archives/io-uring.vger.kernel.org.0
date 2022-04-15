Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F47503181
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350464AbiDOVLq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 17:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245670AbiDOVLp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 17:11:45 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A53DCE02
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:16 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b15so11086641edn.4
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F5/81X/En2x9Z2x66nUtMeT8QqY0522mstfOqT3H19Q=;
        b=YNdqHuxvDSsoD4+Dq3LgVMxa1H09LAuHtQyz6/jm1ch8wjsDnMsMFbhxh1FQro5Yud
         d3D2mk+KX/+YeruAR7Ji78Lrx3fyqhL5L2hMK1nE/4GaXXn2CV/A9E7WGws/mcDYx9Ih
         DK5lZ5/gpBvpN8joBg1gt054sYU1hHf4z0Ka/ysROUKmIsNy7gZ/qJ+iCaY5N5tdSPVb
         ZwCnu7wgQMWmPnanOf1xZvhu9i1vcSitudVBRYcxOjgf2HTs1zsklLZ9PasMSEM1cGsg
         Le9T4aYky+qQhhz//wv7U3cgpmIap1rRxyTSMXYU8RUzaZq9LmVOhciGIb4gnOPaz5Yi
         b3Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F5/81X/En2x9Z2x66nUtMeT8QqY0522mstfOqT3H19Q=;
        b=6vjT1xTaFud9a0ED0pgG1mWk1A0uc+WpjSJym7gI4mNpDtyoq8oDWv8EuCxj03FVsP
         oa7aXJUbqE0UrbWL2CcwKPVlpVPh2ouTCWZITnak1kiKHYxbYn5WtRz3beMGo5FmEvPc
         bvdnG58IrYGthVRl787bPUZ/1ItqNcg30ry3GML8O6CegYKpDjjEeM39aI7bAK+kpaAG
         Cw4+L+iwuEYsqISUak/skrgNRe8zKO7TND98zVH0483piAFI0FHfXAHWaaOKfgM6tl5o
         /uJAmxYr9EP/lTNnOYi2en4XtRn6bcAmAhBPNRw5gJYOXTufon187I9FzsrKHzTVQwKd
         +3MA==
X-Gm-Message-State: AOAM533Ohaa9J8EbxUbJIodzvrd3rGdAJeTqvhC2baEaLdpxTlCAb3Bw
        dI/8aIAsP5/y/KhS7fgeUnA+mOVKCsc=
X-Google-Smtp-Source: ABdhPJxZj6Fvs2dut7kQXtqBpAXzo1nuy0mjPETyNxx8YkSgS3kgH/56229VBQSwtoptimGTzO2jgg==
X-Received: by 2002:a05:6402:681:b0:419:dbec:9909 with SMTP id f1-20020a056402068100b00419dbec9909mr982378edy.310.1650056954398;
        Fri, 15 Apr 2022 14:09:14 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id j10-20020aa7de8a000000b004215209b077sm2602938edv.37.2022.04.15.14.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:09:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 04/14] io_uring: kill io_put_req_deferred()
Date:   Fri, 15 Apr 2022 22:08:23 +0100
Message-Id: <10672a538774ac8986bee6468d960527af59169d.1650056133.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650056133.git.asml.silence@gmail.com>
References: <cover.1650056133.git.asml.silence@gmail.com>
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

We have several spots where a call to io_fill_cqe_req() is immediately
followed by io_put_req_deferred(). Replace them with
__io_req_complete_post() and get rid of io_put_req_deferred() and
io_fill_cqe_req().

> size ./fs/io_uring.o
   text    data     bss     dec     hex filename
  86942   13734       8  100684   1894c ./fs/io_uring.o
> size ./fs/io_uring.o
   text    data     bss     dec     hex filename
  86438   13654       8  100100   18704 ./fs/io_uring.o

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 42 ++++++++----------------------------------
 1 file changed, 8 insertions(+), 34 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 986a2d640702..92d7c7a0d234 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1188,10 +1188,8 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 bool cancel_all);
 static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 
-static void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags);
-
+static void __io_req_complete_post(struct io_kiocb *req, s32 res, u32 cflags);
 static void io_put_req(struct io_kiocb *req);
-static void io_put_req_deferred(struct io_kiocb *req);
 static void io_dismantle_req(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
@@ -1773,8 +1771,7 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-		io_fill_cqe_req(req, status, 0);
-		io_put_req_deferred(req);
+		__io_req_complete_post(req, status, 0);
 	}
 }
 
@@ -2137,12 +2134,6 @@ static inline bool __io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
 	return __io_fill_cqe(req->ctx, req->cqe.user_data, res, cflags);
 }
 
-static noinline void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
-{
-	if (!(req->flags & REQ_F_CQE_SKIP))
-		__io_fill_cqe_req(req, res, cflags);
-}
-
 static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
 				     s32 res, u32 cflags)
 {
@@ -2376,9 +2367,7 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 		link->timeout.head = NULL;
 		if (hrtimer_try_to_cancel(&io->timer) != -1) {
 			list_del(&link->timeout.list);
-			/* leave REQ_F_CQE_SKIP to io_fill_cqe_req */
-			io_fill_cqe_req(link, -ECANCELED, 0);
-			io_put_req_deferred(link);
+			__io_req_complete_post(link, -ECANCELED, 0);
 			return true;
 		}
 	}
@@ -2404,11 +2393,11 @@ static void io_fail_links(struct io_kiocb *req)
 		trace_io_uring_fail_link(req->ctx, req, req->cqe.user_data,
 					req->opcode, link);
 
-		if (!ignore_cqes) {
+		if (ignore_cqes)
+			link->flags |= REQ_F_CQE_SKIP;
+		else
 			link->flags &= ~REQ_F_CQE_SKIP;
-			io_fill_cqe_req(link, res, 0);
-		}
-		io_put_req_deferred(link);
+		__io_req_complete_post(link, res, 0);
 		link = nxt;
 	}
 }
@@ -2424,9 +2413,7 @@ static bool io_disarm_next(struct io_kiocb *req)
 		req->flags &= ~REQ_F_ARM_LTIMEOUT;
 		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
 			io_remove_next_linked(req);
-			/* leave REQ_F_CQE_SKIP to io_fill_cqe_req */
-			io_fill_cqe_req(link, -ECANCELED, 0);
-			io_put_req_deferred(link);
+			__io_req_complete_post(link, -ECANCELED, 0);
 			posted = true;
 		}
 	} else if (req->flags & REQ_F_LINK_TIMEOUT) {
@@ -2695,11 +2682,6 @@ static void io_free_req(struct io_kiocb *req)
 	__io_free_req(req);
 }
 
-static void io_free_req_work(struct io_kiocb *req, bool *locked)
-{
-	io_free_req(req);
-}
-
 static void io_free_batch_list(struct io_ring_ctx *ctx,
 				struct io_wq_work_node *node)
 	__must_hold(&ctx->uring_lock)
@@ -2799,14 +2781,6 @@ static inline void io_put_req(struct io_kiocb *req)
 		io_free_req(req);
 }
 
-static inline void io_put_req_deferred(struct io_kiocb *req)
-{
-	if (req_ref_put_and_test(req)) {
-		req->io_task_work.func = io_free_req_work;
-		io_req_task_work_add(req, false);
-	}
-}
-
 static unsigned io_cqring_events(struct io_ring_ctx *ctx)
 {
 	/* See comment at the top of this file */
-- 
2.35.2

