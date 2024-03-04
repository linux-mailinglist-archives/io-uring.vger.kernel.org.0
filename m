Return-Path: <io-uring+bounces-822-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25544870FD3
	for <lists+io-uring@lfdr.de>; Mon,  4 Mar 2024 23:12:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A102CB26719
	for <lists+io-uring@lfdr.de>; Mon,  4 Mar 2024 22:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 639CB7F499;
	Mon,  4 Mar 2024 22:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KKfbQill"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA90C7BAFD
	for <io-uring@vger.kernel.org>; Mon,  4 Mar 2024 22:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709590125; cv=none; b=o04Af12Pa+nyGeFz6YQ5m7BRPB3TEs7U1o/+ii/gxYlMbtUlYxHIsEJ/K7t0uzynL8OxhBBZN1KvC0cx43dJ98Sq501F81Beyb1FL6CZTKDCTnRQLWbEiyroD+PQI61RP03Fxh5kUj8mOQsWCEYl1FAtSHR5Om5YEMLto1BFlGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709590125; c=relaxed/simple;
	bh=AZHcEAhiLyg3KUtvQ9YTvSG6aWjSjoM0TYrHjvE+ixU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iIQ7nxXDy4KHQgKjuHL5ScH9rVuG8Pe77bLS9024FD3lKQh2gWKxu3zbf3o3qvADozWS0MsSVXUC09Uh2r1tIIeTHgP5ZxM8QiLn3b9EKcvH2vd+/w2eY1GED24vw6DI870LRnGeGDuNAx60SPg3uUxG2w1lTSjG3wETgWuCexY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KKfbQill; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-564fc495d83so6116977a12.0
        for <io-uring@vger.kernel.org>; Mon, 04 Mar 2024 14:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709590122; x=1710194922; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3ZkpAhdCHxgIRoxu2meC/ZPvLNrVNc0pnlV5OyO06Ck=;
        b=KKfbQillYdv2fgAuATmxbtya23fRlgfeIz4XVtnD6vkG2iZqxh7mwnS4WPG+uistoU
         qx4+a6mSvALkFjBWP10zAb/vdkmIVkU4OgLXmL+UF3MDOYv8V6tdZjqJVl7MYG/ptMRi
         Obq/g3QiUv4zm8cTqZPH2c9J8UT3Roc/MHL99q49Rgb/O6Gr0NtpknQqnPmZY9cFDg8/
         PzbaW6/eqOncPZM9neNSOXP017QNO7HUffQTMRjSy78jStBa8EqDTYECkWDdFcnHuSao
         d29JZLYpGW+TBHRPz/g4Y7v57dLw28Qmg8kvjq/BKmADpKq/kvsadkQYew6t1+6jzqbQ
         PWYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709590122; x=1710194922;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ZkpAhdCHxgIRoxu2meC/ZPvLNrVNc0pnlV5OyO06Ck=;
        b=ik7lwqq48yWkHOl/+3pogVt5uY0DWp1RQRS8EVPYgCUxf2w+RkErkq0EWEIYb2TZTD
         UpwcJsWu1PGaVyTSsZY5hSCPG3OJmlZxWs5tu23M3Se/wwoPsUR5SrwiOGOMgjjxQyQD
         E7SMXzIvsLwRY+AevYE7r0wNmeDvnLHG2LY5H735F1x2tz9xo7ksz9UqY3Lk9Qam9Oe8
         gTMle2EKYWApAluU3ETqgY/bxQcPM72sjo05Yq3on8jPD4AaTxpPGWn78lm3OplzY2xw
         QnpKL6EgYH6CpO5kYZipuFKM/24bC45mts3Fdq6D5Z7jJnNW/Tzue62qgV15Zjykl0WX
         jXUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgSEaDExwNQkEEok6NTpV5vqld/mywTXbosj/d/csDB8X40S0THQqtdez1L5hhjlizeym443/zq5RByMLCcL1qRtKCpOFz5nc=
X-Gm-Message-State: AOJu0Ywi8daZBa0/MJH/H1YyslmvP/1EHnSAuc6W8b+hh8+0n3QIYiP5
	Q29CBI6tBOZM+FnFGKF8zY1lSb+ZCroN/YKVEtqwJfeC4E9mcz4u
X-Google-Smtp-Source: AGHT+IEfG7MYp1tyt4Kqqh7qKOwACMLDi5pWjEE4Mgprr+xtj3mq960SYXnYx9UXqBb9ivHw46Ebtg==
X-Received: by 2002:aa7:d714:0:b0:567:48a9:cf85 with SMTP id t20-20020aa7d714000000b0056748a9cf85mr2927532edq.37.1709590121856;
        Mon, 04 Mar 2024 14:08:41 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.152])
        by smtp.gmail.com with ESMTPSA id 5-20020a0564021f4500b00564d7d23919sm5043501edz.67.2024.03.04.14.08.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 14:08:41 -0800 (PST)
Message-ID: <27952c09-0a9c-4c74-a2dd-8899033c3873@gmail.com>
Date: Mon, 4 Mar 2024 22:07:43 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: get rid of intermediate aux cqe caches
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <935d517f0e71218bfc1d40352a4754abb610176d.1709224453.git.asml.silence@gmail.com>
 <1c21f708-ab56-4b5e-bca9-694b954906e5@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1c21f708-ab56-4b5e-bca9-694b954906e5@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/24 03:45, Jens Axboe wrote:
> On 2/29/24 9:36 AM, Pavel Begunkov wrote:
>> With defer taskrun we store aux cqes into a cache array and then flush
>> into the CQ, and we also maintain the ordering so aux cqes are flushed
>> before request completions. Why do we need the cache instead of pushing
>> them directly? We acutally don't, so let's kill it.
>>
>> One nuance is synchronisation -- the path we touch here is only for
>> DEFER_TASKRUN and guaranteed to be executed in the task context, and
>> all cqe posting is serialised by that. We also don't need locks because
>> of that, see __io_cq_lock().
> 
> Nicely spotted! Looks good to me.

Apparently I'm wrong as "defer" in that function is not about
defer taskrun, but rather IO_URING_F_COMPLETE_DEFER. Jens, can
you drop it for now?

-- 
Pavel Begunkov

