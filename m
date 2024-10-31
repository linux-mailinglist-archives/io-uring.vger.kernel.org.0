Return-Path: <io-uring+bounces-4265-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB6AB9B7BC5
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 14:35:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B6822823B1
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 13:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D6A519DF60;
	Thu, 31 Oct 2024 13:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xhUiHGxD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EA819B3D8
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 13:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730381743; cv=none; b=hqf5D/6h18bHz6sT0Ii/ybwL6/B7CwIEqCDjT9nJKnvhBDbrVebK5yi6vuXxa1fJ09h00mYyx6KS6q/vR9fEeH7+EHk1lxx66pkmD+i8cftbRn9cKDJ+qK3qk5Rr08fU3mgAhd28o5s/C/F+fbpDcyADpisWgH2hDdeARdzg/z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730381743; c=relaxed/simple;
	bh=0IL981uGHpcNy7x2z1gDNctekUXtkQ5EG1EbFWZn41g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iyWaNYgGAg5geP9zFnv45cA9aD2cHSUHPxbAmkm2xjGQaZgH6lgP0fR1pM32fDEjzXv1UmpVc98fQZr5skHI/5dryaT2nS51pp7fpTQMe80OQMg6kO2ZsKJcQrJv6uWdUtFHArzu/9oJTxhoE9/wiL2C2HbmpCR1J8w6XRfjkEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xhUiHGxD; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-83ac05206f6so33977939f.2
        for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 06:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730381738; x=1730986538; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nNv9075OCWi9RrftsUA+Z4iEEwc0DVLofZ1iPKvq+o4=;
        b=xhUiHGxDRyFuBgZNwClG9JlungXB9j0lI3D7YErU5k08Iv43So75JqkXOfcJR7TYbE
         U7YWdoWsqXt5uCJ14QSRta6z7XiqtMKDs+d0XIks35GKlDRrA/wYJa9hk7AIrb90Dc6d
         VRoudIUrK/C3frgg5rcsNh8JiEjQL2tRmMsiuEUK+f5jt/Y7odrbNKdw46acKjC+ZZy1
         Efi1tDYHeMcovThYHHSmnoQMBnGsSMUBI1GC3mmQsaSjoPgSIqTpGyV1gaACy2rldCg6
         P7umtm4OZtGKKi165GhLxhFIRcfkpB7to1agqs8MkPpdbA3yx5CkfKktPmcq9nlWaPm5
         umpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730381738; x=1730986538;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nNv9075OCWi9RrftsUA+Z4iEEwc0DVLofZ1iPKvq+o4=;
        b=occcEXz1TlZA7Xw7hNjZmUum8c/KTlRN6gCwQdqWK7Ft5rKH4vJdyeg1S7YSfauEww
         QW6V5OES8PNZcj64enZjXg5qsUa8Xvfd1yf0JJ02a8bdAoSeEbako+vsXBNReSB+VzJH
         lMcaNx/Jo2eP46ERn6QWp5rgAQUqDvhgtrAlLWlOh6kMhyf3MUDSCsttLnUfXkelkR3M
         Xpbnjx/2RueaigrORem6KIE5Y5h3TPtVlIulRiGK3L+QubdsoFnQJfKtZEx1+hZvnsxx
         sQ01JfDDhrkvFamywuEquadkfjLYTz05SSFngimhM92/Kgc8Pv42vointFAvGxigGc04
         fd9g==
X-Forwarded-Encrypted: i=1; AJvYcCWhjkXE/3YVzMP1m60p4ELeul01S183N0Cya09UG7acU4OfOhCpfAzPAVoU12KYQVzlf8Kn12Hhyg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl4ASgKZYSHwGpcrQ/h+rQmL8qmVurygi7hkmCG/SUDLWQiRRn
	H8itmfM6i49m1MQeLuHtmU7gT5V60I1CIDTBgBAej+/zdR+0iPR+mRyQphWjV/U=
X-Google-Smtp-Source: AGHT+IGA/9W+n6Xh8vS08ONU5JUBPBlR2xOsAEfQqfA7TK4Yhgc10OJ833l9lzf24jB2xu+9R7/ejQ==
X-Received: by 2002:a05:6602:6b10:b0:835:4d07:9d46 with SMTP id ca18e2360f4ac-83b650688efmr277948839f.15.1730381737826;
        Thu, 31 Oct 2024 06:35:37 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de049a212bsm287963173.125.2024.10.31.06.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 06:35:37 -0700 (PDT)
Message-ID: <63e2091d-d000-4b42-818b-802341ac877f@kernel.dk>
Date: Thu, 31 Oct 2024 07:35:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 0/8] io_uring: support sqe group and leased group kbuf
To: Ming Lei <ming.lei@redhat.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <15b9b1e0-d961-4174-96ed-5a6287e4b38b@gmail.com>
 <d859c85c-b7bf-4673-8c77-9d7113f19dbb@kernel.dk>
 <bc44d3c0-41e8-425c-957f-bad70aedcc50@kernel.dk>
 <e76d9742-5693-4057-b925-3917943c7441@kernel.dk>
 <f51e50c8-271e-49b6-b3e1-a63bf61d7451@kernel.dk> <ZyGT3h5jNsKB0mrZ@fedora>
 <674e8c3c-1f2c-464a-ad59-da3d00104383@kernel.dk> <ZyGjID-17REc9X3e@fedora>
 <ZyGx4JBPdU4VlxlZ@fedora> <d986221d-7399-4487-9c28-5d6f953510cd@kernel.dk>
 <ZyLxJdn7bboZMAcs@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZyLxJdn7bboZMAcs@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/30/24 8:53 PM, Ming Lei wrote:
> On Wed, Oct 30, 2024 at 07:20:48AM -0600, Jens Axboe wrote:
>> On 10/29/24 10:11 PM, Ming Lei wrote:
>>> On Wed, Oct 30, 2024 at 11:08:16AM +0800, Ming Lei wrote:
>>>> On Tue, Oct 29, 2024 at 08:43:39PM -0600, Jens Axboe wrote:
>>>
>>> ...
>>>
>>>>> You could avoid the OP dependency with just a flag, if you really wanted
>>>>> to. But I'm not sure it makes a lot of sense. And it's a hell of a lot
>>>>
>>>> Yes, IO_LINK won't work for submitting multiple IOs concurrently, extra
>>>> syscall makes application too complicated, and IO latency is increased.
>>>>
>>>>> simpler than the sqe group scheme, which I'm a bit worried about as it's
>>>>> a bit complicated in how deep it needs to go in the code. This one
>>>>> stands alone, so I'd strongly encourage we pursue this a bit further and
>>>>> iron out the kinks. Maybe it won't work in the end, I don't know, but it
>>>>> seems pretty promising and it's soooo much simpler.
>>>>
>>>> If buffer register and lookup are always done in ->prep(), OP dependency
>>>> may be avoided.
>>>
>>> Even all buffer register and lookup are done in ->prep(), OP dependency
>>> still can't be avoided completely, such as:
>>>
>>> 1) two local buffers for sending to two sockets
>>>
>>> 2) group 1: IORING_OP_LOCAL_KBUF1 & [send(sock1), send(sock2)]  
>>>
>>> 3) group 2: IORING_OP_LOCAL_KBUF2 & [send(sock1), send(sock2)]
>>>
>>> group 1 and group 2 needs to be linked, but inside each group, the two
>>> sends may be submitted in parallel.
>>
>> That is where groups of course work, in that you can submit 2 groups and
>> have each member inside each group run independently. But I do think we
>> need to decouple the local buffer and group concepts entirely. For the
>> first step, getting local buffers working with zero copy would be ideal,
>> and then just live with the fact that group 1 needs to be submitted
>> first and group 2 once the first ones are done.
> 
> IMHO, it is one _kernel_ zero copy(_performance_) feature, which often
> imply:
> 
> - better performance expectation
> - no big change on existed application for using this feature

For #2, really depends on what it is. But ideally, yes, agree.

> Application developer is less interested in sort of crippled or
> immature feature, especially need big change on existed code
> logic(then two code paths need to maintain), with potential
> performance regression.
> 
> With sqe group and REQ_F_GROUP_KBUF, application just needs lines of
> code change for using the feature, and it is pretty easy to evaluate
> the feature since no any extra logic change & no extra syscall/wait
> introduced. The whole patchset has been mature enough, unfortunately
> blocked without obvious reasons.

Let me tell you where I'm coming from. If you might recall, I originated
the whole grouping idea. Didn't complete it, but it's essentially the
same concept as REQ_F_GROUP_KBUF in that you have some dependents on a
leader, and the dependents can run in parallel rather than being
serialized by links. I'm obviously in favor of this concept, but I want
to see it being done in such a way that it's actually something we can
reason about and maintain. You want it for zero copy, which makes sense,
but I also want to ensure it's a CLEAN implementation that doesn't have
tangles in places it doesn't need to.

You seem to be very hard to convince of making ANY changes at all. In
your mind the whole thing is done, and it's being "blocked without
obvious reason". It's not being blocked at all, I've been diligently
trying to work with you recently on getting this done. I'm at least as
interested as you in getting this work done. But I want you to work with
me a bit on some items so we can get it into a shape where I'm happy
with it, and I can maintain it going forward.

So, please, rather than dig your heels in all the time, have an open
mind on how we can accomplish some of these things.


>> Once local buffers are done, we can look at doing the sqe grouping in a
>> nice way. I do think it's a potentially powerful concept, but we're
>> going to make a lot more progress on this issue if we carefully separate
>> dependencies and get each of them done separately.
> 
> One fundamental difference between local buffer and REQ_F_GROUP_KBUF is
> 
> - local buffer has to be provided and used in ->prep()
> - REQ_F_GROUP_KBUF needs to be provided in ->issue() instead of ->prep()

It does not - the POC certainly did it in ->prep(), but all it really
cares about is having the ring locked. ->prep() always has that,
->issue() _normally_ has that, unless it ends up in an io-wq punt.

You can certainly do it in ->issue() and still have it be per-submit,
the latter which I care about for safety reasons. This just means it has
to be provided in the _first_ issue, and that IOSQE_ASYNC must not be
set on the request. I think that restriction is fine, nobody should
really be using IOSQE_ASYNC anyway.

I think the original POC maybe did more harm than good in that it was
too simplistic, and you seem too focused on the limits of that. So let
me detail what it actually could look like. We have io_submit_state in
io_ring_ctx. This is per-submit private data, it's initialized and
flushed for each io_uring_enter(2) that submits requests.

We have a registered file and buffer table, file_table and buf_table.
These have life times that are dependent on the ring and
registration/unregistration. We could have a local_table. This one
should be setup by some register command, eg reserving X slots for that.
At the end of submit, we'd flush this table, putting nodes in there.
Requests can look at the table in either prep or issue, and find buffer
nodes. If a request uses one of these, it grabs a ref and hence has it
available until it puts it at IO completion time. When a single submit
context is done, local_table is iterated (if any entries exist) and
existing nodes cleared and put.

That provides a similar table to buf_table, but with a lifetime of a
submit. Just like local buf. Yes it would not be private to a single
group, it'd be private to a submit which has potentially bigger scope,
but that should not matter.

That should give you exactly what you need, if you use
IORING_RSRC_KBUFFER in the local_table. But it could even be used for
IORING_RSRC_BUFFER as well, providing buffers for a single submit cycle
as well.

Rather than do something completely on the side with
io_uring_kernel_buf, we can use io_rsrc_node and io_mapped_ubuf for
this. Which goes back to my initial rant in this email - use EXISTING
infrastructure for these things. A big part of why this isn't making
progress is that a lot of things are done on the side rather than being
integrated. Then you need extra io_kiocb members, where it really should
just be using io_rsrc_node and get everything else for free. No need to
do special checking and putting seperately, it's a resource node just
like any other resource node we already support.

> The only common code could be one buffer abstraction for OP to use, but
> still used differently, ->prep() vs. ->issue().

With the prep vs issue thing not being an issue, then it sounds like we
fully agree that a) it should be one buffer abstraction, and b) we
already have the infrastructure for this. We just need to add
IORING_RSRC_KBUFFER, which I already posted some POC code for.

> So it is hard to call it decouple, especially REQ_F_GROUP_KBUF has been
> simple enough, and the main change is to import it in OP code.
> 
> Local buffer is one smart idea, but I hope the following things may be
> settled first:
> 
> 1) is it generic enough to just allow to provide local buffer during
> ->prep()?
> 
> - this way actually becomes sync & nowait IO, instead AIO, and has been
>   one strong constraint from UAPI viewpoint.
> 
> - Driver may need to wait until some data comes, then return & provide
> the buffer with data, and local buffer can't cover this case

This should be moot now with the above explanation.

> 2) is it allowed to call ->uring_cmd() from io_uring_cmd_prep()? If not,
> any idea to call into driver for leasing the kernel buffer to io_uring?

Ditto

> 3) in OP code, how to differentiate normal userspace buffer select with
> local buffer? And how does OP know if normal buffer select or local
> kernel buffer should be used? Some OP may want to use normal buffer
> select instead of local buffer, others may want to use local buffer.

Yes this is a key question we need to figure out. Right now using fixed
buffers needs to set ->buf_index, and the OP needs to know aboout it.
let's not confuse it with buffer select, IOSQE_BUFFER_SELECT, as that's
for provided buffers.

> 4) arbitrary numbers of local buffer needs to be supported, since IO
> often comes at batch, it shouldn't be hard to support it by adding xarray
> to submission state, what do you think of this added complexity? Without
> supporting arbitrary number of local buffers, performance can be just
> bad, it doesn't make sense as zc viewpoint. Meantime as number of local
> buffer is increased, more rsrc_node & imu allocation is introduced, this
> still may degrade perf a bit.

That's fine, we just need to reserve space for them upfront. I don't
like the xarray idea, as:

1) xarray does internal locking, which we don't need here
2) The existing io_rsrc_data table is what is being used for
   io_rsrc_node management now. This would introduce another method for
   that.

I do want to ensure that io_submit_state_finish() is still low overhead,
and using an xarray would be more expensive than just doing:

if (ctx->local_table.nr)
	flush_nodes();

as you'd need to always setup an iterator. But this isn't really THAT
important. The benefit of using an xarray would be that we'd get
flexible storing of members without needing pre-registration, obviously.

> 5) io_rsrc_node becomes part of interface between io_uring and driver
> for releasing the leased buffer, so extra data has to be
> added to `io_rsrc_node` for driver use.

That's fine imho. The KBUFFER addition already adds the callback, we can
add a data thing too. The kernel you based your code on has an
io_rsrc_node that is 48 bytes in size, and my current tree has one where
it's 32 bytes in size after the table rework. If we have to add 2x8b to
support this, that's NOT a big deal and we just end up with a node
that's the same size as before.

And we get rid of this odd intermediate io_uring_kernel_buf struct,
which is WAY bigger anyway, and requires TWO allocations where the
existing io_mapped_ubuf embeds the bvec. I'd argue two vs one allocs is
a much bigger deal for performance reasons.

As a final note, one thing I mentioned in an earlier email is that part
of the issue here is that there are several things that need ironing
out, and they are actually totally separate. One is the buffer side,
which this email mostly deals with, the other one is the grouping
concept.

For the sqe grouping, one sticking point has been using that last
sqe->flags bit. I was thinking about this last night, and what if we got
away from using a flag entirely? At some point io_uring needs to deal
with this flag limitation, but it's arguably a large effort, and I'd
greatly prefer not having to paper over it to shove in grouped SQEs.

So... what if we simply added a new OP, IORING_OP_GROUP_START, or
something like that. Hence instead of having a designated group leader
bit for an OP, eg:

sqe = io_uring_get_sqe(ring);
io_uring_prep_read(sqe, ...);
sqe->flags |= IOSQE_GROUP_BIT;

you'd do:

sqe = io_uring_get_sqe(ring);
io_uring_prep_group_start(sqe, ...);
sqe->flags |= IOSQE_IO_LINK;

sqe = io_uring_get_sqe(ring);
io_uring_prep_read(sqe, ...);

which would be the equivalent transformation - the read would be the
group leader as it's the first member of that chain. The read should set
IOSQE_IO_LINK for as long as it has members. The members in that group
would NOT be serialized. They would use IOSQE_IO_LINK purely to be part
of that group, but IOSQE_IO_LINK would not cause them to be serialized.
Hence the link just implies membership, not ordering within the group.

This removes the flag issue, with the sligth caveat that IOSQE_IO_LINK
has a different meaning inside the group. Maybe you'd need a GROUP_END
op as well, so you could potentially terminate the group. Or maybe you'd
just rely on the usual semantics, which is "first one that doesn't have
IOSQE_IO_LINK sets marks the end of the group", which is how linked
chains work right now too.

The whole grouping wouldn't change at all, it's just a different way of
marking what constitutes a group that doesn't run afoul of the whole
flag limitation thing.

Just an idea!

-- 
Jens Axboe

