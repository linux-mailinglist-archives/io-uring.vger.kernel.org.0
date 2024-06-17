Return-Path: <io-uring+bounces-2235-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5DCD90A2F6
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 05:55:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB7241C21384
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 03:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9AB41D688;
	Mon, 17 Jun 2024 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H+I73tz9"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF7BA31
	for <io-uring@vger.kernel.org>; Mon, 17 Jun 2024 03:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718596496; cv=none; b=rTzaK6FhgFaR2eQ/HchowFCBtMYfNzkar2SQh0mVYhuLGQfwfN1Mc4FMXydMABh+FZpYjSWxGWdF7Q0XVFKegKKpYIWioqOojWBHZ4YuY5EQgvfS/y7L6hmcGhM2amz6NO3ar+rWS96inUhjqvzyho4eiDP2n2OSz3WLFKkzbHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718596496; c=relaxed/simple;
	bh=cPjR8KS8RP6Xoy+EMpwgxuC70e3KktkumW9L5k4ASME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PtcGpFY04quD4uR3ua1DD/BAKjpKyL3kih8/ytANmg1u7sMTNs5spgQtowr5nsk46dbfm8Uz7GlUwp0QDCGWzcY9uKWGoA+uzCECW83wE0N+FpBf4vQ95ITHXzaaoXKsRwTtNl3c1qX9dmBkDQ45ZToL2vjySCCxnuTyIJfpI5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H+I73tz9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718596492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N0Fuf9hsx/rN40OII0BoWEnnGCP2nN8C0VoUryetpso=;
	b=H+I73tz9V/ygnji3+MasaikZMRAoQsQ1LK20UF/eljp8XJDlDpfZ0URh84eDBsL1EmV9a1
	u+b4arlNMK/4Q93TWzmMazmxRr7MF8sEgsfEuNC+Okr6oHDIMMHgZV/0OzyBYguiNnkF1q
	/Xzb5ILuniIP35cFtntJtab7cCbt2/s=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-581-b36gxjA1MFyAcxAhxANZgw-1; Sun,
 16 Jun 2024 23:54:46 -0400
X-MC-Unique: b36gxjA1MFyAcxAhxANZgw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7CCD919560B7;
	Mon, 17 Jun 2024 03:54:44 +0000 (UTC)
Received: from fedora (unknown [10.72.112.55])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B99323000218;
	Mon, 17 Jun 2024 03:54:39 +0000 (UTC)
Date: Mon, 17 Jun 2024 11:54:34 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>,
	ming.lei@redhat.com
Subject: Re: [PATCH V3 5/9] io_uring: support SQE group
Message-ID: <Zm+zemW1Bi5ZF9DE@fedora>
References: <20240511001214.173711-1-ming.lei@redhat.com>
 <20240511001214.173711-6-ming.lei@redhat.com>
 <97fe853f-1963-4304-b371-5fe596ae5fcf@gmail.com>
 <ZmpPONHc8GajjoEm@fedora>
 <f29e662c-5959-4b90-845a-0e3c81a174e6@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f29e662c-5959-4b90-845a-0e3c81a174e6@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Sun, Jun 16, 2024 at 08:13:26PM +0100, Pavel Begunkov wrote:
> On 6/13/24 02:45, Ming Lei wrote:
> > On Mon, Jun 10, 2024 at 03:53:51AM +0100, Pavel Begunkov wrote:
> > > On 5/11/24 01:12, Ming Lei wrote:
> > > > SQE group is defined as one chain of SQEs starting with the first SQE that
> > > > has IOSQE_SQE_GROUP set, and ending with the first subsequent SQE that
> > > > doesn't have it set, and it is similar with chain of linked SQEs.
> > > 
> > > The main concern stays same, it adds overhead nearly to every
> > > single hot function I can think of, as well as lots of
> > > complexity.
> > 
> > Almost every sqe group change is covered by REQ_F_SQE_GROUP, so I am
> > not clear what the added overhead is.
> 
> Yes, and there is a dozen of such in the hot path.

req->flags is supposed to be L1-cached in all these hot paths, and the
check is basically zero cost, so SQE_GROUP shouldn't add extra cost for
existed io_uring core code path.

> 
> > > Another minor issue is REQ_F_INFLIGHT, as explained before,
> > > cancellation has to be able to find all REQ_F_INFLIGHT
> > > requests. Requests you add to a group can have that flag
> > > but are not discoverable by core io_uring code.
> > 
> > OK, we can deal with it by setting leader as REQ_F_INFLIGHT if the
> > flag is set for any member, since all members are guaranteed to
> > be drained when leader is completed. Will do it in V4.
> 
> Or fail if see one, that's also fine. REQ_F_INFLIGHT is
> only set for POLL requests polling another io_uring.

It is set for read-write/tee/splice op with normal file too, so looks
not safe to fail.

> 
> > > Another note, I'll be looking deeper into this patch, there
> > > is too much of random tossing around of requests / refcounting
> > > and other dependencies, as well as odd intertwinings with
> > > other parts.
> > 
> > The only thing wrt. request refcount is for io-wq, since request
> > reference is grabbed when the req is handled in io-wq context, and
> > group leader need to be completed after all members are done. That
> > is all special change wrt. request refcounting.
> 
> I rather mean refcounting the group leader, even if it's not
> atomic.

If you mean reusing req->refs for refcounting the group leader, it may
not work, cause member can complete from io-wq, but leader may not.
Meantime using dedicated ->grp_refs actually simplifies things a lot.

> 
> > > > diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> > > > index 7a6b190c7da7..62311b0f0e0b 100644
> > > > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > > > index c184c9a312df..b87c5452de43 100644
> > > > --- a/io_uring/io_uring.c
> > > > +++ b/io_uring/io_uring.c
> ...
> > > >    	}
> > > >    }
> > > > +static inline bool need_queue_group_members(struct io_kiocb *req)
> > > > +{
> > > > +	return req_is_group_leader(req) && req->grp_link;
> > > > +}
> > > > +
> > > > +/* Can only be called after this request is issued */
> > > > +static inline struct io_kiocb *get_group_leader(struct io_kiocb *req)
> > > > +{
> > > > +	if (req->flags & REQ_F_SQE_GROUP) {
> > > > +		if (req_is_group_leader(req))
> > > > +			return req;
> > > > +		return req->grp_link;
> > > 
> > > I'm missing something, it seems io_group_sqe() adding all
> > > requests of a group into a singly linked list via ->grp_link,
> > > but here we return it as a leader. Confused.
> > 
> > ->grp_link stores the singly linked list for group leader, and
> > the same field stores the group leader pointer for group member requests.
> > For later, we can add one union field to make code more readable.
> > Will do that in V4.
> 
> So you're repurposing it in io_queue_group_members(). Since
> it has different meaning at different stages of execution,
> it warrants a comment (unless there is one I missed).

OK, either adding comment or another union field for it.

> 
> > > > +	}
> > > > +	return NULL;
> > > > +}
> > > > +
> > > > +void io_cancel_group_members(struct io_kiocb *req, bool ignore_cqes)
> > > > +{
> > > > +	struct io_kiocb *member = req->grp_link;
> > > > +
> > > > +	while (member) {
> > > > +		struct io_kiocb *next = member->grp_link;
> > > > +
> > > > +		if (ignore_cqes)
> > > > +			member->flags |= REQ_F_CQE_SKIP;
> > > > +		if (!(member->flags & REQ_F_FAIL)) {
> > > > +			req_set_fail(member);
> > > > +			io_req_set_res(member, -ECANCELED, 0);
> > > > +		}
> > > > +		member = next;
> > > > +	}
> > > > +}
> > > > +
> > > > +void io_queue_group_members(struct io_kiocb *req, bool async)
> > > > +{
> > > > +	struct io_kiocb *member = req->grp_link;
> > > > +
> > > > +	if (!member)
> > > > +		return;
> > > > +
> > > > +	while (member) {
> > > > +		struct io_kiocb *next = member->grp_link;
> > > > +
> > > > +		member->grp_link = req;
> > > > +		if (async)
> > > > +			member->flags |= REQ_F_FORCE_ASYNC;
> > > > +
> > > > +		if (unlikely(member->flags & REQ_F_FAIL)) {
> > > > +			io_req_task_queue_fail(member, member->cqe.res);
> > > > +		} else if (member->flags & REQ_F_FORCE_ASYNC) {
> > > > +			io_req_task_queue(member);
> > > > +		} else {
> > > > +			io_queue_sqe(member);
> 
> io_req_queue_tw_complete() please, just like links deal
> with it, so it's executed in a well known context without
> jumping ahead of other requests.

members needn't to be queued until leader is completed for plain
SQE_GROUP, otherwise perf can drop.

> 
> > > > +		}
> > > > +		member = next;
> > > > +	}
> > > > +	req->grp_link = NULL;
> > > > +}
> > > > +
> > > > +static inline bool __io_complete_group_req(struct io_kiocb *req,
> > > > +			     struct io_kiocb *lead)
> > > > +{
> > > > +	WARN_ON_ONCE(!(req->flags & REQ_F_SQE_GROUP));
> > > > +
> > > > +	if (WARN_ON_ONCE(lead->grp_refs <= 0))
> > > > +		return false;
> > > > +
> > > > +	/*
> > > > +	 * Set linked leader as failed if any member is failed, so
> > > > +	 * the remained link chain can be terminated
> > > > +	 */
> > > > +	if (unlikely((req->flags & REQ_F_FAIL) &&
> > > > +		     ((lead->flags & IO_REQ_LINK_FLAGS) && lead->link)))
> > > > +		req_set_fail(lead);
> > > > +	return !--lead->grp_refs;
> > > > +}
> > > > +
> > > > +/* Complete group request and collect completed leader for freeing */
> > > > +static inline void io_complete_group_req(struct io_kiocb *req,
> > > > +		struct io_wq_work_list *grp_list)
> > > > +{
> > > > +	struct io_kiocb *lead = get_group_leader(req);
> > > > +
> > > > +	if (__io_complete_group_req(req, lead)) {
> > > > +		req->flags &= ~REQ_F_SQE_GROUP;
> > > > +		lead->flags &= ~REQ_F_SQE_GROUP_LEADER;
> > > > +		if (!(lead->flags & REQ_F_CQE_SKIP))
> > > > +			io_req_commit_cqe(lead, lead->ctx->lockless_cq);
> > > > +
> > > > +		if (req != lead) {
> > > > +			/*
> > > > +			 * Add leader to free list if it isn't there
> > > > +			 * otherwise clearing group flag for freeing it
> > > > +			 * in current batch
> > > > +			 */
> > > > +			if (!(lead->flags & REQ_F_SQE_GROUP))
> > > > +				wq_list_add_tail(&lead->comp_list, grp_list);
> > > > +			else
> > > > +				lead->flags &= ~REQ_F_SQE_GROUP;
> > > > +		}
> > > > +	} else if (req != lead) {
> > > > +		req->flags &= ~REQ_F_SQE_GROUP;
> > > > +	} else {
> > > > +		/*
> > > > +		 * Leader's group flag clearing is delayed until it is
> > > > +		 * removed from free list
> > > > +		 */
> > > > +	}
> > > > +}
> > > > +
> > > >    static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
> > > >    {
> > > >    	struct io_ring_ctx *ctx = req->ctx;
> > > > @@ -1427,6 +1545,17 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
> > > >    						    comp_list);
> > > >    		if (unlikely(req->flags & IO_REQ_CLEAN_SLOW_FLAGS)) {
> > > > +			/*
> > > > +			 * Group leader may be removed twice, don't free it
> > > > +			 * if group flag isn't cleared, when some members
> > > > +			 * aren't completed yet
> > > > +			 */
> > > > +			if (req->flags & REQ_F_SQE_GROUP) {
> > > > +				node = req->comp_list.next;
> > > > +				req->flags &= ~REQ_F_SQE_GROUP;
> > > > +				continue;
> > > > +			}
> > > > +
> > > >    			if (req->flags & REQ_F_REFCOUNT) {
> > > >    				node = req->comp_list.next;
> > > >    				if (!req_ref_put_and_test(req))
> > > > @@ -1459,6 +1588,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
> > > >    	__must_hold(&ctx->uring_lock)
> > > >    {
> > > >    	struct io_submit_state *state = &ctx->submit_state;
> > > > +	struct io_wq_work_list grp_list = {NULL};
> > > >    	struct io_wq_work_node *node;
> > > >    	__io_cq_lock(ctx);
> > > > @@ -1468,9 +1598,15 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
> > > >    		if (!(req->flags & REQ_F_CQE_SKIP))
> > > >    			io_req_commit_cqe(req, ctx->lockless_cq);
> > > > +
> > > > +		if (req->flags & REQ_F_SQE_GROUP)
> > > 
> > > Same note about hot path
> > > 
> > > > +			io_complete_group_req(req, &grp_list);
> > > >    	}
> > > >    	__io_cq_unlock_post(ctx);
> > > > +	if (!wq_list_empty(&grp_list))
> > > > +		__wq_list_splice(&grp_list, state->compl_reqs.first);
> > > 
> > > What's the point of splicing it here insted of doing all
> > > that under REQ_F_SQE_GROUP above?
> > 
> > As mentioned, group leader can't be completed until all members are
> > done, so any leaders in the current list have to be moved to this
> > local list for deferred completion. That should be the only tricky
> > part of the whole sqe group implementation.
> > 
> > > 
> > > > +
> > > >    	if (!wq_list_empty(&ctx->submit_state.compl_reqs)) {
> > > >    		io_free_batch_list(ctx, state->compl_reqs.first);
> > > >    		INIT_WQ_LIST(&state->compl_reqs);
> ...
> > > > @@ -1863,6 +2012,8 @@ void io_wq_submit_work(struct io_wq_work *work)
> > > >    		}
> > > >    	}
> > > > +	if (need_queue_group_members(req))
> > > > +		io_queue_group_members(req, true);
> > > >    	do {
> > > >    		ret = io_issue_sqe(req, issue_flags);
> > > >    		if (ret != -EAGAIN)
> > > > @@ -1977,6 +2128,9 @@ static inline void io_queue_sqe(struct io_kiocb *req)
> > > >    	 */
> > > >    	if (unlikely(ret))
> > > >    		io_queue_async(req, ret);
> > > > +
> > > > +	if (need_queue_group_members(req))
> > > > +		io_queue_group_members(req, false);
> > > 
> > > Request ownership is considered to be handed further at this
> > > point and requests should not be touched. Only ret==0 from
> > > io_issue_sqe it's still ours, but again it's handed somewhere
> > > by io_queue_async().
> > 
> > Yes, you are right.
> > 
> > And it has been fixed in my local tree:
> > 
> > @@ -2154,8 +2154,7 @@ static inline void io_queue_sqe(struct io_kiocb *req)
> >           */
> >          if (unlikely(ret))
> >                  io_queue_async(req, ret);
> > -
> > -       if (need_queue_group_members(req))
> > +       else if (need_queue_group_members(req))
> >                  io_queue_group_members(req, false);
> >   }
> 
> In the else branch you don't own the request anymore
> and shouldn't be poking into it.

In theory, it is yes, but now all requests won't be freed unless
returning from io_queue_sqe(), and it needs to be commented
carefully.

> 
> It looks like you're trying to do io_queue_group_members()
> when previously the request would get completed. It's not

It is only true for REQ_F_SQE_GROUP_DEP, and there isn't such
dependency for plain SQE_GROUP.

> the right place, and apart from whack'a'moled
> io_wq_submit_work() there is also io_poll_issue() missed.
> 
> Seems __io_submit_flush_completions() / io_free_batch_list()
> would be more appropriate, and you already have a chunk with
> GROUP check in there handling the leader appearing in there
> twice.

As mentioned, we need to queue members with leader together
if there isn't dependency among them.

> 
> 
> > > >    }
> > > >    static void io_queue_sqe_fallback(struct io_kiocb *req)
> ...
> > > > @@ -2232,7 +2443,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
> > > >    			 const struct io_uring_sqe *sqe)
> > > >    	__must_hold(&ctx->uring_lock)
> > > >    {
> > > > -	struct io_submit_link *link = &ctx->submit_state.link;
> > > > +	struct io_submit_state *state = &ctx->submit_state;
> > > >    	int ret;
> > > >    	ret = io_init_req(ctx, req, sqe);
> > > > @@ -2241,9 +2452,17 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
> > > >    	trace_io_uring_submit_req(req);
> > > > -	if (unlikely(link->head || (req->flags & (IO_REQ_LINK_FLAGS |
> > > > -				    REQ_F_FORCE_ASYNC | REQ_F_FAIL)))) {
> > > > -		req = io_link_sqe(link, req);
> > > > +	if (unlikely(state->group.head ||
> > > 
> > > A note rather to myself and for the future, all theese checks
> > > including links and groups can be folded under one common if.
> > 
> > Sorry, I may not get the idea, can you provide one example?
> 
> To be clear, not suggesting you doing it.
> 
> Simplifying:
> 
> init_req() {
> 	if (req->flags & GROUP|LINK) {
> 		ctx->assembling;
> 	}
> }
> 
> io_submit_sqe() {
> 	init_req();
> 
> 	if (ctx->assembling) {
> 		check_groups/links();
> 		if (done);
> 			ctx->assembling = false;
> 	}
> }

OK, I can work toward this way, and it is just to replace check over
group.head/link.head & link/group flag with ->assembling, meantime
with cost of setting ctx->assembling.



Thanks,
Ming


