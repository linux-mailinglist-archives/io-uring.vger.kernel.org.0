Return-Path: <io-uring+bounces-3972-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A67B9AE9AD
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD66E2814BC
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 15:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C62C91E2614;
	Thu, 24 Oct 2024 15:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ESV9NDLr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716871E5735
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 15:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729782229; cv=none; b=JDcTKJX99wbXYsn2QUqmwYCCTQShJL87wsgE8Rtp40caJLwHHJRFnpBRARyBrSxQIDI3oo6/oOCWl42d8szHF3Ys6ayLj9sicqPaF9eR0XeJOIc2i3hCAb8rfTTHJrH1eO8I9lvdfK6DDfG7/5W4owL1rGLpokg5NqyviTbdOgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729782229; c=relaxed/simple;
	bh=VEqD7X5/d+YTBm6NywClDeY98+1aCvkxFINTHNToyWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pBdQLC9Zo8YZmIB1Y+oA2vUymt/kz98fQkcWPcIhPA9LucGny8h8+VGtOV0XUtaF47K2OfQgkg/Vx4X/ugfWYCFr+BxDY/6lkdOIQJ9/Zk69Ln/4VJo1rAkEK7uwujfz63HM5WSu8Hr/MZGHH38uWcDMbXcTG7nXDwnVvfJM4NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ESV9NDLr; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5c94c4ad9d8so1240872a12.2
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 08:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729782226; x=1730387026; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uvjPcZSZwQI7vf7RSd6fenQpSZlY6ctk/bK2f7lmtA0=;
        b=ESV9NDLrhwQHN3hihB+MSDNowHz1FTFFz4PYKua3oaRSBYb5/NMRiYkR8YZRZWtE0M
         AkkUj36q2b6hKPMv4GvVj2Oll7rVZ/SzotKIu8XL/qR1HO6SSpOcXcpFPB7KWz5S6FNF
         PbjhZOoz1GC4h+DyeF4ODSXXCDwE3JrYzobjo8V1+0s48Tf90VhDfRlq9nyGxZjVKdtH
         1vVsK+vPE/NcaKU+yUUM6emuxCGC1ZaMoeFIxtHc8V5GxcnEZD8dItFxNMD61LOAvIoJ
         8zlbxYvByivMg4d3ei0sikR8p6r089yeabcjDtzdWbo1bc3NyuKlMO5UCc01F0GulfTU
         V8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729782226; x=1730387026;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uvjPcZSZwQI7vf7RSd6fenQpSZlY6ctk/bK2f7lmtA0=;
        b=PbhsqkeEyHTZm/0pvvP1IzQbJoJrUnPyNI1Je85j1srBwugYHV8ZAFvmK0pTmeCF56
         Tzj31IktRDh35i5UqNrY1ietc/tp1tlyLqgp68RI3I3wfc2uB+umY2a39lhmqlMHS6EI
         RZr74hsz9g3s/GQliDbkv7Zd314/eaoZcK5GGxu9c57O7GPTuv4uu/hNiU+CD7XN8tai
         VdksbWxsXg9uq7BhJiSsqAIPJWiqybAoqICUb3nF1JdyRxK86VfuFIUAa6iBdRaCZalu
         yYM3r1hQ/mD53htAMoK8ioPIhVvvyxDYTKuK2rHzvDjBE8TjtzWShNhTax6ELcWISDX5
         /6gA==
X-Forwarded-Encrypted: i=1; AJvYcCXALlwlx5ivyWXjkp8vKumUbF5/lhnZdfPEfxwz9jghBgmnnwdFjdMoYxBm57XXmY3naM/ElgK23g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyiYbxjUqv/LrczoG4yXWunIA4xlVUkSJbJKf94COQgjYIIWQqQ
	69EXdBITZWi/r3H+EBhElXwJQyO7WIn7I2yXTNIQ7berRQNbgTmI
X-Google-Smtp-Source: AGHT+IEKCHggYh/i3vYhKE64YTJ4qX/8M+xvo8rpYyhc+D7S1UvFLf5zgBFZ8J01PQFaVV3tTqLuSw==
X-Received: by 2002:a17:907:9812:b0:a9a:835:b4eb with SMTP id a640c23a62f3a-a9abf8cd7c2mr597029566b.38.1729782224875;
        Thu, 24 Oct 2024 08:03:44 -0700 (PDT)
Received: from [192.168.42.27] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91370547sm629047166b.128.2024.10.24.08.03.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 08:03:44 -0700 (PDT)
Message-ID: <ee1bde23-be71-47ba-ad4a-4c152fb7551c@gmail.com>
Date: Thu, 24 Oct 2024 16:04:19 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET RFC 0/7] Add support for provided registered buffers
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20241023161522.1126423-1-axboe@kernel.dk>
 <9e6ba7d3-22ae-4149-8eab-ed92a247ac61@gmail.com>
 <954749c7-ee49-4526-9394-4dec4304a1b4@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <954749c7-ee49-4526-9394-4dec4304a1b4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 15:43, Jens Axboe wrote:
> On 10/24/24 8:36 AM, Pavel Begunkov wrote:
>> On 10/23/24 17:07, Jens Axboe wrote:
>>> Hi,
>>>
>>> Normally a request can take a provided buffer, which means "pick a
>>> buffer from group X and do IO to/from it", or it can use a registered
>>> buffer, which means "use the buffer at index Y and do IO to/from it".
>>> For things like O_DIRECT and network zero copy, registered buffers can
>>> be used to speedup the operation, as they avoid repeated
>>> get_user_pages() and page referencing calls for each IO operation.
>>>
>>> Normal (non zero copy) send supports bundles, which is a way to pick
>>> multiple provided buffers at once and send them. send zero copy only
>>> supports registered buffers, and hence can only send a single buffer
>>
>> That's not true, has never been, send[msg] zc work just fine with
>> normal (non-registered) buffers.
> 
> That's not what I'm saying, perhaps it isn't clear. What I'm trying to
> say is that it only supports registered buffers, it does not support
> provided buffers. It obviously does support regular user provided
> buffers that aren't registered or provided, I figured that goes without
> saying explicitly.

Normally goes without saying yes, but the confusion here is because
of a more or less explicit implication (or at least I read it so)
"it only supports registered buffers => selected buffer support
should support registered buffers, which it adds"

Does the series allows provided buffers with normal user memory?

>>> at the time.
>>
>> And that's covered by the posted series for vectored registered
>> buffers support.
> 
> Right, for sendmsg.
> 
>>> This patchset adds support for using a mix of provided and registered
>>> buffers, where the provided buffers merely provide an index into which
>>> registered buffers to use. This enables using provided buffers for
>>> send zc in general, but also bundles where multiple buffers are picked.
>>> This is done by changing how the provided buffers are intepreted.
>>> Normally a provided buffer has an address, length, and buffer ID
>>> associated with it. The address tells the kernel where the IO should
>>> occur. If both fixed and provided buffers are asked for, the provided
>>> buffer address field is instead an encoding of the registered buffer
>>> index and the offset within that buffer. With that in place, using a
>>> combination of the two can work.
>>
>> What the series doesn't say is how it works with notifications and
>> what is the proposed user API in regard to it, it's the main if not
>> the only fundamental distinctive part of the SENDZC API.
> 
> Should not change that? You'll should get the usual two notifications on
> send complete, and reuse safe.

Right you get a notification, but what is it supposed to mean to
the user? Like "the notification indicates that all buffers that
are consumed by this request can be reused". Multishot is not a
thing, but how the user has to track what buffers are consumed
by this request? I assume it posts a CQE per buffer completion,
right?

And let's say you have send heavy workload where the user pushes
more than the socket can take, i.e. it has to wait to send more
and there is always something to send. Does it poll-retry as it's
usually done for multishots? How notifications are paced? i.e.
it'll continue hooking more and more buffers onto the same
notification locking all the previously used buffers.

-- 
Pavel Begunkov

