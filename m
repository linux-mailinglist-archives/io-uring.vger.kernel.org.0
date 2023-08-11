Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50A9778FF5
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 14:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbjHKMzR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 08:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbjHKMzQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 08:55:16 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A386114
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:55:16 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-99c47ef365cso281980266b.0
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691758514; x=1692363314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YJbLz9QdYPZV5kn6edsU70ey95VfZY7HvhquINjrY44=;
        b=iAOOICYcaIDRQzRgQkZvD65NfcZ9h93G4bHmYfLj8txChX+vfjB3IDGy+M4hCtj0qr
         3KAvvBRa6dJY8uqS8Kfh0GWlT+QrRQoYvjSyX+g5ibu8iNMux2QrzRiCnK4fn5Eb0GWT
         8J8iHguoFRcukAalm0j9FY6tz04m7bGsiokKEepzRZ0sr1/NAEOlP/+Db3+/ZoWoKLot
         zOX84L1UiaFMdqGfYIr73ZtHoNLLExb9O3lWqu7WDhqXufkiEhiEeUIuERMh5IvM3C6R
         nb8e8HPDISay1isiqItZI7UdK4vSoNm59wqlJ+18hCGMQZvN24irSeLjwSrZ9atq9GbE
         tTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691758514; x=1692363314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YJbLz9QdYPZV5kn6edsU70ey95VfZY7HvhquINjrY44=;
        b=FAnche3XZyrbNFd4pQzd6pUWfQpwRBgDrL8fQJ41OdTEs1sa4QPnCPIvFT69LaN3da
         FLU6dqIUC2+kRwwMScphYqHntdkw35R53CdwRYhN83zTLzNGdpi2iDr31+PRokmHH72F
         yhTTc0JFlf2DS8lS2jB47nWixAXFMD2OKrBB5Fl44MvP7ZIQRL1eCIiJT4AGOsGWshqI
         pLwaKk0ZTPV+IZinwCC/m+0yRNmYQQDw6XmdTpaLQXvi92n3or8M2dzBuzvUb39Mu472
         2KlRxabpJ5qDDrXc/eBai8OxBmBN/51p2OF/5I7P8ksuAJR2QfvVzB+fhv7gNxAmZyBz
         c5Kg==
X-Gm-Message-State: AOJu0Yyae9sniOsKcNf9XJAcFDa2klHwK+1UJ6VDJN9N9z9pxBho5GwR
        CR8W/XWBPhOjnbJfkwyUWJ6xDOY6Esc=
X-Google-Smtp-Source: AGHT+IGp26d3omOxY9UWuDjRWyX3296Xtvudj7s9cxmfD0/9NQKK43UPD39Bd6EMurMj3wAclJkMvw==
X-Received: by 2002:a17:906:31cb:b0:99c:e38d:e47f with SMTP id f11-20020a17090631cb00b0099ce38de47fmr1561738ejf.33.1691758513983;
        Fri, 11 Aug 2023 05:55:13 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a57e])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm2206943ejc.157.2023.08.11.05.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 05:55:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5/7] io_uring: never overflow io_aux_cqe
Date:   Fri, 11 Aug 2023 13:53:45 +0100
Message-ID: <bb20d14d708ea174721e58bb53786b0521e4dd6d.1691757663.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1691757663.git.asml.silence@gmail.com>
References: <cover.1691757663.git.asml.silence@gmail.com>
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

Now all callers of io_aux_cqe() set allow_overflow to false, remove the
parameter and not allow overflowing auxilary multishot cqes.

When CQ is full the function callers and all multishot requests in
general are expected to complete the request. That prevents indefinite
in-background grows of the overflow list and let's the userspace to
handle the backlog at its own pace.

Resubmitting a request should also be faster than accounting a bunch of
overflows, so it should be better for perf when it happens, but a well
behaving userspace should be trying to avoid overflows in any case.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 11 +++++++----
 io_uring/io_uring.h |  3 +--
 io_uring/net.c      |  8 ++++----
 io_uring/poll.c     |  4 ++--
 io_uring/timeout.c  |  4 ++--
 5 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7595658a5073..e57d00939ab9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -939,15 +939,18 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 	return __io_post_aux_cqe(ctx, user_data, res, cflags, true);
 }
 
-bool io_aux_cqe(const struct io_kiocb *req, bool defer, s32 res, u32 cflags,
-		bool allow_overflow)
+/*
+ * A helper for multishot requests posting additional CQEs.
+ * Should only be used from a task_work including IO_URING_F_MULTISHOT.
+ */
+bool io_fill_cqe_req_aux(struct io_kiocb *req, bool defer, s32 res, u32 cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	u64 user_data = req->cqe.user_data;
 	struct io_uring_cqe *cqe;
 
 	if (!defer)
-		return __io_post_aux_cqe(ctx, user_data, res, cflags, allow_overflow);
+		return __io_post_aux_cqe(ctx, user_data, res, cflags, false);
 
 	lockdep_assert_held(&ctx->uring_lock);
 
@@ -962,7 +965,7 @@ bool io_aux_cqe(const struct io_kiocb *req, bool defer, s32 res, u32 cflags,
 	 * however it's main job is to prevent unbounded posted completions,
 	 * and in that it works just as well.
 	 */
-	if (!allow_overflow && test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq))
+	if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq))
 		return false;
 
 	cqe = &ctx->submit_state.cqes[ctx->submit_state.cqes_count++];
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 3dc0b6fb0ef7..3e6ff3cd9a24 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -44,8 +44,7 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
-bool io_aux_cqe(const struct io_kiocb *req, bool defer, s32 res, u32 cflags,
-		bool allow_overflow);
+bool io_fill_cqe_req_aux(struct io_kiocb *req, bool defer, s32 res, u32 cflags);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
diff --git a/io_uring/net.c b/io_uring/net.c
index 8c419c01a5db..3d07bf79c1e0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -641,8 +641,8 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	}
 
 	if (!mshot_finished) {
-		if (io_aux_cqe(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
-			       *ret, cflags | IORING_CQE_F_MORE, false)) {
+		if (io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
+					*ret, cflags | IORING_CQE_F_MORE)) {
 			io_recv_prep_retry(req);
 			/* Known not-empty or unknown state, retry */
 			if (cflags & IORING_CQE_F_SOCK_NONEMPTY ||
@@ -1366,8 +1366,8 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ret < 0)
 		return ret;
-	if (io_aux_cqe(req, issue_flags & IO_URING_F_COMPLETE_DEFER, ret,
-		       IORING_CQE_F_MORE, false))
+	if (io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
+				ret, IORING_CQE_F_MORE))
 		goto retry;
 
 	return -ECANCELED;
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 65ec363f6377..4c360ba8793a 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -300,8 +300,8 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 			__poll_t mask = mangle_poll(req->cqe.res &
 						    req->apoll_events);
 
-			if (!io_aux_cqe(req, ts->locked, mask,
-					IORING_CQE_F_MORE, false)) {
+			if (!io_fill_cqe_req_aux(req, ts->locked, mask,
+						 IORING_CQE_F_MORE)) {
 				io_req_set_res(req, mask, 0);
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 6242130e73c6..7fd7dbb211d6 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -73,8 +73,8 @@ static void io_timeout_complete(struct io_kiocb *req, struct io_tw_state *ts)
 
 	if (!io_timeout_finish(timeout, data)) {
 		bool filled;
-		filled = io_aux_cqe(req, ts->locked, -ETIME, IORING_CQE_F_MORE,
-				    false);
+		filled = io_fill_cqe_req_aux(req, ts->locked, -ETIME,
+					     IORING_CQE_F_MORE);
 		if (filled) {
 			/* re-arm timer */
 			spin_lock_irq(&ctx->timeout_lock);
-- 
2.41.0

