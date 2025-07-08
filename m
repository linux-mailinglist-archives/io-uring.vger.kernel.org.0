Return-Path: <io-uring+bounces-8621-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F143AFD5D1
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 19:58:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50C7C1C2412D
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 17:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE172E6D03;
	Tue,  8 Jul 2025 17:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JjnaSApD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDF022FDE8;
	Tue,  8 Jul 2025 17:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751997523; cv=none; b=f3xMgFRM6kSHcIAzX73h6qIgaal4og8dWg1gCU8eu9ueIEc1p073kxcrzegTF2LykUSC5umEAK6RDeBSfaOQDnlJUlWXMWwY4F2ANSb3/solClyu2CLYcHpgnCW1FipGkIeNk3ghjEvHrhQlYzz983N4vRV95q9I4qseKvCf+fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751997523; c=relaxed/simple;
	bh=glaERo1/6Amz3ak0rD1cjV7JDoLLcXj+fnCaYbWB+e8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZgtXpkH2jG9fYWSPkpmVPGH9zJakk871KcGLkWgfy5ME0a9XIu/ODY5PgNuoAwX8SdfdIK9kjbrqcX4WnnPU5VidO5XERyVxTctQYvTuZq7Wo6lDV5AQri+lYwXmcSzmjUeGdPa8Oh062G2ZuBVgXPUnsWmTkON7qy8rD6gP3Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JjnaSApD; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a510432236so3106022f8f.0;
        Tue, 08 Jul 2025 10:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751997520; x=1752602320; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=//VSDeb2ydbRuKrirTEUBo5ZkT0z7lXZgvobEWM8eTs=;
        b=JjnaSApDSiXi3M7Et0wuWROtqxaDqcWwBgbwozm5ZVYfOkee/LhXKl4gH27atV9uCs
         /HUJ+nqRmhf1yx0mjf+bIcZFMsAMJmH6lw/qAM492iWDl2X8TrF6w7PmTBESWP/4cin7
         hU2PD9n6okwh5wZzV3nh8vmD6Q2Z8VleIS4r0YHWIBHE9pfj6dSAR+3IC8ceAzCSRFk4
         1CSp/F0vDKFxXYVsi8GcYS2ZAedch8WDols1L3fISfJ7KAbfKB8lu5EpNosE/Oc+Zx3I
         mBAyNZ8VMgyKFaMNcBV78e1CRbjlN3GoEPHuUX2flgZjhw8j0MrLGPpZAkJXgU5RwU6B
         TVLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751997520; x=1752602320;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=//VSDeb2ydbRuKrirTEUBo5ZkT0z7lXZgvobEWM8eTs=;
        b=IdqYALSRkHg9hiAO8ZkTOIIgFEHAtqSK8ZP2al0BrAvL9CShHVINHabyno6h25fw1Q
         lI8ePNtQ5cwU1SjovWOGRqEDmDqACxSp0dqbBtxT2ZMn0KLiBbt3YIMQcBaZHoWdNMln
         PfuS+QQH8X0hSheKkdVRZ8jMPams2sCD9maPC9tV0ZR8wfqOXfSKYSB+gtFugbt38fuA
         VjfhSmzi7MV0iVd4CyA89MTfva6w7eIYOvXECUKiw5/14j72BexdvVO+9IV4WwMau4qW
         HLOmIhxslsh49UJ9CSpkurVRknvZR+PQhFk0gPsJRZhsa6OruOXrWsY4aunrn20aBklm
         2miw==
X-Forwarded-Encrypted: i=1; AJvYcCVM96KNh/xLYV0HpYxEGYUvAkTaQDdMkR6AXl12EMgupWeD2ucODLA2nXLX/CmYhoe2U6SKZWQgDg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxiM1T4/aISZJsO9EqqrB2OsfzarH8KKcPV5i6X7V+mmq/5nDcQ
	vr39UVEpTzWmcoXO0kjxMt04yWROTyd3WwH1j+aPVmdk53WLFmaFPC0L
X-Gm-Gg: ASbGncsuT5zl/jizN0Atl7oJe0XuORT/syaSloMw4iE+dwgJNzZK0ps/014ufeUWqsH
	QKCqxSHYEFXLB/MHZo9/3rHQWT7NPi5hO9mB8191BcNhGDCvaS0OswyzNwv8IUU4/w/VDjFd7Zw
	6I5B2MzfRTNqvv14LGeJy2X/nuborz5zL5VpYrKOWWPfkuSwQIcbipzYW9sOMENwUuTg3+v6bwR
	hG2KqWd4s2KIPCUX4rJzT9tn7E22kYq87hhndNS0zLmfsunqE6LmBDynacPUtzMxHmBLCJbqOWr
	bgsp5cLraG1eVy+YvjJPcDJWb2rsGWZ8OeA+sQDQ7GNhBilIHfNr2cw0O4idHZsgBTDqedo=
X-Google-Smtp-Source: AGHT+IHKSnqnZ83ElcCvcguQfEqFBYUZchWhHHZR4Tzovvi1Bp9b3FQshVkUkmgaZzo8QYuDa1qsxQ==
X-Received: by 2002:a05:6000:25e6:b0:3a3:5ae4:6e81 with SMTP id ffacd0b85a97d-3b49700c54fmr13600837f8f.8.1751997519317;
        Tue, 08 Jul 2025 10:58:39 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.115])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b47285d3c6sm13713084f8f.95.2025.07.08.10.58.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 10:58:38 -0700 (PDT)
Message-ID: <a8ac223d-6bb0-4c47-8439-b0d0de4863dd@gmail.com>
Date: Tue, 8 Jul 2025 19:00:05 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH v5 0/5] io_uring cmd for tx timestamps
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <caba8144-4e27-4eaa-9819-8601d66988a5@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/8/25 18:55, Jens Axboe wrote:
> On 6/28/25 12:10 AM, Pavel Begunkov wrote:
>> On 6/27/25 18:07, Jens Axboe wrote:
>>> On 6/23/25 9:01 AM, Jens Axboe wrote:
>>>>
>>>> On Mon, 16 Jun 2025 10:46:24 +0100, Pavel Begunkov wrote:
>>>>> Vadim Fedorenko suggested to add an alternative API for receiving
>>>>> tx timestamps through io_uring. The series introduces io_uring socket
>>>>> cmd for fetching tx timestamps, which is a polled multishot request,
>>>>> i.e. internally polling the socket for POLLERR and posts timestamps
>>>>> when they're arrives. For the API description see Patch 5.
>>>>>
>>>>> It reuses existing timestamp infra and takes them from the socket's
>>>>> error queue. For networking people the important parts are Patch 1,
>>>>> and io_uring_cmd_timestamp() from Patch 5 walking the error queue.
>>>>>
>>>>> [...]
>>>>
>>>> Applied, thanks!
>>>>
>>>> [2/5] io_uring/poll: introduce io_arm_apoll()
>>>>         commit: 162151889267089bb920609830c35f9272087c3f
>>>> [3/5] io_uring/cmd: allow multishot polled commands
>>>>         commit: b95575495948a81ac9b0110aa721ea061dd850d9
>>>> [4/5] io_uring: add mshot helper for posting CQE32
>>>>         commit: ac479eac22e81c0ff56c6bdb93fad787015149cc
>>>> [5/5] io_uring/netcmd: add tx timestamping cmd support
>>>>         commit: 9e4ed359b8efad0e8ad4510d8ad22bf0b060526a
>>>
>>> Pavel, can you send in the liburing PR for these, please?
>>
>> It needs a minor clean up, I'll send it by Monday
> 
> Gentle reminder on this. No rush, just want to make sure it isn't
> forgotten.

You already merged the (liburing) test

commit 21224848af24d379d54fbf1bd43a60861fe19f9b
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Mon Jun 30 18:10:31 2025 +0100

     tests: add a tx timestamp test

-- 
Pavel Begunkov


