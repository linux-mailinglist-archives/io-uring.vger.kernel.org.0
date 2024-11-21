Return-Path: <io-uring+bounces-4909-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB189D4532
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 02:13:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 591FBB222EA
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 01:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAD7233C9;
	Thu, 21 Nov 2024 01:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="V9wmYa3s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA8F2FB6
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 01:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732151578; cv=none; b=gxlLUNHy1bMsug5MGEaE0ivGZfG62ba9q006ZJiy9naDxPKhxYbldWAPtrD7pt1d4vhaxoF50lGc1l8M30REsDlIK8c26lAWksr9DNNWfZuG/Su5/+vzOc7i4oVEh7fjp3YmTS3duq10q1YmPQ0imfwKP7dqaa0OfukkekY1R3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732151578; c=relaxed/simple;
	bh=SsjmWkmw+wDHEbgCtE2E2vG5daqwUkw5nj1r0d+txjA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d/VSbAATPcjVdK+P22mGC9kqAQsdJqhgrprtoFfJRgFgAjAkW3c8sRve/YsvJ36YgQTCtlROhlTv8iztSdmZQpt1h+Or7/mflSWJLcEiCoSXieYYyvRBMvNfHTVBuPYDcAhiTq3FDM+V1JYqmcjyFQIDzwYy9SL4UBFvAicFS+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=V9wmYa3s; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-720c286bcd6so363980b3a.3
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 17:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732151575; x=1732756375; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lUidyfx+dRq1lDwVF7wbpYoyJT/JNLSQ8+VRQhBxkV8=;
        b=V9wmYa3sNPEJPRb/z/ShJIA+gE2JbWj35hEZBknPz4pdMkseQVQBGKHBprPm/KlO00
         SM9AMQJbLgjlJxVBILTEXBdT7juxIIGcLL4NaSFmNogNYvvR7mpamqdB7Abz6VjW40+f
         SldvSs49PYgrHCwJ8FZqDib11oPilZHrRbbysaSJXuAb0moZlUzjZ8IU7wsr8+y9uX+a
         LeVKuuL6VAgWcxmZ7xxvio5FlDfwIxhz4NQqlF8lDjCNnz25OHNjSq61X/3dyxaHDNck
         5925gHI3x/OpNv/vo2yV0DPpFrLxiP/iTbQBpVy2JoHgZz0/m/uDqtJddCbVAvdjehIk
         WAJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732151575; x=1732756375;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lUidyfx+dRq1lDwVF7wbpYoyJT/JNLSQ8+VRQhBxkV8=;
        b=aOy+RojMozf/ZfpTJpc+z7Fsh65O9yhoDC+CJ/OXfgHQzIsqaImU3//PPXQoQUKo74
         WRA7D88o3TWBFC6G4uLQ50XXdDAy/vfdGdjfzMmMB0fA+DVzcSiccqJv9CZsxGxWKY2j
         /7tuX6qbxG2iFPfhx3YWpzRP1FJ3plZhcYLq6ryZok6xgvZH/bsfarDx+rW62VT2MDr4
         yNfeizZvOjfOyiI9tMePsThieThzUkE7QrWOHEi508xyUWL116MD9DjFSZAxhGTjrKOz
         nxfJ+NVR+b8i9ZI8C+7pnb20zD6E9qogTG+PV5IdBtjgZj+ytVML7lNBX22EptLpvFGZ
         rqvA==
X-Forwarded-Encrypted: i=1; AJvYcCVmjRIbA/IISgaf8PUnFMui+J2apldtsEl3WAoDcW0gl5PAxJ7GNqvvfmUDJ7Xv3DsYGW3IxrT23Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3IdYPpV5YGAw+TT42ff9jqPnfMgASHBrMLzg7eJoTe7UlDXbM
	Xv5lz52QULz/RUElh2SE9/H5k+ofKtkW58lUMkz/1zxsvaPNZjFdBkPzTm1LPzJRUJdaiERwspJ
	K9Pg=
X-Gm-Gg: ASbGnct4BxgKO8Yk360rHSBpR8/HoE6DXrFbaI5gblDXM9duQ6aPgOscxPTvf31oiKX
	67NeKXuSKGOpJknQDGgLK+RB22FbiEcsVI1dzYMzRK7no44uk0drOCoRZRErHFAvom3h08/sUDG
	gHL/udL09ljtIbaEEvi5Qhh4qk/0I1FC/pDiL/KhKWjNusktgKEb/nIxr2wNzxN41MiQrYPG5f4
	rh1Qm/+FFndXlXSrUzkEP8+UUvovDDUD/muRAaoMy4Zhc0=
X-Google-Smtp-Source: AGHT+IF44VJPFube4TY7ZQnh6J64TZdZzMg8JxgpeFmV9DfOVBHOJLr1EXc2ULBb2Llrkufo8aZ0RQ==
X-Received: by 2002:a05:6a00:1381:b0:71e:7d52:fa6d with SMTP id d2e1a72fcca58-724bee28f74mr6363030b3a.21.1732151575253;
        Wed, 20 Nov 2024 17:12:55 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724bef8e762sm2328446b3a.119.2024.11.20.17.12.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 17:12:54 -0800 (PST)
Message-ID: <34bf2ac9-54cf-433f-90e3-9fdff5cf9fb9@kernel.dk>
Date: Wed, 20 Nov 2024 18:12:53 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 0/2] limit local tw done
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20241120221452.3762588-1-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241120221452.3762588-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/24 3:14 PM, David Wei wrote:
> Currently when running local tw it will eagerly try and complete all
> available work. When there is a burst of work coming in, the list of
> work in work_llist may be much larger than the requested batch count
> wait_nr. Doing all of the work eagerly may cause latency issues for some
> applications that do not want to spend so much time in the kernel.
> 
> Limit the amount of local tw done to the max of 20 (a heuristic) or
> wait_nr. This then does not require any userspace changes.
> 
> Many applications will submit and wait with wait_nr = 1 to mean "wait
> for _at least_ 1 completion, but do more work if available". This used
> to mean "all work" but now that is capped to 20 requests. If users want
> more work batching, then they can set wait_nr to > 20.

Looks good to me!

-- 
Jens Axboe


