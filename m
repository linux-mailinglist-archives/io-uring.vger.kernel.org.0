Return-Path: <io-uring+bounces-3994-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E64DB9AED83
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 19:16:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 466FEB26086
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BADD11F6697;
	Thu, 24 Oct 2024 17:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ew8bioAM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C7F21364
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 17:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729790196; cv=none; b=ef0k0HpElyhvk1EvzQMtcmHnCRfEuwPO0RrEqHZQoJEfTKFZKF/tp08FVsWwxiO6HUeSVKWtRMJ94QS76tuxgJrEZSsiZdNSoxtrm9HGG61BSoluy43uG+lGsFzqKAbIm8u8ohNrxMeWe8jvQrqtf0ZJ2RJfIvfF/6YUXmX3/M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729790196; c=relaxed/simple;
	bh=3ZTvjZ5dKU/uvSc6VHkjMGF3Ms2D2RgKci6PaNa8pVE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WMnyNk66ptzFIlDds3ZEzASvtYqxhgrsYu6TB5GVerI5bbCYLFNMUWbehzNpGeyveOFpqNHvkgNlFEMWxIfHpa6Z/33z3QW189VvRXDRklLJewP1q4oi4F0YdrzxZVPJT1Ys6Plkpt0MUJBWhHmdFlVYpV1xkU8NT7FpihaDQyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ew8bioAM; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-83aad99d6bfso45261939f.0
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 10:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729790192; x=1730394992; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cf3e/RlL5qnC/wgbZ8T41+WakXjgreyrgbpsIOiYmDI=;
        b=ew8bioAM40t0qaC2Entx1lATky7gME3Mzqp6y2zZN2RtQd/NQXX2hsQWfpw1aJCVd5
         7IvgwuhLAg5KgUgaIfOcHbYNkua4pU4G2LfFxPqsqXxcL3rt9ZjL/CLPkTTUO2gaadP9
         sbwzzwKLZK0BmWYIAkZtbRTH+XObd/SZqDH5bJpJYNfvKddiWcHA1DvDMy2nu5oFczEt
         ZCkx+KPvgwKe+B7TcNUX6xc62QW13EDkKEqrxCq2joVurufrwDhov1dOZZQqjq36HG0d
         lLRjmzJ63zGeONhg/C9kI9hVaxKqoax9MEClFdIbmHY+GkiIkQvzuavwy0DzAIuMSbL7
         Nczg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729790192; x=1730394992;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cf3e/RlL5qnC/wgbZ8T41+WakXjgreyrgbpsIOiYmDI=;
        b=ZBXUhGbQiZ4vB6Wqvt678rExVIPElTD9zytdz6jOYy4GLNz2KWZnv51owAICFkc/+R
         3BP/dkE76FsqAwsWv/ZbYds8gv8ndbKDf34t/OtgrB6pVnKoYFf/3GYxk/l2bzos7ks2
         HA1BRWbHTlPwLn+YXitA57JeK+c5XB6fnV6ppNnCMnVtKvSI8SaYCoqLvQpiFEzrIJhu
         Q8YrlxI/NnYld8jTRAhpFGrwheMxsGajK3jVj2SdzJCv9jxaHnmlugwaDFhOafaRUDQQ
         km5W7V0Mrn68kJ2qicsIiEhSXyoNHVGhlUllar1rJ8JSs4eRJSQaUeKkzhco+s3rbVPH
         mwtA==
X-Forwarded-Encrypted: i=1; AJvYcCUguooDQuYR+OOkj4gUdOgfjXGqDM4MOi9UD1y9UATwvIyOQjERsdIfu/OSzQZkhAAGl21lFVduQA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzAWUOML/S8OVEfVPWsitymJRHwVZ57v/avmWZBZxZSFJQCFn6j
	hkbkOWA9gQG+qP28JqX1raLHYObqI54P3+CqqMgSwCZi+cdGg2sHIysPL9aR+SM=
X-Google-Smtp-Source: AGHT+IFm388cd91KAwSMjd8glHo9ggW3zUPwt9oE84yfDF6Ii5gIAwJfqqlsB+CiSALRwaegv4SdFA==
X-Received: by 2002:a05:6602:2b0c:b0:83a:b188:7a4d with SMTP id ca18e2360f4ac-83af605d1a2mr948960739f.0.1729790191818;
        Thu, 24 Oct 2024 10:16:31 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a661c23sm2731603173.178.2024.10.24.10.16.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 10:16:31 -0700 (PDT)
Message-ID: <2be64142-0d6d-4018-b99b-343350a5fb08@kernel.dk>
Date: Thu, 24 Oct 2024 11:16:30 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c51938c8-8bb4-44d1-8394-14aeebd58ba2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 10:17 AM, Pavel Begunkov wrote:
> On 10/24/24 16:57, Jens Axboe wrote:
>> On 10/24/24 9:44 AM, Pavel Begunkov wrote:
>>> On 10/23/24 17:07, Jens Axboe wrote:
>>>> This just adds the necessary shifts that define what a provided buffer
>>>> that is merely an index into a registered buffer looks like. A provided
>>>> buffer looks like the following:
>>>>
>>>> struct io_uring_buf {
>>>>      __u64    addr;
>>>>      __u32    len;
>>>>      __u16    bid;
>>>>      __u16    resv;
>>>> };
>>>>
>>>> where 'addr' holds a userspace address, 'len' is the length of the
>>>> buffer, and 'bid' is the buffer ID identifying the buffer. This works
>>>> fine for a virtual address, but it cannot be used efficiently denote
>>>> a registered buffer. Registered buffers are pre-mapped into the kernel
>>>> for more efficient IO, avoiding a get_user_pages() and page(s) inc+dec,
>>>> and are used for things like O_DIRECT on storage and zero copy send.
>>>>
>>>> Particularly for the send case, it'd be useful to support a mix of
>>>> provided and registered buffers. This enables the use of using a
>>>> provided ring buffer to serialize sends, and also enables the use of
>>>> send bundles, where a send can pick multiple buffers and send them all
>>>> at once.
>>>>
>>>> If provided buffers are used as an index into registered buffers, the
>>>> meaning of buf->addr changes. If registered buffer index 'regbuf_index'
>>>> is desired, with a length of 'len' and the offset 'regbuf_offset' from
>>>> the start of the buffer, then the application would fill out the entry
>>>> as follows:
>>>>
>>>> buf->addr = ((__u64) regbuf_offset << IOU_BUF_OFFSET_BITS) | regbuf_index;
>>>> buf->len = len;
>>>>
>>>> and otherwise add it to the buffer ring as usual. The kernel will then
>>>> first pick a buffer from the desired buffer group ID, and then decode
>>>> which registered buffer to use for the transfer.
>>>>
>>>> This provides a way to use both registered and provided buffers at the
>>>> same time.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>    include/uapi/linux/io_uring.h | 8 ++++++++
>>>>    1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>> index 86cb385fe0b5..eef88d570cb4 100644
>>>> --- a/include/uapi/linux/io_uring.h
>>>> +++ b/include/uapi/linux/io_uring.h
>>>> @@ -733,6 +733,14 @@ struct io_uring_buf_ring {
>>>>        };
>>>>    };
>>>>    +/*
>>>> + * When provided buffers are used as indices into registered buffers, the
>>>> + * lower IOU_BUF_REGBUF_BITS indicate the index into the registered buffers,
>>>> + * and the upper IOU_BUF_OFFSET_BITS indicate the offset into that buffer.
>>>> + */
>>>> +#define IOU_BUF_REGBUF_BITS    (32ULL)
>>>> +#define IOU_BUF_OFFSET_BITS    (32ULL)
>>>
>>> 32 bit is fine for IO size but not enough to store offsets, it
>>> can only address under 4GB registered buffers.
>>
>> I did think about that - at least as it stands, registered buffers are
>> limited to 1GB in size. That's how it's been since that got added. Now,
>> for the future, we may obviously lift that limitation, and yeah then
>> 32-bits would not necessarily be enough for the offset.
> 
> Right, and I don't think it's unreasonable considering with how
> much memory systems have nowadays, and we think that one large
> registered buffer is a good thing.

Agree - but at the same time, not a big hardship to chunk up the region
into 8G chunks rather than allow, eg, a 64G region. Would be nice if it
wasn't a requirement, but unsure how to make that work otherwise.

And not a lot of complaints on having 1G be the size, even from the
varnish side where they register hundreds of gigs of memory.

>> For linux, the max read/write value has always been INT_MAX & PAGE_MASK,
>> so we could make do with 31 bits for the size, which would bump the
>> offset to 33-bits, or 8G. That'd leave enough room for, at least, 8G
>> buffers, or 8x what we support now. Which is probably fine, you'd just
>> split your buffer registrations into 8G chunks, if you want to register
>> more than 8G of memory.
> 
> That's why I mentioned IO size, you can register a very large buffer
> and do IO with a small subchunk of it, even if that "small" is 4G,
> but it still needs to be addressed. I think we need at least an order
> of magnitude or two more space for it to last for a bit.
> 
> Can it steal bits from IOU_BUF_REGBUF_BITS?

As mentooned, we can definitely move the one bit, which would bring is
to 31/33, and ~2GB IO size (max in linux) and ~8G of offset. That can be
done without having any tradeoffs. Beyond that, and we're starting to
limit the transfer size, eg it's tradeoff of allowing more offset (and
hence bigger registered regions) vs transfer size. You could probably
argue that 1G would be fine, and hence make it 30/34, which would allow
16GB registered buffers. Just unsure if it's worth it, as neither of
those would allow really huge registered buffers - and does it matter if
your buffer registrations are chunked at 8G vs 16G? Probably not.

-- 
Jens Axboe

