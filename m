Return-Path: <io-uring+bounces-8711-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CCCDEB0A076
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 12:18:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23E5C1AA6B11
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 10:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4ADA21C177;
	Fri, 18 Jul 2025 10:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VQTJlHoV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F189E126F0A
	for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 10:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752833929; cv=none; b=VlmlYJ0HIqdR1fGHq45NY6vLg2LYyrBdfOpDi6EDpQCcp2fDPjULrk+271ZrXTvb3Z3JJA/yYSL69xuqgLlsQsd3dkdrEQ8S8B2WreyA8elPVvsAEnosPHUm9CH4Uyi4bn9mb8pZ01WrNDUHP64m+St5bV7N/pkb6HnLCa+MmIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752833929; c=relaxed/simple;
	bh=EKK2/sYjFJzfsuBXTtBMw6IKbaaqZmd/nUiirL+S44k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HrUXQoDpos2Zwc4a0byW8++fzeYS/1rV8HpvONJu9+mbCWaBcBgXobIXl8Q80QPumXG+1zaGmCmkeTr6ARNxGjQqz/Wic/+5eeyDSpu0jqGpt1nP5tzShXaQ3lM9kvFjzRtDwblxng+IIslmI886UkAVA/0KRwxmQiQ6ax0Txu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VQTJlHoV; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6097d144923so4270621a12.1
        for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 03:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752833926; x=1753438726; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+fA9sXLBKJGy17vKFjEfhPpPR44PaWWtgqYLk+7zotE=;
        b=VQTJlHoVZulatB0O8du5i9iHgXAdk+9LuDIBYrwzAmE6sAbRy7U7efK3QZGVxnhz3/
         /2GT/fet01c7SivunqwopU5mwsy5XVLRLRtRJ0YUIH7Q5BQwOjcLWROxRfmhdazwBdSJ
         8hBrM64Joyv+e35dAgeGAdSInWcxUVhhC11kC+RNNVHEsbeBtHau4KJAxMaZTLN+2c/M
         wNzbejlO51KM0HmNEYRL7zL+UeepdmUTRu97MbyPJzoRsw8T1KjbmIWFSC61EpqkT4PX
         udHxw+eOsvFIv9p/xqtLsMdN4OPreeqZKQC8b0d64LfLeG0ZQ3tO4Sfc2/4kQlMHX9Ae
         hHgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752833926; x=1753438726;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+fA9sXLBKJGy17vKFjEfhPpPR44PaWWtgqYLk+7zotE=;
        b=fSLzkl5Ilt7jKKaOjEAgkpRuPPX6nCk0qIy+0tn4wYo/c4szLH8VR4DdZ/30YmAcPA
         E9jXWWifN64pD38EvtxqMQKsn+HERP+iJCqkLQh18qoPvfeLr5PZx8mYDflyypifpHmR
         k3cP0mERX9fBUkQT/Vq+E7nuGiHmcA4Z7XucBS8sOpdibgDxjJfj1ipZCeCR6hmLI5aD
         bQKZyVLwGaJL22Ifo5gazjOpVK42JeEbohlLz9vnMkIR9E3Q1/BwebQdDMX8NFWbg/3F
         bqjQJgSxRCsCT1qjszJpuvjuab5QOKxxygc9APQ1YSR4tAT/nz/3B/y7sUkQFWeMsgQM
         SRoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKTg7ENWuX+5j65E9YXT5lIJGyCFXLfyo+he63WOFoDAFNhb4B+CVfO3/mPG7uQJAfR9rI4KEqsQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGMkHIZt4cmUt+vSl3K58uNdXsLrDfIoK8QW0mnMi33UhjObM3
	hN+OwyLjgHfk2eGl+SvE3eil6kijTQz2CnQ7RJ2raoT5lW83s7QmZkFHaOYVMQ==
X-Gm-Gg: ASbGncvR7wey8oRR9BvJCVjj15NCyzJf4MipphiaTMnyVGluQWlNbKfD1+BUhimE2Sf
	LFmYtF6eVReJzKZZrJ4cq3qhqRJoVajxYCXD4m6n0TCz3EyyclyG3lkAiYgw39OY0tq9vXSPi5u
	cC/uaGHA+VHOxeYlH2AC+XnkmuSrrWY/00LNB36nGitwPLiKdWDFE4owJGjP1HfSFC1lS6DXJX2
	tr99ReZws2nqXVw95jyCdtyRNNn9JjlvJEtBW+qJL/qkOJlW1AljGaBifgzERQSluOgdxtRBMER
	sI1VevAL6AnA8ppJmZUbf/+jaaCOQVcNncyHdHoFwFsAA6DtchN/BFuvtBJaRfcrQIBzkpKhmJ5
	TPAYqrfcOc5lei81jw5Z/sBZlsoaOL/h/MSv+wy8Sfe55CQ==
X-Google-Smtp-Source: AGHT+IFcqjPwHO0Pc4ORb+9sq5p5f7UdNcE/1CWmgIVgNV2XUMMVG+fJw72Q7PXoyHOqPwy/3J38OA==
X-Received: by 2002:a05:6402:280d:b0:602:a0:1f2c with SMTP id 4fb4d7f45d1cf-612a3392bd7mr5362378a12.9.1752833925874;
        Fri, 18 Jul 2025 03:18:45 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::1ac? ([2620:10d:c092:600::1:6915])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-612c903fb62sm744073a12.44.2025.07.18.03.18.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 03:18:45 -0700 (PDT)
Message-ID: <c6d4ee7e-a283-4599-8ef4-fa049aa26693@gmail.com>
Date: Fri, 18 Jul 2025 11:20:15 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/poll: flag request as having gone through
 poll wake machinery
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <[PATCHSET 0/3] Add support for IORING_CQE_F_POLLED>
 <20250712000344.1579663-1-axboe@kernel.dk>
 <20250712000344.1579663-3-axboe@kernel.dk>
 <801afb46-4070-4df4-a3f6-cb55ceb22a00@gmail.com>
 <9d9b87d4-78df-4c31-8504-8dbc633ccb22@kernel.dk>
 <e89d9a26-0d54-4c22-85d2-6f6c7bad9a73@gmail.com>
 <e24aaa01-e703-4a6b-9d1c-bf5deacbda86@kernel.dk>
 <4abbf820-11c9-4e01-9f95-5ccc45f0f20c@gmail.com>
 <9b874b96-f79e-4a1e-a971-9504f3f209ca@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9b874b96-f79e-4a1e-a971-9504f3f209ca@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/14/25 18:51, Jens Axboe wrote:
> On 7/14/25 9:45 AM, Pavel Begunkov wrote:
>> On 7/14/25 15:54, Jens Axboe wrote:
>>> On 7/14/25 3:26 AM, Pavel Begunkov wrote:
>>>> On 7/12/25 21:59, Jens Axboe wrote:
>>>>> On 7/12/25 5:39 AM, Pavel Begunkov wrote:
>>>>>> On 7/12/25 00:59, Jens Axboe wrote:
>>>>>>> No functional changes in this patch, just in preparation for being able
>> ...>>>> Same, it's overhead for all polled requests for a not clear gain.
>>>>>> Just move it to the arming function. It's also not correct to
>>>>>> keep it here, if that's what you care about.
>>>>>
>>>>> Not too worried about overhead, for an unlocked or. The whole poll
>>>>
>>>> You know, I wrote this machinery and optimised it, I'm not saying it
>>>> to just piss you off, I still need it to work well for zcrx :)
>>>
>>> This was not a critique of the code, it's just a generic statement on
>>> the serialization around poll triggering is obviously a lot more
>>> expensive than basic flag checking or setting. Every comment is not a
>>> backhanded attack on someones code.
>>
>> Not taken this way, it works well enough for such highly concurrent
>> synchronisation.
> 
> Certainly, no complaints!
> 
>>>> Not going into details, but it's not such a simple unlocked or. And
>>>> death by a thousand is never old either.
>>>
>>> That's obviously true, I was just trying to set expectations that a
>>> single flag mask is not really a big deal. If the idea and feature was
>>> fully solidified and useful, then arguing that adding a bit or is a
>>> problem is nonsense.
>>
>> Quite the opppsite, it should be argued about, and not because "or"
>> is expensive, but because it's a write in a nuanced place.
> 
> I think that's orthogonal - should it be commented? Definitely yes. This
> is sadly true for a lot of the code in there, but doesn't mean we should
> add more.

Not sure I understand what you mean. I was telling from the beginning
that there is a legit performance concern for that chunk, which happens
to be a bitwise "or". Which is why I commented, and what I believe should
be argued about. The "or" part is not much relevant, let's not go into
straw man'ing it. I'd just hope you're less eager to call everything
nonsense, because a single "bitwise or" could be a problem depending on
circumstances :)

-- 
Pavel Begunkov


