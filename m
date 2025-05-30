Return-Path: <io-uring+bounces-8156-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 46358AC913E
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 16:11:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1717D1C06A0C
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 14:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C1452288C0;
	Fri, 30 May 2025 14:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BlXuJ2eb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6633222DA1F
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 14:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748614106; cv=none; b=mKddMjoilHsUN1zzuHS9RSNyUVxonS6sIVrQwZtlttoniudBI6al2FYL8LIp+40IQp1hRc1jRGfXB7e7DnHIFECt5U6dQbVKgMWE4RU8hovQyajwavH1e9ssRQLoVeuzDzoC3otTYDVGOJcWqHrOTCznLlo81G744kChmG/UcVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748614106; c=relaxed/simple;
	bh=/J59H0w1ZQ5tS6RoSyQuBXRf40t6zltX6W48R+K+R5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=L9VsZbGA9wM3+ZjOY00iJuOtdIjhtcVkdbTrFHQVglQaUf3kGpdq8S53bGoqFlp8QsqhITC74vWlgwsWO6Oc3LF/EVIYeL/waV4Bk917sCFHb21eVo9cqS2hWBmc1v53yOzj9zFHnbActSi68YOoCu68ISEjJx2LuI4J2oqj+Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BlXuJ2eb; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ad89f9bb725so414894366b.2
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 07:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748614102; x=1749218902; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W8OdFsWCm4+wtbuLprhNqESJQ9dgB/rD2jz40JcbnhU=;
        b=BlXuJ2ebaivy6xnCVSQZ8u73e79dKMg95wXg7rZRzZb4AfeMsXgQZuRQozt4R2tvlU
         NaKfL09MpKU5dYFUVE3Ai+sJ5Mfbc/roqSzoWadyXNcTBGQnuNKbjsYuP5Tp/2kF/9tv
         cNX4isM0Z1yq/Bi8VdO66dGFoOto1ZnZ+OtveWANf5qYkj9dFluvdIyYM+TFJGCQcGYn
         PLv/7OYuK27jC8wIPEYMFYEsD6Kgclr8Ik73eBP3j7j39fRJncXprFZfJY4fcgTr9JbY
         tUaKFhUYYKWjfUAVh+BfpHUIVr3aZ5jQzdIc9g+xH9Sf/hwMYKiujCRcSiIcSX8nzFwB
         /K4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748614102; x=1749218902;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W8OdFsWCm4+wtbuLprhNqESJQ9dgB/rD2jz40JcbnhU=;
        b=sIy3qKDdrrcHAI7EA+Z5QCljsEGDwVaAdo3HWzN0xPB4mghsyjXkd5UYRq20asg92V
         PiugRjRvwamD08RSmscfdsttGE99uljv1cXIuvdeU0EAtPEUD44tdE3TAtdCxDSrNnyx
         F/ZWnTaAuOJOKcBhfyHkzdqG51/rZ35jyTb+T6Bly/4uEhqXMq74WVgohDy9d0JOKnSY
         dA9qGCsNJv5T1HzSam1s483eSKqf77W8qazWRuqrAp+GuzwKzCyM3J9pSM6T8BKKwOvu
         TmUSzRkVh/LZxjFhZaYk3wcTDx+H79OrU0p1oWJYIl3IU9rqcV8fiFi7kvoVj+k5wT/G
         /Tjw==
X-Forwarded-Encrypted: i=1; AJvYcCW+j+YKQ8aun2yPokFGgQUlUGHujQSY0aRl/equUANwBMcTq8nNeg/Y6I2B53cpPFBUn8d4TIvSEg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxUlJKTLQQzJR1CQ8vrWn9Q11aGP3Qn7qUHf1kKQFlmdwI5zczV
	Mlgr1M/30i4YA6D86KhrJ0LKe0dyWQX9nSlFBxB3Qg2WQ9kNe2aNtQQUYmBgkA==
X-Gm-Gg: ASbGncu92V/qw2Cf6CJ/ExPquGZFPVJIb7ZQadlJ3fx8VnLcWIc+d2cHxEHi3pEyuJ/
	YcDmizA2Dqp/SXW9sRrgTmgYv8dKPo4PSSNxlSYQJI0C9qjpT9R5amqZ2R9QkSvLVQvE1NcwYLv
	q9TZagERU5xjV4SDi30kOzg0Iihg6l6P7rhjd57UQnLGdgPKoGalWeciXGinCW94qQOU3dSVDnk
	/cCIqtrO8IcPdQN8X8oDWb8SUv/kxwsiKSXucv3KLJqb/SaVgfDQANdyr22tgpz4N/KbvaXsZWb
	7+ZUJgCZZsXHeIgxsdKBpL+/S6pvNRBdJZyPARjzvqTlgPu1L3Byx9K67vG3ge5i
X-Google-Smtp-Source: AGHT+IHZeTXMASk7+Y5SPBqv9uRNM3kxrQP6EWzoSTiihMqjozXL3bLjOg+fIZdkqxg0Pl8Weq2PfA==
X-Received: by 2002:a17:907:2da1:b0:adb:1b2b:fe20 with SMTP id a640c23a62f3a-adb36be2152mr214387066b.34.1748614102363;
        Fri, 30 May 2025 07:08:22 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::15c? ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada5dd043d5sm332836266b.121.2025.05.30.07.08.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 07:08:21 -0700 (PDT)
Message-ID: <eb81c562-7030-48e0-85de-6192f3f5845a@gmail.com>
Date: Fri, 30 May 2025 15:09:35 +0100
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

I disagree. It's supposed to give a superset of coverage, if not,
mocking should be improved. It might be seen as a nuisance that you
can't run it with a stock kernel, but that desire is already half
step from "let's enable it for prod kernels for testing", and then
distributions will start forcing it on, because as you said "People
do all sorts of weird stuff".

-- 
Pavel Begunkov


