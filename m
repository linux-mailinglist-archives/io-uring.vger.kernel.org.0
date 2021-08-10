Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AD23E599F
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 14:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238727AbhHJMG5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 08:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238600AbhHJMG5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 08:06:57 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015D1C0613D3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 05:06:35 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id b13so25961494wrs.3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 05:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=p8mxPlvKVZV7Sqs+PzhRGZ72Qz+qDN9HA8NttbmGicc=;
        b=g8EhMC62quXrsHi0ImAFxvvPWTHFoZlJFCjgP5XwBHHGAdWgbJI7O0FKhfOAkVk9MB
         mbvyq+jmIyTNH/EA02sdVRJZKRZgc9DWv4bamU5fC6vLogU5mkuhKyxlPxfbTzjlcaX8
         8Ix9ziaelFR2a50/uS1K0Cy3AWMzvDkYJUECFw14BO2RCDWqUGSweo4C/t0Zt6DYNPMh
         gQ4m+CkViLXVypQERJdZj19+KByFpMzLgTrHLVJzHKBXhXCzV4oOSKmtU/65EFmiE8W2
         jfRAeTW8IZy0HrB0E1mb5FxvTNiZz7gylnzWOR4erVrGafD60mp8RlbgurK5Eh7gJoBx
         GFEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p8mxPlvKVZV7Sqs+PzhRGZ72Qz+qDN9HA8NttbmGicc=;
        b=JMdhPzFVHUunj7e2sNpoJZUKXoxID3loGQgnCyD5+LuNk81LsMergYOhPTxOYT0UOH
         Ryr6JORPH9FBpbSd/AlGS5EWyn4T3GL+8lduMI4wZewJGI0nbTePoy+ohYzuDrz7Zq1g
         OhVB3ZYvzKm/EZuTzO3/n1vTvqs5tT3NF21GR8MED/D+gHECncAaNBKNhWWexJOaeKmq
         oalytLuggMX+s8PwrbUTGgkvDeD/yWgdEb6qOj4mfA/XY7soGNF05pF/wObwbQZJKQrH
         anVi9I6nF1m3KeOr39Vk6Rk2p0b7rvBxcwyUFjxIKnE5Ix6za/FuHTQgMS5sZII0yN61
         Awdg==
X-Gm-Message-State: AOAM5330IhawNEy4iUNrdtuiVqJFeNpfCfFD+NxQ0wh50DgZGGSMPRhS
        7tqIJtKxluQJMfC8D9aqono=
X-Google-Smtp-Source: ABdhPJzGqaFbdj0CtXdpl1/01ACyPkpCe0y6KPSxe/335Xy+KYiK9lYHlyv4vA4VzsRk/583/kfYsw==
X-Received: by 2002:a5d:49cf:: with SMTP id t15mr8713429wrs.208.1628597193600;
        Tue, 10 Aug 2021 05:06:33 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id d15sm24954362wri.96.2021.08.10.05.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 05:06:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/5] io_uring: remove req_ref_sub_and_test()
Date:   Tue, 10 Aug 2021 13:05:53 +0100
Message-Id: <d46a0584d3742cbb85175f74e5abefc7c9b0c2e8.1628595748.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628595748.git.asml.silence@gmail.com>
References: <cover.1628595748.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Soon, we won't need to put several references at once, remove
req_ref_sub_and_test() and @nr argument from io_put_req_deferred(),
and put the rest of the references by hand.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cd3a1058f657..5a08cc967199 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1043,7 +1043,7 @@ static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
 				 long res, unsigned int cflags);
 static void io_put_req(struct io_kiocb *req);
-static void io_put_req_deferred(struct io_kiocb *req, int nr);
+static void io_put_req_deferred(struct io_kiocb *req);
 static void io_dismantle_req(struct io_kiocb *req);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
@@ -1093,12 +1093,6 @@ static inline bool req_ref_inc_not_zero(struct io_kiocb *req)
 	return atomic_inc_not_zero(&req->refs);
 }
 
-static inline bool req_ref_sub_and_test(struct io_kiocb *req, int refs)
-{
-	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
-	return atomic_sub_and_test(refs, &req->refs);
-}
-
 static inline bool req_ref_put_and_test(struct io_kiocb *req)
 {
 	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
@@ -1376,7 +1370,7 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
 		io_cqring_fill_event(req->ctx, req->user_data, status, 0);
-		io_put_req_deferred(req, 1);
+		io_put_req_deferred(req);
 	}
 }
 
@@ -1870,7 +1864,7 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 		if (hrtimer_try_to_cancel(&io->timer) != -1) {
 			io_cqring_fill_event(link->ctx, link->user_data,
 					     -ECANCELED, 0);
-			io_put_req_deferred(link, 1);
+			io_put_req_deferred(link);
 			return true;
 		}
 	}
@@ -1889,7 +1883,9 @@ static void io_fail_links(struct io_kiocb *req)
 
 		trace_io_uring_fail_link(req, link);
 		io_cqring_fill_event(link->ctx, link->user_data, -ECANCELED, 0);
-		io_put_req_deferred(link, 2);
+
+		io_put_req(link);
+		io_put_req_deferred(link);
 		link = nxt;
 	}
 }
@@ -2171,7 +2167,8 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 		struct io_kiocb *req = state->compl_reqs[i];
 
 		/* submission and completion refs */
-		if (req_ref_sub_and_test(req, 2))
+		io_put_req(req);
+		if (req_ref_put_and_test(req))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
 	}
 
@@ -2200,9 +2197,9 @@ static inline void io_put_req(struct io_kiocb *req)
 		io_free_req(req);
 }
 
-static inline void io_put_req_deferred(struct io_kiocb *req, int refs)
+static inline void io_put_req_deferred(struct io_kiocb *req)
 {
-	if (req_ref_sub_and_test(req, refs)) {
+	if (req_ref_put_and_test(req)) {
 		req->io_task_work.func = io_free_req;
 		io_req_task_work_add(req);
 	}
@@ -5261,7 +5258,6 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
 static bool io_poll_remove_one(struct io_kiocb *req)
 	__must_hold(&req->ctx->completion_lock)
 {
-	int refs;
 	bool do_complete;
 
 	io_poll_remove_double(req);
@@ -5273,8 +5269,9 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 		req_set_fail(req);
 
 		/* non-poll requests have submit ref still */
-		refs = 1 + (req->opcode != IORING_OP_POLL_ADD);
-		io_put_req_deferred(req, refs);
+		if (req->opcode != IORING_OP_POLL_ADD)
+			io_put_req(req);
+		io_put_req_deferred(req);
 	}
 	return do_complete;
 }
@@ -5565,7 +5562,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 
 	req_set_fail(req);
 	io_cqring_fill_event(ctx, req->user_data, -ECANCELED, 0);
-	io_put_req_deferred(req, 1);
+	io_put_req_deferred(req);
 	return 0;
 }
 
@@ -6416,8 +6413,8 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 
 	if (prev) {
 		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
-		io_put_req_deferred(prev, 1);
-		io_put_req_deferred(req, 1);
+		io_put_req_deferred(prev);
+		io_put_req_deferred(req);
 	} else {
 		io_req_complete_post(req, -ETIME, 0);
 	}
-- 
2.32.0

