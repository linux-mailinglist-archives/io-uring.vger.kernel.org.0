Return-Path: <io-uring+bounces-468-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ABB9A839BE3
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 23:12:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE5101C22A6B
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 22:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 203324F203;
	Tue, 23 Jan 2024 22:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yI61+eRd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233E44E1D0
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 22:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706047939; cv=none; b=Y7kTD2d/yOKDBvf/9u3ByxBVqakgrhVlUtlE0IQISC9yi9/Li5XWMObZCBG/O3cCaA5HJNYCtK1o7xaGFfR2lzf6rRbtI/fun7oDwH8Qpzc9VTZ3m1jraq+02TSud2/XZwxAcDyqWRkdSq1hTBew6eLiqoco0yLUhobf/1pdnT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706047939; c=relaxed/simple;
	bh=Moy+hnHnq3f85k/cPBzerP9U753OoKO9eNgn+ielp08=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OIUWdRx4qUVT3OD7qsJBJDbrB3TGiILNG9kbDDippoKyamV7MuE758k6jgmKnOLQBK3NNlFKAs3Bec94rZoymEquVK84TIe7zHYRGAKEUdFam7r2m8BM1cdieLgmiO/5zoDIQ4re+7WQtoumEOz2I7LRh1eqbK+68xNEc7+sM8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yI61+eRd; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5cfcf509fbdso408561a12.1
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 14:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706047936; x=1706652736; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rq0z14Ii88qAlUObbDzs0mcPd0Y0cMCwmMHUzqVF6YQ=;
        b=yI61+eRdtbTK04lwamCvLU3WAffYQcTAcZUAslfOIwbbuALsPHqS/VlMGuZRb0noxd
         JrrnXEExDkyuEvYxTkP7OUyjwpG2vJqJuJ/hERahMCn1IJjhe4dLzUxVqD4c9qaWBf6y
         La3yNZMe7TJ0W/f9HSGNWHTXi6EjII/fyaBlmG7UkgT1buHZtoZxQE73dktGlgvFuWrx
         Wc+OH3/uw/JdAFSM+0lgRHK8Ao/5VMCo0gtUR22OkBoLtyd3wapsYjk1ETqUCRPsKAbM
         TiwkrGtSRgXBkH2JRj2ATpGC6HERbV5NlQ7N7y2tW6NsNzzZqYYExE6dLH3Copc6zoou
         Rp1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706047936; x=1706652736;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rq0z14Ii88qAlUObbDzs0mcPd0Y0cMCwmMHUzqVF6YQ=;
        b=QX0YZe7LIYQbpvc85cuslElagrJhD0EQiq8QX+iCKk3Vym8lHivtArLwMBeAY/p7JL
         TyjZS8mMhX8ggBmg4YJ2euEoO/MAnBjEZq9T3jzj2EM0oAxKub4yj5R+diiEA4VLKF8g
         hqYbeBGcDka7y1OJhnW7+q2EEIOS9kQteqbMmYfX9dbCvyPZn3KByeXZW4TNGXsszH+e
         G+eK7op+dvtNO+E2xseKrGzrNAIsQSRB/mfPV4iKQ1xkwl/ee3doXVFNdQRpeAI6jHP3
         YZE4wfSPivOwgLjOIY94oUyNU05FeCFhrsV7QfRxx7uVzzDZLoVgv2hoHPVEwxhd/6m/
         Z8LA==
X-Gm-Message-State: AOJu0Yzpm7eddiOF5ezh8nDVtEbOENXNG0I4wK6b0IYPkqcf5pMdhPbj
	BHxaOzCGWhqokJy4Wk6Q2Hj8nFboVVkHYJMWMulXH4e8kZG49n777gQZG6oy9Tw=
X-Google-Smtp-Source: AGHT+IEuEdQyZz6k3HPaHTpiIwi8nPgiYt0chQK1YArsjluKjpj9i+5ue9+w7Lo1EGbrtjNIIuyRfA==
X-Received: by 2002:a17:90a:c915:b0:290:1f0f:fc89 with SMTP id v21-20020a17090ac91500b002901f0ffc89mr689048pjt.0.1706047936404;
        Tue, 23 Jan 2024 14:12:16 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id ee6-20020a17090afc4600b0028e17b2f27esm12468545pjb.13.2024.01.23.14.12.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 14:12:15 -0800 (PST)
Message-ID: <dbd1bfa4-7583-4be9-ba00-cde4f340a509@kernel.dk>
Date: Tue, 23 Jan 2024 15:12:15 -0700
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
To: Paul Moore <paul@paul-moore.com>, io-uring@vger.kernel.org,
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
 audit@vger.kernel.org
References: <20240123215501.289566-2-paul@paul-moore.com>
 <CAHC9VhRMsUkNHpc45H4PVnrGj77RDR_BLR9nN89Nh725ke1ECg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHC9VhRMsUkNHpc45H4PVnrGj77RDR_BLR9nN89Nh725ke1ECg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/24 2:57 PM, Paul Moore wrote:
> On Tue, Jan 23, 2024 at 4:55?PM Paul Moore <paul@paul-moore.com> wrote:
>>
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
>> The second change is to disable the io_uring credential override
>> functionality, also known as io_uring "personalities", in the
>> FD_INSTALL command.  The credential override in FD_INSTALL is
>> particularly problematic as it affects the credentials used in the
>> security_file_receive() LSM hook.  If a task were to request a
>> credential override via REQ_F_CREDS on a FD_INSTALL operation, the LSM
>> would incorrectly check to see if the overridden credentials of the
>> io_uring were able to "receive" the file as opposed to the task's
>> credentials.  After discussions upstream, it's difficult to imagine a
>> use case where we would want to allow a credential override on a
>> FD_INSTALL operation so we are simply going to block REQ_F_CREDS on
>> IORING_OP_FIXED_FD_INSTALL operations.
>>
>> Fixes: dc18b89ab113 ("io_uring/openclose: add support for IORING_OP_FIXED_FD_INSTALL")
>> Signed-off-by: Paul Moore <paul@paul-moore.com>
>> ---
>>  io_uring/opdef.c     | 1 -
>>  io_uring/openclose.c | 4 ++++
>>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> Not having an IORING_OP_FIXED_FD_INSTALL test handy I only did some
> basic sanity tests before posting, I would appreciate it if the
> io_uring folks could run this through whatever FD_INSTALL tests you
> have.

You bet, I'm going to augment the existing test case with one that
passes in creds as well just to verify that part fails as it should as
well.

But looking at the patch, this will surely work.

-- 
Jens Axboe


