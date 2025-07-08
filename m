Return-Path: <io-uring+bounces-8623-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FFE6AFD5E7
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 20:01:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F018D1C249C3
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 18:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2563C21B9DA;
	Tue,  8 Jul 2025 18:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MjaWd9Wd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FDA21A421
	for <io-uring@vger.kernel.org>; Tue,  8 Jul 2025 18:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751997664; cv=none; b=b8+vt2RjguzGAlzJDTul+JOsrDBmq/tRY8+zVwM3xOD2CG2t0I8sdrLfESt4Ihf/5hFJqYz4lHW2ConxhLG+QNJteOJwZkvXKaDYWNFsIY1ecxBYrWH+lHel89td1PEOrx9dxt4JJJ1glEvsZpfEXqE3LCsGHyQP7lYXrFSJC/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751997664; c=relaxed/simple;
	bh=+USx5CH57n6QwmD2K0OGycX899v5Rmxu0jTTkKyLlwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tet0UTQeEsvp2ipOHvOHnnErZNFLDbznZtAQNlQmP+MyFi3cs2zSJVfmoDTfT47m9gFRq2i4MGo8OT7/4neQzqjxgaugsDHhzsTPt4dkH4wpwpmTPp/gtoV3ynI5ZwnFe5GJQ1f2Y+4HF38flVtsNCgKFVBES9+PXliEXLcnnKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MjaWd9Wd; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3da73df6b6bso17540965ab.3
        for <io-uring@vger.kernel.org>; Tue, 08 Jul 2025 11:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751997662; x=1752602462; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=so5kYvoSvBzjaegr3s+w/1MNs5lssVlBMaQJAReKVt8=;
        b=MjaWd9WdPPYYymm/DXx6U9+uqpuatttGIu2dvZD1JFsznabbaGWAczuF43jPGNSZ5b
         rrx67aW7U8j+BdxRim3pQhwUBRZ/S31OwLgMQs4pxIXtSpyMNSrAVWs0lZgrBwzQq4re
         k2qi0/Ec2c2E27MQYhskyoALcGKxFC2VX0wx8zBDALvIJgkyZzrfE69JnwIFhY3F2iFw
         W/egwcSTlItuGpSIT+A3A0hODOUuIvwTsycmK1YEEtuZBKQzUrLAuxXebPY3Ivt2xU9f
         vQKWd/L/CXoA741kwejm+bSLf2AgCexczZzU2feF5Zh/7sEArUMVJBbdxSCoKz73xbGQ
         jaiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751997662; x=1752602462;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=so5kYvoSvBzjaegr3s+w/1MNs5lssVlBMaQJAReKVt8=;
        b=JSYkTtIw7Gb7qiRTMjys5ssqvgf7XmqHvcr7+7h43NznQdGOPT5PYtrVaK43cdRytC
         P0JVJTJSkhZebDY1IJSo9t+HmOZ/aYcQyhsPw0LfEE2JDGI/Yrge2goeb9O6JZQOtXni
         Q3Y3MHBDooDOdXYUV2G/pO3iFA1FaattcyxT4SmRsDMvOoQW3fWWwX1Pd7AqW7rAm7hh
         z+rfYglhWDrtWhx6jpv2GEA6doRaKAJ2vSisF0HKb/McMgQDADytRWf/BfTaBZKAcNTJ
         pBJQuU9hsBhLJ34IRvaxM1pUS+699FBVsuW+5lNE1HwwFGb/i2qDwEfguDUt1KYi/TxU
         OR8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWtXZgHUsn3vv2mx/9apdpKuvCRSmS7RVmq5IIXOawh5tNPoVQOZbeGUnJv3z+0f/9YzRISIgnxlw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMIveWz5trw40RQeeyaGIm90RYDpwwtM9pUG7B00CwMGfm04G7
	uDLel8Ot+I/TcFxZLK9/T9F4u5TQSyqTDXkCQkYJVsjwbHn7kGG5GTyugaZ7qE8N68w=
X-Gm-Gg: ASbGncu7BVLJVFBR7gAzQqlicoFU+ldRHi5IVcNP5N2uTzc397vrbzosVe7qFq50EVL
	e2yWQwL/u4Em1MslTy+jxu2qWRy0FPKShaLqv9uvFx6hB1NSRKxCr9wbhq3Gr2ErtC+8m23nfAQ
	EoGoQiFA42o9ambhdIMsul+K3GccYzG2kZ+jkgARkQlwHlRytis8dryDFtA01aMmeWD0DJHQeM2
	UIXCcNeOXKM9osFsAI3YXXz6SLp8SbDyH6k2021e8ayNm4PS20SqftDDQ7dTBRJJQPS74lV/I2/
	Mky3Oora4dg8uM59QM2LufhnX8k8jHUsE/WdtNiuUHHR/qfgtXo2GcqOrQ==
X-Google-Smtp-Source: AGHT+IFtPgVsC0Dx3w9AbbC/p8IouDOmZruioyseA2FMsL3Zxakw0A33b0jn5x9d2fV9wQVF3L/UBA==
X-Received: by 2002:a05:6e02:1f86:b0:3de:128d:15c4 with SMTP id e9e14a558f8ab-3e136d0ff9amr155063835ab.0.1751997660907;
        Tue, 08 Jul 2025 11:01:00 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e0fe221071sm33769005ab.44.2025.07.08.11.00.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 11:01:00 -0700 (PDT)
Message-ID: <46642bea-f9d4-4b56-9d22-393567328075@kernel.dk>
Date: Tue, 8 Jul 2025 12:00:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH v5 0/5] io_uring cmd for tx timestamps
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing
 <kerneljasonxing@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
 <175069088204.49729.7974627770604664371.b4-ty@kernel.dk>
 <a3e2d283-37cd-4c96-ab0b-dfd1c50aae61@kernel.dk>
 <cf277ccc-5228-41dc-abd5-d486244682dd@gmail.com>
 <caba8144-4e27-4eaa-9819-8601d66988a5@kernel.dk>
 <a8ac223d-6bb0-4c47-8439-b0d0de4863dd@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a8ac223d-6bb0-4c47-8439-b0d0de4863dd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/8/25 12:00 PM, Pavel Begunkov wrote:
> On 7/8/25 18:55, Jens Axboe wrote:
>> On 6/28/25 12:10 AM, Pavel Begunkov wrote:
>>> On 6/27/25 18:07, Jens Axboe wrote:
>>>> On 6/23/25 9:01 AM, Jens Axboe wrote:
>>>>>
>>>>> On Mon, 16 Jun 2025 10:46:24 +0100, Pavel Begunkov wrote:
>>>>>> Vadim Fedorenko suggested to add an alternative API for receiving
>>>>>> tx timestamps through io_uring. The series introduces io_uring socket
>>>>>> cmd for fetching tx timestamps, which is a polled multishot request,
>>>>>> i.e. internally polling the socket for POLLERR and posts timestamps
>>>>>> when they're arrives. For the API description see Patch 5.
>>>>>>
>>>>>> It reuses existing timestamp infra and takes them from the socket's
>>>>>> error queue. For networking people the important parts are Patch 1,
>>>>>> and io_uring_cmd_timestamp() from Patch 5 walking the error queue.
>>>>>>
>>>>>> [...]
>>>>>
>>>>> Applied, thanks!
>>>>>
>>>>> [2/5] io_uring/poll: introduce io_arm_apoll()
>>>>>         commit: 162151889267089bb920609830c35f9272087c3f
>>>>> [3/5] io_uring/cmd: allow multishot polled commands
>>>>>         commit: b95575495948a81ac9b0110aa721ea061dd850d9
>>>>> [4/5] io_uring: add mshot helper for posting CQE32
>>>>>         commit: ac479eac22e81c0ff56c6bdb93fad787015149cc
>>>>> [5/5] io_uring/netcmd: add tx timestamping cmd support
>>>>>         commit: 9e4ed359b8efad0e8ad4510d8ad22bf0b060526a
>>>>
>>>> Pavel, can you send in the liburing PR for these, please?
>>>
>>> It needs a minor clean up, I'll send it by Monday
>>
>> Gentle reminder on this. No rush, just want to make sure it isn't
>> forgotten.
> 
> You already merged the (liburing) test
> 
> commit 21224848af24d379d54fbf1bd43a60861fe19f9b
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Mon Jun 30 18:10:31 2025 +0100
> 
>     tests: add a tx timestamp test

I totally did... Just going over old emails, guess it got lost in post
vacation juggling. Sorry for the noise!

-- 
Jens Axboe

