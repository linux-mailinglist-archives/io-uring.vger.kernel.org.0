Return-Path: <io-uring+bounces-2974-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FBC096395E
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 06:29:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 078A42859F7
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 04:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B01C12FB34;
	Thu, 29 Aug 2024 04:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dW3UCzKv"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478B3446A2
	for <io-uring@vger.kernel.org>; Thu, 29 Aug 2024 04:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724905777; cv=none; b=uEuXFCULDB50iJwuGnV5ktLTjUSsg5eqjUzvCIbykt9MHnrgC0Ecjr2XWpOqjY6AtZRI2E6zKkKGK+g0NEl7tpnmpNeky1cpM+6G58jl27O8HLnj7E0jLdHFZDNJtfG/jk5RKeuNVUrzBl8bw0LwegO33zf4rCKAo4gYsfd6VCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724905777; c=relaxed/simple;
	bh=iZgS4MD+UwuzBInqL7u93lglCD9tNMqToEAb21wKI8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eiK4Quvn+s/RRiRodqgWVJ2FhrARsG60xJEE/A66by24cmN2ckkswsidKRearvH/1RdTrmbJ5I3nE3eNOem+uB010WerhDiP81cYixLR+uZznITyCvTx6TqweDZO3c7VOjW5wkpgFKYxu1Zk5bUh0CYYFRnIqvc1uzWVHbQzg40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dW3UCzKv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724905773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RW181n7zULJ+bTk4v7nsXdSFYPZYTQvKDPcxoOwouv8=;
	b=dW3UCzKvdDEPEbg5KQ5YdenYTGlOd3JEMwLae4g797xZeMtgK7PGVfNxMNPNDCo69C/UQH
	P1XL5x5huIczIbzgdiBvrbhE39f5cYnUkAQ9byHc4U8Vp5bTFJtpp0eNanblOSUIAbyg4w
	1o0QHQznDlfTDjymoG14Q8yz6Wr6uvU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-197-wtX5YgNPOOOBLz_oRMD4dA-1; Thu,
 29 Aug 2024 00:29:29 -0400
X-MC-Unique: wtX5YgNPOOOBLz_oRMD4dA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 664771955D57;
	Thu, 29 Aug 2024 04:29:28 +0000 (UTC)
Received: from fedora (unknown [10.72.112.119])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 433BE19560A3;
	Thu, 29 Aug 2024 04:29:22 +0000 (UTC)
Date: Thu, 29 Aug 2024 12:29:18 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>,
	ming.lei@redhat.com
Subject: Re: [PATCH V5 4/8] io_uring: support SQE group
Message-ID: <Zs/5Hpi16aQKlHFw@fedora>
References: <20240808162503.345913-1-ming.lei@redhat.com>
 <20240808162503.345913-5-ming.lei@redhat.com>
 <3c819871-7ca3-47ea-b752-c4a8a49f8304@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c819871-7ca3-47ea-b752-c4a8a49f8304@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi Pavel,

Thanks for review!

On Tue, Aug 27, 2024 at 04:18:26PM +0100, Pavel Begunkov wrote:
> On 8/8/24 17:24, Ming Lei wrote:
> > SQE group is defined as one chain of SQEs starting with the first SQE that
> > has IOSQE_SQE_GROUP set, and ending with the first subsequent SQE that
> > doesn't have it set, and it is similar with chain of linked SQEs.
> > 
> > Not like linked SQEs, each sqe is issued after the previous one is
> > completed. All SQEs in one group can be submitted in parallel. To simplify
> > the implementation from beginning, all members are queued after the leader
> > is completed, however, this way may be changed and leader and members may
> > be issued concurrently in future.
> > 
> > The 1st SQE is group leader, and the other SQEs are group member. The whole
> > group share single IOSQE_IO_LINK and IOSQE_IO_DRAIN from group leader, and
> > the two flags can't be set for group members.
> > 
> > When the group is in one link chain, this group isn't submitted until the
> > previous SQE or group is completed. And the following SQE or group can't
> > be started if this group isn't completed. Failure from any group member will
> > fail the group leader, then the link chain can be terminated.
> > 
> > When IOSQE_IO_DRAIN is set for group leader, all requests in this group and
> > previous requests submitted are drained. Given IOSQE_IO_DRAIN can be set for
> > group leader only, we respect IO_DRAIN by always completing group leader as
> > the last one in the group. Meantime it is natural to post leader's CQE
> > as the last one from application viewpoint.
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
> >   include/linux/io_uring_types.h |  18 +++
> ...
> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > index f112e9fa90d8..45a292445b18 100644
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> ...
> > @@ -875,6 +877,116 @@ static __always_inline void io_req_commit_cqe(struct io_ring_ctx *ctx,
> >   	}
> >   }
> ...
> > +static void io_queue_group_members(struct io_kiocb *req)
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
> > +		if (unlikely(member->flags & REQ_F_FAIL)) {
> > +			io_req_task_queue_fail(member, member->cqe.res);
> > +		} else if (unlikely(req->flags & REQ_F_FAIL)) {
> > +			io_req_task_queue_fail(member, -ECANCELED);
> > +		} else {
> > +			io_req_task_queue(member);
> > +		}
> > +		member = next;
> > +	}
> > +}
> > +
> > +static inline bool __io_complete_group_member(struct io_kiocb *req,
> > +			     struct io_kiocb *lead)
> > +{
> 
> I think it'd be better if you inline this function, it only
> obfuscates things.

OK.

> 
> > +	if (WARN_ON_ONCE(lead->grp_refs <= 0))
> > +		return false;
> > +
> > +	req->flags &= ~REQ_F_SQE_GROUP;
> 
> I'm getting completely lost when and why it clears and sets
> back REQ_F_SQE_GROUP and REQ_F_SQE_GROUP_LEADER. Is there any
> rule?

My fault, it should have been documented somewhere.

REQ_F_SQE_GROUP is cleared when the request is completed, but it is
reused as flag for marking the last request in this group, so we can
free the group leader when observing the 'last' member request.

The only other difference about the two flags is that both are cleared
when the group leader becomes the last one in the group, then
this leader degenerates as normal request, which way can simplify
group leader freeing.

> 
> > +	/*
> > +	 * Set linked leader as failed if any member is failed, so
> > +	 * the remained link chain can be terminated
> > +	 */
> > +	if (unlikely((req->flags & REQ_F_FAIL) &&
> > +		     ((lead->flags & IO_REQ_LINK_FLAGS) && lead->link)))
> > +		req_set_fail(lead);
> 
> if (req->flags & REQ_F_FAIL)
> 	req_set_fail(lead);
> 
> REQ_F_FAIL is not specific to links, if a request fails we need
> to mark it as such.

It is for handling group failure.

The following condition

	((lead->flags & IO_REQ_LINK_FLAGS) && lead->link))

means that this group is in one link-chain.

If any member in this group is failed, we need to fail this group(lead),
then the remained requests in this chain can be failed.

Otherwise, it isn't necessary to fail group leader in case of any member
io failure.

> 
> 
> > +	return !--lead->grp_refs;
> > +}
> > +
> > +static inline bool leader_is_the_last(struct io_kiocb *lead)
> > +{
> > +	return lead->grp_refs == 1 && (lead->flags & REQ_F_SQE_GROUP);
> > +}
> > +
> > +static void io_complete_group_member(struct io_kiocb *req)
> > +{
> > +	struct io_kiocb *lead = get_group_leader(req);
> > +
> > +	if (WARN_ON_ONCE(!(req->flags & REQ_F_SQE_GROUP)))
> > +		return;
> > +
> > +	/* member CQE needs to be posted first */
> > +	if (!(req->flags & REQ_F_CQE_SKIP))
> > +		io_req_commit_cqe(req->ctx, req);
> > +
> > +	if (__io_complete_group_member(req, lead)) {
> > +		/*
> > +		 * SQE_GROUP flag is kept for the last member, so the leader
> > +		 * can be retrieved & freed from this last member
> > +		 */
> > +		req->flags |= REQ_F_SQE_GROUP;

'req' is the last completed request, so mark it as the last one
by reusing REQ_F_SQE_GROUP, so we can free group leader in
io_free_batch_list() when observing the last flag.

But it should have been documented.

> > +		if (!(lead->flags & REQ_F_CQE_SKIP))
> > +			io_req_commit_cqe(lead->ctx, lead);
> > +	} else if (leader_is_the_last(lead)) {
> > +		/* leader will degenerate to plain req if it is the last */
> > +		lead->flags &= ~(REQ_F_SQE_GROUP | REQ_F_SQE_GROUP_LEADER);
> 
> What's this chunk is about?

The leader becomes the only request not completed in group, so it is
degenerated as normal one by clearing the two flags. This way simplifies
logic for completing group leader.

> 
> > +	}
> > +}
> > +
> > +static void io_complete_group_leader(struct io_kiocb *req)
> > +{
> > +	WARN_ON_ONCE(req->grp_refs <= 0);
> > +	req->flags &= ~REQ_F_SQE_GROUP;
> > +	req->grp_refs -= 1;
> > +	WARN_ON_ONCE(req->grp_refs == 0);
> 
> Why not combine these WARN_ON_ONCE into one?

OK.

> 
> > +
> > +	/* TODO: queue members with leader in parallel */
> 
> no todos, please

Fine, will remove the todos.

> 
> > +	if (req->grp_link)
> > +		io_queue_group_members(req);
> > +}
> 
> It's spinlock'ed, we really don't want to do too much here
> like potentially queueing a ton of task works.
> io_queue_group_members() can move into io_free_batch_list().

Fair enough, will do it in V6.

> 
> > +
> >   static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
> >   {
> >   	struct io_ring_ctx *ctx = req->ctx;
> > @@ -890,7 +1002,8 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
> >   	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
> >   	 * the submitter task context, IOPOLL protects with uring_lock.
> >   	 */
> > -	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL)) {
> > +	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL) ||
> > +	    req_is_group_leader(req)) {
> >   		req->io_task_work.func = io_req_task_complete;
> >   		io_req_task_work_add(req);
> >   		return;
> > @@ -1388,11 +1501,33 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
> >   						    comp_list);
> >   		if (unlikely(req->flags & IO_REQ_CLEAN_SLOW_FLAGS)) {
> > +			if (req->flags & (REQ_F_SQE_GROUP |
> > +					  REQ_F_SQE_GROUP_LEADER)) {
> > +				struct io_kiocb *leader;
> > +
> > +				/* Leader is freed via the last member */
> > +				if (req_is_group_leader(req)) {
> > +					node = req->comp_list.next;
> > +					continue;
> > +				}
> > +
> > +				/*
> > +				 * Only the last member keeps GROUP flag,
> > +				 * free leader and this member together
> > +				 */
> > +				leader = get_group_leader(req);
> > +				leader->flags &= ~REQ_F_SQE_GROUP_LEADER;
> > +				req->flags &= ~REQ_F_SQE_GROUP;
> > +				wq_stack_add_head(&leader->comp_list,
> > +						  &req->comp_list);
> 
> That's quite hacky, but at least we can replace it with
> task work if it gets in the way later on.

io_free_batch_list() is already called in task context, and it isn't
necessary to schedule one extra tw, which hurts perf more or less.

Another way is to store these leaders into one temp list, and
call io_free_batch_list() for this temp list one more time.

> 
> > +			}
> > +
> >   			if (req->flags & REQ_F_REFCOUNT) {
> >   				node = req->comp_list.next;
> >   				if (!req_ref_put_and_test(req))
> >   					continue;
> >   			}
> > +
> >   			if ((req->flags & REQ_F_POLLED) && req->apoll) {
> >   				struct async_poll *apoll = req->apoll;
> > @@ -1427,8 +1562,19 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
> >   		struct io_kiocb *req = container_of(node, struct io_kiocb,
> >   					    comp_list);
> > -		if (!(req->flags & REQ_F_CQE_SKIP))
> > -			io_req_commit_cqe(ctx, req);
> > +		if (unlikely(req->flags & (REQ_F_CQE_SKIP | REQ_F_SQE_GROUP))) {
> > +			if (req->flags & REQ_F_SQE_GROUP) {
> > +				if (req_is_group_leader(req))
> > +					io_complete_group_leader(req);
> > +				else
> > +					io_complete_group_member(req);
> > +				continue;
> > +			}
> > +
> > +			if (req->flags & REQ_F_CQE_SKIP)
> > +				continue;
> > +		}
> > +		io_req_commit_cqe(ctx, req);
> >   	}
> >   	__io_cq_unlock_post(ctx);
> ...
> > @@ -2101,6 +2251,62 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
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
> > +		if (req->flags & (IO_REQ_LINK_FLAGS | REQ_F_IO_DRAIN))
> > +			req_fail_link_node(lead, -EINVAL);
> 
> That should fail the entire link (if any) as well.

Good catch, here we should fail link head by following the logic
in io_submit_fail_init().

> 
> I have even more doubts we even want to mix links and groups. Apart

Wrt. ublk, group provides zero copy, and the ublk io(group) is generic
IO, sometime IO_LINK is really needed & helpful, such as in ublk-nbd,
send(tcp) requests need to be linked & zc. And we shouldn't limit IO_LINK
for generic io_uring IO.

> from nuances as such, which would be quite hard to track, the semantics
> of IOSQE_CQE_SKIP_SUCCESS is unclear.

IO group just follows every normal request.

1) fail in linked chain
- follows IO_LINK's behavior since io_fail_links() covers io group

2) otherwise
- just respect IOSQE_CQE_SKIP_SUCCESS

> And also it doen't work with IORING_OP_LINK_TIMEOUT.

REQ_F_LINK_TIMEOUT can work on whole group(or group leader) only, and I
will document it in V6.

> 
> > +
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
> > +		if (lead->flags & REQ_F_FAIL) {
> > +			io_queue_sqe_fallback(lead);
> 
> Let's say the group was in the middle of a link, it'll
> complete that group and continue with assembling / executing
> the link when it should've failed it and honoured the
> request order.

OK, here we can simply remove the above two lines, and link submit
state can handle this failure in link chain.

> 
> 
> > +			return NULL;
> > +		}
> > +		return lead;
> > +	} else if (req->flags & REQ_F_SQE_GROUP) {
> > +		group->head = req;
> > +		group->last = req;
> > +		req->grp_refs = 1;
> > +		req->flags |= REQ_F_SQE_GROUP_LEADER;
> > +		return NULL;
> > +	} else {
> 
> We shouldn't be able to get here.
> 
> if (WARN_ONCE(!(req->flags & GROUP)))
> 	...
> group->head = req;
> ...

OK.

> 
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
> 
> Same as above, you don't need to check for IO_REQ_LINK_FLAGS.
> io_queue_sqe_fallback()

OK.


Thanks,
Ming


