Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F244525A28E
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 03:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIBBJS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Sep 2020 21:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgIBBJR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Sep 2020 21:09:17 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84404C061244
        for <io-uring@vger.kernel.org>; Tue,  1 Sep 2020 18:09:17 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b124so1873003pfg.13
        for <io-uring@vger.kernel.org>; Tue, 01 Sep 2020 18:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MLNPIsz4cIO7RiuVCK+zVZhZQaDgIV9rfQM/QNTIVRY=;
        b=vxY53cY6icbF0VJTChpmcdpFcfidHgzL+uuPY4DSgzkvxNW2xQpPESsuj69MDcIWH5
         aWHvGcbPabbxQ/3ncBIQkfsK8ljxxTZc4aH5HMaIKepx5KVh0OXo2D0XOLiYq1Af56U/
         8CHNAvnvF7EZQHcjZp5zW+bI3r2hJe+Q4VzJjZts/pWMKwMtM9TzRQv6J8XrpZH6p+fy
         BTKJdNks52BusOl4965V3xfqY9iMg85JPgK1wLIGzN7qkoenNxC8AX+LSS41Z+4XXbbj
         y5u/QWbzAAFA4GrEO1ukWG+qXUWbdiWHioiBAob4DVJsHn8MzH65OpGoFcFa/iMhPxSy
         Sgiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MLNPIsz4cIO7RiuVCK+zVZhZQaDgIV9rfQM/QNTIVRY=;
        b=h782SEJkCgwvrclXnrtfuyIjLo3xYrKQKfobbiRFh9KuKdzhtq7FY2TrZTCxcsZ3pz
         WQGqi5WhX24ZmscDhMw9We45KPu/seUPdvhOrwuPh6laEsWG/aBBLwpqMxDNRr3dV5Ya
         2GAmhxEvkf5L129nBT0cxTSxb5J72EWyhn6UOZgJGpIaZp+bcu4hmTqjdT/CDhkwTEwT
         SC8rpu2A0W6/IikP2/MOVV4y3YiK9pzuZbnXgcbDfn+mRevfPEF9dqFpctBeUjYiFz1H
         uNg3F53nvL67SbOqcklx6oLahKAO/RgRsYVSEFtkSeP3Z2OySxbls7A4pKSk65RtLnw2
         +8gQ==
X-Gm-Message-State: AOAM532BxDs9PuMKGPR71aZfU8BgjPJQEZQfypZiixEkcJZFdRNwnOTE
        CznBsd3TQfh+kE3MxLZ9yeK+7XwgpyoXAajy
X-Google-Smtp-Source: ABdhPJzqI68acBqQG8vF8V8UpR0mq/vsjIQuRcS04PGjcqCL5PelB49aZY7Y9K15leCEsmULIBmJuQ==
X-Received: by 2002:a62:486:: with SMTP id 128mr864517pfe.163.1599008956312;
        Tue, 01 Sep 2020 18:09:16 -0700 (PDT)
Received: from [192.168.1.187] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b64sm3221929pfa.200.2020.09.01.18.09.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 18:09:15 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: allow non-fixed files with SQPOLL
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <f56e97d5-b47c-1310-863a-50664056e5a7@kernel.dk>
 <CAG48ez12XsTUtxrebDzGQD5bYwss3hUguTHtfE-L3XstGPuTCw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cd15e379-36bb-d1fa-74d6-da1a953d0146@kernel.dk>
Date:   Tue, 1 Sep 2020 19:09:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez12XsTUtxrebDzGQD5bYwss3hUguTHtfE-L3XstGPuTCw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/1/20 6:15 PM, Jann Horn wrote:
> On Wed, Sep 2, 2020 at 1:11 AM Jens Axboe <axboe@kernel.dk> wrote:
>> The restriction of needing fixed files for SQPOLL is problematic, and
>> prevents/inhibits several valid uses cases.
>>
>> There's no real good reason for us not to allow it, except we need to
>> have the sqpoll thread inherit current->files from the task that setup
>> the ring. We can't easily do that, since we'd introduce a circular
>> reference by holding on to our own file table.
>>
>> If we wait for the sqpoll thread to exit when the ring fd is closed,
>> then we can safely reference the task files_struct without holding
>> a reference to it. And once we inherit that in the SQPOLL thread, we
>> can support non-fixed files for SQPOLL.
> [...]
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
> [...]
>> +       /*
>> +        * For SQPOLL usage - no reference is held to this file table, we
>> +        * rely on fops->flush() and our callback there waiting for the users
>> +        * to finish.
>> +        */
>> +       struct files_struct     *sqo_files;
> [...]
>> @@ -6621,6 +6622,10 @@ static int io_sq_thread(void *data)
>>
>>         old_cred = override_creds(ctx->creds);
>>
>> +       task_lock(current);
>> +       current->files = ctx->sqo_files;
>> +       task_unlock(current);
> [...]
>> @@ -7549,6 +7557,13 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
>>                 if (!capable(CAP_SYS_ADMIN))
>>                         goto err;
>>
>> +               /*
>> +                * We will exit the sqthread before current exits, so we can
>> +                * avoid taking a reference here and introducing weird
>> +                * circular dependencies on the files table.
>> +                */
>> +               ctx->sqo_files = current->files;
> [...]
>> @@ -8239,8 +8254,10 @@ static int io_uring_flush(struct file *file, void *data)
>>         /*
>>          * If the task is going away, cancel work it may have pending
>>          */
>> -       if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
>> +       if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
>> +               io_sq_thread_stop(ctx);
>>                 io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, current, true);
>> +       }
> 
> What happens when the uring setup syscall fails around
> io_uring_get_fd() (after the sq offload thread was started, but before
> an fd was installed)? Will that also properly wait for the sq_thread
> to go away before returning from the syscall (at which point the
> files_struct could disappear)?

Thanks for taking a look, Jann - I actually meant to CC you on this one
explicitly, but forgot.

Good question, we do need to handle the error case there and wait for
the thread to exit to avoid a potential use-after-free on the file
structure of the current->files. This one-liner addition (and comment)
should ensure we do just that.


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

