Return-Path: <io-uring+bounces-3131-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE089747C2
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 03:28:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E39631C2544E
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 01:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75E2DCA62;
	Wed, 11 Sep 2024 01:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MDsCnrkT"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4241621105
	for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 01:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726018117; cv=none; b=t1Wmyxvu7noUaLcLakRtpiTgpVfwJGmbapqevagnkyIXEjHkm0Pa1SFrCUR1FbmdeR3o7gu6c8tH0FmZ0vvyGcHnqehSU/KvXY/RZkeBi/cBMORensznugmyCW6ZggCTINvYB9Pyz628JaE115KiOfxjwlWL/eRmIpOHQhkce6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726018117; c=relaxed/simple;
	bh=I1FySbNVbbZX/XBUo+yiYw7kXyaBBq+0bAYYEO5R5Dc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IHERB23NJYuJtAkXQ6dfdC7zKDhJt0OumIcp8CawyLBvchTa1n9cs4Yzvpb4GKEnYEGivhL2Sn02k0f2ZlcImI4dBWeZDfm7hBYxRfEZ1ujIgHa73MyaqVwfqI60qP1uvbU1XRxRZQ3is+0+zDdh+TRG3dUA1agdlYTWH6+YIJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MDsCnrkT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726018114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RjKvxk5aoZ89HNsVl63IjgyK7viMtFjFleapBc0RaEQ=;
	b=MDsCnrkTnF29ie/UavQrIe2ByGmUNP1ngVT5S1DWy8Even52J8Zbsp6gj5mkkXQ0T7TFBH
	i/tGyCiGRSBcFz8E7qogGmVVctWUkJQ1FTfMv7kvK46mrd/uNUMIg2bkda1dCQxsphq/qv
	/7zh0fTc+4zt9yAq2HaRlNeld29ZXKg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-323-hx1JP7r2PYasV4HMNOe-1Q-1; Tue,
 10 Sep 2024 21:28:30 -0400
X-MC-Unique: hx1JP7r2PYasV4HMNOe-1Q-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A45F61955BC1;
	Wed, 11 Sep 2024 01:28:29 +0000 (UTC)
Received: from fedora (unknown [10.72.116.76])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AB4519560A3;
	Wed, 11 Sep 2024 01:28:23 +0000 (UTC)
Date: Wed, 11 Sep 2024 09:28:18 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH V5 4/8] io_uring: support SQE group
Message-ID: <ZuDyMtvImGSdrqkh@fedora>
References: <20240808162503.345913-1-ming.lei@redhat.com>
 <20240808162503.345913-5-ming.lei@redhat.com>
 <3c819871-7ca3-47ea-b752-c4a8a49f8304@gmail.com>
 <Zs/5Hpi16aQKlHFw@fedora>
 <36ae357b-bebe-4276-a8db-d6dccf227b61@gmail.com>
 <ZtweiCfLOJmdeY0Z@fedora>
 <7050796e-be88-4e01-abdb-976baba2f83b@gmail.com>
 <ZuBgCbjuED/KOFTt@fedora>
 <dacd0c73-e97d-40b3-81a1-2e5ae42b21b7@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dacd0c73-e97d-40b3-81a1-2e5ae42b21b7@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Sep 10, 2024 at 09:31:45PM +0100, Pavel Begunkov wrote:
> On 9/10/24 16:04, Ming Lei wrote:
> > On Tue, Sep 10, 2024 at 02:12:53PM +0100, Pavel Begunkov wrote:
> > > On 9/7/24 10:36, Ming Lei wrote:
> > > ...
> > > > > > Wrt. ublk, group provides zero copy, and the ublk io(group) is generic
> > > > > > IO, sometime IO_LINK is really needed & helpful, such as in ublk-nbd,
> > > > > > send(tcp) requests need to be linked & zc. And we shouldn't limit IO_LINK
> > > > > > for generic io_uring IO.
> > > > > > 
> > > > > > > from nuances as such, which would be quite hard to track, the semantics
> > > > > > > of IOSQE_CQE_SKIP_SUCCESS is unclear.
> > > > > > 
> > > > > > IO group just follows every normal request.
> > > > > 
> > > > > It tries to mimic but groups don't and essentially can't do it the
> > > > > same way, at least in some aspects. E.g. IOSQE_CQE_SKIP_SUCCESS
> > > > > usually means that all following will be silenced. What if a
> > > > > member is CQE_SKIP, should it stop the leader from posting a CQE?
> > > > > And whatever the answer is, it'll be different from the link's
> > > > > behaviour.
> > > > 
> > > > Here it looks easier than link's:
> > > > 
> > > > - only leader's IOSQE_CQE_SKIP_SUCCESS follows linked request's rule
> > > > - all members just respects the flag for its own, and not related with
> > > > leader's
> > > > 
> > > > > 
> > > > > Regardless, let's forbid IOSQE_CQE_SKIP_SUCCESS and linked timeouts
> > > > > for groups, that can be discussed afterwards.
> > > > 
> > > > It should easy to forbid IOSQE_CQE_SKIP_SUCCESS which is per-sqe, will do
> > > > it in V6.
> > > > 
> > > > I am not sure if it is easy to disallow IORING_OP_LINK_TIMEOUT, which
> > > > covers all linked sqes, and group leader could be just one of them.
> > > > Can you share any idea about the implementation to forbid LINK_TIMEOUT
> > > > for sqe group?
> > > 
> > > diff --git a/io_uring/timeout.c b/io_uring/timeout.c
> > > index 671d6093bf36..83b5fd64b4e9 100644
> > > --- a/io_uring/timeout.c
> > > +++ b/io_uring/timeout.c
> > > @@ -542,6 +542,9 @@ static int __io_timeout_prep(struct io_kiocb *req,
> > >   	data->mode = io_translate_timeout_mode(flags);
> > >   	hrtimer_init(&data->timer, io_timeout_get_clock(data), data->mode);
> > > +	if (is_timeout_link && req->ctx->submit_state.group.head)
> > > +		return -EINVAL;
> > > +
> > >   	if (is_timeout_link) {
> > >   		struct io_submit_link *link = &req->ctx->submit_state.link;
> > > 
> > > This should do, they already look into the ctx's link list. Just move
> > > it into the "if (is_timeout_link)" block.
> > 
> > OK.
> > 
> > > 
> > > 
> > > > > > 1) fail in linked chain
> > > > > > - follows IO_LINK's behavior since io_fail_links() covers io group
> > > > > > 
> > > > > > 2) otherwise
> > > > > > - just respect IOSQE_CQE_SKIP_SUCCESS
> > > > > > 
> > > > > > > And also it doen't work with IORING_OP_LINK_TIMEOUT.
> > > > > > 
> > > > > > REQ_F_LINK_TIMEOUT can work on whole group(or group leader) only, and I
> > > > > > will document it in V6.
> > > > > 
> > > > > It would still be troublesome. When a linked timeout fires it searches
> > > > > for the request it's attached to and cancels it, however, group leaders
> > > > > that queued up their members are discoverable. But let's say you can find
> > > > > them in some way, then the only sensbile thing to do is cancel members,
> > > > > which should be doable by checking req->grp_leader, but might be easier
> > > > > to leave it to follow up patches.
> > > > 
> > > > We have changed sqe group to start queuing members after leader is
> > > > completed. link timeout will cancel leader with all its members via
> > > > leader->grp_link, this behavior should respect IORING_OP_LINK_TIMEOUT
> > > > completely.
> > > > 
> > > > Please see io_fail_links() and io_cancel_group_members().
> > > > 
> > > > > 
> > > > > 
> > > > > > > > +
> > > > > > > > +		lead->grp_refs += 1;
> > > > > > > > +		group->last->grp_link = req;
> > > > > > > > +		group->last = req;
> > > > > > > > +
> > > > > > > > +		if (req->flags & REQ_F_SQE_GROUP)
> > > > > > > > +			return NULL;
> > > > > > > > +
> > > > > > > > +		req->grp_link = NULL;
> > > > > > > > +		req->flags |= REQ_F_SQE_GROUP;
> > > > > > > > +		group->head = NULL;
> > > > > > > > +		if (lead->flags & REQ_F_FAIL) {
> > > > > > > > +			io_queue_sqe_fallback(lead);
> > > > > > > 
> > > > > > > Let's say the group was in the middle of a link, it'll
> > > > > > > complete that group and continue with assembling / executing
> > > > > > > the link when it should've failed it and honoured the
> > > > > > > request order.
> > > > > > 
> > > > > > OK, here we can simply remove the above two lines, and link submit
> > > > > > state can handle this failure in link chain.
> > > > > 
> > > > > If you just delete then nobody would check for REQ_F_FAIL and
> > > > > fail the request.
> > > > 
> > > > io_link_assembling() & io_link_sqe() checks for REQ_F_FAIL and call
> > > > io_queue_sqe_fallback() either if it is in link chain or
> > > > not.
> > > 
> > > The case we're talking about is failing a group, which is
> > > also in the middle of a link.
> > > 
> > > LINK_HEAD -> {GROUP_LEAD, GROUP_MEMBER}
> > > 
> > > Let's say GROUP_MEMBER fails and sets REQ_F_FAIL to the lead,
> > > then in v5 does:
> > > 
> > > if (lead->flags & REQ_F_FAIL) {
> > > 	io_queue_sqe_fallback(lead);
> > > 	return NULL;
> > > }
> > > 
> > > In which case it posts cqes for GROUP_LEAD and GROUP_MEMBER,
> > > and then try to execute LINK_HEAD (without failing it), which
> > > is wrong. So first we need:
> > > 
> > > if (state.linked_link.head)
> > > 	req_fail_link_node(state.linked_link.head);
> > 
> > For group leader, link advancing is always done via io_queue_next(), in
> > which io_disarm_next() is called for failing the whole remained link
> > if the current request is marked as FAIL.
> > 
> > > 
> > > And then we can't just remove io_queue_sqe_fallback(), because
> > > when a group is not linked there would be no io_link_sqe()
> > > to fail it. You can do:
> > 
> > If one request in group is marked as FAIL, io_link_assembling()
> > will return true, and io_link_sqe() will fail it.
> 
> Hmm, you're right, even though it's not a great way of doing it,
> i.e. pushing a req into io_link_sqe() even when linking has never
> been requested, but that's fine. I can drop a quick patch on
> top if it bothers me.

Yeah, it isn't very readable, but following the original logic.

Anyway, I will comment that non-linked request is covered by
the code block.


Thanks,
Ming


