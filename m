Return-Path: <io-uring+bounces-4016-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F3AD9AF58C
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 00:46:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAF141C20FA0
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 22:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AD4216BE01;
	Thu, 24 Oct 2024 22:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P00PUH8t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEDC22B66B
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 22:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729809975; cv=none; b=kVx0+Ih6ucJXNw4KKrfBCkc7WiY7WrzOltZz4x7/drSnb8/AqmAxTLeLNytQOtd0BiWBwUbMyy9YOUjaEsJPZolXZCmmmmcOrQ1xVHd8hUCrRdyoXJZnzeIhawBHUdYSmgtxKpMtad8M3leTVeiBofXUkzYRX+5FTa5jyFHx2t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729809975; c=relaxed/simple;
	bh=osbmgb+7YRC2EAixJm9r1/GjulXGIciWUHzOVrRdZ0o=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=ncXVizId6tfP7eAMBcz36V00dfj9+jvKE3l9By/K6XJBM9Fhw/CjHoaWSRjRU1cItOeWSuZPeYAnDQTl2A1LvR66D1INJ1WfZH8x/HxzNbzHf8Gt0JZY4RI4330o+Ymvt89Fi0Ni19b1sK5qZaQzBuV09ddP+4KRTj3CyydxgdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=P00PUH8t; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2e3d523a24dso1115487a91.0
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 15:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729809968; x=1730414768; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4+eyEWUU+3F5sEP0E+iVpHKtJ/1db5oqR3B1qYsniPg=;
        b=P00PUH8tSbdo77RnAEJI5NTbzzqT+XqfFSYcFRhhEOE5pgCzyUweyKnuIqfXuJlWAD
         GSeVdOG8UgEuJ3u8BgbD2XzLWEV6C9VBnSNd4Ng4ky9Ovoj5CIH3fz285MMen1hTY/SZ
         S/yU+bNtA1CYih601G0ehNRBT4oLBBENzfqwhkYlsG5KU6MKFj7DAyBdWePYkSzlKYza
         66jNLDBSK63lvKlteQ619Ic2FczvGWjHVafFX6Bd7hAVyWYViGw6dfkFhQAgOt1Qgu59
         1qJZVZegS5S4P8ukUNd1lpm1pBsDzWZowpNUke7lMyRdlmRHfWqET2m28DgjIqlwzUJ2
         jmMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729809968; x=1730414768;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4+eyEWUU+3F5sEP0E+iVpHKtJ/1db5oqR3B1qYsniPg=;
        b=QCUu3jzitpnNzdEOaTlDnWjL1C0qzBkmXn5923J5VbdJ0/1eR84CwIJq//C+/cij2q
         Acew6D+FrvOB1fa1HYWAsQ4H9wLKE7xrud1FYtKM1hlS7qRl4+UA+K1bThgw2CcOBSQd
         ZxqwjPA7DYM11OhX6Pusd16x8fPEWJ/L7N0r2usBT4fAHQlxF1ltNoxvdiRm+vsJxbjc
         kbc9XCwJpqhy95aDM7TWNddfz9pkjDJN9jMV6KxAYil4VjSPENpOB1iCezm+VhLRlYgD
         jD2PhFJ0Vw+00l4Cpzry260wL6zII/xA4kf/1QoGNr8Xh/8gpRdlGoCau4MtWtLC4VDH
         V0fw==
X-Forwarded-Encrypted: i=1; AJvYcCU7papkPk3ttEmxCAhgDPvNOT1adbQQScRAT//W2oDkcj0ByO9Ua7oT7mp6r7kH6HwCXzhxRfbLqg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLEiXCAY06U5Ixrdi39aZFR1DsP/hCLv3oxgZd4gxAsQ1c0/nM
	LgtLHLA+4LRb6ABUgb6pQeDX9z8kErN1PlyPgWBtk0rgK5tO7WTogUPp6Ft93vVitE5GrhDzTm8
	h
X-Google-Smtp-Source: AGHT+IGEjJbSyv7AvGR8cuHnriq5FXnIJU5oEPAlsP7GdGWpe2v9qGBARCnfH3dmJQAz/kAE8cHgNg==
X-Received: by 2002:a17:90a:eb01:b0:2e2:bd4b:ac2c with SMTP id 98e67ed59e1d1-2e77f710c0fmr3970642a91.31.1729809967708;
        Thu, 24 Oct 2024 15:46:07 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e77e4c7076sm2057581a91.16.2024.10.24.15.46.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 15:46:07 -0700 (PDT)
Message-ID: <cbc25021-89bd-49cc-8beb-ddd832640eba@kernel.dk>
Date: Thu, 24 Oct 2024 16:46:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] io_uring: add ability for provided buffer to index
 registered buffers
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20241023161522.1126423-1-axboe@kernel.dk>
 <20241023161522.1126423-6-axboe@kernel.dk>
 <34d4cfb3-e605-4d37-b104-03b8b1a892f1@gmail.com>
 <c44ef9b3-bea7-45f5-b050-9c74ff1e0344@kernel.dk>
 <c51938c8-8bb4-44d1-8394-14aeebd58ba2@gmail.com>
 <2be64142-0d6d-4018-b99b-343350a5fb08@kernel.dk>
 <a572428b-2f31-4a3e-975c-8595fbea7e54@gmail.com>
 <b80b7ac2-9eb1-447f-b202-e64d26943796@kernel.dk>
Content-Language: en-US
In-Reply-To: <b80b7ac2-9eb1-447f-b202-e64d26943796@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 1:53 PM, Jens Axboe wrote:
> On 10/24/24 12:20 PM, Pavel Begunkov wrote:
>> On 10/24/24 18:16, Jens Axboe wrote:
>>> On 10/24/24 10:17 AM, Pavel Begunkov wrote:
>>>> On 10/24/24 16:57, Jens Axboe wrote:
>>>>> On 10/24/24 9:44 AM, Pavel Begunkov wrote:
>>>>>> On 10/23/24 17:07, Jens Axboe wrote:
>>>>>>> This just adds the necessary shifts that define what a provided buffer
>>>>>>> that is merely an index into a registered buffer looks like. A provided
>>>>>>> buffer looks like the following:
>>>>>>>
>>>>>>> struct io_uring_buf {
>>>>>>>       __u64    addr;
>>>>>>>       __u32    len;
>>>>>>>       __u16    bid;
>>>>>>>       __u16    resv;
>>>>>>> };
>>>>>>>
>>>>>>> where 'addr' holds a userspace address, 'len' is the length of the
>>>>>>> buffer, and 'bid' is the buffer ID identifying the buffer. This works
>>>>>>> fine for a virtual address, but it cannot be used efficiently denote
>>>>>>> a registered buffer. Registered buffers are pre-mapped into the kernel
>>>>>>> for more efficient IO, avoiding a get_user_pages() and page(s) inc+dec,
>>>>>>> and are used for things like O_DIRECT on storage and zero copy send.
>>>>>>>
>>>>>>> Particularly for the send case, it'd be useful to support a mix of
>>>>>>> provided and registered buffers. This enables the use of using a
>>>>>>> provided ring buffer to serialize sends, and also enables the use of
>>>>>>> send bundles, where a send can pick multiple buffers and send them all
>>>>>>> at once.
>>>>>>>
>>>>>>> If provided buffers are used as an index into registered buffers, the
>>>>>>> meaning of buf->addr changes. If registered buffer index 'regbuf_index'
>>>>>>> is desired, with a length of 'len' and the offset 'regbuf_offset' from
>>>>>>> the start of the buffer, then the application would fill out the entry
>>>>>>> as follows:
>>>>>>>
>>>>>>> buf->addr = ((__u64) regbuf_offset << IOU_BUF_OFFSET_BITS) | regbuf_index;
>>>>>>> buf->len = len;
>>>>>>>
>>>>>>> and otherwise add it to the buffer ring as usual. The kernel will then
>>>>>>> first pick a buffer from the desired buffer group ID, and then decode
>>>>>>> which registered buffer to use for the transfer.
>>>>>>>
>>>>>>> This provides a way to use both registered and provided buffers at the
>>>>>>> same time.
>>>>>>>
>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>> ---
>>>>>>>     include/uapi/linux/io_uring.h | 8 ++++++++
>>>>>>>     1 file changed, 8 insertions(+)
>>>>>>>
>>>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>>>>> index 86cb385fe0b5..eef88d570cb4 100644
>>>>>>> --- a/include/uapi/linux/io_uring.h
>>>>>>> +++ b/include/uapi/linux/io_uring.h
>>>>>>> @@ -733,6 +733,14 @@ struct io_uring_buf_ring {
>>>>>>>         };
>>>>>>>     };
>>>>>>>     +/*
>>>>>>> + * When provided buffers are used as indices into registered buffers, the
>>>>>>> + * lower IOU_BUF_REGBUF_BITS indicate the index into the registered buffers,
>>>>>>> + * and the upper IOU_BUF_OFFSET_BITS indicate the offset into that buffer.
>>>>>>> + */
>>>>>>> +#define IOU_BUF_REGBUF_BITS    (32ULL)
>>>>>>> +#define IOU_BUF_OFFSET_BITS    (32ULL)
>>>>>>
>>>>>> 32 bit is fine for IO size but not enough to store offsets, it
>>>>>> can only address under 4GB registered buffers.
>>>>>
>>>>> I did think about that - at least as it stands, registered buffers are
>>>>> limited to 1GB in size. That's how it's been since that got added. Now,
>>>>> for the future, we may obviously lift that limitation, and yeah then
>>>>> 32-bits would not necessarily be enough for the offset.
>>>>
>>>> Right, and I don't think it's unreasonable considering with how
>>>> much memory systems have nowadays, and we think that one large
>>>> registered buffer is a good thing.
>>>
>>> Agree - but at the same time, not a big hardship to chunk up the region
>>> into 8G chunks rather than allow, eg, a 64G region. Would be nice if it
>>> wasn't a requirement, but unsure how to make that work otherwise.
>>>
>>> And not a lot of complaints on having 1G be the size, even from the
>>> varnish side where they register hundreds of gigs of memory.
>>>
>>>>> For linux, the max read/write value has always been INT_MAX & PAGE_MASK,
>>>>> so we could make do with 31 bits for the size, which would bump the
>>>>> offset to 33-bits, or 8G. That'd leave enough room for, at least, 8G
>>>>> buffers, or 8x what we support now. Which is probably fine, you'd just
>>>>> split your buffer registrations into 8G chunks, if you want to register
>>>>> more than 8G of memory.
>>>>
>>>> That's why I mentioned IO size, you can register a very large buffer
>>>> and do IO with a small subchunk of it, even if that "small" is 4G,
>>>> but it still needs to be addressed. I think we need at least an order
>>>> of magnitude or two more space for it to last for a bit.
>>>>
>>>> Can it steal bits from IOU_BUF_REGBUF_BITS?
>>>
>>> As mentooned, we can definitely move the one bit, which would bring is
>>> to 31/33, and ~2GB IO size (max in linux) and ~8G of offset. That can be
>>> done without having any tradeoffs. Beyond that, and we're starting to
>>> limit the transfer size, eg it's tradeoff of allowing more offset (and
>>> hence bigger registered regions) vs transfer size. You could probably
>>> argue that 1G would be fine, and hence make it 30/34, which would allow
>>> 16GB registered buffers. Just unsure if it's worth it, as neither of
>>> those would allow really huge registered buffers - and does it matter if
>>> your buffer registrations are chunked at 8G vs 16G? Probably not.
>>
>> 6/7 packs offset and the reg buffer index into the same u64,
>> not the len. I'm don't see how it affects the len
>>
>> idx = addr & ((1ULL << IOU_BUF_REGBUF_BITS) - 1);
>> addr >>= IOU_BUF_REGBUF_BITS;
>> *offset = addr  & ((1ULL << IOU_BUF_OFFSET_BITS) - 1);
>>
>> So the tradeoff is with the max size of the registered
>> buffer table. I doubt you need 2^32, if each is at least
>> 4KB, it's at least 16TB.
> 
> Ah yes, nevermind, the len is of course separate. Yes indeed that falls
> out nicely then, we can just reserve eg 16 bits for registered buffers.
> And that leaves 48 bits for the offset, which would hold more than
> enough. Even at that and 8G max buffer size, that'd be half a TB of
> buffer space. And there's no reason we can't just increase the
> registered buffer size on 64-bit to much beyond that. Maybe play it safe
> and set aside 20 bits for the buffer index, and that leaves 44 bits for
> the registered buffer space? Or 16TB of registered buffer space.
> 
> What do you think?

I changed it to 20/44 as that seems to be the best split. It allows much
larger registered buffers, and 1M of them. That should be plenty.

Might even make sense to just up the registered buffer size at this
point too as a separate change, there's no reason for it to be limited
to 1G. We can keep 1G on 32-bit as it could only go to to 4G-1 on that
anyway. But for 64-bit, we can bump it higher.

-- 
Jens Axboe

