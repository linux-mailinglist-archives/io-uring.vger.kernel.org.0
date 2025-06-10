Return-Path: <io-uring+bounces-8304-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B246AD4411
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 22:45:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F7827A7122
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 20:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A5D266B56;
	Tue, 10 Jun 2025 20:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jMUEmxYU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC9125FA05
	for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 20:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749588309; cv=none; b=FA19sAqtj0dD0cWHm8NjxNQy2UpBwyCcy0TNtpGc1hs7HPPsBN+zBvYeic2TJjKoW8m2E6XCjm1taEPvt+i9Q5FpoX249VI+++TDmEmsf9QZ6sK7mJ03hVQv8uD2TgQBd01V0+ZARnzRT6bcIZm7F4Clrqpg8BUnfC8mvntTMzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749588309; c=relaxed/simple;
	bh=L13aJtyj9wZk0S9twJeiImgoOU8CifawXUJwqXKKve4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gULY63IMBlXz1EuXMFN8l3p4ap259UZqOfhHJevFR54dPEupEP+Yq/3EM9iSHkRj2rM2S/43QFgTEn39cb5h3XT+OQbsd0qsGxdCaRrylVrSSl7mJAu20TVBvRzzTu6k7cAwAOrzCARlrrXBDPsoyyMLhL0r2iC1FjcbZLcheM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jMUEmxYU; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3ddc4ad070bso21071355ab.3
        for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 13:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749588305; x=1750193105; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jk4xcY6x0/qvCMVP0X14mWuKHVXmdeVav5ac5YmW+yo=;
        b=jMUEmxYUpQ3be6JG37ddttyfh/bDUwjztPsNSV55D9QzzDJzaYSM4mK1cWCNSKp/6x
         XbaL3pQpc/X/wfOR05Ee/g6kRDYEpXouPqz37Uv5LqQUNEg55bzpKp9USEEWQJhCgYOz
         oB/ZaayNCnIHtcS7jWTsTnnLXGQ0nm+pfG81+MIyc9t36vbh5KzfzXPIAmIzH11iNdrJ
         UZVOLcS66fIQbbJPTgsxDe7r2k3jstux1B5VSfvNcfpajp02uWg9Dfa8oRHuuH4r++Cr
         8hlYhKND0jdplwKiGb+64xvMC8URG11olXfU8F5VYmHiPCzp7UCQw+sDJUMeN30bNvNv
         1Wtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749588305; x=1750193105;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jk4xcY6x0/qvCMVP0X14mWuKHVXmdeVav5ac5YmW+yo=;
        b=kYNKeLswf7wzQi8s3Aw15ZG3emp1Rexwq39KNl0CTvXAdNTmY/2PR7xZQ5FoompW5D
         5/oj4ThLRkP6JyhAgqwcqsjAYkz69KT8nme632T+YySbvct3LXML/Bc3Wsv4t0A65GTc
         ruag7d/fG/v4VI7pyxeF7RB+A60oVYoF5KXl4WZWT8BEo5850Wff5o5TagbivPJzq7MM
         aBZFjQXomeNIPNeOaxlZBlQWDr8J61saiLhJDLYighaP2CKh8igQxFKCuKh8hTr/XeaM
         JZ02H8E6zRqCkyIc26U1e2qQSWBYaizrzJtY3ydxfEI8xX+l+F4D/1Btu90ImtsUKHiC
         8KHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkDoQM3IUzN4KqG5DNsmLeL/rOQ2Pq5MpcY/wsmO5Q/eUigDNZ4Rv7NGz7OUx+Es+qaeC9XRWLzQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxD+cyTDa/ro1ZxkDDIJHNUQwboiBet7XSMbXR4pfDRenHOQDEA
	BkEWm6XFksPrIkjB5X4WS103grju71PTzJJlssgQF9Nl1uZrjKgYgoa8HhR2M9k8OnQ=
X-Gm-Gg: ASbGncv16VyrbH4SL/Od1DCDhBIG+bl1eowCNQ6odfZ75A46266pOj6cAQ/CwgnBAYX
	3kGFg2GJ3ewSn/FYKQ3wxVVJb8dgjSwdN9XLbl3s8Xi3RUJxkuIcEz5QpJYdMMIKz8IQai9vgvU
	qn1DKuNNS7xDEPUvJ6kM9nd1yQH3lN8NiQ3Nz50039RMKwMvw34/I9QMRdle0+VZXpeAF0P+FJF
	BKCBy+6i8PF0QBcppa+t3+H3h4guRlleOaRTz5+0XF5dO558zibWN7/SK7/LIGNt0Pggpb2Umux
	PMUrwEf0RB2JZ0BfU+HAfuWtEMZoP3OgGpAjQ7nJfoBDr0bwQEWuVwC4kPM=
X-Google-Smtp-Source: AGHT+IFwDiqhkcMqon8vfLtwpOBJhV+sVgO8dwvLnQ1m/lnZA5N2yDwtWfV3xTQPqxheglROwQUrmQ==
X-Received: by 2002:a92:ca47:0:b0:3dc:804b:2e74 with SMTP id e9e14a558f8ab-3ddf4df0582mr1643895ab.19.1749588304832;
        Tue, 10 Jun 2025 13:45:04 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5012aaf4e17sm71066173.136.2025.06.10.13.45.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jun 2025 13:45:04 -0700 (PDT)
Message-ID: <f0e4a1f5-0571-4a69-afef-e8c845f19f47@kernel.dk>
Date: Tue, 10 Jun 2025 14:45:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: consistently use rcu semantics with sqpoll
 thread
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
 superman.xpt@gmail.com
References: <20250610193028.2032495-1-kbusch@meta.com>
 <c2f09260-46c8-4108-b190-232c025947df@kernel.dk>
 <aEiToYXiUneeNFq_@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aEiToYXiUneeNFq_@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/10/25 2:20 PM, Keith Busch wrote:
> On Tue, Jun 10, 2025 at 02:04:41PM -0600, Jens Axboe wrote:
>> On 6/10/25 1:30 PM, Keith Busch wrote:
>>> From: Keith Busch <kbusch@kernel.org>
>>>
>>> It is already dereferenced with rcu read protection, so it needs to be
>>> annotated as such, and consistently use rcu helpers for access and
>>> assignment.
>>
>> There are some bits in io_uring.c that access it, which probably need
>> some attention too I think. One of them a bit trickier.
> 
> Oh, sure is. I just ran 'make C=1' on the originally affected files, but
> should have ran it on all of io_uring/.
> 
> I think the below should clear up the new warnings. I think it's safe to
> hold the rcu read lock for the tricky one as io_wq_cancel_cb() doesn't
> appear to make any blocking calls.

It _probably_ is, but that's entirely untested. Right now it looks fine,
for a variety of reasons like submitting work that's marked cancel
should not be doing anything with it really. But it doesn't feel me with
joy, particularly as only the somewhat uncommon SQPOLL is the one that
will do it.

The io_sq_thread_park() parts in the patch also look broken, as an
rcu_access_pointer() is being passed into wake_up_process(). It should
all be fine, but it's now a case of instrumentation actively making the
code more confusing to read.

I think we might be better off leaving the sparse warnings and doing a
proper io_sq_data accessor thing for this, rather than try and paper
over the sparse warnings.

-- 
Jens Axboe

