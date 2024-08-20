Return-Path: <io-uring+bounces-2846-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA33B958FB2
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 23:31:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6393B286DA8
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 21:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79406E541;
	Tue, 20 Aug 2024 21:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zkVXuvK8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6801014F109
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 21:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724189476; cv=none; b=Xb5OtcvDEwkCYdnCzJ6uYzEffkHvOJszmYsD0FqN6O3LfNawNXHp5EfPnenuvnC6aaFsPNkrrgXGZN/cGE9JWbIr0IJC2w7ci0duQFWo3MS0YmmmLvEk/srqazl8ab9pQ2I2liFZGtqgzp0tzC/hnWR55xGjWu8pPo5SRJEt8Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724189476; c=relaxed/simple;
	bh=Akl1xLut2pbKxgNC/fYiUZf5+5mbwbrfvBYmxB29jX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sHs18ndi0zEUgxn8kPvcYgDxSeabJA5Ug5PKJ0gDEoCdDBq59y2YjflxY+2ZpCCXVXwNQc3AXtc1h41OacZCja27Ox4dx3lMUO8om4hN8XsLrSImwYtN2tm+hQ6+U8x9LHQUJjkvw3+BRwVWk/fnKMPXiQzHa9Ete4atetUYj08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zkVXuvK8; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2025031eb60so20351905ad.3
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 14:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724189472; x=1724794272; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tnIlYPjOAc51afGqQI6sq8Yx2Qi9d7q42hkfy/0qmIY=;
        b=zkVXuvK8XMXnLp+6s7He5m+mqcMCcaNAxOde0OdYIYHmaXYIzTMiSgFqN0eSw/EVAK
         js6X5gAAqJrow/MvD8KeU/m3Mwu3wn9rCdM+GTSlqm8scHaMlruv7eLFtC5onMNvEVrZ
         2JRBXmjFqfip6SYg9145rfQmb1XhtoEZC/3NBKq/Y/QxUc1mv+eDsLNh3p27ivLPzTLa
         69NotWPrfhHiLPHhxNllmJge0Bm9A9t/lsD+AfpY01DYNe3S5upWOp6egSDgr5zfcsUW
         qBEbXDukZXmTANk09aZPSQ+Rwnva3pUZ0tzABFi4B4y0dh/6u3o+rgh7707QlaOljg4E
         f0dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724189472; x=1724794272;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tnIlYPjOAc51afGqQI6sq8Yx2Qi9d7q42hkfy/0qmIY=;
        b=QaqIeT145d7P7IJNPCO4iTzj5F8nfE2hNUL7PAwlcsoNC5wbTCEo8mA8W0KzaPlklN
         g2+AX9oY8RvPk93VS038ACRKpYh/4WTRWth9zpczqOPrELhQbip3IVuuVfi7DK/VsOCm
         zqMkzy3pw7aMgL6py58+PXKBNnWgK2nKF0EtrQ1qkO+9u3G9Y/TQrpPxJtmG4bFDziNB
         m2VBw3FgilGsWYi05Qr3NKcwKRNTer/DfrExh5YpgJrwAC43UuJPqugHCmxsEeiUMoP/
         p5cywLZcf15w85V/nzuhnsKU7TZcx6TOkME2YjU9i6V0JMqcQH281psenRiaGwwd1f0i
         RDUw==
X-Forwarded-Encrypted: i=1; AJvYcCU4S6G9upAwJMqm6A/yKaLdAhSjUdd0rU/S6JxYVFr3A8FzdOoWQEBpYtpEFvxsmAp+gBi6S2AHTw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbuzPvvgsO63fXFkDObpe4cfhtP7EJu09DTJmF4qtfkhUSPNzA
	SIztNdsdXLL3h3lexfpaRXqnHTXt/nsYkKWmwXPMigCjO0V2leeo1XM09Qro3eY=
X-Google-Smtp-Source: AGHT+IHqOElJHcpL/fNJ/kaSJFS0BqicHb60WSpVoj/RxgMaIvHY5/v22JWeVIfLO5gRCCZjODIMsw==
X-Received: by 2002:a17:903:2450:b0:1fd:b604:58a6 with SMTP id d9443c01a7336-20367c089b2mr4167135ad.17.1724189471392;
        Tue, 20 Aug 2024 14:31:11 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f0319722sm82110765ad.66.2024.08.20.14.31.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 14:31:10 -0700 (PDT)
Message-ID: <8e089d10-15e0-4dcb-ae64-c18cc29e8d86@kernel.dk>
Date: Tue, 20 Aug 2024 15:31:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] io_uring: add support for batch wait timeout
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-5-axboe@kernel.dk>
 <c9d18b99-96a8-4c86-abe0-0535f395ccc6@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c9d18b99-96a8-4c86-abe0-0535f395ccc6@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/20/24 3:10 PM, David Wei wrote:
> On 2024-08-19 16:28, Jens Axboe wrote:
>> Waiting for events with io_uring has two knobs that can be set:
>>
>> 1) The number of events to wake for
>> 2) The timeout associated with the event
>>
>> Waiting will abort when either of those conditions are met, as expected.
>>
>> This adds support for a third event, which is associated with the number
>> of events to wait for. Applications generally like to handle batches of
>> completions, and right now they'd set a number of events to wait for and
>> the timeout for that. If no events have been received but the timeout
>> triggers, control is returned to the application and it can wait again.
>> However, if the application doesn't have anything to do until events are
>> reaped, then it's possible to make this waiting more efficient.
>>
>> For example, the application may have a latency time of 50 usecs and
>> wanting to handle a batch of 8 requests at the time. If it uses 50 usecs
>> as the timeout, then it'll be doing 20K context switches per second even
>> if nothing is happening.
>>
>> This introduces the notion of min batch wait time. If the min batch wait
>> time expires, then we'll return to userspace if we have any events at all.
>> If none are available, the general wait time is applied. Any request
>> arriving after the min batch wait time will cause waiting to stop and
>> return control to the application.
> 
> I think the batch request count should be applied to the min_timeout,
> such that:
> 
> start_time          min_timeout            timeout
>     |--------------------|--------------------|
> 
> Return to user between [start_time, min_timeout) if there are wait_nr
> number of completions, checked by io_req_local_work_add(), or is it
> io_wake_function()?

Right, if we get the batch fulfilled, we should ALWAYS return.

If we have any events and min_timeout expires, return.

If not, sleep the full timeout.

> Return to user between [min_timeout, timeout) if there are at least one
> completion.

Yes

> Return to user at timeout always.

Yes

This should be how it works, and how I described it in the commit
message.

-- 
Jens Axboe


