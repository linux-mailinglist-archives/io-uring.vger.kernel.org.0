Return-Path: <io-uring+bounces-7455-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D95C8A860DF
	for <lists+io-uring@lfdr.de>; Fri, 11 Apr 2025 16:42:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 273D11BA43A6
	for <lists+io-uring@lfdr.de>; Fri, 11 Apr 2025 14:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C752A1F8BBD;
	Fri, 11 Apr 2025 14:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zqQ7ZR2H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D201F4E39
	for <io-uring@vger.kernel.org>; Fri, 11 Apr 2025 14:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744382324; cv=none; b=b62oyG92auvoYmKOkHlPLf6fULBbB1J/xk2kZfYwD7MLUg/Mvj5cRhhpJ4NgYyAxy/30ObUQyFUXZ/N8DA5jLW1wfUZeK/Jn4AR0bMGNpbhkGl2Ag0uxowOkFEgaN71c85D1HIeEmdx2zI/8pMgdJu8o5sAORd5jo3gWmNX8D3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744382324; c=relaxed/simple;
	bh=Py9b0n4Spd9shv3fai5ExlcWtULnhO4HY6RbmcW7zII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GMlc1++vQQwCEf+WlFyOdIHBuH2+7nqF9kj+riXHo8qT7YFtvhpywKWaFCTmNLiNdmgEGKkC2yxVcJk0x/+JNjHVfo5m4T3FtkQV+fm5B1OG0XWV0JsIpUmSElsKzipd8BiI8U14aXAfp80FakHPnTTE52D81TEZ6OOewUGNi94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zqQ7ZR2H; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d57143ee39so16169495ab.1
        for <io-uring@vger.kernel.org>; Fri, 11 Apr 2025 07:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744382322; x=1744987122; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KNF+SaysF6jNI8dZrqbzXabPIIgPY99/j3AARUIR4IE=;
        b=zqQ7ZR2HnL5e5cpQSP44uaZZZhMfWv8FduSiO/mPZeumWOajPVa8CH3ifXV7shKXhC
         qNOJAVwyyUuJGf1qm6MerXAkQsQzKRC1DMkV+z/e13qxP78aXLJO2+h2MXbFQn5dCDzX
         +Irpdraxc9F35SwIOguSxfF+EonUAusaySoavB7n8wsA5I9blh3J2wVLw4ijaQkh81gK
         KmLu4ZzpDAoACPZsT0/3S/YBEMAfAyS3u1FQ9OB62lsD5PxJePyl6WRj6dVwzUhUcv3/
         AzMCD2guXTp7CY2KVIJTykDdVG6BsyW28gD41cHf0eJwLg/JpdPpIuKtvDvcPEHxNzYF
         Imvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744382322; x=1744987122;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KNF+SaysF6jNI8dZrqbzXabPIIgPY99/j3AARUIR4IE=;
        b=ubJy6Un57hu26B60SFf4DldcwNFTSZ3OEDACllZ+F9zQfSmXuvJRrqsqrYK9zg1l87
         O34kgmQgBL33vfeIAS0cG2BGGeHppMlbdmQnCy5xsiHUzF7B9eXBlSFzbeEZaAKTl666
         MqgB6ZLf2ytrMbkaXcTo1xVlexBFNK8itQe6bHw3ooqxSGXSB6NvsEXVxbdKOZyQeuHq
         ZwMSyW+ExsF9cTlYMYkgPpSWafur2wA8MKxJtRqO/wCkyzRQAybppMcTCZkSU7WK3Pv0
         bWVlvnnSx/WATZJ3gc1j51FF6wgfY+JwpCLk3evjvPcnpKchnBfN5E5/LVpUg5cbXgXH
         X7ag==
X-Gm-Message-State: AOJu0YxZf70U7cidBCNVYH2/E8lsciMxcQpze+xXcVeWMMvS4hs3VpyO
	nQagBtj6parRJpkfQTInPtA/p3v85Ls5OVj4zETDM4M1r697iiWDCxk+RIqAguc=
X-Gm-Gg: ASbGncsP3t+GECAag7dMF1XSwx0LYDG6RpzfhxMbgYcncIDBfhT3p2KO2GwyHbIZRCz
	CZwaBeoM4epQIcBghQOzAlMtgVVjOgK8KoefPKviqyKc3a2Sh0iEjg4uEycSykEJxiRnCnPO1Hm
	bTlHUINkigwKBnyZGmANC4SdsaaJjiGC8kg9wqYyJTzFl/llP4WAFXDpp7tUEAKXL4U7QUKfIeI
	k/4mPTj7Brap491Xtkdp+uBRDLPmv1Ikg1SKLmB5VHrGklmZUc+BSudiFF25b2C6Yk6OKLB9BIt
	ZWmXxdkNH6z/8boXg2px04Y6J2IT8CGHrrZj
X-Google-Smtp-Source: AGHT+IHWG2XNU8wzo30/FH8LklgCUykZwxlTb/VPatdqzr91/hnlg09zYQXj0kiL2LwG+EuYKyU4Zw==
X-Received: by 2002:a05:6e02:441b:20b0:3d6:d179:a182 with SMTP id e9e14a558f8ab-3d7ec26fbcdmr24090815ab.20.1744382321971;
        Fri, 11 Apr 2025 07:38:41 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e2eaeesm1282118173.126.2025.04.11.07.38.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Apr 2025 07:38:41 -0700 (PDT)
Message-ID: <02f8fac0-1ddd-409e-a5f6-c7adf7d10a03@kernel.dk>
Date: Fri, 11 Apr 2025 08:38:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] io_uring: mark exit side kworkers as task_work
 capable
To: Christian Brauner <brauner@kernel.org>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com,
 linux-fsdevel@vger.kernel.org
References: <20250409134057.198671-1-axboe@kernel.dk>
 <20250409134057.198671-3-axboe@kernel.dk>
 <20250411-reinreden-nester-8cd21e845563@brauner>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250411-reinreden-nester-8cd21e845563@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/11/25 7:55 AM, Christian Brauner wrote:
> On Wed, Apr 09, 2025 at 07:35:20AM -0600, Jens Axboe wrote:
>> There are two types of work here:
>>
>> 1) Fallback work, if the task is exiting
>> 2) The exit side cancelations
>>
>> and both of them may do the final fput() of a file. When this happens,
>> fput() will schedule delayed work. This slows down exits when io_uring
> 
> I was a bit surprised by this because it means that all those __fput()s
> are done with kthread credentials which is a bit surprising (but
> harmless afaict).

Sure hope it is, because that's already what happens off the delayed
fput that it'd otherwise go through!

>> needs to wait for that work to finish. It is possible to flush this via
>> flush_delayed_fput(), but that's a big hammer as other unrelated files
>> could be involved, and from other tasks as well.
>>
>> Add two io_uring helpers to temporarily clear PF_NO_TASKWORK for the
>> worker threads, and run any queued task_work before setting the flag
>> again. Then we can ensure we only flush related items that received
>> their final fput as part of work cancelation and flushing.
> 
> Ok, so the only change is that this isn't offloaded to the global
> delayed fput workqueue but to the task work that you're running off of
> your kthread helpers.

Exactly

-- 
Jens Axboe


