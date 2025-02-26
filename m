Return-Path: <io-uring+bounces-6770-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E795A452C0
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 03:07:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82AA217CF4B
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 02:06:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64D5F20E019;
	Wed, 26 Feb 2025 02:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bxm1Dd4L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AA9215F70;
	Wed, 26 Feb 2025 02:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740535559; cv=none; b=WFquuAePv2hFH1aGuStFYE0zoBcmzPFYVgg5x8+tsffiq8XcfDrEZyTDY60JcvMoGf+okEiHQoVZnPyLFxo7C2hyTImAXk9tlbDOK3Q6oE2phswPKqG+Bdb8ZsKXpWK6xXDksh2VFv1+/ZOWaXAaZ2nNQNyRMrFnf40XOxRH1zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740535559; c=relaxed/simple;
	bh=k3ryp968t0B1qeuEWvZoV99DEvfPQ5eZLMa+7wkzkqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DFOQC0fRChLWTcZpVzswrDZWjSN91GZr7sdiYe5dQmD1SklHZACDrbRC13Olw9lmuvvieuDyfWnbqHlMGLYgLD0s2KEBk1zF6aqWWnao2xiu0GMDWhs7/PlxvtmQX5PNP9p96571vlV3khLojdffkBqsgtoq0Wv01zXxKitPttU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bxm1Dd4L; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5e08064b4ddso8469486a12.1;
        Tue, 25 Feb 2025 18:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740535556; x=1741140356; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eL6L4DeYwJ9sxA0vCjH7I3ZmrikTzb+BZffZihcrw0o=;
        b=bxm1Dd4LTNx0Uur4WU4lHKUa3m3BlUzhsaLmfgSzDsryP4FgX4/4TRwtHxWcR8ZnWA
         mhtp0hGs2xH6zf9nMegbJV2MDWa5j8duc5G7njj3w5J4HIAVkEA7KBRrjcATIvGebBcW
         eoVvs02KLaRaBxWbLW/+WoIXhcC11NITimbyvwl4OAuVDKk9m8Hwrm4kWJGPdaX8pTcV
         H2Qose8dEAtmg8L+Ok51q8E1U6/mUlauIUrBJhkHlK0c9/pO+VwmAu+W/eoA/zft7gEc
         ExQY0/D0g4CdhEIbzP6MFDve0n4WOiXgjz1785N1WoRE9DSBq7ifKrIg2BKJsO61qTlM
         +fmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740535556; x=1741140356;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eL6L4DeYwJ9sxA0vCjH7I3ZmrikTzb+BZffZihcrw0o=;
        b=qfJyywb+smm0VcmdBzih260L3gg6U41Jqt2JO8IUHDAFqRh2U/wS3nzzpNCMGCWHmR
         3o5w1nQh2B9/LeOZi5Zm2VVdTcqR47lY33kO2FUNJ15BXGwoQDtB6F9baIEg2wT9Us3H
         V814sovLmth4bCdX/72s2pbBvTtcbtq3lyhJST4dbIA/jgTZ3ag0Hj/sMqxz8RO9gd0a
         0HTvqQfLjskQDvAHJfcKs2cDKdGYHRNQic7mH0cYUi9mGv5yWlHWVJoKweICZoIUz289
         9ADGwEJ42ldbhoFIdYbE9XmFKZ7+iiHzNCybYnyuPkKtOZ6d32f7za69md1NxsG+KzO6
         eRKQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8PSouuKDDQ0wbkzBU/1HQKrt8ORBm9YgRZGwCrP7CxDJjSqZKgRIHFO03xpnGfOMRLGKwPqs4953Y29sW@vger.kernel.org, AJvYcCX9ANWN71dul5Gkp7VT9mkVCn2Z9bu5ig/QJREr6udUAJcobWZjUvQB34ZkklLlb2Nh4eJOgszm3fMD@vger.kernel.org
X-Gm-Message-State: AOJu0Yz++zHASNk9xVw11g6TntK0mhwfkg6vKo5o0gWyFvZvAMdgNVT5
	fluIN+dbF9NfPqBNuqBcgEeiNkLNSjPvgjswkiVf8wiL8BaRURGsKe9s5A==
X-Gm-Gg: ASbGncuZ6yKTWzKa5p53yoOJFhc7t9XuP/RiZMtDAiTMBF1eRgzqejYn913nYZtIWgZ
	tGhNPDTMZoDSH5liCPbiTYoby5CZa2sONvlsEWkyT6beflwibT2niv7GVg/tIucga1ZpY70eY2V
	RIvmdESsF0W/VhuFlRItv14gTatrT8UyXqC0aP5ifHTnkvMfozuzFoXF0aItgUX7lH9Ghra16O3
	cSi57lJ7FZvIsMvWHoxsDP24q2yLbPiCgOzvqDdKmDE4t8hv5db7pxZ0MYni1cFmONOwtgYKtrO
	oEy7DXMntiDEF1O7zv0JGgdifRVLLYh0RA==
X-Google-Smtp-Source: AGHT+IHqh28/8ueONO3Zka532nMhIgT0EI7NUqknxX1mZRWJzLvIyM0LR4zRncMU1zVI0C7mpcm4HA==
X-Received: by 2002:a17:907:94c8:b0:abb:e7b0:5453 with SMTP id a640c23a62f3a-abc0d98781bmr1596812366b.12.1740535555592;
        Tue, 25 Feb 2025 18:05:55 -0800 (PST)
Received: from [192.168.8.100] ([85.255.235.21])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1d5b39fsm241678566b.69.2025.02.25.18.05.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 18:05:53 -0800 (PST)
Message-ID: <543f34a8-9dad-4f63-b847-38289395cbe2@gmail.com>
Date: Wed, 26 Feb 2025 02:06:51 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] iomap: propagate nowait to block layer
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: io-uring@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 wu lei <uwydoc@gmail.com>
References: <ca8f7e4efb902ee6500ab5b1fafd67acb3224c45.1740533564.git.asml.silence@gmail.com>
 <20250226015334.GF6265@frogsfrogsfrogs>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250226015334.GF6265@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 01:53, Darrick J. Wong wrote:
> On Wed, Feb 26, 2025 at 01:33:58AM +0000, Pavel Begunkov wrote:
>> There are reports of high io_uring submission latency for ext4 and xfs,
>> which is due to iomap not propagating nowait flag to the block layer
>> resulting in waiting for IO during tag allocation.
>>
>> Cc: stable@vger.kernel.org
>> Link: https://github.com/axboe/liburing/issues/826#issuecomment-2674131870
>> Reported-by: wu lei <uwydoc@gmail.com>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   fs/iomap/direct-io.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
>> index b521eb15759e..25c5e87dbd94 100644
>> --- a/fs/iomap/direct-io.c
>> +++ b/fs/iomap/direct-io.c
>> @@ -81,6 +81,9 @@ static void iomap_dio_submit_bio(const struct iomap_iter *iter,
>>   		WRITE_ONCE(iocb->private, bio);
>>   	}
>>   
>> +	if (iocb->ki_flags & IOCB_NOWAIT)
>> +		bio->bi_opf |= REQ_NOWAIT;
> 
> Shouldn't this go in iomap_dio_bio_opflags?

It can, if that's the preference, but iomap_dio_zero() would need
to have a separate check. It also affects 5.4, and I'm not sure
which version would be easier to back port.

-- 
Pavel Begunkov


