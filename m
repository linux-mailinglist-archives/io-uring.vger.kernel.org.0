Return-Path: <io-uring+bounces-8155-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD5DAC90C6
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:56:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D625167C3F
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C5E622A811;
	Fri, 30 May 2025 13:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oe0albk1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C530B12D758
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 13:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748613383; cv=none; b=fQFiKAmtIV3j6ZolvQNPRQMXwFLb64OnwSZIkGxIjcMMS/AMNsl9kb4b3KiNvqu/+RFVm/Oiz8nDmD08V9cfhlS9RZZnFzcWn5U96/574+lWgJeQck39Oduo2lCeK5BdYzIjGjXRcHf/Z0A2uYa8eQrG+/yfGNwtf/KR5Udk0l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748613383; c=relaxed/simple;
	bh=5qL5/Z1Hz/sRpndGxX8EAPnvuKYZQTRXavy02HplYFw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kcaIku7hWz9/Il5ug3C49XXdcLILnu0+wTMiiyeNKHEN8Tt4z6FI3oHAr1Opxv2XntjMC6fcxc9ZIVsCdxwKlzkQR9gC6aYP4PHDXTMwKkjEC2iK1yuP+xxoRm3L1gQUBWCqALXUHeI24lXVJbNuKcPc+BJSGSnejxSya6kJrFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oe0albk1; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ad5273c1fd7so425847466b.1
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 06:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748613378; x=1749218178; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KVAK1oaLM+/4Empv+rU+alktw3eoKHIc+iBjTojin5w=;
        b=Oe0albk10/PD+ukV1vIOkB5TdbuDeEIderJymLmTJX1T+4Batz3VS3Ir7Cfg9MVWLR
         RXMUG4KFtm7nrEsOEe4NEhwF+LDoOEZ6t3++mEnVk6ZTy3W4e4eC7tjsPsELIFP2lCOA
         u2AouurYq/dgIQPyeFeos1+RwJYVwLEAMb7LAaWIW7wXT/kFoROrvmn/EOdbTJ51QL66
         OverliXE4hDbUrb62WNogjhUi2lT09uzRpvRXcRx5N00HcWrE8YsmbgPVK+GyoETqhbt
         0RimPE+D4lHec642MJ2861iB3UdqSJpjWKDH6JYpQGbib5L2gICLjuY2reE+gjxJEAnP
         RAWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748613378; x=1749218178;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KVAK1oaLM+/4Empv+rU+alktw3eoKHIc+iBjTojin5w=;
        b=Taqe9LXwR7h4Nv7moZylAGMTfN7k/6wWVXR15tVPkOq3ah8HsVXbYT5l6v/yTRHFkq
         AHmcjYlV2CrAxrxWmPSpAZjAU0PAPSoABo7rRrIQX+G9T3Bouib7l//mBnGQ2IPL1I2B
         SdImhwOJXBQRFwzXQsnuTCdH+YWzKDsqLIYWMOqYK0sJmVqM8Z/NHQJOlgYDja/Tbi2u
         o/+ED9UZvtdhe7X+4BwV1DjhYy2122eKBu64vZrE2oeOdSaFFfpaz6l2WUbCQtHxEm/Q
         J81/nYRBbRjRst7piZUgypU4BbnEL5SGwVTzjIwP6u2CRDIBBs4aGr1+8ieiQc765lHv
         OHfg==
X-Forwarded-Encrypted: i=1; AJvYcCWYXnC/91zMfnzxrzp5d263WPxV1lII1AJxhvy2eFHWGO7GZhhKycUssYmmCujHyznr3d1LrPDS/A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzjMPOGGtNVB6ePHLysLeqKOALsujK48LVZSFYp1qEmC5e1IVIl
	kFgtk3BUs6D/M9yPJMCty88huupi6jeTDcxJ8Yp19XKvzRchu05qdqDN
X-Gm-Gg: ASbGncu/KDiugc7NYZpfik+/+pFUJqwjeny/2j5Zsg/ttHQrxxKYQCwaduuw6WCF5xL
	Khk2iz+FlWFEAnHGbzPp5LWmnYWpt90Ho6V7SNXaCCMF06FXtZo80asH4XZLlRy2gA/ktAlQCy1
	/4ZsD9UaIERkMPP8t7waAaoYXTsnb1Wg4WPlqmDm9LIQC/eeeAfz8vpatpNsSTm+PdBF4rOzuC0
	iz8IXEWLDokbd+abpmfRN4Q0OBtsYVKwJRQUxoAwOs14fj5g1ytHLwajFI2G8GzWbXqUweAKWE8
	WjM/h3Zsy8YGZQgVOkIboP6G67W+SuReDfysWAddTNPSk3cm2wJC6tgMUbhYIewD
X-Google-Smtp-Source: AGHT+IFlfKooJz9TX7Hi2ru7syVsRYDDlC1+bk0aTkoURXKuNk73jwXDjtzK3E4p4XbltfGjBJHj9w==
X-Received: by 2002:a17:907:60ca:b0:ad8:9909:20a4 with SMTP id a640c23a62f3a-adb36bee5d5mr231897266b.45.1748613377792;
        Fri, 30 May 2025 06:56:17 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::15c? ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada5d7fed8bsm332298166b.28.2025.05.30.06.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 06:56:17 -0700 (PDT)
Message-ID: <29438fa9-8228-462a-869d-9e2b82096790@gmail.com>
Date: Fri, 30 May 2025 14:57:30 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] io_uring/mock: add basic infra for test mock files
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <6c51a2bb26dbb74cbe1ca0da137a77f7aaa59b6c.1748609413.git.asml.silence@gmail.com>
 <cf2e4b4b-c229-408d-ac86-ab259a87e90e@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cf2e4b4b-c229-408d-ac86-ab259a87e90e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/25 14:28, Jens Axboe wrote:
> On 5/30/25 6:51 AM, Pavel Begunkov wrote:
>> diff --git a/init/Kconfig b/init/Kconfig
>> index 63f5974b9fa6..9e8a5b810804 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -1774,6 +1774,17 @@ config GCOV_PROFILE_URING
>>   	  the io_uring subsystem, hence this should only be enabled for
>>   	  specific test purposes.
>>   
>> +config IO_URING_MOCK_FILE
>> +	tristate "Enable io_uring mock files (Experimental)" if EXPERT
>> +	default n
>> +	depends on IO_URING && KASAN
>> +	help
>> +	  Enable mock files for io_uring subststem testing. The ABI might
>> +	  still change, so it's still experimental and should only be enabled
>> +	  for specific test purposes.
>> +
>> +	  If unsure, say N.
> 
> As mentioned in the other email, I don't think we should include KASAN
> here.
> 
>> +struct io_uring_mock_create {
>> +	__u32		out_fd;
>> +	__u32		flags;
>> +	__u64		__resv[15];
>> +};
> 
> Do we want to have a type here for this? Eg regular file, pipe, socket,
> etc?

That can be added when/if they're mocked. This set tries to atomize
file rw execution characteristics, pipes should be just a particular
set of those (e.g. +option stream vs offset based file). There might
be some interest to test some interactions like with page cache, but
that's beyond the scope, at least for now.

-- 
Pavel Begunkov


