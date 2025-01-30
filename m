Return-Path: <io-uring+bounces-6187-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C4BCA230AD
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2025 15:54:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E4BD162567
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2025 14:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 810541D88DB;
	Thu, 30 Jan 2025 14:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GwzrqH5+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9271D1E376C
	for <io-uring@vger.kernel.org>; Thu, 30 Jan 2025 14:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738248892; cv=none; b=LCX6GNtPCQT3AiKQTh+xKBZuYSjVIBd6umd0e3wQDhdqKj/mTGwo7iSoRCDicHDFbrUQUK/S4AGtq05b3p/RTmlQQ93F0cE8tHhWhHZDa5He3eWvInizl+ED1BPRZBCBH/+lneIkHWtguxXU5RniJyhW7GsEH3wzOAJWH7XcyuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738248892; c=relaxed/simple;
	bh=TMQl5rfvRVr5SnoZcEJDLgdQ5XZJ/i3ctaiDEkjr4jI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dghIfGh0fd/mj1BAPhzecXYE4Fk99YDsocUVJ3OGDCh19nBBYhir2y84NrOY2EIcwYpNR+ZHWmVmiVj+FhzWhn+5k0oMvfMMx3DD1lCbODwgJLEAwWn7EW4AlS4dkaZohO8OwHkmfEr3dx6x3VzMPXS+MGv0zQcVii3accMl6K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GwzrqH5+; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-4afdf300d07so554313137.3
        for <io-uring@vger.kernel.org>; Thu, 30 Jan 2025 06:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738248888; x=1738853688; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F1UHNnF/D0xuHW2VMmWfJ1WGt6Iflmdx5dnF7fMQdOg=;
        b=GwzrqH5+C++J4VCIsYPMpciQxPl8Mo7w0EIIVv9FvDaMbKK6kS/y66WXFHGZfO33B6
         akr6atv/JnMlzIqwT5DtQDiafrTVML4uMJ2BJGqfNj6pX8BGz8XsdP3/ZhwAz1Bort3d
         HMdkI0oj4qOQdw/uTqN97RgSQtGmlhUCyN/NL6f5DMD2HQ11vY7+MWtgTjFbL/SF2GBP
         8PobKU3jo56vendeSYii4c7CoQwjWVsuMcPd1Rh/4OeUy4FNUsN3Xw/rjQH6zpfVS6UE
         DgluwE1pcCcZl4xYzKZr9dCHBYSNbaiLL0tdm7EVbvs2yxnLuaUDmKgiIXjevPnAAq1t
         lFWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738248888; x=1738853688;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F1UHNnF/D0xuHW2VMmWfJ1WGt6Iflmdx5dnF7fMQdOg=;
        b=MLh2TKx4xKGk+bp4p1ZgjxS27Ja4XQaTdcuURFdblszI1rYwWB4imtH/ruX4zpeXV9
         eNe6RLZq05THJIzAQ7WQuCCMMS95qlmBXHpflMTMeE6CLlv8VxJ88FW2/zSUbILNuoZR
         uj3+QbNTWf4Tvn5Dwf0g2iO2JfRRz3ZrvLB8tsxdNciG1IMoGsShzInjFPi/ox6sFO1g
         fgmZwHh4Bzbo6n8bS+muO6L45bi4NEmvz4o+UKoghLFpU3j9Xrbdz/n8ZHzVfbpEJC6L
         RZIWajuy3EZVQd2SW/9dH4WRJ6eOcmLuMTe6p076A5cIcMiZ3imbjnnlP9jM8YFA65lM
         WyoA==
X-Gm-Message-State: AOJu0YywLdSWgqYBS/qXx4lHqvAKi8kGtXrfxk+MlLRX0YyhI2k88dBn
	dLQhW8V9W/pXk3CLfxbcPYtEWzmkBWQKvSzuglilq7Ry8/PH5mvDNoxH+zO7A85dRhfOyyo6+5C
	I
X-Gm-Gg: ASbGnctr32wcIZlPs5+YTkP2vXJ9/xWaBHZxiWibWpoeEQDSlHFH9RA0Xlp/syVtmX0
	H2bscSr8N8AkbGeFGpzmKbXfaFBb/LcyplR8kLuIy7EyjdHR1sFj9xEnXStJgp/2kath28k3S1v
	fhytPKBzQTliZefIWPnLoXqZI80JlAonPgAfvhQlnNMvAUR7Sn5lCOk0VLDseIow8NUkR3Rx9UJ
	THlXBW4M2ldFhC5ZHyD8lFeZqMe4rfeUt9V1n+NUVRgGDUAVNGSAfMZ+nT3wuczwE+R8cDDXFwG
	M+SMA010Gsc=
X-Google-Smtp-Source: AGHT+IGkqgU29cscaX28kSOW5d/8/UHkajIQjAhHSd6Ez0oybhdmKVoz4YyFx87CK+uM3LcMnII5KA==
X-Received: by 2002:a05:6602:2b10:b0:84c:e8ce:b531 with SMTP id ca18e2360f4ac-85439fbb605mr820918539f.14.1738248877649;
        Thu, 30 Jan 2025 06:54:37 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746c0ed8sm365185173.108.2025.01.30.06.54.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2025 06:54:36 -0800 (PST)
Message-ID: <178c6f1b-cfda-46cb-8c15-a25a5319f6e4@kernel.dk>
Date: Thu, 30 Jan 2025 07:54:36 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] io_uring/io-wq: cache work->flags in variable
To: Pavel Begunkov <asml.silence@gmail.com>,
 Max Kellermann <max.kellermann@ionos.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <20250128133927.3989681-5-max.kellermann@ionos.com>
 <856ed55d-b07b-499c-b340-2efa70c73f7a@gmail.com>
 <CAKPOu+-Mfx9q79nin7tGi1Rr4qGGY=y-2OhuP80U=7EtRpfBdg@mail.gmail.com>
 <19750632-1f9d-4075-ac5c-f44fab3690a6@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <19750632-1f9d-4075-ac5c-f44fab3690a6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/29/25 4:41 PM, Pavel Begunkov wrote:
> On 1/29/25 19:11, Max Kellermann wrote:
>> On Wed, Jan 29, 2025 at 7:56?PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>> What architecture are you running? I don't get why the reads
>>> are expensive while it's relaxed and there shouldn't even be
>>> any contention. It doesn't even need to be atomics, we still
>>> should be able to convert int back to plain ints.
>>
>> I measured on an AMD Epyc 9654P.
>> As you see in my numbers, around 40% of the CPU time was wasted on
>> spinlock contention. Dozens of io-wq threads are trampling on each
>> other's feet all the time.
>> I don't think this is about memory accesses being exceptionally
>> expensive; it's just about wringing every cycle from the code section
>> that's under the heavy-contention spinlock.
> 
> Ok, then it's an architectural problem and needs more serious
> reengineering, e.g. of how work items are stored and grabbed, and it
> might even get some more use cases for io_uring. FWIW, I'm not saying
> smaller optimisations shouldn't have place especially when they're
> clean.

Totally agree - io-wq would need some improvements on the where to queue
and pull work to make it scale better, which may indeed be a good idea
to do and would open it up to more use cases that currently don't make
much sense.

That said, also agree that the minor optimizations still have a place,
it's not like they will stand in the way of general improvements as
well.

-- 
Jens Axboe

