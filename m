Return-Path: <io-uring+bounces-3984-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C4FD89AEB63
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 18:05:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77C871F2104A
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 16:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D60DC158A31;
	Thu, 24 Oct 2024 16:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bN21GL0T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D011E1311
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 16:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729785931; cv=none; b=Mam7GDq+KA9OMtmdfvjBo+coJsakA84TyI9u766iV7ZSye7kcOit3c0Hy/cfsLT4UcljWBATMR83C7jHL8gDNnWIG//H3qVuM7DBGMJO0L2MkX28BqbxaxRAgaZkQ3OI/WQjLMGBxNz6U4nqvcmQ+4DRyUWjJRJrit8I4fyL68I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729785931; c=relaxed/simple;
	bh=DzYivK2WY+7iQr3fJ7PD+EKc+u/1h/gCm7gjZTaZGrw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cb072p8NU4gZLYjGZ6TZGKv0Du/YI716exEsKTyseaUg5iGssNTb+i3RRxshyYdHL1CA1h5ZlnqsEVVPmpMQtUSvskt7fV47LZblDEF5sK/37geOt+mWEhOIhnsXlte+0Bjw14Ozg7pak/MgOW5PUCQWuxcPr4E5GbUJiP84pvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bN21GL0T; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-2884e7fad77so615540fac.2
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 09:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729785927; x=1730390727; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hSYbWGru1dz3DUc78MLXOCv5eumtYsqSIAqP0Rul5Yo=;
        b=bN21GL0TxBJBWDhZ0hOvTF3ZwA+YXOVBr1bTuR3CYL0YzqDZYaznhtfFL0SaTUt0aL
         ZMnPWU9sK2mtvI9vI3/POqd+UzWhchT/+CmdoA0WZfKBRBoNZIXVel0d36V/G4OsYdC5
         GsAV4LIkBsM62pgUwgU+jDIJbp8KfTjNfZgtVxrKgkB2rp7DB2QE/BZmbcl5Q0rrNzPq
         mgh0ipaPyFwT83Rg8+DKJBWz8KmkQpKwySu2HostLiLjEgdpX+spiYgw6jyOVQNYqV6H
         Fi+r6f2+iZuruCaZgXrhw+CFTucCI4gkxADdfo8NbPSr0AVktIF5fIzx+cFi9h/+tJZd
         HOLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729785927; x=1730390727;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hSYbWGru1dz3DUc78MLXOCv5eumtYsqSIAqP0Rul5Yo=;
        b=daRepciaD+Z0im+R9QKDMZ9EQU/CbEoEqvnOyO1yCbUg/SSLyv9gVgoWv1zVUphsGm
         zps4xy6oXrfZwZcp5aK8rFUteUPxgy56r8LfMGRlgTTgHbMvcOdrqgauzF4J+4vs7G75
         gKSxbS/G8Toj4hYUn8qmB3jl0G4/k23vuFIu/yDm4mYtswgpM8XhUDUOwiHjGLDwBVK/
         8CXIr4Ud3LLHya9WP93AEaylzEKZzfv+1jN6PW2lvaPpd8C+DomCntO/ec2wAmfH3SrZ
         gjn47U9zX2CpkgZyDCj0K6TyEDiELBGfakQqVgMdQnXzXcBIQI88QgHyIsvVQmbXZp8X
         Ldrg==
X-Gm-Message-State: AOJu0YwO3nB8ceixTnXRW6x3FkpYFoFCeO798BYBRHHWvxMjOrGpqavn
	QF7JurdO1GUifospRwR6PsaExn/VnT7/MlcGNwN3MvUCYgplrd4q/tGAG36Wqchybz3WLjEam9M
	m
X-Google-Smtp-Source: AGHT+IHBKdZbLMgbTFc7ukyx6Ah4ugPJgm5Bk60HWf98pB+dTci9ojA4yzAMKufZzSBUrpLZoc/NDg==
X-Received: by 2002:a05:6870:7013:b0:287:29a0:cfe4 with SMTP id 586e51a60fabf-28ced42ea47mr2454196fac.32.1729785927557;
        Thu, 24 Oct 2024 09:05:27 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a52fab3sm2713430173.35.2024.10.24.09.05.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 09:05:27 -0700 (PDT)
Message-ID: <b97a3a10-44e5-4158-b2c1-70c07d5fb5d7@kernel.dk>
Date: Thu, 24 Oct 2024 10:05:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET RFC 0/3] Add support for ring resizing
To: Jann Horn <jannh@google.com>
Cc: io-uring@vger.kernel.org
References: <20241022021159.820925-1-axboe@kernel.dk>
 <CAG48ez2OMzMddB1-oCgKOgez4jUGb7E+aiku_c5f5nwZeuwJ3Q@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAG48ez2OMzMddB1-oCgKOgez4jUGb7E+aiku_c5f5nwZeuwJ3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/24/24 9:47 AM, Jann Horn wrote:
> On Tue, Oct 22, 2024 at 4:08 AM Jens Axboe <axboe@kernel.dk> wrote:
>> Here's a stab at supporting ring resizing. It supports resizing of
>> both rings, SQ and CQ, as it's really no different than just doing
>> the CQ ring itself. liburing has a 'resize-rings' branch with a bit
>> of support code, and a test case:
>>
>> https://git.kernel.dk/cgit/liburing/log/?h=resize-rings
>>
>> and these patches can also be found here:
>>
>> https://git.kernel.dk/cgit/linux/log/?h=io_uring-ring-resize
> 
> You'd need to properly synchronize that path with io_uring_mmap(),
> right? Take a lock that prevents concurrent mmap() from accessing
> ctx->ring_pages while the resize is concurrently freeing that array,
> so that you don't get UAF?

Yep indeed! It's missing the mmap_lock, I'll add that.

> And I guess ideally you'd also zap the already-mapped pages from
> corresponding VMAs with something like unmap_mapping_range(), though
> that won't make a difference security-wise since the pages are
> refcounted by the userspace mapping anyway.

Yes don't think we need to do anything there, just have userspace
unmap the old range upon return.

-- 
Jens Axboe


