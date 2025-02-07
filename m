Return-Path: <io-uring+bounces-6298-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD3EA2C53C
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 15:29:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5227D18845C0
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 14:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19B4E23ED72;
	Fri,  7 Feb 2025 14:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="e2YY9F2A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1194722069A
	for <io-uring@vger.kernel.org>; Fri,  7 Feb 2025 14:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738938551; cv=none; b=l0KHuS9nvhLWWZfLZ1U93Y5W9sy8YKVzcJaFYMdPrk/JaZ4Izr4ONeSYFxCpnMMk5wrqHKcKiNH5DAVXP+xeXOy/5YDbU5d1wpCdqm2f49SNt0KCVPJH36V1PYjZ6ILBxrSHvpB6/REFMZFhw+ky0aOliuca64Y12mGXWv3zLNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738938551; c=relaxed/simple;
	bh=O93/SIp+NuGO2A6vL2yDSudFXUg0LMqzw/Tfy72BYZk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jQZjh5BqEla2kl0mYF+VREPB4EDl+iZzaOHOiNE04y1ZDDXh77fiic6sOhhxzz+8uqNhQyvguiF+jXBzPZwh/kJYHbHdUi3QpgmVun4tiabcAdBlSeTAG+RSh8XmjCKx0TOfJCR43F1yXa95pOR13gBD/v8eWB5fvcsv8R2RDaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=e2YY9F2A; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-844e6d1283aso92923439f.1
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2025 06:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738938547; x=1739543347; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S3gig7x9bnhHvNh4AiVNKuX5nWLrgutC+4TudriJZto=;
        b=e2YY9F2AKralTbI/wrbLfLQT9ZCqhWPF53wFUJLAyX+0rznkF8GIRRYlunoCLETVft
         WK4Pizm3Ey9BU4g71R+34Tu0LxzDajPCwLVt7HRSoShAbAJagv3UrugLfFUHn66dl2D/
         wKpyS5K4u6/w4PQL1p0AxS+EBeyyHCww6PyMqjN00c4lui0SePnXRowtP6nUjTnYv10N
         HrUA7d7utjMJXY+/PKVO2cRIT0ugKjn36GVo1aIOTOorHi/Yk7I1nvG0/iUvskfkaDLz
         YauYh0uGyZ/ijz0+scVJ2XI/83AL3clvo0k4USKJxfJWq1ptpS7lLbU4pfx9RkvAbmBV
         qFpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738938547; x=1739543347;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S3gig7x9bnhHvNh4AiVNKuX5nWLrgutC+4TudriJZto=;
        b=A+joMyRb4Og5oXf9fmVyLqS4ZKdjAyQ8fXhOOIl6QbqKKnMZCySRlGimsBWAu4LnEr
         viK2aLxPkL/Rk9fcvXU5wwAHn3rJhIY8dP/oVLnEonRVcJRI1PQh3Y9FxhCDeLG+IHAn
         N099gMxPCgZZQKvezvsthl+P3qAK7AqO+2z3bduzyqquyrBhdFxxDEggC/9we0+n1SuE
         RnO7BQRJiT+DJ+ytCwi3yQ9SKk4NXp/hmAORlmkrMmZTuTxdv1+IZPHPYK/cNc3beSxL
         9iRMQLAR18lw5+rVZ1W3hJ6N10yDqkCmrqQdb/KlpUJfm9Sn1i7h2gLd947Q1UZtGThM
         A8Ow==
X-Forwarded-Encrypted: i=1; AJvYcCXBi212WRB225SRLvTOJc2CyiO1jnMtUNjeGprFWvUbJ0qWWKg3VJok3zLmV0SQljY9/lds3Tayyg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwpK6J3c91yUbEFriJcUq8qVCHXI4tKHCAGXbZsgK+/GzUEpoBY
	AMG1R+zN+afWAXR/IrfuZabAJ9Y2sQ7BwC4qXKnYth7Dm5tkMWTSElz5EXLUn3A7gshO39kE6e/
	o
X-Gm-Gg: ASbGncv20Vb07eBbJUBt0m/NuCE3Mz+UKEUEzzRRpzeyT/A271bgIyK98GpeBU+eGZ5
	proAKAdM+BrlJnaypvbGrRp4jQgt4326LixA9QKwfekdeoJz2Pf5hF3T5tA2x7jC1om+HLzbCmy
	DFX3tDXE+GbqDEnMsoSrDbXbo+LcCLb7kM1ykNPMSKXyAIIOzSLSejlV2OKoDW0LREnK3K5jMVK
	/jcx8dQD7484NOT/hT6KHX8M8I8r5PWXeDYLQ4PxURYD64b6Il9pyEPM/87E5vrgh0+avz7SY5N
	86xtlmwD2tM=
X-Google-Smtp-Source: AGHT+IEwAJI3S0hfPThQqiAP8t1KRYC2JEvRae9KQP/9FEC5QGuz1qpTzFxtAeFnkmtqRmEGyAO6cA==
X-Received: by 2002:a05:6e02:18cd:b0:3d0:59e5:3c7b with SMTP id e9e14a558f8ab-3d05a6b2986mr68989095ab.8.1738938546976;
        Fri, 07 Feb 2025 06:29:06 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4eccfad0446sm764441173.95.2025.02.07.06.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 06:29:06 -0800 (PST)
Message-ID: <80a71fb3-7c87-42d0-9de7-afd35f92be51@kernel.dk>
Date: Fri, 7 Feb 2025 07:29:05 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] eventpoll: add ep_poll_queue() loop
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org
References: <20250204194814.393112-1-axboe@kernel.dk>
 <20250204194814.393112-6-axboe@kernel.dk>
 <618af8fc-6a35-4d6e-9ac7-5e6c33514b44@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <618af8fc-6a35-4d6e-9ac7-5e6c33514b44@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2/7/25 5:28 AM, Pavel Begunkov wrote:
> On 2/4/25 19:46, Jens Axboe wrote:
>> If a wait_queue_entry is passed in to epoll_wait(), then utilize this
>> new helper for reaping events and/or adding to the epoll waitqueue
>> rather than calling the potentially sleeping ep_poll(). It works like
>> ep_poll(), except it doesn't block - it either returns the events that
>> are already available, or it adds the specified entry to the struct
>> eventpoll waitqueue to get a callback when events are triggered. It
>> returns -EIOCBQUEUED for that case.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   fs/eventpoll.c | 37 ++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 36 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
>> index ecaa5591f4be..a8be0c7110e4 100644
>> --- a/fs/eventpoll.c
>> +++ b/fs/eventpoll.c
>> @@ -2032,6 +2032,39 @@ static int ep_try_send_events(struct eventpoll *ep,
>>       return res;
>>   }
>>   +static int ep_poll_queue(struct eventpoll *ep,
>> +             struct epoll_event __user *events, int maxevents,
>> +             struct wait_queue_entry *wait)
>> +{
>> +    int res, eavail;
>> +
>> +    /* See ep_poll() for commentary */
>> +    eavail = ep_events_available(ep);
>> +    while (1) {
>> +        if (eavail) {
>> +            res = ep_try_send_events(ep, events, maxevents);
>> +            if (res)
>> +                return res;
>> +        }
>> +
>> +        eavail = ep_busy_loop(ep, true);
> 
> I have doubts we want to busy loop here even if it's just one iteration /
> nonblockinf. And there is already napi polling support in io_uring done
> from the right for io_uring users spot.

Yeah I did ponder that which is why it's passing in the timed_out == true
to just do a single loop. We could certainly get rid of that.

-- 
Jens Axboe


