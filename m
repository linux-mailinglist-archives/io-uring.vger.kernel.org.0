Return-Path: <io-uring+bounces-3593-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF9E399A62E
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 16:21:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E64C31C213B7
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 14:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A38320B1F3;
	Fri, 11 Oct 2024 14:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qo52o2qL"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2749B219C92
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 14:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728656475; cv=none; b=uAXLol96KL0C1H+4dMCWIWNtE6I2RfMQKFGniOSw/DV7mat+vRlXlKmqSk2A50HcvoeeIMA2AHQ8yzeJCT7co19rSS9Xpi0GgHEQ+Rb/OXaiNU9J7PP1yAzwSNBdYG+SFySeBGpKgPEzxNi+fgCcKyHLoNaCsZBwo66hp19u89Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728656475; c=relaxed/simple;
	bh=wIHrImMDewIwP9EOixKUBPDXE7b2C9VJ2GUAE1N7ipE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KdImCq090tfJg/OGDrDTsBVYvjmaqmnTv3dTLqDdgYemXfwFKihL4ohnh7z2aVYJjdW2LR4kjH5Pp37P4SZTyVA77B5e+YSr3bYqjLpe/DBg+5UcyuKEVA+xAF6Gc7kEIHPr31NBli7waaZMpwh/zq6atxealy7JEEQMbHT4haE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qo52o2qL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728656473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Tbc8V+oG5+2OAEP5Ycosma+Obhdsp+ZQK4DqZMgWYc=;
	b=Qo52o2qLx0CHW3mzjtodOzYm/9AGMB73+3/6Ceml3aarLanr6wEZUJ6E5R1kTGTd5LnOUd
	fJDd7CUNzAD7uCsXVXbvkmwILcPXUu0P5FsXM+kBgP/fexg7my5K/lBHSJArSiFT2bLXXI
	eiNDyGChsI7WM2xM0KjbU/b/jXnMQGs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-401-B9pUNSFjMcuT3-PE3XivUQ-1; Fri,
 11 Oct 2024 10:21:07 -0400
X-MC-Unique: B9pUNSFjMcuT3-PE3XivUQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54ABB19560A2;
	Fri, 11 Oct 2024 14:21:06 +0000 (UTC)
Received: from fedora (unknown [10.72.116.16])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D28A219560A2;
	Fri, 11 Oct 2024 14:21:02 +0000 (UTC)
Date: Fri, 11 Oct 2024 22:20:57 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH V6 7/8] io_uring/uring_cmd: support provide group kernel
 buffer
Message-ID: <Zwk0SQBiTUBLNvj0@fedora>
References: <b232fa58-1255-44b2-92c9-f8eb4f70e2c9@gmail.com>
 <ZwJObC6mzetw4goe@fedora>
 <38ad4c05-6ee3-4839-8d61-f8e1b5219556@gmail.com>
 <ZwdJ7sDuHhWT61FR@fedora>
 <4b40eff1-a848-4742-9cb3-541bf8ed606e@gmail.com>
 <655b3348-27a1-4bc7-ade7-4d958a692d0b@kernel.dk>
 <ZwiN0Ioy2Y7cfnTI@fedora>
 <44028492-3681-4cd4-8ae2-ef7139ad50ad@kernel.dk>
 <ZwiWdO6SS_jlkYrM@fedora>
 <051e74c9-c5b4-40d7-9024-b4bd3f5d0a0f@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <051e74c9-c5b4-40d7-9024-b4bd3f5d0a0f@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, Oct 11, 2024 at 07:24:27AM -0600, Jens Axboe wrote:
> On 10/10/24 9:07 PM, Ming Lei wrote:
> > On Thu, Oct 10, 2024 at 08:39:12PM -0600, Jens Axboe wrote:
> >> On 10/10/24 8:30 PM, Ming Lei wrote:
> >>> Hi Jens,
> >>>
> >>> On Thu, Oct 10, 2024 at 01:31:21PM -0600, Jens Axboe wrote:
> >>>> Hi,
> >>>>
> >>>> Discussed this with Pavel, and on his suggestion, I tried prototyping a
> >>>> "buffer update" opcode. Basically it works like
> >>>> IORING_REGISTER_BUFFERS_UPDATE in that it can update an existing buffer
> >>>> registration. But it works as an sqe rather than being a sync opcode.
> >>>>
> >>>> The idea here is that you could do that upfront, or as part of a chain,
> >>>> and have it be generically available, just like any other buffer that
> >>>> was registered upfront. You do need an empty table registered first,
> >>>> which can just be sparse. And since you can pick the slot it goes into,
> >>>> you can rely on that slot afterwards (either as a link, or just the
> >>>> following sqe).
> >>>>
> >>>> Quick'n dirty obviously, but I did write a quick test case too to verify
> >>>> that:
> >>>>
> >>>> 1) It actually works (it seems to)
> >>>
> >>> It doesn't work for ublk zc since ublk needs to provide one kernel buffer
> >>> for fs rw & net send/recv to consume, and the kernel buffer is invisible
> >>> to userspace. But  __io_register_rsrc_update() only can register userspace
> >>> buffer.
> >>
> >> I'd be surprised if this simple one was enough! In terms of user vs
> >> kernel buffer, you could certainly use the same mechanism, and just
> >> ensure that buffers are tagged appropriately. I need to think about that
> >> a little bit.
> > 
> > It is actually same with IORING_OP_PROVIDE_BUFFERS, so the following
> > consumer OPs have to wait until this OP_BUF_UPDATE is completed.
> 
> See below for the registered vs provided buffer confusion that seems to
> be a confusion issue here.
> 
> > Suppose we have N consumers OPs which depends on OP_BUF_UPDATE.
> > 
> > 1) all N OPs are linked with OP_BUF_UPDATE
> > 
> > Or
> > 
> > 2) submit OP_BUF_UPDATE first, and wait its completion, then submit N
> > OPs concurrently.
> 
> Correct
> 
> > But 1) and 2) may slow the IO handing.  In 1) all N OPs are serialized,
> > and 1 extra syscall is introduced in 2).
> 
> Yes you don't want do do #1. But the OP_BUF_UPDATE is cheap enough that
> you can just do it upfront. It's not ideal in terms of usage, and I get
> where the grouping comes from. But is it possible to do the grouping in
> a less intrusive fashion with OP_BUF_UPDATE? Because it won't change any

The most of 'intrusive' change is just on patch 4, and Pavel has commented
that it is good enough:

https://lore.kernel.org/linux-block/ZwZzsPcXyazyeZnu@fedora/T/#m551e94f080b80ccbd2561e01da5ea8e17f7ee15d

> of the other ops in terms of buffer consumption, they'd just need fixed
> buffer support and you'd flag the buffer index in sqe->buf_index. And
> the nice thing about that is that while fixed/registered buffers aren't
> really used on the networking side yet (as they don't bring any benefit
> yet), adding support for them could potentially be useful down the line
> anyway.

With 2), two extra syscalls are added for each ublk IO, one is provide
buffer, another is remove buffer. The two syscalls have to be sync with
consumer OPs.

I can understand the concern, but if the change can't improve perf or
even slow things done, it loses its value.

> 
> > The same thing exists in the next OP_BUF_UPDATE which has to wait until
> > all the previous buffer consumers are done. So the same slow thing are
> > doubled. Not mention the application will become more complicated.
> 
> It does not, you can do an update on a buffer that's already inflight.

UPDATE may not match the case, actually two OPs are needed, one is
provide buffer OP and the other is remove buffer OP, both have to deal
with the other subsystem(ublk). Remove buffer needs to be done after all
consumer OPs are done immediately.

I guess you mean the buffer is reference-counted, but what if the remove
buffer OP is run before any consumer OP? The order has to be enhanced.

That is why I mention two syscalls are added.

> 
> > Here the provided buffer is only visible among the N OPs wide, and making
> > it global isn't necessary, and slow things down. And has kbuf lifetime
> > issue.
> 
> I was worried about it being too slow too, but the basic testing seems
> like it's fine. Yes with updates inflight it'll make it a tad bit
> slower, but really should not be a concern. I'd argue that even doing
> the very basic of things, which would be:
> 
> 1) Submit OP_BUF_UPDATE, get completion
> 2) Do the rest of the ops

The above adds one syscall for each ublk IO, and the following Remove
buffer adds another syscall.

Not only it slows thing down, but also makes application more
complicated, cause two wait points are added.

> 
> would be totally fine in terms of performance. OP_BUF_UPDATE will
> _always_ completely immediately and inline, which means that it'll
> _always_ be immediately available post submission. The only think you'd
> ever have to worry about in terms of failure is a badly formed request,
> which is a programming issue, or running out of memory on the host.
> 
> > Also it makes error handling more complicated, io_uring has to remove
> > the kernel buffer when the current task is exit, dependency or order with
> > buffer provider is introduced.
> 
> Why would that be? They belong to the ring, so should be torn down as
> part of the ring anyway? Why would they be task-private, but not
> ring-private?

It is kernel buffer, which belongs to provider(such as ublk) instead of uring,
application may panic any time, then io_uring has to remove the buffer for
notifying the buffer owner.

In concept grouping is simpler because:

- buffer lifetime is aligned with group leader lifetime, so we needn't
worry buffer leak because of application accidental exit

- the buffer is borrowed to consumer OPs, and returned back after all
consumers are done, this way avoids any dependency

Meantime OP_BUF_UPDATE(provide buffer OP, remove buffer OP) becomes more
complicated:

- buffer leak because of app panic
- buffer dependency issue: consumer OPs depend on provide buffer OP,
	remove buffer OP depends on consumer OPs; two syscalls has to be
	added for handling single ublk IO.

> 
> >> There are certainly many different ways that can get propagated which
> >> would not entail a complicated mechanism. I really like the aspect of
> >> having the identifier being the same thing that we already use, and
> >> hence not needing to be something new on the side.
> >>
> >>> Also multiple OPs may consume the buffer concurrently, which can't be
> >>> supported by buffer select.
> >>
> >> Why not? You can certainly have multiple ops using the same registered
> >> buffer concurrently right now.
> > 
> > Please see the above problem.
> > 
> > Also I remember that the selected buffer is removed from buffer list,
> > see io_provided_buffer_select(), but maybe I am wrong.
> 
> You're mixing up provided and registered buffers. Provided buffers are
> ones that the applications gives to the kernel, and the kernel grabs and
> consumes them. Then the application replenishes, repeat.
> 
> Registered buffers are entirely different, those are registered with the
> kernel and we can do things like pre-gup the pages so we don't have to
> do them for every IO. They are entirely persistent, any multiple ops can
> keep using them, concurrently. They don't get consumed by an IO like
> provided buffers, they remain in place until they get unregistered (or
> updated, like my patch) at some point.

I know the difference.

The thing is that here we can't register the kernel buffer in ->prep(),
and it has to be provided in ->issue() of uring command. That is similar
with provided buffer.


Thanks,
Ming


