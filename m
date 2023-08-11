Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFDF7795EA
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 19:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236599AbjHKRMv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 13:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234977AbjHKRMv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 13:12:51 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC6719F
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 10:12:51 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6872c60b572so446618b3a.1
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 10:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691773970; x=1692378770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RdLNQTIaZyWtWZzwJYB3ZQDU89FLjKa1NS45V9BX53U=;
        b=ShSU+YG0OxdtUT2tkbXYstIATC/NUFmG/7L+ZqL7pBYGitauI4GPZ/PQEJ0LfrJah7
         IbIL2OQl2IHYY5aKj11GNj9pqh7uEKZ16pFrPWg4aTtB0bGBGjuEpYfP1ZFLdj2R8FY1
         LCsbFZYKz734f8zc0d8+gnFxazHv297yaXlZKAZogMo7mpz4fQCzH/2bq1Wj2EutK6h/
         h+oaQK37FpAPmaD+EIB71uJI5hX3tLBgYrAktp4fVf/cRbktCiWPCea+nlvyejsdWaoW
         IU6RW0/DXFhPbj7+umCIdxv+b0fN2WB4yYseOOa1cM7Y71MGAQ1urphBOAp+ozJNcwYE
         eh1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691773970; x=1692378770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RdLNQTIaZyWtWZzwJYB3ZQDU89FLjKa1NS45V9BX53U=;
        b=EnQfOqyxwx49P3B+qSstjOQ7ck2NuIZ7VFe8C8IYmPyH1tR/WR38SwOxwEnaXTNpo6
         /Z4wGEsiYgxoGKZ1CgSa1iQrMWxeH+oJpONyyDk2CGScHp5EZEkCdpLoSq7VMtRsocJo
         xGxfXmpA37DsiqloaiTWskZhsvJ7z/x0FSEsN/b2LgJN42Q4lCBKisqO/nRVI6S2Wln+
         27ar+M1k4miGQUg2tpmRpRmdZaT73jP2x5//uIfOpEEGM0+jfFg+jPJCDIQHpwK/+rKq
         9kZiV1hF9+MNX0zM99w0GFiYi+AaGwLb80Aiyf+PKYVAklKM0tJ62a7PICkqOFTGCs4x
         l6Jg==
X-Gm-Message-State: AOJu0YydlkXoEk5dwxinBvEoo7ifJJ4VnZcLitl+aNt7Y+FW6u9gxzMs
        QoFbrjw3slc3Io7c0Mv7X6JV0U9A2y5nxG559rs=
X-Google-Smtp-Source: AGHT+IG1AUZYb/BIHgMBhmCdU7ClwT7fWC9xY05CHkBwsOcPZcOJOrC/R5cupu5U5i50Ck8A1O8rDQ==
X-Received: by 2002:a05:6a20:1589:b0:123:149b:a34f with SMTP id h9-20020a056a20158900b00123149ba34fmr3456853pzj.1.1691773970141;
        Fri, 11 Aug 2023 10:12:50 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u20-20020a62ed14000000b006870b923fb3sm3541250pfh.52.2023.08.11.10.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 10:12:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: consider ring dead once the ref is marked dying
Date:   Fri, 11 Aug 2023 11:12:41 -0600
Message-Id: <20230811171242.222550-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230811171242.222550-1-axboe@kernel.dk>
References: <20230811171242.222550-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't gate this on the task exiting flag. It's generally not a good idea
to gate it on the task PF_EXITING flag anyway. Once the ring is starting
to go through ring teardown, the ref is marked as dying. Use that as
our fallback/cancel mechanism.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 10 +++++++---
 io_uring/io_uring.h |  3 ++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fa0d4c2fd458..68344fbfc055 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -489,7 +489,11 @@ void io_queue_iowq(struct io_kiocb *req, struct io_tw_state *ts_dont_use)
 	 * procedure rather than attempt to run this request (or create a new
 	 * worker for it).
 	 */
-	if (WARN_ON_ONCE(!same_thread_group(req->task, current)))
+	WARN_ON_ONCE(!io_ring_ref_is_dying(req->ctx) &&
+		     !same_thread_group(req->task, current));
+
+	if (!same_thread_group(req->task, current) ||
+	    io_ring_ref_is_dying(req->ctx))
 		req->work.flags |= IO_WQ_WORK_CANCEL;
 
 	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
@@ -1354,8 +1358,8 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
-
-	if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
+	if (!io_ring_ref_is_dying(ctx) &&
+	    !task_work_add(req->task, &tctx->task_work, ctx->notify_method))
 		return;
 
 	io_fallback_tw(tctx, false);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 3e6ff3cd9a24..e06d898406c7 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -10,6 +10,7 @@
 #include "io-wq.h"
 #include "slist.h"
 #include "filetable.h"
+#include "refs.h"
 
 #ifndef CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -94,7 +95,7 @@ bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			lockdep_assert_held(&ctx->uring_lock);		\
 		} else if (!ctx->task_complete) {			\
 			lockdep_assert_held(&ctx->completion_lock);	\
-		} else if (ctx->submitter_task->flags & PF_EXITING) {	\
+		} else if (io_ring_ref_is_dying(ctx)) {		\
 			lockdep_assert(current_work());			\
 		} else {						\
 			lockdep_assert(current == ctx->submitter_task);	\
-- 
2.40.1

