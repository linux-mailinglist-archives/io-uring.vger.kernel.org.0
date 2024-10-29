Return-Path: <io-uring+bounces-4090-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 664E19B3FF0
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 02:51:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E020C1F23182
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 01:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B957CA6F;
	Tue, 29 Oct 2024 01:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pontgzql"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2334431
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 01:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730166664; cv=none; b=bg7dUFxIgcq/XefbACiRW53/51sLVjTcg8dtQ+reauhFC+U6LiDmdWwVi34CsugC4zkv8f5dAGm3XWQeOALXBwVVUY8+aGdOC9XOdgT9qBSbj4olXQ6f7Ic54d59TTsEFO9C2J1D7j47QL82nHs/VrA35c+oOVc3na1VLHIHl7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730166664; c=relaxed/simple;
	bh=txW3CKptJhzC1ew4unlAHMc2yCtKtUfyUwfFaFKRmJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MZ2DXp4URIydy/pggXjvoz3XUCFpQXqEQsg5yeGWWI+nKF1/HM77jPujxf7jkNutpCAxwKXU/C+oFq9uzWVFVmnuDY6AnwfWd3i16Z07ik3DZaNyfXLn8ZOQiilI+DiXe8L6IaO8GVU6kmIK6RbJMLfF5vy+OFRSaQ4vyJKfhBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pontgzql; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730166660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=99y8sBj3b0GfVUCs3MoqEoXu8dbndbzPkXRXg5YM9tM=;
	b=Pontgzql0vSXhOOAxQvIu/G2ow2qPeLXUioRxyI2UiDTcQUp8jamehxYDn9gFUEdwBa6SY
	ESEnQnmKUKwtrngzqDijMRzfIUazpMzJaxWDV1cl1Ta36sP9XaT1LFWHppjYOXMBWkq6Gh
	OUxbFMswAaW+EXWfvBJ0hPI+9FFu1CM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-206-C31diDnsORmqV7xi-vlpGw-1; Mon,
 28 Oct 2024 21:50:58 -0400
X-MC-Unique: C31diDnsORmqV7xi-vlpGw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1754D195FE30;
	Tue, 29 Oct 2024 01:50:57 +0000 (UTC)
Received: from fedora (unknown [10.72.116.82])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E30D81956086;
	Tue, 29 Oct 2024 01:50:51 +0000 (UTC)
Date: Tue, 29 Oct 2024 09:50:45 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH V8 4/7] io_uring: support SQE group
Message-ID: <ZyA_dbiU0ho5IJYA@fedora>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
 <20241025122247.3709133-5-ming.lei@redhat.com>
 <5417bcc5-e766-4044-905b-da5768d69f29@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5417bcc5-e766-4044-905b-da5768d69f29@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Mon, Oct 28, 2024 at 06:12:34PM -0600, Jens Axboe wrote:
> On 10/25/24 6:22 AM, Ming Lei wrote:
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
> > the two flags can't be set for group members. For the sake of
> > simplicity, IORING_OP_LINK_TIMEOUT is disallowed for SQE group now.
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
> > extend sqe->flags with io_uring context flag, such as use __pad3 for
> > non-uring_cmd OPs and part of uring_cmd_flags for uring_cmd OP.
> 
> Since it's taking the last flag, maybe a better idea to have the last
> flag mean "more flags in (for example) __pad3" and put the new flag
> there? Not sure you mean in terms of "io_uring context flag", would it
> be an enter flag? Ring required to be setup with a certain flag? Neither
> of those seem super encouraging, imho.

I meant:

If "more flags in __pad3" is enabled in future we may claim it as one 
feature to userspace, such as IORING_FEAT_EXT_FLAG.

Will improve the above commit log.

> 
> Apart from that, just a few minor nits below.
> 
> > +void io_fail_group_members(struct io_kiocb *req)
> > +{
> > +	struct io_kiocb *member = req->grp_link;
> > +
> > +	while (member) {
> > +		struct io_kiocb *next = member->grp_link;
> > +
> > +		if (!(member->flags & REQ_F_FAIL)) {
> > +			req_set_fail(member);
> > +			io_req_set_res(member, -ECANCELED, 0);
> > +		}
> > +		member = next;
> > +	}
> > +}
> > +
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
> 
> Was going to say don't check for !member, you have the while loop. Which
> is what you do in the helper above. You can also drop the parens in this
> one.

OK, will remove the check `!member` and all parens.

> 
> > +static enum group_mem io_prep_free_group_req(struct io_kiocb *req,
> > +					     struct io_kiocb **leader)
> > +{
> > +	/*
> > +	 * Group completion is done, so clear the flag for avoiding double
> > +	 * handling in case of io-wq
> > +	 */
> > +	req->flags &= ~REQ_F_SQE_GROUP;
> > +
> > +	if (req_is_group_leader(req)) {
> > +		/* Queue members now */
> > +		if (req->grp_link)
> > +			io_queue_group_members(req);
> > +		return GROUP_LEADER;
> > +	} else {
> > +		if (!req_is_last_group_member(req))
> > +			return GROUP_OTHER_MEMBER;
> > +
> > +		/*
> > +		 * Prepare for freeing leader which can only be found from
> > +		 * the last member
> > +		 */
> > +		*leader = req->grp_leader;
> > +		(*leader)->flags &= ~REQ_F_SQE_GROUP_LEADER;
> > +		req->grp_leader = NULL;
> > +		return GROUP_LAST_MEMBER;
> > +	}
> > +}
> 
> Just drop the second indentation here.

OK.

> 
> > @@ -927,7 +1051,8 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
> >  	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
> >  	 * the submitter task context, IOPOLL protects with uring_lock.
> >  	 */
> > -	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL)) {
> > +	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL) ||
> > +	    (req->flags & REQ_F_SQE_GROUP)) {
> >  		req->io_task_work.func = io_req_task_complete;
> >  		io_req_task_work_add(req);
> >  		return;
> 
> Minor detail, but might be nice with a REQ_F_* flag for this in the
> future.
> 
> > @@ -1450,8 +1596,16 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
> >  		struct io_kiocb *req = container_of(node, struct io_kiocb,
> >  					    comp_list);
> >  
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
> >  	}
> >  	__io_cq_unlock_post(ctx);
> >  
> > @@ -1661,8 +1815,12 @@ static u32 io_get_sequence(struct io_kiocb *req)
> >  	struct io_kiocb *cur;
> >  
> >  	/* need original cached_sq_head, but it was increased for each req */
> > -	io_for_each_link(cur, req)
> > -		seq--;
> > +	io_for_each_link(cur, req) {
> > +		if (req_is_group_leader(cur))
> > +			seq -= cur->grp_refs;
> > +		else
> > +			seq--;
> > +	}
> >  	return seq;
> >  }
> >  
> > @@ -2124,6 +2282,67 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
> >  	return def->prep(req, sqe);
> >  }
> >  
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
> > +		/*
> > +		 * Members can't be in link chain, can't be drained, but
> > +		 * the whole group can be linked or drained by setting
> > +		 * flags on group leader.
> > +		 *
> > +		 * IOSQE_CQE_SKIP_SUCCESS can't be set for member
> > +		 * for the sake of simplicity
> > +		 */
> > +		if (req->flags & (IO_REQ_LINK_FLAGS | REQ_F_IO_DRAIN |
> > +				REQ_F_CQE_SKIP))
> > +			req_fail_link_node(lead, -EINVAL);
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
> > +
> > +		return lead;
> > +	} else {
> > +		if (WARN_ON_ONCE(!(req->flags & REQ_F_SQE_GROUP)))
> > +			return req;
> > +		group->head = req;
> > +		group->last = req;
> > +		req->grp_refs = 1;
> > +		req->flags |= REQ_F_SQE_GROUP_LEADER;
> > +		return NULL;
> > +	}
> > +}
> 
> Same here, drop the 2nd indentation.

OK.

> 
> > diff --git a/io_uring/timeout.c b/io_uring/timeout.c
> > index 9973876d91b0..ed6c74f1a475 100644
> > --- a/io_uring/timeout.c
> > +++ b/io_uring/timeout.c
> > @@ -149,6 +149,8 @@ static void io_req_tw_fail_links(struct io_kiocb *link, struct io_tw_state *ts)
> >  			res = link->cqe.res;
> >  		link->link = NULL;
> >  		io_req_set_res(link, res, 0);
> > +		if (req_is_group_leader(link))
> > +			io_fail_group_members(link);
> >  		io_req_task_complete(link, ts);
> >  		link = nxt;
> >  	}
> > @@ -543,6 +545,10 @@ static int __io_timeout_prep(struct io_kiocb *req,
> >  	if (is_timeout_link) {
> >  		struct io_submit_link *link = &req->ctx->submit_state.link;
> >  
> > +		/* so far disallow IO group link timeout */
> > +		if (req->ctx->submit_state.group.head)
> > +			return -EINVAL;
> > +
> 
> For now, disallow IO group linked timeout

OK.

thanks,
Ming


