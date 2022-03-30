Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7624EC8DA
	for <lists+io-uring@lfdr.de>; Wed, 30 Mar 2022 17:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240354AbiC3Pyt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 11:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241800AbiC3Pyt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 11:54:49 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019B715A3C
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 08:53:03 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id r11so14814649ila.1
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 08:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=vMKekFGn2cmTTvTzuufjCjdetV2sihHhfIVNt7BJuFk=;
        b=h/VcayIrT2Dfr+Pn2kINtH4m8iNh4pkGjbHHWucw8jst89S3O2hnOwPt4aunXIK0DR
         TSM+aasR5ZU67rJPbDzdEfBRr9uiwWhb2FXUGxUvGLhkVfnORraKVdR8uM6N5teDYsau
         fxQT8gPJjkSgeNBh2MStFNQrplg9xf+1+PT3FVf0RXTdEcDC2He+o2E4HOzOSqiNjz8e
         Tpg1UpdnuA8A/YFHujLLQ30vZd5IRK3vUPmKfiYr2NGhxCak/JUZ7RtN4Zp8/xJehL6p
         w3G7eZ1tBNsbnfr2z16wNdtDKZ8v+PqxlTtV/kzJFidYGiu2EdH0yIBmctWwBnrfov2f
         Zp0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=vMKekFGn2cmTTvTzuufjCjdetV2sihHhfIVNt7BJuFk=;
        b=JhdR1DViRl0Op73YX8rnuZfeBxA/Hgwj3lIXpjsBJDDBsuVsCj/XhFbg/T0MpybQIC
         MJKWXIBB2JlO1fVWb8mMEDYpOTA3QPL0SJoowIyI4UZ4a17vem3CLoLj5F2uwberXgfq
         9rJdvQfodiAfnEQgxSQN1xNqVUNCvZ81BIkTFciX315WUnjheJ4jUeFdoroPR7NcEfAi
         zDu77/5pJnvS99UH3AM1tXfJa6qzBPqtbFti+hiBdSExeqQtwS6rMVKdDK5WGPVKCt2K
         AUKzUm3RbXRYIZdwPA9HXJ7gNoUhrchhB/+UDoV8NurM0hzVT6Sj3xrhChvNDgb0HXY6
         OTzw==
X-Gm-Message-State: AOAM531nhFi/MebaZgiw3XFhURR5VgNq8b38MuzRF5c6h/mHwTsj0y/p
        z3rBTcHbvqlwMfPvWY3lyNd6e275Ykbuh92j
X-Google-Smtp-Source: ABdhPJzGLLHn/MNnUIzhfiJ05bolRL+wZ2pcboB8v09G9VJBBU1N5nDdHZ02oLOWQVQUG5S1Mm8Afg==
X-Received: by 2002:a92:cbc3:0:b0:2c6:78fa:41e9 with SMTP id s3-20020a92cbc3000000b002c678fa41e9mr10913686ilq.112.1648655583256;
        Wed, 30 Mar 2022 08:53:03 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f9-20020a5ec709000000b00645ec64112asm11160441iop.42.2022.03.30.08.53.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 08:53:02 -0700 (PDT)
Message-ID: <61c2336f-0315-5f76-3022-18c80f79e0b5@kernel.dk>
Date:   Wed, 30 Mar 2022 09:53:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: io_uring_prep_openat_direct() and link/drain
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     io-uring@vger.kernel.org
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <CAJfpegs1o3HNkpxPa85LmNCoVVk-T2rt3vJXBvRf_M93P+6ouA@mail.gmail.com>
 <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk>
 <CAJfpegs=GcTuXcor-pbhaAxDKeS5XRy5rwTGXUcZM0BYYUK2LA@mail.gmail.com>
 <89322bd1-5e6f-bcc6-7974-ffd22363a165@kernel.dk>
 <CAJfpegtr+Bo0O=i9uShDJO_=--KAsFmvdzodwH6qF7f+ABeQ5g@mail.gmail.com>
 <0c5745ab-5d3d-52c1-6a1d-e5e33d4078b5@kernel.dk>
 <CAJfpegtob8ZWU1TDBoUf7SRMQJhEcEo2sPUumzpNd3Mcg+1aog@mail.gmail.com>
 <52dca413-61b3-8ded-c4cc-dd6c8e8de1ed@kernel.dk>
 <CAJfpegtEG2c3H8ZyOWPT69HJN2UWU1es-n9P+CSgV7jiZMPtGg@mail.gmail.com>
 <23b62cca-8ec5-f250-e5a3-7e9ed983e190@kernel.dk>
 <CAJfpeguZji8x+zXSADJ4m6VKbdmTb6ZQd5zA=HCt8acxvGSr3w@mail.gmail.com>
 <CAJfpegsADrdURSUOrGTjbu1DoRr7-8itGx23Tn0wf6gNdO5dWA@mail.gmail.com>
 <77229971-72cd-7d78-d790-3ef4789acc9e@kernel.dk>
 <CAJfpeguiZ7U=YQhgGa-oPWO07tpBL6sf3zM=xtAk66njb1p2cw@mail.gmail.com>
 <c5f27130-b4ad-3f4c-ce98-4414227db4fd@kernel.dk>
In-Reply-To: <c5f27130-b4ad-3f4c-ce98-4414227db4fd@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/30/22 9:17 AM, Jens Axboe wrote:
> On 3/30/22 9:12 AM, Miklos Szeredi wrote:
>> On Wed, 30 Mar 2022 at 17:05, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 3/30/22 8:58 AM, Miklos Szeredi wrote:
>>>> Next issue:  seems like file slot reuse is not working correctly.
>>>> Attached program compares reads using io_uring with plain reads of
>>>> proc files.
>>>>
>>>> In the below example it is using two slots alternately but the number
>>>> of slots does not seem to matter, read is apparently always using a
>>>> stale file (the prior one to the most recent open on that slot).  See
>>>> how the sizes of the files lag by two lines:
>>>>
>>>> root@kvm:~# ./procreads
>>>> procreads: /proc/1/stat: ok (313)
>>>> procreads: /proc/2/stat: ok (149)
>>>> procreads: /proc/3/stat: read size mismatch 313/150
>>>> procreads: /proc/4/stat: read size mismatch 149/154
>>>> procreads: /proc/5/stat: read size mismatch 150/161
>>>> procreads: /proc/6/stat: read size mismatch 154/171
>>>> ...
>>>>
>>>> Any ideas?
>>>
>>> Didn't look at your code yet, but with the current tree, this is the
>>> behavior when a fixed file is used:
>>>
>>> At prep time, if the slot is valid it is used. If it isn't valid,
>>> assignment is deferred until the request is issued.
>>>
>>> Which granted is a bit weird. It means that if you do:
>>>
>>> <open fileA into slot 1, slot 1 currently unused><read slot 1>
>>>
>>> the read will read from fileA. But for:
>>>
>>> <open fileB into slot 1, slot 1 is fileA currently><read slot 1>
>>>
>>> since slot 1 is already valid at prep time for the read, the read will
>>> be from fileA again.
>>>
>>> Is this what you are seeing? It's definitely a bit confusing, and the
>>> only reason why I didn't change it is because it could potentially break
>>> applications. Don't think there's a high risk of that, however, so may
>>> indeed be worth it to just bite the bullet and the assignment is
>>> consistent (eg always done from the perspective of the previous
>>> dependent request having completed).
>>>
>>> Is this what you are seeing?
>>
>> Right, this explains it.   Then the only workaround would be to wait
>> for the open to finish before submitting the read, but that would
>> defeat the whole point of using io_uring for this purpose.
> 
> Honestly, I think we should just change it during this round, making it
> consistent with the "slot is unused" use case. The old use case is more
> more of a "it happened to work" vs the newer consistent behavior of "we
> always assign the file when execution starts on the request".
> 
> Let me spin a patch, would be great if you could test.

Something like this on top of the current tree should work. Can you
test?

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4d4ca8e115f6..d36475cefb8c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -785,7 +785,6 @@ enum {
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
 	REQ_F_PARTIAL_IO_BIT,
-	REQ_F_DEFERRED_FILE_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -850,8 +849,6 @@ enum {
 	REQ_F_DOUBLE_POLL	= BIT(REQ_F_DOUBLE_POLL_BIT),
 	/* request has already done partial IO */
 	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
-	/* request has file assignment deferred */
-	REQ_F_DEFERRED_FILE	= BIT(REQ_F_DEFERRED_FILE_BIT),
 };
 
 struct async_poll {
@@ -918,7 +915,11 @@ struct io_kiocb {
 	unsigned int			flags;
 
 	u64				user_data;
-	u32				result;
+	/* fd before execution, if valid, result after execution */
+	union {
+		u32			result;
+		s32			fd;
+	};
 	u32				cflags;
 
 	struct io_ring_ctx		*ctx;
@@ -1767,20 +1768,6 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 	}
 }
 
-static void io_assign_file(struct io_kiocb *req)
-{
-	if (req->file || !io_op_defs[req->opcode].needs_file)
-		return;
-	if (req->flags & REQ_F_DEFERRED_FILE) {
-		req->flags &= ~REQ_F_DEFERRED_FILE;
-		req->file = io_file_get(req->ctx, req, req->result,
-					req->flags & REQ_F_FIXED_FILE);
-		req->result = 0;
-	}
-	if (unlikely(!req->file))
-		req_set_fail(req);
-}
-
 static __cold void io_queue_deferred(struct io_ring_ctx *ctx)
 {
 	while (!list_empty(&ctx->defer_list)) {
@@ -1790,7 +1777,6 @@ static __cold void io_queue_deferred(struct io_ring_ctx *ctx)
 		if (req_need_defer(de->req, de->seq))
 			break;
 		list_del_init(&de->list);
-		io_assign_file(de->req);
 		io_req_task_queue(de->req);
 		kfree(de);
 	}
@@ -2131,7 +2117,6 @@ static void __io_req_complete_post(struct io_kiocb *req, s32 res,
 			if (req->flags & IO_DISARM_MASK)
 				io_disarm_next(req);
 			if (req->link) {
-				io_assign_file(req->link);
 				io_req_task_queue(req->link);
 				req->link = NULL;
 			}
@@ -2443,11 +2428,7 @@ static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 		__io_req_find_next_prep(req);
 	nxt = req->link;
 	req->link = NULL;
-	if (nxt) {
-		io_assign_file(nxt);
-		return nxt;
-	}
-	return NULL;
+	return nxt;
 }
 
 static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
@@ -2650,10 +2631,6 @@ static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 
 static void io_req_task_queue(struct io_kiocb *req)
 {
-	if (unlikely(req->flags & REQ_F_FAIL)) {
-		io_req_task_queue_fail(req, -ECANCELED);
-		return;
-	}
 	req->io_task_work.func = io_req_task_submit;
 	io_req_task_work_add(req, false);
 }
@@ -2668,10 +2645,8 @@ static inline void io_queue_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt = io_req_find_next(req);
 
-	if (nxt) {
-		io_assign_file(req);
+	if (nxt)
 		io_req_task_queue(nxt);
-	}
 }
 
 static void io_free_req(struct io_kiocb *req)
@@ -4545,9 +4520,6 @@ static int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!req->file)
-		return -EBADF;
-
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
@@ -7150,7 +7122,6 @@ static __cold void io_drain_req(struct io_kiocb *req)
 		spin_unlock(&ctx->completion_lock);
 queue:
 		ctx->drain_active = false;
-		io_assign_file(req);
 		io_req_task_queue(req);
 		return;
 	}
@@ -7259,6 +7230,23 @@ static void io_clean_op(struct io_kiocb *req)
 	req->flags &= ~IO_REQ_CLEAN_FLAGS;
 }
 
+static bool io_assign_file(struct io_kiocb *req)
+{
+	if (req->file || !io_op_defs[req->opcode].needs_file)
+		return true;
+
+	req->file = io_file_get(req->ctx, req, req->fd,
+					req->flags & REQ_F_FIXED_FILE);
+	if (unlikely(!req->file)) {
+		req_set_fail(req);
+		req->result = -EBADF;
+		return false;
+	}
+
+	req->result = 0;
+	return true;
+}
+
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 {
 	const struct cred *creds = NULL;
@@ -7269,6 +7257,8 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (!io_op_defs[req->opcode].audit_skip)
 		audit_uring_entry(req->opcode);
+	if (unlikely(!io_assign_file(req)))
+		return -EBADF;
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
@@ -7429,8 +7419,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
-	io_assign_file(req);
-	if (unlikely(!req->file && def->needs_file)) {
+	if (!io_assign_file(req)) {
 		work->flags |= IO_WQ_WORK_CANCEL;
 		err = -EBADF;
 	}
@@ -7732,12 +7721,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	int personality;
 	u8 opcode;
 
+	req->file = NULL;
 	/* req is partially pre-initialised, see io_preinit_req() */
 	req->opcode = opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	req->flags = sqe_flags = READ_ONCE(sqe->flags);
 	req->user_data = READ_ONCE(sqe->user_data);
-	req->file = NULL;
 	req->fixed_rsrc_refs = NULL;
 	req->task = current;
 
@@ -7776,7 +7765,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	if (io_op_defs[opcode].needs_file) {
 		struct io_submit_state *state = &ctx->submit_state;
-		int fd = READ_ONCE(sqe->fd);
+
+		req->fd = READ_ONCE(sqe->fd);
 
 		/*
 		 * Plug now if we have more than 2 IO left after this, and the
@@ -7787,17 +7777,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			state->need_plug = false;
 			blk_start_plug_nr_ios(&state->plug, state->submit_nr);
 		}
-
-		req->file = io_file_get(ctx, req, fd,
-					(sqe_flags & IOSQE_FIXED_FILE));
-		if (unlikely(!req->file)) {
-			/* unless being deferred, error is final */
-			if (!(ctx->submit_state.link.head ||
-			     (sqe_flags & IOSQE_IO_DRAIN)))
-				return -EBADF;
-			req->result = fd;
-			req->flags |= REQ_F_DEFERRED_FILE;
-		}
 	}
 
 	personality = READ_ONCE(sqe->personality);

-- 
Jens Axboe

