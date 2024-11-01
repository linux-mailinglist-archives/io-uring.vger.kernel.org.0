Return-Path: <io-uring+bounces-4291-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC5219B88B1
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 02:39:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C02F1C21DED
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 01:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12BBA74BF5;
	Fri,  1 Nov 2024 01:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kxl6GJa7"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B44962171
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 01:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730425192; cv=none; b=Q6FUJzNgjk/83J1AiPzU10gXW7unzcof458zBr5VPXGoOXbtnaykBGgMiHDnIDjcJqfY/sIPVHcgUQiDo0ICAXab2bszT5hj254sBdyY19v5xsd6LM9i2DAoIhookSZ8TNj9AtFGP7/0jRBYCbgZHsqxbdSYfJVhxTprhgReOZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730425192; c=relaxed/simple;
	bh=LY2KAuwm2mZ67w34FtyVk1JBGu3JhVDxmSdiJpx+9nI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nxMTxyggMxrrF311dPRp2K9lSFpB+yt7Yec3hiJzLcBAtyM3Uwt1l53mJhINdNHMZKQIGnKjeKEz8xA3HDVkeOtdbIt1BCIIE7jx8IMS1QLssKK0z3JoeXTVa8qlJBafcuycKwdY8ECXh35NFDL1RvAz7dX0oHggDXxDGQlEjng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kxl6GJa7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730425184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b4UZ2rxA3GcTmcKZtghXG7tp6ZcTLATq+IXqEZ8otRI=;
	b=Kxl6GJa7C6fkcZhG2pQvp23H0I3oNdbch7cBk0Gwg3kD+w6BNuVeT3OB4aKo7JWuUh1Emc
	OedZ5a7N+FIUHEj2u+knLazvoK6/GYiQqtIRfXACOYutnObq2A0FjmmoGAB+ZmoVFftocu
	Oj7b/yzsMiK063NjmB7YPAynpci/I54=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-gcRVHTihN1qvoY84TbpY_w-1; Thu,
 31 Oct 2024 21:39:40 -0400
X-MC-Unique: gcRVHTihN1qvoY84TbpY_w-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD0AA1955EE7;
	Fri,  1 Nov 2024 01:39:38 +0000 (UTC)
Received: from fedora (unknown [10.72.116.63])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D29D7300018D;
	Fri,  1 Nov 2024 01:39:32 +0000 (UTC)
Date: Fri, 1 Nov 2024 09:39:27 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>, ming.lei@redhat.com
Subject: Re: [PATCH V8 0/8] io_uring: support sqe group and leased group kbuf
Message-ID: <ZyQxT9gp65WNajyL@fedora>
References: <bc44d3c0-41e8-425c-957f-bad70aedcc50@kernel.dk>
 <e76d9742-5693-4057-b925-3917943c7441@kernel.dk>
 <f51e50c8-271e-49b6-b3e1-a63bf61d7451@kernel.dk>
 <ZyGT3h5jNsKB0mrZ@fedora>
 <674e8c3c-1f2c-464a-ad59-da3d00104383@kernel.dk>
 <ZyGjID-17REc9X3e@fedora>
 <ZyGx4JBPdU4VlxlZ@fedora>
 <d986221d-7399-4487-9c28-5d6f953510cd@kernel.dk>
 <ZyLxJdn7bboZMAcs@fedora>
 <63e2091d-d000-4b42-818b-802341ac877f@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63e2091d-d000-4b42-818b-802341ac877f@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Oct 31, 2024 at 07:35:35AM -0600, Jens Axboe wrote:
> On 10/30/24 8:53 PM, Ming Lei wrote:
> > On Wed, Oct 30, 2024 at 07:20:48AM -0600, Jens Axboe wrote:
> >> On 10/29/24 10:11 PM, Ming Lei wrote:
> >>> On Wed, Oct 30, 2024 at 11:08:16AM +0800, Ming Lei wrote:
> >>>> On Tue, Oct 29, 2024 at 08:43:39PM -0600, Jens Axboe wrote:
> >>>
> >>> ...
> >>>
> >>>>> You could avoid the OP dependency with just a flag, if you really wanted
> >>>>> to. But I'm not sure it makes a lot of sense. And it's a hell of a lot
> >>>>
> >>>> Yes, IO_LINK won't work for submitting multiple IOs concurrently, extra
> >>>> syscall makes application too complicated, and IO latency is increased.
> >>>>
> >>>>> simpler than the sqe group scheme, which I'm a bit worried about as it's
> >>>>> a bit complicated in how deep it needs to go in the code. This one
> >>>>> stands alone, so I'd strongly encourage we pursue this a bit further and
> >>>>> iron out the kinks. Maybe it won't work in the end, I don't know, but it
> >>>>> seems pretty promising and it's soooo much simpler.
> >>>>
> >>>> If buffer register and lookup are always done in ->prep(), OP dependency
> >>>> may be avoided.
> >>>
> >>> Even all buffer register and lookup are done in ->prep(), OP dependency
> >>> still can't be avoided completely, such as:
> >>>
> >>> 1) two local buffers for sending to two sockets
> >>>
> >>> 2) group 1: IORING_OP_LOCAL_KBUF1 & [send(sock1), send(sock2)]  
> >>>
> >>> 3) group 2: IORING_OP_LOCAL_KBUF2 & [send(sock1), send(sock2)]
> >>>
> >>> group 1 and group 2 needs to be linked, but inside each group, the two
> >>> sends may be submitted in parallel.
> >>
> >> That is where groups of course work, in that you can submit 2 groups and
> >> have each member inside each group run independently. But I do think we
> >> need to decouple the local buffer and group concepts entirely. For the
> >> first step, getting local buffers working with zero copy would be ideal,
> >> and then just live with the fact that group 1 needs to be submitted
> >> first and group 2 once the first ones are done.
> > 
> > IMHO, it is one _kernel_ zero copy(_performance_) feature, which often
> > imply:
> > 
> > - better performance expectation
> > - no big change on existed application for using this feature
> 
> For #2, really depends on what it is. But ideally, yes, agree.
> 
> > Application developer is less interested in sort of crippled or
> > immature feature, especially need big change on existed code
> > logic(then two code paths need to maintain), with potential
> > performance regression.
> > 
> > With sqe group and REQ_F_GROUP_KBUF, application just needs lines of
> > code change for using the feature, and it is pretty easy to evaluate
> > the feature since no any extra logic change & no extra syscall/wait
> > introduced. The whole patchset has been mature enough, unfortunately
> > blocked without obvious reasons.
> 
> Let me tell you where I'm coming from. If you might recall, I originated
> the whole grouping idea. Didn't complete it, but it's essentially the
> same concept as REQ_F_GROUP_KBUF in that you have some dependents on a
> leader, and the dependents can run in parallel rather than being
> serialized by links. I'm obviously in favor of this concept, but I want
> to see it being done in such a way that it's actually something we can
> reason about and maintain. You want it for zero copy, which makes sense,
> but I also want to ensure it's a CLEAN implementation that doesn't have
> tangles in places it doesn't need to.
> 
> You seem to be very hard to convince of making ANY changes at all. In
> your mind the whole thing is done, and it's being "blocked without
> obvious reason". It's not being blocked at all, I've been diligently
> trying to work with you recently on getting this done. I'm at least as
> interested as you in getting this work done. But I want you to work with
> me a bit on some items so we can get it into a shape where I'm happy
> with it, and I can maintain it going forward.
> 
> So, please, rather than dig your heels in all the time, have an open
> mind on how we can accomplish some of these things.
> 
> 
> >> Once local buffers are done, we can look at doing the sqe grouping in a
> >> nice way. I do think it's a potentially powerful concept, but we're
> >> going to make a lot more progress on this issue if we carefully separate
> >> dependencies and get each of them done separately.
> > 
> > One fundamental difference between local buffer and REQ_F_GROUP_KBUF is
> > 
> > - local buffer has to be provided and used in ->prep()
> > - REQ_F_GROUP_KBUF needs to be provided in ->issue() instead of ->prep()
> 
> It does not - the POC certainly did it in ->prep(), but all it really
> cares about is having the ring locked. ->prep() always has that,
> ->issue() _normally_ has that, unless it ends up in an io-wq punt.
> 
> You can certainly do it in ->issue() and still have it be per-submit,
> the latter which I care about for safety reasons. This just means it has
> to be provided in the _first_ issue, and that IOSQE_ASYNC must not be
> set on the request. I think that restriction is fine, nobody should
> really be using IOSQE_ASYNC anyway.

Yes, IOSQE_ASYNC can't work, and IO_LINK can't work too.

The restriction on IO_LINK is too strong, because it needs big
application change.

> 
> I think the original POC maybe did more harm than good in that it was
> too simplistic, and you seem too focused on the limits of that. So let

I am actually trying to thinking how to code local buffer, that is why I
puts these questions first.

> me detail what it actually could look like. We have io_submit_state in
> io_ring_ctx. This is per-submit private data, it's initialized and
> flushed for each io_uring_enter(2) that submits requests.
> 
> We have a registered file and buffer table, file_table and buf_table.
> These have life times that are dependent on the ring and
> registration/unregistration. We could have a local_table. This one
> should be setup by some register command, eg reserving X slots for that.
> At the end of submit, we'd flush this table, putting nodes in there.
> Requests can look at the table in either prep or issue, and find buffer
> nodes. If a request uses one of these, it grabs a ref and hence has it
> available until it puts it at IO completion time. When a single submit
> context is done, local_table is iterated (if any entries exist) and
> existing nodes cleared and put.
> 
> That provides a similar table to buf_table, but with a lifetime of a
> submit. Just like local buf. Yes it would not be private to a single
> group, it'd be private to a submit which has potentially bigger scope,
> but that should not matter.
> 
> That should give you exactly what you need, if you use
> IORING_RSRC_KBUFFER in the local_table. But it could even be used for
> IORING_RSRC_BUFFER as well, providing buffers for a single submit cycle
> as well.
> 
> Rather than do something completely on the side with
> io_uring_kernel_buf, we can use io_rsrc_node and io_mapped_ubuf for
> this. Which goes back to my initial rant in this email - use EXISTING
> infrastructure for these things. A big part of why this isn't making
> progress is that a lot of things are done on the side rather than being
> integrated. Then you need extra io_kiocb members, where it really should
> just be using io_rsrc_node and get everything else for free. No need to
> do special checking and putting seperately, it's a resource node just
> like any other resource node we already support.
> 
> > The only common code could be one buffer abstraction for OP to use, but
> > still used differently, ->prep() vs. ->issue().
> 
> With the prep vs issue thing not being an issue, then it sounds like we

IO_LINK is another blocker for prep vs issue thing.

> fully agree that a) it should be one buffer abstraction, and b) we

Yes, can't agree more.

> already have the infrastructure for this. We just need to add
> IORING_RSRC_KBUFFER, which I already posted some POC code for.

I am open to IORING_RSRC_KBUFFER if there isn't too strong limit for
application. Disallowing IOSQE_ASYNC is fine, but not allowing IO_LINK
does cause trouble for application, and need big change on app code.

> 
> > So it is hard to call it decouple, especially REQ_F_GROUP_KBUF has been
> > simple enough, and the main change is to import it in OP code.
> > 
> > Local buffer is one smart idea, but I hope the following things may be
> > settled first:
> > 
> > 1) is it generic enough to just allow to provide local buffer during
> > ->prep()?
> > 
> > - this way actually becomes sync & nowait IO, instead AIO, and has been
> >   one strong constraint from UAPI viewpoint.
> > 
> > - Driver may need to wait until some data comes, then return & provide
> > the buffer with data, and local buffer can't cover this case
> 
> This should be moot now with the above explanation.
> 
> > 2) is it allowed to call ->uring_cmd() from io_uring_cmd_prep()? If not,
> > any idea to call into driver for leasing the kernel buffer to io_uring?
> 
> Ditto
> 
> > 3) in OP code, how to differentiate normal userspace buffer select with
> > local buffer? And how does OP know if normal buffer select or local
> > kernel buffer should be used? Some OP may want to use normal buffer
> > select instead of local buffer, others may want to use local buffer.
> 
> Yes this is a key question we need to figure out. Right now using fixed
> buffers needs to set ->buf_index, and the OP needs to know aboout it.
> let's not confuse it with buffer select, IOSQE_BUFFER_SELECT, as that's
> for provided buffers.

Indeed, here what matters is fixed buffer.

> 
> > 4) arbitrary numbers of local buffer needs to be supported, since IO
> > often comes at batch, it shouldn't be hard to support it by adding xarray
> > to submission state, what do you think of this added complexity? Without
> > supporting arbitrary number of local buffers, performance can be just
> > bad, it doesn't make sense as zc viewpoint. Meantime as number of local
> > buffer is increased, more rsrc_node & imu allocation is introduced, this
> > still may degrade perf a bit.
> 
> That's fine, we just need to reserve space for them upfront. I don't
> like the xarray idea, as:
> 
> 1) xarray does internal locking, which we don't need here
> 2) The existing io_rsrc_data table is what is being used for
>    io_rsrc_node management now. This would introduce another method for
>    that.
> 
> I do want to ensure that io_submit_state_finish() is still low overhead,
> and using an xarray would be more expensive than just doing:
> 
> if (ctx->local_table.nr)
> 	flush_nodes();
> 
> as you'd need to always setup an iterator. But this isn't really THAT
> important. The benefit of using an xarray would be that we'd get
> flexible storing of members without needing pre-registration, obviously.

The main trouble could be buffer table pre-allocation if xarray isn't
used.

> 
> > 5) io_rsrc_node becomes part of interface between io_uring and driver
> > for releasing the leased buffer, so extra data has to be
> > added to `io_rsrc_node` for driver use.
> 
> That's fine imho. The KBUFFER addition already adds the callback, we can
> add a data thing too. The kernel you based your code on has an
> io_rsrc_node that is 48 bytes in size, and my current tree has one where
> it's 32 bytes in size after the table rework. If we have to add 2x8b to
> support this, that's NOT a big deal and we just end up with a node
> that's the same size as before.
> 
> And we get rid of this odd intermediate io_uring_kernel_buf struct,
> which is WAY bigger anyway, and requires TWO allocations where the
> existing io_mapped_ubuf embeds the bvec. I'd argue two vs one allocs is
> a much bigger deal for performance reasons.

The structure is actually preallocated in ublk, so it is zero allocation
in my patchset in case of non bio merge.

> 
> As a final note, one thing I mentioned in an earlier email is that part
> of the issue here is that there are several things that need ironing
> out, and they are actually totally separate. One is the buffer side,
> which this email mostly deals with, the other one is the grouping
> concept.
> 
> For the sqe grouping, one sticking point has been using that last
> sqe->flags bit. I was thinking about this last night, and what if we got
> away from using a flag entirely? At some point io_uring needs to deal
> with this flag limitation, but it's arguably a large effort, and I'd
> greatly prefer not having to paper over it to shove in grouped SQEs.
> 
> So... what if we simply added a new OP, IORING_OP_GROUP_START, or
> something like that. Hence instead of having a designated group leader
> bit for an OP, eg:
> 
> sqe = io_uring_get_sqe(ring);
> io_uring_prep_read(sqe, ...);
> sqe->flags |= IOSQE_GROUP_BIT;
> 
> you'd do:
> 
> sqe = io_uring_get_sqe(ring);
> io_uring_prep_group_start(sqe, ...);
> sqe->flags |= IOSQE_IO_LINK;

One problem is how to map IORING_OP_GROUP_START to uring_cmd.

IOSQE_IO_LINK isn't another trouble, because it becomes not possible
to model dependency among groups.

> 
> sqe = io_uring_get_sqe(ring);
> io_uring_prep_read(sqe, ...);
> 
> which would be the equivalent transformation - the read would be the
> group leader as it's the first member of that chain. The read should set
> IOSQE_IO_LINK for as long as it has members. The members in that group
> would NOT be serialized. They would use IOSQE_IO_LINK purely to be part
> of that group, but IOSQE_IO_LINK would not cause them to be serialized.
> Hence the link just implies membership, not ordering within the group.
> 
> This removes the flag issue, with the sligth caveat that IOSQE_IO_LINK
> has a different meaning inside the group. Maybe you'd need a GROUP_END

No, for group leader IOSQE_IO_LINK works same as any other normal SQE.


Thanks, 
Ming


