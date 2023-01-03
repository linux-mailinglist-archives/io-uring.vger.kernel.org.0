Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4091B65B995
	for <lists+io-uring@lfdr.de>; Tue,  3 Jan 2023 04:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236606AbjACDFg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Jan 2023 22:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236626AbjACDFb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Jan 2023 22:05:31 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E247BF7A
        for <io-uring@vger.kernel.org>; Mon,  2 Jan 2023 19:05:30 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so22169865wms.2
        for <io-uring@vger.kernel.org>; Mon, 02 Jan 2023 19:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o2BAv+ryfLgNKGIDpPfwqLcUzObKBG5bNKUNy7ao14I=;
        b=Nv/W5O9e7W7oRhEdBbdwqEv8xeJIw3okvbCkU3OaDsLlX1cg4cMnTpIjIQAtEW2f5j
         OWAODFuZouSQyekHhYczc04o18rze/KG2lWj7PRK4SwzZDPrrDHzN6DFxZwTVc4MV/g+
         xeB9bL5GrJSM+1W5AsIZ0PwBPYIlPK8EI6MaC79Xq+OAQCKIq3QfAUaGfNSmyXNmkiU5
         ZMVe4ElFy4Kf5cbvkujmRyJadYUEQdhMvTiMJ0z3fyEv6xTn9xBnoGcQFSOXkq1+tTBC
         rdMz5xDtDsC+jyk8yBc0Y3hYIIhOTIj7/bvRuu/V8pzEKsauWCSgfbvAix6+3cCuRWgo
         M/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o2BAv+ryfLgNKGIDpPfwqLcUzObKBG5bNKUNy7ao14I=;
        b=t0kRKT9QCzgqS2N8pU/X93MNLzPBhQZyEw66ztizCjpTPC1+2hIQhKsPtMbfio4n8x
         bXnhIp/QasTi7eWPXmP1HrQmHyFXrP3HMLspL669pKmdy8J/rYf4cMqzWEhQwbgd6a3V
         5lXvAB+fBIMHlKgxD6IiFH9GBZo0FF77KF0O/Wou6e/5GkjHutpUE84W+ql80RtdvUaV
         8S1WIsR27SfpSAfbgc5bxVH7zrhf97engw5oUf6W1Ra7HbTM0tf9mQSUPshcC121E5v2
         PWJYPT9Gnm12U2C9p+d4b6gXF0EVxMJHqd2OkDnp1rbjxxMGglbY7bHznM/8NLscW7+M
         CimQ==
X-Gm-Message-State: AFqh2kqZeRzoEJs0b6RsmR0IpRDpnBpyIewYfLidmwv/8MkY15cXe86l
        5//fdI+n+wCc3OS7o9fC1yDkpp0bqp4=
X-Google-Smtp-Source: AMrXdXuB2yV9Z6wVqpkBqJnmFMBi165wJ6YYLXjvPr4TP059qEyszWrt5ELzBThwLJf243a1kW1I7Q==
X-Received: by 2002:a7b:c4da:0:b0:3d3:864a:1173 with SMTP id g26-20020a7bc4da000000b003d3864a1173mr29167489wmk.18.1672715129396;
        Mon, 02 Jan 2023 19:05:29 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id m1-20020a7bca41000000b003d1de805de5sm39967839wml.16.2023.01.02.19.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 19:05:29 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC v2 13/13] io_uring: add io_req_local_work_add wake fast path
Date:   Tue,  3 Jan 2023 03:04:04 +0000
Message-Id: <f7c52527313e6f0d8dff2bb36ecad2380f5c5c9c.1672713341.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672713341.git.asml.silence@gmail.com>
References: <cover.1672713341.git.asml.silence@gmail.com>
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

Don't wake the master task after queueing a deferred tw unless it's
currently waiting in io_cqring_wait.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 1 +
 io_uring/io_uring.c            | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 1452ff745e5c..332a29cfe076 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -285,6 +285,7 @@ struct io_ring_ctx {
 
 		unsigned		cached_cq_tail;
 		unsigned		cq_entries;
+		bool			cq_waiting;
 		struct io_ev_fd	__rcu	*io_ev_fd;
 		struct wait_queue_head	cq_wait;
 		struct wait_queue_head	poll_wq;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 943032d2fd21..e436fe73becf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1275,7 +1275,8 @@ static void io_req_local_work_add(struct io_kiocb *req)
 		io_eventfd_signal(ctx);
 
 	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
-		wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
+		if (READ_ONCE(ctx->cq_waiting))
+			wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
 	} else {
 		__io_cqring_wake(ctx);
 	}
@@ -2565,6 +2566,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
 			set_current_state(TASK_INTERRUPTIBLE);
+			smp_store_mb(ctx->cq_waiting, 1);
 		} else {
 			prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 							TASK_INTERRUPTIBLE);
@@ -2572,6 +2574,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
 		__set_current_state(TASK_RUNNING);
+		WRITE_ONCE(ctx->cq_waiting, 0);
+
 		if (ret < 0)
 			break;
 		/*
-- 
2.38.1

