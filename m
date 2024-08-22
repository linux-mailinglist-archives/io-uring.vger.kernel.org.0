Return-Path: <io-uring+bounces-2900-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E12395BB5A
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 18:07:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 706E5B2180F
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 16:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2630C1CC17E;
	Thu, 22 Aug 2024 16:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nlme0MXb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFCA28389
	for <io-uring@vger.kernel.org>; Thu, 22 Aug 2024 16:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724342763; cv=none; b=mAXdWh1oN7QNJtKNHm5Brz7z0A2rb/1DdWO/cUjHPgDoPx58gy1PUET9b0zo9sIFtgL4srpeyjP9K6CHW2dNOPQr0SdHaQnLqNCQud7pg8XHhE0PLYz4quy2DxXRkazjEIRsZ74tPwntssvkSiyIlS+Rni/qoaXoqUcvokHeLCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724342763; c=relaxed/simple;
	bh=GurnSe8NZP/OIF9V2KaqO4OGMsdeUnyRdw/ep2ejpzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c+T7k54g825rT0cmcFCQW0R761RmDJisgPRjuziImgcNSgbR5sBLazec31IqlaVzu4hIHLV3BaTXGnrj1rZaAubJbpX10+1iAEWnRo/YdoJ4CkChNIOvb22MKQSvdEjd1jwSAFT4bMIJF5JEMO9MIIjQLgfluRvXQ6v2cZ+4XOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nlme0MXb; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5befd2f35bfso1383758a12.2
        for <io-uring@vger.kernel.org>; Thu, 22 Aug 2024 09:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724342760; x=1724947560; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kMGRraYcU9T0Nz7Odtk1K6EMerulIpJLx9kYGs3ZpI4=;
        b=Nlme0MXbqjzq7+SFWhxDY/CkypCPY3v2Hrw2t7u1ZCVSVoJP1YZAZhTNvpULAAxMeC
         o7FqjZmTx0hGHBb/mpaVM2FPiJTJNzPGOTtEyJyAegK32n+tVb/MPFeMAVrfHBoMNLmA
         5ZBJXxtC6PBucKyYxcqQDKITiS8vYMl7I2Z5t5uaVz/8WhDFqV7Gtx2btxi0RcT1PA/K
         g6Z40K86SqzMMLMbvfNg/MsN+fHHpCs6L/xMIA5eIk8VJEWdoqq33MSoRSufgC5HoZ6+
         Iioptt+uCJXG4z45aCLNPsbuPGSXKgycB7z9HO8GFrZtXo/yaBGBnxJ+zWDU6w0zJFLc
         9M/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724342760; x=1724947560;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kMGRraYcU9T0Nz7Odtk1K6EMerulIpJLx9kYGs3ZpI4=;
        b=bVLrtb2xb1ookg0jREyb5F8QeTnF+egBDCPTOOF5N38V+ykfb+KvHLPD91AdzBW6VX
         IOH8B4ztqgX1Kn/4fGNCPVZqegp+o5X2Xebanr29hAZk3P6m0k056jnpQKXszQbk1x2B
         YWSX+kXUnel6NtQIzfCEhkLJsze6wbHOJjEylBCHnrxsBhk5shVshF+vHa0Gwz5vZAld
         CpNqk3UY+4x6OYhTTQ4c6jsABF4lkfml5ebCLHT0fslvU1H/OT0Io9awnDzwrWjumDLS
         LfBN/RvA+qizsY7MJWSOytiUVUGmrF33Rr4iDPZ5EqQf2n5/ZQOW20co5YuzvuK+wE7q
         onYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkayZy6ginDcUCs5s6hY4T0KbftW4QPa0EgCupVrZQSm+CC6yJhxyESF33Py34vv4M8utbDfBd/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzcdHsvQy8ZSxXCCyhYq12Vgz/Fda+l3CG8IaeCA9D9F+fmO8/z
	DNnO16NRgnO1EJsL0ZokYYz0T0ru4Ux/MVrmwL1tRpWIQ/ObpMwHUYAsGg==
X-Google-Smtp-Source: AGHT+IGP9EHVjazEQAMPWHfYQ2lhsPwxVQjIAXwB2k8o5+LXNa1LH60N+phSlOmwKqxnZj3OUdHGVA==
X-Received: by 2002:a17:906:730b:b0:a77:f2c5:84a9 with SMTP id a640c23a62f3a-a866f27a133mr448149366b.18.1724342759015;
        Thu, 22 Aug 2024 09:05:59 -0700 (PDT)
Received: from [192.168.42.169] (82-132-212-177.dab.02.net. [82.132.212.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f4365b4sm136557966b.113.2024.08.22.09.05.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2024 09:05:58 -0700 (PDT)
Message-ID: <3087dde9-4dc4-4ed2-a0ed-4b60cf1e0cbe@gmail.com>
Date: Thu, 22 Aug 2024 17:06:23 +0100
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <fbb24fa4-3efe-4344-a4b9-982710e9454b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/22/24 16:37, Jens Axboe wrote:
> On 8/22/24 7:46 AM, Pavel Begunkov wrote:
>> On 8/21/24 15:16, Jens Axboe wrote:
...
>>>          if (ext_arg->sig) {
>>> @@ -2484,14 +2544,16 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>>>            unsigned long check_cq;
>>>              if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
>>> -            atomic_set(&ctx->cq_wait_nr, nr_wait);
>>> +            /* if min timeout has been hit, don't reset wait count */
>>> +            if (!READ_ONCE(iowq.hit_timeout))
>>
>> Why read once? You're out of io_cqring_schedule_timeout(),
>> timers are cancelled and everything should've been synchronised
>> by this point.
> 
> Just for consistency's sake.

Please drop it. Sync primitives tell a story, and this one says
that it's racing with something when it's not. It's always hard to
work with code with unnecessary protection. If it has to change in
the future the first question asked would be why read once is there,
what does it try to achieve / protect and if it's safe to kill it.
It'll also hide real races from sanitizers.

-- 
Pavel Begunkov

