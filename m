Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F6E6E7BF9
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 16:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbjDSOMt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 10:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbjDSOLy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 10:11:54 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8119C1A1
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 07:11:28 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-63b621b1dabso1490834b3a.0
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 07:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681913488; x=1684505488;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0xNOxuM/Q5bpnY5wu/Mk8v5XqLEF0yXr8Lavq8xCLBI=;
        b=dbYdMVNBZAXtFnxqi/+hd9ElkpDEHwRvEdfQXibeH2x2t5NK2N584hjAqe5g1inZ+5
         PEdDd56nnVP/T16X8KL0i13b1v3Psrs4+XzZCyAW97Fy5v2IlzCzW8btRW7Yy9dYBs/2
         Cj5KTUTlXsrVXOCIYzY+9DO/JNmLs1p1WLRL4vIwtDqSxSQYQ0pTucNd+L46PkXv4S/A
         Qs3JtMfipVNLfzewQW5rr7CmtPPOVj5Xc+9qOklDtlfiQ/JAGa5kreSsoW5WoH21Cnxd
         /efIGwHFVToHS0ARrA0WznHPMq2pOQZXazxoXPSjrjY4sXq1THhTL99G37mwYt1OvGIp
         5u/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681913488; x=1684505488;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0xNOxuM/Q5bpnY5wu/Mk8v5XqLEF0yXr8Lavq8xCLBI=;
        b=E7ZriiHlgr1p+FiXr8zA6uiXNonT1tXVHRpx1P7VPKrKsWm9Z3fyu7YPselemoCoS+
         muHCETCseIBqTfYR/5vC+kJlqwP1dWOPwTMhhG7n0Xm24ABIO/xTt2LvzJ1I1+VLXVXt
         bD5hRsxV6yaphUgqsoMRGPdBkgcEM5JTmE9dCekpD0oXWsflVqDEK2iUC7tlRnYGIktC
         GvTZ+1zR0/KEQPISPXpB1+83Sxrszw2JG0TELiod68dfEQTaKWMCOJ8F22w+jEYP1YO4
         nwhJA2xGd/WJX1sM+xO3iOLAiBD0mT1QqYD7JmPwplhSOGtWgM89YRlZWGCFG4PHe+s4
         DZ3A==
X-Gm-Message-State: AAQBX9daNWikFG7K6X8IGIuQWcK7HwgDRpRhSXGsUHfXlU/3XXtpYAJk
        9XsMlyppMMiUk76d2PfBkOEoLuqJH+KerjMisXI=
X-Google-Smtp-Source: AKy350bEvRYzEBCnOpnJFKmtTKDS+DUs3P7riBFSdQnQqbeIteclnAxTTIXg8E6O1obcsqPoO3aOOA==
X-Received: by 2002:a05:6a00:4147:b0:63a:2829:7e33 with SMTP id bv7-20020a056a00414700b0063a28297e33mr20249457pfb.0.1681913487778;
        Wed, 19 Apr 2023 07:11:27 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a29-20020a62d41d000000b0062db34242aesm1027514pfh.167.2023.04.19.07.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 07:11:27 -0700 (PDT)
Message-ID: <4aa0bade-0234-9cee-4eb9-5dc86c3e7240@kernel.dk>
Date:   Wed, 19 Apr 2023 08:11:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] io_uring: Optimization of buffered random write
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     luhongfei <luhongfei@vivo.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "open list:IO_URING" <io-uring@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     opensource.kernel@vivo.com
References: <20230419092233.56338-1-luhongfei@vivo.com>
 <30cf5639-ff99-9e73-42cd-21955088c283@kernel.dk>
In-Reply-To: <30cf5639-ff99-9e73-42cd-21955088c283@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/23 7:32?AM, Jens Axboe wrote:
> On 4/19/23 3:22?AM, luhongfei wrote:
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 4a865f0e85d0..64bb91beb4d6
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -2075,8 +2075,23 @@ static inline void io_queue_sqe(struct io_kiocb *req)
>>  	__must_hold(&req->ctx->uring_lock)
>>  {
>>  	int ret;
>> +	bool is_write;
>>  
>> -	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
>> +	switch (req->opcode) {
>> +	case IORING_OP_WRITEV:
>> +	case IORING_OP_WRITE_FIXED:
>> +	case IORING_OP_WRITE:
>> +		is_write = true;
>> +		break;
>> +	default:
>> +		is_write = false;
>> +		break;
>> +	}
>> +
>> +	if (!is_write || (req->rw.kiocb.ki_flags & IOCB_DIRECT))
>> +		ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
>> +	else
>> +		ret = io_issue_sqe(req, 0);
>>  
>>  	/*
>>  	 * We async punt it if the file wasn't marked NOWAIT, or if the file
> 
> We really can't just do that, implicitly. What you are doing is making
> any of write synchronous. What are you writing to in terms of device or
> file? If file, what file system is being used? Curious if the target
> supports async buffered writes, guessing it does not which is why you
> see io-wq activity for all of them.
> 
> That said, I did toss out a test patch a while back that explicitly sets
> up the ring such that we'll do blocking IO rather than do a non-blocking
> attempt and then punt it if that fails. And I do think there's a use
> case for that, in case you just want to use io_uring for batched
> syscalls and don't care about if you end up blocking for some IO.
> 
> Let's do a primer on what happens for io_uring issue:
> 
> 1) Non-blocking issue is attempted for IO. If successful, we're done for
>    now.
> 
> 2) Case 1 failed. Now we have two options
> 	a) We can poll the file. We arm poll, and we're done for now
> 	   until that triggers.
> 	b) File cannot be polled, we punt to io-wq which then does a
> 	   blocking attempt.
> 
> For case 2b, this is the one where we could've just done a blocking
> attempt initially if the ring was setup with a flag explicitly saying
> that's what the application wants. Or io_uring_enter() had a flag passed
> in that explicitly said this is what the applications wants. I suspect
> we'll want both, to cover both SQPOLL and !SQPOLL.
> 
> I'd recommend we still retain non-blocking issue for pollable files, as
> you could very quickly block forever otherwise. Imagine an empty pipe
> and a read issued to it in the blocking mode.
> 
> A solution like that would cater to your case too, without potentially
> breaking a lot of things like your patch could. The key here is the
> explicit nature of it, we cannot just go and make odd assumptions about
> a particular opcode type (writes) and ring type (SQPOLL) and say "oh
> this one is fine for just ignoring blocking off the issue path".

Something like this, totally untested. You can either setup the ring
with IORING_SETUP_NO_OFFLOAD, or you can pass in IORING_ENTER_NO_OFFLOAD
to achieve the same thing but on a per-invocation of io_uring_enter(2)
basis.

I suspect this would be cleaner with an io_kiocb flag for this, so we
can make the retry paths correct as well and avoid passing 'no_offload'
too much around. I'll probably clean it up with that and actually try
and test it.

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 0716cb17e436..ea903a677ce9 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -173,6 +173,12 @@ enum {
  */
 #define IORING_SETUP_DEFER_TASKRUN	(1U << 13)
 
+/*
+ * Don't attempt non-blocking issue on file types that would otherwise
+ * punt to io-wq if they cannot be completed non-blocking.
+ */
+#define IORING_SETUP_NO_OFFLOAD		(1U << 14)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
@@ -443,6 +449,7 @@ struct io_cqring_offsets {
 #define IORING_ENTER_SQ_WAIT		(1U << 2)
 #define IORING_ENTER_EXT_ARG		(1U << 3)
 #define IORING_ENTER_REGISTERED_RING	(1U << 4)
+#define IORING_ENTER_NO_OFFLOAD		(1U << 5)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3bca7a79efda..431e41701991 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -147,7 +147,7 @@ static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 
 static void io_dismantle_req(struct io_kiocb *req);
 static void io_clean_op(struct io_kiocb *req);
-static void io_queue_sqe(struct io_kiocb *req);
+static void io_queue_sqe(struct io_kiocb *req, bool no_offload);
 static void io_move_task_work_from_local(struct io_ring_ctx *ctx);
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx);
 static __cold void io_fallback_tw(struct io_uring_task *tctx);
@@ -1471,7 +1471,7 @@ void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts)
 	else if (req->flags & REQ_F_FORCE_ASYNC)
 		io_queue_iowq(req, ts);
 	else
-		io_queue_sqe(req);
+		io_queue_sqe(req, false);
 }
 
 void io_req_task_queue_fail(struct io_kiocb *req, int ret)
@@ -1938,7 +1938,8 @@ static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
 	return !!req->file;
 }
 
-static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
+static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags,
+			bool no_offload)
 {
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	const struct cred *creds = NULL;
@@ -1947,6 +1948,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!io_assign_file(req, def, issue_flags)))
 		return -EBADF;
 
+	if (no_offload && (!req->file || !file_can_poll(req->file)))
+		issue_flags &= ~IO_URING_F_NONBLOCK;
+
 	if (unlikely((req->flags & REQ_F_CREDS) && req->creds != current_cred()))
 		creds = override_creds(req->creds);
 
@@ -1980,7 +1984,7 @@ int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	io_tw_lock(req->ctx, ts);
 	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_MULTISHOT|
-				 IO_URING_F_COMPLETE_DEFER);
+				 IO_URING_F_COMPLETE_DEFER, false);
 }
 
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
@@ -2029,7 +2033,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 	}
 
 	do {
-		ret = io_issue_sqe(req, issue_flags);
+		ret = io_issue_sqe(req, issue_flags, false);
 		if (ret != -EAGAIN)
 			break;
 		/*
@@ -2120,12 +2124,13 @@ static void io_queue_async(struct io_kiocb *req, int ret)
 		io_queue_linked_timeout(linked_timeout);
 }
 
-static inline void io_queue_sqe(struct io_kiocb *req)
+static inline void io_queue_sqe(struct io_kiocb *req, bool no_offload)
 	__must_hold(&req->ctx->uring_lock)
 {
 	int ret;
 
-	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
+	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER,
+				no_offload);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
@@ -2337,7 +2342,7 @@ static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
 }
 
 static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
-			 const struct io_uring_sqe *sqe)
+			 const struct io_uring_sqe *sqe, bool no_offload)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_link *link = &ctx->submit_state.link;
@@ -2385,7 +2390,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		return 0;
 	}
 
-	io_queue_sqe(req);
+	io_queue_sqe(req, no_offload);
 	return 0;
 }
 
@@ -2466,7 +2471,7 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 	return false;
 }
 
-int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
+int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr, bool no_offload)
 	__must_hold(&ctx->uring_lock)
 {
 	unsigned int entries = io_sqring_entries(ctx);
@@ -2495,7 +2500,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		 * Continue submitting even for sqe failure if the
 		 * ring was setup with IORING_SETUP_SUBMIT_ALL
 		 */
-		if (unlikely(io_submit_sqe(ctx, req, sqe)) &&
+		if (unlikely(io_submit_sqe(ctx, req, sqe, no_offload)) &&
 		    !(ctx->flags & IORING_SETUP_SUBMIT_ALL)) {
 			left--;
 			break;
@@ -3524,7 +3529,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 
 	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
 			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
-			       IORING_ENTER_REGISTERED_RING)))
+			       IORING_ENTER_REGISTERED_RING |
+			       IORING_ENTER_NO_OFFLOAD)))
 		return -EINVAL;
 
 	/*
@@ -3575,12 +3581,17 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 
 		ret = to_submit;
 	} else if (to_submit) {
+		bool no_offload;
+
 		ret = io_uring_add_tctx_node(ctx);
 		if (unlikely(ret))
 			goto out;
 
+		no_offload = flags & IORING_ENTER_NO_OFFLOAD ||
+				ctx->flags & IORING_SETUP_NO_OFFLOAD;
+
 		mutex_lock(&ctx->uring_lock);
-		ret = io_submit_sqes(ctx, to_submit);
+		ret = io_submit_sqes(ctx, to_submit, no_offload);
 		if (ret != to_submit) {
 			mutex_unlock(&ctx->uring_lock);
 			goto out;
@@ -3969,7 +3980,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
 			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
-			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN))
+			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
+			IORING_SETUP_NO_OFFLOAD))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 25515d69d205..c5c0db7232c0 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -76,7 +76,7 @@ int io_uring_alloc_task_context(struct task_struct *task,
 				struct io_ring_ctx *ctx);
 
 int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts);
-int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr);
+int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr, bool no_offload);
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin);
 void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node);
 int io_req_prep_async(struct io_kiocb *req);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 9db4bc1f521a..9a9417bf9e3f 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -166,6 +166,7 @@ static inline bool io_sqd_events_pending(struct io_sq_data *sqd)
 
 static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 {
+	bool no_offload = ctx->flags & IORING_SETUP_NO_OFFLOAD;
 	unsigned int to_submit;
 	int ret = 0;
 
@@ -190,7 +191,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		 */
 		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)) &&
 		    !(ctx->flags & IORING_SETUP_R_DISABLED))
-			ret = io_submit_sqes(ctx, to_submit);
+			ret = io_submit_sqes(ctx, to_submit, no_offload);
 		mutex_unlock(&ctx->uring_lock);
 
 		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))

-- 
Jens Axboe

