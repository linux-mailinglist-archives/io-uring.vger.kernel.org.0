Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7676421A9
	for <lists+io-uring@lfdr.de>; Mon,  5 Dec 2022 03:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiLECpn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Dec 2022 21:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiLECpm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Dec 2022 21:45:42 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DF1FACA
        for <io-uring@vger.kernel.org>; Sun,  4 Dec 2022 18:45:41 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id h10so7094113wrx.3
        for <io-uring@vger.kernel.org>; Sun, 04 Dec 2022 18:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ajY7oGhe0hmOGNUv5BKDKhjewuXgAiFYQv5RXF5CL34=;
        b=ToBIr6PVGPshoyADvy5PYrdDjRH+YZ+vrcG0LmtA1UW7N/kafzyk5n5gl8J36smCk2
         xYNJDM63TgvfjewObMDupCEGiQNoB3/hvJu62l9qk1Nb7RjRmiBrFdySengxOQhaAU5f
         7pYlN5LwbusqNCHre2z4BKHL5VIVWwOcSc0QGoJ0ow1TatZNfhDY5Yvfnac4ixqYUh+n
         MjNuC4hib84jU30D5hglT7PN2RVWq+t6QtweMVwhY8+EfkwDTkVuMqLo9Yk/rMRKKbXA
         R+fIekK+6RmeLgemfPDKjqjAqBFpkbUW6d+enQHZBJ3e507uNNnwAGf8t2kZiM+hPu8K
         jhCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ajY7oGhe0hmOGNUv5BKDKhjewuXgAiFYQv5RXF5CL34=;
        b=kphNU4j/SaoMJqsYjzwwRiUXihxv68KDrvHgWS2foxWyVNxc8wbY2bIzV40Jp5XYqJ
         7ugmsKCBPOyRbXjKSOYqNQq0l1BvaaJOvNIlhsDV8kM0H/LJOUSOqjvX3ji613TLEVpt
         thEMVc+9IXFu8rNne3w4tIEhmK2V3juzAlme+i/zAQA+bY0oJ8DixfRtEgKi9LI0cK7F
         nQaugmy4e35DkCB+K/1D+JwK1Jj36WAy3gp3SNlXnIIxUkmhdCnHozT7DL8YensumQsp
         Xv7He0/6tRY41i9qycGA1YDGXK5JU41GNUztJvfdQ0ZrOoFDoPy4oiK5iBySZrLC+9ND
         UFXA==
X-Gm-Message-State: ANoB5plcx3wUUH8+nT7BYoTFfcx0Ld/BqaAnVrc+FBUTAfWgLuvXFFJs
        LwQwNwBHs2Xweid6pshTWHtzf1nM0ac=
X-Google-Smtp-Source: AA0mqf51LGxdRxx2l4Gjq+YOFdrXlljXmHDczQBz2IRTMN7ZyqZ9ov9r3nMbEe3x1RjKLDtC2/Ahpg==
X-Received: by 2002:a5d:67d0:0:b0:241:781e:606 with SMTP id n16-20020a5d67d0000000b00241781e0606mr49435377wrw.216.1670208339584;
        Sun, 04 Dec 2022 18:45:39 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id t17-20020a05600c41d100b003cf71b1f66csm15281532wmh.0.2022.12.04.18.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 18:45:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/7] io_uring: complete all requests in task context
Date:   Mon,  5 Dec 2022 02:44:27 +0000
Message-Id: <24ed012156ad8c9f3b13dd7fe83925443cbdd627.1670207706.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670207706.git.asml.silence@gmail.com>
References: <cover.1670207706.git.asml.silence@gmail.com>
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

This patch adds ctx->task_complete flag. If set, we'll complete all
requests in the context of the original task. Note, this extends to
completion CQE posting only but not io_kiocb cleanup / free, e.g. io-wq
may free the requests in the free calllback. This flag will be used
later for optimisations purposes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring.h       |  2 ++
 include/linux/io_uring_types.h |  2 ++
 io_uring/io_uring.c            | 14 +++++++++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 29e519752da4..934e5dd4ccc0 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -11,6 +11,8 @@ enum io_uring_cmd_flags {
 	IO_URING_F_UNLOCKED		= 2,
 	/* the request is executed from poll, it should not be freed */
 	IO_URING_F_MULTISHOT		= 4,
+	/* executed by io-wq */
+	IO_URING_F_IOWQ			= 8,
 	/* int's last bit, sign checks are usually faster than a bit test */
 	IO_URING_F_NONBLOCK		= INT_MIN,
 
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index accdfecee953..6be1e1359c89 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -208,6 +208,8 @@ struct io_ring_ctx {
 		unsigned int		drain_disabled: 1;
 		unsigned int		has_evfd: 1;
 		unsigned int		syscall_iopoll: 1;
+		/* all CQEs should be posted only by the submitter task */
+		unsigned int		task_complete: 1;
 	} ____cacheline_aligned_in_smp;
 
 	/* submission data */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7239776a9d4b..0c86df7112fb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -932,8 +932,11 @@ static void __io_req_complete_post(struct io_kiocb *req)
 
 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
-	if (!(issue_flags & IO_URING_F_UNLOCKED) ||
-	    !(req->ctx->flags & IORING_SETUP_IOPOLL)) {
+	if (req->ctx->task_complete && (issue_flags & IO_URING_F_IOWQ)) {
+		req->io_task_work.func = io_req_task_complete;
+		io_req_task_work_add(req);
+	} else if (!(issue_flags & IO_URING_F_UNLOCKED) ||
+		   !(req->ctx->flags & IORING_SETUP_IOPOLL)) {
 		__io_req_complete_post(req);
 	} else {
 		struct io_ring_ctx *ctx = req->ctx;
@@ -1841,7 +1844,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	const struct io_op_def *def = &io_op_defs[req->opcode];
-	unsigned int issue_flags = IO_URING_F_UNLOCKED;
+	unsigned int issue_flags = IO_URING_F_UNLOCKED | IO_URING_F_IOWQ;
 	bool needs_poll = false;
 	int ret = 0, err = -ECANCELED;
 
@@ -3501,6 +3504,11 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (!ctx)
 		return -ENOMEM;
 
+	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
+	    !(ctx->flags & IORING_SETUP_IOPOLL) &&
+	    !(ctx->flags & IORING_SETUP_SQPOLL))
+		ctx->task_complete = true;
+
 	/*
 	 * When SETUP_IOPOLL and SETUP_SQPOLL are both enabled, user
 	 * space applications don't need to do io completion events
-- 
2.38.1

