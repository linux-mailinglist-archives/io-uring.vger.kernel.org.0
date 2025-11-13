Return-Path: <io-uring+bounces-10552-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCA25C55A20
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 05:18:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5786B3B0645
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 04:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1453C2741C0;
	Thu, 13 Nov 2025 04:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ExHZIi7p"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E472725A321
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 04:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763007505; cv=none; b=Z1s8RiQEKro49NyHxHz4Usf+1CIcjncQYedZHZ6/kDyCsugpeFBf1N3LSsuNeDBqpOSDGs5/V+akyNpXMkQg+Vu+fFH2MYw2FvDdQCi/1ZyD/8CRgiK8Ug/64VYiP2dma9sbF0emvHVQmHr7xnW/jmD1zKIRgAhvRDJS1mxwOA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763007505; c=relaxed/simple;
	bh=sLROp/YkDbpN/w32RtOpHtpMpzX7u9dDrpVr3kzbi+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X1467FUOCU4V+JNUXuGSGW9GLwDvMHO7sKupA+MUqT3pkw9s0hUvZGPUMFQT6GNe4D85CSt0efwmdfDPNNbrffjMYJWfeQEqyQ3dBAD2518rNToz1a/FqVhRhJzCWUHDPfx7T8fZ8hFBRK7LOtmlO7cfnO6AAo3C28Z1m49sO58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ExHZIi7p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763007503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=drC7S4phDKiP+TILDj00BjqZygv8s7Qb+MZ6MbtuVmM=;
	b=ExHZIi7pUSTczmz0TyTfA/X5jkThhB2g+9baIehxCuLUtq6O2ja1jXN1JPbIu4iRenNMeo
	Zwrlmomhe5yAfxDhRA98qwmSlELdWV0SwlND8MV/FENCfZZDUVfJa+jdLzcLY3dp69AIJ0
	XlRPxJyoKqEY9G0CKuw8G8PvF9GryN8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-139-WvQOQ56rMTS-TpDJYdkH8A-1; Wed,
 12 Nov 2025 23:18:19 -0500
X-MC-Unique: WvQOQ56rMTS-TpDJYdkH8A-1
X-Mimecast-MFC-AGG-ID: WvQOQ56rMTS-TpDJYdkH8A_1763007498
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E2E51956096;
	Thu, 13 Nov 2025 04:18:18 +0000 (UTC)
Received: from fedora (unknown [10.72.116.134])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD36119560A2;
	Thu, 13 Nov 2025 04:18:13 +0000 (UTC)
Date: Thu, 13 Nov 2025 12:18:08 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 0/5] io_uring: add IORING_OP_BPF for extending io_uring
Message-ID: <aRVcAFOsb7X3kxB9@fedora>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
 <891f4413-9556-4f0d-87e2-6b452b08a83f@gmail.com>
 <aQtz-dw7t7jtqALc@fedora>
 <58c0e697-2f6a-4b06-bf04-c011057cd6c7@gmail.com>
 <aQ4WTLX9ieL5J7ot@fedora>
 <9b59b165-1f57-4cb6-ae62-403d922ad4da@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b59b165-1f57-4cb6-ae62-403d922ad4da@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Nov 11, 2025 at 02:07:47PM +0000, Pavel Begunkov wrote:
> On 11/7/25 15:54, Ming Lei wrote:
> > On Thu, Nov 06, 2025 at 04:03:29PM +0000, Pavel Begunkov wrote:
> > > On 11/5/25 15:57, Ming Lei wrote:
> > > > On Wed, Nov 05, 2025 at 12:47:58PM +0000, Pavel Begunkov wrote:
> > > > > On 11/4/25 16:21, Ming Lei wrote:
> > > > > > Hello,
> > > > > > 
> > > > > > Add IORING_OP_BPF for extending io_uring operations, follows typical cases:
> > > > > 
> > > > > BPF requests were tried long time ago and it wasn't great. Performance
> > > > 
> > > > Care to share the link so I can learn from the lesson? Maybe things have
> > > > changed now...
> > > 
> > > https://lore.kernel.org/io-uring/a83f147b-ea9d-e693-a2e9-c6ce16659749@gmail.com/T/#m31d0a2ac6e2213f912a200f5e8d88bd74f81406b
> > > 
> > > There were some extra features and testing from folks, but I don't
> > > think it was ever posted to the list.
> > 
> > Thanks for sharing the link:
> > 
> > ```
> > The main problem solved is feeding completion information of other
> > requests in a form of CQEs back into BPF. I decided to wire up support
> > for multiple completion queues (aka CQs) and give BPF programs access to
> > them, so leaving userspace in control over synchronisation that should
> > be much more flexible that the link-based approach.
> > ```
> 
> FWIW, and those extensions were the sign telling that the approach
> wasn't flexible enough.
> 
> > Looks it is totally different with my patch in motivation and policy.
> > 
> > I do _not_ want to move application logic into kernel by building SQE from
> > kernel prog. With IORING_OP_BPF, the whole io_uring application is
> > built & maintained completely in userspace, so I needn't to do cumbersome
> > kernel/user communication just for setting up one SQE in prog, not mention
> > maintaining SQE's relation with userspace side's.
> 
> It's built and maintained in userspace in either case, and in

No.

BPF prog is not userspace, it is definitely kernel stuff, but it belongs to
application scope.

> both cases you have bpf implementing some logic that was previously
> done in userspace. To emphasize, you can do the desired parts of
> handling in BPF, and I'm not suggesting moving the entirety of
> request processing in there.

The problem with your patch is that SQE is built in bpf prog(kernel), then
inevitable application logic is moved to bpf prog, which isn't good at
handling complicated logic.

Then people have to run kernel<->user communication for setting up the SQE.

And the SQE in bpf prog may need to be linked with previous and following SQEs in
usersapce, which basically partitions application logic into two parts: one
is in userspace, another is in bpf prog(kernel).

The patch I am suggesting doesn't have this problem, all SQEs are built in
userspace, and just the minimized part(standalone and well defined function) is
done in bpf prog.

> 
> > > > > for short BPF programs is not great because of io_uring request handling
> > > > > overhead. And flexibility was severely lacking, so even simple use cases
> > > > 
> > > > What is the overhead? In this patch, OP's prep() and issue() are defined in
> > > 
> > > The overhead of creating, freeing and executing a request. If you use
> > > it with links, it's also overhead of that. That prototype could also
> > > optionally wait for completions, and it wasn't free either.
> > 
> > IORING_OP_BPF is same with existing normal io_uring request and link, wrt
> > all above you mentioned.
> 
> It is, but it's an extra request, and in previous testing overhead
> for that extra request was affecting total performance, that's why
> linking or not is also important.

Yes, but does the extra request matters for whole performance?

I did have such test:

1) in tools/testing/selftests/ublk/null.c

- for zero copy test, one extra nop is submitted

2) rublk test

- for zero copy test, it simply returns without submitting nop

The IOPS gap is pretty small.

Also in your approach, without allocating one new SQE in bpf, how to
provide generic interface for bpf prog to work on different functions, such
as, memory copy or raid5 parity or compression ..., all require flexible
handling, such as, variable parameters, buffer could be plain user memory
, fixed, vectored or fixed vectored,..., so one SQE or new operation is the
easiest way for providing the abstraction and generic bpf prog interface.

> 
> > IORING_OP_BPF's motivation is for being io_uring's supplementary or extention
> > in function, not for improving performance.
> > 
> > > 
> > > > bpf prog, but in typical use case, the code size is pretty small, and bpf
> > > > prog code is supposed to run in fast path.>
> > > > > were looking pretty ugly, internally, and for BPF writers as well.
> > > > 
> > > > I am not sure what `simple use cases` you are talking about.
> > > 
> > > As an example, creating a loop reading a file:
> > > read N bytes; wait for completion; repeat
> > 
> > IORING_OP_BPF isn't supposed to implement FS operation in bpf prog.
> > 
> > It doesn't mean IORING_OP_BPF can't support async issuing:
> > 
> > - issue_wait() can be added for offload in io-wq context
> > 
> > OR
> > 
> > - for typical FS AIO, in theory it can be supported too, just the struct_ops need
> > to define one completion callback, and the callback can be called from
> > ->ki_complete().
> 
> There is more to IO than read/write, and I'm afraid each new type of
> operation would need some extra kfunc glue. And even then there is
> enough of handling for rw requests in io_uring than just calling the
> callback. It's nicer to be able to reuse all io_uring request
> handling, which wouldn't even need extra kfuncs.

Looks you are trying to propose generic bpf io_uring request, which is
ambitious goal, :-)

But that isn't my patchset's motivation, which just serves as supplement or
extention of existing io_uring.

Another big case could be network IO, which could be covered -EAGAIN,
or other main cases?

> 
> ...
> > > > and it can't be used in my case.
> > > Hmm, how so? Let's say ublk registers a buffer and posts a
> > > completion. Then BPF runs, it sees the completion and does the
> > > necessary processing, probably using some kfuncs like the ones
> > 
> > It is easy to say, how can the BPF prog know the next completion is
> > exactly waiting for? You have to rely on bpf map to communicate with userspace
> 
> By taking a peek at and maybe dereferencing cqe->user_data.

Yes, but you have to pass the interested ->user_data to bpf prog first.

There could be many inflight interested IOs, how to query them efficiently?

Scan each one after every CQE is posted? But ebpf just support bound loops,
the complexity may be run out of easily[1].

https://docs.ebpf.io/linux/concepts/loops/

> 
> > to understanding what completion is what you are interested in, also
> > need all information from userpace for preparing the SQE for submission
> > from bpf prog. Tons of userspace and kernel communication.
> 
> You can setup a BPF arena, and all that comm will be working with
> a block of shared memory. Or same but via io_uring parameter region.
> That sounds pretty simple.

But application logic has to splitted into two parts, both two have to
rely on the shared memory to communicate.

The exiting io_uring application has been complicated enough, adding one
extra shared memory communication for holding application logic just makes
things worse. Even in userspace programming, it is horrible to model logic
into data, that is why state machine pattern is usually not readable.

Think about writing high performance raid5 application based on ublk zero
copy & io_uring, for example, handling one simple write:

- one ublk write command comes for raid5

- suppose the command just writes data to one single stripe exactly

- submitting each write to N - 1 disks

- When all N writes are done, the new SQE needs to work:

	- calculate parity by reading buffers from the N request kernel buffer
	  and writing resulted XOR parity to one user specified buffer

- then new FS IO need to be submitted to write the parity data to one calculated
disk(N)

So the involved things for bpf prog SQE:

	- monitoring N - 1 writes
	- do the parity calculation job, which has to define one kfunc
	- mark parity is ready & notify userspace for writing parity(how to
	  notify?)

Now there can be variable(many) such WRITEs to handle concurrently, and the
bpf prog has to cover them all.

The above just the simplest case, the write command may not align with
stripe, so parity calculation may need to read data from other stripes.

If you think it is `pretty simple`, care to provide one example to show your
approach is workable?

> 
> > > you introduced. After it can optionally queue up requests
> > > writing it to the storage or anything else.
> > 
> > Again, I do not want to move userspace logic into bpf prog(kernel), what
> > IORING_BPF_OP provides is to define one operation, then userspace
> > can use it just like in-kernel operations.
> 
> Right, but that's rather limited. I want to cover all those
> use cases with one implementation instead of fragmenting users,
> if that can be achieved.

I don't know when your ambitious plan can land or be doable.

I am going to write V2 with the approach of IORING_BPF_OP which is at least
workable for some cases, and much easier to take in userspace. Also it
doesn't conflict with your approach.


Thanks,
Ming


