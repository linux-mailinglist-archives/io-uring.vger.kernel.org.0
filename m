Return-Path: <io-uring+bounces-4002-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 353319AEF98
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 20:20:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66195B22038
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 18:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0097200BB2;
	Thu, 24 Oct 2024 18:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kg44IqaQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2C11ABEC5
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 18:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729794003; cv=none; b=PRoQqOqsm1Ou0lbcXIXu3cr/Kp8oDPTd/qPKStYvK/RHASQku21QsF8mqUVni4rBCzQAOvp3u5V5QinEwxPLMW1Qn8Eglrjkba5i1tVihSU6yRAP1u3qU/vvjhnvU+15m43vdiLRPskdhwGCmHgbc+wn1z6D6aMiS5DFMhkHgns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729794003; c=relaxed/simple;
	bh=nT8BktKFhfvm8+i7iI3OD+hlEQPRNJNrAT/ThuwypNU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SN/RECEMSrhwfnEt/DucedPkXqcTckSPzGfmBaQOOWE1LYYR8cnyMrq18WPgat18etuLKabZpH5tsqP86B7mjpvrszL40TtfHE/SK/ymV5wEyAjqRPE8U+Q5KfDsp/BKt2I/ObEVWAkG7h2MM0BI9smxDy6yPGobWxbbpqrKdDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kg44IqaQ; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-37d495d217bso1066919f8f.0
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 11:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793999; x=1730398799; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d1MxSJ5w6e6jXUVZQx/UiqPbvQnqkeZAXVeVzoahGaY=;
        b=Kg44IqaQ8araepi5rNLMtaQd02XYWIniPBvd93PQ1pYvhq7DxhUc9CGthOSTWMk9+o
         1qHPmRTH84WzJ72/NFdfrSDdI98KOF/CH5xVfkpoaUvv0he0fyGJ7RAHkIcB+2cLkqwM
         nrREpXdkTYJ1twDTbwHgfrCH6+zl6QP0Z1DA2dsqpJBAbrt6RsgKMlkHWwehs+HMu0sH
         7QZoYXUwVKUhNeFBjHo9EGkpgPlLM+LTbUKn/aUVgUeA3OAY8kPejxxjVcVOd2IppXOK
         9qClrX1wUMpMzxNXVRoqcFi13BSd91WjMYHolSNcBp61sUHnInKw/Lnp6epOSfJWmtl3
         uCVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793999; x=1730398799;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d1MxSJ5w6e6jXUVZQx/UiqPbvQnqkeZAXVeVzoahGaY=;
        b=fdvKig7OHsF/svB0h5p0BJ3MdoKJNccZkFfetnJZVgi73AnNfPN8QR2YoP9BmFPu2P
         /wa9CntvwPFwt347Z/LZOkAst3I+lXSHCcZBdF2AtjPZd1HKjbqNpq9rQ66TOpdtlfLE
         TxcVZn1ApVU8tT22q+SlQmEgCNgMFWAam7d3rGQbqyYvBuZb7FbAs2vVOiXlc1B9b1eQ
         tbaPGIU+WXwaACmt+ZRRzG/m6yj7OaPFGn1CGoOwe65ymWh2BjDgkQHf8DAF0BUvVUvw
         tdyhE4Gx94qnJFb2Z73HKW3ZkGo5kGL8u2PMTB7yPgeYtHeRvVKAWeu118/v7ETuhSwI
         Et8w==
X-Forwarded-Encrypted: i=1; AJvYcCXkkIqmb44oFTqo5ZVv6dIkp0szQJ5L6jMbp7VjLYlHjRaKaxjnuIfm4Djv+6yW+BzzfxP+y2DNTQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhR72S4Vlpr8X/iTs6JQuLFDgwL6CROjsVgeks5PQwKsL3kF1j
	wkwFCl2/SJiGUuixFmI1K9HHEJOwXkG0/HkQpl7dszUn7MScKbB7BSImDQ==
X-Google-Smtp-Source: AGHT+IEAqIRPzNmN3ShwVsxShEr5aJXanJzgF9A1H+hLN2YPezWDE1PzpgHUJX0g8z92zPcRgTdMlg==
X-Received: by 2002:a05:6000:178e:b0:37e:f4a1:2b58 with SMTP id ffacd0b85a97d-37efcf0605cmr7302167f8f.16.1729793999163;
        Thu, 24 Oct 2024 11:19:59 -0700 (PDT)
Received: from [192.168.8.113] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a9157221asm646311366b.161.2024.10.24.11.19.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 11:19:58 -0700 (PDT)
Message-ID: <a572428b-2f31-4a3e-975c-8595fbea7e54@gmail.com>
Date: Thu, 24 Oct 2024 19:20:33 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] io_uring: add ability for provided buffer to index
 registered buffers
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20241023161522.1126423-1-axboe@kernel.dk>
 <20241023161522.1126423-6-axboe@kernel.dk>
 <34d4cfb3-e605-4d37-b104-03b8b1a892f1@gmail.com>
 <c44ef9b3-bea7-45f5-b050-9c74ff1e0344@kernel.dk>
 <c51938c8-8bb4-44d1-8394-14aeebd58ba2@gmail.com>
 <2be64142-0d6d-4018-b99b-343350a5fb08@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2be64142-0d6d-4018-b99b-343350a5fb08@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 18:16, Jens Axboe wrote:
> On 10/24/24 10:17 AM, Pavel Begunkov wrote:
>> On 10/24/24 16:57, Jens Axboe wrote:
>>> On 10/24/24 9:44 AM, Pavel Begunkov wrote:
>>>> On 10/23/24 17:07, Jens Axboe wrote:
>>>>> This just adds the necessary shifts that define what a provided buffer
>>>>> that is merely an index into a registered buffer looks like. A provided
>>>>> buffer looks like the following:
>>>>>
>>>>> struct io_uring_buf {
>>>>>       __u64    addr;
>>>>>       __u32    len;
>>>>>       __u16    bid;
>>>>>       __u16    resv;
>>>>> };
>>>>>
>>>>> where 'addr' holds a userspace address, 'len' is the length of the
>>>>> buffer, and 'bid' is the buffer ID identifying the buffer. This works
>>>>> fine for a virtual address, but it cannot be used efficiently denote
>>>>> a registered buffer. Registered buffers are pre-mapped into the kernel
>>>>> for more efficient IO, avoiding a get_user_pages() and page(s) inc+dec,
>>>>> and are used for things like O_DIRECT on storage and zero copy send.
>>>>>
>>>>> Particularly for the send case, it'd be useful to support a mix of
>>>>> provided and registered buffers. This enables the use of using a
>>>>> provided ring buffer to serialize sends, and also enables the use of
>>>>> send bundles, where a send can pick multiple buffers and send them all
>>>>> at once.
>>>>>
>>>>> If provided buffers are used as an index into registered buffers, the
>>>>> meaning of buf->addr changes. If registered buffer index 'regbuf_index'
>>>>> is desired, with a length of 'len' and the offset 'regbuf_offset' from
>>>>> the start of the buffer, then the application would fill out the entry
>>>>> as follows:
>>>>>
>>>>> buf->addr = ((__u64) regbuf_offset << IOU_BUF_OFFSET_BITS) | regbuf_index;
>>>>> buf->len = len;
>>>>>
>>>>> and otherwise add it to the buffer ring as usual. The kernel will then
>>>>> first pick a buffer from the desired buffer group ID, and then decode
>>>>> which registered buffer to use for the transfer.
>>>>>
>>>>> This provides a way to use both registered and provided buffers at the
>>>>> same time.
>>>>>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>> ---
>>>>>     include/uapi/linux/io_uring.h | 8 ++++++++
>>>>>     1 file changed, 8 insertions(+)
>>>>>
>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>>> index 86cb385fe0b5..eef88d570cb4 100644
>>>>> --- a/include/uapi/linux/io_uring.h
>>>>> +++ b/include/uapi/linux/io_uring.h
>>>>> @@ -733,6 +733,14 @@ struct io_uring_buf_ring {
>>>>>         };
>>>>>     };
>>>>>     +/*
>>>>> + * When provided buffers are used as indices into registered buffers, the
>>>>> + * lower IOU_BUF_REGBUF_BITS indicate the index into the registered buffers,
>>>>> + * and the upper IOU_BUF_OFFSET_BITS indicate the offset into that buffer.
>>>>> + */
>>>>> +#define IOU_BUF_REGBUF_BITS    (32ULL)
>>>>> +#define IOU_BUF_OFFSET_BITS    (32ULL)
>>>>
>>>> 32 bit is fine for IO size but not enough to store offsets, it
>>>> can only address under 4GB registered buffers.
>>>
>>> I did think about that - at least as it stands, registered buffers are
>>> limited to 1GB in size. That's how it's been since that got added. Now,
>>> for the future, we may obviously lift that limitation, and yeah then
>>> 32-bits would not necessarily be enough for the offset.
>>
>> Right, and I don't think it's unreasonable considering with how
>> much memory systems have nowadays, and we think that one large
>> registered buffer is a good thing.
> 
> Agree - but at the same time, not a big hardship to chunk up the region
> into 8G chunks rather than allow, eg, a 64G region. Would be nice if it
> wasn't a requirement, but unsure how to make that work otherwise.
> 
> And not a lot of complaints on having 1G be the size, even from the
> varnish side where they register hundreds of gigs of memory.
> 
>>> For linux, the max read/write value has always been INT_MAX & PAGE_MASK,
>>> so we could make do with 31 bits for the size, which would bump the
>>> offset to 33-bits, or 8G. That'd leave enough room for, at least, 8G
>>> buffers, or 8x what we support now. Which is probably fine, you'd just
>>> split your buffer registrations into 8G chunks, if you want to register
>>> more than 8G of memory.
>>
>> That's why I mentioned IO size, you can register a very large buffer
>> and do IO with a small subchunk of it, even if that "small" is 4G,
>> but it still needs to be addressed. I think we need at least an order
>> of magnitude or two more space for it to last for a bit.
>>
>> Can it steal bits from IOU_BUF_REGBUF_BITS?
> 
> As mentooned, we can definitely move the one bit, which would bring is
> to 31/33, and ~2GB IO size (max in linux) and ~8G of offset. That can be
> done without having any tradeoffs. Beyond that, and we're starting to
> limit the transfer size, eg it's tradeoff of allowing more offset (and
> hence bigger registered regions) vs transfer size. You could probably
> argue that 1G would be fine, and hence make it 30/34, which would allow
> 16GB registered buffers. Just unsure if it's worth it, as neither of
> those would allow really huge registered buffers - and does it matter if
> your buffer registrations are chunked at 8G vs 16G? Probably not.

6/7 packs offset and the reg buffer index into the same u64,
not the len. I'm don't see how it affects the len

idx = addr & ((1ULL << IOU_BUF_REGBUF_BITS) - 1);
addr >>= IOU_BUF_REGBUF_BITS;
*offset = addr  & ((1ULL << IOU_BUF_OFFSET_BITS) - 1);

So the tradeoff is with the max size of the registered
buffer table. I doubt you need 2^32, if each is at least
4KB, it's at least 16TB.

-- 
Pavel Begunkov

