Return-Path: <io-uring+bounces-2955-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E91D496115A
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 17:19:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E872281BEA
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 15:19:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00B4C1C2317;
	Tue, 27 Aug 2024 15:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lZF0t4XR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7161CCB33;
	Tue, 27 Aug 2024 15:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771897; cv=none; b=PZMlyQRZyZQHnehf3hEIr3om2+F7ryi2i7oHIYZM9z07Els0pLaAiO8Hs2T1vIMT90/exaYBvr48xcA30qv6Q3bHVTujM+I27Fmsp3KtvMb1jelpgmbeBYKF+I1sgCE0dGA+ZU70KbGPtDzjPu8v461ba16beBu+Q/WinjgmDL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771897; c=relaxed/simple;
	bh=piQp8t3nQR50qiwQ2EfEiLa+xEuAnIo60u5rV8XT2XI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YHvqrbhktEIbXC5fSCw8/p49tij1QV2Uf5jKAFTkWqYROFOXSe7RLJDNgJgWUJ1LgmaoNQGOu+jqw4fScOtLe00nRsFCdSM0e0izsS720DKvAjEzmwX5aHSQFbWGFTFU5Ba/XCTFNnyKu4yDKQZ77m49UIsX3/ZQ85SiSmJcp9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lZF0t4XR; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-533462b9428so9573526e87.3;
        Tue, 27 Aug 2024 08:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724771894; x=1725376694; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qpdkCytbMJyzGxkX00NjeQPLMROyS6LnGxu+SEiZL9k=;
        b=lZF0t4XRlG3wSqhOhmvFYvOA5/eJzDZP7/0dscrU/iE39l2WWwEPbiuV6wxxK04G/2
         yUz+iTl2dbXOz+GJLxFGN21ANRcGL4Gt8zLADeLvqPJ+mhkEcYctuSn25U77GVdfEhR7
         SzRwYM9lqIcyhIVTLJds/psVaoTpKu820KX0grMVU9G4kIEh4Xp56dP8c04JZ3DPCNxw
         0sKXh3fCg8nTTZOa/78QRnb4KKEGotJC5fwTDMybR1UpxwE5pwBW/QVyQkgZfHKN9FM7
         jdS1XjStFqjkV1nTKqurvkgz+eEZovdnRg3sEbolNvdLVDqj1dbFGF5I1t2Tva2+husw
         Co7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724771894; x=1725376694;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qpdkCytbMJyzGxkX00NjeQPLMROyS6LnGxu+SEiZL9k=;
        b=mDTVyb9IUbEY016lyMeI5HkCmuPg7PWp3hDneBvqG37UfUlF9EvBiDWb31COGKRqIa
         +u1/2ev+d5T30EmA2fd+S7whv3R3AWqSXx8Iw2C5PZLMbFqtDz0rTRwxc771jXmURMY/
         xDyy2QvZd1u7f8s4v2wZfxwvlIo1Sf4C++I+3/UJd1mWSjxTmM+pKgVdJu5i5bMZM37k
         jzBYt/i0yAouPlTIqVnOn96X3eaptsczink7Fl6g3SHxLfxzPuZO5mO1OCktuwdSOY9y
         IPqxHt3geeCGQOXBlQ7DLuEHmDxDHXKUFHuhx1cNDUD7ID69BPhNFYW+JQ039TC1Rqq1
         AzkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUi45AZaQFplOk4We8mJliAnGJy49t+hEZ+TYqjmjTaj1BC0RY3GS70SMJCctYvT69aSWcfDWxVsw==@vger.kernel.org, AJvYcCV2qIS3xvsBzDEYuyzLfcNUgtdzWRfOUsueI1/P8e74iegj5kfcrU8N6XEVIPzEpZVjPwuSMCHlBYZSoxc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxXvtfJSYANE6f6dZWuYsQblJZ2BWEjZV8E8MzQ2NB2m490vn6
	/od124K2KS4C6KfUWxA+HS0idd0a1eor2bo+jOA/hL0rRM0jGwGkJ40BkA==
X-Google-Smtp-Source: AGHT+IGk9/0LjcySSNWILkuW71xQGnvxQC+nsZl9FnEk19fFuwbXhxcGd/iVEr75D967dlcrdruRWw==
X-Received: by 2002:a05:6512:23a3:b0:52e:d0f8:2d43 with SMTP id 2adb3069b0e04-53438846f57mr11037110e87.17.1724771892977;
        Tue, 27 Aug 2024 08:18:12 -0700 (PDT)
Received: from [192.168.42.187] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a86e58779c7sm122793766b.143.2024.08.27.08.18.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2024 08:18:10 -0700 (PDT)
Message-ID: <3c819871-7ca3-47ea-b752-c4a8a49f8304@gmail.com>
Date: Tue, 27 Aug 2024 16:18:26 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 4/8] io_uring: support SQE group
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org
Cc: Kevin Wolf <kwolf@redhat.com>
References: <20240808162503.345913-1-ming.lei@redhat.com>
 <20240808162503.345913-5-ming.lei@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240808162503.345913-5-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/8/24 17:24, Ming Lei wrote:
> SQE group is defined as one chain of SQEs starting with the first SQE that
> has IOSQE_SQE_GROUP set, and ending with the first subsequent SQE that
> doesn't have it set, and it is similar with chain of linked SQEs.
> 
> Not like linked SQEs, each sqe is issued after the previous one is
> completed. All SQEs in one group can be submitted in parallel. To simplify
> the implementation from beginning, all members are queued after the leader
> is completed, however, this way may be changed and leader and members may
> be issued concurrently in future.
> 
> The 1st SQE is group leader, and the other SQEs are group member. The whole
> group share single IOSQE_IO_LINK and IOSQE_IO_DRAIN from group leader, and
> the two flags can't be set for group members.
> 
> When the group is in one link chain, this group isn't submitted until the
> previous SQE or group is completed. And the following SQE or group can't
> be started if this group isn't completed. Failure from any group member will
> fail the group leader, then the link chain can be terminated.
> 
> When IOSQE_IO_DRAIN is set for group leader, all requests in this group and
> previous requests submitted are drained. Given IOSQE_IO_DRAIN can be set for
> group leader only, we respect IO_DRAIN by always completing group leader as
> the last one in the group. Meantime it is natural to post leader's CQE
> as the last one from application viewpoint.
> 
> Working together with IOSQE_IO_LINK, SQE group provides flexible way to
> support N:M dependency, such as:
> 
> - group A is chained with group B together
> - group A has N SQEs
> - group B has M SQEs
> 
> then M SQEs in group B depend on N SQEs in group A.
> 
> N:M dependency can support some interesting use cases in efficient way:
> 
> 1) read from multiple files, then write the read data into single file
> 
> 2) read from single file, and write the read data into multiple files
> 
> 3) write same data into multiple files, and read data from multiple files and
> compare if correct data is written
> 
> Also IOSQE_SQE_GROUP takes the last bit in sqe->flags, but we still can
> extend sqe->flags with one uring context flag, such as use __pad3 for
> non-uring_cmd OPs and part of uring_cmd_flags for uring_cmd OP.
> 
> Suggested-by: Kevin Wolf <kwolf@redhat.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   include/linux/io_uring_types.h |  18 +++
...
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index f112e9fa90d8..45a292445b18 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
...
> @@ -875,6 +877,116 @@ static __always_inline void io_req_commit_cqe(struct io_ring_ctx *ctx,
>   	}
>   }
...
> +static void io_queue_group_members(struct io_kiocb *req)
> +{
> +	struct io_kiocb *member = req->grp_link;
> +
> +	if (!member)
> +		return;
> +
> +	req->grp_link = NULL;
> +	while (member) {
> +		struct io_kiocb *next = member->grp_link;
> +
> +		member->grp_leader = req;
> +		if (unlikely(member->flags & REQ_F_FAIL)) {
> +			io_req_task_queue_fail(member, member->cqe.res);
> +		} else if (unlikely(req->flags & REQ_F_FAIL)) {
> +			io_req_task_queue_fail(member, -ECANCELED);
> +		} else {
> +			io_req_task_queue(member);
> +		}
> +		member = next;
> +	}
> +}
> +
> +static inline bool __io_complete_group_member(struct io_kiocb *req,
> +			     struct io_kiocb *lead)
> +{

I think it'd be better if you inline this function, it only
obfuscates things.

> +	if (WARN_ON_ONCE(lead->grp_refs <= 0))
> +		return false;
> +
> +	req->flags &= ~REQ_F_SQE_GROUP;

I'm getting completely lost when and why it clears and sets
back REQ_F_SQE_GROUP and REQ_F_SQE_GROUP_LEADER. Is there any
rule?

> +	/*
> +	 * Set linked leader as failed if any member is failed, so
> +	 * the remained link chain can be terminated
> +	 */
> +	if (unlikely((req->flags & REQ_F_FAIL) &&
> +		     ((lead->flags & IO_REQ_LINK_FLAGS) && lead->link)))
> +		req_set_fail(lead);

if (req->flags & REQ_F_FAIL)
	req_set_fail(lead);

REQ_F_FAIL is not specific to links, if a request fails we need
to mark it as such.


> +	return !--lead->grp_refs;
> +}
> +
> +static inline bool leader_is_the_last(struct io_kiocb *lead)
> +{
> +	return lead->grp_refs == 1 && (lead->flags & REQ_F_SQE_GROUP);
> +}
> +
> +static void io_complete_group_member(struct io_kiocb *req)
> +{
> +	struct io_kiocb *lead = get_group_leader(req);
> +
> +	if (WARN_ON_ONCE(!(req->flags & REQ_F_SQE_GROUP)))
> +		return;
> +
> +	/* member CQE needs to be posted first */
> +	if (!(req->flags & REQ_F_CQE_SKIP))
> +		io_req_commit_cqe(req->ctx, req);
> +
> +	if (__io_complete_group_member(req, lead)) {
> +		/*
> +		 * SQE_GROUP flag is kept for the last member, so the leader
> +		 * can be retrieved & freed from this last member
> +		 */
> +		req->flags |= REQ_F_SQE_GROUP;
> +		if (!(lead->flags & REQ_F_CQE_SKIP))
> +			io_req_commit_cqe(lead->ctx, lead);
> +	} else if (leader_is_the_last(lead)) {
> +		/* leader will degenerate to plain req if it is the last */
> +		lead->flags &= ~(REQ_F_SQE_GROUP | REQ_F_SQE_GROUP_LEADER);

What's this chunk is about?

> +	}
> +}
> +
> +static void io_complete_group_leader(struct io_kiocb *req)
> +{
> +	WARN_ON_ONCE(req->grp_refs <= 0);
> +	req->flags &= ~REQ_F_SQE_GROUP;
> +	req->grp_refs -= 1;
> +	WARN_ON_ONCE(req->grp_refs == 0);

Why not combine these WARN_ON_ONCE into one?

> +
> +	/* TODO: queue members with leader in parallel */

no todos, please

> +	if (req->grp_link)
> +		io_queue_group_members(req);
> +}

It's spinlock'ed, we really don't want to do too much here
like potentially queueing a ton of task works.
io_queue_group_members() can move into io_free_batch_list().

> +
>   static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
> @@ -890,7 +1002,8 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
>   	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
>   	 * the submitter task context, IOPOLL protects with uring_lock.
>   	 */
> -	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL)) {
> +	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL) ||
> +	    req_is_group_leader(req)) {
>   		req->io_task_work.func = io_req_task_complete;
>   		io_req_task_work_add(req);
>   		return;
> @@ -1388,11 +1501,33 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
>   						    comp_list);
>   
>   		if (unlikely(req->flags & IO_REQ_CLEAN_SLOW_FLAGS)) {
> +			if (req->flags & (REQ_F_SQE_GROUP |
> +					  REQ_F_SQE_GROUP_LEADER)) {
> +				struct io_kiocb *leader;
> +
> +				/* Leader is freed via the last member */
> +				if (req_is_group_leader(req)) {
> +					node = req->comp_list.next;
> +					continue;
> +				}
> +
> +				/*
> +				 * Only the last member keeps GROUP flag,
> +				 * free leader and this member together
> +				 */
> +				leader = get_group_leader(req);
> +				leader->flags &= ~REQ_F_SQE_GROUP_LEADER;
> +				req->flags &= ~REQ_F_SQE_GROUP;
> +				wq_stack_add_head(&leader->comp_list,
> +						  &req->comp_list);

That's quite hacky, but at least we can replace it with
task work if it gets in the way later on.

> +			}
> +
>   			if (req->flags & REQ_F_REFCOUNT) {
>   				node = req->comp_list.next;
>   				if (!req_ref_put_and_test(req))
>   					continue;
>   			}
> +
>   			if ((req->flags & REQ_F_POLLED) && req->apoll) {
>   				struct async_poll *apoll = req->apoll;
>   
> @@ -1427,8 +1562,19 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   		struct io_kiocb *req = container_of(node, struct io_kiocb,
>   					    comp_list);
>   
> -		if (!(req->flags & REQ_F_CQE_SKIP))
> -			io_req_commit_cqe(ctx, req);
> +		if (unlikely(req->flags & (REQ_F_CQE_SKIP | REQ_F_SQE_GROUP))) {
> +			if (req->flags & REQ_F_SQE_GROUP) {
> +				if (req_is_group_leader(req))
> +					io_complete_group_leader(req);
> +				else
> +					io_complete_group_member(req);
> +				continue;
> +			}
> +
> +			if (req->flags & REQ_F_CQE_SKIP)
> +				continue;
> +		}
> +		io_req_commit_cqe(ctx, req);
>   	}
>   	__io_cq_unlock_post(ctx);
>   
...
> @@ -2101,6 +2251,62 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>   	return def->prep(req, sqe);
>   }
>   
> +static struct io_kiocb *io_group_sqe(struct io_submit_link *group,
> +				     struct io_kiocb *req)
> +{
> +	/*
> +	 * Group chain is similar with link chain: starts with 1st sqe with
> +	 * REQ_F_SQE_GROUP, and ends with the 1st sqe without REQ_F_SQE_GROUP
> +	 */
> +	if (group->head) {
> +		struct io_kiocb *lead = group->head;
> +
> +		/* members can't be in link chain, can't be drained */
> +		if (req->flags & (IO_REQ_LINK_FLAGS | REQ_F_IO_DRAIN))
> +			req_fail_link_node(lead, -EINVAL);

That should fail the entire link (if any) as well.

I have even more doubts we even want to mix links and groups. Apart
from nuances as such, which would be quite hard to track, the semantics
of IOSQE_CQE_SKIP_SUCCESS is unclear. And also it doen't work with
IORING_OP_LINK_TIMEOUT.

> +
> +		lead->grp_refs += 1;
> +		group->last->grp_link = req;
> +		group->last = req;
> +
> +		if (req->flags & REQ_F_SQE_GROUP)
> +			return NULL;
> +
> +		req->grp_link = NULL;
> +		req->flags |= REQ_F_SQE_GROUP;
> +		group->head = NULL;
> +		if (lead->flags & REQ_F_FAIL) {
> +			io_queue_sqe_fallback(lead);

Let's say the group was in the middle of a link, it'll
complete that group and continue with assembling / executing
the link when it should've failed it and honoured the
request order.


> +			return NULL;
> +		}
> +		return lead;
> +	} else if (req->flags & REQ_F_SQE_GROUP) {
> +		group->head = req;
> +		group->last = req;
> +		req->grp_refs = 1;
> +		req->flags |= REQ_F_SQE_GROUP_LEADER;
> +		return NULL;
> +	} else {

We shouldn't be able to get here.

if (WARN_ONCE(!(req->flags & GROUP)))
	...
group->head = req;
...

> +		return req;
> +	}
> +}
> +
> +static __cold struct io_kiocb *io_submit_fail_group(
> +		struct io_submit_link *link, struct io_kiocb *req)
> +{
> +	struct io_kiocb *lead = link->head;
> +
> +	/*
> +	 * Instead of failing eagerly, continue assembling the group link
> +	 * if applicable and mark the leader with REQ_F_FAIL. The group
> +	 * flushing code should find the flag and handle the rest
> +	 */
> +	if (lead && (lead->flags & IO_REQ_LINK_FLAGS) && !(lead->flags & REQ_F_FAIL))
> +		req_fail_link_node(lead, -ECANCELED);

Same as above, you don't need to check for IO_REQ_LINK_FLAGS.
io_queue_sqe_fallback()


> +
> +	return io_group_sqe(link, req);
> +}
> +

-- 
Pavel Begunkov

