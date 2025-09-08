Return-Path: <io-uring+bounces-9654-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70D11B499C1
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 21:20:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35E223AE6A8
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 19:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 584CC248F7F;
	Mon,  8 Sep 2025 19:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="m8mKrQx3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D6024A047
	for <io-uring@vger.kernel.org>; Mon,  8 Sep 2025 19:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757359198; cv=none; b=WtysF55516SXWLFK5HbG6cri1cQNULA/PiWrUPZPDnbi+Wj4BVwJk3IJgMyWQR+Oxm0ziI4z/OZx1BYrhbIGh8irmbp1awJTO2Y92btPHYI+onnYsY7/UAj5XtFp5vNdJLN6vRKyCbEvGc7ooKtG3xS9Bal1083QYI+KRO9TmK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757359198; c=relaxed/simple;
	bh=4e4g1IiZ8YnmsTRTvzVogdSRnaGkWDvyrbvctrtPG10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G3GUXxCK9cvYmMEjqOE4ziln87p3PTT3g3uagwkhh/n/JFSUYxvDFkyz7LlEv15n/mg+xYj4TBhUgEhgBiBiN77qriG5uFFm9apOjqYqI01Wi9ZpmBuD70eO6xjABTe8kTytAYGqQZ/j6fkAifdp6LzFd6VElJoJweejAGQMX1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=m8mKrQx3; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-401078bfacdso23434365ab.3
        for <io-uring@vger.kernel.org>; Mon, 08 Sep 2025 12:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757359194; x=1757963994; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ulKtJOuKiGZPKXYAmUAbPqb1QZQ57vmP9fPSuv2Vk/I=;
        b=m8mKrQx37qo+UVMQpEF9NkimsG4jE635mY8LeOQcNZNs9Iaw+RP0X7Nd771EtOr3Pp
         +iuD8LnTqv9lGPmeJf7IKJledRHTGsS6Me8koRFgF4o6XJKUFG/+OE82pr2j7c+axrA1
         4ckduRUkwOm98h5caV/3Bc0SnN7w7sTxQxUjKS9ku53HQGTWMe17+0RFRlLuj23qS6tM
         gX4wtjEc2aFusW+xCJwvPuct9YfvLVuYzTnCdExDWAH+KujhJi7QGiYUdjQ1NNbAjsC1
         teWgssEFnjP7ViXxnn/RbsQmN1r8IZoLJAkQFZ1YP51vFqQv3LSW9iOtgAaiM5XYkzHU
         frqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757359194; x=1757963994;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ulKtJOuKiGZPKXYAmUAbPqb1QZQ57vmP9fPSuv2Vk/I=;
        b=GSucWNe+hGSe2Zel2lYfrujOsorYr7UG7hYHU4zCbUo/75KXYL2qoXesuaP2XeFm0q
         tnc7gx/lrp+FpIZzoXCRwkxE4OQmPc3kGXqAMJPGAi4fXs4l5tBL0wIiuMT+AxGWW0be
         WSyeDySlvMu1ZNPw26Qpyq+jor+Dr3spDiC2pTCrF20K2EvpUMqB8sKtB0nRQvWDiS1Y
         +1Hl+0bjyrhN07FaAg8lqRPHIfDzpY0hJCcNHYXYyxKsg1hWuz6xcpsZNKSE2cY5lo3+
         Yhl0fYy9wWpWphLb/US6+AlOzvQmx+VvppYGXhQ+vCn09zZU0BEmWKdUBILFkQbNINwx
         gfpQ==
X-Gm-Message-State: AOJu0YyoXglTbz33ITI77EMcUUGaVk/NctU5+BpaGUjqPqaT+t9FEoLN
	xLhHzem/TL62Xra9gwX6gZy8zuUX0Ma3T8WRAiyg8/6ypwiaY/LMwH8iIbO1drDB25ZRMTxAaUx
	klZhC
X-Gm-Gg: ASbGnctcQPlfVTvi9RRA/c4L/2icm3VjJqrnjj8M3JlwyyLEmUN47NG3QXbqUWDcEm+
	28L/ZJuE/3p179XcwArcFPAd5tuYQES7Wj5gZ4bxFxJxAGqB3pDw2MJga1GyQ7p5CrCJ/XwGMg7
	Yn3Vt5naG7OFWXH0ZJY7sPjIsmGEVjtuMh+m+G1a8O8Kt4RySa8Gww6seb/52Pz/qlQLbJ3CvtC
	0vkFctsbMEOe3Lr86gdQ2rskgWPRvMQdSexrl/0FCjSQZaX0DLY/aDpmUTecUvwEXp6AWIw/nK/
	/ufUHNpvS7lrWFMX0Mix6XhAjozN+1SAUtu3xbxGj63En8SCr6iGi1S4/m1lUjCZ17g2e6Fp4rJ
	4jcjQUlFMLgLgBrd2WHQ=
X-Google-Smtp-Source: AGHT+IGXrqO2/TmlaLxs2btRyugMh/qdnCVxn01lCsIFTUtgLR+a8XDso0hWxX40MNNYPrNSIMsuzw==
X-Received: by 2002:a05:6e02:178d:b0:3fa:e602:737 with SMTP id e9e14a558f8ab-3fd94a140b0mr136360485ab.17.1757359193811;
        Mon, 08 Sep 2025 12:19:53 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-402758bb0f2sm23808205ab.39.2025.09.08.12.19.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 12:19:53 -0700 (PDT)
Message-ID: <2e424956-9884-48fc-93ad-de0d08f3485b@kernel.dk>
Date: Mon, 8 Sep 2025 13:19:52 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] io_uring: clear IORING_SETUP_SINGLE_ISSUER for
 IORING_SETUP_SQPOLL
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250904170902.2624135-1-csander@purestorage.com>
 <20250904170902.2624135-4-csander@purestorage.com>
 <07806298-f9d3-4ca6-8ce5-4088c9f0ea2c@kernel.dk>
 <CADUfDZovKhJvF+zaVukM75KLSUsCwUDRoMybMKLpHioPpcfJCw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <CADUfDZovKhJvF+zaVukM75KLSUsCwUDRoMybMKLpHioPpcfJCw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/8/25 12:11 PM, Caleb Sander Mateos wrote:
> On Mon, Sep 8, 2025 at 7:13?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 9/4/25 11:09 AM, Caleb Sander Mateos wrote:
>>> IORING_SETUP_SINGLE_ISSUER doesn't currently enable any optimizations,
>>> but it will soon be used to avoid taking io_ring_ctx's uring_lock when
>>> submitting from the single issuer task. If the IORING_SETUP_SQPOLL flag
>>> is set, the SQ thread is the sole task issuing SQEs. However, other
>>> tasks may make io_uring_register() syscalls, which must be synchronized
>>> with SQE submission. So it wouldn't be safe to skip the uring_lock
>>> around the SQ thread's submission even if IORING_SETUP_SINGLE_ISSUER is
>>> set. Therefore, clear IORING_SETUP_SINGLE_ISSUER from the io_ring_ctx
>>> flags if IORING_SETUP_SQPOLL is set.
>>>
>>> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
>>> ---
>>>  io_uring/io_uring.c | 9 +++++++++
>>>  1 file changed, 9 insertions(+)
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 42f6bfbb99d3..c7af9dc3d95a 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -3724,10 +3724,19 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
>>>        */
>>>       if ((flags & (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED)) ==
>>>           (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED))
>>>               return -EINVAL;
>>>
>>> +     /*
>>> +      * If IORING_SETUP_SQPOLL is set, only the SQ thread issues SQEs,
>>> +      * but other threads may call io_uring_register() concurrently.
>>> +      * We still need uring_lock to synchronize these io_ring_ctx accesses,
>>> +      * so disable the single issuer optimizations.
>>> +      */
>>> +     if (flags & IORING_SETUP_SQPOLL)
>>> +             p->flags &= ~IORING_SETUP_SINGLE_ISSUER;
>>> +
>>
>> As mentioned I think this is fine. Just for posterity, one solution
>> here would be to require that the task doing eg io_uring_register() on a
>> setup with SINGLE_ISSUER|SQPOLL would be required to park and unpark the
>> SQ thread before doing what it needs to do. That should get us most/all
>> of the way there to enabling it with SQPOLL as well.
> 
> Right, though that may make io_uring_register() significantly slower
> and disruptive to the I/O path. Another option would be to proxy all
> registrations to the SQ thread via task_work. I think leaving the
> current behavior as-is makes the most sense to avoid any regressions.
> If someone is interested in optimizing the IORING_SETUP_SQPOLL &&
> IORING_SETUP_SINGLE_ISSUER use case, they're more than welcome to!

True, though for most cases that won't matter, but for some it certainly
could. I certainly agree that this is a problen that's best deferred
anyway, SQPOLL is a bit of an oddball use case anyway.

> I appreciate your feedback on the series. Do you have any other
> thoughts on it?

Looks pretty clean to me, no big concerns honestly.

-- 
Jens Axboe

