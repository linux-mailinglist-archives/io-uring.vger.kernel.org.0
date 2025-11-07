Return-Path: <io-uring+bounces-10441-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C1C4C40B34
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 16:57:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26FCC566A8B
	for <lists+io-uring@lfdr.de>; Fri,  7 Nov 2025 15:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5297432E149;
	Fri,  7 Nov 2025 15:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GAlMeLQ+"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFE232E14F
	for <io-uring@vger.kernel.org>; Fri,  7 Nov 2025 15:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762530910; cv=none; b=LRO10kr7p5GlK53Kq2g0Vism3+QsRJa5T6rd810tASUhopq1DZ2LcwQJ1/cXMH4c+Q3HtWdRDrOCU3zdDL2McEWm8Ve8U86P7UyMoNi6BR0lrpCgmJ3OV5YBxwM/FJ3NOU/63xswdwc5Iud/En/PIHMS7oAr3aDGCL2tEYFtH2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762530910; c=relaxed/simple;
	bh=s0KX0+8Mk3Q0S/GY1L4ckWJnZe8vPO/e3WNe2sEYxKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aGOj7oz4yBCb/REz6ez/DEv+CBGQcKUlw4gp+5d8lQcszhUrz1vIp1KIrUFzg0rl4jcLgLBPhVMycd/XM0OKYR+e5QFFkoTpYOg2Rc5dQimc8PYSffrmsLMwNJsFbC5QKsVyuweHkBJjU4SIweDhfBwsmCNT93+nJ8AmuRSL8qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GAlMeLQ+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762530906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SIZQG/tAM3yt9cw96mCjWh5EbBQYLZDT/7P+Ur1PCV8=;
	b=GAlMeLQ+cm+Ju4PnKhz/CfFpBiSjs9rW5+bITUd1U72UNHveD0ZoQlCV4+dqHdy3uaVdxu
	0lEUeyh2a0p4raRHDrJtlCP6RVZM65mDrS2lEb+Dl1qJemevv+stUO9PDnWyCVBU26i1n0
	2wfn4/4yqCSByRHI8TTdvOnybN9+gqM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-662-M8OH64nGNxWpdyn1lhDFkA-1; Fri,
 07 Nov 2025 10:55:04 -0500
X-MC-Unique: M8OH64nGNxWpdyn1lhDFkA-1
X-Mimecast-MFC-AGG-ID: M8OH64nGNxWpdyn1lhDFkA_1762530903
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABBBE180035F;
	Fri,  7 Nov 2025 15:55:02 +0000 (UTC)
Received: from fedora (unknown [10.72.120.9])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E0AE1800346;
	Fri,  7 Nov 2025 15:54:57 +0000 (UTC)
Date: Fri, 7 Nov 2025 23:54:52 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 0/5] io_uring: add IORING_OP_BPF for extending io_uring
Message-ID: <aQ4WTLX9ieL5J7ot@fedora>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
 <891f4413-9556-4f0d-87e2-6b452b08a83f@gmail.com>
 <aQtz-dw7t7jtqALc@fedora>
 <58c0e697-2f6a-4b06-bf04-c011057cd6c7@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58c0e697-2f6a-4b06-bf04-c011057cd6c7@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Thu, Nov 06, 2025 at 04:03:29PM +0000, Pavel Begunkov wrote:
> On 11/5/25 15:57, Ming Lei wrote:
> > On Wed, Nov 05, 2025 at 12:47:58PM +0000, Pavel Begunkov wrote:
> > > On 11/4/25 16:21, Ming Lei wrote:
> > > > Hello,
> > > > 
> > > > Add IORING_OP_BPF for extending io_uring operations, follows typical cases:
> > > 
> > > BPF requests were tried long time ago and it wasn't great. Performance
> > 
> > Care to share the link so I can learn from the lesson? Maybe things have
> > changed now...
> 
> https://lore.kernel.org/io-uring/a83f147b-ea9d-e693-a2e9-c6ce16659749@gmail.com/T/#m31d0a2ac6e2213f912a200f5e8d88bd74f81406b
> 
> There were some extra features and testing from folks, but I don't
> think it was ever posted to the list.

Thanks for sharing the link:

```
The main problem solved is feeding completion information of other
requests in a form of CQEs back into BPF. I decided to wire up support
for multiple completion queues (aka CQs) and give BPF programs access to
them, so leaving userspace in control over synchronisation that should
be much more flexible that the link-based approach.
```

Looks it is totally different with my patch in motivation and policy.

I do _not_ want to move application logic into kernel by building SQE from
kernel prog. With IORING_OP_BPF, the whole io_uring application is
built & maintained completely in userspace, so I needn't to do cumbersome
kernel/user communication just for setting up one SQE in prog, not mention
maintaining SQE's relation with userspace side's.

> 
> > > for short BPF programs is not great because of io_uring request handling
> > > overhead. And flexibility was severely lacking, so even simple use cases
> > 
> > What is the overhead? In this patch, OP's prep() and issue() are defined in
> 
> The overhead of creating, freeing and executing a request. If you use
> it with links, it's also overhead of that. That prototype could also
> optionally wait for completions, and it wasn't free either.

IORING_OP_BPF is same with existing normal io_uring request and link, wrt
all above you mentioned.

IORING_OP_BPF's motivation is for being io_uring's supplementary or extention
in function, not for improving performance.

> 
> > bpf prog, but in typical use case, the code size is pretty small, and bpf
> > prog code is supposed to run in fast path.>
> > > were looking pretty ugly, internally, and for BPF writers as well.
> > 
> > I am not sure what `simple use cases` you are talking about.
> 
> As an example, creating a loop reading a file:
> read N bytes; wait for completion; repeat

IORING_OP_BPF isn't supposed to implement FS operation in bpf prog.

It doesn't mean IORING_OP_BPF can't support async issuing:

- issue_wait() can be added for offload in io-wq context

OR

- for typical FS AIO, in theory it can be supported too, just the struct_ops need
to define one completion callback, and the callback can be called from
->ki_complete().

> 
> > > I'm not so sure about your criteria, but my requirement was to at least
> > > being able to reuse all io_uring IO handling, i.e. submitting requests,
> > > and to wait/process completions, otherwise a lot of opportunities are
> > > wasted. My approach from a few months back [1] controlling requests from
> > 
> > Please read the patchset.
> > 
> > This patchset defines new IORING_BPF_OP code, which's ->prep(), ->issue(), ...,
> > are hooked with struct_ops prog, so all io_uring core code is used, just the
> > exact IORING_BPF_OP behavior is defined by struct_ops prog.
> 
> Right, but I'm talking about what the io_uring BPF program is capable
> of doing.

There can be many types of io_uring BPF progs from function viewpoint, we are not
talking about same type.

> 
> > > the outside was looking much better. At least it covered a bunch of needs
> > > without extra changes. I was just wiring up io_uring changes I wanted
> > > to make BPF writer lifes easier. Let me resend the bpf series with it.
> > > 
> > > It makes me wonder if they are complementary, but I'm not sure what
> > 
> > I think the two are orthogonal in function, and they can co-exist.
> > 
> > > your use cases are and what capabilities it might need.
> > 
> > The main use cases are described in cover letter and the 3rd patch, please
> > find the details there.
> > 
> > So far the main case is to access the registered (kernel)buffer
> > from issue() callback of struct_ops, because the buffer doesn't have
> > userspace mapping. The last two patches adds support to provide two
> > buffers(fixed, plain) for IORING_BPF_OP, and in future vectored buffer
> > will be added too, so IORING_BPF_OP can handle buffer flexibly, such as:
> > 
> > - use exported compress kfunc to compress data from kernel buffer
> > into another buffer or inplace, then the following linked SQE can be submitted
> > to write the built compressed data into storage
> > 
> > - in raid use case, calculate IO data parity from kernel buffer, and store
> > the parity data to another plain user buffer, then the following linked SQE
> > can be submitted to write the built parity data to storage
> > 
> > Even for userspace buffer, the BPF_OP can support similar handling for saving
> > one extra io_uring_enter() syscall.
> 
> Sure, registered buffer handling was one of the use cases for
> that recent re-itarations as well, and David Wei had some thoughts
> for it as well. Though, it was not exactly about copying.
> 
> > > [1] https://lore.kernel.org/io-uring/cover.1749214572.git.asml.silence@gmail.com/
> > 
> > I looked at your patches, in which SQE is generated in bpf prog(kernel),
> 
> Quick note: userspace and BPF are both allowed to submit
> requests / generate SQEs.
> 
> > and it can't be used in my case.
> Hmm, how so? Let's say ublk registers a buffer and posts a
> completion. Then BPF runs, it sees the completion and does the
> necessary processing, probably using some kfuncs like the ones

It is easy to say, how can the BPF prog know the next completion is
exactly waiting for? You have to rely on bpf map to communicate with userspace
to understanding what completion is what you are interested in, also
need all information from userpace for preparing the SQE for submission
from bpf prog. Tons of userspace and kernel communication.

> you introduced. After it can optionally queue up requests
> writing it to the storage or anything else.

Again, I do not want to move userspace logic into bpf prog(kernel), what
IORING_BPF_OP provides is to define one operation, then userspace
can use it just like in-kernel operations.

Then existing application can apply IORING_BPF_OP just with little small
change. If submitting SQE from bpf prog, ublk application need re-write
for supporting register buffer based zero copy.

> The reason I'm asking is because it's supposed to be able to
> do anything the userspace can already achieve (and more). So,
> if it can't be used for this use cases, there should be some
> problem in my design.

BPF prog programming is definitely much more limited compared with
userspace application because it is safe kernel programming.

Thanks,
Ming


