Return-Path: <io-uring+bounces-3519-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5757D9975AE
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 21:27:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 039EF1F239B3
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 19:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D424217798F;
	Wed,  9 Oct 2024 19:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BrPpDNhf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0928E17837F;
	Wed,  9 Oct 2024 19:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728502003; cv=none; b=gS67tiz+Ff6CldlZLx1KbUvjlZ7Ty/bxnOiCV5FSpE7wa8rFUuD8QJjbr4lLbrp55TM+382bjqBcwNTAIOUmFOOMLo27BZuflKvJXOjvUJzkSptpxAeu5LbGIh36J26w1ZZFcxKef5ZU8xR9vj8UrM0eQSlncibI4sBSLkaEwlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728502003; c=relaxed/simple;
	bh=NmRZiK+ENYogwM8UE7jF/k4j7Mt6GF2YAmQxXkjNb9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V8WgOBFrsyP8EovL0SS5pFYEdbX1t6a5gZz94+m8XSGH5aL6ueq3Z8F8OqqwuqtM54/WYYMmn7MyYw4PcZZ8y+VjSreaKEljwySfNiuntzm0k9QzZFD+wwkQHjm65GGTEC3ZEkreO7c4wFOGquadwB7NJIgEAth2TLnutcC+GIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BrPpDNhf; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-42f56ad2afaso1377955e9.1;
        Wed, 09 Oct 2024 12:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728502000; x=1729106800; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=strvYIwe51JCe0Ajqt1iFG2aiUA/py1LxeiQQpZAGac=;
        b=BrPpDNhfUdCG0iTaxykRk6hkBDOZp51sDA2Ix6i7hpti99Vp2zyJA6jhL9CP2O0Yiy
         nqKJTxt59c8uLpD7d0qzWIbLgdXOEYHOR7fG1qalSsSME93KJRQLuLlmcqQmshECtlnn
         IcCqMGkwth9RnfHaoL4JZMbC6+hh7sSI5q/1gOo7S4N1YCywoAjWoCTQPiIl8x4qZdWb
         cuxs8VQMV90t9Ig+di5YSewIrayuQFudqR57eeUlGpgEZOGpY30VkJTGA6f0avcFX5m0
         WvCTzMcXIUhoet/9DPE86MNKdKngMBY0XTBIrc21G0sah5ZF6oMSorHgNRbeRSqmctSH
         Vx6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728502000; x=1729106800;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=strvYIwe51JCe0Ajqt1iFG2aiUA/py1LxeiQQpZAGac=;
        b=g9v7D7cCDqjwM+IEmSr9ahJMGPAdgRwXMZRQqB6ghEjjD4QrMPDJ7M4uQ1c3lAT2R5
         3lZsisNtdlU1h9sP/NQKkkSnD19Gn44X1hEuLvYHS5Al3w1cI668dUmkXj14FN02zxYe
         Vh5FYrsHZWAuc4PNL5vMLkylDd7vLLqD/9pC60y28QTdtWKLu0QTqC5vfAvXPNXcQXnw
         OfOz4jkOd1YjBlZojKaq+NfpFJdPIB59bQM+MJhQaTSpJOiYDNHI39EH2+lkPpqEA3OU
         5wqVIT6WqrBRM3J5o2vBWSxJhcKGyShe11eAZnKRMI8FmPKPd/7XhBjsiOz4NkE4xFtf
         +zaw==
X-Forwarded-Encrypted: i=1; AJvYcCUGNDxFo5Ur1bB/1p7lRdRfIK7mKZu0yCutV2x3E32C6/LX22t56tXFNjWRwFhxXCYVZf6PFaxZ@vger.kernel.org, AJvYcCX5aZTj87KdIM3He6zLwGlJBg2K2msrL4TETyHCkKkLSxUQSp6Qcf3f9AA/ureOLrWNJWHdVwNddw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxmJZipaGrt4I2aBjgaxsHNqJysZQIsK97PACTdBUaD04j6FqQe
	A6Ed6IRrGwS+wvWtJZat5gRs5rcJ9D2ODOCXJ+TvRdGsryBynxlqqghHRg==
X-Google-Smtp-Source: AGHT+IFmsto5Gokit3wpafTj2Zo97aFHYUXcDSuSE440Pjks0Lz57L7JBAZDm2IGUuDpezAhfweOrw==
X-Received: by 2002:adf:f48c:0:b0:37c:cdbf:2cc0 with SMTP id ffacd0b85a97d-37d3ab106ddmr3086131f8f.53.1728502000098;
        Wed, 09 Oct 2024 12:26:40 -0700 (PDT)
Received: from [192.168.42.9] ([148.252.145.180])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a994565d5a1sm589911866b.17.2024.10.09.12.26.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 12:26:39 -0700 (PDT)
Message-ID: <7cee82f7-188f-438a-9fe1-086aeda66caf@gmail.com>
Date: Wed, 9 Oct 2024 20:27:15 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 12/15] io_uring/zcrx: add io_recvzc request
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-13-dw@davidwei.uk>
 <703c9d90-bca1-4ee7-b1f3-0cfeaf38ef8f@kernel.dk>
 <f2ab35ef-ef19-4280-bc39-daf9165c3a51@gmail.com>
 <af74b2db-8cf4-4b5a-9390-e7c1cfd8b409@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <af74b2db-8cf4-4b5a-9390-e7c1cfd8b409@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 20:01, Jens Axboe wrote:
> On 10/9/24 12:51 PM, Pavel Begunkov wrote:
>> On 10/9/24 19:28, Jens Axboe wrote:
>>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>>> index d08abcca89cc..482e138d2994 100644
>>>> --- a/io_uring/net.c
>>>> +++ b/io_uring/net.c
>>>> @@ -1193,6 +1201,76 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>>>        return ret;
>>>>    }
>>>>    +int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>> +{
>>>> +    struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>>>> +    unsigned ifq_idx;
>>>> +
>>>> +    if (unlikely(sqe->file_index || sqe->addr2 || sqe->addr ||
>>>> +             sqe->len || sqe->addr3))
>>>> +        return -EINVAL;
>>>> +
>>>> +    ifq_idx = READ_ONCE(sqe->zcrx_ifq_idx);
>>>> +    if (ifq_idx != 0)
>>>> +        return -EINVAL;
>>>> +    zc->ifq = req->ctx->ifq;
>>>> +    if (!zc->ifq)
>>>> +        return -EINVAL;
>>>
>>> This is read and assigned to 'zc' here, but then the issue handler does
>>> it again? I'm assuming that at some point we'll have ifq selection here,
>>> and then the issue handler will just use zc->ifq. So this part should
>>> probably remain, and the issue side just use zc->ifq?
>>
>> Yep, fairly overlooked. It's not a real problem, but should
>> only be fetched and checked here.
> 
> Right
> 
>>>> +    /* All data completions are posted as aux CQEs. */
>>>> +    req->flags |= REQ_F_APOLL_MULTISHOT;
>>>
>>> This puzzles me a bit...
>>
>> Well, it's a multishot request. And that flag protects from cq
>> locking rules violations, i.e. avoiding multishot reqs from
>> posting from io-wq.
> 
> Maybe make it more like the others and require that
> IORING_RECV_MULTISHOT is set then, and set it based on that?

if (IORING_RECV_MULTISHOT)
	return -EINVAL;
req->flags |= REQ_F_APOLL_MULTISHOT;

It can be this if that's the preference. It's a bit more consistent,
but might be harder to use. Though I can just hide the flag behind
liburing helpers, would spare from neverending GH issues asking
why it's -EINVAL'ed


>>>> +    zc->flags = READ_ONCE(sqe->ioprio);
>>>> +    zc->msg_flags = READ_ONCE(sqe->msg_flags);
>>>> +    if (zc->msg_flags)
>>>> +        return -EINVAL;
>>>
>>> Maybe allow MSG_DONTWAIT at least? You already pass that in anyway.
>>
>> What would the semantics be? The io_uring nowait has always
>> been a pure mess because it's not even clear what it supposed
>> to mean for async requests.
> 
> Yeah can't disagree with that. Not a big deal, doesn't really matter,
> can stay as-is.

I went through the MSG_* flags before looking which ones might
even make sense here and be useful... Let's better enable if
it'd be needed.

>>>> +    if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST | IORING_RECV_MULTISHOT))
>>>> +        return -EINVAL;
>>>> +
>>>> +
>>>> +#ifdef CONFIG_COMPAT
>>>> +    if (req->ctx->compat)
>>>> +        zc->msg_flags |= MSG_CMSG_COMPAT;
>>>> +#endif
>>>> +    return 0;
>>>> +}
>>>
>>> Heh, we could probably just return -EINVAL for that case, but since this
>>> is all we need, fine.
>>
>> Well, there is no msghdr, cmsg nor iovec there, so doesn't even
>> make sense to set it. Can fail as well, I don't anyone would care.
> 
> Then let's please just kill it, should not need a check for that then.
> 

-- 
Pavel Begunkov

