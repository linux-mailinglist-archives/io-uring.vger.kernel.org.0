Return-Path: <io-uring+bounces-407-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C65482FCCB
	for <lists+io-uring@lfdr.de>; Tue, 16 Jan 2024 23:29:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 354A528B9BE
	for <lists+io-uring@lfdr.de>; Tue, 16 Jan 2024 22:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 254503588F;
	Tue, 16 Jan 2024 21:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IpImeec6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D765FB98
	for <io-uring@vger.kernel.org>; Tue, 16 Jan 2024 21:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705440758; cv=none; b=OCy9vX+m1wJG1RTfO5G/WfDlOZ8+4pn4Ld9n04r7c806CyzuHcdkzZ535E4yeGm82IfVbqPDJrUq/xNQDLZk6KmrBxSq4tHjgezABm5OzYY3dAEeaNMMACygYCY4VmwUpv/aj9Yk/dggFvKC+qc9EzAs/d3zaSS/ljklpV2YeaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705440758; c=relaxed/simple;
	bh=3yocsVfSDvxZThq90Dj3nH0nus8tfly+X0MaJvdgtaQ=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:Content-Language:
	 To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding; b=XLhfAswm1yrkxuVln4u3YUq8/pCqb2beeTswACcYRwLjRgEqEccLZqIKZF/Lf7C2id6NXAi+UIgWVBABPSi8rWcpyu2vI8X2nWnrlRWdBrnRlPdx5tuQYWROlynsB+ffZAGUAayF60JvQEd7GsqMJoi6PrDWgtLLVGs9o8Vay4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IpImeec6; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7bbdd28a52aso71182139f.1
        for <io-uring@vger.kernel.org>; Tue, 16 Jan 2024 13:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705440754; x=1706045554; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YuP1ZSfv05ObmtuBguIF3PEonyWKaCpp8Usq9FqYdaQ=;
        b=IpImeec6Ztag7ymu/BeQsnkdHhwh7+spJR3C1QKE87bd5cRFu1FQ9TsFK9ckMe3XNZ
         7/3cc81cOhF0R4ZB0YQ6I2axnHm6VVspDFParUnOfwOMcn8QJq8tW6mI/y7jvwu8EjB6
         gZKOuY4vZMM4iK8G6sdBi/fpsLeSKKS2uoOtAf5fPg8w4+HZh2Vg2ihBDIUKSn44pviH
         TOhdRnfDNx/UR2Uj+4UGC2H9ackzI+DD0vSms5Bsd73ZMrOLSpSYfLJzpmtHtbelMfkK
         yq61bS6MHawmBYpfBpnI60xC7s2ShAr5+UYIxivKFrAs4r7Z0TpigMGoBzIRD7wkQPXH
         Rg9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705440754; x=1706045554;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YuP1ZSfv05ObmtuBguIF3PEonyWKaCpp8Usq9FqYdaQ=;
        b=KtVuVwPhKLYgSTME3u4IbrEQKNtsN5L9EBLiUBsY90Nt5uwwp6xMlUL/iENkTBi3U3
         HXKxyBhkrHzOLNB7+F84y2qj46U8OwUfgrKMU3CW2oHgN62gYF9AwwNtB1wZ4PjI2IeZ
         RHe14mx6iAK/WUBCAhLZDA0xZz74q/zeKSv+C/8SkAqu3cVWyppORw2G2ZIFy1dx0ZiO
         ex2Hy1vz0JxiyrKSZQIWozn+qTQDq5ooVwAkqKMEPZKrHp7MdtjflPVZLq+NBHxPse5P
         Eqoh+OOZDDeDMN2CYltsL6d3trozW7BDfK0kV52L4r09oAW8xVJGV9cheNpuOmYQUxnb
         qmUw==
X-Gm-Message-State: AOJu0YwN9ZgSdB37eDZoUEMUlh9bILQz/SQXdapTPNpTltOWDfZxfXwA
	GImf3V6u2GsUjkw2+AmFxTIbg/w083gz3w==
X-Google-Smtp-Source: AGHT+IHGBWfXZuz+JxnUw5W0S83vUvP3llxnQWtTkehX6ZpkBeJfEhlXbU3TUyeDZuGlC1GwlETGow==
X-Received: by 2002:a5e:834b:0:b0:7bc:2603:575f with SMTP id y11-20020a5e834b000000b007bc2603575fmr195550iom.0.1705440754189;
        Tue, 16 Jan 2024 13:32:34 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id n22-20020a056638265600b0046e552de3c0sm23529jat.117.2024.01.16.13.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jan 2024 13:32:33 -0800 (PST)
Message-ID: <71ba9456-45a7-4042-8716-ccd68cc7329f@kernel.dk>
Date: Tue, 16 Jan 2024 14:32:32 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iouring:added boundary value check for io_uring_group
 systl
Content-Language: en-US
To: Subramanya Swamy <subramanya.swamy.linux@gmail.com>, corbet@lwn.net,
 asml.silence@gmail.com, ribalda@chromium.org, rostedt@goodmis.org,
 bhe@redhat.com, akpm@linux-foundation.org, matteorizzo@google.com,
 ardb@kernel.org, alexghiti@rivosinc.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20240115124925.1735-1-subramanya.swamy.linux@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240115124925.1735-1-subramanya.swamy.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/15/24 5:49 AM, Subramanya Swamy wrote:
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 09b6d860deba..0ed91b69643d 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -146,7 +146,9 @@ static void io_queue_sqe(struct io_kiocb *req);
>  struct kmem_cache *req_cachep;
>  
>  static int __read_mostly sysctl_io_uring_disabled;
> -static int __read_mostly sysctl_io_uring_group = -1;
> +static unsigned int __read_mostly sysctl_io_uring_group;
> +static unsigned int min_gid;
> +static unsigned int max_gid  = 4294967294;  /*4294967294 is the max guid*/

As per the compile bot, these need to be under CONFIG_SYSCTL. I'd
recommend just moving them a few lines further down to do that.

I think this would be cleaner:

static unsigned int max_gid = ((gid_t) ~0U) - 1;

however, as it explains why the value is what it is rather than being
some magic constant.

-- 
Jens Axboe


