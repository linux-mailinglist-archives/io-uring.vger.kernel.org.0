Return-Path: <io-uring+bounces-2568-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB16993B1D3
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 15:42:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A00F3283CCB
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 13:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7BDB158DBF;
	Wed, 24 Jul 2024 13:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eiToFcyJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1784158DBE;
	Wed, 24 Jul 2024 13:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721828478; cv=none; b=YXebd2s8avDlxYq1zz33RvbZuqulN/EmTa28kzZZw9+0cZ1mPGlHtVHfVOUHYIvKX4X9tSBhLI1558+vsScj2tqkn5/s16VDBkcqsGXg0CQx98W2smdjskElyf1vVLzYW+F2ZXLJkGC/OVjqQFRHrmTAgD7tug3wdlO8sZ+Vqzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721828478; c=relaxed/simple;
	bh=kgLznTgZlYFb5cpu4Iprpk7gS/LL+x/uUQ8+bHF6MtU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WIOSvmDwmhf2WjdoaBgM7QtJD2VPYbFuxqsO8p3DEHW+85xya16f3KHVVMCKH7pU01k20n33KQY62B/PUMnaexJ/K3Lb4rKmYh5WRVRjFARcpYYPrJtqnW3DTViOC5ZDsl/HG8kXPkEp0wj//CMaGQ90bOQFLHq63PtFn00VcSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eiToFcyJ; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52f01ec08d6so4923258e87.2;
        Wed, 24 Jul 2024 06:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721828475; x=1722433275; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZkmAdyzqT3ul8KL6W6VLgu8jevujRiadYN9T2ZdJXtI=;
        b=eiToFcyJC2PAxNiK+dsdrwrrYKZKvMC41nTPhS37s7/aDi/oObak34Cj7jf+YmqDEb
         l37hBzs+jASRcbw88wsCqO4Leejy4h+KM0UA3YG4e3ODVwrJs12ziLufzrUiBXwydWEK
         yk/130BRfE2tpG6zDY62nHE4FPj50BV9kY3McIlPQZTU72UVN0TfS0eQccmFzatkFkGW
         TovMg0XdK/5M8SYztVkaLLQdakiB/Pz9m2MHt9TjwINuwOCVuuld9z1OV8jWwjrwAfbF
         hLCrXk7GsrtCdKzi17pbEre7VUULY++11qLkfFB9DyDzY09LOwaD+jNGIeYS1RQsQOnv
         A27w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721828475; x=1722433275;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZkmAdyzqT3ul8KL6W6VLgu8jevujRiadYN9T2ZdJXtI=;
        b=RBkYR4A47CXd6+F+2qo5Pun26RbOsHRHWtUezK0JQAWpmzyGiazs0SqMbeopLtjICw
         qBhNWZlIzEwv2an8UqutpnXGjGgZMuD5tEYW4rPvV+5/eqIyPhzCmWE2mUq09X/QSxz6
         pER5wPDBjGV/cH5902ZGVaeZ/BncT1sqAthkfySLZKu2vKZUvEJRwkZ8LaxVx4Y2aVI5
         QyfmjImAUNYEtwyVlVxoSAcByW1oXMZtCPTi75GjNF+ickjeu6XM/sGUyPnZDUkSdiGo
         E+FjQch/9glc7Be9qM3MldtOxcFGwXj1mEo0VekAX8yycln/4Nz4jZVMIDmyc1vG7ati
         Hwxg==
X-Forwarded-Encrypted: i=1; AJvYcCURa+rUXmMumehQXI4HTkbfXB44CrJOejRgQYKwS347Ua6GPivUCkjvOidtf+qb0E8u//ulwmi4NRST44WLjopdGB+NYs0zYIwSo6nMy0tfrSZliJoSHhStG5m1qOwRTVo62adAiA==
X-Gm-Message-State: AOJu0Yzi28xJA5UKbhQLbcEV/ERQS6iplTBDUZsemr1hFDZbO5fegyE2
	xdiDrGMqogevP6MEV3l+kptGRirnAetvK0rHoTQCaUKheTtzC1lR
X-Google-Smtp-Source: AGHT+IGNGbT4d3ABLWotXwXdFyhyhZ7jaaBnEDdbR/oy8tyz5ht1YcmE+ghLgqCR82VY6dhcD5/kfA==
X-Received: by 2002:a05:6512:3c87:b0:52f:441:bdd9 with SMTP id 2adb3069b0e04-52fc404d1e9mr4312088e87.34.1721828474350;
        Wed, 24 Jul 2024 06:41:14 -0700 (PDT)
Received: from [192.168.42.176] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7a98b6496fsm175172866b.113.2024.07.24.06.41.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jul 2024 06:41:14 -0700 (PDT)
Message-ID: <0fa0c9b9-cfb9-4710-85d0-2f6b4398603c@gmail.com>
Date: Wed, 24 Jul 2024 14:41:38 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 4/8] io_uring: support SQE group
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
References: <20240706031000.310430-1-ming.lei@redhat.com>
 <20240706031000.310430-5-ming.lei@redhat.com>
 <fa5e8098-f72f-43c1-90c1-c3eaebfea3d5@gmail.com> <Zp+/hBwCBmKSGy5K@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zp+/hBwCBmKSGy5K@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/24 15:34, Ming Lei wrote:
> Hi Pavel,
> 
> Thanks for the review!
> 
> On Mon, Jul 22, 2024 at 04:33:05PM +0100, Pavel Begunkov wrote:
>> On 7/6/24 04:09, Ming Lei wrote:
>>> SQE group is defined as one chain of SQEs starting with the first SQE that
>>> has IOSQE_SQE_GROUP set, and ending with the first subsequent SQE that
>>> doesn't have it set, and it is similar with chain of linked SQEs.
>>>
...
>>> ---
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 7597344a6440..b5415f0774e5 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>> ...
>>> @@ -421,6 +422,10 @@ static inline void io_req_track_inflight(struct io_kiocb *req)
>>>    	if (!(req->flags & REQ_F_INFLIGHT)) {
>>>    		req->flags |= REQ_F_INFLIGHT;
>>>    		atomic_inc(&req->task->io_uring->inflight_tracked);
>>> +
>>> +		/* make members' REQ_F_INFLIGHT discoverable via leader's */
>>> +		if (req_is_group_member(req))
>>> +			io_req_track_inflight(req->grp_leader);
>>
>> Requests in a group can be run in parallel with the leader (i.e.
>> io_issue_sqe()), right? In which case it'd race setting req->flags. We'd
>> need to think how make it sane.
> 
> Yeah, another easier way could be to always mark leader as INFLIGHT.

I've been thinking a bit more about it, there should be an easier way
out since we now have lazy file assignment. I sent a patch closing
a gap, I need to double check if that's enough, but let's forget
about additional REQ_F_INFLIGHT handling here.

...
>>> @@ -1420,6 +1553,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>>>    	__must_hold(&ctx->uring_lock)
>>>    {
>>>    	struct io_submit_state *state = &ctx->submit_state;
>>> +	struct io_wq_work_list grp_list = {NULL};
>>>    	struct io_wq_work_node *node;
>>>    	__io_cq_lock(ctx);
>>> @@ -1427,11 +1561,22 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>>>    		struct io_kiocb *req = container_of(node, struct io_kiocb,
>>>    					    comp_list);
>>> -		if (!(req->flags & REQ_F_CQE_SKIP))
>>> +		/*
>>> +		 * For group leader, cqe has to be committed after all
>>> +		 * members are committed, when the group leader flag is
>>> +		 * cleared
>>> +		 */
>>> +		if (!(req->flags & REQ_F_CQE_SKIP) &&
>>> +				likely(!req_is_group_leader(req)))
>>>    			io_req_commit_cqe(ctx, req);
>>> +		if (req->flags & REQ_F_SQE_GROUP)
>>> +			io_complete_group_req(req, &grp_list);
>>
>>
>> if (unlikely(flags & (SKIP_CQE|GROUP))) {
>> 	<sqe group code>
>> 	if (/* needs to skip CQE posting */)
>> 		continue;
> 
> io_complete_group_req() needs to be called too in case of CQE_SKIP
> because the current request may belong to group.

What's the problem? You can even do

if (flags & GROUP) {
	// do all group specific stuff
	// handle CQE_SKIP if needed
} else if (flags & CQE_SKIP) {
	continue;
}

And call io_complete_group_req() and other group stuff
at any place there.

>> 	<more sqe group code>
>> }
>>
>> io_req_commit_cqe();
>>
>>
>> Please. And, what's the point of reversing the CQE order and
>> posting the "leader" completion last? It breaks the natural
>> order of how IO complete, that is first the "leader" completes
>> what it has need to do including IO, and then "members" follow
>> doing their stuff. And besides, you can even post a CQE for the
>> "leader" when its IO is done and let the user possibly continue
>> executing. And the user can count when the entire group complete,
>> if that's necessary to know.
> 
> There are several reasons for posting leader completion last:
> 
> 1) only the leader is visible in link chain, IO drain has to wait
> the whole group by draining the leader

Let's forget about IO drain. It's a feature I'd love to see killed
(if only we can), it's a slow path, for same reasons I'll discourage
anyone using it.

For correctness we can just copy the link trick, i.e. mark the next
request outside of the current group/link as drained like below or
just fail the group.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7ed1e009aaec..aa0b93765406 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1975,7 +1975,7 @@ static void io_init_req_drain(struct io_kiocb *req)
  	struct io_kiocb *head = ctx->submit_state.link.head;
  
  	ctx->drain_active = true;
-	if (head) {
+	if (head || ctx->submit_state.group.head) {
  		/*
  		 * If we need to drain a request in the middle of a link, drain
  		 * the head request and the next request/link after the current



> 2) when members depend on leader, leader holds group-wide resource,
> so it has to be completed after all members are done

I'm talking about posting a CQE but not destroying the request
(and associated resources).

>>>    	}
>>>    	__io_cq_unlock_post(ctx);
>>> +	if (!wq_list_empty(&grp_list))
>>> +		__wq_list_splice(&grp_list, state->compl_reqs.first);
>>> +
>>>    	if (!wq_list_empty(&state->compl_reqs)) {
>>>    		io_free_batch_list(ctx, state->compl_reqs.first);
>>>    		INIT_WQ_LIST(&state->compl_reqs);
>> ...
>>> @@ -1754,9 +1903,18 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
>>>    	struct io_kiocb *nxt = NULL;
>>>    	if (req_ref_put_and_test(req)) {
>>> -		if (req->flags & IO_REQ_LINK_FLAGS)
>>> -			nxt = io_req_find_next(req);
>>> -		io_free_req(req);
>>> +		/*
>>> +		 * CQEs have been posted in io_req_complete_post() except
>>> +		 * for group leader, and we can't advance the link for
>>> +		 * group leader until its CQE is posted.
>>> +		 */
>>> +		if (!req_is_group_leader(req)) {
>>> +			if (req->flags & IO_REQ_LINK_FLAGS)
>>> +				nxt = io_req_find_next(req);
>>> +			io_free_req(req);
>>> +		} else {
>>> +			__io_free_req(req, false);
>>
>> Something fishy is going on here. io-wq only holds a ref that the
>> request is not killed, but it's owned by someone else. And the
>> owner is responsible for CQE posting and logical flow of the
>> request.
> 
> io_req_complete_post() is always called in io-wq for CQE posting
> before io-wq drops ref.
> 
> The ref held by io-wq prevents the owner from calling io_free_req(),
> so the owner actually can't run CQE post.
> 
>>
>> Now, the owner put the request down but for some reason didn't
>> finish with the request like posting a CQE, but it's delayed to
>> iowq dropping the ref?
>>
>> I assume the refcounting hierarchy, first grp_refs go down,
>> and when it hits zero it does whatever it needs, posting a
>> CQE at that point of prior, and then puts the request reference
>> down.
> 
> Yes, that is why the patch doesn't mark CQE_SKIP for leader in
> io_wq_free_work(), meantime leader->link has to be issued after
> leader's CQE is posted in case of io-wq.

The point is that io_wq_free_work() doesn't need to know
anything about groups and can just continue setting the
skip cqe flag as before if it's done differently

> But grp_refs is dropped after io-wq request reference drops to
> zero, then both io-wq and nor-io-wq code path can be unified
> wrt. dealing with grp_refs, meantime it needn't to be updated
> in extra(io-wq) context.

Let's try to describe how it can work. First, I'm only describing
the dep mode for simplicity. And for the argument's sake we can say
that all CQEs are posted via io_submit_flush_completions.

io_req_complete_post() {
	if (flags & GROUP) {
		req->io_task_work.func = io_req_task_complete;
		io_req_task_work_add(req);
		return;
	}
	...
}

You can do it this way, nobody would ever care, and it shouldn't
affect performance. Otherwise everything down below can probably
be extended to io_req_complete_post().

To avoid confusion in terminology, what I call a member below doesn't
include a leader. IOW, a group leader request is not a member.

At the init we have:
grp_refs = nr_members; /* doesn't include the leader */

Let's also say that the group leader can and always goes
through io_submit_flush_completions() twice, just how it's
with your patches.

1) The first time we see the leader in io_submit_flush_completions()
is when it's done with resource preparation. For example, it was
doing some IO into a buffer, and now is ready to give that buffer
with data to group members. At this point it should queue up all group
members. And we also drop 1 grp_ref. There will also be no
io_issue_sqe() for it anymore.

2) Members are executed and completed, in io_submit_flush_completions()
they drop 1 grp_leader->grp_ref reference each.

3) When all members complete, leader's grp_ref becomes 0. Here
the leader is queued for io_submit_flush_completions() a second time,
at which point it drops ublk buffers and such and gets destroyed.

You can post a CQE in 1) and then set CQE_SKIP. Can also be fitted
into 3). A pseudo code for when we post it in step 1)

io_free_batch_list() {
	if (req->flags & GROUP) {
		if (req_is_member(req)) {
			req->grp_leader->grp_refs--;
			if (req->grp_leader->grp_refs == 0) {
				req->io_task_work.func = io_req_task_complete;
				io_req_task_work_add(req->grp_leader);
				// can be done better....
			}
			goto free_req;
		}
		WARN_ON_ONCE(!req_is_leader());

		if (!(req->flags & SEEN_FIRST_TIME)) {
			// already posted it just before coming here
			req->flags |= SKIP_CQE;
			// we'll see it again when grp_refs hit 0
			req->flags |= SEEN_FIRST_TIME;

			// Don't free the req, we're leaving it alive for now.
			// req->ref/REQ_F_REFCOUNT will be put next time we get here.
			return; // or continue
		}

		clean_up_request_resources(); // calls back into ublk
		// and now free the leader
	}

free_req:
	// the rest of io_free_batch_list()
	if (flags & REQ_F_REFCOUNT) {
		req_drop_ref();
		....
	}
	...
}


This way
1) There are relatively easy request lifetime rules.
2) No special ownership/lifetime rules for the group link field.
3) You don't need to touch io_req_complete_defer()
4) io-wq doesn't know anything about grp_refs and doesn't play tricks
with SKIP_CQE.
5) All handling is in one place, doesn't need multiple checks in common
hot path. You might need some extra, but at least it's contained.


>>> +		}
>>>    	}
>>>    	return nxt ? &nxt->work : NULL;
>>>    }
>>> @@ -1821,6 +1979,8 @@ void io_wq_submit_work(struct io_wq_work *work)
>>>    		}
>>>    	}
>>> +	if (need_queue_group_members(req->flags))
>>> +		io_queue_group_members(req, true);
>>>    	do {
>>>    		ret = io_issue_sqe(req, issue_flags);
>>>    		if (ret != -EAGAIN)
>>> @@ -1932,9 +2092,17 @@ static inline void io_queue_sqe(struct io_kiocb *req)
>>>    	/*
>>>    	 * We async punt it if the file wasn't marked NOWAIT, or if the file
>>>    	 * doesn't support non-blocking read/write attempts
>>> +	 *
>>> +	 * Request is always freed after returning from io_queue_sqe(), so
>>> +	 * it is fine to check its flags after it is issued
>>> +	 *
>>> +	 * For group leader, members holds leader references, so it is safe
>>> +	 * to touch the leader after leader is issued
>>>    	 */
>>>    	if (unlikely(ret))
>>>    		io_queue_async(req, ret);
>>> +	else if (need_queue_group_members(req->flags))
>>> +		io_queue_group_members(req, false);
>>
>> It absolutely cannot be here. There is no relation between this place
>> in code and lifetime of the request. It could've been failed or
>> completed, it can also be flying around in a completely arbitrary
>> context being executed. We're not introducing weird special lifetime
>> rules for group links. It complicates the code, and no way it can be
>> sanely supported.
>> For example, it's not forbidden for issue_sqe callbacks to queue requests
>> to io-wq and return 0 (IOU_ISSUE_SKIP_COMPLETE which would be turned
>> into 0), and then we have two racing io_queue_group_members() calls.
> 
> It can by handled by adding io_queue_sqe_group() in which:
> 
> - req->grp_link is moved to one local variable, and make every
>    member's grp_leader point to req
> 
> - call io_queue_sqe() for leader
> 
> - then call io_queue_group_members() for all members, and make sure
> not touch leader in io_queue_group_members()
> 
> What do you think of this way?

By the end of the day, io_queue_sqe is just not the right place for
it. Take a look at the scheme above, I believe it should work

-- 
Pavel Begunkov

