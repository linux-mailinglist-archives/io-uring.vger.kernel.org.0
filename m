Return-Path: <io-uring+bounces-3115-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FA1E973AF0
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 17:05:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A7FF1F2539C
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 15:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4797194A43;
	Tue, 10 Sep 2024 15:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y0v4rt0v"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7EC1DFD1
	for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 15:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725980697; cv=none; b=nlsI2Vb0OaKlobRP0DB49raWHa65se8mOxnnMOrF+rQ0NHlQEyW/XQd2wXdSItuWhnWOts5L1aDpf7/h0IfVDVfgA0IJ87sJHpo8Alx8lhxSYPpTXpQCarCxY6BTuKGmkAkmSdZ40EY8n+PI1T6kOYTXxAxg+cCUZ9ung0PIhms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725980697; c=relaxed/simple;
	bh=4mgHDfSax/5TSkAWs3Ho/u/j87cQNsUksLX15hjdbG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e/oDstxxHUnp+QW2U3A/13SZFzYSUpcpQ/mG/M2KZZxeEXtcjtheXr1Hr8xr7/K26eDLgg8CgjLIZAB1DHyrxFai+c8NIXePvKqCRm/IBJSknCSxuMJ+4TeAwBK59/p2nZZsDvp3YYmGjt4WTEqOwx4D9515ifm5GrNG0/AOiXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y0v4rt0v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725980695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GDz0byhQS+s6u6DW8Qwii+Zg/kt7+Og96iaRCkOZvnU=;
	b=Y0v4rt0vUg8l4JcnySJ/lLxccv3rIhLJOq/1WKDxExWVgRvVVi9VvJMKldDDTvtFzA1ohT
	SC2vIN7eB4T5+PyxlbpSW9kaU4nAY0eVb6pg6DzbvotA1WxXd62eYrZghCGfJEZk8HcjaO
	Q+tW4Zd0JnrcBsUJMNcw8Bj4UTGxuGg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-_4-o3rENNBK1PNlDP979Tw-1; Tue,
 10 Sep 2024 11:04:53 -0400
X-MC-Unique: _4-o3rENNBK1PNlDP979Tw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B6E71956096;
	Tue, 10 Sep 2024 15:04:52 +0000 (UTC)
Received: from fedora (unknown [10.72.116.11])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 77B711955D48;
	Tue, 10 Sep 2024 15:04:47 +0000 (UTC)
Date: Tue, 10 Sep 2024 23:04:41 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>,
	ming.lei@redhat.com
Subject: Re: [PATCH V5 4/8] io_uring: support SQE group
Message-ID: <ZuBgCbjuED/KOFTt@fedora>
References: <20240808162503.345913-1-ming.lei@redhat.com>
 <20240808162503.345913-5-ming.lei@redhat.com>
 <3c819871-7ca3-47ea-b752-c4a8a49f8304@gmail.com>
 <Zs/5Hpi16aQKlHFw@fedora>
 <36ae357b-bebe-4276-a8db-d6dccf227b61@gmail.com>
 <ZtweiCfLOJmdeY0Z@fedora>
 <7050796e-be88-4e01-abdb-976baba2f83b@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7050796e-be88-4e01-abdb-976baba2f83b@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, Sep 10, 2024 at 02:12:53PM +0100, Pavel Begunkov wrote:
> On 9/7/24 10:36, Ming Lei wrote:
> ...
> > > > Wrt. ublk, group provides zero copy, and the ublk io(group) is generic
> > > > IO, sometime IO_LINK is really needed & helpful, such as in ublk-nbd,
> > > > send(tcp) requests need to be linked & zc. And we shouldn't limit IO_LINK
> > > > for generic io_uring IO.
> > > > 
> > > > > from nuances as such, which would be quite hard to track, the semantics
> > > > > of IOSQE_CQE_SKIP_SUCCESS is unclear.
> > > > 
> > > > IO group just follows every normal request.
> > > 
> > > It tries to mimic but groups don't and essentially can't do it the
> > > same way, at least in some aspects. E.g. IOSQE_CQE_SKIP_SUCCESS
> > > usually means that all following will be silenced. What if a
> > > member is CQE_SKIP, should it stop the leader from posting a CQE?
> > > And whatever the answer is, it'll be different from the link's
> > > behaviour.
> > 
> > Here it looks easier than link's:
> > 
> > - only leader's IOSQE_CQE_SKIP_SUCCESS follows linked request's rule
> > - all members just respects the flag for its own, and not related with
> > leader's
> > 
> > > 
> > > Regardless, let's forbid IOSQE_CQE_SKIP_SUCCESS and linked timeouts
> > > for groups, that can be discussed afterwards.
> > 
> > It should easy to forbid IOSQE_CQE_SKIP_SUCCESS which is per-sqe, will do
> > it in V6.
> > 
> > I am not sure if it is easy to disallow IORING_OP_LINK_TIMEOUT, which
> > covers all linked sqes, and group leader could be just one of them.
> > Can you share any idea about the implementation to forbid LINK_TIMEOUT
> > for sqe group?
> 
> diff --git a/io_uring/timeout.c b/io_uring/timeout.c
> index 671d6093bf36..83b5fd64b4e9 100644
> --- a/io_uring/timeout.c
> +++ b/io_uring/timeout.c
> @@ -542,6 +542,9 @@ static int __io_timeout_prep(struct io_kiocb *req,
>  	data->mode = io_translate_timeout_mode(flags);
>  	hrtimer_init(&data->timer, io_timeout_get_clock(data), data->mode);
> +	if (is_timeout_link && req->ctx->submit_state.group.head)
> +		return -EINVAL;
> +
>  	if (is_timeout_link) {
>  		struct io_submit_link *link = &req->ctx->submit_state.link;
> 
> This should do, they already look into the ctx's link list. Just move
> it into the "if (is_timeout_link)" block.

OK.

> 
> 
> > > > 1) fail in linked chain
> > > > - follows IO_LINK's behavior since io_fail_links() covers io group
> > > > 
> > > > 2) otherwise
> > > > - just respect IOSQE_CQE_SKIP_SUCCESS
> > > > 
> > > > > And also it doen't work with IORING_OP_LINK_TIMEOUT.
> > > > 
> > > > REQ_F_LINK_TIMEOUT can work on whole group(or group leader) only, and I
> > > > will document it in V6.
> > > 
> > > It would still be troublesome. When a linked timeout fires it searches
> > > for the request it's attached to and cancels it, however, group leaders
> > > that queued up their members are discoverable. But let's say you can find
> > > them in some way, then the only sensbile thing to do is cancel members,
> > > which should be doable by checking req->grp_leader, but might be easier
> > > to leave it to follow up patches.
> > 
> > We have changed sqe group to start queuing members after leader is
> > completed. link timeout will cancel leader with all its members via
> > leader->grp_link, this behavior should respect IORING_OP_LINK_TIMEOUT
> > completely.
> > 
> > Please see io_fail_links() and io_cancel_group_members().
> > 
> > > 
> > > 
> > > > > > +
> > > > > > +		lead->grp_refs += 1;
> > > > > > +		group->last->grp_link = req;
> > > > > > +		group->last = req;
> > > > > > +
> > > > > > +		if (req->flags & REQ_F_SQE_GROUP)
> > > > > > +			return NULL;
> > > > > > +
> > > > > > +		req->grp_link = NULL;
> > > > > > +		req->flags |= REQ_F_SQE_GROUP;
> > > > > > +		group->head = NULL;
> > > > > > +		if (lead->flags & REQ_F_FAIL) {
> > > > > > +			io_queue_sqe_fallback(lead);
> > > > > 
> > > > > Let's say the group was in the middle of a link, it'll
> > > > > complete that group and continue with assembling / executing
> > > > > the link when it should've failed it and honoured the
> > > > > request order.
> > > > 
> > > > OK, here we can simply remove the above two lines, and link submit
> > > > state can handle this failure in link chain.
> > > 
> > > If you just delete then nobody would check for REQ_F_FAIL and
> > > fail the request.
> > 
> > io_link_assembling() & io_link_sqe() checks for REQ_F_FAIL and call
> > io_queue_sqe_fallback() either if it is in link chain or
> > not.
> 
> The case we're talking about is failing a group, which is
> also in the middle of a link.
> 
> LINK_HEAD -> {GROUP_LEAD, GROUP_MEMBER}
> 
> Let's say GROUP_MEMBER fails and sets REQ_F_FAIL to the lead,
> then in v5 does:
> 
> if (lead->flags & REQ_F_FAIL) {
> 	io_queue_sqe_fallback(lead);
> 	return NULL;
> }
> 
> In which case it posts cqes for GROUP_LEAD and GROUP_MEMBER,
> and then try to execute LINK_HEAD (without failing it), which
> is wrong. So first we need:
> 
> if (state.linked_link.head)
> 	req_fail_link_node(state.linked_link.head);

For group leader, link advancing is always done via io_queue_next(), in
which io_disarm_next() is called for failing the whole remained link
if the current request is marked as FAIL.

> 
> And then we can't just remove io_queue_sqe_fallback(), because
> when a group is not linked there would be no io_link_sqe()
> to fail it. You can do:

If one request in group is marked as FAIL, io_link_assembling()
will return true, and io_link_sqe() will fail it.


Thanks, 
Ming


