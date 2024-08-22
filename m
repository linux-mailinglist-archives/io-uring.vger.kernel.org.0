Return-Path: <io-uring+bounces-2902-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B86595BBD0
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 18:24:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B93F1C2294A
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 16:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC2C91D130F;
	Thu, 22 Aug 2024 16:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nXPIla1/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C68219DF99
	for <io-uring@vger.kernel.org>; Thu, 22 Aug 2024 16:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724343869; cv=none; b=UV1J3q3NYhEJmzygv4LLgxWNVxU+ULkAwvqJW0Jel2MekwPkzS+9KQQLFmoGqsm5Vzaia61Umsd+6d44Y+chYm/NI6ivJ3qruqyq7ivAvX9yWrrqBA8S5kTLLFoQEvBUNrLufnDmzdjEe7OkGciHktEjoQ2ctbq1cmzj+c1w+Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724343869; c=relaxed/simple;
	bh=hjkg7uxW5AcIUq9YItOoMHXYcCYfbWk1KhnRvMLTPG0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dxiKW+WidwEUnAR89YRwiSEc3pXhMnHXBupFa8j28179/HdG4GK83UShatG1h2y3WFrwc7l8ZpCV7tn+C5umUdbicr8PzRcyvJa3b7NySabzWtFZzjiFCv8nPtnmyDSHy4bZaqYD65F19xwo1GnOsE/HZU55EjvCCqEXGHE3jTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nXPIla1/; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a83597ce5beso160253166b.1
        for <io-uring@vger.kernel.org>; Thu, 22 Aug 2024 09:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724343866; x=1724948666; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jqiSzi8xaFFetawrK1ToLz6fOnHikXFPljcmPGpCuno=;
        b=nXPIla1/zCVwpqc7wUrnroo2MSq6zltMZ50Kpt90NqpXCGws3GPi36OzXGREmkQzBQ
         0R0As+QKSCEsbGu0CYW2+gjjims6Jb1b4d3N6G5lQLaRnUuqew3pV0GS8IM89u/v4EC2
         Mcx25oAXMzKeiybttHfJsa0zWX/3TZdVeeZprweQ4hJVvL0Z2chOsU5IyYZjNQgn92F0
         +Et3OFXLiN4/n2UtDHJMiOTYaDC+wlTzqo9PL4wh27UD1quG5AtiyW75goJULw3iCQJS
         24mo3RH+C0xjFzP2c5F4A/30C3VOQdxcp91AzODABdP1aUDjEXor4BwPDV2EDMg7n7w3
         6Sjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724343866; x=1724948666;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jqiSzi8xaFFetawrK1ToLz6fOnHikXFPljcmPGpCuno=;
        b=A1DI9kA4DUlsTRNO/mS+9rRn83PkLnZwQn2z8bloQrR+Gg05cvYmkOe0VYM39Dhvy0
         p24zBaZM7JK0aq3mBeckGDu7vIJoBNXSu91i/Zp8A9aez6GR3MoI2+cPm9KGkHRYLeA9
         Xy65QMZSSe2hd63y1MPHi+SZzcxFj5xBoyMcYEFZdiMLSNtniHbQd9z4c0mNGTFP5C8z
         FFlBCp1rGYjb4jVT8wLLLyDZdnHPzFLFtj81/jssPyecliSrbTCVX6oNqzUU1iZm4KpV
         enF+zyFn7ATmNaLaSfVmugzSkaI0+yyz+cd9hy+W/IjqsGYF61CNRHCi/ChhPPvSYLp4
         KYlA==
X-Forwarded-Encrypted: i=1; AJvYcCWguZZ2bqCnsy4Xo4WXK2Q5E4YiCYHVHJyGNZEm+yimHLCye7nk8h2oicoMntUiWxaK23Cs9Lvw5Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YycTGOnSKbWlzo1mien/oeEAa7CT7rPXh1+XMKO+Uf+2DcwQG+B
	5ik9wp0pmShs+hEj2hyiPgSj5bnRYXPSPZQNuWnJiuxYaX7LhhYo9WlLiQ==
X-Google-Smtp-Source: AGHT+IEWfbYofAxMxjaXcpB7Yj0khHcfFP41bLG9ynRwqFAqpIV3fW2O1ZjpzQoKcUMLQSScUHOXfw==
X-Received: by 2002:a17:907:7dac:b0:a7a:87c1:26c4 with SMTP id a640c23a62f3a-a868a849d5emr327754366b.17.1724343866029;
        Thu, 22 Aug 2024 09:24:26 -0700 (PDT)
Received: from [192.168.42.169] (82-132-212-177.dab.02.net. [82.132.212.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f4378f3sm139828566b.132.2024.08.22.09.24.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2024 09:24:25 -0700 (PDT)
Message-ID: <b0983ae0-f1b4-48e5-a979-d8263652d110@gmail.com>
Date: Thu, 22 Aug 2024 17:24:50 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] io_uring: add support for batch wait timeout
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <20240821141910.204660-1-axboe@kernel.dk>
 <20240821141910.204660-5-axboe@kernel.dk>
 <ca995b4b-9dc3-4035-88ac-a22c690f09d0@gmail.com>
 <fbb24fa4-3efe-4344-a4b9-982710e9454b@kernel.dk>
 <3087dde9-4dc4-4ed2-a0ed-4b60cf1e0cbe@gmail.com>
 <2e9b16b9-e22e-40c4-99d8-80169dc657c9@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2e9b16b9-e22e-40c4-99d8-80169dc657c9@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/22/24 17:14, Jens Axboe wrote:
> On 8/22/24 10:06 AM, Pavel Begunkov wrote:
>> On 8/22/24 16:37, Jens Axboe wrote:
>>> On 8/22/24 7:46 AM, Pavel Begunkov wrote:
>>>> On 8/21/24 15:16, Jens Axboe wrote:
>> ...
>>>>>           if (ext_arg->sig) {
>>>>> @@ -2484,14 +2544,16 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>>>>>             unsigned long check_cq;
>>>>>               if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
>>>>> -            atomic_set(&ctx->cq_wait_nr, nr_wait);
>>>>> +            /* if min timeout has been hit, don't reset wait count */
>>>>> +            if (!READ_ONCE(iowq.hit_timeout))
>>>>
>>>> Why read once? You're out of io_cqring_schedule_timeout(),
>>>> timers are cancelled and everything should've been synchronised
>>>> by this point.
>>>
>>> Just for consistency's sake.
>>
>> Please drop it. Sync primitives tell a story, and this one says
>> that it's racing with something when it's not. It's always hard to
>> work with code with unnecessary protection. If it has to change in
>> the future the first question asked would be why read once is there,
>> what does it try to achieve / protect and if it's safe to kill it.
>> It'll also hide real races from sanitizers.
> 
> Sure I don't disagree, I'll kill it.

Thanks. Personal trauma, especially after tracking down some chunks
of code back to 2.6 with no explanation nor author to ask.

-- 
Pavel Begunkov

