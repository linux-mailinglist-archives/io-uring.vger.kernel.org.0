Return-Path: <io-uring+bounces-2547-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 065D693A2DB
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 16:35:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29F251C229B4
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 14:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4D61552E0;
	Tue, 23 Jul 2024 14:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R67KlVXe"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A361015530F
	for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 14:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721745302; cv=none; b=QisAnToXSwacQVotM8z5y2O3YAQhf++qfnTxyqTdMJJhJosi/2m0OLcktlYvTEhzYQdYn8roU8FNpIxFb3CudYJcjNAz5CnekyEEVtjRo6uxceW4ueOHfjxHUqrNT/xQCBf7WqA/+7zevenbYfrNtdO1KdOVgIpkcRAkfKFTSBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721745302; c=relaxed/simple;
	bh=/4zW9nnQOsZjJEkA6sYdEXwYhZITnB0nlzLTE/jJ/lY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CMoHjhWYK22EMqQYt47rMSjxQyleqmde4qvUefcrsWM0Zj72MaEhjMDi2UDYTAC1NtLIKB42I2GrDMt0tEyWdWoe7U6Bb80PhMDxzovWvOXIrOwjmTPQrKHulubtienuNW9eyILo+xzObUUFiJMagghkv/Z3s6mx9rfRuTvgu5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R67KlVXe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721745298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A/ieDxIMeBJouGAg5DZ/lc80M+fS/qPyHtONuleO55U=;
	b=R67KlVXeRTM146crRR/Cqsi5NyY/5q8jFVzy51sIdo24B96NhbPUQ4m04w37AAhfukSE9H
	ZGmNHan5c+jv/3VR33/r1dcEQIZsPbBSeO2sj6FXZQ2nYfevnkNTpMBvA7iwWKXIfOFOuP
	EpOAoIVKIsBYmeUktIovrr+SpWciOjw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-21-LejB1RSDO1CEozPtTGMzbA-1; Tue,
 23 Jul 2024 10:34:56 -0400
X-MC-Unique: LejB1RSDO1CEozPtTGMzbA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08A9E1955D4F;
	Tue, 23 Jul 2024 14:34:55 +0000 (UTC)
Received: from fedora (unknown [10.72.116.29])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C26A3000192;
	Tue, 23 Jul 2024 14:34:49 +0000 (UTC)
Date: Tue, 23 Jul 2024 22:34:44 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>,
	ming.lei@redhat.com
Subject: Re: [PATCH V4 4/8] io_uring: support SQE group
Message-ID: <Zp+/hBwCBmKSGy5K@fedora>
References: <20240706031000.310430-1-ming.lei@redhat.com>
 <20240706031000.310430-5-ming.lei@redhat.com>
 <fa5e8098-f72f-43c1-90c1-c3eaebfea3d5@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa5e8098-f72f-43c1-90c1-c3eaebfea3d5@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Pavel,

Thanks for the review!

On Mon, Jul 22, 2024 at 04:33:05PM +0100, Pavel Begunkov wrote:
> On 7/6/24 04:09, Ming Lei wrote:
> > SQE group is defined as one chain of SQEs starting with the first SQE that
> > has IOSQE_SQE_GROUP set, and ending with the first subsequent SQE that
> > doesn't have it set, and it is similar with chain of linked SQEs.
> > 
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
> > One simple sqe group based copy example[1] shows that:
> 
> Sorry to say, but it's a flawed misleading example. We just can't
> coalesce 4 writes into 1 and say it's a win of this feature. It'd
> be a different thing if you compare perfectly optimised version
> without vs with groups. Note, I'm not asking you to do that, the
> use case here is zerocopy ublk.

OK, group provides one easy way to do that.

> 
> 
> > 1) buffered copy:
> > - perf is improved by 5%
> > 
> > 2) direct IO mode
> > - perf is improved by 27%
> > 
> > 3) sqe group copy, which keeps QD not changed, just re-organize IOs in the
> > following ways:
> > 
> > - each group have 4 READ IOs, linked by one single write IO for writing
> >    the read data in sqe group to destination file
> > 
> > - the 1st 12 groups have (4 + 1) IOs, and the last group have (3 + 1)
> >    IOs
> > 
> > - test code:
> > 	https://github.com/ming1/liburing/commits/sqe_group_v2/
> > 
> > Suggested-by: Kevin Wolf <kwolf@redhat.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > index 7597344a6440..b5415f0774e5 100644
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> ...
> > @@ -421,6 +422,10 @@ static inline void io_req_track_inflight(struct io_kiocb *req)
> >   	if (!(req->flags & REQ_F_INFLIGHT)) {
> >   		req->flags |= REQ_F_INFLIGHT;
> >   		atomic_inc(&req->task->io_uring->inflight_tracked);
> > +
> > +		/* make members' REQ_F_INFLIGHT discoverable via leader's */
> > +		if (req_is_group_member(req))
> > +			io_req_track_inflight(req->grp_leader);
> 
> Requests in a group can be run in parallel with the leader (i.e.
> io_issue_sqe()), right? In which case it'd race setting req->flags. We'd
> need to think how make it sane.

Yeah, another easier way could be to always mark leader as INFLIGHT.

> 
> >   	}
> >   }
> ...
> > +void io_queue_group_members(struct io_kiocb *req, bool async)
> > +{
> > +	struct io_kiocb *member = req->grp_link;
> > +
> > +	if (!member)
> > +		return;
> > +
> > +	req->grp_link = NULL;
> > +	while (member) {
> > +		struct io_kiocb *next = member->grp_link;
> > +
> > +		member->grp_leader = req;
> > +		if (async)
> > +			member->flags |= REQ_F_FORCE_ASYNC;
> 
> It doesn't need REQ_F_FORCE_ASYNC. That forces
> io-wq -> task_work -> io-wq for no reason when the user
> didn't ask for that.

OK.

> 
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
> > +static void io_complete_group_req(struct io_kiocb *req,
> > +		struct io_wq_work_list *grp_list)
> > +{
> > +	struct io_kiocb *lead = get_group_leader(req);
> > +
> > +	if (__io_complete_group_req(req, lead)) {
> > +		req->flags &= ~REQ_F_SQE_GROUP;
> > +		lead->flags &= ~REQ_F_SQE_GROUP_LEADER;
> > +
> > +		if (!(lead->flags & REQ_F_CQE_SKIP))
> > +			io_req_commit_cqe(lead->ctx, lead);
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
> > @@ -897,7 +1013,7 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
> >   	}
> >   	io_cq_lock(ctx);
> > -	if (!(req->flags & REQ_F_CQE_SKIP)) {
> > +	if (!(req->flags & REQ_F_CQE_SKIP) && !req_is_group_leader(req)) {
> >   		if (!io_fill_cqe_req(ctx, req))
> >   			io_req_cqe_overflow(req);
> >   	}
> > @@ -974,16 +1090,22 @@ __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
> >   	return true;
> >   }
> 
> ...
> >   static void __io_req_find_next_prep(struct io_kiocb *req)
> >   {
> >   	struct io_ring_ctx *ctx = req->ctx;
> > @@ -1388,6 +1510,17 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
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
> > @@ -1420,6 +1553,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
> >   	__must_hold(&ctx->uring_lock)
> >   {
> >   	struct io_submit_state *state = &ctx->submit_state;
> > +	struct io_wq_work_list grp_list = {NULL};
> >   	struct io_wq_work_node *node;
> >   	__io_cq_lock(ctx);
> > @@ -1427,11 +1561,22 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
> >   		struct io_kiocb *req = container_of(node, struct io_kiocb,
> >   					    comp_list);
> > -		if (!(req->flags & REQ_F_CQE_SKIP))
> > +		/*
> > +		 * For group leader, cqe has to be committed after all
> > +		 * members are committed, when the group leader flag is
> > +		 * cleared
> > +		 */
> > +		if (!(req->flags & REQ_F_CQE_SKIP) &&
> > +				likely(!req_is_group_leader(req)))
> >   			io_req_commit_cqe(ctx, req);
> > +		if (req->flags & REQ_F_SQE_GROUP)
> > +			io_complete_group_req(req, &grp_list);
> 
> 
> if (unlikely(flags & (SKIP_CQE|GROUP))) {
> 	<sqe group code>
> 	if (/* needs to skip CQE posting */)
> 		continue;

io_complete_group_req() needs to be called too in case of CQE_SKIP
because the current request may belong to group.

> 	<more sqe group code>
> }
> 
> io_req_commit_cqe();
> 
> 
> Please. And, what's the point of reversing the CQE order and
> posting the "leader" completion last? It breaks the natural
> order of how IO complete, that is first the "leader" completes
> what it has need to do including IO, and then "members" follow
> doing their stuff. And besides, you can even post a CQE for the
> "leader" when its IO is done and let the user possibly continue
> executing. And the user can count when the entire group complete,
> if that's necessary to know.

There are several reasons for posting leader completion last:

1) only the leader is visible in link chain, IO drain has to wait
the whole group by draining the leader

2) when members depend on leader, leader holds group-wide resource,
so it has to be completed after all members are done

> 
> >   	}
> >   	__io_cq_unlock_post(ctx);
> > +	if (!wq_list_empty(&grp_list))
> > +		__wq_list_splice(&grp_list, state->compl_reqs.first);
> > +
> >   	if (!wq_list_empty(&state->compl_reqs)) {
> >   		io_free_batch_list(ctx, state->compl_reqs.first);
> >   		INIT_WQ_LIST(&state->compl_reqs);
> ...
> > @@ -1754,9 +1903,18 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
> >   	struct io_kiocb *nxt = NULL;
> >   	if (req_ref_put_and_test(req)) {
> > -		if (req->flags & IO_REQ_LINK_FLAGS)
> > -			nxt = io_req_find_next(req);
> > -		io_free_req(req);
> > +		/*
> > +		 * CQEs have been posted in io_req_complete_post() except
> > +		 * for group leader, and we can't advance the link for
> > +		 * group leader until its CQE is posted.
> > +		 */
> > +		if (!req_is_group_leader(req)) {
> > +			if (req->flags & IO_REQ_LINK_FLAGS)
> > +				nxt = io_req_find_next(req);
> > +			io_free_req(req);
> > +		} else {
> > +			__io_free_req(req, false);
> 
> Something fishy is going on here. io-wq only holds a ref that the
> request is not killed, but it's owned by someone else. And the
> owner is responsible for CQE posting and logical flow of the
> request.

io_req_complete_post() is always called in io-wq for CQE posting
before io-wq drops ref.

The ref held by io-wq prevents the owner from calling io_free_req(),
so the owner actually can't run CQE post.

> 
> Now, the owner put the request down but for some reason didn't
> finish with the request like posting a CQE, but it's delayed to
> iowq dropping the ref?
> 
> I assume the refcounting hierarchy, first grp_refs go down,
> and when it hits zero it does whatever it needs, posting a
> CQE at that point of prior, and then puts the request reference
> down.

Yes, that is why the patch doesn't mark CQE_SKIP for leader in
io_wq_free_work(), meantime leader->link has to be issued after
leader's CQE is posted in case of io-wq.

But grp_refs is dropped after io-wq request reference drops to
zero, then both io-wq and nor-io-wq code path can be unified
wrt. dealing with grp_refs, meantime it needn't to be updated
in extra(io-wq) context.

> 
> > +		}
> >   	}
> >   	return nxt ? &nxt->work : NULL;
> >   }
> > @@ -1821,6 +1979,8 @@ void io_wq_submit_work(struct io_wq_work *work)
> >   		}
> >   	}
> > +	if (need_queue_group_members(req->flags))
> > +		io_queue_group_members(req, true);
> >   	do {
> >   		ret = io_issue_sqe(req, issue_flags);
> >   		if (ret != -EAGAIN)
> > @@ -1932,9 +2092,17 @@ static inline void io_queue_sqe(struct io_kiocb *req)
> >   	/*
> >   	 * We async punt it if the file wasn't marked NOWAIT, or if the file
> >   	 * doesn't support non-blocking read/write attempts
> > +	 *
> > +	 * Request is always freed after returning from io_queue_sqe(), so
> > +	 * it is fine to check its flags after it is issued
> > +	 *
> > +	 * For group leader, members holds leader references, so it is safe
> > +	 * to touch the leader after leader is issued
> >   	 */
> >   	if (unlikely(ret))
> >   		io_queue_async(req, ret);
> > +	else if (need_queue_group_members(req->flags))
> > +		io_queue_group_members(req, false);
> 
> It absolutely cannot be here. There is no relation between this place
> in code and lifetime of the request. It could've been failed or
> completed, it can also be flying around in a completely arbitrary
> context being executed. We're not introducing weird special lifetime
> rules for group links. It complicates the code, and no way it can be
> sanely supported.
> For example, it's not forbidden for issue_sqe callbacks to queue requests
> to io-wq and return 0 (IOU_ISSUE_SKIP_COMPLETE which would be turned
> into 0), and then we have two racing io_queue_group_members() calls.

It can by handled by adding io_queue_sqe_group() in which:

- req->grp_link is moved to one local variable, and make every
  member's grp_leader point to req

- call io_queue_sqe() for leader

- then call io_queue_group_members() for all members, and make sure
not touch leader in io_queue_group_members()

What do you think of this way?

> 
> You mentioned before there are 2 cases, w/ and w/o deps. That gives me
> a very _very_ bad feeling that you're taking two separate features,
> and trying to hammer them together into one. And the current

Yes, because w/ deps reuses most of code of w/ deps.

> dependencies thing looks terrible as a user api, when you have
> requests run in parallel, unless there is a special request ahead which
> provides buffers but doesn't advertise that in a good way. I don't
> know what to do about it. Either we need to find a better api or
> just implement one. Maybe, always delaying until leader executes
> like with dependencies is good enough, and then you set a nop
> as a leader to emulate the dependency-less mode.

Another ways is to start with w/ deps mode only, which is exactly
what ublk zero copy is needed, and w/o deps is just for making
the feature more generic, suggested by Kevin.

> 
> Taking uapi aside, the two mode dichotomy tells the story how
> io_queue_group_members() placing should look like. If there
> are dependencies, the leader should be executed, completed,
> and quueue members in a good place denoting completion, like
> io_free_batch_list. In case of no deps it need to queue everyone
> when you'd queue up a linked request (or issue the head).
> 
> 
> >   }
> >   static void io_queue_sqe_fallback(struct io_kiocb *req)
> > @@ -2101,6 +2269,56 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
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
> 
> needs to fail instead seeing these flags

OK.

> 
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
> ...
> > diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> > index e1ce908f0679..8cc347959f7e 100644
> > --- a/io_uring/io_uring.h
> > +++ b/io_uring/io_uring.h
> > @@ -68,6 +68,8 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
> >   void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
> >   bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
> >   void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
> > +void io_queue_group_members(struct io_kiocb *req, bool async);
> > +void io_cancel_group_members(struct io_kiocb *req, bool ignore_cqes);
> >   struct file *io_file_get_normal(struct io_kiocb *req, int fd);
> >   struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
> > @@ -339,6 +341,16 @@ static inline void io_tw_lock(struct io_ring_ctx *ctx, struct io_tw_state *ts)
> >   	lockdep_assert_held(&ctx->uring_lock);
> >   }
> > +static inline bool req_is_group_leader(struct io_kiocb *req)
> > +{
> > +	return req->flags & REQ_F_SQE_GROUP_LEADER;
> > +}
> > +
> > +static inline bool req_is_group_member(struct io_kiocb *req)
> > +{
> > +	return !req_is_group_leader(req) && (req->flags & REQ_F_SQE_GROUP);
> > +}
> > +
> >   /*
> >    * Don't complete immediately but use deferred completion infrastructure.
> >    * Protected by ->uring_lock and can only be used either with
> > @@ -352,6 +364,10 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
> >   	lockdep_assert_held(&req->ctx->uring_lock);
> >   	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
> > +
> > +	/* members may not be issued when leader is completed */
> > +	if (unlikely(req_is_group_leader(req) && req->grp_link))
> > +		io_queue_group_members(req, false);
> >   }
> 
> Here should be no processing, it's not a place where it can be

OK.


Thanks,
Ming


