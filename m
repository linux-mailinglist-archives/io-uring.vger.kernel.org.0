Return-Path: <io-uring+bounces-8000-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2C09ABA178
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 19:02:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E325A068F1
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 16:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145F1223300;
	Fri, 16 May 2025 16:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YVaX6G0w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A73B250C0C
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747414641; cv=none; b=X+X9rr00H6qzn/LDUaHATpsK+uY6sHO60x52/0cREHDp0Y8SwZaWOaz1F7H8zlaEaSSp+/143ct7Kb2TslI1x/MxxaH96QB7dcPiWSV2dh4Zu45m5+jO9CQflt4qwRxGiLFabIHonGLeczvUU/zxzwuvPrNk5Uj6XLmwBDFuWio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747414641; c=relaxed/simple;
	bh=TuFRN4+s27vr9Q5GhlQM9E7mQGutE3Pjb2jPS7Z+xfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=L0pVL69n4DMbtT3zeltki6RfGhcfr0zuZKXzBptmT59z/30TSieGBqE8ogt3OhFt7Xb3IJAFBciPSbUJaQ7TKECkdvbuxbTnHiK3NM5p5nyLqChmB2eC6yJ6LJgmFi8HCWLLVxAwLwGuUuad3o4jzVy64LRzRq6qzQ4CyFpLfR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YVaX6G0w; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5fbeadf2275so4385499a12.2
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 09:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747414633; x=1748019433; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FArj7ZBHUX9K72GRR0zQIbIruoqJ2BYgwAP/HtQKAII=;
        b=YVaX6G0wgpJN/EOM/SnQEoyziM6FzPBcmkOMIH8GYNX6l7vtfzWgI9OuzU9OU/ohPw
         jSk3Qx3ptnZV1aiPTPSlT+jD96egOMf6D0YsiApSz7wT7ZmSS6UNDtiO4Yua7srRs34Z
         DvdASZeohpWBM9fOpeGAANpNL3kyWkBam3GJ8RIyyMbdRHyGZDMCdjkn3CQc/qlWq3PF
         /kigpa1x4pXOCRSePZNLXhElLciGKGYQPmPiKT3GN3yD93iqlTFX6m5p8yxawHe5HZJY
         j+fHBXmb0vo79jlP577sCviWadO9RyZBEb7YSMrc5cFXSQpeN9WXjmrbwnwZjju6XAPc
         uaww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747414633; x=1748019433;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FArj7ZBHUX9K72GRR0zQIbIruoqJ2BYgwAP/HtQKAII=;
        b=ejg9yPESRht/IovDZ5Daxvz8pZI0V9MF7bnea7UULIcBZGvvs7pSwg4IM4mJaohm24
         9dgh2b0IqNfATIJUhzhiY1iq6SqBKeFC+fAclZ6tuEQHv1b3qrbgozjTZ9iQGoou0tDW
         F26QN0XZpld/OTR0vSI7SgoZyPKlrbvAY44UOEK/P7IBr+1JrwfOL7KmWA5hn/yor91i
         q2qpNHOElCl542F80CNYhOr2CWPpiZy5BmhKsCisoGWzKPbG+WqwYVtzretjwSb33aQh
         BiwUMIl2NryCv+3jbEwsbGBb3ETxwW5pWqT+DLQ8ojoLJbLrKdQF5LfxoQJOrEshJP7d
         00Dw==
X-Forwarded-Encrypted: i=1; AJvYcCVHqM8NVb+/tZQaGzVvA1e9iFfOPdJpFzz2zDvN3GODgAWyQgMs8psf9nOm8QQ3f2QuUrZyY5lR1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxgeLkhwdDeU3KF/CECoWXoZWNIDuioMJqq8o93X4kmwYxcMa4G
	RNgNeLMA1ZDI4FJ8329ohjyV+NTwUpdN37UalrtFH5s29Hx4fV1d/0JjmU5NcA==
X-Gm-Gg: ASbGncui1o7CrphlGFc5IGE0IRy+uwRKbQygllCFNZmODGn8j6WLAQXU1vJx+5c4YdF
	z3hSj/1XjN0quGcZ9cPU4m1662hqVkFQqlPXENNsFccplX0iXwvyguxbnD8E+LbmDmnhGC78QsI
	Vl726df2hlKKWaeJSOUkbXrZ9ZQwnjrw9HE7aNM589jb2KN2fRTbz+nApKfZs1viY8dhcFR0pg1
	zL+lt5j0jveWOlTSwdAef/LJH8kLEYUbikWGJwQA5OlcjaEPTuSdMVzaXR43uIhiSu5SNzEuSv2
	KP+Tmvf8362FGflFoXoDToLGq758W00LV+uIg10G1+6idvchy1J5Zq9klr0=
X-Google-Smtp-Source: AGHT+IFID+mSOqhdJSMzhegXB4ZfWvndaAQxtV7tfivf+dewy5TNsP6VyP9KDcSEMWnHxcm01mYZNQ==
X-Received: by 2002:a05:6402:2108:b0:5fb:a146:8600 with SMTP id 4fb4d7f45d1cf-6011411eaf4mr2857800a12.25.1747414632693;
        Fri, 16 May 2025 09:57:12 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.234.71])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6005ac33d7asm1666268a12.52.2025.05.16.09.57.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 09:57:12 -0700 (PDT)
Message-ID: <f8f99262-2e11-4204-ad18-fabe836881b6@gmail.com>
Date: Fri, 16 May 2025 17:58:29 +0100
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <036598fc-cc22-4e37-a83c-8378ef630f55@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/16/25 17:44, Jens Axboe wrote:
> On 5/16/25 10:43 AM, Pavel Begunkov wrote:
>> On 5/16/25 17:08, Jens Axboe wrote:
>>> Add a new helper, io_alloc_ocqe(), that simply allocates and fills an
>>> overflow entry. Then it can get done outside of the locking section,
>>> and hence use more appropriate gfp_t allocation flags rather than always
>>> default to GFP_ATOMIC.
>>>
>>> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
>>
>> I didn't suggest that. If anything, it complicates CQE posting
>> helpers when we should be moving in the opposite direction.
> 
> I'll kill the attribution then - it's not meant to mean the
> approach, but the concept of being able to use GFP_KERNEL
> when we can.

Sure, but that will be blurred by time, while the patch IMHO is
making it worse and should never see the light.

-- 
Pavel Begunkov


