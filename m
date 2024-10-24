Return-Path: <io-uring+bounces-3973-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 160079AEA00
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:12:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CFAF1F2328B
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 15:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86A8E1E378A;
	Thu, 24 Oct 2024 15:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WMNXSLGk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4001C07E8
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 15:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729782723; cv=none; b=VQHv/2I6WIeuvf67/asywMzCIngt3o3ukiNMJyVkhDOz31fHAtBvcDfcrgKSOvYcJjwWLRCAQe85rFKqPpzwBQI/FBQJGiTDYOLPYKJgMLol5ZK5k96JKCeZN97dyHjrF88i2v0DMS37UpkuWhUlx9WLliqAE2Lp/M0RTiMRuwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729782723; c=relaxed/simple;
	bh=D/aMYYMojLkabo6O2tlRgKPfUA3MKtJNALlbHY/4kvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QzlH0OOYkTxbZJEIdlm9g8Jcj0Qh1fq3+MvZgLms8gwz5h9VruTArO76if9a/s7ytC/1dGLD9LlPVFDve8ij7BsjR5DZVaruNJS68E4RgRJUKGuY45xeAI08FCfh36c2Tdyrn/0uYetpr8JyOIWAchbE64VM1mnH5sAq9vEyjIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WMNXSLGk; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-83aad4a05eeso40682239f.1
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 08:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729782718; x=1730387518; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gXNA1dOrkWZSzNS+tR4JlM7Y5+AluBU3TMvpj9kJ3pk=;
        b=WMNXSLGkdDVyXxx/hILgpSxEV8JoU/t/2Ck/5zKiJa8R8gQWVrnQlc2viFAPndRsDc
         t3uIGzOlnmNfTkclhIKDd70240coV1/u3HOqXqobfikrHAeshhS5QrGcNzx+sQsf2vBN
         w75YZkEUTwcF27xvWOPtVNBg8ek/vhPW6xBM9XZ/3cIXzJrk70waSc286uG/jVLuNKYG
         rIk/e8jEXOfMBZf90jJ6iRLwmdjwWpdOMgPSeGxjrbkgHG02tOLRn4B8XnjN0ExfSdDC
         uErKIp35irph92SL+LVUf86sAXz29YYYZJw8+hz8IC25DFCs0wg/1eA+IV+Jbz1NEyhB
         9EVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729782718; x=1730387518;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gXNA1dOrkWZSzNS+tR4JlM7Y5+AluBU3TMvpj9kJ3pk=;
        b=rm1ngK8MOD4RgB0BOSr4sjef7d5JsQIZt8O1tQkqPIgNIdy067R75JK4yXaG7svF8P
         kykUPxGYnmvTyXIggkJHlC9UgW2g+/Q+EP8AKbPN9b9US145JAiOnCVnfejD+cBaRzH3
         F93GQhwfCABiORwTHXY59toxNRrXEjBfs7u4OeHAGk8g6Xbid1aKq2uoYIgYvbQFbWVr
         /LTTlf6amV2C4OE6q1Fo4pAgf6inPFBJgYNkr386tVj3RubV7xdY1a8De2rf4S6sLZiu
         WX1q+/TprDTHQ6vSAhxT4PLIWAwEVQbFOqiBSXnVGpS/jF4XU3KcVFyGIRTI345qa2i4
         KgtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWeBcpwXdOVgAoH6TZoSpJ8sY+5ko7RxjogIww1wQsneR6ssvsytYM1pcUh54z72yTteiZHcFarMQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5/B0Nv26nY+uit3UESMmWxcvjsFrcGISP0N9QCRiAr2PTFvds
	QV5n2k+r/9ffyl+B/80bXJl2iPXZRPrzK9vXAlqiQTeSzhdHCirIopgyIyer6PM=
X-Google-Smtp-Source: AGHT+IEFNMTSUAL1g+PPB2aTfAwfgQc2u2Dm15a2ODrUzaPMVeLP6THqxXJBt3R9ia5vQ7gjq61m7Q==
X-Received: by 2002:a05:6602:3cf:b0:835:359c:3f03 with SMTP id ca18e2360f4ac-83af642687fmr846043839f.15.1729782718018;
        Thu, 24 Oct 2024 08:11:58 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a6098c9sm2701871173.109.2024.10.24.08.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 08:11:57 -0700 (PDT)
Message-ID: <943cc734-e074-438a-b881-84dca3feb23c@kernel.dk>
Date: Thu, 24 Oct 2024 09:11:56 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET RFC 0/7] Add support for provided registered buffers
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20241023161522.1126423-1-axboe@kernel.dk>
 <9e6ba7d3-22ae-4149-8eab-ed92a247ac61@gmail.com>
 <954749c7-ee49-4526-9394-4dec4304a1b4@kernel.dk>
 <ee1bde23-be71-47ba-ad4a-4c152fb7551c@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ee1bde23-be71-47ba-ad4a-4c152fb7551c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 9:04 AM, Pavel Begunkov wrote:
> On 10/24/24 15:43, Jens Axboe wrote:
>> On 10/24/24 8:36 AM, Pavel Begunkov wrote:
>>> On 10/23/24 17:07, Jens Axboe wrote:
>>>> Hi,
>>>>
>>>> Normally a request can take a provided buffer, which means "pick a
>>>> buffer from group X and do IO to/from it", or it can use a registered
>>>> buffer, which means "use the buffer at index Y and do IO to/from it".
>>>> For things like O_DIRECT and network zero copy, registered buffers can
>>>> be used to speedup the operation, as they avoid repeated
>>>> get_user_pages() and page referencing calls for each IO operation.
>>>>
>>>> Normal (non zero copy) send supports bundles, which is a way to pick
>>>> multiple provided buffers at once and send them. send zero copy only
>>>> supports registered buffers, and hence can only send a single buffer
>>>
>>> That's not true, has never been, send[msg] zc work just fine with
>>> normal (non-registered) buffers.
>>
>> That's not what I'm saying, perhaps it isn't clear. What I'm trying to
>> say is that it only supports registered buffers, it does not support
>> provided buffers. It obviously does support regular user provided
>> buffers that aren't registered or provided, I figured that goes without
>> saying explicitly.
> 
> Normally goes without saying yes, but the confusion here is because
> of a more or less explicit implication (or at least I read it so)
> "it only supports registered buffers => selected buffer support
> should support registered buffers, which it adds"

I'll expand it to be more clear.

> Does the series allows provided buffers with normal user memory?

Yep, it should allow either picking one (or more, for bundles) provided
buffers, and the provided buffer is either normal user memory, or it's
indices into registered buffers.

>>>> This patchset adds support for using a mix of provided and registered
>>>> buffers, where the provided buffers merely provide an index into which
>>>> registered buffers to use. This enables using provided buffers for
>>>> send zc in general, but also bundles where multiple buffers are picked.
>>>> This is done by changing how the provided buffers are intepreted.
>>>> Normally a provided buffer has an address, length, and buffer ID
>>>> associated with it. The address tells the kernel where the IO should
>>>> occur. If both fixed and provided buffers are asked for, the provided
>>>> buffer address field is instead an encoding of the registered buffer
>>>> index and the offset within that buffer. With that in place, using a
>>>> combination of the two can work.
>>>
>>> What the series doesn't say is how it works with notifications and
>>> what is the proposed user API in regard to it, it's the main if not
>>> the only fundamental distinctive part of the SENDZC API.
>>
>> Should not change that? You'll should get the usual two notifications on
>> send complete, and reuse safe.
> 
> Right you get a notification, but what is it supposed to mean to
> the user? Like "the notification indicates that all buffers that
> are consumed by this request can be reused". Multishot is not a
> thing, but how the user has to track what buffers are consumed
> by this request? I assume it posts a CQE per buffer completion,
> right?

Depends on if it's bundles or not. For a non-bundle, a single buffer is
picked, and that buffer is either user memory or it's an index into a
registered buffer. For that, completions work just like they do now - a
single one is posted for the expected inline completion with buffer ID,
and one is posted for reuse laster.

If it's a bundle, it works the same way, two completions are posted. The
first expected inline one will have a buffer ID, and the length will
tell you how many consecutive buffers were sent/consumed. Then the reuse
notification goes with that previous completion.

> And let's say you have send heavy workload where the user pushes
> more than the socket can take, i.e. it has to wait to send more
> and there is always something to send. Does it poll-retry as it's
> usually done for multishots? How notifications are paced? i.e.
> it'll continue hooking more and more buffers onto the same
> notification locking all the previously used buffers.

If it sends nothing, nothing is consumed. If it's a partial send, then
buffers are kept (as nobody else should send them anyway), and it's
retried based on the poll trigger. For the latter case, completion is
postd at the end, when the picked buffers are done. For pacing, you can
limit the amount of data sent by just setting ->len to your desired
bundle/batch size.

-- 
Jens Axboe

