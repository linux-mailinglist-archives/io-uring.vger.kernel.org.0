Return-Path: <io-uring+bounces-12313-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oK9zGX6ylWkHUAIAu9opvQ
	(envelope-from <io-uring+bounces-12313-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 13:37:18 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BE01815662F
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 13:37:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4A8FD3010D88
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 12:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86A9F318EFB;
	Wed, 18 Feb 2026 12:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OhaV37rs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DC13161A1
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 12:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771418209; cv=none; b=E+r/h9VBxCRnI6FBU2F4Q1cwTU8sRqDgDtpFw/1ok2i2nicajr0qS/DOIQg0KdvtHr91LEyVreh1PsvzEDcaXwR5NxhUUNOiYt+hPNa2jZVO5Qb3223AQu+0Bo5/1e8J8kGzxBpZmXnqY0o8ksnkdtOHDGsTU4oDZcADNiZqsz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771418209; c=relaxed/simple;
	bh=s5ZK6ZH605eyMnQxPT1E3AwPjgAiTk/S2xV2V9EkU00=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lY8AgwutF5Y9ufU7iyq72fEvz75dmdSgzSX2Yl1+zCvacBRPUBolI4NK79j0Z0YyIvKOMOYKuwDwudI/84jPPhUm1rY2O6gy7RHMvvy9UrZeCT3Uu+QrzIK/9CshpLrsx/VMhJU1HFSFGG7zHIuwzOWlFQ/sXi0Ro809BodiI+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OhaV37rs; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4806f3fc50bso61414505e9.0
        for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 04:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771418206; x=1772023006; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aqOcUFSotC5SoZFXFXr+TmVVlguvy7ywLxHwSoGMkjY=;
        b=OhaV37rsieVST4lgzHz+GQ306vwcDcqQ0Lxhrqyr8DsGPkHZxN8AmjnnyQeKKP5v3x
         MgXr4yItksOEDG0ez5MAdlkw2EsaJ3EKvQQLh/f/fhlbLv0yEeRwmn7L02xxvUJ28+KA
         Gybdq20mlo4EtV+1o4CsWOG9PpfEBwvekvUn3Li02JY8ZglYv8NePrt0VBcW8HyzKKnl
         62lIDBOoAZY8IgW5PkNj3IsGN9qpXWcrAqSDvla7SvntpOgXHQuo65Qgz+UHUcdYPC9Y
         QS33ZxyKEdD3UmZzBfF9rBAuC7a74aMw3c99puKnvhqCm8yeo0aHEiDOY31Qg/dZyFj1
         kQ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771418206; x=1772023006;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aqOcUFSotC5SoZFXFXr+TmVVlguvy7ywLxHwSoGMkjY=;
        b=uLOdTuNHIMEJ8pWDTsPlk0xfQMdblMfV5SLOQa5CnZp4mrMrNlZBM9domZGGc4qmJt
         jsAWoxtAmNRMk05jofmyyg2nf10WPeKfQW1p/U4Te2x1tCswQW5VU3wYFLx0HhwEqegx
         7+ouu51bqvAWPYKUGotsVZe2jvHluewaGNTwR5TgHXOrki84nXJ7qiPzhsLu8PochQJH
         6Uz49PfuDMx9NId/u8RNhUilBlQbcqF6MfYp90SH2OgUdEtB2Pnq8OMecEuikjxlsH1g
         eoYxCr96AyCkQNiys/Lx33vRDZK7hMXq4Lu+FRNNsJ+OtdJxHMTyhgDByiMz0I7EjeiW
         L4qA==
X-Forwarded-Encrypted: i=1; AJvYcCWN8WebAtVYQVxtHPQDHXU7tGfwee8f18S0i5h9H+f7GruWOjqguX/6UUYmn/sQk1DukMfuW0I7wQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6er+HPtMzk2ryvWCpFi6wkQ3lZkItkU0J5z95hofeTGV2Pn4r
	0iX9gjJcAedWoh94V2SgKbWcMYo0LnCbuDztVkN/iWIGkE64qtPoU0L6
X-Gm-Gg: AZuq6aJ0OJpK8nydAAgxT47+3KGt/WNIVj5vwgySA8xGOCATC+7P50GPzG6M4KjUzod
	FJ1STVob87HZPCLB+QJprH1czE6RNxxl4h3uS22dmWoyD16KOuhhxyIDILuR/uao+utyj8srbFX
	ci1Yy+QKEJoYzVUs3dLOw9cZZVzrqK6vcdjbgGr9aG+vcqfcEHLv4odBPtDdeEKfEhRB51lI7sl
	wlXuvUZt7sHQTIaZkk0M3fkmYWZnjumjKORv5MsSUoi0A18L9k4fXXHg5u0O43RTz1FZf/hb1SO
	zc6T9RQhqNP1ZVaSwj4dYgyvaIuq2+fbtG+CXyvxSu4qckqmCNCch/ft934WgXDJm1rEiUd3V8M
	5jddaNR1hFss4Bjkw5JQNnsVLDeabfPftf5GLt/4fNvh1gCdeHoVQJ19DKwJV5btp/mALo3Rn4Y
	YW82EC3+4mWg5nHAmTDO9Lx1h/5mOQGsSHrfR2h1p9wbOi0U+cpPqVdsKsmwTNwRG2RzyCHzuVU
	kC5nEG03RL04ihVG2kb4jjJrVCODptDxX/Q4qc5EPO9kesbKyXrp5NB1J8=
X-Received: by 2002:a05:600c:468b:b0:47e:e20e:bbb2 with SMTP id 5b1f17b1804b1-48379b93583mr230100025e9.7.1771418205782;
        Wed, 18 Feb 2026 04:36:45 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:aef7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483983f7886sm16476135e9.27.2026.02.18.04.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Feb 2026 04:36:44 -0800 (PST)
Message-ID: <7a62c5a9-1ac2-4cc2-a22f-e5b0c52dabea@gmail.com>
Date: Wed, 18 Feb 2026 12:36:43 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
 io-uring@vger.kernel.org, csander@purestorage.com, krisman@suse.de,
 bernd@bsbernd.com, linux-fsdevel@vger.kernel.org
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com>
 <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <aYykILfX_u9-feH-@infradead.org>
 <bd488a4e-a856-4fa5-b2bb-427280e6a053@gmail.com>
 <aY7QX-BIW-SMJ3h_@infradead.org>
 <34cf24a3-f7f3-46ed-96be-bf716b2db060@gmail.com>
 <CAJnrk1a+YuPpoLghA01uJhEKrhmrLhQ+5bw2OeeuLG3tG8p6Ew@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAJnrk1a+YuPpoLghA01uJhEKrhmrLhQ+5bw2OeeuLG3tG8p6Ew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12313-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BE01815662F
X-Rspamd-Action: no action

On 2/13/26 22:04, Joanne Koong wrote:
> On Fri, Feb 13, 2026 at 4:41 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
...
>> Fuse is doing both adding (kernel) buffers to the ring and consuming
>> them. At which point it's not clear:
>>
>> 1. Why it even needs io_uring provided buffer rings, it can be all
>>      contained in fuse. Maybe it's trying to reuse pbuf ring code as
>>      basically an internal memory allocator, but then why expose buffer
>>      rings as an io_uring uapi instead of keeping it internally.
>>
>>      That's also why I mentioned whether those buffers are supposed to
>>      be used with other types of io_uring requests like recv, etc.
> 
> On the userspace/server side, it uses the buffers for other io-uring
> operations (eg reading or writing the contents from/to a
> locally-backed file).

Oops, typo. I was asking whether the buffer rings (not buffers) are
supposed to be used with other requests. E.g. submitting a
IORING_OP_RECV with IOSQE_BUFFER_SELECT set and the bgid specifying
your kernel-managed buffer ring.

>> 2. Why making io_uring to allocate payload memory. The answer to which
>>      is probably to reuse the region api with mmap and so on. And why
>>      payload buffers are inseparably created together with the ring
> 
> My main motivation for this is simplicity. I see (and thanks for
> explaining) that using a registered mem region allows the use of some
> optimizations (the only one I know of right now is the PMD one you
> mentioned but maybe there's more I'm missing) that could be useful for
> some workloads, but I don't think (and this could just be my lack of
> understanding of what more optimizations there are) most use cases of
> kmbufs benefit from those optimizations, so to me it feels like we're
> adding non-trivial complexity for no noticeable benefit.

There are two separate arguments. The first is about not making buffers
inseparable from buffer rings in the io_uring user API. Whether it's
IORING_REGISTER_MEM_REGION or something else is not that important.
I have no objection if it's a part of fuse instead though, e.g. if
fuse binds two objects together when you register it with fuse, or even
if fuse create a buffer ring internally (assuming it doesn't indirectly
leak into io_uring uapi).

And the second was about optionally allowing user memory for buffer
creation as you're reusing the region abstraction. You can find pros
and cons for both modes, and funnily enough, SQ/CQ were first kernel
allocated and then people asked for backing it by user memory, and IIRC
it was in the reverse order for pbuf rings.

Implementing this is trivial as well, you just need to pass an argument
while creating a region. All new region users use struct
io_uring_region_desc for uapi and forward it to io_create_region()
without caring if it's user or kernel allocated memory.

> I feel like we get the best of both worlds by letting users have both:
> the simple kernel-managed pbuf where the kernel allocates the buffers
> and the buffers are tied to the lifecycle of the ring, and the more
> advanced kernel-managed pbuf where buffers are tied to a registered
> memory region that the subsystem is responsible for later populating
> the ring with.
> 
>>      and via a new io_uring uapi.
> 
> imo it felt cleaner to have a new uapi for it because kmbufs and pbufs

The stress is on why it's an _io_uring_ API. It doesn't matter to me
whether it's a separate opcode or not. Currently, buffer rings don't give
you anything that can't be pure fuse, and it might be simpler to have
it implemented in fuse than binding to some io_uring object. Or it could
create buffer rings internally to reuse code but it doesn't become an
io_uring uapi but rather implementation detail. And that predicates on
whether km rings are intended to be used with other / non-fuse requests.

> have different expectations and behaviors (eg pbufs only work with
> user-provided buffers and requires userspace to populate the ring
> before using it, whereas for kmbufs the kernel allocates the buffers
> and populates it for you; pbufs require userspace to recycle back the
> buffer, whereas for kmbufs the kernel is the one in control of
> recycling) and from the user pov it seemed confusing to have kmbufs as
> part of the pbuf ring uapi, instead of separating it out as a
> different type of ringbuffer with a different expectation and

I believe the source of disagreement is that you're thinking
about how it's going to look like for fuse specifically, and I
believe you that it'll be nicer for the fuse use case. However,
on the other hand it's an io_uring uapi, and if it is an io_uring
uapi, we need reusable blocks that are not specific to particular
users.

If it km rings has to stay an io_uring uapi, I guess a middle
ground would be to allow registering km rings together with memory,
but make it a pure region without a notion of a buffer, and let
fuse to chunk it. Later, we can make payload memory allocation
optional.

> behavior. I was trying to make the point that combining the interface
> if we go with IORING_MEM_REGION gets even more confusing because now
> pbufs that are kernel-managed are also empty at initialization and
> only can point to areas inside a registered mem region and the
> responsibility of populating it is now on whatever subsystem is using
> it.

Right, intentionally so, because otherwise it's a fuse uapi that
pretends to be a generic io_uring uapi but it's not because of
all assumptions in different places.

> I still have this opinion but I also think in general, you likely know
> better than I do what kind of io-uring uapi is best for io-uring's
> users. For v2 I'll have kmbufs go through the pbuf uapi.
> 
>>
>>      And yes, I believe in the current form it's inflexible, it requires
>>      a new io_uring uapi. It requires the number of buffers to match
>>      the number of ring entries, which are related but not the same
> 
> I'm not really seeing what the purpose of having a ring entry with no
> buffer associated with it is. In the existing code for non-kernel
> managed pbuf rings, there's the same tie between reg->ring_entries
> being used as the marker for how many buffers the ring supports. But

Not really, it tells the buffer ring depth but says nothing about
how much memory user space allocated and how it's pushed. It's a
reasonable default but they could be different. For example, if you
expect adding more memory at runtime, you might create the buffer
ring a bit larger. Or when server processing takes a while and you
can't recycle until it finishes, you might have more buffers than
you need ring entries. Or you might might decide to split buffers
and as you mentioned incremental consumption, which is an entire
separate topic because it doesn't do de-fragmentation and you'd
need to have it in fuse, just like user space does with pbufs.

> if the number of buffers should be different than the number of ring
> entries, this can be easily fixed by passing in the number of buffers
> from the uapi for kernel-managed pbuf rings.

My entire point is that we're making lots of assumptions for io_uring
uapi, and if it's moved to fuse because it knows better what it
needs, it should be a win.

IOW, it sounds better if instead of passing the number of buffers to
io_uring, you just ask it to create a large chunk of memory, and then
fuse chunks it up and puts into the ring.

>>      thing. You can't easily add more memory as it's bound to the ring
>>      object. The buffer memory won't even have same lifetime as the
> 
> To play devil's advocate, we also can't easily add more memory to the
> mem region once it's been registered. I think there's also a worse
> penalty where the user needs to know upfront how much memory to
> allocate for the mem region for the lifetime of the ring, which imo
> may be hard to do (eg if a kernel-managed buf ring only needs to be
> registered for some code paths and not others, the mem region
> registration would still have to allocate the memory a potential kbuf
> ring would use).

I agree, and you'd need something new in either case to add more
memory, and it doesn't need to be IORING_REGISTER_MEM_REGION
specifically.

>>      ring object -- allow using that km buffer ring with recv requests
>>      and highly likely I'll most likely give you a way to crash the
>>      kernel.
> 
> I'm a bit confused by this part. The buffer memory does have the same
> lifetime as the ring object, no? The buffers only get freed when the
> ring itself is freed.

Unregistering a buffer ring doesn't guarantee that there are no
inflight requests that are still using buffers that came out of
the buffer ring. The fuse driver can wait/terminate its requests
before unregisteration, but allow userspace issued IORING_OP_RECV
to use this km buffer ring, and you'll need to somehow synchronise
with all other io_uring requests.

-- 
Pavel Begunkov


