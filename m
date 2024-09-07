Return-Path: <io-uring+bounces-3083-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32C57970168
	for <lists+io-uring@lfdr.de>; Sat,  7 Sep 2024 11:36:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5740B1C20FC9
	for <lists+io-uring@lfdr.de>; Sat,  7 Sep 2024 09:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A88415665D;
	Sat,  7 Sep 2024 09:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A/Tq1zGz"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50B6148FF7
	for <io-uring@vger.kernel.org>; Sat,  7 Sep 2024 09:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725701789; cv=none; b=b6Wjy5M4rquk1jYReTPWJzO2CQBsXjacDxpIPqjriea4wod7u97yFj6lmF8iRHSnvO/9TyoQTLjmKVBrTC+OiWY6kIA6U1XRmcR2ditHBVjkfiRaMSe2G7KLN8Kg70WcNTCbEIsfyqysSjDlvBr7hvcYTE3GKCKgZVDfMHnOYzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725701789; c=relaxed/simple;
	bh=pm3x5AU41FUZDDYq5D+zv9pedtwyTqzxF5wWf0S12yY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eciDpNZzbFm/DfGC+22E2PFMapOnFVgHI+lEuyAa1ehWJF9hKXHQtwLn0r2PSGHCabdDyO78sJPZ3pw0YM7wVtyb+v4qa8I079ARfe4aegRXHpj+GHXp6K12dGJycUYXgDIrhS8w/902vMBKqtcN1wUUNZVjdt9NJTugnmA43ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A/Tq1zGz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725701785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PT+pYIPSjDF8A2b5NMf2iS6ujBdIfCuDCgcJg0vuM/I=;
	b=A/Tq1zGzhYM8Q4SyTz3DnqF6z6jqWHSyrFLMc3L6NiGDt3nYIqZY3oF/NNtolqGu23ZPXX
	yXPjMRfXXphx0HxUNFeon37QOBo8SPORd8yaIk60z0n3gZn2xCmJJmxbjE8x+WdrQvJDFD
	r5Frx/xFxMdG5Hoj0qJ+R5UWucCyGcQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-31-0Y85Rd7hMKWj9RPg6RSfEA-1; Sat,
 07 Sep 2024 05:36:21 -0400
X-MC-Unique: 0Y85Rd7hMKWj9RPg6RSfEA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63F451956096;
	Sat,  7 Sep 2024 09:36:19 +0000 (UTC)
Received: from fedora (unknown [10.72.116.7])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89DDC1956086;
	Sat,  7 Sep 2024 09:36:14 +0000 (UTC)
Date: Sat, 7 Sep 2024 17:36:08 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>,
	ming.lei@redhat.com
Subject: Re: [PATCH V5 4/8] io_uring: support SQE group
Message-ID: <ZtweiCfLOJmdeY0Z@fedora>
References: <20240808162503.345913-1-ming.lei@redhat.com>
 <20240808162503.345913-5-ming.lei@redhat.com>
 <3c819871-7ca3-47ea-b752-c4a8a49f8304@gmail.com>
 <Zs/5Hpi16aQKlHFw@fedora>
 <36ae357b-bebe-4276-a8db-d6dccf227b61@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36ae357b-bebe-4276-a8db-d6dccf227b61@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, Sep 06, 2024 at 06:15:32PM +0100, Pavel Begunkov wrote:
> On 8/29/24 05:29, Ming Lei wrote:
> ...
> > > > +	if (WARN_ON_ONCE(lead->grp_refs <= 0))
> > > > +		return false;
> > > > +
> > > > +	req->flags &= ~REQ_F_SQE_GROUP;
> > > 
> > > I'm getting completely lost when and why it clears and sets
> > > back REQ_F_SQE_GROUP and REQ_F_SQE_GROUP_LEADER. Is there any
> > > rule?
> > 
> > My fault, it should have been documented somewhere.
> > 
> > REQ_F_SQE_GROUP is cleared when the request is completed, but it is
> > reused as flag for marking the last request in this group, so we can
> > free the group leader when observing the 'last' member request.
> 
> Maybe it'd be cleaner to use a second flag?

I will add one new flag with same value, since the two's lifetime
is non-overlapping.

> 
> > The only other difference about the two flags is that both are cleared
> > when the group leader becomes the last one in the group, then
> > this leader degenerates as normal request, which way can simplify
> > group leader freeing.
> > 
> > > 
> > > > +	/*
> > > > +	 * Set linked leader as failed if any member is failed, so
> > > > +	 * the remained link chain can be terminated
> > > > +	 */
> > > > +	if (unlikely((req->flags & REQ_F_FAIL) &&
> > > > +		     ((lead->flags & IO_REQ_LINK_FLAGS) && lead->link)))
> > > > +		req_set_fail(lead);
> > > 
> > > if (req->flags & REQ_F_FAIL)
> > > 	req_set_fail(lead);
> > > 
> > > REQ_F_FAIL is not specific to links, if a request fails we need
> > > to mark it as such.
> > 
> > It is for handling group failure.
> > 
> > The following condition
> > 
> > 	((lead->flags & IO_REQ_LINK_FLAGS) && lead->link))
> > 
> > means that this group is in one link-chain.
> > 
> > If any member in this group is failed, we need to fail this group(lead),
> > then the remained requests in this chain can be failed.
> > 
> > Otherwise, it isn't necessary to fail group leader in case of any member
> > io failure.
> 
> What bad would happen if you do it like this?
> 
> if (req->flags & REQ_F_FAIL)
> 	req_set_fail(lead);
> 
> I'm asking because if you rely on some particular combination
> of F_FAIL and F_LINK somewhere, it's likely wrong, but otherwise
> we F_FAIL a larger set of requests, which should never be an
> issue.

From dependency relation viewpoint it is not necessary to fail all, but it
makes us easier to start with this more determinate behavior, will
change to this way in V6.

> 
> > > > +	return !--lead->grp_refs;
> > > > +}
> > > > +
> > > > +static inline bool leader_is_the_last(struct io_kiocb *lead)
> > > > +{
> > > > +	return lead->grp_refs == 1 && (lead->flags & REQ_F_SQE_GROUP);
> > > > +}
> > > > +
> > > > +static void io_complete_group_member(struct io_kiocb *req)
> > > > +{
> > > > +	struct io_kiocb *lead = get_group_leader(req);
> > > > +
> > > > +	if (WARN_ON_ONCE(!(req->flags & REQ_F_SQE_GROUP)))
> > > > +		return;
> > > > +
> > > > +	/* member CQE needs to be posted first */
> > > > +	if (!(req->flags & REQ_F_CQE_SKIP))
> > > > +		io_req_commit_cqe(req->ctx, req);
> > > > +
> > > > +	if (__io_complete_group_member(req, lead)) {
> > > > +		/*
> > > > +		 * SQE_GROUP flag is kept for the last member, so the leader
> > > > +		 * can be retrieved & freed from this last member
> > > > +		 */
> > > > +		req->flags |= REQ_F_SQE_GROUP;
> > 
> > 'req' is the last completed request, so mark it as the last one
> > by reusing REQ_F_SQE_GROUP, so we can free group leader in
> > io_free_batch_list() when observing the last flag.
> > 
> > But it should have been documented.
> > 
> > > > +		if (!(lead->flags & REQ_F_CQE_SKIP))
> > > > +			io_req_commit_cqe(lead->ctx, lead);
> > > > +	} else if (leader_is_the_last(lead)) {
> > > > +		/* leader will degenerate to plain req if it is the last */
> > > > +		lead->flags &= ~(REQ_F_SQE_GROUP | REQ_F_SQE_GROUP_LEADER);
> > > 
> > > What's this chunk is about?
> > 
> > The leader becomes the only request not completed in group, so it is
> > degenerated as normal one by clearing the two flags. This way simplifies
> > logic for completing group leader.
> > 
> ...
> > > > @@ -1388,11 +1501,33 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
> > > >    						    comp_list);
> > > >    		if (unlikely(req->flags & IO_REQ_CLEAN_SLOW_FLAGS)) {
> > > > +			if (req->flags & (REQ_F_SQE_GROUP |
> > > > +					  REQ_F_SQE_GROUP_LEADER)) {
> > > > +				struct io_kiocb *leader;
> > > > +
> > > > +				/* Leader is freed via the last member */
> > > > +				if (req_is_group_leader(req)) {
> > > > +					node = req->comp_list.next;
> > > > +					continue;
> > > > +				}
> > > > +
> > > > +				/*
> > > > +				 * Only the last member keeps GROUP flag,
> > > > +				 * free leader and this member together
> > > > +				 */
> > > > +				leader = get_group_leader(req);
> > > > +				leader->flags &= ~REQ_F_SQE_GROUP_LEADER;
> > > > +				req->flags &= ~REQ_F_SQE_GROUP;
> > > > +				wq_stack_add_head(&leader->comp_list,
> > > > +						  &req->comp_list);
> > > 
> > > That's quite hacky, but at least we can replace it with
> > > task work if it gets in the way later on.
> > 
> > io_free_batch_list() is already called in task context, and it isn't
> > necessary to schedule one extra tw, which hurts perf more or less.
> > 
> > Another way is to store these leaders into one temp list, and
> > call io_free_batch_list() for this temp list one more time.
> 
> What I'm saying, it's fine to leave it as is for now. In the
> future if it becomes a problem for ome reason or another, we can
> do it the task_work like way.

OK, got it, I will leave it as is, and document the potential risk
with future changes.

> 
> ...
> > > > @@ -2101,6 +2251,62 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
> > > >    	return def->prep(req, sqe);
> > > >    }
> > > > +static struct io_kiocb *io_group_sqe(struct io_submit_link *group,
> > > > +				     struct io_kiocb *req)
> > > > +{
> > > > +	/*
> > > > +	 * Group chain is similar with link chain: starts with 1st sqe with
> > > > +	 * REQ_F_SQE_GROUP, and ends with the 1st sqe without REQ_F_SQE_GROUP
> > > > +	 */
> > > > +	if (group->head) {
> > > > +		struct io_kiocb *lead = group->head;
> > > > +
> > > > +		/* members can't be in link chain, can't be drained */
> > > > +		if (req->flags & (IO_REQ_LINK_FLAGS | REQ_F_IO_DRAIN))
> > > > +			req_fail_link_node(lead, -EINVAL);
> > > 
> > > That should fail the entire link (if any) as well.
> > 
> > Good catch, here we should fail link head by following the logic
> > in io_submit_fail_init().
> > 
> > > 
> > > I have even more doubts we even want to mix links and groups. Apart
> > 
> > Wrt. ublk, group provides zero copy, and the ublk io(group) is generic
> > IO, sometime IO_LINK is really needed & helpful, such as in ublk-nbd,
> > send(tcp) requests need to be linked & zc. And we shouldn't limit IO_LINK
> > for generic io_uring IO.
> > 
> > > from nuances as such, which would be quite hard to track, the semantics
> > > of IOSQE_CQE_SKIP_SUCCESS is unclear.
> > 
> > IO group just follows every normal request.
> 
> It tries to mimic but groups don't and essentially can't do it the
> same way, at least in some aspects. E.g. IOSQE_CQE_SKIP_SUCCESS
> usually means that all following will be silenced. What if a
> member is CQE_SKIP, should it stop the leader from posting a CQE?
> And whatever the answer is, it'll be different from the link's
> behaviour.

Here it looks easier than link's:

- only leader's IOSQE_CQE_SKIP_SUCCESS follows linked request's rule
- all members just respects the flag for its own, and not related with
leader's

> 
> Regardless, let's forbid IOSQE_CQE_SKIP_SUCCESS and linked timeouts
> for groups, that can be discussed afterwards.

It should easy to forbid IOSQE_CQE_SKIP_SUCCESS which is per-sqe, will do
it in V6.

I am not sure if it is easy to disallow IORING_OP_LINK_TIMEOUT, which
covers all linked sqes, and group leader could be just one of them.
Can you share any idea about the implementation to forbid LINK_TIMEOUT
for sqe group?

> 
> > 1) fail in linked chain
> > - follows IO_LINK's behavior since io_fail_links() covers io group
> > 
> > 2) otherwise
> > - just respect IOSQE_CQE_SKIP_SUCCESS
> > 
> > > And also it doen't work with IORING_OP_LINK_TIMEOUT.
> > 
> > REQ_F_LINK_TIMEOUT can work on whole group(or group leader) only, and I
> > will document it in V6.
> 
> It would still be troublesome. When a linked timeout fires it searches
> for the request it's attached to and cancels it, however, group leaders
> that queued up their members are discoverable. But let's say you can find
> them in some way, then the only sensbile thing to do is cancel members,
> which should be doable by checking req->grp_leader, but might be easier
> to leave it to follow up patches.

We have changed sqe group to start queuing members after leader is
completed. link timeout will cancel leader with all its members via
leader->grp_link, this behavior should respect IORING_OP_LINK_TIMEOUT
completely.

Please see io_fail_links() and io_cancel_group_members().

> 
> 
> > > > +
> > > > +		lead->grp_refs += 1;
> > > > +		group->last->grp_link = req;
> > > > +		group->last = req;
> > > > +
> > > > +		if (req->flags & REQ_F_SQE_GROUP)
> > > > +			return NULL;
> > > > +
> > > > +		req->grp_link = NULL;
> > > > +		req->flags |= REQ_F_SQE_GROUP;
> > > > +		group->head = NULL;
> > > > +		if (lead->flags & REQ_F_FAIL) {
> > > > +			io_queue_sqe_fallback(lead);
> > > 
> > > Let's say the group was in the middle of a link, it'll
> > > complete that group and continue with assembling / executing
> > > the link when it should've failed it and honoured the
> > > request order.
> > 
> > OK, here we can simply remove the above two lines, and link submit
> > state can handle this failure in link chain.
> 
> If you just delete then nobody would check for REQ_F_FAIL and
> fail the request.

io_link_assembling() & io_link_sqe() checks for REQ_F_FAIL and call
io_queue_sqe_fallback() either if it is in link chain or
not.

> Assuming you'd also set the fail flag to the
> link head when appropriate, how about deleting these two line
> and do like below? (can be further prettified)
> 
> 
> bool io_group_assembling()
> {
> 	return state->group.head || (req->flags & REQ_F_SQE_GROUP);
> }
> bool io_link_assembling()
> {
> 	return state->link.head || (req->flags & IO_REQ_LINK_FLAGS);
> }
> 
> static inline int io_submit_sqe()
> {
> 	...
> 	if (unlikely(io_link_assembling(state, req) ||
> 				 io_group_assembling(state, req) ||
> 				 req->flags & REQ_F_FAIL)) {
> 		if (io_group_assembling(state, req)) {
> 			req = io_group_sqe(&state->group, req);
> 			if (!req)
> 				return 0;
> 		}
> 		if (io_link_assembling(state, req)) {
> 			req = io_link_sqe(&state->link, req);
> 			if (!req)
> 				return 0;
> 		}
> 		if (req->flags & REQ_F_FAIL) {
> 			io_queue_sqe_fallback(req);
> 			return 0;

As I mentioned above, io_link_assembling() & io_link_sqe() covers
the failure handling.


thanks, 
Ming


