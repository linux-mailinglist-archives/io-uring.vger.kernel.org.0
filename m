Return-Path: <io-uring+bounces-3430-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C385991C77
	for <lists+io-uring@lfdr.de>; Sun,  6 Oct 2024 05:54:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23E7B1C213D1
	for <lists+io-uring@lfdr.de>; Sun,  6 Oct 2024 03:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F39614A0A4;
	Sun,  6 Oct 2024 03:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MVtxYp3X"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63794EAC6
	for <io-uring@vger.kernel.org>; Sun,  6 Oct 2024 03:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728186867; cv=none; b=VOpBHmwjGONFLuiGZvnVewbhvNGTZw/QWJxIox5N4ku3q9tolqPE+Jz6+NxSKzKAHX6JyxJEfXoLxvVb1HnwRrQKAe2J79n2peVbCbpTrkvaHOXg/2ekGTYv1OLNVFnwGtXsQZ0ybc8avBbY2VyCvdd8kaXQw/Z3sIPBw7+dh0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728186867; c=relaxed/simple;
	bh=cIKr7O4yQzF4ar3MExX335MGYdIri/si1RGn4cMWjA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jWr5Ll6gDqo11c+DAWY4QGCcfTG4mkyIOU9FZV2eSGxi4jqA7TMLvdEAAT4GX+WnDWYNrjLngUrT6g7iNi5lEGdEoqrzOOTaG4re83MzKqykiDKrpXehxNalNk26GOYo+YFqItpsn1ymMw2mVIgEr5cS17wgN8tb61uTrXx0MU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MVtxYp3X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728186864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pSq3nTl6jIdbog6zkho/feio3dOuT9WYpCQ8vRqv8ZA=;
	b=MVtxYp3Xcn3PHrPi7e56ViftOh/Ldm+HMn68iM6mG0WGYtPHCKi+WsLJuOsDRPd2rL75Ks
	fqc6sJ/Nq+qpQ8U5wjraEy3OIVHUlGS09+TM0FOor7pKBjuuI4bKNspVU9dvcY0POl3xWZ
	utfNN9QBYbPWw/yXtJkZ1far8KDrzSM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-a_Uht70wOMGLnUazx95dcQ-1; Sat,
 05 Oct 2024 23:54:22 -0400
X-MC-Unique: a_Uht70wOMGLnUazx95dcQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6413B195608A;
	Sun,  6 Oct 2024 03:54:21 +0000 (UTC)
Received: from fedora (unknown [10.72.116.21])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A572B3000198;
	Sun,  6 Oct 2024 03:54:14 +0000 (UTC)
Date: Sun, 6 Oct 2024 11:54:08 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>,
	ming.lei@redhat.com
Subject: Re: [PATCH V6 4/8] io_uring: support SQE group
Message-ID: <ZwIJ4Hn52-tm22Z8@fedora>
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-5-ming.lei@redhat.com>
 <239e42d2-791e-4ef5-a312-8b5959af7841@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <239e42d2-791e-4ef5-a312-8b5959af7841@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Oct 04, 2024 at 02:12:28PM +0100, Pavel Begunkov wrote:
> On 9/12/24 11:49, Ming Lei wrote:
> ...
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> > @@ -111,13 +111,15 @@
> ...
> > +static void io_complete_group_member(struct io_kiocb *req)
> > +{
> > +	struct io_kiocb *lead = get_group_leader(req);
> > +
> > +	if (WARN_ON_ONCE(!(req->flags & REQ_F_SQE_GROUP) ||
> > +			 lead->grp_refs <= 0))
> > +		return;
> > +
> > +	/* member CQE needs to be posted first */
> > +	if (!(req->flags & REQ_F_CQE_SKIP))
> > +		io_req_commit_cqe(req->ctx, req);
> > +
> > +	req->flags &= ~REQ_F_SQE_GROUP;
> 
> I can't say I like this implicit state machine too much,
> but let's add a comment why we need to clear it. i.e.
> it seems it wouldn't be needed if not for the
> mark_last_group_member() below that puts it back to tunnel
> the leader to io_free_batch_list().

Yeah, the main purpose is for reusing the flag for marking last
member, will add comment for this usage.

> 
> > +
> > +	/* Set leader as failed in case of any member failed */
> > +	if (unlikely((req->flags & REQ_F_FAIL)))
> > +		req_set_fail(lead);
> > +
> > +	if (!--lead->grp_refs) {
> > +		mark_last_group_member(req);
> > +		if (!(lead->flags & REQ_F_CQE_SKIP))
> > +			io_req_commit_cqe(lead->ctx, lead);
> > +	} else if (lead->grp_refs == 1 && (lead->flags & REQ_F_SQE_GROUP)) {
> > +		/*
> > +		 * The single uncompleted leader will degenerate to plain
> > +		 * request, so group leader can be always freed via the
> > +		 * last completed member.
> > +		 */
> > +		lead->flags &= ~REQ_F_SQE_GROUP_LEADER;
> 
> What does this try to handle? A group with a leader but no
> members? If that's the case, io_group_sqe() and io_submit_state_end()
> just need to fail such groups (and clear REQ_F_SQE_GROUP before
> that).

The code block allows to issue leader and members concurrently, but
we have changed to always issue members after leader is completed, so
the above code can be removed now.

> 
> > +	}
> > +}
> > +
> > +static void io_complete_group_leader(struct io_kiocb *req)
> > +{
> > +	WARN_ON_ONCE(req->grp_refs <= 1);
> > +	req->flags &= ~REQ_F_SQE_GROUP;
> > +	req->grp_refs -= 1;
> > +}
> > +
> > +static void io_complete_group_req(struct io_kiocb *req)
> > +{
> > +	if (req_is_group_leader(req))
> > +		io_complete_group_leader(req);
> > +	else
> > +		io_complete_group_member(req);
> > +}
> > +
> >   static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
> >   {
> >   	struct io_ring_ctx *ctx = req->ctx;
> > @@ -890,7 +1005,8 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
> >   	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
> >   	 * the submitter task context, IOPOLL protects with uring_lock.
> >   	 */
> > -	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL)) {
> > +	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL) ||
> > +	    req_is_group_leader(req)) {
> 
> We're better to push all group requests to io_req_task_complete(),
> not just a group leader. While seems to be correct, that just
> overcomplicates the request's flow, it can post a CQE here, but then
> still expect to do group stuff in the CQE posting loop
> (flush_completions -> io_complete_group_req), which might post another
> cqe for the leader, and then do yet another post processing loop in
> io_free_batch_list().

OK, it is simpler to complete all group reqs via tw.

> 
> 
> >   		req->io_task_work.func = io_req_task_complete;
> >   		io_req_task_work_add(req);
> >   		return;
> > @@ -1388,11 +1504,43 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
> >   						    comp_list);
> >   		if (unlikely(req->flags & IO_REQ_CLEAN_SLOW_FLAGS)) {
> > +			if (req_is_last_group_member(req) ||
> > +					req_is_group_leader(req)) {
> > +				struct io_kiocb *leader;
> > +
> > +				/* Leader is freed via the last member */
> > +				if (req_is_group_leader(req)) {
> > +					if (req->grp_link)
> > +						io_queue_group_members(req);
> > +					node = req->comp_list.next;
> > +					continue;
> > +				}
> > +
> > +				/*
> > +				 * Prepare for freeing leader since we are the
> > +				 * last group member
> > +				 */
> > +				leader = get_group_leader(req);
> > +				leader->flags &= ~REQ_F_SQE_GROUP_LEADER;
> > +				req->flags &= ~REQ_F_SQE_GROUP;
> > +				/*
> > +				 * Link leader to current request's next,
> > +				 * this way works because the iterator
> > +				 * always check the next node only.
> > +				 *
> > +				 * Be careful when you change the iterator
> > +				 * in future
> > +				 */
> > +				wq_stack_add_head(&leader->comp_list,
> > +						  &req->comp_list);
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
> > @@ -1427,8 +1575,16 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
> >   		struct io_kiocb *req = container_of(node, struct io_kiocb,
> >   					    comp_list);
> > -		if (!(req->flags & REQ_F_CQE_SKIP))
> > -			io_req_commit_cqe(ctx, req);
> > +		if (unlikely(req->flags & (REQ_F_CQE_SKIP | REQ_F_SQE_GROUP))) {
> > +			if (req->flags & REQ_F_SQE_GROUP) {
> > +				io_complete_group_req(req);
> > +				continue;
> > +			}
> > +
> > +			if (req->flags & REQ_F_CQE_SKIP)
> > +				continue;
> > +		}
> > +		io_req_commit_cqe(ctx, req);
> >   	}
> >   	__io_cq_unlock_post(ctx);
> > @@ -1638,8 +1794,12 @@ static u32 io_get_sequence(struct io_kiocb *req)
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
> ...
> > @@ -2217,8 +2470,22 @@ static void io_submit_state_end(struct io_ring_ctx *ctx)
> >   {
> >   	struct io_submit_state *state = &ctx->submit_state;
> > -	if (unlikely(state->link.head))
> > -		io_queue_sqe_fallback(state->link.head);
> > +	if (unlikely(state->group.head || state->link.head)) {
> > +		/* the last member must set REQ_F_SQE_GROUP */
> > +		if (state->group.head) {
> > +			struct io_kiocb *lead = state->group.head;
> > +
> > +			state->group.last->grp_link = NULL;
> > +			if (lead->flags & IO_REQ_LINK_FLAGS)
> > +				io_link_sqe(&state->link, lead);
> > +			else
> > +				io_queue_sqe_fallback(lead);
> 
> req1(F_LINK), req2(F_GROUP), req3
> 
> is supposed to be turned into
> 
> req1 -> {group: req2 (lead), req3 }
> 
> but note that req2 here doesn't have F_LINK set.
> I think it should be like this instead:
> 
> if (state->link.head)
> 	io_link_sqe();
> else
> 	io_queue_sqe_fallback(lead);

Indeed, the above change is correct.


Thanks,
Ming


