Return-Path: <io-uring+bounces-2231-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A854909F7A
	for <lists+io-uring@lfdr.de>; Sun, 16 Jun 2024 21:13:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A3EA2B2230D
	for <lists+io-uring@lfdr.de>; Sun, 16 Jun 2024 19:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A99D51C6A0;
	Sun, 16 Jun 2024 19:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YY26ee7+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8D3224D7;
	Sun, 16 Jun 2024 19:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718565208; cv=none; b=FyXEKpbA2jbxd5gzN47xRpH6kZ+l4G1IttznYxg0VNg6Ps4ou+7lJvZRAmBs/hl7FPWNR/QGugprba7W7VsUV965cJKYVZSf5az7gJKBTjMlXTdvgeb/lRW2mmWc/DfVLr64VER9W3vjHVOn8NabfQmNhEnR7UJAwSPdfCq84Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718565208; c=relaxed/simple;
	bh=gm8BtqumwEgNfj/a+XzF48j8r0w/nqI7oMpUyrMWZ4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QJaVYyFmPo7raBIwQpeGPdsNfzb6uGLSUvOM3iEi/auR/Ue7XbAVvqcEaGQqP/3Uh7EbKyKOWezN3OjYcPueq96e8Hsv6P3jfq6dub2xmKSgowuUIT0uqew2JjYgWQcQMFqVv69XWIAwZE/ayCvChesOgYaK+9xuGTL3wwfBZ9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YY26ee7+; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-35f2d723ef0so3190212f8f.1;
        Sun, 16 Jun 2024 12:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718565205; x=1719170005; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MTi1jFBco0pj7Sm6vTbnmjTTo8w6JNcyvc0zcggpELk=;
        b=YY26ee7+qAwP8Y41EUKE+hY0PuDh6aOsMXWAzdCJEBZwiwhK/p+7vZlzIy2dIGmE9b
         G1DxXz6sut1XpPBEjQP14vNRacDUN6fO4DiFgn/EGuCYlyoGQU9HVlAeY5Z59LrErmeq
         1eQcrgkvs+Wd7nj5jTRHl0yPeZQpVHK/wCHj+YRLRbT9ZZ2sT7ysOUqYx0MbQnQo2Iu5
         9KuB6KTK5KYAe7bJUat08IS7c70AvQYzJCRyfJ+x1wBtjoI8AO5UnQPisK/IGyh5mg5r
         RAQiPOtG4QpmU+w4QLgFwkskhZTOhhL9oeclyVio4UOeMKhRP9CZ4Rz6cp/hH640Gm2B
         6TEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718565205; x=1719170005;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MTi1jFBco0pj7Sm6vTbnmjTTo8w6JNcyvc0zcggpELk=;
        b=ZUpbIQO8j0Gusd8L8uqqkec/ewJfTZq4w0lCCLjO+j5Az/8ksxK5HAuESzvnG3S8/F
         XTpHkJxgVKu0Xp5H1DTtZQPFoGPgJMpFicSINtCcIfNiyAwwabBKoUg593eq2fTguk5y
         F5G8CVy3QBeGACo9+VGHihM+VuRQ0ChnL2Z9Pt8biY5OEhIe1k+tby4i5TuA/0jBYFqm
         +dckin1S082du1S4H+XihyafKTr2mjfQAH55yT4uFKrTmiiV0yItHpMDTbbPSTRlBGYW
         ssq3kq31wnKEowhGcHrD7T5rg6CoO0HEexSqgmfiJ1DcmPm6C7d5w6dMAMTTBTX+ifA0
         dzNg==
X-Forwarded-Encrypted: i=1; AJvYcCVxIohLKs4Vcxnt8Pg7s6CcSxaPQvfxBNCjK8Y5Ez79mRaNUvMRaxx5FUqLDwF3ZjN6T2UwRc6sTF0hdjEPTTlPwdf+Qi44u3sQ3mzakQf2IP47nD5Drrf8gtdheOSOLTUSonjr1A==
X-Gm-Message-State: AOJu0YxhCs97KhPP3q4hkMEkLPcwcrB701qSJ63nQvFYX6Rvbdhl+PzI
	z6tQ1dohr5nzUPnemZP5hp83nvzJaugFtL/k885KuZDJv0T6A7GJ
X-Google-Smtp-Source: AGHT+IGqAb2EM9IokQ7zI1o80Sz5QZWLcpN//eQFKAyJUWjuI3eT4C8Mx0uSRfpEc1jpqK/XOEQ9Qg==
X-Received: by 2002:a5d:5274:0:b0:35f:1ddf:3437 with SMTP id ffacd0b85a97d-3607a7468bcmr5664052f8f.25.1718565204601;
        Sun, 16 Jun 2024 12:13:24 -0700 (PDT)
Received: from [192.168.42.249] ([148.252.147.74])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3609515e16dsm1474173f8f.44.2024.06.16.12.13.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jun 2024 12:13:24 -0700 (PDT)
Message-ID: <f29e662c-5959-4b90-845a-0e3c81a174e6@gmail.com>
Date: Sun, 16 Jun 2024 20:13:26 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 5/9] io_uring: support SQE group
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
References: <20240511001214.173711-1-ming.lei@redhat.com>
 <20240511001214.173711-6-ming.lei@redhat.com>
 <97fe853f-1963-4304-b371-5fe596ae5fcf@gmail.com> <ZmpPONHc8GajjoEm@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZmpPONHc8GajjoEm@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/24 02:45, Ming Lei wrote:
> On Mon, Jun 10, 2024 at 03:53:51AM +0100, Pavel Begunkov wrote:
>> On 5/11/24 01:12, Ming Lei wrote:
>>> SQE group is defined as one chain of SQEs starting with the first SQE that
>>> has IOSQE_SQE_GROUP set, and ending with the first subsequent SQE that
>>> doesn't have it set, and it is similar with chain of linked SQEs.
>>
>> The main concern stays same, it adds overhead nearly to every
>> single hot function I can think of, as well as lots of
>> complexity.
> 
> Almost every sqe group change is covered by REQ_F_SQE_GROUP, so I am
> not clear what the added overhead is.

Yes, and there is a dozen of such in the hot path.

>> Another minor issue is REQ_F_INFLIGHT, as explained before,
>> cancellation has to be able to find all REQ_F_INFLIGHT
>> requests. Requests you add to a group can have that flag
>> but are not discoverable by core io_uring code.
> 
> OK, we can deal with it by setting leader as REQ_F_INFLIGHT if the
> flag is set for any member, since all members are guaranteed to
> be drained when leader is completed. Will do it in V4.

Or fail if see one, that's also fine. REQ_F_INFLIGHT is
only set for POLL requests polling another io_uring.

>> Another note, I'll be looking deeper into this patch, there
>> is too much of random tossing around of requests / refcounting
>> and other dependencies, as well as odd intertwinings with
>> other parts.
> 
> The only thing wrt. request refcount is for io-wq, since request
> reference is grabbed when the req is handled in io-wq context, and
> group leader need to be completed after all members are done. That
> is all special change wrt. request refcounting.

I rather mean refcounting the group leader, even if it's not
atomic.

>>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>>> index 7a6b190c7da7..62311b0f0e0b 100644
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index c184c9a312df..b87c5452de43 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
...
>>>    	}
>>>    }
>>> +static inline bool need_queue_group_members(struct io_kiocb *req)
>>> +{
>>> +	return req_is_group_leader(req) && req->grp_link;
>>> +}
>>> +
>>> +/* Can only be called after this request is issued */
>>> +static inline struct io_kiocb *get_group_leader(struct io_kiocb *req)
>>> +{
>>> +	if (req->flags & REQ_F_SQE_GROUP) {
>>> +		if (req_is_group_leader(req))
>>> +			return req;
>>> +		return req->grp_link;
>>
>> I'm missing something, it seems io_group_sqe() adding all
>> requests of a group into a singly linked list via ->grp_link,
>> but here we return it as a leader. Confused.
> 
> ->grp_link stores the singly linked list for group leader, and
> the same field stores the group leader pointer for group member requests.
> For later, we can add one union field to make code more readable.
> Will do that in V4.

So you're repurposing it in io_queue_group_members(). Since
it has different meaning at different stages of execution,
it warrants a comment (unless there is one I missed).

>>> +	}
>>> +	return NULL;
>>> +}
>>> +
>>> +void io_cancel_group_members(struct io_kiocb *req, bool ignore_cqes)
>>> +{
>>> +	struct io_kiocb *member = req->grp_link;
>>> +
>>> +	while (member) {
>>> +		struct io_kiocb *next = member->grp_link;
>>> +
>>> +		if (ignore_cqes)
>>> +			member->flags |= REQ_F_CQE_SKIP;
>>> +		if (!(member->flags & REQ_F_FAIL)) {
>>> +			req_set_fail(member);
>>> +			io_req_set_res(member, -ECANCELED, 0);
>>> +		}
>>> +		member = next;
>>> +	}
>>> +}
>>> +
>>> +void io_queue_group_members(struct io_kiocb *req, bool async)
>>> +{
>>> +	struct io_kiocb *member = req->grp_link;
>>> +
>>> +	if (!member)
>>> +		return;
>>> +
>>> +	while (member) {
>>> +		struct io_kiocb *next = member->grp_link;
>>> +
>>> +		member->grp_link = req;
>>> +		if (async)
>>> +			member->flags |= REQ_F_FORCE_ASYNC;
>>> +
>>> +		if (unlikely(member->flags & REQ_F_FAIL)) {
>>> +			io_req_task_queue_fail(member, member->cqe.res);
>>> +		} else if (member->flags & REQ_F_FORCE_ASYNC) {
>>> +			io_req_task_queue(member);
>>> +		} else {
>>> +			io_queue_sqe(member);

io_req_queue_tw_complete() please, just like links deal
with it, so it's executed in a well known context without
jumping ahead of other requests.

>>> +		}
>>> +		member = next;
>>> +	}
>>> +	req->grp_link = NULL;
>>> +}
>>> +
>>> +static inline bool __io_complete_group_req(struct io_kiocb *req,
>>> +			     struct io_kiocb *lead)
>>> +{
>>> +	WARN_ON_ONCE(!(req->flags & REQ_F_SQE_GROUP));
>>> +
>>> +	if (WARN_ON_ONCE(lead->grp_refs <= 0))
>>> +		return false;
>>> +
>>> +	/*
>>> +	 * Set linked leader as failed if any member is failed, so
>>> +	 * the remained link chain can be terminated
>>> +	 */
>>> +	if (unlikely((req->flags & REQ_F_FAIL) &&
>>> +		     ((lead->flags & IO_REQ_LINK_FLAGS) && lead->link)))
>>> +		req_set_fail(lead);
>>> +	return !--lead->grp_refs;
>>> +}
>>> +
>>> +/* Complete group request and collect completed leader for freeing */
>>> +static inline void io_complete_group_req(struct io_kiocb *req,
>>> +		struct io_wq_work_list *grp_list)
>>> +{
>>> +	struct io_kiocb *lead = get_group_leader(req);
>>> +
>>> +	if (__io_complete_group_req(req, lead)) {
>>> +		req->flags &= ~REQ_F_SQE_GROUP;
>>> +		lead->flags &= ~REQ_F_SQE_GROUP_LEADER;
>>> +		if (!(lead->flags & REQ_F_CQE_SKIP))
>>> +			io_req_commit_cqe(lead, lead->ctx->lockless_cq);
>>> +
>>> +		if (req != lead) {
>>> +			/*
>>> +			 * Add leader to free list if it isn't there
>>> +			 * otherwise clearing group flag for freeing it
>>> +			 * in current batch
>>> +			 */
>>> +			if (!(lead->flags & REQ_F_SQE_GROUP))
>>> +				wq_list_add_tail(&lead->comp_list, grp_list);
>>> +			else
>>> +				lead->flags &= ~REQ_F_SQE_GROUP;
>>> +		}
>>> +	} else if (req != lead) {
>>> +		req->flags &= ~REQ_F_SQE_GROUP;
>>> +	} else {
>>> +		/*
>>> +		 * Leader's group flag clearing is delayed until it is
>>> +		 * removed from free list
>>> +		 */
>>> +	}
>>> +}
>>> +
>>>    static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
>>>    {
>>>    	struct io_ring_ctx *ctx = req->ctx;
>>> @@ -1427,6 +1545,17 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
>>>    						    comp_list);
>>>    		if (unlikely(req->flags & IO_REQ_CLEAN_SLOW_FLAGS)) {
>>> +			/*
>>> +			 * Group leader may be removed twice, don't free it
>>> +			 * if group flag isn't cleared, when some members
>>> +			 * aren't completed yet
>>> +			 */
>>> +			if (req->flags & REQ_F_SQE_GROUP) {
>>> +				node = req->comp_list.next;
>>> +				req->flags &= ~REQ_F_SQE_GROUP;
>>> +				continue;
>>> +			}
>>> +
>>>    			if (req->flags & REQ_F_REFCOUNT) {
>>>    				node = req->comp_list.next;
>>>    				if (!req_ref_put_and_test(req))
>>> @@ -1459,6 +1588,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>>>    	__must_hold(&ctx->uring_lock)
>>>    {
>>>    	struct io_submit_state *state = &ctx->submit_state;
>>> +	struct io_wq_work_list grp_list = {NULL};
>>>    	struct io_wq_work_node *node;
>>>    	__io_cq_lock(ctx);
>>> @@ -1468,9 +1598,15 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>>>    		if (!(req->flags & REQ_F_CQE_SKIP))
>>>    			io_req_commit_cqe(req, ctx->lockless_cq);
>>> +
>>> +		if (req->flags & REQ_F_SQE_GROUP)
>>
>> Same note about hot path
>>
>>> +			io_complete_group_req(req, &grp_list);
>>>    	}
>>>    	__io_cq_unlock_post(ctx);
>>> +	if (!wq_list_empty(&grp_list))
>>> +		__wq_list_splice(&grp_list, state->compl_reqs.first);
>>
>> What's the point of splicing it here insted of doing all
>> that under REQ_F_SQE_GROUP above?
> 
> As mentioned, group leader can't be completed until all members are
> done, so any leaders in the current list have to be moved to this
> local list for deferred completion. That should be the only tricky
> part of the whole sqe group implementation.
> 
>>
>>> +
>>>    	if (!wq_list_empty(&ctx->submit_state.compl_reqs)) {
>>>    		io_free_batch_list(ctx, state->compl_reqs.first);
>>>    		INIT_WQ_LIST(&state->compl_reqs);
...
>>> @@ -1863,6 +2012,8 @@ void io_wq_submit_work(struct io_wq_work *work)
>>>    		}
>>>    	}
>>> +	if (need_queue_group_members(req))
>>> +		io_queue_group_members(req, true);
>>>    	do {
>>>    		ret = io_issue_sqe(req, issue_flags);
>>>    		if (ret != -EAGAIN)
>>> @@ -1977,6 +2128,9 @@ static inline void io_queue_sqe(struct io_kiocb *req)
>>>    	 */
>>>    	if (unlikely(ret))
>>>    		io_queue_async(req, ret);
>>> +
>>> +	if (need_queue_group_members(req))
>>> +		io_queue_group_members(req, false);
>>
>> Request ownership is considered to be handed further at this
>> point and requests should not be touched. Only ret==0 from
>> io_issue_sqe it's still ours, but again it's handed somewhere
>> by io_queue_async().
> 
> Yes, you are right.
> 
> And it has been fixed in my local tree:
> 
> @@ -2154,8 +2154,7 @@ static inline void io_queue_sqe(struct io_kiocb *req)
>           */
>          if (unlikely(ret))
>                  io_queue_async(req, ret);
> -
> -       if (need_queue_group_members(req))
> +       else if (need_queue_group_members(req))
>                  io_queue_group_members(req, false);
>   }

In the else branch you don't own the request anymore
and shouldn't be poking into it.

It looks like you're trying to do io_queue_group_members()
when previously the request would get completed. It's not
the right place, and apart from whack'a'moled
io_wq_submit_work() there is also io_poll_issue() missed.

Seems __io_submit_flush_completions() / io_free_batch_list()
would be more appropriate, and you already have a chunk with
GROUP check in there handling the leader appearing in there
twice.


>>>    }
>>>    static void io_queue_sqe_fallback(struct io_kiocb *req)
...
>>> @@ -2232,7 +2443,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>    			 const struct io_uring_sqe *sqe)
>>>    	__must_hold(&ctx->uring_lock)
>>>    {
>>> -	struct io_submit_link *link = &ctx->submit_state.link;
>>> +	struct io_submit_state *state = &ctx->submit_state;
>>>    	int ret;
>>>    	ret = io_init_req(ctx, req, sqe);
>>> @@ -2241,9 +2452,17 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>    	trace_io_uring_submit_req(req);
>>> -	if (unlikely(link->head || (req->flags & (IO_REQ_LINK_FLAGS |
>>> -				    REQ_F_FORCE_ASYNC | REQ_F_FAIL)))) {
>>> -		req = io_link_sqe(link, req);
>>> +	if (unlikely(state->group.head ||
>>
>> A note rather to myself and for the future, all theese checks
>> including links and groups can be folded under one common if.
> 
> Sorry, I may not get the idea, can you provide one example?

To be clear, not suggesting you doing it.

Simplifying:

init_req() {
	if (req->flags & GROUP|LINK) {
		ctx->assembling;
	}
}

io_submit_sqe() {
	init_req();

	if (ctx->assembling) {
		check_groups/links();
		if (done);
			ctx->assembling = false;
	}
}


> 
> We need different logics for group and link, meantime group
> has to be handled first before linking, since only the group leader
> can be linked.

-- 
Pavel Begunkov

