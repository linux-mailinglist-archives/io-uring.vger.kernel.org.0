Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4EA2335EF
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 17:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729808AbgG3PqL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 11:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729989AbgG3Pp7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 11:45:59 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987B8C061574
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:45:58 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id c16so8063943ejx.12
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=lGo1b0m/AMwOVuG4xr38BKWJm86tU3Ns7YEME8jieJ8=;
        b=pk79ExshgZ1joWO02mMV+f71yAUQRu3pMDykzB3plDxPKXo7xwWRofkhuYHXxNvoLv
         DKo0K0ZNm7BS/tFWi8pPLxuDVMrYjmVl+aeib+PhaoDrJVFnFTF32T8oSiaIIe5DUMhG
         rC5Okp/taRUyyvjLK1MdTPQKsNWW4uh2hYDiAFgUizRH0zpfFE1wN2OyKWr4FtMoa0yi
         ZZ7DIRyJ6hus4yW4u8q+yS5QKHwa7NhE0uW/MLOi07dF/jgfE7vrCYNdvUFUGQuYPwP0
         ZqtYTySYE1Aa+RlLL8ZJ867Ph6GD8UuBHzW0Q5hyyOOLRrMZnNzDkDaPMwfVtyqjiB2V
         P0Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lGo1b0m/AMwOVuG4xr38BKWJm86tU3Ns7YEME8jieJ8=;
        b=Dm2GLL75UyyDPxjOqTc5zHMbXura6+eouTnfN46dlNfBXCmBq8GzMg0cpyNif9s9Ad
         CQtIuTw9igBoXMejjAzC/OPgL9xF546OZfYVvaZgrRs9V/3pECvVWPRFJSy+YfsG2DQg
         tAf2g0aV6kHw3eU1JhQ/KH4p0oyJ7A6+IH5nr4WFuk9CpfF4bukWYLMrwNGOg/TryIeT
         y91O48B/fn7GfsWpMLevAzJmvZTACpMnR8PNiykaHhGlPcyOopsmYuFJ19nSZCe34Hj/
         496hQz9ecf7NPnfKMgpZdl1ZzGD0al5O6mrY0DIKWrVoMUHWak/1FQqZw/lnAHJDh5AS
         gO3w==
X-Gm-Message-State: AOAM530gmBTioRn2zZEPbWnfpov/tGF7sOKoT3AC48VBFewPtUXtG92p
        ynerGTtz3gNIh5jL2egH6p4=
X-Google-Smtp-Source: ABdhPJw9YRpGs7x8Jc17piV8Mx160SdvBjEzY64gIeF20viHMg4ZUSrdOHKxCKvj42NJIWOKSkLJxQ==
X-Received: by 2002:a17:906:f202:: with SMTP id gt2mr3211631ejb.70.1596123957313;
        Thu, 30 Jul 2020 08:45:57 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id g25sm6740962edp.22.2020.07.30.08.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 08:45:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/6] io_uring: de-unionise io_kiocb
Date:   Thu, 30 Jul 2020 18:43:45 +0300
Message-Id: <fc65b0d9542140ea199a8556003f569518d40085.1596123376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1596123376.git.asml.silence@gmail.com>
References: <cover.1596123376.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As io_kiocb have enough space, move ->work out of a union. It's safer
this way and removes ->work memcpy bouncing.
By the way make tabulation in struct io_kiocb consistent.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 59 ++++++++++++---------------------------------------
 1 file changed, 14 insertions(+), 45 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3e406bc1f855..86ec5669fe50 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -600,7 +600,6 @@ enum {
 struct async_poll {
 	struct io_poll_iocb	poll;
 	struct io_poll_iocb	*double_poll;
-	struct io_wq_work	work;
 };
 
 /*
@@ -641,36 +640,26 @@ struct io_kiocb {
 	u16				buf_index;
 	u32				result;
 
-	struct io_ring_ctx	*ctx;
-	unsigned int		flags;
-	refcount_t		refs;
-	struct task_struct	*task;
-	u64			user_data;
+	struct io_ring_ctx		*ctx;
+	unsigned int			flags;
+	refcount_t			refs;
+	struct task_struct		*task;
+	u64				user_data;
 
-	struct list_head	link_list;
+	struct list_head		link_list;
 
 	/*
 	 * 1. used with ctx->iopoll_list with reads/writes
 	 * 2. to track reqs with ->files (see io_op_def::file_table)
 	 */
-	struct list_head	inflight_entry;
-
-	struct percpu_ref	*fixed_file_refs;
-
-	union {
-		/*
-		 * Only commands that never go async can use the below fields,
-		 * obviously. Right now only IORING_OP_POLL_ADD uses them, and
-		 * async armed poll handlers for regular commands. The latter
-		 * restore the work, if needed.
-		 */
-		struct {
-			struct hlist_node	hash_node;
-			struct async_poll	*apoll;
-		};
-		struct io_wq_work	work;
-	};
-	struct callback_head	task_work;
+	struct list_head		inflight_entry;
+
+	struct percpu_ref		*fixed_file_refs;
+	struct callback_head		task_work;
+	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
+	struct hlist_node		hash_node;
+	struct async_poll		*apoll;
+	struct io_wq_work		work;
 };
 
 struct io_defer_entry {
@@ -4668,10 +4657,6 @@ static void io_async_task_func(struct callback_head *cb)
 	io_poll_remove_double(req, apoll->double_poll);
 	spin_unlock_irq(&ctx->completion_lock);
 
-	/* restore ->work in case we need to retry again */
-	if (req->flags & REQ_F_WORK_INITIALIZED)
-		memcpy(&req->work, &apoll->work, sizeof(req->work));
-
 	if (!READ_ONCE(apoll->poll.canceled))
 		__io_req_task_submit(req);
 	else
@@ -4763,9 +4748,6 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	apoll->double_poll = NULL;
 
 	req->flags |= REQ_F_POLLED;
-	if (req->flags & REQ_F_WORK_INITIALIZED)
-		memcpy(&apoll->work, &req->work, sizeof(req->work));
-
 	io_get_req_task(req);
 	req->apoll = apoll;
 	INIT_HLIST_NODE(&req->hash_node);
@@ -4784,8 +4766,6 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	if (ret) {
 		io_poll_remove_double(req, apoll->double_poll);
 		spin_unlock_irq(&ctx->completion_lock);
-		if (req->flags & REQ_F_WORK_INITIALIZED)
-			memcpy(&req->work, &apoll->work, sizeof(req->work));
 		kfree(apoll->double_poll);
 		kfree(apoll);
 		return false;
@@ -4828,14 +4808,6 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 		do_complete = __io_poll_remove_one(req, &apoll->poll);
 		if (do_complete) {
 			io_put_req(req);
-			/*
-			 * restore ->work because we will call
-			 * io_req_clean_work below when dropping the
-			 * final reference.
-			 */
-			if (req->flags & REQ_F_WORK_INITIALIZED)
-				memcpy(&req->work, &apoll->work,
-				       sizeof(req->work));
 			kfree(apoll->double_poll);
 			kfree(apoll);
 		}
@@ -4969,9 +4941,6 @@ static int io_poll_add(struct io_kiocb *req)
 	struct io_poll_table ipt;
 	__poll_t mask;
 
-	/* ->work is in union with hash_node and others */
-	io_req_clean_work(req);
-
 	INIT_HLIST_NODE(&req->hash_node);
 	ipt.pt._qproc = io_poll_queue_proc;
 
-- 
2.24.0

