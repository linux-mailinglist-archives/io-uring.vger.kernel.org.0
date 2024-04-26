Return-Path: <io-uring+bounces-1652-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16D6D8B3D92
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 19:05:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99DED1F210EC
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 17:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 989802F874;
	Fri, 26 Apr 2024 17:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y7fl3clQ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FE9156F4B
	for <io-uring@vger.kernel.org>; Fri, 26 Apr 2024 17:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714151127; cv=none; b=l80NI6YcQ/Cq9oBbdggmJ2aFUQO7XZWYcc6JcYR6uRE2W6q1JaDpvOa6zdkTZ0bHxNdRYkGkdPlOLuR24wMiPOFZIolInIWzFxYry5qjMb7PPAdCCJIoD4+bSmm9usYewi6/uiL2iN9VAtIK04Ue61vEmt4hHUs6iyzaeZ18Dvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714151127; c=relaxed/simple;
	bh=TB3CW47H8g6N8G0xjqcrKJMZnfxJ6zm4ikC6peDOkls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nEjN4uKmbRjNclftNCyR54OFT8eO+nwXBF8WNzmNDJ5JZNcfeuQ6OmsnbzqDyhF8/H49eWAhbFfqmvNSLcDjEu1IMVIVce9ofQC1+2RPmYQSPIILsZfr9Pu1IX1+LDRdHPngrJaiuxJ9XbxrlrLevfZVgXDNrOn3zlaKyNdnNoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y7fl3clQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714151123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q/fj7MjBPdsp+vwuT8yg7QiEYh89efWuvqU0xqkN09o=;
	b=Y7fl3clQCK6EAiJp90FPF2fYVykoq2cGL5CVWo78zNowzoiZSuzx0+MswH9iMa9dQkDTn6
	y89A58OYtSQtbAoep/qVh3OEukGweOufgOBjJNb+sJSqhvcAD+Hrb80KBDlYKj0XW1TFUX
	QOXVLR+R6tSnmPfc5M9zDSObAQeG9VA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-112-GmmUmBbHNC-f7901t1lI3Q-1; Fri,
 26 Apr 2024 13:05:19 -0400
X-MC-Unique: GmmUmBbHNC-f7901t1lI3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63454385A18D;
	Fri, 26 Apr 2024 17:05:19 +0000 (UTC)
Received: from redhat.com (unknown [10.39.193.233])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 80018C13FA3;
	Fri, 26 Apr 2024 17:05:18 +0000 (UTC)
Date: Fri, 26 Apr 2024 19:05:17 +0200
From: Kevin Wolf <kwolf@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 5/9] io_uring: support SQE group
Message-ID: <ZivezbdBK0ys-5gY@redhat.com>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-6-ming.lei@redhat.com>
 <e36cc8de-3726-4479-8fbd-f54fd21465a2@kernel.dk>
 <Ziey53aADgxDrXZw@redhat.com>
 <Zihi3nDAJg1s7Cws@fedora>
 <ZioiBLWuPMQ6ywW5@redhat.com>
 <ZitdhYFsLmZ9YKFU@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZitdhYFsLmZ9YKFU@fedora>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Am 26.04.2024 um 09:53 hat Ming Lei geschrieben:
> On Thu, Apr 25, 2024 at 11:27:32AM +0200, Kevin Wolf wrote:
> > Am 24.04.2024 um 03:39 hat Ming Lei geschrieben:
> > > On Tue, Apr 23, 2024 at 03:08:55PM +0200, Kevin Wolf wrote:
> > > > When I first read this patch, I wondered if it wouldn't make sense to
> > > > allow linking a group with subsequent requests, e.g. first having a few
> > > > requests that run in parallel and once all of them have completed
> > > > continue with the next linked one sequentially.
> > > > 
> > > > For SQE bundles, you reused the LINK flag, which doesn't easily allow
> > > > this. Ming's patch uses a new flag for groups, so the interface would be
> > > > more obvious, you simply set the LINK flag on the last member of the
> > > > group (or on the leader, doesn't really matter). Of course, this doesn't
> > > > mean it has to be implemented now, but there is a clear way forward if
> > > > it's wanted.
> > > 
> > > Reusing LINK for bundle breaks existed link chains (BUNDLE linked to
> > > existed link chain), so I think it may not work.
> > 
> > You can always extend things *somehow*, but it wouldn't fit very
> > naturally. That's why I feel your approach on this detail is a little
> > better.
> 
> Linking group in traditionally way is real use case, please see
> ublk-nbd's zero copy implementation.
> 
> https://github.com/ublk-org/ublksrv/blob/group-provide-buf/nbd/tgt_nbd.cpp

I'm not sure what you're trying to argue, I agreed with you twice?

I don't think Jens's bundles break existing users of links because the
special meaning is only triggered with IORING_OP_BUNDLE. But obviously
they don't allow linking a bundle with something else after it, which
feels more limiting than necessary.

> > > The link rule is explicit for sqe group:
> > > 
> > > - only group leader can set link flag, which is applied on the whole
> > > group: the next sqe in the link chain won't be started until the
> > > previous linked sqe group is completed
> > > 
> > > - link flag can't be set for group members
> > > 
> > > Also sqe group doesn't limit async for both group leader and member.
> > > 
> > > sqe group vs link & async is covered in the last liburing test code.
> > 
> > Oh right, I didn't actually notice that you already implement what I
> > proposed!
> > 
> > I was expecting the flag on the last SQE and I saw in the code that this
> > isn't allowed, but I completely missed your comment that explicitly
> > states that it's the group leader that gets the link flag. Of course,
> > this is just as good.
> > 
> > > > The part that looks a bit arbitrary in Ming's patch is that the group
> > > > leader is always completed before the rest starts. It makes perfect
> > > > sense in the context that this series is really after (enabling zero
> > > > copy for ublk), but it doesn't really allow the case you mention in the
> > > > SQE bundle commit message, running everything in parallel and getting a
> > > > single CQE for the whole group.
> > > 
> > > I think it should be easy to cover bundle in this way, such as add one
> > > new op IORING_OP_BUNDLE as Jens did, and implement the single CQE for
> > > whole group/bundle.
> > 
> > This requires an extra SQE compared to just creating the group with
> > flags, but I suppose this is not a big problem. An alternative might be
> > sending the CQE for the group leader only after the whole group has
> > completed if we're okay with userspace never knowing when the leader
> > itself completed.
> > 
> > However, assuming an IORING_OP_BUNDLE command, if this command only
> > completes after the whole group, doesn't that conflict with the
> 
> Here the completion means committing CQE to userspace ring.
> 
> > principle that all other commands are only started after the first one
> > has completed?
> 
> I meant IORING_OP_BUNDLE is the group leader, and the first one is the
> the leader.
> 
> The member requests won't be started until the leader is completed, and
> here the completion means that the request is completed from subsystem
> (FS, netowork, ...), so there isn't conflict, but yes, we need to
> describe the whole ideas/terms more carefully.

Is there precedence for requests that are completed, but don't result in
a CQE immediately? But yes, it's the same as I had in mind above when I
was talking about completing the leader only after the whole group has
completed.

> > Maybe we shouldn't wait for the whole group leader request to complete,
> > but just give the group leader a chance to prepare the group before all
> > requests in the group (including the leader itself) are run in parallel.
> > Maybe io_issue_sqe() could just start the rest of the group somewhere
> > after calling def->issue() for the leader. Then you can't prepare the
> > group buffer asynchronously, but I don't think this is needed, right?
> 
> That isn't true, if leader request is one network RX, we need to wait
> until the recv is done, then the following member requests can be
> started for consuming the received data.
> 
> Same example with the multiple copy one in last patch.

I don't see a group kernel buffer in the last patch at all? It seems to
use userspace buffers. In which case the read doesn't have to be part of
the group at all: You can have a read and link that with a group of
writes. Then you have the clear semantics of link = sequential,
group = parallel again.

But let's assume that the read actually did provide a group buffer.

What this example showed me is that grouping requests for parallel
submission is logically independent from grouping requests for sharing a
buffer. For full flexibility, they would probably have to be separate
concepts. You could then have the same setup as before (read linked to a
group of writes), but still share a group kernel buffer for the whole
sequence.

However, it's not clear if that the full flexibility is needed, and it
would probably complicate the implementation a bit.

> > Your example with one read followed by multiple writes would then have
> > to be written slightly differently: First the read outside of the group,
> > linked to a group of writes. I honestly think this makes more sense as
> > an interface, too, because then links are for sequential things and
> > groups are (only) for parallel things. This feels clearer than having
> > both a sequential and a parallel element in groups.
> 
> Group also implements 1:N dependency, in which N members depends on
> single group leader, meantime there isn't any dependency among each
> members. That is something the current io_uring is missing.

Dependencies are currently expressed with links, which is why I felt
that it would be good to use them in this case, too. Groups that only
include parallel requests and can be part of a link chain even provide
N:M dependencies, so are even more powerful than the fixed 1:N of your
groups.

The only thing that doesn't work as nicely then is sharing the buffer as
long as it's not treated as a separate concept.

> > > > I suppose you could hack around the sequential nature of the first
> > > > request by using an extra NOP as the group leader - which isn't any
> > > > worse than having an IORING_OP_BUNDLE really, just looks a bit odd - but
> > > > the group completion would still be missing. (Of course, removing the
> > > > sequential first operation would mean that ublk wouldn't have the buffer
> > > > ready any more when the other requests try to use it, so that would
> > > > defeat the purpose of the series...)
> > > > 
> > > > I wonder if we can still combine both approaches and create some
> > > > generally useful infrastructure and not something where it's visible
> > > > that it was designed mostly for ublk's special case and other use cases
> > > > just happened to be enabled as a side effect.
> > > 
> > > sqe group is actually one generic interface, please see the multiple
> > > copy( copy one file to multiple destinations in single syscall for one
> > > range) example in the last patch
> > 
> > Yes, that's an example that happens to work well with the model that you
> > derived from ublk.
> 
> Not only for ublk and device zero copy, it also have the multiple copy example.

This is what I replied to. Yes, it's an example where the model works
fine. This is not evidence that the model is as generic as it could be,
just that it's an example that fits it.

> > If you have the opposite case, reading a buffer that is spread across
> > multiple files and then writing it to one target (i.e. first step
> > parallel, second step sequential), you can't represent this well
> > currently. You could work around it by having a NOP leader, but that's
> > not very elegant.
> 
> Yeah, linking the group(nop & reads) with the following write does
> work for the above copy case, :-)
> 
> > 
> > This asymmetry suggests that it's not the perfect interface yet.
> 
> 1:N dependency requires the asymmetry, an nothing in this world is perfect, :-)
> But we can try to make it better.

The asymmetry doesn't contribute anything to the 1:N dependency. As
discussed above, normal links combined with fully parallel (and
therefore symmetrical) groups provide this functionality, too.

The only real reason I see for justifying it is the group kernel buffer.

> > If the whole group runs in parallel instead, including the leader, then
> > both examples become symmetrical. You have a group for the parallel I/O
> > and a linked single request for the other operation.
> > 
> > Or if both steps are parallel, you can just have two linked groups.
> 
> I think sqe group can be extended to this way easily by one new flag if
> there is such real use case. We still can use leader's link flag for
> same purpose, an only advance the linking chain until the whole group
> is done. 
> 
> Then sqe group just degrades to single link group without 1:N dependency
> covered and leader is just for providing group link flag, looks it can be
> well defined and documented, and could be useful too, IMO.

If you're willing to introduce a second flag, then I'd consider using
that flag to define buffer sharing groups independently of groups for
parallel execution.

I think it's usually preferable to build the semantics you need by
combining flags that provide independent building blocks with a
straightforward meaning than having a single complex building block and
then flags that modify the way the complex concept works.

> > > and it can support generic device zero copy: any device internal
> > > buffer can be linked with io_uring operations in this way, which can't
> > > be done by traditional splice/pipe.
> > 
> > Is this actually implemented or is it just a potential direction for the
> > future?
> 
> It is potential direction since sqe group & provide buffer provides one
> generic framework to export device internal buffer for further consuming
> in zero copy & non-mmap way.

I see. This contributes a bit to the impression that much of the design
is driven by ublk alone, because it's the only thing that seems to make
use of group buffers so far.

Anyway, I'm just throwing in a few thoughts and ideas from outside. In
the end, Jens and you need to agree on something.

Kevin


