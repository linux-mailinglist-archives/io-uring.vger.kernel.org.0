Return-Path: <io-uring+bounces-2199-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 644F4906142
	for <lists+io-uring@lfdr.de>; Thu, 13 Jun 2024 03:45:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7D64B21FD6
	for <lists+io-uring@lfdr.de>; Thu, 13 Jun 2024 01:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 555657F9;
	Thu, 13 Jun 2024 01:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LRbaghmz"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4D428F4
	for <io-uring@vger.kernel.org>; Thu, 13 Jun 2024 01:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718243147; cv=none; b=JMaQkejL210coa+uohvqOaFZJW5pVTuiEhjlzuYaKLXLq7TiKzG+GuLBKIIOjvixszwkjEMqgzrc2twGi6EKp/Ej20xvTUYqV9066vnRy4rau0UhcOTfe2V2pO5eXl8lB1crLVDQySvGh6lrLTdYctrhll+coJMxKM1TmXDSaRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718243147; c=relaxed/simple;
	bh=7mo/aLVvgUWXlBsBfy2O/UMzQiEsWokbOpn580GNic8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wfi1zwzJ1LYN0600aqs+35bWpxuRn7XGdIRETXiwz2VqTe9vHbmlTSxl1PHt1+DYeN/kEBaqjBJPMaYUK+cKnuyqhUJxGGogWOH0nuWa1e2qEeQ9U+A5Ny03VPEKokwmjQQBnDP0MOojpXHyKCxQ72qNkcPkEA623/yR1j04Nx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LRbaghmz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718243143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3mVxgZTRzuDlMN/EimwUIIsXsWNAdTkbYVXvD7yO6z4=;
	b=LRbaghmzYtkRZT9mTrIjkF0NzL+Acg3SNtdzr1igFBs9C91lsyG+uxcU1DU1kODw5/2fs6
	/tDQXGnNgpcgRJsDnP2CzZJJmCihGlAQfZAK4WAPhZPlDbJuSJTvNfeUrIrQpYvOTvjgWM
	YM7USax1dNbYDk4DOobQpEKZGAzgfHs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-308-W8axJYbWNSmsgd-xvhyqWA-1; Wed,
 12 Jun 2024 21:45:40 -0400
X-MC-Unique: W8axJYbWNSmsgd-xvhyqWA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 267D9195608C;
	Thu, 13 Jun 2024 01:45:39 +0000 (UTC)
Received: from fedora (unknown [10.72.112.209])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 13B8419560AA;
	Thu, 13 Jun 2024 01:45:33 +0000 (UTC)
Date: Thu, 13 Jun 2024 09:45:28 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>,
	ming.lei@redhat.com
Subject: Re: [PATCH V3 5/9] io_uring: support SQE group
Message-ID: <ZmpPONHc8GajjoEm@fedora>
References: <20240511001214.173711-1-ming.lei@redhat.com>
 <20240511001214.173711-6-ming.lei@redhat.com>
 <97fe853f-1963-4304-b371-5fe596ae5fcf@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97fe853f-1963-4304-b371-5fe596ae5fcf@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Mon, Jun 10, 2024 at 03:53:51AM +0100, Pavel Begunkov wrote:
> On 5/11/24 01:12, Ming Lei wrote:
> > SQE group is defined as one chain of SQEs starting with the first SQE that
> > has IOSQE_SQE_GROUP set, and ending with the first subsequent SQE that
> > doesn't have it set, and it is similar with chain of linked SQEs.
> 
> The main concern stays same, it adds overhead nearly to every
> single hot function I can think of, as well as lots of
> complexity.

Almost every sqe group change is covered by REQ_F_SQE_GROUP, so I am
not clear what the added overhead is.

> 
> Another minor issue is REQ_F_INFLIGHT, as explained before,
> cancellation has to be able to find all REQ_F_INFLIGHT
> requests. Requests you add to a group can have that flag
> but are not discoverable by core io_uring code.

OK, we can deal with it by setting leader as REQ_F_INFLIGHT if the
flag is set for any member, since all members are guaranteed to
be drained when leader is completed. Will do it in V4.

> 
> Another note, I'll be looking deeper into this patch, there
> is too much of random tossing around of requests / refcounting
> and other dependencies, as well as odd intertwinings with
> other parts.

The only thing wrt. request refcount is for io-wq, since request
reference is grabbed when the req is handled in io-wq context, and
group leader need to be completed after all members are done. That
is all special change wrt. request refcounting.

> 
> > Not like linked SQEs, each sqe is issued after the previous one is completed.
> > All SQEs in one group are submitted in parallel, so there isn't any dependency
> > among SQEs in one group.
> > 
> > The 1st SQE is group leader, and the other SQEs are group member. The whole
> > group share single IOSQE_IO_LINK and IOSQE_IO_DRAIN from group leader, and
> > the two flags are ignored for group members.
> > 
> > When the group is in one link chain, this group isn't submitted until the
> > previous SQE or group is completed. And the following SQE or group can't
> > be started if this group isn't completed. Failure from any group member will
> > fail the group leader, then the link chain can be terminated.
> > 
> > When IOSQE_IO_DRAIN is set for group leader, all requests in this group and
> > previous requests submitted are drained. Given IOSQE_IO_DRAIN can be set for
> > group leader only, we respect IO_DRAIN by always completing group leader as
> > the last one in the group.
> > 
> > Working together with IOSQE_IO_LINK, SQE group provides flexible way to
> > support N:M dependency, such as:
> > 
> > - group A is chained with group B together
> > - group A has N SQEs
> > - group B has M SQEs
> > 
> > then M SQEs in group B depend on N SQEs in group A.
> > 
> > N:M dependency can support some interesting use cases in efficient way:
> > 
> > 1) read from multiple files, then write the read data into single file
> > 
> > 2) read from single file, and write the read data into multiple files
> > 
> > 3) write same data into multiple files, and read data from multiple files and
> > compare if correct data is written
> > 
> > Also IOSQE_SQE_GROUP takes the last bit in sqe->flags, but we still can
> > extend sqe->flags with one uring context flag, such as use __pad3 for
> > non-uring_cmd OPs and part of uring_cmd_flags for uring_cmd OP.
> > 
> > Suggested-by: Kevin Wolf <kwolf@redhat.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   include/linux/io_uring_types.h |  12 ++
> >   include/uapi/linux/io_uring.h  |   4 +
> >   io_uring/io_uring.c            | 255 +++++++++++++++++++++++++++++++--
> >   io_uring/io_uring.h            |  16 +++
> >   io_uring/timeout.c             |   2 +
> >   5 files changed, 277 insertions(+), 12 deletions(-)
> > 
> > diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> > index 7a6b190c7da7..62311b0f0e0b 100644
> > --- a/include/linux/io_uring_types.h
> > +++ b/include/linux/io_uring_types.h
> > @@ -666,6 +674,10 @@ struct io_kiocb {
> >   		u64			extra1;
> >   		u64			extra2;
> >   	} big_cqe;
> > +
> > +	/* all SQE group members linked here for group lead */
> > +	struct io_kiocb			*grp_link;
> > +	int				grp_refs;
> >   };
> >   struct io_overflow_cqe {
> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > index c184c9a312df..b87c5452de43 100644
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> > @@ -109,7 +109,8 @@
> >   			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
> >   #define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS | IOSQE_BUFFER_SELECT | \
> > -			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
> > +			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS | \
> > +			IOSQE_SQE_GROUP)
> >   #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
> >   				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
> > @@ -915,6 +916,13 @@ static __always_inline void io_req_commit_cqe(struct io_kiocb *req,
> >   {
> >   	struct io_ring_ctx *ctx = req->ctx;
> > +	/*
> > +	 * For group leader, cqe has to be committed after all members are
> > +	 * committed, when the request becomes normal one.
> > +	 */
> > +	if (unlikely(req_is_group_leader(req)))
> > +		return;
> 
> The copy of it inlined into flush_completions should
> maintain a proper fast path.
> 
> if (req->flags & (CQE_SKIP | GROUP)) {
> 	if (req->flags & CQE_SKIP)
> 		continue;
> 	if (req->flags & GROUP) {}

OK, I will try to do that in above way.

> }
> 
> > +
> >   	if (unlikely(!io_fill_cqe_req(ctx, req))) {
> >   		if (lockless_cq) {
> >   			spin_lock(&ctx->completion_lock);
> > @@ -926,6 +934,116 @@ static __always_inline void io_req_commit_cqe(struct io_kiocb *req,
> >   	}
> >   }
> > +static inline bool need_queue_group_members(struct io_kiocb *req)
> > +{
> > +	return req_is_group_leader(req) && req->grp_link;
> > +}
> > +
> > +/* Can only be called after this request is issued */
> > +static inline struct io_kiocb *get_group_leader(struct io_kiocb *req)
> > +{
> > +	if (req->flags & REQ_F_SQE_GROUP) {
> > +		if (req_is_group_leader(req))
> > +			return req;
> > +		return req->grp_link;
> 
> I'm missing something, it seems io_group_sqe() adding all
> requests of a group into a singly linked list via ->grp_link,
> but here we return it as a leader. Confused.

->grp_link stores the singly linked list for group leader, and
the same field stores the group leader pointer for group member requests.
For later, we can add one union field to make code more readable.
Will do that in V4.

> 
> > +	}
> > +	return NULL;
> > +}
> > +
> > +void io_cancel_group_members(struct io_kiocb *req, bool ignore_cqes)
> > +{
> > +	struct io_kiocb *member = req->grp_link;
> > +
> > +	while (member) {
> > +		struct io_kiocb *next = member->grp_link;
> > +
> > +		if (ignore_cqes)
> > +			member->flags |= REQ_F_CQE_SKIP;
> > +		if (!(member->flags & REQ_F_FAIL)) {
> > +			req_set_fail(member);
> > +			io_req_set_res(member, -ECANCELED, 0);
> > +		}
> > +		member = next;
> > +	}
> > +}
> > +
> > +void io_queue_group_members(struct io_kiocb *req, bool async)
> > +{
> > +	struct io_kiocb *member = req->grp_link;
> > +
> > +	if (!member)
> > +		return;
> > +
> > +	while (member) {
> > +		struct io_kiocb *next = member->grp_link;
> > +
> > +		member->grp_link = req;
> > +		if (async)
> > +			member->flags |= REQ_F_FORCE_ASYNC;
> > +
> > +		if (unlikely(member->flags & REQ_F_FAIL)) {
> > +			io_req_task_queue_fail(member, member->cqe.res);
> > +		} else if (member->flags & REQ_F_FORCE_ASYNC) {
> > +			io_req_task_queue(member);
> > +		} else {
> > +			io_queue_sqe(member);
> > +		}
> > +		member = next;
> > +	}
> > +	req->grp_link = NULL;
> > +}
> > +
> > +static inline bool __io_complete_group_req(struct io_kiocb *req,
> > +			     struct io_kiocb *lead)
> > +{
> > +	WARN_ON_ONCE(!(req->flags & REQ_F_SQE_GROUP));
> > +
> > +	if (WARN_ON_ONCE(lead->grp_refs <= 0))
> > +		return false;
> > +
> > +	/*
> > +	 * Set linked leader as failed if any member is failed, so
> > +	 * the remained link chain can be terminated
> > +	 */
> > +	if (unlikely((req->flags & REQ_F_FAIL) &&
> > +		     ((lead->flags & IO_REQ_LINK_FLAGS) && lead->link)))
> > +		req_set_fail(lead);
> > +	return !--lead->grp_refs;
> > +}
> > +
> > +/* Complete group request and collect completed leader for freeing */
> > +static inline void io_complete_group_req(struct io_kiocb *req,
> > +		struct io_wq_work_list *grp_list)
> > +{
> > +	struct io_kiocb *lead = get_group_leader(req);
> > +
> > +	if (__io_complete_group_req(req, lead)) {
> > +		req->flags &= ~REQ_F_SQE_GROUP;
> > +		lead->flags &= ~REQ_F_SQE_GROUP_LEADER;
> > +		if (!(lead->flags & REQ_F_CQE_SKIP))
> > +			io_req_commit_cqe(lead, lead->ctx->lockless_cq);
> > +
> > +		if (req != lead) {
> > +			/*
> > +			 * Add leader to free list if it isn't there
> > +			 * otherwise clearing group flag for freeing it
> > +			 * in current batch
> > +			 */
> > +			if (!(lead->flags & REQ_F_SQE_GROUP))
> > +				wq_list_add_tail(&lead->comp_list, grp_list);
> > +			else
> > +				lead->flags &= ~REQ_F_SQE_GROUP;
> > +		}
> > +	} else if (req != lead) {
> > +		req->flags &= ~REQ_F_SQE_GROUP;
> > +	} else {
> > +		/*
> > +		 * Leader's group flag clearing is delayed until it is
> > +		 * removed from free list
> > +		 */
> > +	}
> > +}
> > +
> >   static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
> >   {
> >   	struct io_ring_ctx *ctx = req->ctx;
> > @@ -1427,6 +1545,17 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
> >   						    comp_list);
> >   		if (unlikely(req->flags & IO_REQ_CLEAN_SLOW_FLAGS)) {
> > +			/*
> > +			 * Group leader may be removed twice, don't free it
> > +			 * if group flag isn't cleared, when some members
> > +			 * aren't completed yet
> > +			 */
> > +			if (req->flags & REQ_F_SQE_GROUP) {
> > +				node = req->comp_list.next;
> > +				req->flags &= ~REQ_F_SQE_GROUP;
> > +				continue;
> > +			}
> > +
> >   			if (req->flags & REQ_F_REFCOUNT) {
> >   				node = req->comp_list.next;
> >   				if (!req_ref_put_and_test(req))
> > @@ -1459,6 +1588,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
> >   	__must_hold(&ctx->uring_lock)
> >   {
> >   	struct io_submit_state *state = &ctx->submit_state;
> > +	struct io_wq_work_list grp_list = {NULL};
> >   	struct io_wq_work_node *node;
> >   	__io_cq_lock(ctx);
> > @@ -1468,9 +1598,15 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
> >   		if (!(req->flags & REQ_F_CQE_SKIP))
> >   			io_req_commit_cqe(req, ctx->lockless_cq);
> > +
> > +		if (req->flags & REQ_F_SQE_GROUP)
> 
> Same note about hot path
> 
> > +			io_complete_group_req(req, &grp_list);
> >   	}
> >   	__io_cq_unlock_post(ctx);
> > +	if (!wq_list_empty(&grp_list))
> > +		__wq_list_splice(&grp_list, state->compl_reqs.first);
> 
> What's the point of splicing it here insted of doing all
> that under REQ_F_SQE_GROUP above?

As mentioned, group leader can't be completed until all members are
done, so any leaders in the current list have to be moved to this
local list for deferred completion. That should be the only tricky
part of the whole sqe group implementation.

> 
> > +
> >   	if (!wq_list_empty(&ctx->submit_state.compl_reqs)) {
> >   		io_free_batch_list(ctx, state->compl_reqs.first);
> >   		INIT_WQ_LIST(&state->compl_reqs);
> > @@ -1677,8 +1813,12 @@ static u32 io_get_sequence(struct io_kiocb *req)
> >   	struct io_kiocb *cur;
> >   	/* need original cached_sq_head, but it was increased for each req */
> > -	io_for_each_link(cur, req)
> > -		seq--;
> > +	io_for_each_link(cur, req) {
> > +		if (req_is_group_leader(cur))
> > +			seq -= cur->grp_refs;
> > +		else
> > +			seq--;
> > +	}
> >   	return seq;
> >   }
> > @@ -1793,11 +1933,20 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
> >   	struct io_kiocb *nxt = NULL;
> >   	if (req_ref_put_and_test(req)) {
> > -		if (req->flags & IO_REQ_LINK_FLAGS)
> > -			nxt = io_req_find_next(req);
> > +		/*
> > +		 * CQEs have been posted in io_req_complete_post() except
> > +		 * for group leader, and we can't advance the link for
> > +		 * group leader until its CQE is posted.
> > +		 *
> > +		 * TODO: try to avoid defer and complete leader in io_wq
> > +		 * context directly
> > +		 */
> > +		if (!req_is_group_leader(req)) {
> > +			req->flags |= REQ_F_CQE_SKIP;
> > +			if (req->flags & IO_REQ_LINK_FLAGS)
> > +				nxt = io_req_find_next(req);
> > +		}
> > -		/* we have posted CQEs in io_req_complete_post() */
> > -		req->flags |= REQ_F_CQE_SKIP;
> >   		io_free_req(req);
> >   	}
> >   	return nxt ? &nxt->work : NULL;
> > @@ -1863,6 +2012,8 @@ void io_wq_submit_work(struct io_wq_work *work)
> >   		}
> >   	}
> > +	if (need_queue_group_members(req))
> > +		io_queue_group_members(req, true);
> >   	do {
> >   		ret = io_issue_sqe(req, issue_flags);
> >   		if (ret != -EAGAIN)
> > @@ -1977,6 +2128,9 @@ static inline void io_queue_sqe(struct io_kiocb *req)
> >   	 */
> >   	if (unlikely(ret))
> >   		io_queue_async(req, ret);
> > +
> > +	if (need_queue_group_members(req))
> > +		io_queue_group_members(req, false);
> 
> Request ownership is considered to be handed further at this
> point and requests should not be touched. Only ret==0 from
> io_issue_sqe it's still ours, but again it's handed somewhere
> by io_queue_async().

Yes, you are right.

And it has been fixed in my local tree:

@@ -2154,8 +2154,7 @@ static inline void io_queue_sqe(struct io_kiocb *req)
         */
        if (unlikely(ret))
                io_queue_async(req, ret);
-
-       if (need_queue_group_members(req))
+       else if (need_queue_group_members(req))
                io_queue_group_members(req, false);
 }

> 
> >   }
> >   static void io_queue_sqe_fallback(struct io_kiocb *req)
> > @@ -2142,6 +2296,56 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
> >   	return def->prep(req, sqe);
> >   }
> > +static struct io_kiocb *io_group_sqe(struct io_submit_link *group,
> > +				     struct io_kiocb *req)
> > +{
> > +	/*
> > +	 * Group chain is similar with link chain: starts with 1st sqe with
> > +	 * REQ_F_SQE_GROUP, and ends with the 1st sqe without REQ_F_SQE_GROUP
> > +	 */
> > +	if (group->head) {
> > +		struct io_kiocb *lead = group->head;
> > +
> > +		/* members can't be in link chain, can't be drained */
> > +		req->flags &= ~(IO_REQ_LINK_FLAGS | REQ_F_IO_DRAIN);
> > +		lead->grp_refs += 1;
> > +		group->last->grp_link = req;
> > +		group->last = req;
> > +
> > +		if (req->flags & REQ_F_SQE_GROUP)
> > +			return NULL;
> > +
> > +		req->grp_link = NULL;
> > +		req->flags |= REQ_F_SQE_GROUP;
> > +		group->head = NULL;
> > +		return lead;
> > +	} else if (req->flags & REQ_F_SQE_GROUP) {
> > +		group->head = req;
> > +		group->last = req;
> > +		req->grp_refs = 1;
> > +		req->flags |= REQ_F_SQE_GROUP_LEADER;
> > +		return NULL;
> > +	} else {
> > +		return req;
> > +	}
> > +}
> > +
> > +static __cold struct io_kiocb *io_submit_fail_group(
> > +		struct io_submit_link *link, struct io_kiocb *req)
> > +{
> > +	struct io_kiocb *lead = link->head;
> > +
> > +	/*
> > +	 * Instead of failing eagerly, continue assembling the group link
> > +	 * if applicable and mark the leader with REQ_F_FAIL. The group
> > +	 * flushing code should find the flag and handle the rest
> > +	 */
> > +	if (lead && (lead->flags & IO_REQ_LINK_FLAGS) && !(lead->flags & REQ_F_FAIL))
> > +		req_fail_link_node(lead, -ECANCELED);
> > +
> > +	return io_group_sqe(link, req);
> > +}
> > +
> >   static __cold int io_submit_fail_link(struct io_submit_link *link,
> >   				      struct io_kiocb *req, int ret)
> >   {
> > @@ -2180,11 +2384,18 @@ static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
> >   {
> >   	struct io_ring_ctx *ctx = req->ctx;
> >   	struct io_submit_link *link = &ctx->submit_state.link;
> > +	struct io_submit_link *group = &ctx->submit_state.group;
> >   	trace_io_uring_req_failed(sqe, req, ret);
> >   	req_fail_link_node(req, ret);
> > +	if (group->head || (req->flags & REQ_F_SQE_GROUP)) {
> > +		req = io_submit_fail_group(group, req);
> > +		if (!req)
> > +			return 0;
> > +	}
> > +
> >   	/* cover both linked and non-linked request */
> >   	return io_submit_fail_link(link, req, ret);
> >   }
> > @@ -2232,7 +2443,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
> >   			 const struct io_uring_sqe *sqe)
> >   	__must_hold(&ctx->uring_lock)
> >   {
> > -	struct io_submit_link *link = &ctx->submit_state.link;
> > +	struct io_submit_state *state = &ctx->submit_state;
> >   	int ret;
> >   	ret = io_init_req(ctx, req, sqe);
> > @@ -2241,9 +2452,17 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
> >   	trace_io_uring_submit_req(req);
> > -	if (unlikely(link->head || (req->flags & (IO_REQ_LINK_FLAGS |
> > -				    REQ_F_FORCE_ASYNC | REQ_F_FAIL)))) {
> > -		req = io_link_sqe(link, req);
> > +	if (unlikely(state->group.head ||
> 
> A note rather to myself and for the future, all theese checks
> including links and groups can be folded under one common if.

Sorry, I may not get the idea, can you provide one example?

We need different logics for group and link, meantime group
has to be handled first before linking, since only the group leader
can be linked.


Thanks, 
Ming


