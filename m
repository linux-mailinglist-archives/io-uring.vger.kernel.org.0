Return-Path: <io-uring+bounces-2579-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09BB793BFF9
	for <lists+io-uring@lfdr.de>; Thu, 25 Jul 2024 12:33:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B576B2839DD
	for <lists+io-uring@lfdr.de>; Thu, 25 Jul 2024 10:33:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6B3616A95E;
	Thu, 25 Jul 2024 10:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D5LP8Mui"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19B5198E60
	for <io-uring@vger.kernel.org>; Thu, 25 Jul 2024 10:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721903617; cv=none; b=nbQoclvtjM0XMeZ+5o/Jw3Pzwv4r9/63Tt0WlO/gBFaFRLD/lkZPbwsF0G1pmESGvzaB24cgoak9wSzDHLIBvFyKR+V0i8GAlf6bu6JAAzBgqVYIHfjtnhyoqHkA6pwJ8N+6ZSnvOkRCybT73hg1zwa4e33n6QXYtIb+m4TlL2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721903617; c=relaxed/simple;
	bh=t8EfNAIQs89ioAvtNtLk/PILdSsjztR8hmLdNh/zlS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dmDrq2toLcqjyZeDCWnZV5feRKOnSLVXpx3Rs8GLWr7h2ynZpP5eJk4SUJ9nLGpnz+wO0BOg/3UCzupqZ6Y3y5B/mSQ11rRRdACwCeeTyyb5ey2XbiVJiPwpG441Kuqf6swEsecaURwLcGIwnQ+5Y+BAhgRRUEubQwMoZIWP8XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D5LP8Mui; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721903614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T/kss0pqBfkcMmuy9eEWZx1fj+0pvoMMZEaSz09rFqQ=;
	b=D5LP8Mui+5x6DG3bVBOQCMtytOTKbYrOlkd2GF15GTgxxD3u56E/wOTFLYpGVFHhSx8bYS
	nHlCBx+DkVK5h8QXk0WS5EeF6nK8l03FasSiDphYt1CWxNCRT3KwRiKle99mLTVsUiWt8w
	ZoQb7Rg4yfFa0FDnxk4iGJZ8kHsM+DM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-531-nxZtrHsgPlGviz7EFDJrIg-1; Thu,
 25 Jul 2024 06:33:31 -0400
X-MC-Unique: nxZtrHsgPlGviz7EFDJrIg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65E001955F0D;
	Thu, 25 Jul 2024 10:33:30 +0000 (UTC)
Received: from fedora (unknown [10.72.116.46])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 455C519560AE;
	Thu, 25 Jul 2024 10:33:24 +0000 (UTC)
Date: Thu, 25 Jul 2024 18:33:19 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>,
	ming.lei@redhat.com
Subject: Re: [PATCH V4 4/8] io_uring: support SQE group
Message-ID: <ZqIp7/Ci+abGcZLG@fedora>
References: <20240706031000.310430-1-ming.lei@redhat.com>
 <20240706031000.310430-5-ming.lei@redhat.com>
 <fa5e8098-f72f-43c1-90c1-c3eaebfea3d5@gmail.com>
 <Zp+/hBwCBmKSGy5K@fedora>
 <0fa0c9b9-cfb9-4710-85d0-2f6b4398603c@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fa0c9b9-cfb9-4710-85d0-2f6b4398603c@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Jul 24, 2024 at 02:41:38PM +0100, Pavel Begunkov wrote:
> On 7/23/24 15:34, Ming Lei wrote:
> > Hi Pavel,
> > 
> > Thanks for the review!
> > 
> > On Mon, Jul 22, 2024 at 04:33:05PM +0100, Pavel Begunkov wrote:
> > > On 7/6/24 04:09, Ming Lei wrote:
> > > > SQE group is defined as one chain of SQEs starting with the first SQE that
> > > > has IOSQE_SQE_GROUP set, and ending with the first subsequent SQE that
> > > > doesn't have it set, and it is similar with chain of linked SQEs.
> > > > 
> ...
> > > > ---
> > > > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > > > index 7597344a6440..b5415f0774e5 100644
> > > > --- a/io_uring/io_uring.c
> > > > +++ b/io_uring/io_uring.c
> > > ...
> > > > @@ -421,6 +422,10 @@ static inline void io_req_track_inflight(struct io_kiocb *req)
> > > >    	if (!(req->flags & REQ_F_INFLIGHT)) {
> > > >    		req->flags |= REQ_F_INFLIGHT;
> > > >    		atomic_inc(&req->task->io_uring->inflight_tracked);
> > > > +
> > > > +		/* make members' REQ_F_INFLIGHT discoverable via leader's */
> > > > +		if (req_is_group_member(req))
> > > > +			io_req_track_inflight(req->grp_leader);
> > > 
> > > Requests in a group can be run in parallel with the leader (i.e.
> > > io_issue_sqe()), right? In which case it'd race setting req->flags. We'd
> > > need to think how make it sane.
> > 
> > Yeah, another easier way could be to always mark leader as INFLIGHT.
> 
> I've been thinking a bit more about it, there should be an easier way
> out since we now have lazy file assignment. I sent a patch closing
> a gap, I need to double check if that's enough, but let's forget
> about additional REQ_F_INFLIGHT handling here.

Great, thanks!

> 
> ...
> > > > @@ -1420,6 +1553,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
> > > >    	__must_hold(&ctx->uring_lock)
> > > >    {
> > > >    	struct io_submit_state *state = &ctx->submit_state;
> > > > +	struct io_wq_work_list grp_list = {NULL};
> > > >    	struct io_wq_work_node *node;
> > > >    	__io_cq_lock(ctx);
> > > > @@ -1427,11 +1561,22 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
> > > >    		struct io_kiocb *req = container_of(node, struct io_kiocb,
> > > >    					    comp_list);
> > > > -		if (!(req->flags & REQ_F_CQE_SKIP))
> > > > +		/*
> > > > +		 * For group leader, cqe has to be committed after all
> > > > +		 * members are committed, when the group leader flag is
> > > > +		 * cleared
> > > > +		 */
> > > > +		if (!(req->flags & REQ_F_CQE_SKIP) &&
> > > > +				likely(!req_is_group_leader(req)))
> > > >    			io_req_commit_cqe(ctx, req);
> > > > +		if (req->flags & REQ_F_SQE_GROUP)
> > > > +			io_complete_group_req(req, &grp_list);
> > > 
> > > 
> > > if (unlikely(flags & (SKIP_CQE|GROUP))) {
> > > 	<sqe group code>
> > > 	if (/* needs to skip CQE posting */)
> > > 		continue;
> > 
> > io_complete_group_req() needs to be called too in case of CQE_SKIP
> > because the current request may belong to group.
> 
> What's the problem? You can even do
> 
> if (flags & GROUP) {
> 	// do all group specific stuff
> 	// handle CQE_SKIP if needed
> } else if (flags & CQE_SKIP) {
> 	continue;
> }
> 
> And call io_complete_group_req() and other group stuff
> at any place there.

It depends on if leader CQE posting need to be the last one posted.

> 
> > > 	<more sqe group code>
> > > }
> > > 
> > > io_req_commit_cqe();
> > > 
> > > 
> > > Please. And, what's the point of reversing the CQE order and
> > > posting the "leader" completion last? It breaks the natural
> > > order of how IO complete, that is first the "leader" completes
> > > what it has need to do including IO, and then "members" follow
> > > doing their stuff. And besides, you can even post a CQE for the
> > > "leader" when its IO is done and let the user possibly continue
> > > executing. And the user can count when the entire group complete,
> > > if that's necessary to know.
> > 
> > There are several reasons for posting leader completion last:
> > 
> > 1) only the leader is visible in link chain, IO drain has to wait
> > the whole group by draining the leader
> 
> Let's forget about IO drain. It's a feature I'd love to see killed
> (if only we can), it's a slow path, for same reasons I'll discourage
> anyone using it.

Then we have to fail io group in case of IO_DRAIN, otherwise, it may
fail liburing test.

I am fine with this way, at least ublk doesn't use IO_DRAIN at all.

> 
> For correctness we can just copy the link trick, i.e. mark the next
> request outside of the current group/link as drained like below or
> just fail the group.
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 7ed1e009aaec..aa0b93765406 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1975,7 +1975,7 @@ static void io_init_req_drain(struct io_kiocb *req)
>  	struct io_kiocb *head = ctx->submit_state.link.head;
>  	ctx->drain_active = true;
> -	if (head) {
> +	if (head || ctx->submit_state.group.head) {
>  		/*
>  		 * If we need to drain a request in the middle of a link, drain
>  		 * the head request and the next request/link after the current
> 
> 
> 
> > 2) when members depend on leader, leader holds group-wide resource,
> > so it has to be completed after all members are done
> 
> I'm talking about posting a CQE but not destroying the request
> (and associated resources).

Such as, in ublk, the group leader is one uring command for providing
buffer, if its cqe is observed before member consumers's CQE, this way
may confuse application, cause consumer is supposed to be consuming
the provided buffer/resource, and it shouldn't have been completed
before all consumers.

> 
> > > >    	}
> > > >    	__io_cq_unlock_post(ctx);
> > > > +	if (!wq_list_empty(&grp_list))
> > > > +		__wq_list_splice(&grp_list, state->compl_reqs.first);
> > > > +
> > > >    	if (!wq_list_empty(&state->compl_reqs)) {
> > > >    		io_free_batch_list(ctx, state->compl_reqs.first);
> > > >    		INIT_WQ_LIST(&state->compl_reqs);
> > > ...
> > > > @@ -1754,9 +1903,18 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
> > > >    	struct io_kiocb *nxt = NULL;
> > > >    	if (req_ref_put_and_test(req)) {
> > > > -		if (req->flags & IO_REQ_LINK_FLAGS)
> > > > -			nxt = io_req_find_next(req);
> > > > -		io_free_req(req);
> > > > +		/*
> > > > +		 * CQEs have been posted in io_req_complete_post() except
> > > > +		 * for group leader, and we can't advance the link for
> > > > +		 * group leader until its CQE is posted.
> > > > +		 */
> > > > +		if (!req_is_group_leader(req)) {
> > > > +			if (req->flags & IO_REQ_LINK_FLAGS)
> > > > +				nxt = io_req_find_next(req);
> > > > +			io_free_req(req);
> > > > +		} else {
> > > > +			__io_free_req(req, false);
> > > 
> > > Something fishy is going on here. io-wq only holds a ref that the
> > > request is not killed, but it's owned by someone else. And the
> > > owner is responsible for CQE posting and logical flow of the
> > > request.
> > 
> > io_req_complete_post() is always called in io-wq for CQE posting
> > before io-wq drops ref.
> > 
> > The ref held by io-wq prevents the owner from calling io_free_req(),
> > so the owner actually can't run CQE post.
> > 
> > > 
> > > Now, the owner put the request down but for some reason didn't
> > > finish with the request like posting a CQE, but it's delayed to
> > > iowq dropping the ref?
> > > 
> > > I assume the refcounting hierarchy, first grp_refs go down,
> > > and when it hits zero it does whatever it needs, posting a
> > > CQE at that point of prior, and then puts the request reference
> > > down.
> > 
> > Yes, that is why the patch doesn't mark CQE_SKIP for leader in
> > io_wq_free_work(), meantime leader->link has to be issued after
> > leader's CQE is posted in case of io-wq.
> 
> The point is that io_wq_free_work() doesn't need to know
> anything about groups and can just continue setting the
> skip cqe flag as before if it's done differently
> 
> > But grp_refs is dropped after io-wq request reference drops to
> > zero, then both io-wq and nor-io-wq code path can be unified
> > wrt. dealing with grp_refs, meantime it needn't to be updated
> > in extra(io-wq) context.
> 
> Let's try to describe how it can work. First, I'm only describing
> the dep mode for simplicity. And for the argument's sake we can say
> that all CQEs are posted via io_submit_flush_completions.
> 
> io_req_complete_post() {
> 	if (flags & GROUP) {
> 		req->io_task_work.func = io_req_task_complete;
> 		io_req_task_work_add(req);
> 		return;
> 	}
> 	...
> }

OK.

io_wq_free_work() still need to change to not deal with
next link & ignoring skip_cqe, because group handling(
cqe posting, link advance) is completely moved into
io_submit_flush_completions().

> 
> You can do it this way, nobody would ever care, and it shouldn't
> affect performance. Otherwise everything down below can probably
> be extended to io_req_complete_post().
> 
> To avoid confusion in terminology, what I call a member below doesn't
> include a leader. IOW, a group leader request is not a member.
> 
> At the init we have:
> grp_refs = nr_members; /* doesn't include the leader */
> 
> Let's also say that the group leader can and always goes
> through io_submit_flush_completions() twice, just how it's
> with your patches.
> 
> 1) The first time we see the leader in io_submit_flush_completions()
> is when it's done with resource preparation. For example, it was
> doing some IO into a buffer, and now is ready to give that buffer
> with data to group members. At this point it should queue up all group
> members. And we also drop 1 grp_ref. There will also be no
> io_issue_sqe() for it anymore.

Ok, then it is just the case with dependency.

> 
> 2) Members are executed and completed, in io_submit_flush_completions()
> they drop 1 grp_leader->grp_ref reference each.
> 
> 3) When all members complete, leader's grp_ref becomes 0. Here
> the leader is queued for io_submit_flush_completions() a second time,
> at which point it drops ublk buffers and such and gets destroyed.
> 
> You can post a CQE in 1) and then set CQE_SKIP. Can also be fitted
> into 3). A pseudo code for when we post it in step 1)

This way should work, but it confuses application because
the leader is completed before all members:

- leader usually provide resources in group wide
- member consumes this resource
- leader is supposed to be completed after all consumer(member) are
done.

Given it is UAPI, we have to be careful with CQE posting order.

> 
> io_free_batch_list() {
> 	if (req->flags & GROUP) {
> 		if (req_is_member(req)) {
> 			req->grp_leader->grp_refs--;
> 			if (req->grp_leader->grp_refs == 0) {
> 				req->io_task_work.func = io_req_task_complete;
> 				io_req_task_work_add(req->grp_leader);
> 				// can be done better....
> 			}
> 			goto free_req;
> 		}
> 		WARN_ON_ONCE(!req_is_leader());
> 
> 		if (!(req->flags & SEEN_FIRST_TIME)) {
> 			// already posted it just before coming here
> 			req->flags |= SKIP_CQE;
> 			// we'll see it again when grp_refs hit 0
> 			req->flags |= SEEN_FIRST_TIME;
> 
> 			// Don't free the req, we're leaving it alive for now.
> 			// req->ref/REQ_F_REFCOUNT will be put next time we get here.
> 			return; // or continue
> 		}
> 
> 		clean_up_request_resources(); // calls back into ublk
> 		// and now free the leader
> 	}
> 
> free_req:
> 	// the rest of io_free_batch_list()
> 	if (flags & REQ_F_REFCOUNT) {
> 		req_drop_ref();
> 		....
> 	}
> 	...
> }
> 
> 
> This way
> 1) There are relatively easy request lifetime rules.
> 2) No special ownership/lifetime rules for the group link field.
> 3) You don't need to touch io_req_complete_defer()
> 4) io-wq doesn't know anything about grp_refs and doesn't play tricks
> with SKIP_CQE.

io_wq_free_work() still need to change for not setting SKIP_CQE and
not advancing the link.

> 5) All handling is in one place, doesn't need multiple checks in common
> hot path. You might need some extra, but at least it's contained.
> 
> 
> > > > +		}
> > > >    	}
> > > >    	return nxt ? &nxt->work : NULL;
> > > >    }
> > > > @@ -1821,6 +1979,8 @@ void io_wq_submit_work(struct io_wq_work *work)
> > > >    		}
> > > >    	}
> > > > +	if (need_queue_group_members(req->flags))
> > > > +		io_queue_group_members(req, true);
> > > >    	do {
> > > >    		ret = io_issue_sqe(req, issue_flags);
> > > >    		if (ret != -EAGAIN)
> > > > @@ -1932,9 +2092,17 @@ static inline void io_queue_sqe(struct io_kiocb *req)
> > > >    	/*
> > > >    	 * We async punt it if the file wasn't marked NOWAIT, or if the file
> > > >    	 * doesn't support non-blocking read/write attempts
> > > > +	 *
> > > > +	 * Request is always freed after returning from io_queue_sqe(), so
> > > > +	 * it is fine to check its flags after it is issued
> > > > +	 *
> > > > +	 * For group leader, members holds leader references, so it is safe
> > > > +	 * to touch the leader after leader is issued
> > > >    	 */
> > > >    	if (unlikely(ret))
> > > >    		io_queue_async(req, ret);
> > > > +	else if (need_queue_group_members(req->flags))
> > > > +		io_queue_group_members(req, false);
> > > 
> > > It absolutely cannot be here. There is no relation between this place
> > > in code and lifetime of the request. It could've been failed or
> > > completed, it can also be flying around in a completely arbitrary
> > > context being executed. We're not introducing weird special lifetime
> > > rules for group links. It complicates the code, and no way it can be
> > > sanely supported.
> > > For example, it's not forbidden for issue_sqe callbacks to queue requests
> > > to io-wq and return 0 (IOU_ISSUE_SKIP_COMPLETE which would be turned
> > > into 0), and then we have two racing io_queue_group_members() calls.
> > 
> > It can by handled by adding io_queue_sqe_group() in which:
> > 
> > - req->grp_link is moved to one local variable, and make every
> >    member's grp_leader point to req
> > 
> > - call io_queue_sqe() for leader
> > 
> > - then call io_queue_group_members() for all members, and make sure
> > not touch leader in io_queue_group_members()
> > 
> > What do you think of this way?
> 
> By the end of the day, io_queue_sqe is just not the right place for
> it. Take a look at the scheme above, I believe it should work

OK, thanks again for the review!


Thanks,
Ming


