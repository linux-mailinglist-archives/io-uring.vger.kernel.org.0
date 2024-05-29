Return-Path: <io-uring+bounces-1989-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A63558D2B1C
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 04:43:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CAE0285255
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 02:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 626B415B135;
	Wed, 29 May 2024 02:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZMQBSq1l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607F715B12E
	for <io-uring@vger.kernel.org>; Wed, 29 May 2024 02:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716950534; cv=none; b=b0gCjFatiNTJ6cDZGb8JbtZ1OHUAC91NRh/wnhkRgjrSBJfLVPENt2G/74z/Z6iB2UvBH/IgSqIi8bGei6DWSoKCgBudOsGMAjTVuGxcVk8cbnqb1ScZNTFrzqZTVE5r0jeeEZqsMWwM/sNRgchoD4eNxiSsskfYGy7XXb+ViWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716950534; c=relaxed/simple;
	bh=C1ba4R32jN/gAJLdPxQ//q31hQ2z9jv2bi85Oyw4vXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RlYpKeqZSTQr9We5LHlpxbBA7zuUApBG5nLBdzr6Ect1tv24SMiLapD5kUJqJLnpT3EjE4qiUadwzNsYGgTQM+exnixWuU25aXhlSLuWZ0Llnegq1EjogAsBuZw9A+CDazqG1B5T783afM0z24jQDCG9g4Vzq92v1af+jdYsUus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZMQBSq1l; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5b335681e82so235380eaf.2
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 19:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716950530; x=1717555330; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=08e0ps5MM/FCl+fgkLYesxOA+Pbr/1G6pkJUz60G3yo=;
        b=ZMQBSq1luIHkxBmCKBiSOsIoCkOYCrz67V5L7CYSBIccq70CxVyGQsWOAkUORv7G2r
         vGZ7yx9K0Azj7MQyaCrpUWlm+gI7JX/44sw3vLC1B86sLFE9ehWNp7i4Q3RApPkVHRpa
         OvV2L9AG+jqmQVyESqHZljz2BzgHofpPspAWLvqwWnnWswABcjcktBLm+z2lIHF4gzVq
         sbI8S19kJSkrxhri6xZNn3Vfx1zEYIWGaUwf0AD7AMsdYf2PrVdrGaHqNKpsGU/WCXqi
         2dMCPU3SbPOk3mP2wx08woNW1X0xiOhldiHc81Ez86gYJ44U2gSrFxD6GM9JniURK181
         YSIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716950530; x=1717555330;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=08e0ps5MM/FCl+fgkLYesxOA+Pbr/1G6pkJUz60G3yo=;
        b=AuMdYjq4U2MX2Rp3816Cj8Jt4ru/FggHZ3QU/qLDjg6Bt/JLJPG+XF2ELvg70Wg6aP
         AMX3XfEgEnlpto7926jH8UUWV2s4PAYTmC/TSKh45itd7fro6KRGss06JUxm9glR7YMM
         GSAMpec5zB0coSNFtZ911uG458icSE5ejOlSQ4tF8pYkOyuMZtSvvyWjIhjV052gjBP2
         Xj+GrdlI6bbGwfTu6jV55mSilQZfPM9TOeZfQ7/eBkiMBb7QNSeZM7LPsY3Bib878xVp
         OIy1OVADvb6h/w3Uz3iEwdku/VjxQ/Mz8oc9l5gtwX6D843BJD9UH1SNHkLjcD7gOt12
         hZwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJoIVABg8JOjAhUtIC/005qX1SYkKi+vm8xaAyTKmN+E2i5nDFksKQ16PDvQPPkc0oi1fBEQssvPK7TS2ymaYT5BrU0DzqM98=
X-Gm-Message-State: AOJu0Yyn7soAVwTpRPktXDYGF5TQlmexl6EsF20g2fqD2dWl8e/7GiWa
	KSnQ6E9WIb/622GR5G9mnRfU3rwnL5ge84I3uEXdKh9EhZjhmxD0ewteCltD+Yb6rZKr+DqCv64
	M
X-Google-Smtp-Source: AGHT+IEyUSDK9oHQQ8Qqx/MQuTQbh4ITVIc6hY7O2PHBgGiIzw+zIv4+kUbGWJ9YB8kZH2WC4bQfQw==
X-Received: by 2002:a05:6358:716:b0:186:6e58:d81d with SMTP id e5c5f4694b2df-197e5677731mr1484273955d.3.1716950529813;
        Tue, 28 May 2024 19:42:09 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6822198a7e3sm8200133a12.34.2024.05.28.19.42.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 19:42:09 -0700 (PDT)
Message-ID: <3d553205-0fe2-482e-8d4c-a4a1ad278893@kernel.dk>
Date: Tue, 28 May 2024 20:42:08 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/3] Improve MSG_RING SINGLE_ISSUER performance
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240524230501.20178-1-axboe@kernel.dk>
 <3571192b-238b-47a3-948d-1ecff5748c01@gmail.com>
 <94e3df4c-2dd3-4b8d-a65f-0db030276007@kernel.dk>
 <d3d8363e-280d-41f4-94ac-8b7bb0ce16a9@gmail.com>
 <35a9b48d-7269-417b-a312-6a9d637cfd72@kernel.dk>
 <d86d292a-4ef2-41a3-8f54-c3a1ff0caad7@kernel.dk>
 <6ceed652-a81a-485f-8e6e-d653932bb86d@kernel.dk>
 <18a96f04-bb30-4bd8-82ca-e72f1c954dac@kernel.dk>
 <377bad85-032d-4906-9142-d7be5cae9dcb@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <377bad85-032d-4906-9142-d7be5cae9dcb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/28/24 8:08 PM, Pavel Begunkov wrote:
> On 5/29/24 02:35, Jens Axboe wrote:
>> On 5/28/24 5:04 PM, Jens Axboe wrote:
>>> On 5/28/24 12:31 PM, Jens Axboe wrote:
>>>> I suspect a bug in the previous patches, because this is what the
>>>> forward port looks like. First, for reference, the current results:
>>>
>>> Got it sorted, and pinned sender and receiver on CPUs to avoid the
>>> variation. It looks like this with the task_work approach that I sent
>>> out as v1:
>>>
>>> Latencies for: Sender
>>>      percentiles (nsec):
>>>       |  1.0000th=[ 2160],  5.0000th=[ 2672], 10.0000th=[ 2768],
>>>       | 20.0000th=[ 3568], 30.0000th=[ 3568], 40.0000th=[ 3600],
>>>       | 50.0000th=[ 3600], 60.0000th=[ 3600], 70.0000th=[ 3632],
>>>       | 80.0000th=[ 3632], 90.0000th=[ 3664], 95.0000th=[ 3696],
>>>       | 99.0000th=[ 4832], 99.5000th=[15168], 99.9000th=[16192],
>>>       | 99.9500th=[16320], 99.9900th=[18304]
>>> Latencies for: Receiver
>>>      percentiles (nsec):
>>>       |  1.0000th=[ 1528],  5.0000th=[ 1576], 10.0000th=[ 1656],
>>>       | 20.0000th=[ 2040], 30.0000th=[ 2064], 40.0000th=[ 2064],
>>>       | 50.0000th=[ 2064], 60.0000th=[ 2064], 70.0000th=[ 2096],
>>>       | 80.0000th=[ 2096], 90.0000th=[ 2128], 95.0000th=[ 2160],
>>>       | 99.0000th=[ 3472], 99.5000th=[14784], 99.9000th=[15168],
>>>       | 99.9500th=[15424], 99.9900th=[17280]
>>>
>>> and here's the exact same test run on the current patches:
>>>
>>> Latencies for: Sender
>>>      percentiles (nsec):
>>>       |  1.0000th=[  362],  5.0000th=[  362], 10.0000th=[  370],
>>>       | 20.0000th=[  370], 30.0000th=[  370], 40.0000th=[  370],
>>>       | 50.0000th=[  374], 60.0000th=[  382], 70.0000th=[  382],
>>>       | 80.0000th=[  382], 90.0000th=[  382], 95.0000th=[  390],
>>>       | 99.0000th=[  402], 99.5000th=[  430], 99.9000th=[  900],
>>>       | 99.9500th=[  972], 99.9900th=[ 1432]
>>> Latencies for: Receiver
>>>      percentiles (nsec):
>>>       |  1.0000th=[ 1528],  5.0000th=[ 1544], 10.0000th=[ 1560],
>>>       | 20.0000th=[ 1576], 30.0000th=[ 1592], 40.0000th=[ 1592],
>>>       | 50.0000th=[ 1592], 60.0000th=[ 1608], 70.0000th=[ 1608],
>>>       | 80.0000th=[ 1640], 90.0000th=[ 1672], 95.0000th=[ 1688],
>>>       | 99.0000th=[ 1848], 99.5000th=[ 2128], 99.9000th=[14272],
>>>       | 99.9500th=[14784], 99.9900th=[73216]
>>>
>>> I'll try and augment the test app to do proper rated submissions, so I
>>> can ramp up the rates a bit and see what happens.
>>
>> And the final one, with the rated sends sorted out. One key observation
>> is that v1 trails the current edition, it just can't keep up as the rate
>> is increased. If we cap the rate at at what should be 33K messages per
>> second, v1 gets ~28K messages and has the following latency profile (for
>> a 3 second run)
> 
> Do you see where the receiver latency comes from? The wakeups are
> quite similar in nature, assuming it's all wait(nr=1) and CPUs
> are not 100% consumed. The hop back spoils scheduling timing?

I haven't dug into that side yet, but I'm guessing it's indeed
scheduling artifacts. It's all doing single waits, the sender is doing
io_uring_submit_and_wait(ring, 1) and the receiver is doing
io_uring_wait_cqe(ring, &cqe);

-- 
Jens Axboe


