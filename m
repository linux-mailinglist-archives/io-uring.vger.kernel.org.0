Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC54726DA3
	for <lists+io-uring@lfdr.de>; Wed,  7 Jun 2023 22:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbjFGUoP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jun 2023 16:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbjFGUoO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jun 2023 16:44:14 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4111FE2
        for <io-uring@vger.kernel.org>; Wed,  7 Jun 2023 13:43:52 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-25655c1fcf7so1505358a91.0
        for <io-uring@vger.kernel.org>; Wed, 07 Jun 2023 13:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686170625; x=1688762625;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kjTht/v7mE9h36bv8RH6aPgD/5g1NaAxrcV+B4S+BDo=;
        b=S8ploq0Jv/oumixpFcY4E4dew/f+poC3RUxhYsmjfkTO1DVZN6J4fNp+B4+mRCt/ro
         GbXFtP7z7TZonWMpVPPqIaFB9r7Ur+a3t8NvaVNWSvllfgfh2X+f3zMY3R6bJ65nuF0j
         vg3YXeuRg2l8HZtw2Y8Y6/mQubyvT6EaFXIEWA2dzrggAv+zI0sC8SMm6BihnF++EqJH
         LCAQI6MI/omVB2Qa/bLEYNby+JZqsYF4RFEZgLBY6LjGT20LgjORXFnjIqgMoZg9GWEK
         gLyGVrwHLQCcU6jF5DrQoWjBf/oFyx4moOOZ62tdqYnZ94pNHOoEwJTjY5o6vsrGCn7D
         FWEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686170625; x=1688762625;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kjTht/v7mE9h36bv8RH6aPgD/5g1NaAxrcV+B4S+BDo=;
        b=cKS7vpI5bX/l6mzB4WfGMSsNVt03GABDLUSpcb8RaVI9GJRzyltXbF4e1pg3jvp6AO
         TE5jDOfhddZH8+6vWpGa2E/mJXQ98+DfYSgC/kW6aS9pHpvu0LW6fQgqtMxscliBHi03
         E/NiKvNnf4yx/aidGOC930Q4mUekNSbE+IxMdUUg83E9NkiXXd6xI978APYAdkIleQes
         N4QEwHyADZU/jCWnZpMQ/4VxGFahBjrdVffALIx1aUKYIoAq05FXnRpJKmyazPNpVqSx
         RlB1b6R1SbjfquJ+Slo/vt+PrdEPlvCNbCph5n5VaadptYxX1Mgs/6GoUBgW27ervnO/
         0pCw==
X-Gm-Message-State: AC+VfDzwrkv/79kKCcslE+U2CXGJckB1wB0MsAIewb8kEe8xXYniuKG3
        TnHTfa+dTYiAfZucDzDIimLtmUtYPmeX2e6jdaw=
X-Google-Smtp-Source: ACHHUZ57c128m1qa4jVi5PPS6r0DTUqOmNX+xHFCkBZMSmIb9dslk31c1rNZdJIHZCRTkCR11N3thg==
X-Received: by 2002:a17:90b:38c2:b0:259:c00a:8830 with SMTP id nn2-20020a17090b38c200b00259c00a8830mr3647487pjb.4.1686170624952;
        Wed, 07 Jun 2023 13:43:44 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:122::1:6343? ([2620:10d:c090:600::2:9b70])
        by smtp.gmail.com with ESMTPSA id bk17-20020a17090b081100b00256b9d26a2bsm1740154pjb.44.2023.06.07.13.43.43
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 13:43:43 -0700 (PDT)
Message-ID: <e47ea2e6-8920-9ecb-b0a8-434e48f6aa90@kernel.dk>
Date:   Wed, 7 Jun 2023 14:43:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: cleanup io_aux_cqe() API
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Everybody is passing in the request, so get rid of the io_ring_ctx and
explicit user_data pass-in. Both the ctx and user_data can be deduced
from the request at hand.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fc511cb6761d..12bcab382e5f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -935,9 +935,11 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 	return __io_post_aux_cqe(ctx, user_data, res, cflags, true);
 }
 
-bool io_aux_cqe(struct io_ring_ctx *ctx, bool defer, u64 user_data, s32 res, u32 cflags,
+bool io_aux_cqe(struct io_kiocb *req, bool defer, s32 res, u32 cflags,
 		bool allow_overflow)
 {
+	struct io_ring_ctx *ctx = req->ctx;
+	u64 user_data = req->cqe.user_data;
 	struct io_uring_cqe *cqe;
 	unsigned int length;
 
@@ -963,7 +965,7 @@ bool io_aux_cqe(struct io_ring_ctx *ctx, bool defer, u64 user_data, s32 res, u32
 		return false;
 
 	cqe = &ctx->submit_state.cqes[ctx->submit_state.cqes_count++];
-	cqe->user_data = user_data;
+	cqe->user_data = req->cqe.user_data;
 	cqe->res = res;
 	cqe->flags = cflags;
 	return true;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 9b8dfb3bb2b4..316f524ec8ae 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -47,7 +47,7 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
-bool io_aux_cqe(struct io_ring_ctx *ctx, bool defer, u64 user_data, s32 res, u32 cflags,
+bool io_aux_cqe(struct io_kiocb *req, bool defer, s32 res, u32 cflags,
 		bool allow_overflow);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
diff --git a/io_uring/net.c b/io_uring/net.c
index 0795f3783013..369167e45fa8 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -632,8 +632,8 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	}
 
 	if (!mshot_finished) {
-		if (io_aux_cqe(req->ctx, issue_flags & IO_URING_F_COMPLETE_DEFER,
-			       req->cqe.user_data, *ret, cflags | IORING_CQE_F_MORE, true)) {
+		if (io_aux_cqe(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
+			       *ret, cflags | IORING_CQE_F_MORE, true)) {
 			io_recv_prep_retry(req);
 			/* Known not-empty or unknown state, retry */
 			if (cflags & IORING_CQE_F_SOCK_NONEMPTY ||
@@ -1304,7 +1304,6 @@ int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	struct io_accept *accept = io_kiocb_to_cmd(req, struct io_accept);
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
@@ -1354,8 +1353,8 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ret < 0)
 		return ret;
-	if (io_aux_cqe(ctx, issue_flags & IO_URING_F_COMPLETE_DEFER,
-		       req->cqe.user_data, ret, IORING_CQE_F_MORE, true))
+	if (io_aux_cqe(req, issue_flags & IO_URING_F_COMPLETE_DEFER, ret,
+		       IORING_CQE_F_MORE, true))
 		goto retry;
 
 	return -ECANCELED;
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 9689806d3c16..6b9179e8228e 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -300,8 +300,8 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 			__poll_t mask = mangle_poll(req->cqe.res &
 						    req->apoll_events);
 
-			if (!io_aux_cqe(req->ctx, ts->locked, req->cqe.user_data,
-					mask, IORING_CQE_F_MORE, false)) {
+			if (!io_aux_cqe(req, ts->locked, mask,
+					IORING_CQE_F_MORE, false)) {
 				io_req_set_res(req, mask, 0);
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 350eb830b485..fb0547b35dcd 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -73,8 +73,8 @@ static void io_timeout_complete(struct io_kiocb *req, struct io_tw_state *ts)
 
 	if (!io_timeout_finish(timeout, data)) {
 		bool filled;
-		filled = io_aux_cqe(ctx, ts->locked, req->cqe.user_data, -ETIME,
-				    IORING_CQE_F_MORE, false);
+		filled = io_aux_cqe(req, ts->locked, -ETIME, IORING_CQE_F_MORE,
+				    false);
 		if (filled) {
 			/* re-arm timer */
 			spin_lock_irq(&ctx->timeout_lock);

-- 
Jens Axboe

