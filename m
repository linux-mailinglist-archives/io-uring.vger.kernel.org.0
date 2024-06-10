Return-Path: <io-uring+bounces-2147-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45CAF90196E
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 04:54:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6ACE2B20C86
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 02:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D10115CE;
	Mon, 10 Jun 2024 02:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i/PRYFny"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2CA7EF;
	Mon, 10 Jun 2024 02:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717988035; cv=none; b=CfrdvCFaX9KE+efVh/RACT3rN0b6Uz6rSYBTOCA2+cPuYXweCzx4a+l5Uz5hLvWpvx5xcYWa/uraRhsnQnsPEjfk4/ENxmzpiqD3JShiP88Wg+L5drEl26UtrG6OikDSS9ld3vNeo44yu9nlDYPkMWl9XH7swwWWgklRqd3Pztw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717988035; c=relaxed/simple;
	bh=w2RYlSugWxxWfqoRkDltOAXIcAe2KyaqA4R4RJZPo5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YBurm7ze4JaQ1rFIazz3jyaWKbjBRSMTMDUkq2NATVj+ScmgTu1UNLHAGr/DOF60pZofegEU4D9StUQuspKfebFjOPX9LEuYdi+XQEbmuk2mpM7CDZAEomAAIkg5f4nOxYzNmfEmn5+OEViErkApmMbAPiG2AeuyNR9h8DlB3QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i/PRYFny; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-354f3f6c3b1so3167736f8f.2;
        Sun, 09 Jun 2024 19:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717988031; x=1718592831; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jMY/nMr4YN1IlHT2+hgSevr1m7Z7kxrU0v76nsoWyeY=;
        b=i/PRYFnyDR3ugLITI3lgyUmnie9tlPZM0RXKNanEUn0oPVEjWz4Q/RUDBNeScFUaql
         oEYRtqiggoKIl9c+EXDIQMlXK0NbGGN8LqDc1w2YR4MBQ725+KQwOJt7JGk7vJeMFdgg
         6v7CAWxOVK9b8wOiVavPiG98xRvFptDQqzFtSzBUkwU/TiEhN7SnbtASGstFKUni4P5o
         Og0JwYf7j91rf65YnNJ0w4CjDfqCtgcyG2Sl7UtjcgSJ1E7G6YcoDLPlsIADlhTSyN5Z
         MnP808wFQ+lF2oyCk3PmlCC2kGhjIJxfci8LvvL+LKhkzsspcqabjOR0N1cDSBjM4n5+
         L97g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717988031; x=1718592831;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jMY/nMr4YN1IlHT2+hgSevr1m7Z7kxrU0v76nsoWyeY=;
        b=mI5361tGl2JOzCxGzP0I2fnMrbRdiQlsWnix4F9MSREPtwgZAYO7j6xpnkt3et94ig
         7q80/3OfpFPpZdy7qxKTc3LzorPJFht5QCUoYWAarrzdszDrjSxZ9ZZ18q7xFIkDCJV4
         m6Wvrr8mWmJVbwGL70UPJ362u1n8dk3VVgknrtieNN5g7MJupmzrqFVNTGvuQl1H42qp
         egtyE59ByOqfg4iBWxipEkp56iG12QPeWCaRaU6blr1alrCll7jzRMTlcjKZHPog6QLe
         tZcW4ouRMc1CIHMTQ877MLCrB5I7mTiFPr6llAzIDg65UKtj7A6VhbRpsJG8mfF6J7k/
         FS5Q==
X-Forwarded-Encrypted: i=1; AJvYcCW5rOcoC00/1Qub/aZ077mLOca+O+44GVi/tUTnULBP/Vf0mLQjthh7XmMGGod4YcFzRE7pjDD6K3rEITI2o0BOdo/5IDUGEJo=
X-Gm-Message-State: AOJu0Yw8QfneXaINsqZz+QSctRjm67pt++zLtoyFxoBmWBiTCI7Gc91c
	PYeCzRT3kQFXsR/qNtP8YtDGyJ8sZfpspAzlEvussxNCMg+8V25ugbjyfxbg
X-Google-Smtp-Source: AGHT+IFKJM11SpLqzLhMNwJkG2eukvCYMGlq1XGEliB8Y1HtC0PnUS/o6LTUxo9l7oWSL7enVLuwTQ==
X-Received: by 2002:a5d:457a:0:b0:35f:1907:813c with SMTP id ffacd0b85a97d-35f190782d2mr2592280f8f.31.1717988031179;
        Sun, 09 Jun 2024 19:53:51 -0700 (PDT)
Received: from [192.168.42.136] ([148.252.129.53])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35ef5d2da31sm9741966f8f.14.2024.06.09.19.53.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Jun 2024 19:53:50 -0700 (PDT)
Message-ID: <97fe853f-1963-4304-b371-5fe596ae5fcf@gmail.com>
Date: Mon, 10 Jun 2024 03:53:51 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 5/9] io_uring: support SQE group
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
References: <20240511001214.173711-1-ming.lei@redhat.com>
 <20240511001214.173711-6-ming.lei@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240511001214.173711-6-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/11/24 01:12, Ming Lei wrote:
> SQE group is defined as one chain of SQEs starting with the first SQE that
> has IOSQE_SQE_GROUP set, and ending with the first subsequent SQE that
> doesn't have it set, and it is similar with chain of linked SQEs.

The main concern stays same, it adds overhead nearly to every
single hot function I can think of, as well as lots of
complexity.

Another minor issue is REQ_F_INFLIGHT, as explained before,
cancellation has to be able to find all REQ_F_INFLIGHT
requests. Requests you add to a group can have that flag
but are not discoverable by core io_uring code.

Another note, I'll be looking deeper into this patch, there
is too much of random tossing around of requests / refcounting
and other dependencies, as well as odd intertwinings with
other parts.

> Not like linked SQEs, each sqe is issued after the previous one is completed.
> All SQEs in one group are submitted in parallel, so there isn't any dependency
> among SQEs in one group.
> 
> The 1st SQE is group leader, and the other SQEs are group member. The whole
> group share single IOSQE_IO_LINK and IOSQE_IO_DRAIN from group leader, and
> the two flags are ignored for group members.
> 
> When the group is in one link chain, this group isn't submitted until the
> previous SQE or group is completed. And the following SQE or group can't
> be started if this group isn't completed. Failure from any group member will
> fail the group leader, then the link chain can be terminated.
> 
> When IOSQE_IO_DRAIN is set for group leader, all requests in this group and
> previous requests submitted are drained. Given IOSQE_IO_DRAIN can be set for
> group leader only, we respect IO_DRAIN by always completing group leader as
> the last one in the group.
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
>   include/linux/io_uring_types.h |  12 ++
>   include/uapi/linux/io_uring.h  |   4 +
>   io_uring/io_uring.c            | 255 +++++++++++++++++++++++++++++++--
>   io_uring/io_uring.h            |  16 +++
>   io_uring/timeout.c             |   2 +
>   5 files changed, 277 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 7a6b190c7da7..62311b0f0e0b 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -666,6 +674,10 @@ struct io_kiocb {
>   		u64			extra1;
>   		u64			extra2;
>   	} big_cqe;
> +
> +	/* all SQE group members linked here for group lead */
> +	struct io_kiocb			*grp_link;
> +	int				grp_refs;
>   };
>   
>   struct io_overflow_cqe {
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index c184c9a312df..b87c5452de43 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -109,7 +109,8 @@
>   			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
>   
>   #define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS | IOSQE_BUFFER_SELECT | \
> -			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
> +			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS | \
> +			IOSQE_SQE_GROUP)
>   
>   #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
>   				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
> @@ -915,6 +916,13 @@ static __always_inline void io_req_commit_cqe(struct io_kiocb *req,
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
>   
> +	/*
> +	 * For group leader, cqe has to be committed after all members are
> +	 * committed, when the request becomes normal one.
> +	 */
> +	if (unlikely(req_is_group_leader(req)))
> +		return;

The copy of it inlined into flush_completions should
maintain a proper fast path.

if (req->flags & (CQE_SKIP | GROUP)) {
	if (req->flags & CQE_SKIP)
		continue;
	if (req->flags & GROUP) {}
}

> +
>   	if (unlikely(!io_fill_cqe_req(ctx, req))) {
>   		if (lockless_cq) {
>   			spin_lock(&ctx->completion_lock);
> @@ -926,6 +934,116 @@ static __always_inline void io_req_commit_cqe(struct io_kiocb *req,
>   	}
>   }
>   
> +static inline bool need_queue_group_members(struct io_kiocb *req)
> +{
> +	return req_is_group_leader(req) && req->grp_link;
> +}
> +
> +/* Can only be called after this request is issued */
> +static inline struct io_kiocb *get_group_leader(struct io_kiocb *req)
> +{
> +	if (req->flags & REQ_F_SQE_GROUP) {
> +		if (req_is_group_leader(req))
> +			return req;
> +		return req->grp_link;

I'm missing something, it seems io_group_sqe() adding all
requests of a group into a singly linked list via ->grp_link,
but here we return it as a leader. Confused.

> +	}
> +	return NULL;
> +}
> +
> +void io_cancel_group_members(struct io_kiocb *req, bool ignore_cqes)
> +{
> +	struct io_kiocb *member = req->grp_link;
> +
> +	while (member) {
> +		struct io_kiocb *next = member->grp_link;
> +
> +		if (ignore_cqes)
> +			member->flags |= REQ_F_CQE_SKIP;
> +		if (!(member->flags & REQ_F_FAIL)) {
> +			req_set_fail(member);
> +			io_req_set_res(member, -ECANCELED, 0);
> +		}
> +		member = next;
> +	}
> +}
> +
> +void io_queue_group_members(struct io_kiocb *req, bool async)
> +{
> +	struct io_kiocb *member = req->grp_link;
> +
> +	if (!member)
> +		return;
> +
> +	while (member) {
> +		struct io_kiocb *next = member->grp_link;
> +
> +		member->grp_link = req;
> +		if (async)
> +			member->flags |= REQ_F_FORCE_ASYNC;
> +
> +		if (unlikely(member->flags & REQ_F_FAIL)) {
> +			io_req_task_queue_fail(member, member->cqe.res);
> +		} else if (member->flags & REQ_F_FORCE_ASYNC) {
> +			io_req_task_queue(member);
> +		} else {
> +			io_queue_sqe(member);
> +		}
> +		member = next;
> +	}
> +	req->grp_link = NULL;
> +}
> +
> +static inline bool __io_complete_group_req(struct io_kiocb *req,
> +			     struct io_kiocb *lead)
> +{
> +	WARN_ON_ONCE(!(req->flags & REQ_F_SQE_GROUP));
> +
> +	if (WARN_ON_ONCE(lead->grp_refs <= 0))
> +		return false;
> +
> +	/*
> +	 * Set linked leader as failed if any member is failed, so
> +	 * the remained link chain can be terminated
> +	 */
> +	if (unlikely((req->flags & REQ_F_FAIL) &&
> +		     ((lead->flags & IO_REQ_LINK_FLAGS) && lead->link)))
> +		req_set_fail(lead);
> +	return !--lead->grp_refs;
> +}
> +
> +/* Complete group request and collect completed leader for freeing */
> +static inline void io_complete_group_req(struct io_kiocb *req,
> +		struct io_wq_work_list *grp_list)
> +{
> +	struct io_kiocb *lead = get_group_leader(req);
> +
> +	if (__io_complete_group_req(req, lead)) {
> +		req->flags &= ~REQ_F_SQE_GROUP;
> +		lead->flags &= ~REQ_F_SQE_GROUP_LEADER;
> +		if (!(lead->flags & REQ_F_CQE_SKIP))
> +			io_req_commit_cqe(lead, lead->ctx->lockless_cq);
> +
> +		if (req != lead) {
> +			/*
> +			 * Add leader to free list if it isn't there
> +			 * otherwise clearing group flag for freeing it
> +			 * in current batch
> +			 */
> +			if (!(lead->flags & REQ_F_SQE_GROUP))
> +				wq_list_add_tail(&lead->comp_list, grp_list);
> +			else
> +				lead->flags &= ~REQ_F_SQE_GROUP;
> +		}
> +	} else if (req != lead) {
> +		req->flags &= ~REQ_F_SQE_GROUP;
> +	} else {
> +		/*
> +		 * Leader's group flag clearing is delayed until it is
> +		 * removed from free list
> +		 */
> +	}
> +}
> +
>   static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
> @@ -1427,6 +1545,17 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
>   						    comp_list);
>   
>   		if (unlikely(req->flags & IO_REQ_CLEAN_SLOW_FLAGS)) {
> +			/*
> +			 * Group leader may be removed twice, don't free it
> +			 * if group flag isn't cleared, when some members
> +			 * aren't completed yet
> +			 */
> +			if (req->flags & REQ_F_SQE_GROUP) {
> +				node = req->comp_list.next;
> +				req->flags &= ~REQ_F_SQE_GROUP;
> +				continue;
> +			}
> +
>   			if (req->flags & REQ_F_REFCOUNT) {
>   				node = req->comp_list.next;
>   				if (!req_ref_put_and_test(req))
> @@ -1459,6 +1588,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   	__must_hold(&ctx->uring_lock)
>   {
>   	struct io_submit_state *state = &ctx->submit_state;
> +	struct io_wq_work_list grp_list = {NULL};
>   	struct io_wq_work_node *node;
>   
>   	__io_cq_lock(ctx);
> @@ -1468,9 +1598,15 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   
>   		if (!(req->flags & REQ_F_CQE_SKIP))
>   			io_req_commit_cqe(req, ctx->lockless_cq);
> +
> +		if (req->flags & REQ_F_SQE_GROUP)

Same note about hot path

> +			io_complete_group_req(req, &grp_list);
>   	}
>   	__io_cq_unlock_post(ctx);
>   
> +	if (!wq_list_empty(&grp_list))
> +		__wq_list_splice(&grp_list, state->compl_reqs.first);

What's the point of splicing it here insted of doing all
that under REQ_F_SQE_GROUP above?

> +
>   	if (!wq_list_empty(&ctx->submit_state.compl_reqs)) {
>   		io_free_batch_list(ctx, state->compl_reqs.first);
>   		INIT_WQ_LIST(&state->compl_reqs);
> @@ -1677,8 +1813,12 @@ static u32 io_get_sequence(struct io_kiocb *req)
>   	struct io_kiocb *cur;
>   
>   	/* need original cached_sq_head, but it was increased for each req */
> -	io_for_each_link(cur, req)
> -		seq--;
> +	io_for_each_link(cur, req) {
> +		if (req_is_group_leader(cur))
> +			seq -= cur->grp_refs;
> +		else
> +			seq--;
> +	}
>   	return seq;
>   }
>   
> @@ -1793,11 +1933,20 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
>   	struct io_kiocb *nxt = NULL;
>   
>   	if (req_ref_put_and_test(req)) {
> -		if (req->flags & IO_REQ_LINK_FLAGS)
> -			nxt = io_req_find_next(req);
> +		/*
> +		 * CQEs have been posted in io_req_complete_post() except
> +		 * for group leader, and we can't advance the link for
> +		 * group leader until its CQE is posted.
> +		 *
> +		 * TODO: try to avoid defer and complete leader in io_wq
> +		 * context directly
> +		 */
> +		if (!req_is_group_leader(req)) {
> +			req->flags |= REQ_F_CQE_SKIP;
> +			if (req->flags & IO_REQ_LINK_FLAGS)
> +				nxt = io_req_find_next(req);
> +		}
>   
> -		/* we have posted CQEs in io_req_complete_post() */
> -		req->flags |= REQ_F_CQE_SKIP;
>   		io_free_req(req);
>   	}
>   	return nxt ? &nxt->work : NULL;
> @@ -1863,6 +2012,8 @@ void io_wq_submit_work(struct io_wq_work *work)
>   		}
>   	}
>   
> +	if (need_queue_group_members(req))
> +		io_queue_group_members(req, true);
>   	do {
>   		ret = io_issue_sqe(req, issue_flags);
>   		if (ret != -EAGAIN)
> @@ -1977,6 +2128,9 @@ static inline void io_queue_sqe(struct io_kiocb *req)
>   	 */
>   	if (unlikely(ret))
>   		io_queue_async(req, ret);
> +
> +	if (need_queue_group_members(req))
> +		io_queue_group_members(req, false);

Request ownership is considered to be handed further at this
point and requests should not be touched. Only ret==0 from
io_issue_sqe it's still ours, but again it's handed somewhere
by io_queue_async().

>   }
>   
>   static void io_queue_sqe_fallback(struct io_kiocb *req)
> @@ -2142,6 +2296,56 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
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
> +		req->flags &= ~(IO_REQ_LINK_FLAGS | REQ_F_IO_DRAIN);
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
> +		return lead;
> +	} else if (req->flags & REQ_F_SQE_GROUP) {
> +		group->head = req;
> +		group->last = req;
> +		req->grp_refs = 1;
> +		req->flags |= REQ_F_SQE_GROUP_LEADER;
> +		return NULL;
> +	} else {
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
> +
> +	return io_group_sqe(link, req);
> +}
> +
>   static __cold int io_submit_fail_link(struct io_submit_link *link,
>   				      struct io_kiocb *req, int ret)
>   {
> @@ -2180,11 +2384,18 @@ static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
>   	struct io_submit_link *link = &ctx->submit_state.link;
> +	struct io_submit_link *group = &ctx->submit_state.group;
>   
>   	trace_io_uring_req_failed(sqe, req, ret);
>   
>   	req_fail_link_node(req, ret);
>   
> +	if (group->head || (req->flags & REQ_F_SQE_GROUP)) {
> +		req = io_submit_fail_group(group, req);
> +		if (!req)
> +			return 0;
> +	}
> +
>   	/* cover both linked and non-linked request */
>   	return io_submit_fail_link(link, req, ret);
>   }
> @@ -2232,7 +2443,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>   			 const struct io_uring_sqe *sqe)
>   	__must_hold(&ctx->uring_lock)
>   {
> -	struct io_submit_link *link = &ctx->submit_state.link;
> +	struct io_submit_state *state = &ctx->submit_state;
>   	int ret;
>   
>   	ret = io_init_req(ctx, req, sqe);
> @@ -2241,9 +2452,17 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>   
>   	trace_io_uring_submit_req(req);
>   
> -	if (unlikely(link->head || (req->flags & (IO_REQ_LINK_FLAGS |
> -				    REQ_F_FORCE_ASYNC | REQ_F_FAIL)))) {
> -		req = io_link_sqe(link, req);
> +	if (unlikely(state->group.head ||

A note rather to myself and for the future, all theese checks
including links and groups can be folded under one common if.

> +		     (req->flags & REQ_F_SQE_GROUP))) {
> +		req = io_group_sqe(&state->group, req);
> +		if (!req)
> +			return 0;
> +	}
> +
> +	if (unlikely(state->link.head ||
> +		     (req->flags & (IO_REQ_LINK_FLAGS | REQ_F_FORCE_ASYNC |
> +				    REQ_F_FAIL)))) {
> +		req = io_link_sqe(&state->link, req);
>   		if (!req)
>   			return 0;
>   	}
> @@ -2258,6 +2477,17 @@ static void io_submit_state_end(struct io_ring_ctx *ctx)
>   {
>   	struct io_submit_state *state = &ctx->submit_state;
>   
> +	/* the last member must set REQ_F_SQE_GROUP */
> +	if (unlikely(state->group.head)) {
> +		struct io_kiocb *lead = state->group.head;
> +
> +		state->group.last->grp_link = NULL;
> +		if (lead->flags & IO_REQ_LINK_FLAGS)
> +			io_link_sqe(&state->link, lead);
> +		else
> +			io_queue_sqe_fallback(lead);
> +	}
> +
>   	if (unlikely(state->link.head))
>   		io_queue_sqe_fallback(state->link.head);
>   	/* flush only after queuing links as they can generate completions */
> @@ -2277,6 +2507,7 @@ static void io_submit_state_start(struct io_submit_state *state,
>   	state->submit_nr = max_ios;
>   	/* set only head, no need to init link_last in advance */
>   	state->link.head = NULL;
> +	state->group.head = NULL;
>   }
>   
>   static void io_commit_sqring(struct io_ring_ctx *ctx)
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 624ca9076a50..b11db3bdd8d8 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -67,6 +67,8 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res);
>   bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
>   bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
>   void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
> +void io_queue_group_members(struct io_kiocb *req, bool async);
> +void io_cancel_group_members(struct io_kiocb *req, bool ignore_cqes);
>   
>   struct file *io_file_get_normal(struct io_kiocb *req, int fd);
>   struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
> @@ -342,6 +344,16 @@ static inline void io_tw_lock(struct io_ring_ctx *ctx, struct io_tw_state *ts)
>   	lockdep_assert_held(&ctx->uring_lock);
>   }
>   
> +static inline bool req_is_group_leader(struct io_kiocb *req)
> +{
> +	return req->flags & REQ_F_SQE_GROUP_LEADER;
> +}
> +
> +static inline bool req_is_group_member(struct io_kiocb *req)
> +{
> +	return !req_is_group_leader(req) && (req->flags & REQ_F_SQE_GROUP);
> +}
> +
>   /*
>    * Don't complete immediately but use deferred completion infrastructure.
>    * Protected by ->uring_lock and can only be used either with
> @@ -355,6 +367,10 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
>   	lockdep_assert_held(&req->ctx->uring_lock);
>   
>   	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
> +
> +	/* members may not be issued when leader is completed */
> +	if (unlikely(req_is_group_leader(req) && req->grp_link))
> +		io_queue_group_members(req, false);
>   }
>   
>   static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)

-- 
Pavel Begunkov

