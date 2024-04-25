Return-Path: <io-uring+bounces-1622-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41B908B1DF8
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 11:28:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65DF31C20C4F
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 09:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E60628F7;
	Thu, 25 Apr 2024 09:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZrLLTYLS"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4432E647
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 09:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714037260; cv=none; b=R3v2AZRs0Zqh0sMKiNfQz6lGwAcwqFbJBVKiK02nW6tsBuwWVa/aY8OtkqekSJp5CdcneXS1bmVJrT8ivs/LLkLoTZ//1vU3+t0WgRr8zt95U4hoFfVH7NdG0YhstZ3YSIWEr3Buvyfrwqibi5pZ56r8KrWCDf7fV2Y4Shaad+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714037260; c=relaxed/simple;
	bh=r+3Br1/X9yK4WycqLGInG81xrjTTXLUU0K5UKY+xOu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X0EXLXJMTPO1QJnIin2QTjBXi+Et9yOnaXT+LBeKMdi1qHcJJcVEAVVQjjPJhfSquaBonEvl+asslMXlWytlEkoZGkhOnvNzj3PLMcTtIC2ikGDoHaR9yZdRB7GDqgdk7iYqfnjVEoX4aFnuAyY3W+SFP3Zti9gHrxiSFZfhK9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZrLLTYLS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714037257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fKLSBuu032igi1UQCrIS2E/dWk4IoY59TMlvkYqUq/Q=;
	b=ZrLLTYLS+yKnrgY69gXx0wwdbP2EvvxbxjDP8Noo23rCJ3HOnq2CUyDcUmTJgORg51IFIr
	PPMPFp+WLacwFEBFhQ5lLMI5elVvHwqY2rZObgLg9P41zWEKLvs+/p/kARdD7z3h6C8zkI
	ekubX+x99LYv92SJ3MwbjvFSuyPmyN4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-327-Y8KILmATOimoaXzyt4z9ng-1; Thu, 25 Apr 2024 05:27:35 -0400
X-MC-Unique: Y8KILmATOimoaXzyt4z9ng-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B95C718065AA;
	Thu, 25 Apr 2024 09:27:34 +0000 (UTC)
Received: from redhat.com (unknown [10.39.193.182])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A70F35C5CCC;
	Thu, 25 Apr 2024 09:27:33 +0000 (UTC)
Date: Thu, 25 Apr 2024 11:27:32 +0200
From: Kevin Wolf <kwolf@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 5/9] io_uring: support SQE group
Message-ID: <ZioiBLWuPMQ6ywW5@redhat.com>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-6-ming.lei@redhat.com>
 <e36cc8de-3726-4479-8fbd-f54fd21465a2@kernel.dk>
 <Ziey53aADgxDrXZw@redhat.com>
 <Zihi3nDAJg1s7Cws@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zihi3nDAJg1s7Cws@fedora>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Am 24.04.2024 um 03:39 hat Ming Lei geschrieben:
> On Tue, Apr 23, 2024 at 03:08:55PM +0200, Kevin Wolf wrote:
> > Am 22.04.2024 um 20:27 hat Jens Axboe geschrieben:
> > > On 4/7/24 7:03 PM, Ming Lei wrote:
> > > > SQE group is defined as one chain of SQEs starting with the first sqe that
> > > > has IOSQE_EXT_SQE_GROUP set, and ending with the first subsequent sqe that
> > > > doesn't have it set, and it is similar with chain of linked sqes.
> > > > 
> > > > The 1st SQE is group leader, and the other SQEs are group member. The group
> > > > leader is always freed after all members are completed. Group members
> > > > aren't submitted until the group leader is completed, and there isn't any
> > > > dependency among group members, and IOSQE_IO_LINK can't be set for group
> > > > members, same with IOSQE_IO_DRAIN.
> > > > 
> > > > Typically the group leader provides or makes resource, and the other members
> > > > consume the resource, such as scenario of multiple backup, the 1st SQE is to
> > > > read data from source file into fixed buffer, the other SQEs write data from
> > > > the same buffer into other destination files. SQE group provides very
> > > > efficient way to complete this task: 1) fs write SQEs and fs read SQE can be
> > > > submitted in single syscall, no need to submit fs read SQE first, and wait
> > > > until read SQE is completed, 2) no need to link all write SQEs together, then
> > > > write SQEs can be submitted to files concurrently. Meantime application is
> > > > simplified a lot in this way.
> > > > 
> > > > Another use case is to for supporting generic device zero copy:
> > > > 
> > > > - the lead SQE is for providing device buffer, which is owned by device or
> > > >   kernel, can't be cross userspace, otherwise easy to cause leak for devil
> > > >   application or panic
> > > > 
> > > > - member SQEs reads or writes concurrently against the buffer provided by lead
> > > >   SQE
> > > 
> > > In concept, this looks very similar to "sqe bundles" that I played with
> > > in the past:
> > > 
> > > https://git.kernel.dk/cgit/linux/log/?h=io_uring-bundle
> > > 
> > > Didn't look too closely yet at the implementation, but in spirit it's
> > > about the same in that the first entry is processed first, and there's
> > > no ordering implied between the test of the members of the bundle /
> > > group.
> > 
> > When I first read this patch, I wondered if it wouldn't make sense to
> > allow linking a group with subsequent requests, e.g. first having a few
> > requests that run in parallel and once all of them have completed
> > continue with the next linked one sequentially.
> > 
> > For SQE bundles, you reused the LINK flag, which doesn't easily allow
> > this. Ming's patch uses a new flag for groups, so the interface would be
> > more obvious, you simply set the LINK flag on the last member of the
> > group (or on the leader, doesn't really matter). Of course, this doesn't
> > mean it has to be implemented now, but there is a clear way forward if
> > it's wanted.
> 
> Reusing LINK for bundle breaks existed link chains (BUNDLE linked to
> existed link chain), so I think it may not work.

You can always extend things *somehow*, but it wouldn't fit very
naturally. That's why I feel your approach on this detail is a little
better.

> The link rule is explicit for sqe group:
> 
> - only group leader can set link flag, which is applied on the whole
> group: the next sqe in the link chain won't be started until the
> previous linked sqe group is completed
> 
> - link flag can't be set for group members
> 
> Also sqe group doesn't limit async for both group leader and member.
> 
> sqe group vs link & async is covered in the last liburing test code.

Oh right, I didn't actually notice that you already implement what I
proposed!

I was expecting the flag on the last SQE and I saw in the code that this
isn't allowed, but I completely missed your comment that explicitly
states that it's the group leader that gets the link flag. Of course,
this is just as good.

> > The part that looks a bit arbitrary in Ming's patch is that the group
> > leader is always completed before the rest starts. It makes perfect
> > sense in the context that this series is really after (enabling zero
> > copy for ublk), but it doesn't really allow the case you mention in the
> > SQE bundle commit message, running everything in parallel and getting a
> > single CQE for the whole group.
> 
> I think it should be easy to cover bundle in this way, such as add one
> new op IORING_OP_BUNDLE as Jens did, and implement the single CQE for
> whole group/bundle.

This requires an extra SQE compared to just creating the group with
flags, but I suppose this is not a big problem. An alternative might be
sending the CQE for the group leader only after the whole group has
completed if we're okay with userspace never knowing when the leader
itself completed.

However, assuming an IORING_OP_BUNDLE command, if this command only
completes after the whole group, doesn't that conflict with the
principle that all other commands are only started after the first one
has completed?

Maybe we shouldn't wait for the whole group leader request to complete,
but just give the group leader a chance to prepare the group before all
requests in the group (including the leader itself) are run in parallel.
Maybe io_issue_sqe() could just start the rest of the group somewhere
after calling def->issue() for the leader. Then you can't prepare the
group buffer asynchronously, but I don't think this is needed, right?

Your example with one read followed by multiple writes would then have
to be written slightly differently: First the read outside of the group,
linked to a group of writes. I honestly think this makes more sense as
an interface, too, because then links are for sequential things and
groups are (only) for parallel things. This feels clearer than having
both a sequential and a parallel element in groups.

> > I suppose you could hack around the sequential nature of the first
> > request by using an extra NOP as the group leader - which isn't any
> > worse than having an IORING_OP_BUNDLE really, just looks a bit odd - but
> > the group completion would still be missing. (Of course, removing the
> > sequential first operation would mean that ublk wouldn't have the buffer
> > ready any more when the other requests try to use it, so that would
> > defeat the purpose of the series...)
> > 
> > I wonder if we can still combine both approaches and create some
> > generally useful infrastructure and not something where it's visible
> > that it was designed mostly for ublk's special case and other use cases
> > just happened to be enabled as a side effect.
> 
> sqe group is actually one generic interface, please see the multiple
> copy( copy one file to multiple destinations in single syscall for one
> range) example in the last patch

Yes, that's an example that happens to work well with the model that you
derived from ublk.

If you have the opposite case, reading a buffer that is spread across
multiple files and then writing it to one target (i.e. first step
parallel, second step sequential), you can't represent this well
currently. You could work around it by having a NOP leader, but that's
not very elegant.

This asymmetry suggests that it's not the perfect interface yet.

If the whole group runs in parallel instead, including the leader, then
both examples become symmetrical. You have a group for the parallel I/O
and a linked single request for the other operation.

Or if both steps are parallel, you can just have two linked groups.

> and it can support generic device zero copy: any device internal
> buffer can be linked with io_uring operations in this way, which can't
> be done by traditional splice/pipe.

Is this actually implemented or is it just a potential direction for the
future?

> I guess it can be used in network Rx zero copy too, but may depend on
> actual network Rx use case.

Kevin


