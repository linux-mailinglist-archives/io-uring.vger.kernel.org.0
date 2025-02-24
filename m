Return-Path: <io-uring+bounces-6723-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9339A43030
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 23:38:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4F3E3AE8AB
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 22:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 582E419B586;
	Mon, 24 Feb 2025 22:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rvfM2/rO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDF81F5FA
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 22:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740436730; cv=none; b=N3lxY9SZXGdpvAVvJwE7yDwmjph3RKr7pBGHucrIdiCUlaQYCLJoEyiJnQK3cQPJxyG4beDUmioIc9uoEDkk18hYuQNqhqX4sLrzljsuVXOTg6oQeQr2yegnEP/fn5a9fMkzsRMfuz2CkOt3f/30kifWUpH0+6RZI7dhzLTFnKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740436730; c=relaxed/simple;
	bh=1532iGWN0IEg5xaTzIgNih2/rgjtLdWlY/rMH2+Nwzg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IX959u9YPnMzm2oCadVrB9oelsKwUZiVbsaUqqqoy6RxsN3cQfRKhReStFF32WTqJf8SKbX4fbkHOO2yNSSkiG1+Z0sdygvkHma4bKxwuZlw+K5uZQ/6IRKWCDVFX0KjtzwoeOPB+jfBkmJD6SEWdfhbF/fDXls/U0i/MOOlCnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rvfM2/rO; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3ce868498d3so14350605ab.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 14:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740436725; x=1741041525; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HKpFLj4FG0iU02bCfQsJzDd1HU3OS1T4WFmnFbYL14A=;
        b=rvfM2/rOqHE5IF/wdVqg62/NAqzN87p3nVSo9fyVfw3MO/fiYemtXIpsd9W9m8GwLZ
         4qpIF/N9EHuUfiEk7sARw/xKQU8b6cgGhvKAzE1v2yETG7SS8kumiwe2rFhEKdPQ3myQ
         iHvAUC6q8JrlHvbPDN2WRR8N8CAt8KAsKWp1IooUsYfsCQUsIKSavZtRzuyKWW5heZ49
         aqoHFzUIDX9JB0JeBUcfRc9sJ7rTNPIp+CpHfSSMejGCKTuUuStwBSoFySmyHD7X+m5p
         sqh77/hi6/H998Wwtu+va3Ry6BDUdpnvJHMydVYduZHAsTudikDwQzgGaD684uqk7K8m
         uU8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740436725; x=1741041525;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HKpFLj4FG0iU02bCfQsJzDd1HU3OS1T4WFmnFbYL14A=;
        b=BRLTUjsaJE87XwsINUCgOU8xvfN8qgxncy28O6i4M9w7bryohma5rJz1S1LIUatUQ7
         m8VgJgsK+P8AcA+1sni6PDXhfrEaKSfjsNhr1tjam39WNHYrlcNA1In4i3BTmWorDjAz
         SgrcUU1r7a6UqiI9rBQTVCiw+RWWDQomD+YuUiJLg5GgvXPIaGOGvJzICsP42QkZ3i1r
         vR/OuEwu2o7SaOr+VjFA90HxSMFMaYsN2+nHE9wMe65yhTt9Q3dzNsI2o8JhIM2bseua
         e3HdIXLLN5VWqB9o9hPHNvJAD8Lnril3vVu/AAioSKtdoETKYmN7pbk5+7JBUD4TLF50
         LYXA==
X-Forwarded-Encrypted: i=1; AJvYcCWtOeeUa3LRi17vb/xl90e3ZOtNoS8iPKYCuQO11F/Bft8rTPAWOBTtDCJwSyS1ScKL/C2r9pnCJw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yytm7nhSBQagXA1Be9avjp8aqfxArRHgVVZGPiwukBrLVNPIlSg
	yBT93jQW5+Y+hxZsx7PDK3I8t1r47fIKmictXvm3lB71o5f1UvmhrQ/OSSPM1K4=
X-Gm-Gg: ASbGncuJQ0lo+iNQGwcPhg7UZAmt6K92I2kbISy1XNGZAf1/53g0Sq4PaWgMsnl/YNV
	Z/iq0MAGxMtbQs0rLjXRQeJrzLkVyR16a1jxan1mDN7uFDQjFVmOYTi+9aREArX2Tzm72Dk5J4F
	VtspOeOA2ieKTptWjvk57psFELtsw5vlE1F6fuvL4Y8T+UDAEb3MMK853plTBVgauzfBLzaEZXV
	zfT5MxAxWnUs25N5XJqT8aT06xuWrCQZS/TipjMMnpDEuAZCvtj/nE+aoAZy3YLDrIZvseffzGk
	SzIi7w4X3QpsPk0JCeOmU9c=
X-Google-Smtp-Source: AGHT+IFw5KPcc7ysYzMiIpyApNNJMBoEKvcPjCfgDeBP5tJmeyDbd/vB8SBQM7Er8BKaxz6zI/neaA==
X-Received: by 2002:a05:6e02:1d95:b0:3d2:af07:c8f with SMTP id e9e14a558f8ab-3d2cb4502bamr136151005ab.7.1740436725437;
        Mon, 24 Feb 2025 14:38:45 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d367feefa5sm653005ab.59.2025.02.24.14.38.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 14:38:44 -0800 (PST)
Message-ID: <6df285ea-01e6-4b13-b9c7-1f5ed01b942f@kernel.dk>
Date: Mon, 24 Feb 2025 15:38:44 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] io_uring/zcrx: recvzc read limit
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, lizetao <lizetao1@huawei.com>
References: <20250224041319.2389785-1-dw@davidwei.uk>
 <174040774071.1976134.14229369640864774353.b4-ty@kernel.dk>
 <17c27735-a613-4bd5-89df-645ae7ed83a2@kernel.dk>
 <531efbe5-aaf1-47a4-b5d1-a5c5ce9156cc@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <531efbe5-aaf1-47a4-b5d1-a5c5ce9156cc@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/24/25 1:33 PM, David Wei wrote:
> On 2025-02-24 11:56, Jens Axboe wrote:
>> On 2/24/25 7:35 AM, Jens Axboe wrote:
>>>
>>> On Sun, 23 Feb 2025 20:13:17 -0800, David Wei wrote:
>>>> Currently multishot recvzc requests have no read limit and will remain
>>>> active so as long as the socket remains open. But, there are sometimes a
>>>> need to do a fixed length read e.g. peeking at some data in the socket.
>>>>
>>>> Add a length limit to recvzc requests `len`. A value of 0 means no limit
>>>> which is the previous behaviour. A positive value N specifies how many
>>>> bytes to read from the socket.
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>>
>>> [1/2] io_uring/zcrx: add a read limit to recvzc requests
>>>       commit: 9a53ea6aa5c87fe4c49297158e7982dbe4f96227
>>> [2/2] io_uring/zcrx: add selftest case for recvzc with read limit
>>>       commit: f4b4948fb824a9fbaff906d96f6d575305842efc
>>
>> Fixed up 1/2 for !CONFIG_NET, fwiw.
>>
> 
> Thanks, and sorry for the noise. I'll be sure to compile check
> !CONFIG_NET next time.

Easy to miss, and the kernel test bot always finds them. So not a huge
deal.

-- 
Jens Axboe

