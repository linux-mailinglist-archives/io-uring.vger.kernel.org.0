Return-Path: <io-uring+bounces-473-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEA7F839C66
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 23:40:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 682E0285276
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 22:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D54537E4;
	Tue, 23 Jan 2024 22:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ejpJjxYP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6EC524B9
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 22:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706049620; cv=none; b=HSrUjz/XL0czSjcOzFi5bicpw31zDUnuHRq7L5Claq+0VTVKuGDrw74g1AcXPh/k3QHopW8k32no6z4ycggtN7HQ6ImXoE3OdmOLxaYSFa7LaD++exhRoTw62XigJBvrJxXHyoE50xNAwjPQKRgs+IyP/JfdTaEC6OR6AL46DOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706049620; c=relaxed/simple;
	bh=dDmiAyTd6I1WoQ1JHmDV+Aim3uCnxncV333lDUyp4KM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=Mb8GXWMspmz5UVEdwn7sGTUyCKyor0KzfGuua9upcXRpiRTrFgOmrz+9pVKFfBPxjoiR8hHDEpFM3kD3lxziQG6LNhjGjvEgwDK3ydqTKnZ3rbzL16qhkJKcxK/xUX9aB0GIJ0OhEeSOIP7ITPSNvqUOVneqcbIae0bd+hYtHzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ejpJjxYP; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5d3ea9eb5c2so201348a12.1
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 14:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706049617; x=1706654417; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uK4AqgzTPBnmXYr2iScowkm9axVe1AfckM6HmRvPGe8=;
        b=ejpJjxYPS88nedXdRnZ4fAoA4+A7Itj4vdNj863LG5jTJHBN47MlwbW1bYVYRkA+cS
         jxxtayRJ+1YmZ4NumPpFbvymix2b8ITEcJs6b3TO4uPTGPADe8b56MH/Np5oKU3UG7hi
         4vDDoIyKDmOQ0nQj+4Zyv5H5l9cVPwmWmlmxkPcTxMKMpcS3/7GDN5GRWa5qCA1Muis2
         /HxROM+P7dWBBE6J+CCenAfphCPEMd4Cc2rtdhWMRrzDZa40eyeRW4vSuPrpmtp7KuyR
         pHoxNkRGHlffin++9vQZox1ASri5qP0VscQlFECzAPMIOCwKynhFPngBWrSgZBV5Oikq
         qr0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706049617; x=1706654417;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uK4AqgzTPBnmXYr2iScowkm9axVe1AfckM6HmRvPGe8=;
        b=uLZd4eJGCbcqgZyhytdkp8/O3YSGparTS1u8kYsG4BOiL6jrOA8BpC0uuqNoUbXrWn
         skw2zBBdt7H89k/kzFW6U7nIZ0BC4RqU5s2opWRG+BsxA5YP74f9kFGKrj67QfysA8vQ
         FXPwb8xkzf7U+UWsOza/OCDMPQHlM3ryiB8Eym4Ocl5ql8EZZTjKk8BN3AC6GmtzA1MS
         42cZggdMDC8/mDKE3mA+NS1B9aRQt9bIvHvYl7pr4YwBgTs50GC1b1ViL5wEim8/reX0
         AUNcop8bdltjU//5xCxuCEdVIHHRV0c7reR6Ga5wiFdcex50ooUXmoHj84O3WCYxh5CZ
         OZCw==
X-Gm-Message-State: AOJu0YxCBJGH2uBclJqKaVw3ehnYmGpbkQKoP44yKXrwYFR3vvz1baOR
	wQ3kBC7VU8zzkF9NohHLCP9dEWkGd2Iak/b2/odEu6eRi6rP1d1s9vOgGjVNcw4yrUZHd+fGpj4
	DcEE=
X-Google-Smtp-Source: AGHT+IEHrhNprAGub+wfj4V1kCK8kl1gmykQV7Hc5rqYq2gCCzlHqlLOCPh2W3ZGllBpORaFaqkJ5g==
X-Received: by 2002:a17:90a:88f:b0:290:239b:8f8e with SMTP id v15-20020a17090a088f00b00290239b8f8emr9500004pjc.4.1706049617331;
        Tue, 23 Jan 2024 14:40:17 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id qc12-20020a17090b288c00b00290a26531f5sm4882355pjb.7.2024.01.23.14.40.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 14:40:16 -0800 (PST)
Message-ID: <e785d5df-9873-46ab-8b8a-7135da6ed273@kernel.dk>
Date: Tue, 23 Jan 2024 15:40:15 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: enable audit and restrict cred override for
 IORING_OP_FIXED_FD_INSTALL
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, linux-security-module@vger.kernel.org,
 selinux@vger.kernel.org, audit@vger.kernel.org,
 Paul Moore <paul@paul-moore.com>
References: <20240123215501.289566-2-paul@paul-moore.com>
 <170604930501.2065523.10114697425588415558.b4-ty@kernel.dk>
In-Reply-To: <170604930501.2065523.10114697425588415558.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/24 3:35 PM, Jens Axboe wrote:
> 
> On Tue, 23 Jan 2024 16:55:02 -0500, Paul Moore wrote:
>> We need to correct some aspects of the IORING_OP_FIXED_FD_INSTALL
>> command to take into account the security implications of making an
>> io_uring-private file descriptor generally accessible to a userspace
>> task.
>>
>> The first change in this patch is to enable auditing of the FD_INSTALL
>> operation as installing a file descriptor into a task's file descriptor
>> table is a security relevant operation and something that admins/users
>> may want to audit.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/1] io_uring: enable audit and restrict cred override for IORING_OP_FIXED_FD_INSTALL
>       commit: 16bae3e1377846734ec6b87eee459c0f3551692c

So after doing that and writing the test case and testing it, it dawned
on me that we should potentially allow the current task creds. And to
make matters worse, this is indeed what happens if eg the application
would submit this with IOSQE_ASYNC or if it was part of a linked series
and we marked it async.

While I originally reasoned for why this is fine as it'd be silly to
register your current creds and then proceed to pass in that personality,
I do think that we should probably handle that case and clearly separate
the case of "we assigned creds from the submitting task because we're
handing it to a thread" vs "the submitting task asked for other creds
that were previously registered".

I'll take a look and see what works the best here.

-- 
Jens Axboe



