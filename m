Return-Path: <io-uring+bounces-2658-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B97C948B72
	for <lists+io-uring@lfdr.de>; Tue,  6 Aug 2024 10:38:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6B4B1F24FA2
	for <lists+io-uring@lfdr.de>; Tue,  6 Aug 2024 08:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5A001BD01D;
	Tue,  6 Aug 2024 08:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PaRGPdO0"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC3215F409
	for <io-uring@vger.kernel.org>; Tue,  6 Aug 2024 08:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722933509; cv=none; b=Kc2Upp/07JO179CBJyF2Nzpa4ZFmpr4SaQ1uEW9iCufaJwU+O3ab8myl45OfccF2Zgg54lnQBUbUIUNrieK5/6MO0KFbIpXmnKznTshCgzcxkZqS4YNbHJjaapRDPDEMkLWT1bjKw0sU5rbLuaUtH7XgvpOL3kihTh5lMo44IU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722933509; c=relaxed/simple;
	bh=WVZWyIP6uJ5BOtupNx5wwqFBgsVUdt07yyyfBwZFEMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rz1dz2swoNWUQ00TpAGXJLMtRXLwhm7cQpOxCFxJl0So+8bIY9MKKa60/fH/dpJcc/QQooq51wHIkp9JfRIANTwW+fvgvld7d/igNuTQNzrlN59qlmqTjmG+dHM3M5V0lhppBB6mhkcN9f8XbejEl1/nevnmihPrZ1LR0x65O/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PaRGPdO0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722933506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0lKOIM5Vmzv0yyg6noKLYeHXDJklfR3/ebBux3lZFnI=;
	b=PaRGPdO0cNOKzpq9jt0/HdFIUSbNwNIwPx2A+fIIWBhzSq2xJVbZdVMPSzfccNMhbU/+Ms
	5IL5swOPmi3fa4C9CRaS234doztzmJc2NfwWznmg0H5Eiqc5MJCpti/ZyGNjXw+fQRlHAY
	FvBZqMw+Nx/7oekkPtzVpHUMyF2Upq8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-564-IfEobIgOPoiJsZPjxi7YPA-1; Tue,
 06 Aug 2024 04:38:23 -0400
X-MC-Unique: IfEobIgOPoiJsZPjxi7YPA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E5CD71955F42;
	Tue,  6 Aug 2024 08:38:21 +0000 (UTC)
Received: from fedora (unknown [10.72.116.158])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 588CE19560AE;
	Tue,  6 Aug 2024 08:38:14 +0000 (UTC)
Date: Tue, 6 Aug 2024 16:38:08 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>,
	ming.lei@redhat.com
Subject: Re: [PATCH V4 4/8] io_uring: support SQE group
Message-ID: <ZrHg8LUOeM23318x@fedora>
References: <20240706031000.310430-1-ming.lei@redhat.com>
 <20240706031000.310430-5-ming.lei@redhat.com>
 <fa5e8098-f72f-43c1-90c1-c3eaebfea3d5@gmail.com>
 <Zp+/hBwCBmKSGy5K@fedora>
 <0fa0c9b9-cfb9-4710-85d0-2f6b4398603c@gmail.com>
 <ZqIp7/Ci+abGcZLG@fedora>
 <5fd602d8-0c0b-418a-82bc-955ab0444b1e@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fd602d8-0c0b-418a-82bc-955ab0444b1e@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Jul 29, 2024 at 02:58:58PM +0100, Pavel Begunkov wrote:
> On 7/25/24 11:33, Ming Lei wrote:
> > On Wed, Jul 24, 2024 at 02:41:38PM +0100, Pavel Begunkov wrote:
> > > On 7/23/24 15:34, Ming Lei wrote:
> ...
> > > > But grp_refs is dropped after io-wq request reference drops to
> > > > zero, then both io-wq and nor-io-wq code path can be unified
> > > > wrt. dealing with grp_refs, meantime it needn't to be updated
> > > > in extra(io-wq) context.
> > > 
> > > Let's try to describe how it can work. First, I'm only describing
> > > the dep mode for simplicity. And for the argument's sake we can say
> > > that all CQEs are posted via io_submit_flush_completions.
> > > 
> > > io_req_complete_post() {
> > > 	if (flags & GROUP) {
> > > 		req->io_task_work.func = io_req_task_complete;
> > > 		io_req_task_work_add(req);
> > > 		return;
> > > 	}
> > > 	...
> > > }
> > 
> > OK.
> > 
> > io_wq_free_work() still need to change to not deal with
> > next link & ignoring skip_cqe, because group handling(
> 
> No, it doesn't need to know about all that.
> 
> > cqe posting, link advance) is completely moved into
> > io_submit_flush_completions().
> 
> It has never been guaranteed that io_req_complete_post()
> will be the one completing the request,
> io_submit_flush_completions() can always happen.
> 
> 
> struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
> {
> 	...
> 	if (req_ref_put_and_test(req)) {
> 		nxt = io_req_find_next(req);
> 		io_free_req();
> 	}
> }
> 
> We queue linked requests only when all refs are dropped, and
> the group handling in my snippet is done before we drop the
> owner's reference.
> 
> IOW, you won't hit io_free_req() in io_wq_free_work() for a
> leader unless all members in its group got completed and
> the leader already went through the code dropping those shared
> ublk buffers.

If io_free_req() won't be called for leader, leader won't be added
to ->compl_reqs, and it has to be generated when all members are
completed in __io_submit_flush_completions().

For !io_wq, we can align to this way by not completing leader in
io_req_complete_defer().

The above implementation looks simpler, and more readable.

> 
> 
> > > You can do it this way, nobody would ever care, and it shouldn't
> > > affect performance. Otherwise everything down below can probably
> > > be extended to io_req_complete_post().
> > > 
> > > To avoid confusion in terminology, what I call a member below doesn't
> > > include a leader. IOW, a group leader request is not a member.
> > > 
> > > At the init we have:
> > > grp_refs = nr_members; /* doesn't include the leader */
> > > 
> > > Let's also say that the group leader can and always goes
> > > through io_submit_flush_completions() twice, just how it's
> > > with your patches.
> > > 
> > > 1) The first time we see the leader in io_submit_flush_completions()
> > > is when it's done with resource preparation. For example, it was
> > > doing some IO into a buffer, and now is ready to give that buffer
> > > with data to group members. At this point it should queue up all group
> > > members. And we also drop 1 grp_ref. There will also be no
> > > io_issue_sqe() for it anymore.
> > 
> > Ok, then it is just the case with dependency.
> > 
> > > 
> > > 2) Members are executed and completed, in io_submit_flush_completions()
> > > they drop 1 grp_leader->grp_ref reference each.
> > > 
> > > 3) When all members complete, leader's grp_ref becomes 0. Here
> > > the leader is queued for io_submit_flush_completions() a second time,
> > > at which point it drops ublk buffers and such and gets destroyed.
> > > 
> > > You can post a CQE in 1) and then set CQE_SKIP. Can also be fitted
> > > into 3). A pseudo code for when we post it in step 1)
> > 
> > This way should work, but it confuses application because
> > the leader is completed before all members:
> > 
> > - leader usually provide resources in group wide
> > - member consumes this resource
> > - leader is supposed to be completed after all consumer(member) are
> > done.
> > 
> > Given it is UAPI, we have to be careful with CQE posting order.
> 
> That's exactly what I was telling about the uapi previously,
> I don't believe we want to inverse the natural CQE order.
> 
> Regardless, the order can be inversed like this:
> 
> __io_flush_completions() {
> 	...
> 	if (req->flags & (SKIP_CQE|GROUP)) {
> 		if (req->flags & SKIP_CQE)
> 			continue;
> 		// post a CQE only when we see it for a 2nd time in io_flush_completion();
> 		if (is_leader() && !(req->flags & ALREADY_SEEN))
> 			continue;

I am afraid that ALREADY_SEEN can't work, since leader can only be added
to ->compl_reqs once.


Thanks, 
Ming


