Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F3A212FDA
	for <lists+io-uring@lfdr.de>; Fri,  3 Jul 2020 01:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgGBXHB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jul 2020 19:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgGBXHA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jul 2020 19:07:00 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE24DC08C5C1
        for <io-uring@vger.kernel.org>; Thu,  2 Jul 2020 16:07:00 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z3so3879139pfn.12
        for <io-uring@vger.kernel.org>; Thu, 02 Jul 2020 16:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZsfZ0uy5hkMfsWnqElu1hmdPi8+7CoOo2j21sL5tCEY=;
        b=R7GoBFjG5jRcYCfxJG4jdg8NC7ZkbtcyzHvBU4VxQFXdPWD/+Iah8isv9egNzXw8nb
         yO5iOmyc58WxMr0moNuPIRiYLtV5tSSY1LlSdPp+Jzf2uZrdHG2KbMVIcFk8C2sqewVS
         pAKLoXbM8RdfB6SXYWJj5UKj3YX+US17yyhDhsADpQGfhu5cdfecOSKV0JSQsq+apUT+
         BMJP0jyeKkRNHJGG2qLxso7D4bbe7gVxKIJaZL2/9kNW4aClIWKLiAJSCOx/npPANMSi
         enM+2DxNO+AMyw/kAh4vscTrFl4cp375ZpIH4ETtoBXUxhMePMW7OllCD4XcTggvcDMM
         l62w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZsfZ0uy5hkMfsWnqElu1hmdPi8+7CoOo2j21sL5tCEY=;
        b=C0TM+Q+VqiK5t8F+Wx/UHNXiNFKHtlM5THKmJs+eKpz1pe1Q0de4Z7el4vQG4+1PuS
         ++5iy7riJcCaEy9Vvc76uVcKDq294nfVKAWSMWHjONu4kYApLthvuq8gSWjrCkE9LepR
         HGWbl7ukPvzTlOcNkJWCBnIhsa48if/MM4KZuS7BZfDBuNeOFM0GCyGlDO19arIX1buj
         4NbI5LJeW7zrwlfmZT7dnkhrGGYaIRpeK3qhLEJ4tHkEVyLjw6X/m00hhsECrBkDQ/eg
         33ghHuckxmapiMpNq3OOMoE9yYNuzHKhODnAeH3tkr3FLcrD2x5/J/qMsVwAggjOE023
         Xnyg==
X-Gm-Message-State: AOAM530Aqr3z8MwOnqFKEqq3p+GjGzlw+OdtuWqmfGN2wNnYFQeZmIBH
        5YxaMoVu0rW1K7z8Jj7vH3cB1/svN2AKlw==
X-Google-Smtp-Source: ABdhPJytF6/yUR/cbz+1f3oklEKkI3xn8X/E0Il7aTtmwaI71EOt+o0sLvhlGFeFUiHshjodP6vPIw==
X-Received: by 2002:a62:ce48:: with SMTP id y69mr29045902pfg.208.1593731220012;
        Thu, 02 Jul 2020 16:07:00 -0700 (PDT)
Received: from x1.mib2p ([204.156.180.104])
        by smtp.gmail.com with ESMTPSA id j36sm10024463pgj.39.2020.07.02.16.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 16:06:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: use new io_req_task_work_add() helper throughout
Date:   Thu,  2 Jul 2020 17:06:53 -0600
Message-Id: <20200702230653.1379419-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200702230653.1379419-1-axboe@kernel.dk>
References: <20200702230653.1379419-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since we now have that in the 5.9 branch, convert the existing users of
task_work_add() to use this new helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 62 +++++++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 32 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 982f49096580..51132f9bdbcc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1689,6 +1689,22 @@ static struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 	return __io_req_find_next(req);
 }
 
+static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb,
+				int notify)
+{
+	const bool is_sqthread = (req->ctx->flags & IORING_SETUP_SQPOLL) != 0;
+	struct task_struct *tsk = req->task;
+	int ret;
+
+	if (is_sqthread)
+		notify = 0;
+
+	ret = task_work_add(tsk, cb, notify);
+	if (!ret)
+		wake_up_process(tsk);
+	return ret;
+}
+
 static void __io_req_task_cancel(struct io_kiocb *req, int error)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1732,18 +1748,19 @@ static void io_req_task_submit(struct callback_head *cb)
 
 static void io_req_task_queue(struct io_kiocb *req)
 {
-	struct task_struct *tsk = req->task;
 	int ret;
 
 	init_task_work(&req->task_work, io_req_task_submit);
 
-	ret = task_work_add(tsk, &req->task_work, true);
+	ret = io_req_task_work_add(req, &req->task_work, TWA_RESUME);
 	if (unlikely(ret)) {
+		struct task_struct *tsk;
+
 		init_task_work(&req->task_work, io_req_task_cancel);
 		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, true);
+		task_work_add(tsk, &req->task_work, 0);
+		wake_up_process(tsk);
 	}
-	wake_up_process(tsk);
 }
 
 static void io_queue_next(struct io_kiocb *req)
@@ -2197,19 +2214,15 @@ static void io_rw_resubmit(struct callback_head *cb)
 static bool io_rw_reissue(struct io_kiocb *req, long res)
 {
 #ifdef CONFIG_BLOCK
-	struct task_struct *tsk;
 	int ret;
 
 	if ((res != -EAGAIN && res != -EOPNOTSUPP) || io_wq_current_is_worker())
 		return false;
 
-	tsk = req->task;
 	init_task_work(&req->task_work, io_rw_resubmit);
-	ret = task_work_add(tsk, &req->task_work, true);
-	if (!ret) {
-		wake_up_process(tsk);
+	ret = io_req_task_work_add(req, &req->task_work, TWA_RESUME);
+	if (!ret)
 		return true;
-	}
 #endif
 	return false;
 }
@@ -2909,7 +2922,6 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 	struct io_kiocb *req = wait->private;
 	struct io_async_rw *rw = &req->io->rw;
 	struct wait_page_key *key = arg;
-	struct task_struct *tsk;
 	int ret;
 
 	wpq = container_of(wait, struct wait_page_queue, wait);
@@ -2923,15 +2935,16 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 	init_task_work(&rw->task_work, io_async_buf_retry);
 	/* submit ref gets dropped, acquire a new one */
 	refcount_inc(&req->refs);
-	tsk = req->task;
-	ret = task_work_add(tsk, &rw->task_work, true);
+	ret = io_req_task_work_add(req, &rw->task_work, TWA_RESUME);
 	if (unlikely(ret)) {
+		struct task_struct *tsk;
+
 		/* queue just for cancelation */
 		init_task_work(&rw->task_work, io_async_buf_cancel);
 		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &rw->task_work, true);
+		task_work_add(tsk, &rw->task_work, 0);
+		wake_up_process(tsk);
 	}
-	wake_up_process(tsk);
 	return 1;
 }
 
@@ -4424,25 +4437,9 @@ struct io_poll_table {
 	int error;
 };
 
-static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb,
-				int notify)
-{
-	struct task_struct *tsk = req->task;
-	int ret;
-
-	if (req->ctx->flags & IORING_SETUP_SQPOLL)
-		notify = 0;
-
-	ret = task_work_add(tsk, cb, notify);
-	if (!ret)
-		wake_up_process(tsk);
-	return ret;
-}
-
 static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 			   __poll_t mask, task_work_func_t func)
 {
-	struct task_struct *tsk;
 	int ret;
 
 	/* for instances that support it check for an event match first: */
@@ -4453,7 +4450,6 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 
 	list_del_init(&poll->wait.entry);
 
-	tsk = req->task;
 	req->result = mask;
 	init_task_work(&req->task_work, func);
 	/*
@@ -4464,6 +4460,8 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	 */
 	ret = io_req_task_work_add(req, &req->task_work, TWA_SIGNAL);
 	if (unlikely(ret)) {
+		struct task_struct *tsk;
+
 		WRITE_ONCE(poll->canceled, true);
 		tsk = io_wq_get_task(req->ctx->io_wq);
 		task_work_add(tsk, &req->task_work, 0);
-- 
2.27.0

