Return-Path: <io-uring+bounces-1019-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 953FB87DA79
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 15:40:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28498281E98
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 14:40:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25CBA17BA6;
	Sat, 16 Mar 2024 14:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wJq3dDp3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37133168BE
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 14:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710600001; cv=none; b=KOTGLvGj8gL3Qgmerg1IGCC78RHK9h/raDhkJZvC7FYLp+tUNCjN3kGNwlhQ10A+gNenewWIBvIqEIZVkHzrai6yUlrHNDRocCA9O+fKf0W4L2r7oObtoGR7aC7gHuYN3NWsK1c1L1G8io2qLf/JVRMVQwJxwRs06xSbsv7zQXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710600001; c=relaxed/simple;
	bh=73OXW6pTlGLLBW9MfEBQwW+BVRiIDp238X1M+JI7Yxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IX7jC+n9+xN2ojJ1aqMuTQ5tMlsTllgsJAaXfh1hRGVJoRfKd5YsUSxGFn0I62uZ4XdVCMsJXKPovZ2A4PoOChzu9osIOMWxtgGqHAAEIOpgJduwJRd7QVG1QNo2/f/rBn/xT8ReIrMo78/mV+DyXijiLDB5v1LYBlIf8KZDdEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wJq3dDp3; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-29c572d4b84so1067246a91.1
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 07:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710599998; x=1711204798; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zZ4yFo1VyLJ+y6QT4dGRiJ5jwQSp3a2Nf6zrdn6LrkY=;
        b=wJq3dDp3x8JNA0BEpUKNU9cZD1KHMMZYtrE0vOWUOoCUL8GS73DWCKEY4ue+WVhims
         VyN25DXyUu+PMh0R5DzPbxNcWXHOh3PDOlNesJSsf8QHTZNMZkKTTdGbsEDbX+sltiu8
         7MqGDC8CJGKNRrQQBZs/ugxx8c80sUUeAxWju7Bx+rO+c8G03KgOVtWSS4gD71gcjfuu
         D0vXl08DcPzTvkb8xQx7XMDCsdZVJHvet59LuBzQ8NkzbHiAPGCkYSv/XY+hiDemJM9K
         RCM1pUmdHWPa81TWL5m7CzOZH/xNt4eVkxkqUbnzTLIndmx2EkI+hAKCN8h8LspAm1cl
         pvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710599998; x=1711204798;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zZ4yFo1VyLJ+y6QT4dGRiJ5jwQSp3a2Nf6zrdn6LrkY=;
        b=k/GLfbU8m4NC38NNDv1m50IMig7W7ZivttKLmqaAeMY0W/+aeIfzTM85xrsOurqf8+
         yZIbLDLsnvYEYLZbDpNtmBUVS0ogoXBRq6guaUTLgoApDZfh6G+4VF//Iu2ZlleFEvn0
         5gdoUhY2tWgSZu1LxvhWfycZ8LpZ3fBDxyw7x6eFPssW6i7CraO2xANCIVWS0fxL7NcN
         fu+qqSN0snc6tRwSvwqZ1/2wuD/ArlpfA83s2jfm96ZNBn5aOM+q2VNBHJGgEmspV/8s
         WvCTluE9jQmJP3DCpQ1RQ/ChJktQq5tRPbVOlZYjtaRtP9ezkt1x8LgPeQIWs4oTWQrE
         fBew==
X-Gm-Message-State: AOJu0YzR6070nFuAuzKqybM3VWogmFIzbDjhV5badbDp70DdvnBME0xo
	sS0eVhC5pxHKDhKqi5yFIO0ESdljTGBDDxuuZxhiZSsCePR6+gv9IuHjtvcWd4w=
X-Google-Smtp-Source: AGHT+IH7g+QXYVmugrseha/BLqq3hWUtLMbdjmNSj54K7/SSF/tjFNdICksn4ozdpOP2T2RYQ0+wpg==
X-Received: by 2002:a05:6a20:8e09:b0:1a3:5666:8d79 with SMTP id y9-20020a056a208e0900b001a356668d79mr2477751pzj.6.1710599998490;
        Sat, 16 Mar 2024 07:39:58 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id gu25-20020a056a004e5900b006e7040519a1sm1641272pfb.216.2024.03.16.07.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 07:39:57 -0700 (PDT)
Message-ID: <f03f3a74-38ad-4ddb-8ce8-d3de2ebfeb3e@kernel.dk>
Date: Sat, 16 Mar 2024 08:39:56 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
 <ZfWIFOkN/X9uyJJe@fedora> <29b950aa-d3c3-4237-a146-c6abd7b68b8f@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <29b950aa-d3c3-4237-a146-c6abd7b68b8f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/16/24 7:27 AM, Pavel Begunkov wrote:
> On 3/16/24 11:52, Ming Lei wrote:
>> On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
>>>
>>> On Fri, 15 Mar 2024 15:29:50 +0000, Pavel Begunkov wrote:
>>>> Patch 1 is a fix.
>>>>
>>>> Patches 2-7 are cleanups mainly dealing with issue_flags conversions,
>>>> misundertsandings of the flags and of the tw state. It'd be great to have
>>>> even without even w/o the rest.
>>>>
>>>> 8-11 mandate ctx locking for task_work and finally removes the CQE
>>>> caches, instead we post directly into the CQ. Note that the cache is
>>>> used by multishot auxiliary completions.
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>>
>>> [02/11] io_uring/cmd: kill one issue_flags to tw conversion
>>>          commit: 31ab0342cf6434e1e2879d12f0526830ce97365d
>>> [03/11] io_uring/cmd: fix tw <-> issue_flags conversion
>>>          commit: b48f3e29b89055894b3f50c657658c325b5b49fd
>>> [04/11] io_uring/cmd: introduce io_uring_cmd_complete
>>>          commit: c5b4c92ca69215c0af17e4e9d8c84c8942f3257d
>>> [05/11] ublk: don't hard code IO_URING_F_UNLOCKED
>>>          commit: c54cfb81fe1774231fca952eff928389bfc3b2e3
>>> [06/11] nvme/io_uring: don't hard code IO_URING_F_UNLOCKED
>>>          commit: 800a90681f3c3383660a8e3e2d279e0f056afaee
>>> [07/11] io_uring/rw: avoid punting to io-wq directly
>>>          commit: 56d565d54373c17b7620fc605c899c41968e48d0
>>> [08/11] io_uring: force tw ctx locking
>>>          commit: f087cdd065af0418ffc8a9ed39eadc93347efdd5
>>> [09/11] io_uring: remove struct io_tw_state::locked
>>>          commit: 339f8d66e996ec52b47221448ff4b3534cc9a58d
>>> [10/11] io_uring: refactor io_fill_cqe_req_aux
>>>          commit: 7b31c3964b769a6a16c4e414baa8094b441e498e
>>> [11/11] io_uring: get rid of intermediate aux cqe caches
>>>          commit: 5a475a1f47412a44ed184aac04b9ff0aeaa31d65
>>
>> Hi Jens and Pavel,
> 
> Jens, I hope you already dropped the series for now, right?

It's just sitting in a branch for now, it's not even in linux-next. I'll
review and look at a v2 of the series. So it hasn't moved anywhere yet.

-- 
Jens Axboe


