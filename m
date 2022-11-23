Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D53635BD9
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237281AbiKWLfN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237310AbiKWLfH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:35:07 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0479F72D4
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:35:05 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id r9-20020a1c4409000000b003d02dd48c45so882673wma.0
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=alCckDgLta/2b15StUxHZvhqjHuwSHam7jn/kHiSi0c=;
        b=YPP3kOab9ZkazKcgMB3j0Ul7O0hIuyfpcjZ9lN8Geo5lB+uE+UF7/hcW9GpaxyiUhG
         S/BKTkd9k8bv2nSdnaipq5AejyB4d7swmaBpO8pAgKEp6qjaZ/rqUGKygFx+914XSbMS
         LEStRW20xX0ssEoquCWO2t0+Gd/IfpiHcn6ag8nW7J+M2KHKd+gVYflK+Yb7sIeroZs/
         3ZJs98nvIGcHD9kNEw8CPYsfkth6IFxvJt6a7P22bmZZVKgNRE/+2ZbzV/V9F2nih0LU
         4gP2Mv0zu3eWsOkKtkMDLuC13pou5CE3jQUuCHPMaeRv65qpiz18WmOJI+iikQmLsfUG
         QkRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=alCckDgLta/2b15StUxHZvhqjHuwSHam7jn/kHiSi0c=;
        b=ZlSZRYyhZisTGvDcJbrbVAdn3PNLYZLfNdQ4ALhc3Sg4g4U86AEb5SSoruWfCeol5D
         gF+jc4hChIYhgADOrysnYzxeBt5A5L5NaaoZjsu9UHPHsxFXZlDZMQ8LyPngCTFgZW80
         vnGgrVc//BtHMzlIub846vCv2fhZ4n9XyqVDrCimNaUc6ZQCO6erK0VWxjrax4plBst1
         F4SZVoKeafYNRmUun4fnaNzhA6p0wTlwkgDfsm7leuTQ5TwycPKtb87BGCEZ0rYFoRBr
         O0mxADI5rexVVD55U0OKxVN9TPknzoidE7AzqS/tezZnbRrWYFB3Q/hsAbF+VkS9otLB
         Q5ow==
X-Gm-Message-State: ANoB5plCrXosgALgdtwdZhGS6V2BbIlTE9TUdsMdpQHWAXBy7hV8NeD/
        G+R3afvl1vDDkU2dw+vUSGQEOQN7cT8=
X-Google-Smtp-Source: AA0mqf5WUhBP2fMp4aUJssc5aq8f4+50o265jcirc3PQgoaX8jpGOrcF5z8W/caKw8goj6V/yrYCBg==
X-Received: by 2002:a05:600c:4d0a:b0:3c6:a7a1:eebd with SMTP id u10-20020a05600c4d0a00b003c6a7a1eebdmr19354734wmp.176.1669203304346;
        Wed, 23 Nov 2022 03:35:04 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e1b])
        by smtp.gmail.com with ESMTPSA id g9-20020a05600c4ec900b003cfd58409desm2262064wmq.13.2022.11.23.03.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 03:35:03 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 4/7] io_uring: remove io_req_tw_post_queue
Date:   Wed, 23 Nov 2022 11:33:39 +0000
Message-Id: <b9b73c08022c7f1457023ac841f35c0100e70345.1669203009.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669203009.git.asml.silence@gmail.com>
References: <cover.1669203009.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove io_req_tw_post() and io_req_tw_post_queue(), we can use
io_req_task_complete() instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 12 ------------
 io_uring/io_uring.h |  8 +++++++-
 io_uring/timeout.c  |  6 +++---
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a4e6866f24c8..81e7e51816fb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1225,18 +1225,6 @@ int io_run_local_work(struct io_ring_ctx *ctx)
 	return ret;
 }
 
-static void io_req_tw_post(struct io_kiocb *req, bool *locked)
-{
-	io_req_complete_post(req);
-}
-
-void io_req_tw_post_queue(struct io_kiocb *req, s32 res, u32 cflags)
-{
-	io_req_set_res(req, res, cflags);
-	req->io_task_work.func = io_req_tw_post;
-	io_req_task_work_add(req);
-}
-
 static void io_req_task_cancel(struct io_kiocb *req, bool *locked)
 {
 	/* not needed for normal modes, but SQPOLL depends on it */
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index af3f82bd4017..002b6cc842a5 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -50,7 +50,6 @@ static inline bool io_req_ffs_set(struct io_kiocb *req)
 void __io_req_task_work_add(struct io_kiocb *req, bool allow_local);
 bool io_is_uring_fops(struct file *file);
 bool io_alloc_async_data(struct io_kiocb *req);
-void io_req_tw_post_queue(struct io_kiocb *req, s32 res, u32 cflags);
 void io_req_task_queue(struct io_kiocb *req);
 void io_queue_iowq(struct io_kiocb *req, bool *dont_use);
 void io_req_task_complete(struct io_kiocb *req, bool *locked);
@@ -366,4 +365,11 @@ static inline bool io_allowed_run_tw(struct io_ring_ctx *ctx)
 		      ctx->submitter_task == current);
 }
 
+static inline void io_req_queue_tw_complete(struct io_kiocb *req, s32 res)
+{
+	io_req_set_res(req, res, 0);
+	req->io_task_work.func = io_req_task_complete;
+	io_req_task_work_add(req);
+}
+
 #endif
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index a819818df7b3..5b4bc93fd6e0 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -63,7 +63,7 @@ static bool io_kill_timeout(struct io_kiocb *req, int status)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&timeout->list);
-		io_req_tw_post_queue(req, status, 0);
+		io_req_queue_tw_complete(req, status);
 		return true;
 	}
 	return false;
@@ -159,7 +159,7 @@ void io_disarm_next(struct io_kiocb *req)
 		req->flags &= ~REQ_F_ARM_LTIMEOUT;
 		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
 			io_remove_next_linked(req);
-			io_req_tw_post_queue(link, -ECANCELED, 0);
+			io_req_queue_tw_complete(link, -ECANCELED);
 		}
 	} else if (req->flags & REQ_F_LINK_TIMEOUT) {
 		struct io_ring_ctx *ctx = req->ctx;
@@ -168,7 +168,7 @@ void io_disarm_next(struct io_kiocb *req)
 		link = io_disarm_linked_timeout(req);
 		spin_unlock_irq(&ctx->timeout_lock);
 		if (link)
-			io_req_tw_post_queue(link, -ECANCELED, 0);
+			io_req_queue_tw_complete(link, -ECANCELED);
 	}
 	if (unlikely((req->flags & REQ_F_FAIL) &&
 		     !(req->flags & REQ_F_HARDLINK)))
-- 
2.38.1

