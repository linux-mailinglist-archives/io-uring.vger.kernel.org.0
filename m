Return-Path: <io-uring+bounces-6091-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8031FA1A65B
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:57:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42C0A3A7179
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2664121128D;
	Thu, 23 Jan 2025 14:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MPYqJ84T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C42321147C
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 14:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737644246; cv=none; b=qWlHhw0FQwT4G32n7jQzuJwjBpV7QHiYMmllrnak8sKghgH5ooBAi6pOko57F0k+kwrCcSeFcFX3CCO3/k5JPJNFVY/zImou+1Vp3D1WzynB+8LBAixraCOTojsToj2at9qnLwHFR9sCnvi5RNZn5TyY5uqBW+5ujaAA6mIJ9yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737644246; c=relaxed/simple;
	bh=gDHAMA2pQKQBNdSc75WaLSsS4G7nbpHUPidhG5GOgb0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LvBLmUHN73iGNJxYe/zCeLH6BFiFXv48ytYZ80GGq+v5Vw47JmMwOxZcvz17uBqXXS/lgnyxRtZhDPvL45UO4kTBX51VIbxXxsAwgEdltyM+8B/8cxJgIZilsUalurQA9h0i/r3tEW59XrtCocnZIvbP4bRjXayrLxdC0msubME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MPYqJ84T; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aafc9d75f8bso183838766b.2
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 06:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737644242; x=1738249042; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CYhIO1OYtAmLOe8jueYJCCzSTDBNvt/3I1/Ahc7Gw00=;
        b=MPYqJ84Ty0urpY8HlHxw8goJ0sD8IUWC7iYPuBYE0FIsevOvVOvwyrQ/YPVwUYOYpH
         wMuB6UvLjgbpYIpl8VY7lSsV5x2b6KKR5XgTZYR8D4zvGEAGVU0EtHh6ZDwr6BNQ1Ftd
         GoD0+khomlW0k07Bgp+XvmN9KK1yWu5V7O/GuzPoryN/Z1gwOnG6ZJz/kUP4w7zNUXOs
         eRIG9QVE8XWLC+ERimLwmS/WgOa3Wn1a4SoK7W6PcZlVA+0cx1imfPD6rSjxlJioc0qt
         MccLYmqzNN+SIHbQ+joOVEGXdpSCSPDHIXOOsetXkhgDxBLcoo/FQGLF0inryq57vhXs
         DOTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737644242; x=1738249042;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CYhIO1OYtAmLOe8jueYJCCzSTDBNvt/3I1/Ahc7Gw00=;
        b=n+QGxTjQuBHaB1HGy7L5XOLC1tLDoRRpWTM9y++QK1F9gM0XsJI306WkBsX9j1n72U
         nec76qhcmVRNKn0dCQKIXcKo9hjh6Fz523C3cyDad8rOY5QS9dSK1Dh/O9PYJ3F4laOQ
         idvaw66YpNB9oN0Xuk2Y5CQINblC6peoM7XBGC/o7PcmFthh38brSsMhKnAgEP/FSHX4
         jqnCwLNcIlmmqXh8ZJLO9CoTiRyocR+YOUPCGQ0ctVvGMCLat9DoI2fHn9ffiS/9uT3W
         DDxdez4/leQZ2tZ5YPHqKMe/HWTJRXcju/aOaRQ+/PrJz4axEYB41Y6i9P1G4v8TxQq+
         5oRA==
X-Forwarded-Encrypted: i=1; AJvYcCUbru0mJyLp1BbM0okO+BkXqoIIb9/IRCsyZ86pk2MyfP+G1e9G4WS5y+zxWrSMcnTiFNkLS1FJig==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2XlyJJZqFy2tuhooPn0jgV5FIN+QcYF9HNxDUvmCnCo7zKmjm
	5y3apv1/5AxlTF+rkdTAU+/fbZnzk/NtX0LF7gwvMNg7C+efqz+MlbD+xg==
X-Gm-Gg: ASbGnctbjdL3OcOVNPSiZt2RZBh8xIpKAWZ8ARov7vbk8jgPKuvnEzyCujUt68jLwLK
	kuKz3VmLKn0mAcmS8YJAUieQtyYFAp2eLUTCzHdFp0ubHlDT68IPd24uHSKyiGLyuDr0N9Rlr4K
	F9y9a3TJioh6BFux+GV0bfrVLWoqejP4nkmg9LV9cPD8U2O/5y7mM3/Bs7NXBNB0t6dpaedK+mP
	r25ZGpZtxe3dorwZZYaKuhdQueZY1/rIXZByM2t+OAvejZkkfF3MYSjfYRqpSdHGNjbUjU5+wRr
	G5Uf/pGqeZHoOpuW7TS/5DJX4Yvki+PC7sL3ug==
X-Google-Smtp-Source: AGHT+IFeLm7RUZ25aLWb2i+kXmoy7kTtg/nKnlYsMNuMEPmn3+QgAhlvoXQcLtRCDwQBpq+yx7wxKA==
X-Received: by 2002:a17:907:86a8:b0:ab3:6311:5bd2 with SMTP id a640c23a62f3a-ab38b42e6a3mr2487391666b.40.1737644242354;
        Thu, 23 Jan 2025 06:57:22 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:7d36])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f2918fsm1091712966b.91.2025.01.23.06.57.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 06:57:21 -0800 (PST)
Message-ID: <2fbf17ab-b7c3-4a5e-a435-f658a42ac8a2@gmail.com>
Date: Thu, 23 Jan 2025 14:57:55 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/uring_cmd: cleanup struct io_uring_cmd_data
 layout
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: krisman@suse.de
References: <20250123142301.409846-1-axboe@kernel.dk>
 <20250123142301.409846-2-axboe@kernel.dk>
 <914661c1-4718-4637-ab2b-6aa5af675d23@gmail.com>
 <832dd761-32ad-4b7e-8d6b-1fae9caf5a83@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <832dd761-32ad-4b7e-8d6b-1fae9caf5a83@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/25 14:54, Jens Axboe wrote:
> On 1/23/25 7:38 AM, Pavel Begunkov wrote:
>> On 1/23/25 14:21, Jens Axboe wrote:
>>> A few spots in uring_cmd assume that the SQEs copied are always at the
>>> start of the structure, and hence mix req->async_data and the struct
>>> itself.
>>>
>>> Clean that up and use the proper indices.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>    io_uring/uring_cmd.c | 6 +++---
>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>> index 3993c9339ac7..6a63ec4b5445 100644
>>> --- a/io_uring/uring_cmd.c
>>> +++ b/io_uring/uring_cmd.c
>>> @@ -192,8 +192,8 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
>>>            return 0;
>>>        }
>>>    -    memcpy(req->async_data, sqe, uring_sqe_size(req->ctx));
>>> -    ioucmd->sqe = req->async_data;
>>> +    memcpy(cache->sqes, sqe, uring_sqe_size(req->ctx));
>>> +    ioucmd->sqe = cache->sqes;
>>>        return 0;
>>>    }
>>>    @@ -260,7 +260,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>>            struct io_uring_cmd_data *cache = req->async_data;
>>>              if (ioucmd->sqe != (void *) cache)
>>> -            memcpy(cache, ioucmd->sqe, uring_sqe_size(req->ctx));
>>> +            memcpy(cache->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
>>
>> 3347fa658a1b ("io_uring/cmd: add per-op data to struct io_uring_cmd_data")
>>
>> IIUC the patch above is queued for 6.14, and with that this patch
>> looks like a fix? At least it feels pretty dangerous without.
> 
> It's not a fix, the sqes are first in the struct even with that patch.

Ah yes

> So I'd consider it a cleanup. In any case, targeting 6.14 for these
> alloc cache cleanups as it got introduced there as well.

That's good, makes it not that brittle

-- 
Pavel Begunkov


