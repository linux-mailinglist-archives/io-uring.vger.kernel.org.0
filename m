Return-Path: <io-uring+bounces-8005-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A9B6ABA2B6
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 20:25:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 654501B66789
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:26:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABDDF27990E;
	Fri, 16 May 2025 18:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fojsEX4Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26FA19938D
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 18:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747419951; cv=none; b=SCyEH27Ag35EeP+bRymon5xmTdcNjwj+G5pmiOkpD6TJOpumjVqKvuFmjYZzI6uaa5kWOULixWSki+TInSY7VF2YrEiPNB0zjLp2KCpJJHxJna/1eWsMUFJ+khLqWoSEgC7hqIu1mGJr2BbplOmALfzdQ1jYHg0spURhi0I76ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747419951; c=relaxed/simple;
	bh=m8VuVBt16oh4qJKf1wNPytamp+EVXxuIU6MlIZMIalQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eYUQaDjTZkbrcAXytx2SL+APggOgMbR2dKFJgUzN+rfXAFDx+NDZazEDf23Mv/cfT8GjIgGGGmBt6ucogJV/53DZYsEp2fPlQjKfHrQetjrrxslZO3uizpLoD+fszePQX939Cy96k3p+8De2yePPEqepgeeYTvFlUx7AB5ZqMJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fojsEX4Y; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ad545e74f60so89548566b.2
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 11:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747419948; x=1748024748; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nis7cUFCd4ptlWhEry8C6v9GQyPJIV+gRQu42CZzdBE=;
        b=fojsEX4YvABylHfarxDRIqlozcmMOyxTuFDhvTxkyI39tTffDquBcnu6rqQWQVEsl6
         pdogT5LuAHuFsDFqlAcqkzgtsU68qg0LOZ4vlsrXfTC3J5fXsBxvSXGYDlbzZckNmLkv
         KL6VZs4+SGOdIELlxMHFZzOf/56oiD3/21bk009vwj30Wcq209WxuUEjFVmVUTeQwYcX
         5s9DZ+bwEILoStmBRCEntFHk2OVjk3uZQ3PFSkdGM/L2TNv6rWjhj+JEbA5zWDzk5SAT
         MVRaNJR42rEcFbQSopmG0h9qk91DqwHMBlepl2bx9n50ogo8XciwncNDPq19qkhCxKR3
         5U/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747419948; x=1748024748;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nis7cUFCd4ptlWhEry8C6v9GQyPJIV+gRQu42CZzdBE=;
        b=tt7SBW0faWGfmGuJTzcgh8sGRRKr4F8SvasUTYppxF1MvlLcYKcpZhCtHwWkWBKQgI
         nJXLRapT2Y5PVecOCspNHZ9IClhdx5zhCeU6fMQTVA7tyV6k/pcifskF009pWNalXGOz
         z2ykwSOi3P3nVuwTwVUgY2kIeI6GBTt5PZHhaPTgriJ+WaxfNaSZyuTHYSJeZTtwBu8i
         rnvULJzDzVS15PTDUdbTG1UTApeJtNRSmjCpqXLDroaufBAckA72eQohcsa+HlL7QYma
         v4TJTSCy1nRe4cldSCIWawF7/lXc4Se9J7SFOq0Q0dhstsh4sCSpPjZpA01gHNInwRpJ
         +3Fw==
X-Forwarded-Encrypted: i=1; AJvYcCUYtnsRUoOw1zN3WM+jnKBWqsgOppOV51ZUbE/CPozC/z/3do6IYJ/gia7xaDpshbyhhFlzGjYBWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwlfeccOx+LrV6gFxJjfy8PY3zJxJIzh3CJYEy8t6jcHPIe9cgp
	T5BvUy/dcYvlQvF9rMKhxTo9n9Hb/zEZnUGFISdKoOADNEDi0XqVsxPF/euvwg==
X-Gm-Gg: ASbGnctCOo/A4fxZjVOy/p3Eu3U0gT9osyhpEhk/7B/ueq5HyqeYkFjUEU7oS1iwLJ6
	L1mapqBbnJSuy61uIRlMhih452tqYX52eQVb6UOgp68gmw5G0tP7PVV2U+3GOuyKnAuNiKD2lH4
	w+oZczrsrM/YQDAFGKQNHht6rhjiI2xf+TeeiqK8PaTu1dWeT6wqKwyyKpF8xCmy98XrGXg9Ept
	gZlexM19jueGcdL7puBUQZQliHuiCiGLeMXV1BwFRC2wEszHTm+CFp4/oN5QO5xbTP5Esr623OB
	vH+D7fojPSngCFbL4tmL2nrd6Qu1PhG/dUd+KUovVwoxPkOeByxfwcZoRZc=
X-Google-Smtp-Source: AGHT+IFawIYtBm7Sgk8Hq8IdYPsjQtRTdvExVdjBs47piHZDqHXV9qBYNutV/+NO7U6wFosq+Dlegg==
X-Received: by 2002:a17:906:f595:b0:ac3:4139:9346 with SMTP id a640c23a62f3a-ad52d42bf33mr345247666b.9.1747419947698;
        Fri, 16 May 2025 11:25:47 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.234.71])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d06cc3asm194004066b.39.2025.05.16.11.25.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 11:25:47 -0700 (PDT)
Message-ID: <3b6e1d2f-91e4-43aa-a08c-9b1e946c458e@gmail.com>
Date: Fri, 16 May 2025 19:27:04 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring: split alloc and add of overflow
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20250516161452.395927-1-axboe@kernel.dk>
 <20250516161452.395927-2-axboe@kernel.dk>
 <01275ac2-8d33-4f33-b216-f9d37e7c83af@gmail.com>
 <036598fc-cc22-4e37-a83c-8378ef630f55@kernel.dk>
 <f8f99262-2e11-4204-ad18-fabe836881b6@gmail.com>
 <f0d9fb95-5539-4a5d-972f-6904c1b9c2db@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f0d9fb95-5539-4a5d-972f-6904c1b9c2db@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/16/25 17:57, Jens Axboe wrote:
> On 5/16/25 10:58 AM, Pavel Begunkov wrote:
>> On 5/16/25 17:44, Jens Axboe wrote:
>>> On 5/16/25 10:43 AM, Pavel Begunkov wrote:
>>>> On 5/16/25 17:08, Jens Axboe wrote:
>>>>> Add a new helper, io_alloc_ocqe(), that simply allocates and fills an
>>>>> overflow entry. Then it can get done outside of the locking section,
>>>>> and hence use more appropriate gfp_t allocation flags rather than always
>>>>> default to GFP_ATOMIC.
>>>>>
>>>>> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>
>>>> I didn't suggest that. If anything, it complicates CQE posting
>>>> helpers when we should be moving in the opposite direction.
>>>
>>> I'll kill the attribution then - it's not meant to mean the
>>> approach, but the concept of being able to use GFP_KERNEL
>>> when we can.
>>
>> Sure, but that will be blurred by time, while the patch IMHO is
>> making it worse and should never see the light.
> 
> Well, you're certainly cheerful today.

Only extending an opinion, which, it seems, you're going to
shrug off. That's fine, I just need to learn my lessons and
stop caring about improving the code base.

-- 
Pavel Begunkov


