Return-Path: <io-uring+bounces-12390-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OEjtHuqynGmxJwQAu9opvQ
	(envelope-from <io-uring+bounces-12390-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 21:04:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EC4AE17CB36
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 21:04:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A39163015702
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 20:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55436366DC0;
	Mon, 23 Feb 2026 20:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GaZHY2Dy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2F536605D
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 20:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771876823; cv=none; b=nXUtZgaPGhpgxso8yhakpy0VbOjm4J3gtTeIUkTLIOQZUWr9fQxEy1Hv+pf9t/bzE2vxyllIjRJAhXH3gfi5fW4s+JpTB5LcC1WFwuPNeOhP1Ei5Luw6pBQFMJxP/tmztCpWmbVj0Kl7TS3V1/iHq+Pkg79dYGZYKfI3fLGuY5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771876823; c=relaxed/simple;
	bh=4jls0VB2pPpO17qp5P78+T6wnaEkTuXm3XnZVGXUqg8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aJZiRxwqdx2C/Wng2lvQzLOa/246GNTUgecHdQY7+ECVPOztHUkuNjzO+DtqcEbXJpLwoZg1oZ0qWmmeHdVEMHCvv356rDqxU5xIaJSScZZvt6ei8W/RgU4corxiL8PkWZqljniXHiG/UYLCCFjLmGfFTHts7TpqfYdu8wnZbqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GaZHY2Dy; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48372efa020so37799895e9.2
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 12:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771876820; x=1772481620; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ppR0cEPQxTYV1q27SxXg+9iVDhkw6VgIGfU3vsgp4Sw=;
        b=GaZHY2Dyq/JKlBz0WTXkhWNFaFjOVts5y5cCZKYizF+FeZ1mif1vH8g6U1DpXkF1p6
         Wq5OLV9QrunWtGFF0cGrZAd+gplARJEQh/tiybCFZH4Daog6WdMfWwC9dzY9DjCIdXfX
         mhzc2PXgt2P0Ef+eNv5maSjPks43P1iUagK0UUCmsHmk5Feaic0ohpZdOicm1a6Axt5Z
         0zTharh7wmqDniVxTQEpW0Enf8Z7cP+ngap/EyumTRvai0MUHnBuogiXDqO4bhEaNN0b
         X7VbRvA4GEZ/vQnAabLJa2KNnVpeK5POhv1I53I/wij7oVSAVVPv5UcyGU5Zi48gyQGh
         yg5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771876820; x=1772481620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ppR0cEPQxTYV1q27SxXg+9iVDhkw6VgIGfU3vsgp4Sw=;
        b=SJzB5mr+ItyPMmZOpG4JNufKhsIFH9kGP2zHvo8dvGB4vtBsM6LI/qSvhe2r9MRsSY
         5UgScMcwLWPggas/BsRnjPgTmlgzdPH9lh4KaTSygQKSmmDFoImH8AsymqF6TlUfqD6l
         h5SxI0e81QDEGUU/876A09xeDLF7xe7QM5laPxa3Txc0ptfK8XjW1Vks/q8tAKIemiAu
         /Sr01um52K/UN1/qw9GMt+X3Pjvr9u1Y31QeAB0A0EjYdL1LO74gOh5WlDbj3tbZ/KMm
         HWrv+Qc2m20M9f+4iLPOLo7sMc+MUVqTU99ESRrKQwcxRzcH7FaB669fJmgcG0eSSN90
         7HOA==
X-Forwarded-Encrypted: i=1; AJvYcCUHbLTFGfi9a8W96sWF/Zt18fw6fInlOon+7fvRMKikaIuD5e0vi5ZDOc+vYSRiyo5rNHGwdmNDsA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZzmSc+Wps6HGfOhYxhciypn1TFOpeIm4dIR4/rI/tfo4nWvO4
	hGuEe/hosBs34DYT+0T/HpnXc7H2Bm3et/mg0ttwtY/H2rsF4dbgOw6d
X-Gm-Gg: AZuq6aLM+DRTrOh2U+RUu7xGhARANMWi9Kwkd1LNh6gPSweGyyM55koqUvsnjP0woWJ
	4oFEFB1DDgB6gQXjvnDpiEg0CoMIbreJ+tzpskEk0OPAWyrKeAeHJjJBN985erv+VLzECxwCFwF
	aMRsAmwaTHFIl+J1qrjo+OSES5Beyz5urZUbbDULBApMG5P/fdX0+t2cERU7AXlclERtOcwK5jl
	hop+iZXiC/aqineUTry+m9VuHl69fP+yMPRKihYLHmrOna7fchTbnFzbW23CMMNs6cusJF7gKnR
	yUm5f5DeyAzd+5gGPNVPWpv6hr+sqYKhX5TDpQ9lR9EvyBjnYjaeVJLoMP9bkyF+S1CPdxxWKTg
	fTp3Z/hkk3pxtCu3vd1hNinfrUkaYQ9lxZMblO4dqrepIFg0HWHuRkrBdCK/4OEnL0+KYknqUEm
	EV51lq50K6KcUZRsRjsDTKHiIBYZZQeoWs15ioom+PxENYxpeXfN0l+bEaEb5v8btvwfEGzEQUC
	a09VEPhqy/2eNVRyj1oamKDqIKSaEFGvqxz6clPhF1vU6ktincQ5UZ4TLzP3oVvD6ZOWP7rpIyb
	ow==
X-Received: by 2002:a05:600c:3516:b0:483:7783:5373 with SMTP id 5b1f17b1804b1-483a963588bmr149371545e9.23.1771876819843;
        Mon, 23 Feb 2026 12:00:19 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483b822c9a5sm5178545e9.2.2026.02.23.12.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Feb 2026 12:00:18 -0800 (PST)
Message-ID: <94ae832e-209a-4427-925c-d4e2f8217f5a@gmail.com>
Date: Mon, 23 Feb 2026 20:00:15 +0000
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
 <7a62c5a9-1ac2-4cc2-a22f-e5b0c52dabea@gmail.com>
 <CAJnrk1Y5iTOhj4_RbnR7RJPkr7fFcCdh1gY=3Hm72M91D-SnyQ@mail.gmail.com>
 <11869d3d-1c40-4d49-a6c2-607fd621bf91@gmail.com>
 <CAJnrk1Zr=9RMGpNXpe6=fSDkG2uVijB9qa1vENHpQozB3iPQtg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAJnrk1Zr=9RMGpNXpe6=fSDkG2uVijB9qa1vENHpQozB3iPQtg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12390-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EC4AE17CB36
X-Rspamd-Action: no action

On 2/21/26 02:14, Joanne Koong wrote:
> On Fri, Feb 20, 2026 at 4:53 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
...
>> So I'm asking whether you expect that a server or other user space
>> program should be able to issue a READ_OP_RECV, READ_OP_READ or any
>> other similar request, which would consume buffers/entries from the
>> km ring without any fuse kernel code involved? Do you have some
>> use case for that in mind?
> 
> Thanks for clarifying your question. Yes, this would be a useful
> optimization in the future for fuse servers with certain workload
> characteristics (eg network-backed servers with high concurrency and
> unpredictable latencies). I don't think the concept of kmbufrings is
> exclusively fuse-specific though (for example, Christoph's use case
> being a recent instance);

Sorry, I don't see relevance b/w km rings and what Christoph wants.
I explained why in some sub-thread, but maybe someone can tell
what I'm missing.

> I think other subsystems/users that'll use
> kmbuf rings would also generically find it useful to have the option
> of READ_OP_RECV/READ_OP_READ operating directly on the ring.

Yep, it could be, potentially, it's just the patchset doesn't plumb
it to other requests and uses it within fuse. It's just cases like
that always make me wonder, here it was why what is basically an
internal kernel fuse API is exposed as an io_uring uapi. Maybe there
was a discussion about it I missed?

>> So you already can do all that using the mmap()'ed region user
>> pointer, and you just want it to be more efficient, right?
>> For that let's just reuse registered buffers, we don't need a
>> new mechanism that needs to be propagated to all request types.
>> And registered buffer are already optimised for I/O in a bunch
>> of ways. And as a bonus, it'll be similar to the zero-copy
>> internally registered buffers if you still plan to add them.
>>
>> The simplest way to do that is to create a registered buffer out
>> of the mmap'ed region pointer. Pseudo code:
>>
>> // mmap'ed if it's kernel allocated.
>> {region_ptr, region_size} = create_region();
>>
>> struct iovec iov;
>> iov.iov_base = region_ptr;
>> iov.iov_len = region_size;
>> io_uring_register_buffers(ring, &iov, 1);
>>
>> // later instead of this:
>> ptr = region_ptr + off;
>> io_uring_prep_read(sqe, fd, ptr, ...);
>>
>> // you use registered buffers as usual:
>> io_uring_prep_read_fixed(sqe, fd, off, regbuf_idx, ...);
>>
> 
> I feel like this design makes the interface more convoluted and now
> muddies different concepts together by adding new complexity /
> relationships between them whereas they were otherwise cleanly
> isolated. Maybe I'm just not seeing/understanding the overarching
> vision for why conceptually it makes sense for them to be tied
> together besides as a mechanism to tell io-uring requests where to
> copy from by reusing what exists for fixed buffer ids. There's more
> complexity now on the kernel side (eg having to detect if the buffer
> passed in is kernel-allocated to know whether to pin the pages /
> charge it against the user's RLIMIT_MEMLOCK limit) but I'm not
> understanding what we gain from it.

That would avoid doing a large revamp of uapi and plumbing it
to each every request type when there is already a uapi that does
what you want, does it well and have lots of things figured out.
Keeping the I/O path sane is important, io_uring already has 3
different ways of passing buffers, let's not add a 4th one
unless it achieves something meaningful.

> I got the sense from your previous
> comments that memory regions are the de facto way to go and should be

Sorry, maybe I wasn't clear. With what I see you're trying to do,
i.e. copying client's data into user space (server), I think
registered buffers would be a better abstraction. However, I just
went with your design on top of regions, since it's not the first
iteration of the series and I wasn't following previous ones, and
IIRC you was already using registered buffers in previous revisions
but moved from that for some reason. IOW, I was taking you main I/O
path and was trying to make the setup path a bit more flexible and
reusable.

> decoupled from other structures, so if that's the case, why doesn't it
> make sense for io-uring to add native support for using memory regions
> for io-uring requests? I feel like from the userspace side it makes
> things more confusing with this extra layer of indirection that now
> has to go through a fixed buffer.

There is a high bar for adding a new interface for passing buffers
that needs to be propagated to a good number of request handlers,
and there is already one that gives you all you need to write
efficient user space.

>> IIRC the registration would fail because it doesn't allow file
>> backed pages, but it should be fine if we know it's io_uring
>> region memory, so that would need to be patched.
>>
>> There might be a bunch of other ways you can do that like
>> create a kernel allocated registered buffer like what Cristoph
>> wants, and then register it as a region. Or allow creating
>> registered buffers out of a region. etc.
>>
>> I wanted to unify registered buffers and regions internally
>> at some point, but then drifted away from active io_uring core
>> infrastructure development, so I guess that could've been useful.
>>
>>> Right now there's only a uapi to register a memory region and none to
>>> unregister one. Is it guaranteed that io-uring will never add
>>> something in the future that will let userspace unregister the memory
>>> region or at least unregister it while it's being used (eg if we add
>>> future refcounting to it to track active uses of it)?
>>
>> Let's talk about it when it's needed or something changes, but if
>> you do registered buffers instead as per above, they'll be holding
>> page references and or have to pin the region in some other way.
> 
> I don't think we can guarantee that the caller will register the
> memory region as a fixed buffer (eg if it doesn't need/want to use the
> buffer for normal io-uring requests). On the kernel side, the internal

It's up to the user (i.e. fuse server) to either use OP_READ/etc. using
user addresses that you have in your design from mmap()ing regions, or
registering it and using OP_READ_FIXED.

> buffer entry uses the kaddr of the registered memory region buffer for
> any memcpys. If it's not guaranteed that registered memory regions
> persist for the lifetime of the ring, there'll have to be extra
> overhead for every I/O (eg grab the io-uring lock, checking if the mem
> region is still registered, grab a refcount to that mem region, unlock
> the ring, do the memcpy to the kaddr, then grab the io-uring lock
> again, decrement the refcount, and unlock). Or I guess we could add
> pinning to a registered memory region.



-- 
Pavel Begunkov


