Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0641E25A1D0
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 01:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIAXKs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Sep 2020 19:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgIAXKs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Sep 2020 19:10:48 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027A1C061244
        for <io-uring@vger.kernel.org>; Tue,  1 Sep 2020 16:10:48 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 31so1511289pgy.13
        for <io-uring@vger.kernel.org>; Tue, 01 Sep 2020 16:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=nKaDFiAxU7RaYDV2wQm6sT6F+T1lXqOzT+1BowGGCSg=;
        b=EMeLKLlbc1mqzDYHUt/Sh1q29dwIH2AO1YVcXHI5NmlxpsIt9nZuuQILMV5g36EtV1
         POY/Vv19gasAEAOIovJ3iDuEVhZswMjRzvj/AGUQlZv7ccxIwVRXjaaDNWvIxsjeK/p+
         NM3hPYLaz9J0W6cYHC82OMEGUmmeerP7fOb1D6O2LDUegSWXqwHV0jKtrenPD2M6ZA37
         VlHqDYK0GgJ6rCpZxDUTbiXzTgAiB/6xQkaVNdsOZBtl2vKwUKK52DAjR1+AUqynlMMC
         XG+p/o03t08F6LuaZdvRCeYGc0kJJNRxNifMFUW5JLH9xCG9kYnjvR/qJKQ4Kbv5Peev
         FqfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=nKaDFiAxU7RaYDV2wQm6sT6F+T1lXqOzT+1BowGGCSg=;
        b=UZDA+x6FkYr6z/ktmSHNvwFWlMW/P+Afs3P6pACRIjqyVpu0eN5ago+SaaDYlmaAou
         onrrVJmMqWY/SQbY+TWUg6hJkAeYnnJ2Ej2C1rbUDvH5DEaWoptV4uvv1sQDIAVDnTnP
         2OHpp7rmSvpg2KaalZEgXVhFEr3N/2NFMztrRRo8jPGv7/MMyhM3JxYOIVky2wY5jw8Q
         0EGXCcIdlvwrqz2b1hexmza3LrbKweP/4wp7HKOBJiEzFJXBUq+ADcZqh8XzXxJ9xEu+
         0hikWiEukWcwUsYzeBhfHEEfsg6Z/iywSp1TwEsGvcSIPR/6LE8yiTS2lQ35XvpsE37a
         b5Mw==
X-Gm-Message-State: AOAM530FHjwdkeOFlzXwQ7ITETZ7leCZhO6WNib/GOaliUInUjeWFB8y
        0xIQHnKhyAPtKN4od/YuFzXG3HxNx/x2LNJ2
X-Google-Smtp-Source: ABdhPJxYOSvAqiNGXkw+A57ZuNIztYalhtSI9r6hipo0sjDmy88daSggisVqq0M64tblmOnvio0vng==
X-Received: by 2002:aa7:8285:: with SMTP id s5mr486778pfm.226.1599001846958;
        Tue, 01 Sep 2020 16:10:46 -0700 (PDT)
Received: from [192.168.1.187] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q5sm3131593pgi.31.2020.09.01.16.10.45
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 16:10:46 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring: allow non-fixed files with SQPOLL
Message-ID: <f56e97d5-b47c-1310-863a-50664056e5a7@kernel.dk>
Date:   Tue, 1 Sep 2020 17:10:45 -0600
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

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7fcf83592046..1ac8e8bb7657 100644
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
@@ -8239,8 +8254,10 @@ static int io_uring_flush(struct file *file, void *data)
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
@@ -8690,7 +8707,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
-			IORING_FEAT_POLL_32BITS;
+			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
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

