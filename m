Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634766452B6
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 04:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiLGDyj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 22:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiLGDyi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 22:54:38 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9574A27168
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 19:54:37 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id m18so9506630eji.5
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 19:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FVS0T7T3Ozq0qySF9iT4OWlcTNwZwEIB7k/FfHEjpAA=;
        b=UT9Xx3wqNraPVuCpehat9w1RfNR3OkCTJ39vrUIynSs+uNcrd7eJALy0aAnSsBMIR1
         LVWRzDlH6RiMFtRZ6phRNj3dY56dLClDTrFGR0PRFBOXqJKR4FHMQuNRe6kTip7L4fEC
         z8E7txA4SzHvxPY6j3lbwBl0qa4e0iFY6654t1AbeH+/g4FZdeiS/jU5dSfq355shQnC
         ReIDM2ZHeL1Z+vgJzqCCSjZgKo9e3YxQtDP6dHQtBlOiygYLxsFPHr2kVF+AIN28SkkA
         V+sq+VVzb+B9x6ZCrLuh0V9VCKEF9afpMKZSeFvb7PfL4+tnAyrdDJoQq4CmM2OiIYsW
         boqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FVS0T7T3Ozq0qySF9iT4OWlcTNwZwEIB7k/FfHEjpAA=;
        b=6HSnymjwHEy6DrrEKm/RMrAMoaZFGPys0xKx6FrDntGwPvpxm2vdwcmpBK0acaJYQS
         LrmKrYj2TG3HX3LcGA0s33tD2usgV2a2xuhBcbwIoCxQG7SpXOyVkp8oZjLM6N8V+Ac/
         soR8TR5T5TMmDt36YcQE6sdzLGSyksuk8OBGONvboElDMuBYVd8eVu8jvRwPhNMUTB9s
         nxP/ns96ckLbEyBDiodKdPAnuL4GIkngiyldmekd7Ae2KzIoP6rnlKK+L3ag0ZqgNuGO
         ptke9Sa/wsny6tPRKdtcbQrIaeznawkJaqUp5A0McjLQubUuaJSVqKWWM+fscCtEo6i2
         RJJQ==
X-Gm-Message-State: ANoB5plAs3GG0eltwKD+ZUbfpwrayZbM7QqK0K2nXcI06u/QuWv5XPDJ
        398DtIxNCRYJVXlRpZX8Eiuiqc1Dhdw=
X-Google-Smtp-Source: AA0mqf57sjUHbcpo6NHSBr5YwTZbVZ24aX/IP/ENPA7I2xn/4gtFGHUzt4eMq+hSz8hPcWHLzEJ/tA==
X-Received: by 2002:a17:906:5213:b0:7b6:12ee:b7fc with SMTP id g19-20020a170906521300b007b612eeb7fcmr25192583ejm.265.1670385277038;
        Tue, 06 Dec 2022 19:54:37 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b0073de0506745sm7938939ejt.197.2022.12.06.19.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 19:54:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 05/12] io_uring: complete all requests in task context
Date:   Wed,  7 Dec 2022 03:53:30 +0000
Message-Id: <21ece72953f76bb2e77659a72a14326227ab6460.1670384893.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670384893.git.asml.silence@gmail.com>
References: <cover.1670384893.git.asml.silence@gmail.com>
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
index 7bebca5ed950..52ea83f241c6 100644
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

