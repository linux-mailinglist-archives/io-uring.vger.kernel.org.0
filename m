Return-Path: <io-uring+bounces-10430-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E030C3DD13
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 00:25:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C149F18914C1
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 23:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08D5C2FD689;
	Thu,  6 Nov 2025 23:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aUB+3wt7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2992128C00C
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 23:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762471437; cv=none; b=Wu6In9+c/Mp7ehI9ssf0GGaGoulbkECPMOh6XawJOzzIp4ohLu3IpvNNEaiczrdwayab6l39/1NBZBp37XCh1F4yQ/WfXBhNu7awqrWVLRcJKQHSjOs9DJghPKxma6Dj8J4fmdYAFDWQqpyoBz0Fgs7LJmsz5iDXjWfGGM/4sGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762471437; c=relaxed/simple;
	bh=Hh6iND3HR1ofqwHfinXpf8mEwfG/z256yqmJQizNQNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZLkTSi95VO2KsLJzgLQmjlySFuotZ6DPKOWeoDUuQ6oJIMa8TIdx6r9+O0LbzvgDV+Gt1scPd9AyMqokMfgeQ4fFsw2kWgDi60oO5X21NpwQg0llD7LNEdITYlyvRdYpPuNALAi1WbPjjPbEIvY2uAUW/+EdItFsM6H7v1HQEBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aUB+3wt7; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ed811820faso938681cf.1
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 15:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762471435; x=1763076235; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=el1cuAz1YqLgeETGs2aRQ5ebH+J/xxuEoT4Lm14Yiv0=;
        b=aUB+3wt7Hx3EKJwLLJvVsufxx7yvtAUpjc6MgdmVvVwUq9tuxsW9owF3+M9X6wKz9q
         3stVRJLH6Gva/+7NJ+5HGYmIiPWh0OFCvirlJynQn9OE+QwvRL4FSGbON9sFQ/tVmmSz
         QK+bP0NNiixkiB58mQMnMfHU/p7n5y1LGQ8AClYo+b0HsfUqGCxmtchTzbFXlK7hmczj
         JS7KQ2c7rkiLNKnzYNIUsg6mShGt2MX8PK3rIaNFr1bcb9nICtEiar/YD4REIp8p3I83
         geRJvJF/IIqDWfZ8Uj2DtNQE05Zklv1ubhGHHFo5NJ7VuIddz2VqEZ2N3sMU0LBpXbWI
         yXpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762471435; x=1763076235;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=el1cuAz1YqLgeETGs2aRQ5ebH+J/xxuEoT4Lm14Yiv0=;
        b=hqhKHY2fsb7Erdmeo6P3BU4D306XFHZlaibA8XSfv/Ia9td7ERityrVADCU0IsqAtU
         6Of/A0uNWTGyX8vChzP56Lf8B6D7LT+VksnurVDcQJFxqlKVdzXIJvA07oNNykQn2vzX
         Ksh8oqAx3yYiXBSM10h4DMKqcGGiO3ttqj9DB8iuSVd2ylu+AiuN0NZyh9wstdWAkQfN
         GOVOUGSNPNQxzg8LU4aNyE8WlnvzavSpO/cocCija/Xs6NN7XcDWLE5nS47/TemsYhW4
         U4a0NAYfx357w9rJf/aSDw5UJVacaYYVl6PjtbRS5lYr0c4hWjWI1n7AcjR4zAqK+CPu
         vFwg==
X-Forwarded-Encrypted: i=1; AJvYcCWnrULNM4BFdXiYAuoGU0xzMpDqFbbIUgHUc4QK40Tuwck+W27NfghJoikkZku/RB783FpMYhfbXw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzweaCHtJkz9nTtBfm0TUNC/ei5287O7pH4z7OzmKIbJ3J/i7th
	lXyzy3kEEzdx35KYHKGHiST4GAN8YbQcS2J5FMgPslTimV//jd42JFjqsdW2m52HnlE=
X-Gm-Gg: ASbGncvud08tRCi9tugzvkUwsOy9TEYYZbzSlTHagV2A2IchuimHNudKK93XBhAElrY
	PvI8gLUtB2GQrLGDHU5ULbtxexDJtXBUshtzzi8EXelwAByVu9lhI6MmrpYMtJOLSlX4Cgweiwa
	sF0bp6a/PEY4ECwhWXXSLiI7DuPxty5n8pj6JdDc+e5wGiBahT7nVKV9omTjfISixoHrFjsF3ov
	WV+IoSjrTs8Oz33sPLVqaC0uqMhGo0o69asLnFhS3A9ICO3jp/2BGDW4jUANyP6/qvaq0bxj5Yl
	TnaJHEXyTevcrrhEtlKTDDkFoD9gSEYRCHlFqVRdRD9Ma9G6x1f1eITEkYHZFOEeM7qQ1VFilpi
	FlAmtQlh6Fexjrq5ARWxTGNssY51eXLPOnfiujb6H5t/CGvN1tJV+uSJPwDgPfyrIgzvnsXeS
X-Google-Smtp-Source: AGHT+IED0loxr5e8Ks69pE0XI9j+TVf8lGI6jhLq9i6Hya94Y0QyZfmPoxrPRZ9H9+SmuUujFWFHpA==
X-Received: by 2002:a05:622a:148c:b0:4ec:f477:60e9 with SMTP id d75a77b69052e-4ed94aadfc9mr14650901cf.76.1762471434846;
        Thu, 06 Nov 2025 15:23:54 -0800 (PST)
Received: from [10.0.0.167] ([216.235.231.34])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ed8131b3eesm27176251cf.7.2025.11.06.15.23.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 15:23:53 -0800 (PST)
Message-ID: <a4cbaa8b-0bfb-46b9-a932-86b740ef8ce0@kernel.dk>
Date: Thu, 6 Nov 2025 16:23:53 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-6.18 1/1] io_uring: fix types for region size
 calulation
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <f883c8cca557438e70423b4831d2e8d17a4eeaf4.1762357551.git.asml.silence@gmail.com>
 <43429045-4443-4e5c-a892-4265de2cd026@kernel.dk>
 <5db63478-cd4f-4a6c-a694-3c39a5f38571@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5db63478-cd4f-4a6c-a694-3c39a5f38571@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/6/25 5:09 AM, Pavel Begunkov wrote:
> On 11/5/25 18:44, Jens Axboe wrote:
>> On 11/5/25 8:47 AM, Pavel Begunkov wrote:
>>> ->nr_pages is int, it needs type extension before calculating the region
>>> size.
>>>
>>> Fixes: a90558b36ccee ("io_uring/memmap: helper for pinning region pages")
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   io_uring/memmap.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/io_uring/memmap.c b/io_uring/memmap.c
>>> index 2e99dffddfc5..fab79c7b3157 100644
>>> --- a/io_uring/memmap.c
>>> +++ b/io_uring/memmap.c
>>> @@ -135,7 +135,7 @@ static int io_region_pin_pages(struct io_ring_ctx *ctx,
>>>                   struct io_mapped_region *mr,
>>>                   struct io_uring_region_desc *reg)
>>>   {
>>> -    unsigned long size = mr->nr_pages << PAGE_SHIFT;
>>> +    unsigned long size = (size_t)mr->nr_pages << PAGE_SHIFT;
>>>       struct page **pages;
>>>       int nr_pages;
>>
>> Should probably consistently use a size_t, everywhere else does. Doesn't
>> matter here as io_pin_pages() does the right thing anyway.
> 
> I have a patch on the topic as I needed it myself, but didn't
> include it into the fix.

That's fine, better that way too imho.

-- 
Jens Axboe


