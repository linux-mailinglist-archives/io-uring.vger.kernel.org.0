Return-Path: <io-uring+bounces-899-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8294E879AD5
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 18:54:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2615283E3D
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 17:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7920F1386B5;
	Tue, 12 Mar 2024 17:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LyOMGNti"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD217CF35
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 17:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710266078; cv=none; b=U7GtBrDPyI/UZyIeSqyp3pnOcDTRcQLInjzel5IUhk3W+ewOirSiUxZ8ltFnSKggRWbW19a/VqZzGHzvZ95Gu71c5LrWCPlqnUi+GtVUG0NrFS+8NQuXhhHX31TDZJQ9k/JsjylUtpLpadCRpg1pltFp4SLFczEa0mAE/WRhb+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710266078; c=relaxed/simple;
	bh=1dMqk2JDvIME7s9z3lYxtaHNAky6PAHnCcMJUONdnAM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=l6Z0CTnARKgHJZ3AHQNRcKcThZuyF31CcD5C/DQPZnmcN8M+OUIIjDChz+ddIfIH+6pV4GObBOhuttWZEzjB0c295+clPMNZXwJTB4vJcZWRGSQqGdaMyJHVIcFZVfJhSZ72pfpn4FUxaLMQU+ukFAhpx2Ec3oy8N4tngeXLxHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LyOMGNti; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1dd3c6c8dbbso9720695ad.1
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 10:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710266075; x=1710870875; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7Lc1k3V9a/jyoMl1MPlT4vJVEugebv8lX4qr+r+dj/4=;
        b=LyOMGNtib6fhUmht/Y2QKIU68g7NV8cMONB0Qy4GSngMWqYVgwmKDUwA4litHJ1DQd
         G44O4t6Hn7Hh49ueRaIaCY222dMtELYMOZDe3YR2Fd6vnCuzK6ScJQRRlKEUmN0e6nid
         dbZhDWk0hHFcbZGdQ9fNlppbkUmTNgOj4Ah+OF4TzmSbRBCWgMn8W/HnfOfQ3TdYxHJO
         TeNtcXfLzsYJRJdtZNvJeg5prcBo3fDn/l1FNDuQmok08hZ4dcUM4Gn0GmKP8huR9GDB
         mL9CJ8ky5E729+61Lz6JzFwkmQMI+EBrFzVnbMEpZfrF9hR4dHCxSaNcG815bUlcTn3m
         6JfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710266075; x=1710870875;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Lc1k3V9a/jyoMl1MPlT4vJVEugebv8lX4qr+r+dj/4=;
        b=SAYF4CmOCK3V+g+BFDu475Miz50rOnlp15zJgEPwEgc2ESZECOrzCA7VFdN6ttrs6V
         E2QInY/lqCMbonFDjA5vvQfCCIkYNGXp4Ja5HVEBh4TTDKhdBwpI31V29bhL6JpAedw1
         FaUJI8F4NgNAZm7QqgCt/h34KGZEIi4yMFMHT0WiG68LNMcSCMVHnzuxtxGN74Bg/eMg
         iNLY24EBDBT+GEk/Ehv+RNdcVWcIXpitEWjQgs4ZuuDgRsR7OoohaA/C+HtVtivQdu00
         1ySpyAWrsqtsJ1QoGLe/2UklbAQpS4ZjhNrGLF2XN7gkglHmzqxXJ9A+DLhS7YthdIpb
         bYhg==
X-Forwarded-Encrypted: i=1; AJvYcCUY+yGUrAPz60DRaQ8i76W7XD5z+C0NGmpUYbXI1WCIvqKgna66uiJr4eqQgVidW36PthOtVqxeDe63mcuAElSC1pv4xvT+0EY=
X-Gm-Message-State: AOJu0YxvBjLugyqqhxtiFHgNz4Ek5ahEpltVwI9NHGVkKKbdKX+8HISd
	Amq7fAuJVUeYMQNKvHmIRTTMzWk/g12Xir4ToCDPDdaovc3hg5xm9lCK/LX3XtY=
X-Google-Smtp-Source: AGHT+IFU7Wcw3x+gYZo9ooLBLSB40PkntNMm1FYmyQCfzwq08peolf7EsabpWj4e6VcNcbf/cLTDVg==
X-Received: by 2002:a17:902:8a91:b0:1dd:7350:29f6 with SMTP id p17-20020a1709028a9100b001dd735029f6mr2507951plo.3.1710266075395;
        Tue, 12 Mar 2024 10:54:35 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id kj14-20020a17090306ce00b001dd3bc79142sm7004708plb.264.2024.03.12.10.54.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Mar 2024 10:54:34 -0700 (PDT)
Message-ID: <085beb85-d1a4-4cb0-969b-e0f895a95738@kernel.dk>
Date: Tue, 12 Mar 2024 11:54:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10/5.15] io_uring: fix registered files leak
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 Alexey Khoroshilov <khoroshilov@ispras.ru>, lvc-project@linuxtesting.org,
 Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
 Roman Belyaev <belyaevrd@yandex.ru>
References: <20240312142313.3436-1-pchelkin@ispras.ru>
 <8a9993c7-fd4d-44ff-8971-af59c7f3052c@kernel.dk>
 <466e842f-66c6-4530-8c16-2b008fc3fbc6-pchelkin@ispras.ru>
 <fb57be64-4da6-418b-9369-eae0db42a570@kernel.dk>
In-Reply-To: <fb57be64-4da6-418b-9369-eae0db42a570@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/12/24 9:21 AM, Jens Axboe wrote:
> On 3/12/24 9:14 AM, Fedor Pchelkin wrote:
>> On 24/03/12 08:34AM, Jens Axboe wrote:
>>> On 3/12/24 8:23 AM, Fedor Pchelkin wrote:
>>
>> [...]
>>
>>>> I feel io_uring-SCM related code should be dropped entirely from the
>>>> stable branches as the backports already differ greatly between versions
>>>> and some parts are still kept, some have been dropped in a non-consistent
>>>> order. Though this might contradict with stable kernel rules or be
>>>> inappropriate for some other reason.
>>>
>>> Looks fine to me, and I agree, it makes much more sense to drop it all
>>> from 5.10/5.15-stable as well to keep them in sync with upstream. And I
>>> think this is fine for stable, dropping code is always a good thing.
>>>
>>
>> Alright, got it. So that would require dropping it from all of the
>> supported 5.4, 6.1, 6.6, 6.7, too.
>>
>> Would it be okay if I'll send this as a series?
> 
> Yeah I think so, keeping the code more in sync is always a good thing
> when it comes to stable. Just make sure you mark the backport commits
> with the appropriate upstream shas. Thanks!

I'll just do these backports myself, thanks for bringing it up.

-- 
Jens Axboe


