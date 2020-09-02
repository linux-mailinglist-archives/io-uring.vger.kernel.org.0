Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4412E25A2A5
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 03:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgIBBbL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Sep 2020 21:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgIBBbK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Sep 2020 21:31:10 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB87C061244
        for <io-uring@vger.kernel.org>; Tue,  1 Sep 2020 18:31:10 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q1so1540088pjd.1
        for <io-uring@vger.kernel.org>; Tue, 01 Sep 2020 18:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=y7RbGPARQjn6TirZ4f/2e9aykZ6xofiCnvXJX7Gy1/I=;
        b=Lwv95SCPcml0Ksj7QNFEjL1xZtdf9HCbzWGDXsowUQZFPErvCn1RitlBXlRaesUHBZ
         IaPtf901HzKW4Mpw3hJbta0gOIzUOteuup9M2Uz6YlHZwceVvpamfq676cE65MbgmRxh
         olBLE8E/uRYP+geE1rQY5tyjZYpp3//Bgn8LuZMZgBnrtEp+x2giBjX0RKbpMrsj4v5k
         Mvyg7hUm1mZW2kKKTYCUu1XWvjvRkfDIv/iirje9rA9Jz053MqIvDleYkBq/EwttcFzV
         oaQ6nEht3TSiUIHw3nkAmMxwSnVlPAU5V1Yygr5XRxqeXeM00cvRl2tksiJrA1kOry9g
         s3Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=y7RbGPARQjn6TirZ4f/2e9aykZ6xofiCnvXJX7Gy1/I=;
        b=tsCKupdU+KkyNzfsi///nN0kXXR1mBMHe+ERt3Oejj+mM9ho7xwpVD/2Y7mK+GcSwG
         jWI58zKKsmzHXbjc8xI/D0qt9sNobGY8wSMuoII7+EmJ5KZZH2eakO4Avo70+sCacOjB
         ry8jZ5M+zpJtq+j5KwQ8ZcsXA6kag6rPMfQ4ODdqzWZiOesjkFJNZte4wT0++wFlC6Vr
         XMJlmyGbWKVxdOUZvtlqLE22kM2Nrtzv5s+YMuhJ2xNzHb4cy9VhvhtM0168iGexJw/3
         8vT2pz8aP1z1VOTO6VdILFIQrLzxiwWHndHQdvI5x30v1dvL4dMsi9ySkv5UF6vqpeeq
         gD2g==
X-Gm-Message-State: AOAM532W8KpVtAk/a9mls2I0MNQa5HsLW9BtDm8NMxbmZd3zEKEhuwgC
        45QlqHx4ugXYp6G6F5DhkK9jcQ==
X-Google-Smtp-Source: ABdhPJwyCNXbd3mtkC8sWJIX5OGklcSgunX1KTZ3+GdFmFwhDcOpDQTa10S7EpPE6LnSh8DcncegPw==
X-Received: by 2002:a17:902:720a:: with SMTP id ba10mr3904519plb.41.1599010269410;
        Tue, 01 Sep 2020 18:31:09 -0700 (PDT)
Received: from [192.168.1.187] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c199sm1447412pfc.128.2020.09.01.18.31.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 18:31:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 for-next] io_uring: allow non-fixed files with SQPOLL
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Jann Horn <jannh@google.com>
Message-ID: <cf8bdc95-1718-60d6-beb3-2b8909106d2c@kernel.dk>
Date:   Tue, 1 Sep 2020 19:31:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The restriction of needing fixed files for SQPOLL is problematic, and
prevents/inhibits several valid uses cases.

There's no real good reason for us not to allow it, except we need to
have the sqpoll thread inherit current->files from the task that setup
the ring. We can't easily do that, since we'd introduce a circular
reference by holding on to our own file table.

If we wait for the sqpoll thread to exit when the ring fd is closed,
then we can safely reference the task files_struct without holding
a reference to it. And once we inherit that in the SQPOLL thread, we
can support non-fixed files for SQPOLL.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2: Ensure we exit SQPOLL thread on ring creation error

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7fcf83592046..d97601cacd7f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -279,6 +279,13 @@ struct io_ring_ctx {
 	struct mm_struct	*sqo_mm;
 	wait_queue_head_t	sqo_wait;
 
+	/*
+	 * For SQPOLL usage - no reference is held to this file table, we
+	 * rely on fops->flush() and our callback there waiting for the users
+	 * to finish.
+	 */
+	struct files_struct	*sqo_files;
+
 	/*
 	 * If used, fixed file set. Writers must ensure that ->refs is dead,
 	 * readers must ensure that ->refs is alive as long as the file* is
@@ -6045,13 +6052,7 @@ static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 			   int fd)
 {
-	bool fixed;
-
-	fixed = (req->flags & REQ_F_FIXED_FILE) != 0;
-	if (unlikely(!fixed && io_async_submit(req->ctx)))
-		return -EBADF;
-
-	return io_file_get(state, req, fd, &req->file, fixed);
+	return io_file_get(state, req, fd, &req->file, req->flags & REQ_F_FIXED_FILE);
 }
 
 static int io_grab_files(struct io_kiocb *req)
@@ -6621,6 +6622,10 @@ static int io_sq_thread(void *data)
 
 	old_cred = override_creds(ctx->creds);
 
+	task_lock(current);
+	current->files = ctx->sqo_files;
+	task_unlock(current);
+
 	timeout = jiffies + ctx->sq_thread_idle;
 	while (!kthread_should_park()) {
 		unsigned int to_submit;
@@ -6719,6 +6724,9 @@ static int io_sq_thread(void *data)
 	io_run_task_work();
 
 	io_sq_thread_drop_mm();
+	task_lock(current);
+	current->files = NULL;
+	task_unlock(current);
 	revert_creds(old_cred);
 
 	kthread_parkme();
@@ -7549,6 +7557,13 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		if (!capable(CAP_SYS_ADMIN))
 			goto err;
 
+		/*
+		 * We will exit the sqthread before current exits, so we can
+		 * avoid taking a reference here and introducing weird
+		 * circular dependencies on the files table.
+		 */
+		ctx->sqo_files = current->files;
+
 		ctx->sq_thread_idle = msecs_to_jiffies(p->sq_thread_idle);
 		if (!ctx->sq_thread_idle)
 			ctx->sq_thread_idle = HZ;
@@ -7586,6 +7601,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 
 	return 0;
 err:
+	ctx->sqo_files = NULL;
 	io_finish_async(ctx);
 	return ret;
 }
@@ -8239,8 +8255,10 @@ static int io_uring_flush(struct file *file, void *data)
 	/*
 	 * If the task is going away, cancel work it may have pending
 	 */
-	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
+		io_sq_thread_stop(ctx);
 		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, current, true);
+	}
 
 	return 0;
 }
@@ -8690,7 +8708,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
-			IORING_FEAT_POLL_32BITS;
+			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
@@ -8708,6 +8726,12 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
 	return ret;
 err:
+	/*
+	 * Our wait-and-kill does do this, but we need it done before we
+	 * exit as the SQPOLL thread could already be active and the current
+	 * files could be done as soon as we exit here.
+	 */
+	io_finish_async(ctx);
 	io_ring_ctx_wait_and_kill(ctx);
 	return ret;
 }
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 3e45de39e04b..02528ec8e81b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -255,6 +255,7 @@ struct io_uring_params {
 #define IORING_FEAT_CUR_PERSONALITY	(1U << 4)
 #define IORING_FEAT_FAST_POLL		(1U << 5)
 #define IORING_FEAT_POLL_32BITS 	(1U << 6)
+#define IORING_FEAT_SQPOLL_NONFIXED	(1U << 7)
 
 /*
  * io_uring_register(2) opcodes and arguments

-- 
Jens Axboe

