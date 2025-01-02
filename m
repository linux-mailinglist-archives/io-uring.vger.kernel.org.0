Return-Path: <io-uring+bounces-5652-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FC0C9FFE0D
	for <lists+io-uring@lfdr.de>; Thu,  2 Jan 2025 19:25:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06ADC1605E1
	for <lists+io-uring@lfdr.de>; Thu,  2 Jan 2025 18:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B77815573A;
	Thu,  2 Jan 2025 18:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="O+DbvVDn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F023815E5A6
	for <io-uring@vger.kernel.org>; Thu,  2 Jan 2025 18:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735842306; cv=none; b=uoXm5lNdla8B3/nT0nTyPqiusi0fsTf1FlIybwk/sUewIuZYFqLDdxqeOBvzNLUbLKVDekLM9ic+FVMLTOiqy1tDYUk9FHA/ehx6uAktPykdMBPOge9r/fAMIm2KRAQM2pJjvgNoFKK+llhtL8ol1oTA8Da6LLnoZVXln8sWhrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735842306; c=relaxed/simple;
	bh=3oFr9Shh5I6VVSMkpyA2Ct97Tg5lMpID/SPTorJVF/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dfNO2YYdeOpn+Oq4A550G0TIpgXtUh7ogUpOJybm2wYpT5BGlsggwzhHueEhduhy5S+4XDvUNJpQS9EKXcXQqMSkcc5dPoi2BuXahlL3qj6gcWUTf77Qswn5vvbunUI/aDgPhpMYmFzE9/CQNy9RGtmNULRNXa7jTOGiss++jNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=O+DbvVDn; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-844e9b8b0b9so926390339f.0
        for <io-uring@vger.kernel.org>; Thu, 02 Jan 2025 10:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735842302; x=1736447102; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kHsjmEaryOKI685WZ7lu5KUQeAoU/XtJziJDhY5ui5g=;
        b=O+DbvVDnixA17kHaPKmQ13lDtz81xoiUwntDZuhPAgnCB6GyqnZ1cO0ZW/a96bhif2
         814CdJ+5bRWc4nQ02VkawCiUMnTxzhB8cQFBAlc2ouWIw3rIODYVPk4ZfWDTssypr46R
         StiF+bjJMxrukx6RkYwkQPSZuUUkhKDjKjS3NHanpVvsZOaemHGrm8lFbWwJMFbMlWdf
         3dk4bVHk/r0HIieTtfKf9Lp31Lr07iNJJQPi43gZFJDMIvOyeaO9hYR5fRPoBD62Ieq1
         0G6R9RrHvrhqfjUqRxVPIV4sq0bFA7pO8SX1zWC7AJaXhcsOH1SH2zT8arj37CB3zPiR
         qxPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735842302; x=1736447102;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kHsjmEaryOKI685WZ7lu5KUQeAoU/XtJziJDhY5ui5g=;
        b=ers4iK5DNuLI+3aSI2jXuOLDIPhDAxSG2RMk7Epaez0CG0TbWWCyONamhyQ6cZJZUH
         C1aJE7n4DCRF66VoyOGb0hweszSIeTv5SqbAACyRr9hUaGP2oucnMV87pY0nCYnHsgIg
         1hDGlt7QpjV+W8Ysy/qWlUMS6FN2S6O4NsipMQ3Bv65og7FSbo//EQIJfX+aw23WIry8
         oFNkzyUFWMe+Mg/1CUeAGfCVkKnHFWlHqqw0060lw0bmH2zvZzyYozfiK+P9nqCcFvn6
         A37UJRVsUqvqXN6uleq7PSoRZB2BN2c69TtMrLuQID3NDwq7xRF0ekjFoZmQLiDI0N/u
         7kkQ==
X-Gm-Message-State: AOJu0Yz0jxWy6VSWd7ApsdwLJNRAExIf4DhQC6iyDyehmF9JLbrXeCJm
	hqzG0Zim5h1R9AVSWNpf2kMuf3ZE4+w4Qneo5iz05Ar0hh88BSyN3tFeRUwUmo3bYn3hjmqmHxJ
	U
X-Gm-Gg: ASbGncv7YV3GL0DKRobicE35X6OwD/wpEIvo3yH3eHo5kGP8FXhM4MW9erm7j/Xzfoc
	BOxzcy4WS0hqer/qCchTPFK/iKAcv27eLDuh2pSfKwb1m7GZZFEncxNwZbbnVVLUjZXK2l/4w+O
	Eu9FpQ1iUfqp365GvHqCYlRrcXgELPJv2amAg4Lx9/4ZWX3UvyI8O1NP0RfG0KDac0lHbWRBi8I
	BNE4mFOZh1niD/WxQeyeqcNHXX3EmhGZmHSw+Xgv3rQ9wLqB8Xd
X-Google-Smtp-Source: AGHT+IHt5iX8oylyMO48tJasCNtWFIDPsPUr3r41quY1OM/fKCqCRjnn+7oqCcuKdwUaFkHXUiMgug==
X-Received: by 2002:a05:6602:2cd1:b0:83a:97e7:8bcf with SMTP id ca18e2360f4ac-8499e658743mr3154875039f.11.1735842302025;
        Thu, 02 Jan 2025 10:25:02 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8498d8eb3cbsm674316339f.46.2025.01.02.10.25.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2025 10:25:01 -0800 (PST)
Message-ID: <4b310cfd-b2e7-4fc1-964c-02c6741011bb@kernel.dk>
Date: Thu, 2 Jan 2025 11:25:00 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1BBVENIIGZvci1uZXh0XSBpb191cmluZzogZW5z?=
 =?UTF-8?Q?ure_io=5Fqueue=5Fdeferred=28=29_is_out-of-line?=
To: lizetao <lizetao1@huawei.com>
Cc: io-uring <io-uring@vger.kernel.org>
References: <c1596f5f-405b-4370-997d-f42c8303c58c@kernel.dk>
 <9b1201df8c2d4f8cbe957c57deac2f95@huawei.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9b1201df8c2d4f8cbe957c57deac2f95@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/2/25 5:38 AM, lizetao wrote:
> Hi,
> 
>> -----Original Message-----
>> From: Jens Axboe <axboe@kernel.dk>
>> Sent: Tuesday, December 31, 2024 8:37 AM
>> To: io-uring <io-uring@vger.kernel.org>
>> Subject: [PATCH for-next] io_uring: ensure io_queue_deferred() is out-of-line
>>
>> This is not the hot path, it's a slow path. Yet the locking for it is in the hot path,
>> and __cold does not prevent it from being inlined.
>>
>> Move the locking to the function itself, and mark it noinline as well to avoid it
>> polluting the icache of the hot path.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c index
>> 42d4cc5da73b..db198bd435b5 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -550,8 +550,9 @@ void io_req_queue_iowq(struct io_kiocb *req)
>>  	io_req_task_work_add(req);
>>  }
>>
>> -static __cold void io_queue_deferred(struct io_ring_ctx *ctx)
>> +static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
>>  {
>> +	spin_lock(&ctx->completion_lock);
> Just a digression, whether the io_uring subsystem welcomes scope-based
> cleanup helpers, this is somewhat

We welcome any change that makes sense :-)

For this particular one, no point having io_queue_deferred() marked as
cold yet still inlined, and no point having the locking outside of the
helper as that gets inlined as well.

-- 
Jens Axboe

