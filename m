Return-Path: <io-uring+bounces-2165-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9446790427C
	for <lists+io-uring@lfdr.de>; Tue, 11 Jun 2024 19:37:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BFAF282F4F
	for <lists+io-uring@lfdr.de>; Tue, 11 Jun 2024 17:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A325441C92;
	Tue, 11 Jun 2024 17:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="RvZ8Wm1P";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SMmlze/w"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh2-smtp.messagingengine.com (fhigh2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0653D38E;
	Tue, 11 Jun 2024 17:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718127458; cv=none; b=CIAn3+aNAzwd2Z4o2pYuC9hd2NQnZyPG9tKQ+szStuUVvZMJGBXQlpKQzI7uD7ff5BFqpuaJXKlfUXKq4Yp0mNb0Uv8PaP3kiIOthdPenjUvazDCLNI0GNvQivd44AebrRvIHv7xrn2/LOkabGpxP2HBBWvGDgGZ+k5pSf+Hyk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718127458; c=relaxed/simple;
	bh=4XmcK12DXwJXIapSnFbyP/QF9jeejr3p66KszCzDeoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G+40t2o0/+HBpXkshSSKvGV7rtvLHMpvr4VlcdP0wLOiFM0eSPWEUdeamGILrPwbWlFsqVCh9322c5K1VFDedLxk5aRhLnqOjPsEV1k7/ltyTCfKmwCuEXXJO4EXvFzL3c7alcFYqZLQOi8dnD6HcUx/kS4DNDT9n0fceXwZj34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=RvZ8Wm1P; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=SMmlze/w; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 003F41140161;
	Tue, 11 Jun 2024 13:37:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 11 Jun 2024 13:37:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1718127454;
	 x=1718213854; bh=pOuPcveqpWiuYir7J0yohCnuL60OUaTHLzF8ljIq0hY=; b=
	RvZ8Wm1PdEN5ZHxNVJXvuhfNrDeRNX/etDyMNVKbhYMY7AEIbbh4DLwfSATPg6OT
	tl0x+yMBBIawyiIVemIzE8WeRCIXcK0WV/qwrO25ND6CakaJ0zv3nIaPb6DGovyF
	w4q7P2SzH9YhtdKwz2HoiFNsgdV43UHj2i0UYCZGy6p9cRsLBxTyiv8K1lKYoLmh
	wUma8FjUa1Xf75B3rYNSrTGRtd4dz1lkLL1LKbo6MeanNHXaGgC4Z186gFaAoOn1
	zMDIWDUQHTAwff8JL0QZ0LRUthb/OvJhDcUCi21mL3f/py44TaViBjwVeyGjc5Zf
	DRoVjDyaJCsKtWiAOdkRPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1718127454; x=
	1718213854; bh=pOuPcveqpWiuYir7J0yohCnuL60OUaTHLzF8ljIq0hY=; b=S
	Mmlze/wQEYXjj8ioA8X6ea0fmOBv7otWKnUGRpyKU3Hl8f7WTobZG1E56Nk4QxNC
	5eIDENCkAlQIQtz4+EqjLSW5MskoKeiWH+DLBOwaLwhspajpWs8a36m6UU4sUUaH
	dvt7TqAivZmx6KU3HBeM6zIGm5k2URjSZAjCli3TfEPFJX6YazafKe/muydQqcrW
	pyEfnnIR7UXfNwHjJW6GgCkS8n1ladJGpYLWbbFOq9dw+0RAlL2j4niBhQwesnIJ
	PBYyFBEGpK51aZc6cjFXU/YYvI3doDkqRLf3tV2bq/FkMdUe3hkXHH5gWurNAasw
	LKzqONGS5MNvHwKS02YCg==
X-ME-Sender: <xms:XotoZlAN95t7tvTO7Ol8t9bsCZKkPQ2-79-tnr-PGKMw8ejCTnyblg>
    <xme:XotoZjin3EvBNGkd-zIwZSKphVXV7-jdCEqn9S4FnHrBRzpYgOAdCZy7Lth0Qrt2A
    dT7Y9zYghOHu_p1>
X-ME-Received: <xmr:XotoZgnbLzqmiRTaYHL2l1f5fvSpbJCAYniq3h7HpZFGXY7FTD1JlJR2VmP_fpAr_QHsysJGgREzWT_HEWlP097lSIq2NA5cYv-mG2TpZGvMhOx7Hp7h>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrfeduvddguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepuegv
    rhhnugcuufgthhhusggvrhhtuceosggvrhhnugdrshgthhhusggvrhhtsehfrghsthhmrg
    hilhdrfhhmqeenucggtffrrghtthgvrhhnpeevvdffhfeltedttdelffehudeiueevgefh
    vdfgfeduieehudffheduteelhffgueenucffohhmrghinhepghhithhhuhgsrdgtohhmpd
    hkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsvghrnhgurdhstghhuhgsvghrthesfhgrshhtmhgrihhlrdhfmh
X-ME-Proxy: <xmx:XotoZvzEWcRcEPoFPF3s5JaEMJH90BAIR1ksGA582DKYpzirJ-rS7A>
    <xmx:XotoZqQLx50tDwmNy-NQZmZOQZLVwDuognyeu__D27jlnm3bQL0r2Q>
    <xmx:XotoZibpS3bBbBJM1X1D6hG7dR36TCabRBDAXM76TfH2dejlLIho2w>
    <xmx:XotoZrT6b-chb7KTG_aPmywmOMVfK3B7HPe9f_cPWhqNYKvyZhrf4g>
    <xmx:XotoZmaR5sQEPNyU_GN1SZwNRgOCfQun-SL4LuVYo4kRlQ8DDoYIM9jE>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Jun 2024 13:37:32 -0400 (EDT)
Message-ID: <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
Date: Tue, 11 Jun 2024 19:37:30 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Bernd Schubert <bschubert@ddn.com>, Amir Goldstein <amir73il@gmail.com>,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>,
 io-uring@vger.kernel.org, Kent Overstreet <kent.overstreet@linux.dev>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm>
 <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/11/24 17:35, Miklos Szeredi wrote:
> On Tue, 11 Jun 2024 at 12:26, Bernd Schubert <bernd.schubert@fastmail.fm> wrote:
> 
>> Secondly, with IORING_OP_URING_CMD we already have only a single command
>> to submit requests and fetch the next one - half of the system calls.
>>
>> Wouldn't IORING_OP_READV/IORING_OP_WRITEV be just this approach?
>> https://github.com/uroni/fuseuring?
>> I.e. it hook into the existing fuse and just changes from read()/write()
>> of /dev/fuse to io-uring of /dev/fuse. With the disadvantage of zero
>> control which ring/queue and which ring-entry handles the request.
> 
> Unlike system calls, io_uring ops should have very little overhead.
> That's one of the main selling points of io_uring (as described in the
> io_uring(7) man page).
> 
> So I don't think it matters to performance whether there's a combined
> WRITEV + READV (or COMMIT + FETCH) op or separate ops.

This has to be performance proven and is no means what I'm seeing. How
should io-uring improve performance if you have the same number of
system calls?

As I see it (@Jens or @Pavel or anyone else please correct me if I'm
wrong), advantage of io-uring comes when there is no syscall overhead at
all - either you have a ring with multiple entries and then one side
operates on multiple entries or you have polling and no syscall overhead
either. We cannot afford cpu intensive polling - out of question,
besides that I had even tried SQPOLL and it made things worse (that is
actually where my idea about application polling comes from).
As I see it, for sync blocking calls (like meta operations) with one
entry in the queue, you would get no advantage with
IORING_OP_READV/IORING_OP_WRITEV -  io-uring has  do two system calls -
one to submit from kernel to userspace and another from userspace to
kernel. Why should io-uring be faster there?

And from my testing this is exactly what I had seen - io-uring for meta
requests (i.e. without a large request queue and *without* core
affinity) makes meta operations even slower that /dev/fuse.

For anything that imposes a large ring queue and where either side
(kernel or userspace) needs to process multiple ring entries - system
call overhead gets reduced by the queue size. Just for DIO or meta
operations that is hard to reach.

Also, if you are using IORING_OP_READV/IORING_OP_WRITEV, nothing would
change in fuse kernel? I.e. IOs would go via fuse_dev_read()?
I.e. we would not have encoded in the request which queue it belongs to?

> 
> The advantage of separate ops is more flexibility and less complexity
> (do only one thing in an op)

Did you look at patch 12/19? It just does
fuse_uring_req_end_and_get_next(). That part isn't complex, imho.

> 
>> Thirdly, initially I had even removed the allocation of 'struct
>> fuse_req' and directly allocated these on available ring entries. I.e.
>> the application thread was writing to the mmap ring buffer. I just
>> removed that code for now, as it introduced additional complexity with
>> an unknown performance outcome. If it should be helpful we could add
>> that later. I don't think we have that flexibility with
>> IORING_OP_READV/IORING_OP_WRITEV.
> 
> I think I understand what you'd like to see in the end: basically a
> reverse io_uring, where requests are placed on a "submission queue" by
> the kernel and completed requests are placed on a completion queue by
> the userspace.  Exactly the opposite of current io_uring.
> 
> The major difference between your idea of a fuse_uring and the
> io_uring seems to be that you place not only the request on the shared
> buffer, but the data as well.   I don't think this is a good idea,
> since it will often incur one more memory copy.  Otherwise the idea
> itself seems sound.

Coud you explain what you mean with "one more memory copy"? As it is
right now, 'struct fuse_req' is always allocated as it was before and
then a copy is done to the ring entry. No difference to legacy /dev/fuse
IO, which also copies to the read buffer.

If we would avoid allocating 'struct fuse_req' when there are free ring
entry requests we would reduce copies, but never increase?

Btw, advantage for the ring is on the libfuse side, where the
fuse-request buffer is assigned to the CQE and as long as the request is
not completed, the buffer is valid. (For /dev/fuse IO that could be
solved in libfuse by decoupling request memory from the thread, but with
the current ring buffer design that just happens more naturally and
memory is limited by the queue size.)

> 
> The implementation twisted due to having to integrate it with
> io_uring.  Unfortunately placing fuse requests directly into the
> io_uring queue doesn't work, due to the reversal of roles and the size
> difference between sqe and cqe entries.  Also the shared buffer seems
> to lose its ring aspect due to the fact that fuse doesn't get notified
> when a request is taken off the queue (io_uring_cqe_seen(3)).
> 
> So I think either better integration with io_uring is needed with
> support for "reverse submission" or a new interface.

Well, that is exactly what IORING_OP_URING_CMD is for, afaik. And
ublk_drv  also works exactly that way. I had pointed it out before,
initially I had considered to write a reverse io-uring myself and then
exactly at that time ublk came up.

The interface of that 'reverse io' to io-uring is really simple.

1) Userspace sends a IORING_OP_URING_CMD SQE
2) That CMD gets handled/queued by struct file_operations::uring_cmd /
fuse_uring_cmd(). fuse_uring_cmd() returns -EIOCBQUEUED and queues the
request
3) When fuse client has data to complete the request, it calls
io_uring_cmd_done() and fuse server receives a CQE with the fuse request.

Personally I don't see anything twisted here, one just needs to
understand that IORING_OP_URING_CMD was written for that reverse order.

(There came up a light twisting when io-uring introduced issue_flags -
that is part of discussion of patch 19/19 with Jens in the series. Jens
suggested to work on io-uring improvements once the main series is
merged. I.e. patch 19/19 will be dropped in RFCv3 and I'm going to ask
Jens for help once the other parts are merged. Right now that easy to
work around by always submitting with an io-uring task).

Also, that simplicity is the reason why I'm hesitating a bit to work on
Kents new ring, as io-uring already has all what we need and with a
rather simple interface.

Well, maybe you mean patch 09/19 "Add a dev_release exception for
fuse-over-io-uring". Yep, that is the shutdown part I'm not too happy
about and which initially lead to the async release thread in RFCv1.


> 
>>>
>>> Maybe there's an advantage in using an atomic op for WRITEV + READV,
>>> but I'm not quite seeing it yet, since there's no syscall overhead for
>>> separate ops.
>>
>> Here I get confused, could please explain?
>> Current fuse has a read + write operation - a read() system call to
>> process a fuse request and a write() call to submit the result and then
>> read() to fetch the next request.
>> If userspace has to send IORING_OP_READV to fetch a request and complete
>> with IORING_OP_IORING_OP_WRITEV it would go through existing code path
>> with operations? Well, maybe userspace could submit with IOSQE_IO_LINK,
>> but that sounds like it would need to send two ring entries? I.e. memory
>> and processing overhead?
> 
> Overhead should be minimal.

See above, for single entry blocking requests you get two system calls +
io-uring overhead.

> 
>> And then, no way to further optimize and do fuse_req allocation on the
>> ring (if there are free entries). And probably also no way that we ever
>> let the application work in the SQPOLL way, because the application
>> thread does not have the right to read from the fuse-server buffer? I.e.
>> what I mean is that IORING_OP_URING_CMD gives a better flexibility.
> 
> There should be no difference between IORING_OP_URING_CMD and
> IORING_OP_WRITEV +  IORING_OP_READV in this respect.  At least I don't
> see why polling would work differently: the writev should complete
> immediately and then the readv is queued.  Same as what effectively
> happens with IORING_OP_URING_CMD, no?


Polling yes, but without shared memory the application thread does not
have the right to read from fuse userspace server request?

> 
>> Btw, another issue that is avoided with the new ring-request layout is
>> compatibility and alignment. The fuse header is always in a 4K section
>> of the request data follow then. I.e. extending request sizes does not
>> impose compatibility issues any more and also for passthrough and
>> similar - O_DIRECT can be passed through to the backend file system.
>> Although these issues probably need to be solved into the current fuse
>> protocol.
> 
> Yes.
> 
>> Last but not least, with separation there is no global async queue
>> anymore - no global lock and cache issues.
> 
> The global async code should be moved into the /dev/fuse specific
> "legacy" queuing so it doesn't affect either uring or virtiofs
> queuing.

Yep, wait a few days I have seen your recent patch and I'm may to add
that to my series. I actually considered to point of that the bg queue
could be handled by that series as well, but then preferred to just add
patch for that in my series, which will make use of it for the ring queue.

> 
>>>> https://lore.kernel.org/linux-fsdevel/CAJfpegtL3NXPNgK1kuJR8kLu3WkVC_ErBPRfToLEiA_0=w3=hA@mail.gmail.com/
>>>>
>>>> This cache line bouncing should be addressed by these patches
>>>> as well.
>>>
>>> Why do you think this is solved?
>>
>>
>> I _guess_ that writing to the mmaped buffer and processing requests on
>> the same cpu core should make it possible to keep things in cpu cache. I
>> did not verify that with perf, though.
> 
> Well, the issue is with any context switch that happens in the
> multithreaded fuse server process.  Shared address spaces will have a
> common "which CPU this is currently running on" bitmap
> (mm->cpu_bitmap), which is updated whenever one of the threads using
> this address space gets scheduled or descheduled.
> 
> Now imagine a fuse server running on a big numa system, which has
> threads bound to each CPU.  The server tries to avoid using sharing
> data structures between threads, so that cache remains local.  But it
> can't avoid updating this bitmap on schedule.  The bitmap can pack 512
> CPUs into a single cacheline, which means that thread locality is
> compromised.

To be honest, I wonder how you worked around scheduler issues on waking
up the application thread. Did you core bind application threads as well
(I mean besides fuse server threads)? We now have this (unexported)
wake_on_current_cpu. Last year that still wasn't working perfectly well
and  Hillf Danton has suggested the 'seesaw' approach. And with that the
scheduler was working very well. You could get the same with application
core binding, but with 512 CPUs that is certainly not done manually
anymore. Did you use a script to bind application threads or did you
core bind from within the application?

> 
> I'm somewhat surprised that this doesn't turn up in profiles in real
> life, but I guess it's not a big deal in most cases.  I only observed
> it with a special "no-op" fuse server running on big numa and with
> per-thread queuing, etc. enabled (fuse2).

Ok, I'm testing only with 32 cores and two numa nodes. For final
benchmarking I could try to get a more recent AMD based system with 96
cores. I don't think we have anything near 512 CPUs in the lab. I'm not
aware of such customer systems either.

> 
>> For sync requests getting the scheduler involved is what is responsible
>> for making really fuse slow. It schedules on random cores, that are in
>> sleep states and additionally frequency scaling does not go up. We
>> really need to stay on the same core here, as that is submitting the
>> result, the core is already running (i.e. not sleeping) and has data in
>> its cache. All benchmark results with sync requests point that out.
> 
> No arguments about that.
> 
>> For async requests, the above still applies, but basically one thread is
>> writing/reading and the other thread handles/provides the data. Random
>> switching of cores is then still not good. At best and to be tested,
>> submitting rather large chunks to other cores.
>> What is indeed to be discussed (and think annotated in the corresponding
>> patch description), if there is a way to figure out if the other core is
>> already busy. But then the scheduler does not know what it is busy with
>> - are these existing fuse requests or something else. That part is
>> really hard and I don't think it makes sense to discuss this right now
>> before the main part is merged. IMHO, better to add a config flag for
>> the current cpu+1 scheduling with an annotation that this setting might
>> go away in the future.
> 
> The cpu + 1 seems pretty arbitrary, and could be a very bad decision
> if there are independent tasks bound to certain CPUs or if the target
> turns out to be on a very distant CPU.
> 
> I'm not sure what the right answer is.   It's probably something like:
> try to schedule this on a CPU which is not busy but is not very
> distant from this one.  The scheduler can probably answer this
> question, but there's no current API for this.

This is just another optimization. What you write is true and I was
aware of that. It was just a rather simple optimization that improved
results - enough to demo it. We can work with scheduler people in the
future on that or we add a bit of our own logic and create mapping of
cpu -> next-cpu-on-same-numa-node. Certainly an API and help from the
scheduler would be preferred.


Thanks,
Bernd

