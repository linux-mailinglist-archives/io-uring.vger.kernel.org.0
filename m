Return-Path: <io-uring+bounces-2732-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0317294FAD7
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 02:49:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5CDF7B21873
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 00:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD1B817FF;
	Tue, 13 Aug 2024 00:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h/Ib9awv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B72EDB
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 00:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723510180; cv=none; b=kpxqw7KHZtpDZtG/D4bQIJc0p0jMs9zQwMAskuwY7bLtRxRZTK04aoe1vURtIZVoDZuJsxY4jAzkpKKV/PDF8y6mqUFrkFtG0nXy+6cYxCmVgOsy65Aq8UtoMCTPvsD8CRdJLpIHIVqPPIC7gYOzqOgH2+BRfgJoTFAAmqg/O4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723510180; c=relaxed/simple;
	bh=qL3QKnSH9D659LrOhp+bY4ZhqHgS4o7GriCi1MBCIPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cm++xWJsNzZp5+1Hm6dqfsYQyBjYIGWxGzV38D8IJxgtWr2Ljnod335NocZVsuhpDsxHEP0J0wsFm9IMYsZ6YHXI8+jIc1dNPIrefsoCcOUeSqkgRKaNQdzC/LLnDgKdXvj8WxkRpMxS9WAiH5hdhMLygMwS1l5cSg1rBGhHz5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h/Ib9awv; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42816ca782dso37822105e9.2
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 17:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723510177; x=1724114977; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GqmN+3FV9Pff+1BU/gju4r3iI3tiJCY+lyjrrAAN+GM=;
        b=h/Ib9awvc1Be5YjjHijR2JTfi5MQd+Ny5qNeUW0RrZVvrQRkVzAou6efW5z61JglpU
         MhSpzhLwIhoqbjz3nPZ+QS+zjTws8Fa8sbeeoHw6BgIUKeuUFji6d9lp51dGksLCOOP5
         MqjShexjW29bz8OnPXHmi757nrNEzymoFFgEIMoY82pY4Z5sfskQhnBIo/oAdPp1EVqe
         g5V8hhKCYDQH4+xR6bI8S3J8jMN+pS9Li8sXevUxu8gw1OcEbR6W6VQHgAvizbAdsUYv
         0eOrj1ctSfVzxaElvuX5DBn3mgCnof1UbxUlqIm37IJcJVPVhW7S+i2GOLe8kT6URMM/
         4cEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723510177; x=1724114977;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GqmN+3FV9Pff+1BU/gju4r3iI3tiJCY+lyjrrAAN+GM=;
        b=q8jXFXSSWpFQB1IUPEsi/gdB+OCmmDiu8vY1uGjIz89FRm65CDRBZzGz6nmUEZbzxm
         gBGiOXGlJDFPWP82O5bVrTpHJNtAukQ4koao3+XqV22+kPizh88SnRxA6FVV9NcExr+9
         Q5NlrgxnCUn+5+3hAaomxPdej2JuzdZMWlslLGUEyyrI6OzEDYet/f/A4r/07KzBLaiC
         JWomjnAYLjDLuVgWD1Tei3/VKsq4O6Uh6sBgQmOiiGG75Ui4KZT3MtWyQtKvIgR0MPdD
         /GKGq0HCt5IFV9ovuCsptckooiE6Mlqb9RrUGE6pgBPQXx17kFXZQIPsq6/L8TJ+np1g
         nfgA==
X-Forwarded-Encrypted: i=1; AJvYcCUlV+XL3ozPxmwbo059K6+UflVNLQ1/Ly6BH3j5i8BYYFjFwGYdCcGzOeSS77dql3kmNGsJ9x2VVWcTOvC+8yxfWK9hBMrLL9U=
X-Gm-Message-State: AOJu0YzAqt+4R5P4991YdjL8AKvd3VtAIohIEqYMMS8eVi5NMQxdksxF
	5wjZeUfe+A9/JLnuXQayr+ky1uPrddsfS5xOezaYOxRPW4aNPsdB
X-Google-Smtp-Source: AGHT+IGingoyo25aB+TYSdWKzggSRjYEegNHmJbJcjy3tFeTgvQnU+o/2eotpTHDC6/MCtID10E7Kg==
X-Received: by 2002:a05:600c:1e1a:b0:429:d43e:db9e with SMTP id 5b1f17b1804b1-429d4895427mr12194705e9.36.1723510177034;
        Mon, 12 Aug 2024 17:49:37 -0700 (PDT)
Received: from [192.168.42.116] ([85.255.232.227])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429c75044b5sm120106725e9.2.2024.08.12.17.49.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 17:49:36 -0700 (PDT)
Message-ID: <61b2c7c1-7607-4bd9-b430-b190b6166117@gmail.com>
Date: Tue, 13 Aug 2024 01:50:06 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] clodkid and abs mode CQ wait timeouts
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Lewis Baker <lewissbaker@gmail.com>
References: <cover.1723039801.git.asml.silence@gmail.com>
 <98f30ada-e6a9-4a44-ac93-49665041c1ff@kernel.dk>
 <6ad98d50-75f4-4f7d-9062-75bfbf0ec75d@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6ad98d50-75f4-4f7d-9062-75bfbf0ec75d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/24 19:30, Jens Axboe wrote:
> On 8/12/24 12:13 PM, Jens Axboe wrote:
>> On 8/7/24 8:18 AM, Pavel Begunkov wrote:
>>> Patch 3 allows the user to pass IORING_ENTER_ABS_TIMER while waiting
>>> for completions, which makes the kernel to interpret the passed timespec
>>> not as a relative time to wait but rather an absolute timeout.
>>>
>>> Patch 4 adds a way to set a clock id to use for CQ waiting.
>>>
>>> Tests: https://github.com/isilence/liburing.git abs-timeout
>>
>> Looks good to me - was going to ask about tests, but I see you have those
>> already! Thanks.
> 
> Took a look at the test, also looks good to me. But we need the man
> pages updated, or nobody will ever know this thing exists.

If we go into that topic, people not so often read manuals
to learn new features, a semi formal tutorial would be much
more useful, I believe.

Regardless, I can update mans before sending the tests, I was
waiting if anyone have feedback / opinions on the api.

-- 
Pavel Begunkov

