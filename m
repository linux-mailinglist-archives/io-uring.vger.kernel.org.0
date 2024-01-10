Return-Path: <io-uring+bounces-381-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5590482A020
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 19:14:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED5071F224AF
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 18:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D04164B5CB;
	Wed, 10 Jan 2024 18:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uDn95EhY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE05495C1
	for <io-uring@vger.kernel.org>; Wed, 10 Jan 2024 18:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7baf436cdf7so44746939f.0
        for <io-uring@vger.kernel.org>; Wed, 10 Jan 2024 10:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1704910432; x=1705515232; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=98V5FsbN49MLCRxD84Dk8Zs//MGBhZTtEP9P3z940QA=;
        b=uDn95EhYSF0oWxt3dFZf1V/T4oOtzwXUot6fdSha8bFdsCKfjarIkNaXDSjNz4e/Xy
         nP7xmXMSXj+NMOolXF34WDZe8kPIKNM/DrbENYrhV4LDFR9ghHVWpdUJwYz5H7G0a4Tj
         7WWOpdmpTQIO69UBPCZ2yd5EJ8q99P1WcQX8PeK4HaKhQPKwzJWVtce+pBsD5jJwsk6y
         bFOE2qEJ2261LfZtqgNzodKL8im9TDqruBc5FvaTGGTrCdFnLjtNFraj1lHQqxaUy8Z/
         La45aAeD3EX80cuMNTOHgc94zU+o+LkXvQ0f9wo1iNoEc2VoXm+AJ1H2nHE7BcNc3Dz5
         9GnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704910432; x=1705515232;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=98V5FsbN49MLCRxD84Dk8Zs//MGBhZTtEP9P3z940QA=;
        b=e4ygRj6gOHDegCy87z1MI00TtCsFA+WmUKLia85uNbmtFcJLi2BhYNAnYOQgpzA8Yj
         zEMpFHjig7HiNINbF2i56TuahmLMmnQDFFynponaLOgcW57wfJJXR+uueHWbaDU1jKEv
         Y1k3iuwlFJgp6OLptN01B7DvysUTO9CCvG4NEA6nMAT9vtdKsENaEiUuCrCiRCWCtR/2
         YabJ0HNI+YJbrT4SSW/ThSqA1jS+pmPvZaNG5c0Qfr9jUIssZZmV9RlAVhLksXZ0ps44
         8y9lGxA3e7/s91OQXCt3BHY/W4+NdJKEmB3Xk0Mnapjn5WO+bodHHiukfP5NKCyWuTcx
         86rw==
X-Gm-Message-State: AOJu0YwiqjTM+1rlzC58fDPLud0z6y36N2zcRYxEdjwD99X7xQ2uI8Mi
	szTJFWwiSJLeHl50kLSj8O3qnH1qzljptg==
X-Google-Smtp-Source: AGHT+IFjgsatUrTzaCXpUAZcoueUwFAW/LtgKvl9x0CixJF42o2+Kb1AqjQiQjUjdsEpg762KlqYsg==
X-Received: by 2002:a6b:e318:0:b0:7bc:2c5:4f6a with SMTP id u24-20020a6be318000000b007bc02c54f6amr3241560ioc.1.1704910431877;
        Wed, 10 Jan 2024 10:13:51 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ds12-20020a056638284c00b0046d4105b7e8sm1417914jab.49.2024.01.10.10.13.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jan 2024 10:13:51 -0800 (PST)
Message-ID: <b3035bbe-487d-47c7-a4e9-8a081df2936e@kernel.dk>
Date: Wed, 10 Jan 2024 11:13:50 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] io_uring updates for 6.8-rc1
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>,
 Christian Brauner <brauner@kernel.org>
References: <c5c21ccf-201b-486a-b184-a99924f4fc04@kernel.dk>
In-Reply-To: <c5c21ccf-201b-486a-b184-a99924f4fc04@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/8/24 11:24 AM, Jens Axboe wrote:
> Also note that this will throw a merge conflict with the block branch,
> as we killed the IORING_URING_CMD_POLLED flag and associated cookie in
> struct io_uring_cmd, and this branch moved those things to a different
> file. The resolution is to remove all of the offending hunk in
> include/linux/io_uring.h and then edit include/linux/io_uring/cmd.h,
> killing IORING_URING_CMD_POLLED in there and getting rid of the union
> and cookie field in struct io_uring_cmd. Including my resolution of the
> merge at the end of the email.

Forgot to mention the security conflict too, which I was reminded of when
that landed upstream. See:

https://lore.kernel.org/lkml/20231204120314.5718b5f6@canb.auug.org.au/

for the simple fix.

-- 
Jens Axboe


