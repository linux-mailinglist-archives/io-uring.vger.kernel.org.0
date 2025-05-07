Return-Path: <io-uring+bounces-7890-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4827DAAE833
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 19:51:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E1071B68FA8
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 17:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6284528DB43;
	Wed,  7 May 2025 17:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gFr5CwW1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC8F28C2B9
	for <io-uring@vger.kernel.org>; Wed,  7 May 2025 17:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746640284; cv=none; b=WapbfrDUf8V4FZ902U0Lx1hWHf50Ejxn08X5TEBpM0snz/GUO8oznJ7g4PdfrfgthFmITQywQam2PeFCrOay4TJMH94EjhDvNXvhdz6FqG8J7mRMnrCyHzrBMc4fA4liptPoTIN6D7MTwjmkjV3Ux7DuvRT6x8FAQ0dFWeaWN5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746640284; c=relaxed/simple;
	bh=Se3N3w9Ihx8YzyjZgG2am/XnYBiCebCqRcaoxwRkCz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LCKe7Zds1LfZbc/FXj7QQPZcdnTzG1lCHja33AaRZTP9dKPFjhokrZ/aPHcQHy5i9NyYs4MiHH5ewOq9/RguLSIUqRXGdvV+clm89/OcekLYum7GwRWAb9LLq57XYB1SgnuM9B4Y38bDHrtaa675sGyXHvXAtpPN/cenk82T3tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gFr5CwW1; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-861b1f04b99so4006539f.0
        for <io-uring@vger.kernel.org>; Wed, 07 May 2025 10:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746640277; x=1747245077; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c1Y/IUsJF0wFon3ryF5T3L6/jR6son6Hw7vzZyRqV1g=;
        b=gFr5CwW1axS71KAZm6otrr3vxC8RL89UWXakDxYKVeE5A/fg1tuZzAYa9YdE0miei7
         Yf3usThGsua3QeSi8nddOHIv4UbIueHg1ARY4UmlpI3FDKgq3B6SyhBNJqJqiwfRch0/
         25AdUHgfDzb5200eXzyGUjqSm6f1V933exnAP7LhePj1k+LiEfvOXmfX5r+/+DIVFMEb
         3rP2qe5cMsZK16LsTynye+vkXpI+B+QS1n5T14QRe8cND08Wyeh+2XiuBzcEmPRiFr0u
         DVrs+FnqRmC6oy7HiKSjUvJ5cvRsCaI5pU5p39QJ8ucQO1G3fJwCjfpC0vlzJ0RPT0GR
         jsdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746640277; x=1747245077;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c1Y/IUsJF0wFon3ryF5T3L6/jR6son6Hw7vzZyRqV1g=;
        b=Vtxty7mif0v9g9fzbcXWdN0PCVV8LcH5ugDHLROBqBwUduuayermj8r32iq/mMqFq+
         CVtnIu1tj2AXFgq72saEe75zW3Fn4nBTR2ESMI+uva6yCEMdwJv+GFlMHC6e97EQ839X
         r0uyU6MvknE55TOi2P6kKvFpSquXW6i0QNsNLVCTSEDISi1YsblfMHDF6evlSFQN4xkm
         eIalOBOY6HzmDEbhP5AZKsTdqOKGvSylsyuMztfG3AoamrQvoiEZWhvTtegMHryr5RO2
         p4lMvHxzSid3QwoQchJZ6GZpkRmXuMV33GveejF1djgIydri+qQ0q3rlgcf/mOiVuIFy
         SCzA==
X-Forwarded-Encrypted: i=1; AJvYcCU3CWOpNg04i7KT+M/1juqfncC9y9V6WL0R73AjdWM0rHu8KbRChG08VAjiVLmRvPlm/mS03pWoJw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzXUDsFCJ98vMi6Yw1d2Y+JczrD1i0M5fJsNQ44mcALfzDlQCa3
	yp1xDPfxIsmQPliEsnusp3jFdAej93ZYMRZcXsg1MxnGkQ/ux4EdnsdDHE10mgBKb0AWdGSBAkZ
	T
X-Gm-Gg: ASbGnctqXlhgsB+eZIA+7rtAq88EerpjyugyGAAm+/IMJCsSJLdBo6hZr2HnpQXaiAe
	uZKy16B1DbOtRYymeJm9fW7PccWmDP2amVAIrrtqXBlExPJYt4P7yVwAohTvK5SsAnAf6e5x/82
	Pnw6D1pzKkjhheNMAPsdGWZRJghfmZtlZIpTrMD0BT3PICXZqF2/06AOAWCkcol6AOxbXP2NUav
	d57OGZXDfrPVg8cslTRO2ZbxBcL2r5swPBxk9vxi2sSBSIhgAbQg9l0YyDATJ94mn+1iYEDVMhI
	+q7txQ/CAkvimHS8bMg6hx6hoobfb0PDsj4h
X-Google-Smtp-Source: AGHT+IGhtU2lA6HJLfl+/IXHkahIw9uf0JVp6BNjOX37v/L63A2/Mvf6LxBTFNyOm+gCBZAeELsGcg==
X-Received: by 2002:a05:6602:3f94:b0:85b:577b:37c9 with SMTP id ca18e2360f4ac-86755121be1mr61397739f.12.1746640277221;
        Wed, 07 May 2025 10:51:17 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88a91373asm2833701173.33.2025.05.07.10.51.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 10:51:16 -0700 (PDT)
Message-ID: <05a2682a-4e66-41eb-a978-ff94a7ab282a@kernel.dk>
Date: Wed, 7 May 2025 11:51:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: ensure deferred completions are flushed for
 multishot
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <a1dffa40-0c30-40d0-87b4-0a03698fd85f@kernel.dk>
 <c6260e33-ad29-4cd1-85c1-d0658c347a31@gmail.com>
 <a4ef2e70-e858-4a3a-9f7a-22bd3af2fefe@kernel.dk>
 <f6ac1b25-3185-4d3a-8e8e-d6d2771f2b3c@gmail.com>
 <611393de-4c50-4597-9290-82059e412a4b@kernel.dk>
 <f62f094c-346c-49d0-a80e-bc5fc0dcdc34@gmail.com>
 <654d7a07-5b5f-4f78-bef5-dda6a919c3e1@kernel.dk>
 <364679fa-8fc3-4bcb-8296-0877f39d6f2c@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <364679fa-8fc3-4bcb-8296-0877f39d6f2c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/7/25 10:18 AM, Pavel Begunkov wrote:
> On 5/7/25 16:49, Jens Axboe wrote:
>> On 5/7/25 9:46 AM, Pavel Begunkov wrote:
>>> On 5/7/25 16:26, Jens Axboe wrote:
>>>> On 5/7/25 9:11 AM, Pavel Begunkov wrote:
>>>>> On 5/7/25 15:58, Jens Axboe wrote:
>>>>>> On 5/7/25 8:36 AM, Pavel Begunkov wrote:
>>>>>>> On 5/7/25 14:56, Jens Axboe wrote:
>>>>>>>> Multishot normally uses io_req_post_cqe() to post completions, but when
>>>>>>>> stopping it, it may finish up with a deferred completion. This is fine,
>>>>>>>> except if another multishot event triggers before the deferred completions
>>>>>>>> get flushed. If this occurs, then CQEs may get reordered in the CQ ring,
>>>>>>>> as new multishot completions get posted before the deferred ones are
>>>>>>>> flushed. This can cause confusion on the application side, if strict
>>>>>>>> ordering is required for the use case.
>>>>>>>>
>>>>>>>> When multishot posting via io_req_post_cqe(), flush any pending deferred
>>>>>>>> completions first, if any.
>>>>>>>>
>>>>>>>> Cc: stable@vger.kernel.org # 6.1+
>>>>>>>> Reported-by: Norman Maurer <norman_maurer@apple.com>
>>>>>>>> Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>>
>>>>>>>> ---
>>>>>>>>
>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>> index 769814d71153..541e65a1eebf 100644
>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>>> @@ -848,6 +848,14 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
>>>>>>>>          struct io_ring_ctx *ctx = req->ctx;
>>>>>>>>          bool posted;
>>>>>>>>      +    /*
>>>>>>>> +     * If multishot has already posted deferred completions, ensure that
>>>>>>>> +     * those are flushed first before posting this one. If not, CQEs
>>>>>>>> +     * could get reordered.
>>>>>>>> +     */
>>>>>>>> +    if (!wq_list_empty(&ctx->submit_state.compl_reqs))
>>>>>>>> +        __io_submit_flush_completions(ctx);
>>>>>>>
>>>>>>> A request is already dead if it's in compl_reqs, there should be no
>>>>>>> way io_req_post_cqe() is called with it. Is it reordering of CQEs
>>>>>>> belonging to the same request? And what do you mean by "deferred"
>>>>>>> completions?
>>>>>>
>>>>>> It's not the same req, it's different requests using the same
>>>>>> provided buffer ring where it can be problematic.
>>>>>
>>>>> Ok, and there has never been any ordering guarantees between them.
>>>>> Is there any report describing the problem? Why it's ok if
>>>>> io_req_post_cqe() produced CQEs of two multishot requests get
>>>>> reordered, but it's not when one of them is finishing a request?
>>>>> What's the problem with provided buffers?
>>>>
>>>> There better be ordering between posting of the CQEs - I'm not talking
>>>> about issue ordering in general, but if you have R1 (request 1) and R2
>>>> each consuming from the same buffer ring, then completion posting of
>>>> those absolutely need to be ordered. If not, you can have:
>>>>
>>>> R1 peek X buffers, BID Y, BGID Z. Doesn't use io_req_post_cqe() because
>>>> it's stopping, end up posting via io_req_task_complete ->
>>>> io_req_complete_defer -> add to deferred list.
>>>>
>>>> Other task_work in that run has R2, grabbing buffers from BGID Z,
>>>> doesn't terminate, posts CQE2 via io_req_post_cqe().
>>>>
>>>> tw run done, deferred completions flushed, R1 posts CQE1.
>>>>
>>>> Then we have CQE2 ahead of CQE1 in the CQ ring.
>>>
>>> Which is why provided buffers from the beginning were returning
>>> buffer ids (i.e. bid, id within the group). Is it incremental
>>> consumption or some newer feature not being able to differentiate
>>> buffer chunks apart from ordering?
>>
>> Both incrementally consumed and bundles are susceptible to this
>> reordering.
>>
>>>>> It's a pretty bad spot to do such kinds of things, it disables any
>>>>> mixed mshot with non-mshot batching, and nesting flushing under
>>>>> an opcode handler is pretty nasty, it should rather stay top
>>>>> level as it is. From what I hear it's a provided buffer specific
>>>>> problem and should be fixed there.
>>>>
>>>> I agree it's not the prettiest, but I would prefer if we do it this way
>>>> just in terms of stable backporting. This should be a relatively rare
>>>
>>> Sure. Are you looking into fixing it in a different way for
>>> upstream? Because it's not the right level of abstraction.
>>
>> Yeah I think so - basically the common use case for stopping multishot
>> doesn't really work for this, as there are two methods of posting the
>> CQE. One is using io_req_post_cqe(), the other is a final deferred
>> completion. The mix and match of those two is what's causing this,
>> obviously.
> 
> That's the reason why all mshot stuff I've been adding is solely
> using io_req_post_cqe() for IO completions, and the final CQE only
> carries error / 0. Maybe it's not too late to switch read/recv to
> that model.
> 
> Or use io_req_post_cqe() for the final completion and silence
> the CQE coming from flush_completions() with REQ_F_SKIP_CQE?

Yeah we can do something like that. Something like the below should
work. Might be cleaner to simply add a new helper for this in
io_uring.c and leave the overflow handling private and in there.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 541e65a1eebf..796ecd4bea5c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -700,8 +700,8 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
 	}
 }
 
-static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
-				     s32 res, u32 cflags, u64 extra1, u64 extra2)
+bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data, s32 res,
+			      u32 cflags, u64 extra1, u64 extra2)
 {
 	struct io_overflow_cqe *ocqe;
 	size_t ocq_size = sizeof(struct io_overflow_cqe);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e4050b2d0821..dd0a89674095 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -82,6 +82,8 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
+bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data, s32 res,
+			      u32 cflags, u64 extra1, u64 extra2);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 8eb744eb9f4c..c002508015a4 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -312,6 +312,24 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 	return IOU_POLL_NO_ACTION;
 }
 
+static void io_poll_req_complete(struct io_kiocb *req, io_tw_token_t tw)
+{
+	bool filled;
+
+	filled = io_req_post_cqe(req, req->cqe.res, req->cqe.flags);
+	if (unlikely(!filled)) {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		spin_lock(&ctx->completion_lock);
+		filled = io_cqring_event_overflow(ctx, req->cqe.user_data,
+					req->cqe.res, req->cqe.flags, 0, 0);
+		spin_unlock(&ctx->completion_lock);
+	}
+	if (filled)
+		req->flags |= REQ_F_CQE_SKIP;
+	io_req_task_complete(req, tw);
+}
+
 void io_poll_task_func(struct io_kiocb *req, io_tw_token_t tw)
 {
 	int ret;
@@ -349,7 +367,7 @@ void io_poll_task_func(struct io_kiocb *req, io_tw_token_t tw)
 		io_tw_lock(req->ctx, tw);
 
 		if (ret == IOU_POLL_REMOVE_POLL_USE_RES)
-			io_req_task_complete(req, tw);
+			io_poll_req_complete(req, tw);
 		else if (ret == IOU_POLL_DONE || ret == IOU_POLL_REISSUE)
 			io_req_task_submit(req, tw);
 		else

-- 
Jens Axboe

