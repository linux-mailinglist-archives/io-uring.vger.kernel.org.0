Return-Path: <io-uring+bounces-4005-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D6A939AF2FA
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 21:53:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96094283FDD
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 19:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B266219B3FF;
	Thu, 24 Oct 2024 19:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XGHDycWz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DD318BB88
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 19:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729799625; cv=none; b=jJ88N6jNQkdh2t/KGr8tWIdUNGJX0WiC7Qz8baGt0Q1dAe44AbqCJ+bOlgf0ilbs/6V+cuEdiC4aZDYxhCLiXQzSYpsTjqxrdY5hChJ6AnXgQiVn+bYiA1Unof7tlXorwLN5o9WyG2nNk2lxm9B5mF0Rc14S3jqASqtUxnK+iLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729799625; c=relaxed/simple;
	bh=SUgUl1RsT9f1K6J0KN4p6F828fvQ3evEy29jRtA9HRI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uCDU/PCcyHj+3aFYf+BD3MgSp9Yka5lUoV0LnvtGBcWTXcstcHsTBLa6CcY7ddZ5NNsT0Ue2tWYFC4ZF0/XXaGWv7BgnrPeCGDH5sLn5SLKRwMCtxGMRGGCNIPrkfqr3mlPgYKHc8bw4dqK4TFVy8nj97wncoBQXXUSQlI9l3kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XGHDycWz; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-8323b555a6aso65804239f.3
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 12:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729799621; x=1730404421; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eXyo2wMBhlaeP10UhS8tNCg+csGEJm4Y3vrhkFzJyZY=;
        b=XGHDycWzg2WBCjg9C8pZsnj5Ab+IJ8l0jNiE8K9no+2uPKCy+Upi75AN4NXNVTE7mi
         1sQtVF1jNlbtqvK1RVGF5C0Gt8auxN71CmrHFG7EnhQizCuF+23L1pl5sKCOcKYFH7CF
         Pnxs8pGp7X4eTq4wBIJixixYBnr08+Yzr23NGW1O6RD6iHtuAdudO3bSaijUyLhsQOe1
         hPuahNMXTP/HdHAs2IWW2eIQhTS7wiZwQMAJ2bd6UDPeu6cv4YiCQMGV++5APhuWYxMC
         IZ0dkEoF8jVgnSip2/Qnktv3MZsH0WI96nWjdeO4XnTvUT8a2RO3vwrwjCxEl7dXrzcH
         BtZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729799621; x=1730404421;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eXyo2wMBhlaeP10UhS8tNCg+csGEJm4Y3vrhkFzJyZY=;
        b=qthQlhe6Bo2m+bv5nV0mu4CrL06XdALqUImrCLsScb2udVReYH7S2Q+5lrl9h/nD2H
         Ns2EnZaJ9+SbP8hbTFN+HZeq8M/VosKm3fIL8tc5xhCat56fF6Ho1QJTbKlPHubB8Su+
         xBhJEWKzLTwFuo2IwEV2/TskIcDtMOE8JvTE7n/j+U1ZT9/JjcOaSRGYPCl4P5Qiqiwc
         9yTnwRPreD5iYwDDIWvTzMBtVMs4TuWMGLSdYOLMqjy5jn+AOJ9VGlAX2csR86r4y8yO
         aTAsTfuL74VmktPOeq/LO5oDR4FqthCn7fK10eHzk+XNLOW7jDTOHimzVMuEqHh8Qcxf
         vsMg==
X-Forwarded-Encrypted: i=1; AJvYcCXO04xGmYdiQnan5k2H1o18AWTNbutlozcaITBydgmc3kth5yo+PJkIw6Ma5Qi8FMeN47USXfXYUQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywcj0tcdkmo2IbU+QpLjoeg+tI9uhlpw+4Z7N8arxVwCz7FLqKT
	wl9fpB7ujj2pHbHU1d/r0AXAscIlnbSbsezz2J4L5k2axR0JlgdHrWjiOzcI68w=
X-Google-Smtp-Source: AGHT+IFWVBiGARlifFdFl5G7zjktsN01grknII/t0AMUPXkRFMVMuDWQ/XyreKKFSl7laHfRGfP2ww==
X-Received: by 2002:a05:6e02:19cc:b0:3a3:afa3:5155 with SMTP id e9e14a558f8ab-3a4d59fcc8dmr77723415ab.25.1729799621332;
        Thu, 24 Oct 2024 12:53:41 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a55978esm2769908173.71.2024.10.24.12.53.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 12:53:40 -0700 (PDT)
Message-ID: <b80b7ac2-9eb1-447f-b202-e64d26943796@kernel.dk>
Date: Thu, 24 Oct 2024 13:53:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] io_uring: add ability for provided buffer to index
 registered buffers
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20241023161522.1126423-1-axboe@kernel.dk>
 <20241023161522.1126423-6-axboe@kernel.dk>
 <34d4cfb3-e605-4d37-b104-03b8b1a892f1@gmail.com>
 <c44ef9b3-bea7-45f5-b050-9c74ff1e0344@kernel.dk>
 <c51938c8-8bb4-44d1-8394-14aeebd58ba2@gmail.com>
 <2be64142-0d6d-4018-b99b-343350a5fb08@kernel.dk>
 <a572428b-2f31-4a3e-975c-8595fbea7e54@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a572428b-2f31-4a3e-975c-8595fbea7e54@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 12:20 PM, Pavel Begunkov wrote:
> On 10/24/24 18:16, Jens Axboe wrote:
>> On 10/24/24 10:17 AM, Pavel Begunkov wrote:
>>> On 10/24/24 16:57, Jens Axboe wrote:
>>>> On 10/24/24 9:44 AM, Pavel Begunkov wrote:
>>>>> On 10/23/24 17:07, Jens Axboe wrote:
>>>>>> This just adds the necessary shifts that define what a provided buffer
>>>>>> that is merely an index into a registered buffer looks like. A provided
>>>>>> buffer looks like the following:
>>>>>>
>>>>>> struct io_uring_buf {
>>>>>>       __u64    addr;
>>>>>>       __u32    len;
>>>>>>       __u16    bid;
>>>>>>       __u16    resv;
>>>>>> };
>>>>>>
>>>>>> where 'addr' holds a userspace address, 'len' is the length of the
>>>>>> buffer, and 'bid' is the buffer ID identifying the buffer. This works
>>>>>> fine for a virtual address, but it cannot be used efficiently denote
>>>>>> a registered buffer. Registered buffers are pre-mapped into the kernel
>>>>>> for more efficient IO, avoiding a get_user_pages() and page(s) inc+dec,
>>>>>> and are used for things like O_DIRECT on storage and zero copy send.
>>>>>>
>>>>>> Particularly for the send case, it'd be useful to support a mix of
>>>>>> provided and registered buffers. This enables the use of using a
>>>>>> provided ring buffer to serialize sends, and also enables the use of
>>>>>> send bundles, where a send can pick multiple buffers and send them all
>>>>>> at once.
>>>>>>
>>>>>> If provided buffers are used as an index into registered buffers, the
>>>>>> meaning of buf->addr changes. If registered buffer index 'regbuf_index'
>>>>>> is desired, with a length of 'len' and the offset 'regbuf_offset' from
>>>>>> the start of the buffer, then the application would fill out the entry
>>>>>> as follows:
>>>>>>
>>>>>> buf->addr = ((__u64) regbuf_offset << IOU_BUF_OFFSET_BITS) | regbuf_index;
>>>>>> buf->len = len;
>>>>>>
>>>>>> and otherwise add it to the buffer ring as usual. The kernel will then
>>>>>> first pick a buffer from the desired buffer group ID, and then decode
>>>>>> which registered buffer to use for the transfer.
>>>>>>
>>>>>> This provides a way to use both registered and provided buffers at the
>>>>>> same time.
>>>>>>
>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>> ---
>>>>>>     include/uapi/linux/io_uring.h | 8 ++++++++
>>>>>>     1 file changed, 8 insertions(+)
>>>>>>
>>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>>>> index 86cb385fe0b5..eef88d570cb4 100644
>>>>>> --- a/include/uapi/linux/io_uring.h
>>>>>> +++ b/include/uapi/linux/io_uring.h
>>>>>> @@ -733,6 +733,14 @@ struct io_uring_buf_ring {
>>>>>>         };
>>>>>>     };
>>>>>>     +/*
>>>>>> + * When provided buffers are used as indices into registered buffers, the
>>>>>> + * lower IOU_BUF_REGBUF_BITS indicate the index into the registered buffers,
>>>>>> + * and the upper IOU_BUF_OFFSET_BITS indicate the offset into that buffer.
>>>>>> + */
>>>>>> +#define IOU_BUF_REGBUF_BITS    (32ULL)
>>>>>> +#define IOU_BUF_OFFSET_BITS    (32ULL)
>>>>>
>>>>> 32 bit is fine for IO size but not enough to store offsets, it
>>>>> can only address under 4GB registered buffers.
>>>>
>>>> I did think about that - at least as it stands, registered buffers are
>>>> limited to 1GB in size. That's how it's been since that got added. Now,
>>>> for the future, we may obviously lift that limitation, and yeah then
>>>> 32-bits would not necessarily be enough for the offset.
>>>
>>> Right, and I don't think it's unreasonable considering with how
>>> much memory systems have nowadays, and we think that one large
>>> registered buffer is a good thing.
>>
>> Agree - but at the same time, not a big hardship to chunk up the region
>> into 8G chunks rather than allow, eg, a 64G region. Would be nice if it
>> wasn't a requirement, but unsure how to make that work otherwise.
>>
>> And not a lot of complaints on having 1G be the size, even from the
>> varnish side where they register hundreds of gigs of memory.
>>
>>>> For linux, the max read/write value has always been INT_MAX & PAGE_MASK,
>>>> so we could make do with 31 bits for the size, which would bump the
>>>> offset to 33-bits, or 8G. That'd leave enough room for, at least, 8G
>>>> buffers, or 8x what we support now. Which is probably fine, you'd just
>>>> split your buffer registrations into 8G chunks, if you want to register
>>>> more than 8G of memory.
>>>
>>> That's why I mentioned IO size, you can register a very large buffer
>>> and do IO with a small subchunk of it, even if that "small" is 4G,
>>> but it still needs to be addressed. I think we need at least an order
>>> of magnitude or two more space for it to last for a bit.
>>>
>>> Can it steal bits from IOU_BUF_REGBUF_BITS?
>>
>> As mentooned, we can definitely move the one bit, which would bring is
>> to 31/33, and ~2GB IO size (max in linux) and ~8G of offset. That can be
>> done without having any tradeoffs. Beyond that, and we're starting to
>> limit the transfer size, eg it's tradeoff of allowing more offset (and
>> hence bigger registered regions) vs transfer size. You could probably
>> argue that 1G would be fine, and hence make it 30/34, which would allow
>> 16GB registered buffers. Just unsure if it's worth it, as neither of
>> those would allow really huge registered buffers - and does it matter if
>> your buffer registrations are chunked at 8G vs 16G? Probably not.
> 
> 6/7 packs offset and the reg buffer index into the same u64,
> not the len. I'm don't see how it affects the len
> 
> idx = addr & ((1ULL << IOU_BUF_REGBUF_BITS) - 1);
> addr >>= IOU_BUF_REGBUF_BITS;
> *offset = addr  & ((1ULL << IOU_BUF_OFFSET_BITS) - 1);
> 
> So the tradeoff is with the max size of the registered
> buffer table. I doubt you need 2^32, if each is at least
> 4KB, it's at least 16TB.

Ah yes, nevermind, the len is of course separate. Yes indeed that falls
out nicely then, we can just reserve eg 16 bits for registered buffers.
And that leaves 48 bits for the offset, which would hold more than
enough. Even at that and 8G max buffer size, that'd be half a TB of
buffer space. And there's no reason we can't just increase the
registered buffer size on 64-bit to much beyond that. Maybe play it safe
and set aside 20 bits for the buffer index, and that leaves 44 bits for
the registered buffer space? Or 16TB of registered buffer space.

What do you think?

-- 
Jens Axboe

