Return-Path: <io-uring+bounces-3987-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CD779AEBA9
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 18:17:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B4F2284444
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 16:17:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C41FD1F5836;
	Thu, 24 Oct 2024 16:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Br1/8SrJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C9E1B0F16
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 16:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729786626; cv=none; b=opymfFc/GhhDL7vEVBM2Wu7xg4qBpznoX8edMaPy+cm6+EKIerYVq9XFMIrNE7LZ2IwH7I5+TkvtMRe8YtmAiUetx1KP38vK1dBohIidFv2TEIcr5mhDXO/WcaN9iF09r8wTRMZ0c+EEG25NHbq3WH3vgbCnjwbc1fboCyX4at4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729786626; c=relaxed/simple;
	bh=FzLLhX/bdO8LTLZoIoJd8tqp1o1s/Goj+Xv8RYY/sg0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iRQGYd3/x9LGBN2hriCiBCPo94Fa0rP1Rhu3GD8ZksggUWoQoCYSuwn7TsYpXWN7MzdUs4yH4UxMRYxvUePyYdtBmkCK1ENAT6MF5gqBIazdvm5UdjeKyExGBDQNYma13CtmkjdWuM4Ia4PMvTyboOjyGbZKYC/O2sitCqdiRmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Br1/8SrJ; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9a0472306cso143560766b.3
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 09:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729786623; x=1730391423; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sESdBJNwAFwQAyoVVF9TaPMHjhix9BawS5zI5WdyhMI=;
        b=Br1/8SrJNQMm5oP7EUOmDMr8GWgKjHw1uQs/Bmlic1DnlK++ALxLMgWIg58DQfolsr
         ErN+TDycuszEQ/WdSoPbWkp+h2gIUtILYnVNBIoalDj0HZdynqcz+uYtmrONxANpFfbL
         HQum+Fp0R+SHTOROb4DtSQ3P/oaVXB9qeqrWaS0b6YXcuuUZfuEYWIJ7wphnr39pPncJ
         UNNNv/3bXLD5pmgUwfnNHKrZmXPIcgtkpIJr7DaelWJEejZcOR3r0e1BPC+6x81OZimr
         b0x48IdOG3ijRyK4l1srTmNoPuewA/+s7vcVLSyhB3a8VEzL855ejd0a+Gk3DKS6hWYn
         HBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729786623; x=1730391423;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sESdBJNwAFwQAyoVVF9TaPMHjhix9BawS5zI5WdyhMI=;
        b=tJ951Z+2H/WdvWgfnD+KWO6TYvrw4fmio6W4h3LgKXG+TXQ6vrVJt+DLS0RuHRvVu6
         kmw4lTmy/Lh5zlMz/xu3hqm7ZTsz2TvdWPkX1HZw3/kI5qglTCMDU39EWF0Oh3gDc/xB
         UsVs6mKpuPsBhG9CMdnQMcw/SXrS404+sAdAjTAnlIXYagMX/3em+5z/i50G8E5ZWrMz
         xYeUF8M+ZcadOfeOJHSud3GxF7Mhy8cWVB5Uy1xXJf6h+C+MWblIZjS6paN3bAGTmfxE
         6zUiF4xNbAV9BAOT+e5/cjAFiNfWhprsnB2/l3DeSjMH1s/vV3MLmHUNmJtyV80Kf6YM
         SSSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVG4nQN/uVvf0LebEb965G1wLswKj8UBAa+/0lUUemBoTRXXgOdVQH0CDjNKJhQw/DmQCtUNvRhRA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKSk8MvOroA73fAVB8PPAW0U+OZQJDFxnAc/hwnoXORh5wBHNb
	x6JYPztjSDJ9TBqBHv/YdyLZaMaChRk3DFAQdJ3ey0pxGhD5b4ADDsy0kQ==
X-Google-Smtp-Source: AGHT+IGUbkifyIxeiTIBrhUndqKoXISmU7oGAuZY274dJLLT/tdEOrsSg5T8Clusrvr5ngRPJUPj9w==
X-Received: by 2002:a17:906:7309:b0:a99:dde6:9f42 with SMTP id a640c23a62f3a-a9abf96ce04mr691070266b.47.1729786622557;
        Thu, 24 Oct 2024 09:17:02 -0700 (PDT)
Received: from [192.168.42.27] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912d624asm637251466b.30.2024.10.24.09.17.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 09:17:01 -0700 (PDT)
Message-ID: <c51938c8-8bb4-44d1-8394-14aeebd58ba2@gmail.com>
Date: Thu, 24 Oct 2024 17:17:37 +0100
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c44ef9b3-bea7-45f5-b050-9c74ff1e0344@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 16:57, Jens Axboe wrote:
> On 10/24/24 9:44 AM, Pavel Begunkov wrote:
>> On 10/23/24 17:07, Jens Axboe wrote:
>>> This just adds the necessary shifts that define what a provided buffer
>>> that is merely an index into a registered buffer looks like. A provided
>>> buffer looks like the following:
>>>
>>> struct io_uring_buf {
>>>      __u64    addr;
>>>      __u32    len;
>>>      __u16    bid;
>>>      __u16    resv;
>>> };
>>>
>>> where 'addr' holds a userspace address, 'len' is the length of the
>>> buffer, and 'bid' is the buffer ID identifying the buffer. This works
>>> fine for a virtual address, but it cannot be used efficiently denote
>>> a registered buffer. Registered buffers are pre-mapped into the kernel
>>> for more efficient IO, avoiding a get_user_pages() and page(s) inc+dec,
>>> and are used for things like O_DIRECT on storage and zero copy send.
>>>
>>> Particularly for the send case, it'd be useful to support a mix of
>>> provided and registered buffers. This enables the use of using a
>>> provided ring buffer to serialize sends, and also enables the use of
>>> send bundles, where a send can pick multiple buffers and send them all
>>> at once.
>>>
>>> If provided buffers are used as an index into registered buffers, the
>>> meaning of buf->addr changes. If registered buffer index 'regbuf_index'
>>> is desired, with a length of 'len' and the offset 'regbuf_offset' from
>>> the start of the buffer, then the application would fill out the entry
>>> as follows:
>>>
>>> buf->addr = ((__u64) regbuf_offset << IOU_BUF_OFFSET_BITS) | regbuf_index;
>>> buf->len = len;
>>>
>>> and otherwise add it to the buffer ring as usual. The kernel will then
>>> first pick a buffer from the desired buffer group ID, and then decode
>>> which registered buffer to use for the transfer.
>>>
>>> This provides a way to use both registered and provided buffers at the
>>> same time.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>    include/uapi/linux/io_uring.h | 8 ++++++++
>>>    1 file changed, 8 insertions(+)
>>>
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index 86cb385fe0b5..eef88d570cb4 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -733,6 +733,14 @@ struct io_uring_buf_ring {
>>>        };
>>>    };
>>>    +/*
>>> + * When provided buffers are used as indices into registered buffers, the
>>> + * lower IOU_BUF_REGBUF_BITS indicate the index into the registered buffers,
>>> + * and the upper IOU_BUF_OFFSET_BITS indicate the offset into that buffer.
>>> + */
>>> +#define IOU_BUF_REGBUF_BITS    (32ULL)
>>> +#define IOU_BUF_OFFSET_BITS    (32ULL)
>>
>> 32 bit is fine for IO size but not enough to store offsets, it
>> can only address under 4GB registered buffers.
> 
> I did think about that - at least as it stands, registered buffers are
> limited to 1GB in size. That's how it's been since that got added. Now,
> for the future, we may obviously lift that limitation, and yeah then
> 32-bits would not necessarily be enough for the offset.

Right, and I don't think it's unreasonable considering with how
much memory systems have nowadays, and we think that one large
registered buffer is a good thing.

> For linux, the max read/write value has always been INT_MAX & PAGE_MASK,
> so we could make do with 31 bits for the size, which would bump the
> offset to 33-bits, or 8G. That'd leave enough room for, at least, 8G
> buffers, or 8x what we support now. Which is probably fine, you'd just
> split your buffer registrations into 8G chunks, if you want to register
> more than 8G of memory.

That's why I mentioned IO size, you can register a very large buffer
and do IO with a small subchunk of it, even if that "small" is 4G,
but it still needs to be addressed. I think we need at least an order
of magnitude or two more space for it to last for a bit.

Can it steal bits from IOU_BUF_REGBUF_BITS?

-- 
Pavel Begunkov

