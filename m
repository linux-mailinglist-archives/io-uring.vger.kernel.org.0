Return-Path: <io-uring+bounces-8851-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D8DCAB14474
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 00:43:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0534E18C069B
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 22:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6B55230981;
	Mon, 28 Jul 2025 22:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d8pov55P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FE62165E2;
	Mon, 28 Jul 2025 22:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753742576; cv=none; b=jpfzDJIDoC3ZPWn1Gj/kYi4O2hFNxRZrC/w5RXrJz3tB+Jid83WZ7xC35n/7dpr8QsG/Dwt8t5xFS2JUXUFgoyXbIHlar8p/0OLIDbxk9rhmUXDIcSqdbvzGf6NXLBdbjJFdbRnn6OzRX63uSKcE1e4KcmNAOVpLiQRV0kwwF00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753742576; c=relaxed/simple;
	bh=T0m4RjxGmRcFCGY8Izzxhx+NyLjSIqOUl5woFA8I+xA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tmniueKm0I5DcX0/jfDAOUC7IFYpXlMYMr65bctnr6tMBXf98kTgoqNao2aUmHlH4KRHScpYB/4N95t++FKG2Ace73RlE0j9z7BCjIFs/tyDN4pSh7gLElSxbV1OGFIj3IV/3yxy7FsNM8y/W/jLIc7qJFOyAkfVI6mEe7VFZMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d8pov55P; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ae0d758c3a2so817015666b.2;
        Mon, 28 Jul 2025 15:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753742571; x=1754347371; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kNq1RCK00rRwSRJWj6lFJCddqvzpUCP6cBE32w5jDcw=;
        b=d8pov55PrB4Mso7v+VE8s2lzhcUcXsL67155imTzYLtvMYEp+CUJ+NPkgEnCGHWFJH
         YBJ01kK/gJd/TonkWnj7ekdu9SfH6tTbi+AVseTKnR/dDgEVQwpObc5++WIEBsr6DyxO
         jkGIseiLjbINxj9Skx666TuNgtFe9Ln36EOmXW+1iR0SvBee9lBG96Xymki6Nxydbnjs
         3V+wZHH7gAMBCjj0jZE762iuNteMyq+N2e4V12jqqk5+n6ztTDHXGO/0Y3fhlw8PXfpB
         Z/Zl6o0bQzrKOYzFlfYBwnAXd/SXDgT3EABChoqBWkOUbGw+YfXdzFJxYnYfjRVRcd3Z
         Uiuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753742571; x=1754347371;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kNq1RCK00rRwSRJWj6lFJCddqvzpUCP6cBE32w5jDcw=;
        b=fKwN0eqe+4So1/JAxQH2j9GBsEXhtFIgOW+/5LqfWz17kPz0buW1bIuEbewGMhBF+T
         3OpfCIv4jbwWeCJLk6jN29CC4nzhVfr31wx8AY2LEnXVZjAAg5zI/h6FuZ8XRbWDEZzN
         LmXNzjMwNqtRbzbfoIMh2jNMEs2B5kbyiRNko3BQ2bLaLR4SACIFKu7ZI76vGIC+1c5E
         09UGL8gP8h4SW+r6Km7XNEzzZyQ57V4io8r0ZNMAZ3boUSdKYvV1RCH7h9XuaQaEPcUP
         zE2V2w37qFTnUpnyq+HQEWzX95LQcCIbAiaddDBeRBkJOoJ1KC/m4faj80fvb6jF3SlQ
         /v8g==
X-Forwarded-Encrypted: i=1; AJvYcCULbgywZenTj54uhwdsX5HtiytfQeFrANptzXAsqBzySYg+cthqccF/R3VKbgAjtAQ9pyewYrmK5A==@vger.kernel.org, AJvYcCUXhs8LsoiPrUWPYhYVc+5j5dXWaZ5IyPKxsxnEbYI2C13y9q6crjQdmd0OFWTFTK3ZjNeFQyKU@vger.kernel.org
X-Gm-Message-State: AOJu0YwrAkxr4jPg9it2DEANP8N2XlHYqdV+nQ5hatin5+CCQJwHqGpU
	i0D8+TmNnkwUi/wQtrr+rT0REwud7wr0WFxdDLzOr71P6eIHldZzS0zY
X-Gm-Gg: ASbGncs5RqAH+MQFcr6ImOfz4p/W++vF+BCqKZAqa/vhsCV+XXhqMsMbCQ9oBzrURur
	Bc3ecuIM+5JZO4S/iFjBFT2pAFGewdgP07XJl4VKQhiotxB0TCWVu5T4lukPt0+e037EBTKkIuX
	RRlx1nPRPt6B14yoZw/mXtVNABPSEUw01zhVtXG3mZzlwTlTTqGq3gikLvu2ueO+ovUsSh81ADx
	QsoBlOFZt+UcNc0bIAs+T37NCUi/quSQ3Egy9lF/d1tUr0bZDEozG2FOmDsqam8/d8/2DYtTDyu
	Vn2gaQZhl/Pv9gm6/zi86TCYz9QhMRi+MnT8Yp3p3z67MQ3JNZJXJwUgDxLtAEaYUN8FlIPrrJF
	bCIC/rA2NytiAH5ZzE8LCjhu20YXJhjA=
X-Google-Smtp-Source: AGHT+IE8tPcwTBp77mPrq1aCmXHLDbhx61oWPmjW3wgxxCuZpUYKcMUsA7Vh7dmh56bO13trpuukow==
X-Received: by 2002:a17:907:961b:b0:ae0:d019:dac7 with SMTP id a640c23a62f3a-af61750935cmr1498862666b.23.1753742571097;
        Mon, 28 Jul 2025 15:42:51 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.164])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af635a62b09sm479103066b.75.2025.07.28.15.42.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 15:42:50 -0700 (PDT)
Message-ID: <52597d29-6de4-4292-b3f0-743266a8dcff@gmail.com>
Date: Mon, 28 Jul 2025 23:44:11 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 00/22] Large rx buffer support for zcrx
To: Stanislav Fomichev <stfomichev@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Willem de Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, almasrymina@google.com, dw@davidwei.uk,
 michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com
References: <cover.1753694913.git.asml.silence@gmail.com>
 <aIevvoYj7BcURD3F@mini-arch> <df74d6e8-41cc-4840-8aca-ad7e57d387ce@gmail.com>
 <aIfb1Zd3CSAM14nX@mini-arch> <0dbb74c0-fcd6-498f-8e1e-3a222985d443@gmail.com>
 <aIf0bXkt4bvA-0lC@mini-arch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aIf0bXkt4bvA-0lC@mini-arch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/28/25 23:06, Stanislav Fomichev wrote:
> On 07/28, Pavel Begunkov wrote:
>> On 7/28/25 21:21, Stanislav Fomichev wrote:
>>> On 07/28, Pavel Begunkov wrote:
>>>> On 7/28/25 18:13, Stanislav Fomichev wrote:
>> ...>>> Supporting big buffers is the right direction, but I have the same
>>>>> feedback:
>>>>
>>>> Let me actually check the feedback for the queue config RFC...
>>>>
>>>> it would be nice to fit a cohesive story for the devmem as well.
>>>>
>>>> Only the last patch is zcrx specific, the rest is agnostic,
>>>> devmem can absolutely reuse that. I don't think there are any
>>>> issues wiring up devmem?
>>>
>>> Right, but the patch number 2 exposes per-queue rx-buf-len which
>>> I'm not sure is the right fit for devmem, see below. If all you
>>
>> I guess you're talking about uapi setting it, because as an
>> internal per queue parameter IMHO it does make sense for devmem.
>>
>>> care is exposing it via io_uring, maybe don't expose it from netlink for
>>
>> Sure, I can remove the set operation.
>>
>>> now? Although I'm not sure I understand why you're also passing
>>> this per-queue value via io_uring. Can you not inherit it from the
>>> queue config?
>>
>> It's not a great option. It complicates user space with netlink.
>> And there are convenience configuration features in the future
>> that requires io_uring to parse memory first. E.g. instead of
>> user specifying a particular size, it can say "choose the largest
>> length under 32K that the backing memory allows".
> 
> Don't you already need a bunch of netlink to setup rss and flow

Could be needed, but there are cases where configuration and
virtual queue selection is done outside the program. I'll need
to ask which option we currently use.

> steering? And if we end up adding queue api, you'll have to call that
> one over netlink also.

There is already a queue api, even though it's cropped IIUC.
What kind of extra setup you have in mind?

>>>
>>> If we assume that at some point niov can be backed up by chunks larger
>>> than PAGE_SIZE, the assumed workflow for devemem is:
>>> 1. change rx-buf-len to 32K
>>>     - this is needed only for devmem, but not for CPU RAM, but we'll have
>>>       to refill the queues from the main memory anyway
>>
>> Urgh, that's another reason why I prefer to just pass it through
>> zcrx and not netlink. So maybe you can just pass the len to devmem
>> on creation, and internally it sets up its queues with it.
> 
> But you still need to solve MAX_PAGE_ORDER/PAGE_ALLOC_COSTLY_ORDER I
> think? We don't want the drivers to do PAGE_ALLOC_COSTLY_ORDER costly
> allocation presumably?

#define PAGE_ALLOC_COSTLY_ORDER 3

It's "costly" for the page allocator and not a custom specially
cooked memory providers. Nobody should care as long as the length
applies to the given provider only. MAX_PAGE_ORDER also seems to
be a page allocator thing.

-- 
Pavel Begunkov


