Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326216448E4
	for <lists+io-uring@lfdr.de>; Tue,  6 Dec 2022 17:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbiLFQLy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 11:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235502AbiLFQLU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 11:11:20 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC5B31352
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 08:06:04 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id z144so5702106iof.3
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 08:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZSBlvfLTMkAHBaqk987HRkAmiD4entsV8iYZWt+qbBs=;
        b=STrF/h+y4V+n9Y7tWO2c3K47t5DzuMaYnV80p8fOfgvcQqMCSBNFbUYHubzdx+9pCz
         0iXu9tg90arGI+cuRIGnsyymA2V1FqVo2KpXFaaWB0z3z1bGUiu8xBMsaIwIqSzqhkIV
         vo+4qmNYPsLCeUjuFF1pt5cci0x3Q5cdvfqAwotP2Qx2Jnuqj6+zu4jWrgqXjeuM+jUr
         H2dwoq74RJwRCXBIGIQqpEK0r4lO18WNfVZtnVto+FhTcUiUHko0/0g0LDxAnQfvIRGk
         hyWBorVhd6oBbswjPVn2loCkRYMJVnRvnJY7hEISsmLGDwKlIpGFFf5tbSLiSFdUSvYn
         YV0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSBlvfLTMkAHBaqk987HRkAmiD4entsV8iYZWt+qbBs=;
        b=nTQ52HL0b04nvMmKXIxczZ+l3N3Ktw1Ugguo122Ja6iQ8ut8TvybyqVLeECpTYKBG2
         KxbA7QUcK4i8wjqq8rZ7X1hgaFK2ESIXT9DnbYS3jf1UlWBc2Sl8HffKolAdn7J1sEUz
         4oSnjYix4f16sxWD3vyq1Br2kMZtm3r7+RlUxluUSSAyaZYZ3cHWSvaLiLnElxMVIxSu
         2vW6P1JQvm8IZbyWZs8E/nTZmIY8C1cS8uNSbyI9r3yZp0B/nGDCwY5FyjE16ajH7016
         0qm2seojvyihiLXokz7hYSzXypNlzW6SbRZlVHGRFODOnOdwLNg0Ki4wWPnyMnhiMqyC
         Z8qg==
X-Gm-Message-State: ANoB5pmwNwnpLhw1H7iJhi95W+pb9PPfrsS6zK/5jECIdNCoA0Bc60MB
        VFh5OKdF4Ef/4JOcZV4Va93dPQ==
X-Google-Smtp-Source: AA0mqf6c95AXviMnAKj14RoLl4RsMfAHJ4jd8a1To9RT4vN9OdDoqcYQ2Vrd0u68tBEmwKBIrOmxmA==
X-Received: by 2002:a05:6638:34e:b0:38a:590c:3b80 with SMTP id x14-20020a056638034e00b0038a590c3b80mr2397793jap.79.1670342763624;
        Tue, 06 Dec 2022 08:06:03 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b3-20020a92c843000000b00302fa942161sm6173833ilq.27.2022.12.06.08.06.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 08:06:03 -0800 (PST)
Message-ID: <4654437d-eb17-2832-ceae-6c45d6458006@kernel.dk>
Date:   Tue, 6 Dec 2022 09:06:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH for-next 5/7] io_uring: post msg_ring CQE in task context
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@meta.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <cover.1670207706.git.asml.silence@gmail.com>
 <bb0e9ee516e182802da798258f303bf22ecdc151.1670207706.git.asml.silence@gmail.com>
 <3b15e83e-52d6-d775-3561-5bec32cf1297@kernel.dk>
 <d64021e26df111c20c7e194627abf5c526636b73.camel@fb.com>
 <bc83f604-bdde-e86e-9d12-dfc6aa0a91af@kernel.dk>
 <03be41e8-fafd-2563-116c-71c52a27409f@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <03be41e8-fafd-2563-116c-71c52a27409f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/6/22 3:42?AM, Pavel Begunkov wrote:
> On 12/5/22 15:18, Jens Axboe wrote:
>> On 12/5/22 8:12?AM, Dylan Yudaken wrote:
>>> On Mon, 2022-12-05 at 04:53 -0700, Jens Axboe wrote:
>>>> On 12/4/22 7:44?PM, Pavel Begunkov wrote:
>>>>> We want to limit post_aux_cqe() to the task context when -
>>>>>> task_complete
>>>>> is set, and so we can't just deliver a IORING_OP_MSG_RING CQE to
>>>>> another
>>>>> thread. Instead of trying to invent a new delayed CQE posting
>>>>> mechanism
>>>>> push them into the overflow list.
>>>>
>>>> This is really the only one out of the series that I'm not a big fan
>>>> of.
>>>> If we always rely on overflow for msg_ring, then that basically
>>>> removes
>>>> it from being usable in a higher performance setting.
>>>>
>>>> The natural way to do this would be to post the cqe via task_work for
>>>> the target, ring, but we also don't any storage available for that.
>>>> Might still be better to alloc something ala
>>>>
>>>> struct tw_cqe_post {
>>>> ????????struct task_work work;
>>>> ????????s32 res;
>>>> ????????u32 flags;
>>>> ????????u64 user_data;
>>>> }
>>>>
>>>> and post it with that?
> 
> What does it change performance wise? I need to add a patch to
> "try to flush before overflowing", but apart from that it's one
> additional allocation in both cases but adds additional
> raw / not-batch task_work.

It adds alloc+free for each one, and overflow flush needed on the
recipient side. It also adds a cq lock/unlock, though I don't think that
part will be a big deal.

>>> It might work to post the whole request to the target, post the cqe,
>>> and then return the request back to the originating ring via tw for the
>>> msg_ring CQE and cleanup.
>>
>> I did consider that, but then you need to ref that request as well as
>> bounce it twice via task_work. Probably easier to just alloc at that
>> point? Though if you do that, then the target cqe would post later than
>> the original. And potentially lose -EOVERFLOW if the target ring is
>> overflown...
> 
> Double tw is interesting for future plans, but yeah, I don't think
> it's so much of a difference in context of this series.

I did a half assed patch for that... Below.


diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 36cb63e4174f..974eeaac313f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1254,10 +1254,10 @@ static void io_req_local_work_add(struct io_kiocb *req)
 	__io_cqring_wake(ctx);
 }
 
-void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
+void __io_req_task_work_add_ctx(struct io_ring_ctx *ctx, struct io_kiocb *req,
+				struct task_struct *task, bool allow_local)
 {
-	struct io_uring_task *tctx = req->task->io_uring;
-	struct io_ring_ctx *ctx = req->ctx;
+	struct io_uring_task *tctx = task->io_uring;
 
 	if (allow_local && ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
 		io_req_local_work_add(req);
@@ -1277,6 +1277,11 @@ void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
 	io_fallback_tw(tctx);
 }
 
+void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
+{
+	__io_req_task_work_add_ctx(req->ctx, req, req->task, allow_local);
+}
+
 static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 {
 	struct llist_node *node;
@@ -1865,7 +1870,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		return ret;
 
 	/* If the op doesn't have a file, we're not polling for it */
-	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && req->file)
+	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && !def->noiopoll && req->file)
 		io_iopoll_req_issued(req, issue_flags);
 
 	return 0;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index c20f15f5024d..3d24cba17504 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -51,6 +51,8 @@ static inline bool io_req_ffs_set(struct io_kiocb *req)
 }
 
 void __io_req_task_work_add(struct io_kiocb *req, bool allow_local);
+void __io_req_task_work_add_ctx(struct io_ring_ctx *ctx, struct io_kiocb *req,
+				struct task_struct *task, bool allow_local);
 bool io_is_uring_fops(struct file *file);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 7717fe519b07..fdc189b04d30 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -23,14 +23,41 @@ struct io_msg {
 	u32 flags;
 };
 
+static void io_msg_cqe_post(struct io_kiocb *req, bool *locked)
+{
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	struct io_ring_ctx *ctx = req->file->private_data;
+	unsigned issue_flags = 0;
+	int ret = 0;
+
+	if (!io_post_aux_cqe(ctx, msg->user_data, msg->len, msg->flags))
+		ret = -EOVERFLOW;
+
+	io_req_set_res(req, ret, 0);
+	if (!*locked)
+		issue_flags = IO_URING_F_UNLOCKED;
+	io_req_complete_post(req, issue_flags);
+}
+
+static int io_msg_post_remote(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	req->io_task_work.func = io_msg_cqe_post;
+	__io_req_task_work_add_ctx(ctx, req, ctx->submitter_task, true);
+	return IOU_ISSUE_SKIP_COMPLETE;
+}
+
 /* post cqes to another ring */
-static int io_msg_post_cqe(struct io_ring_ctx *ctx,
-			   u64 user_data, s32 res, u32 cflags)
+static int io_msg_post_cqe(struct io_ring_ctx *ctx, struct io_kiocb *req)
 {
-	if (!ctx->task_complete || current == ctx->submitter_task)
-		return io_post_aux_cqe(ctx, user_data, res, cflags);
-	else
-		return io_post_aux_cqe_overflow(ctx, user_data, res, cflags);
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+
+	if (!ctx->task_complete || current == ctx->submitter_task) {
+		if (io_post_aux_cqe(ctx, msg->user_data, msg->len, msg->flags))
+			return 0;
+		return -EOVERFLOW;
+	}
+
+	return io_msg_post_remote(ctx, req);
 }
 
 static int io_msg_ring_data(struct io_kiocb *req)
@@ -41,10 +68,7 @@ static int io_msg_ring_data(struct io_kiocb *req)
 	if (msg->src_fd || msg->dst_fd || msg->flags)
 		return -EINVAL;
 
-	if (io_msg_post_cqe(target_ctx, msg->user_data, msg->len, 0))
-		return 0;
-
-	return -EOVERFLOW;
+	return io_msg_post_cqe(target_ctx, req);
 }
 
 static void io_double_unlock_ctx(struct io_ring_ctx *ctx,
@@ -126,8 +150,7 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 	 * completes with -EOVERFLOW, then the sender must ensure that a
 	 * later IORING_OP_MSG_RING delivers the message.
 	 */
-	if (!io_msg_post_cqe(target_ctx, msg->user_data, msg->len, 0))
-		ret = -EOVERFLOW;
+	ret = io_msg_post_cqe(target_ctx, req);
 out_unlock:
 	io_double_unlock_ctx(ctx, target_ctx, issue_flags);
 	return ret;
@@ -173,13 +196,11 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 		break;
 	}
 
+	if (ret == IOU_ISSUE_SKIP_COMPLETE)
+		return IOU_ISSUE_SKIP_COMPLETE;
 done:
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	/* put file to avoid an attempt to IOPOLL the req */
-	if (!(req->flags & REQ_F_FIXED_FILE))
-		io_put_file(req->file);
-	req->file = NULL;
 	return IOU_OK;
 }
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 83dc0f9ad3b2..638df83895fb 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -436,6 +436,7 @@ const struct io_op_def io_op_defs[] = {
 	[IORING_OP_MSG_RING] = {
 		.needs_file		= 1,
 		.iopoll			= 1,
+		.noiopoll		= 1,
 		.name			= "MSG_RING",
 		.prep			= io_msg_ring_prep,
 		.issue			= io_msg_ring,
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 3efe06d25473..e378eb240538 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -25,6 +25,8 @@ struct io_op_def {
 	unsigned		ioprio : 1;
 	/* supports iopoll */
 	unsigned		iopoll : 1;
+	/* don't iopoll for this request */
+	unsigned		noiopoll : 1;
 	/* opcode specific path will handle ->async_data allocation if needed */
 	unsigned		manual_alloc : 1;
 	/* size of async data needed, if any */

-- 
Jens Axboe
