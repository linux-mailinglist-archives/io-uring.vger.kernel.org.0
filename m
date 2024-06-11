Return-Path: <io-uring+bounces-2160-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A93D29038D0
	for <lists+io-uring@lfdr.de>; Tue, 11 Jun 2024 12:26:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC1801C21468
	for <lists+io-uring@lfdr.de>; Tue, 11 Jun 2024 10:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FBFF14F9CC;
	Tue, 11 Jun 2024 10:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="Ol2G/Qwl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Fm+bXBif"
X-Original-To: io-uring@vger.kernel.org
Received: from wfout4-smtp.messagingengine.com (wfout4-smtp.messagingengine.com [64.147.123.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1F854750;
	Tue, 11 Jun 2024 10:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718101596; cv=none; b=fu7M261WDwRVwz0BE2q1BHHZ0+SdUqHJb2Myz5zn5cL74VRGxObGU0deZwvRQr1IPazw0D8RqsXKY+79uH8HZhkUiFYt4iSD0ApVVuYMuLT26vOeEXArf+XwRQHkfVBHuNPCglFV4To5oy4caUYsf6FXB1R5KoDVDR4xo/5HG6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718101596; c=relaxed/simple;
	bh=maNt/uhcrYX9xRmA8C2ymmFMiisBnVyFWuEqooNOfcI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=axg7icPvdI7T5pyqg4UfhS0wd3YBZhcw/Hf1Zt+u8+htUVbNmvmBGxWdJllzqRmzcBXBsIqPQ56rXKaU3jde3OZYt+Ww/P+OMcd7S58h+LxM7HzO9QFCfH6GWefVP72TyHDzd6gn7nILnwhNdfiPJrGjhk3HnY4XBxFrWKY5e4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=Ol2G/Qwl; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Fm+bXBif; arc=none smtp.client-ip=64.147.123.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailfout.west.internal (Postfix) with ESMTP id 974D11C000D6;
	Tue, 11 Jun 2024 06:26:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 11 Jun 2024 06:26:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1718101592;
	 x=1718187992; bh=zDgXz75IPyYSyzGjwEyK6xgeH1K1Pa6YT4NcRf967gU=; b=
	Ol2G/QwlwgO7wYvPeCUzk3KHS1zEFcUPGPjpeqHdXA6ILU8M4pwdm+EQGZc81zG4
	wTP8C/A/q9zxElmrx8HuML+xMPJcyNJ+ErJOmJZQwFi1q1eTme8+xZEiEmkmXFoY
	2WyEJZmGumgYSemCDZZgn/3xwIIWv2k4c3Xgf9M3G4Vd9YJo76sWJ1QUVN7dwm0J
	y/JdAX5O2ekRk2f8nWwjvOIp00R6QX9MytR84nrsJJHgmjF8wmU2okAzPLCf/McX
	ZRsTs43RlrcQmExrwCtzG7lzk8s3FMub5PMNEV8dygNwomDcW46Yop8GCwUhPdae
	57oxGZcVE3DER3gzZtp86g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1718101592; x=
	1718187992; bh=zDgXz75IPyYSyzGjwEyK6xgeH1K1Pa6YT4NcRf967gU=; b=F
	m+bXBifbIFopPRni6LPnZRHhwntC0/n9hlJle12rXwnS1NkEubeTze7fjE2Kk08F
	evyCq4WprnBTrp/CVXL6kmLnhhommL96ChkY8ht+C0MV3PGSHg8FUvRHLHm7udsT
	vAXDiXbbmE96Eup83ZFVxgR6tszvTT5hKYGcTxxl44k5EiEkg4PlZJ47yUW/83Fa
	ful2WfcWaFrsdx++YUbhRIcsEbwSCwfCZN/KefzNWVuFfdabmGrfFThhD0qXrWCR
	lSuNWOaL7b9e1NDn2tpcwE8Z1/kpBk5PCwSLSAikr0c7DXgRIJ5A2TUNTDLJIIhP
	3a/J0dZL+sBXs7SoHVz2A==
X-ME-Sender: <xms:VyZoZtSxCRuas1B2k4T1jgllkAPSiAelIyN2pnZQgStfw3TP9CGXrw>
    <xme:VyZoZmxLS0hQNqWx3Hx7qCO3uSyve7S4ODGcX4sJfDNQmahiMH_1DxFV5cKj9WBqo
    PCzmsi79hhpmFiH>
X-ME-Received: <xmr:VyZoZi19wpRb0nOYgFnNgWHqLD7ai6s4BfrWmxxa2NQuUtieoNwlzt2iNbatXCiPjISX3y_jNoFcJjbERx1p9KxjKdnraZQNXJQRnZYjCQkJjwxobu-b>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrfeduvddgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeeuvghr
    nhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvghrthesfhgrshhtmhgrih
    hlrdhfmheqnecuggftrfgrthhtvghrnhepvedvfffhleettddtleffheduieeuveeghfdv
    gfefudeiheduffehudetlefhgfeunecuffhomhgrihhnpehgihhthhhusgdrtghomhdpkh
    gvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsggvrhhnugdrshgthhhusggvrhhtsehfrghsthhmrghilhdrfhhm
X-ME-Proxy: <xmx:VyZoZlAmpcMe7sna75iynZtviaxO2ywlKeLQBdBPx2Z3lMweeOx4Jg>
    <xmx:VyZoZmj0wJuh6CDbRcC9-pVBBAqqwgq9sbMZJNH0SNJniiNOXOpsOw>
    <xmx:VyZoZpochK3JQzwA5o7fRW4vLNixWMGQ5u3srCfXRRViKnRBcOG48w>
    <xmx:VyZoZhgbiO-uELHFhDivEehLe0iHJdm23ivda1A8YYmiu_uBUSn-kQ>
    <xmx:WCZoZrZwbV2ACczbdEfozRQHtsavfkc3Y1AvcLeKQvEdLhQYhs3k1YRf>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Jun 2024 06:26:30 -0400 (EDT)
Message-ID: <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm>
Date: Tue, 11 Jun 2024 12:26:29 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bschubert@ddn.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/11/24 10:20, Miklos Szeredi wrote:
> On Wed, 29 May 2024 at 20:01, Bernd Schubert <bschubert@ddn.com> wrote:
>>
>> From: Bernd Schubert <bschubert@ddn.com>
>>
>> This adds support for uring communication between kernel and
>> userspace daemon using opcode the IORING_OP_URING_CMD. The basic
>> appraoch was taken from ublk.  The patches are in RFC state,
>> some major changes are still to be expected.
> 
> Thank you very much for tackling this.  I think this is an important
> feature and one that could potentially have a significant effect on
> fuse performance, which is something many people would love to see.
> 
> I'm thinking about the architecture and there are some questions:
> 
> Have you tried just plain IORING_OP_READV / IORING_OP_WRITEV?  That's
> would just be the async part, without the mapped buffer.  I suspect
> most of the performance advantage comes from this and the per-CPU
> queue, not from the mapped buffer, yet most of the complexity seems to
> be related to the mapped buffer.

I didn't try because IORING_OP_URING_CMD seems to be exactly made for
our case.

Firstly and although I didn't have time to look into it yet, but with
the current approach it should be rather simple to switch to another
ring as Kent has suggested.

Secondly, with IORING_OP_URING_CMD we already have only a single command
to submit requests and fetch the next one - half of the system calls.

Wouldn't IORING_OP_READV/IORING_OP_WRITEV be just this approach?
https://github.com/uroni/fuseuring?
I.e. it hook into the existing fuse and just changes from read()/write()
of /dev/fuse to io-uring of /dev/fuse. With the disadvantage of zero
control which ring/queue and which ring-entry handles the request.

Thirdly, initially I had even removed the allocation of 'struct
fuse_req' and directly allocated these on available ring entries. I.e.
the application thread was writing to the mmap ring buffer. I just
removed that code for now, as it introduced additional complexity with
an unknown performance outcome. If it should be helpful we could add
that later. I don't think we have that flexibility with
IORING_OP_READV/IORING_OP_WRITEV.

And then, personally I do not see mmap complexity - it is just very
convenient to write/read to/from the ring buffer from any kernel thread.
Currently not supported by io-uring, but I think we could even avoid any
kind of system call and let the application poll for results. Similar to
what IORING_SETUP_SQPOLL does, but without the requirement of another
kernel thread.

Most complexity and issues I got, come from the requirement of io_uring
to complete requests with io_uring_op_cmd_done. In RFCv1 you had
annotated the async shutdown method - that was indeed really painful and
resulted in a never ending number of shutdown races. Once I removed that
and also removed using a bitmap (I don't even know why I used a bitmap
in the first place in RFCv1 and not lists as in RFCv2) shutdown became
manageable.

If there would be way to tell io-uring that kernel fuse is done and to
let it complete itself whatever was not completed yet, it would would be
great help. Although from my point of view, that could be done once this
series is merged.
Or we decide to switch to Kents new ring buffer and might not have that
problem at all...

> 
> Maybe there's an advantage in using an atomic op for WRITEV + READV,
> but I'm not quite seeing it yet, since there's no syscall overhead for
> separate ops.

Here I get confused, could please explain?
Current fuse has a read + write operation - a read() system call to
process a fuse request and a write() call to submit the result and then
read() to fetch the next request.
If userspace has to send IORING_OP_READV to fetch a request and complete
with IORING_OP_IORING_OP_WRITEV it would go through existing code path
with operations? Well, maybe userspace could submit with IOSQE_IO_LINK,
but that sounds like it would need to send two ring entries? I.e. memory
and processing overhead?

And then, no way to further optimize and do fuse_req allocation on the
ring (if there are free entries). And probably also no way that we ever
let the application work in the SQPOLL way, because the application
thread does not have the right to read from the fuse-server buffer? I.e.
what I mean is that IORING_OP_URING_CMD gives a better flexibility.

Btw, another issue that is avoided with the new ring-request layout is
compatibility and alignment. The fuse header is always in a 4K section
of the request data follow then. I.e. extending request sizes does not
impose compatibility issues any more and also for passthrough and
similar - O_DIRECT can be passed through to the backend file system.
Although these issues probably need to be solved into the current fuse
protocol.

> 
> What's the reason for separate async and sync request queues?

To have credits for IO operations. For an overlay file system it might
not matter, because it might get stuck with another system call in the
underlying file system. But for something that is not system call bound
and that has control, async and sync can be handled with priority given
by userspace.

As I had written in the introduction mail, I'm currently working on
different IO sizes per ring queue - it gets even more fine grained and
with the advantage of reduced memory usage per queue when the queue has
entries for many small requests and a few large ones.

Next step would here to add credits for reads/writes (or to reserve
credits for meta operations) in the sync queue, so that meta operations
can always go through. If there should be async meta operations (through
application io-uring requests?) would need to be done for the async
queue as well.

Last but not least, with separation there is no global async queue
anymore - no global lock and cache issues.

> 
>> Avoiding cache line bouncing / numa systems was discussed
>> between Amir and Miklos before and Miklos had posted
>> part of the private discussion here
>> https://lore.kernel.org/linux-fsdevel/CAJfpegtL3NXPNgK1kuJR8kLu3WkVC_ErBPRfToLEiA_0=w3=hA@mail.gmail.com/
>>
>> This cache line bouncing should be addressed by these patches
>> as well.
> 
> Why do you think this is solved?


I _guess_ that writing to the mmaped buffer and processing requests on
the same cpu core should make it possible to keep things in cpu cache. I
did not verify that with perf, though.

> 
>> I had also noticed waitq wake-up latencies in fuse before
>> https://lore.kernel.org/lkml/9326bb76-680f-05f6-6f78-df6170afaa2c@fastmail.fm/T/
>>
>> This spinning approach helped with performance (>40% improvement
>> for file creates), but due to random server side thread/core utilization
>> spinning cannot be well controlled in /dev/fuse mode.
>> With fuse-over-io-uring requests are handled on the same core
>> (sync requests) or on core+1 (large async requests) and performance
>> improvements are achieved without spinning.
> 
> I feel this should be a scheduler decision, but the selecting the
> queue needs to be based on that decision.  Maybe the scheduler people
> can help out with this.

For sync requests getting the scheduler involved is what is responsible
for making really fuse slow. It schedules on random cores, that are in
sleep states and additionally frequency scaling does not go up. We
really need to stay on the same core here, as that is submitting the
result, the core is already running (i.e. not sleeping) and has data in
its cache. All benchmark results with sync requests point that out.

For async requests, the above still applies, but basically one thread is
writing/reading and the other thread handles/provides the data. Random
switching of cores is then still not good. At best and to be tested,
submitting rather large chunks to other cores.
What is indeed to be discussed (and think annotated in the corresponding
patch description), if there is a way to figure out if the other core is
already busy. But then the scheduler does not know what it is busy with
- are these existing fuse requests or something else. That part is
really hard and I don't think it makes sense to discuss this right now
before the main part is merged. IMHO, better to add a config flag for
the current cpu+1 scheduling with an annotation that this setting might
go away in the future.


Thanks,
Bernd

