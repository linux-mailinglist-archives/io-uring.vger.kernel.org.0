Return-Path: <io-uring+bounces-1950-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42F1D8CB44B
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 21:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A2D4B20C8E
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 19:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 601071DFE8;
	Tue, 21 May 2024 19:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Mzb0DSRo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C806FDC
	for <io-uring@vger.kernel.org>; Tue, 21 May 2024 19:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716320191; cv=none; b=LyCsVsu29nHa0hDuIXvBMk7fXQY8anIE1Skcp6GSI/xbWDx9HPwD2xPCSMwyQbbuuG0x6F7tw39X5jIgZd4iba97j6kjOxrb9/7Z9/XSfp9dKcn+z/5JSvBDizEZOPszmRc8Pghi6l4J9D2dKKLHZbpyEbo4sIOTQsTh1nvt6S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716320191; c=relaxed/simple;
	bh=ikxbxZ8FjqMDhrrkk2D5nLqfIfAn0RqHaPpraJv+K/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gHazx9mehNbpPJ4H7X/dKbsNW3HLRrya5f0xJMl8gmFe1iltmsyeSUuVWkFCf4LzwksQzOo3IiFrueAL8wws4x5SioQcAG4GTM67nsRMMS7gI+CgTB1qAIMucCdjIcNrtZecNJIJCiz21HWAeKpJpZaNE8OH579fW+CHOzV1FxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Mzb0DSRo; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7e1b8606bfdso19700239f.3
        for <io-uring@vger.kernel.org>; Tue, 21 May 2024 12:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716320187; x=1716924987; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xePqQlr9Hwg/NyUW4bJAe88xQcUe0YJyjg2xMqe02j4=;
        b=Mzb0DSRo7eLK4DHzhNCc9L6Ce3+TyOR5yfDl2phQabMusO+Ry2CEuZnsZUOkNkCcMN
         CPFYW6pTgN8SE28zr9WLfdEjFvNwGXa2JXAju+9qiaLEwiYDUGjo1G//RIh6uNEIdwrY
         k3k0QdCispU/FlyREaGKuDls6R8dovfS6jsWgxRuMEN59Uqo+d3O+AG6/vIVqBcNT+pN
         r56g6EuVwXlcu1a0DF2rg2Js17Nhkou5JgWQJTRMduSwCv3xHn7QPPzJ7ZQbXEqhewal
         +x3/Zp/jRKJQJfUwVvzUa5hXXh/l8Ij8iARv7myHxoBmNZGjGMQ+8cVkLcQa1lwT2s6L
         WNug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716320187; x=1716924987;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xePqQlr9Hwg/NyUW4bJAe88xQcUe0YJyjg2xMqe02j4=;
        b=wRAvonXiKLxQ9ESjloIXUML3ayMq4tWR7yWHqHzK25NZJJtuHYpuCt1g31JnkFtcgQ
         yFqKOSthjTzF8aU3ZxJI8IbMNvJvVgUgqbVmSeLge2VjiHQt3tV5hSkALSEnkPblPUow
         0Ivu3rPH80LLIB3BPlMXNFiGneqgZqTWC27wEQhBtn56Rj7TTZT42jRudIfOdJRDOhPf
         +iLcwYVxVekn4XUdeEfh98N4QYfISwG0Yp+GXn48FOyE5q7sAtb+oBH1/u4pBqQYTA0s
         br2KAbZPGqx8Mn0SzjQ0ldxtqql6bfzj852nshahb7RuspnTa3VtYw09AINn+9xIrBL4
         x2cA==
X-Forwarded-Encrypted: i=1; AJvYcCWvQQ2AwMmXFy6ThO8bcK+gT9TqQYLLGoBghcr8IGvoeHxzzkohXjQrQiWPPxoXGJdUBkYVCnpAVexco6KntvPAxjDqf4DQgHI=
X-Gm-Message-State: AOJu0Yyu9fDiq7waoK2kiKeDyKMN55rXJM3c5us0bRnlaYSgp3YPKaRc
	cLzQNDnhZrkxeGHF/l+7vkKd4drSB2vZ3GLNGrd9NN7YrF7nYfAfNIXNZ3JgDvw=
X-Google-Smtp-Source: AGHT+IFk2v5N71VRLaKar/Gv9UHdlrX6c0Pv9qkJ50PzawnksP2Zx+uvBLPpPUIbBIU6Bk0lWQT3lg==
X-Received: by 2002:a5d:9496:0:b0:7e1:8bc8:8228 with SMTP id ca18e2360f4ac-7e34f7ff29fmr2400939f.0.1716320187504;
        Tue, 21 May 2024 12:36:27 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-48b9b4d71eesm3522227173.143.2024.05.21.12.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 12:36:26 -0700 (PDT)
Message-ID: <be0bb7ea-8e82-4bf1-b592-918080216db6@kernel.dk>
Date: Tue, 21 May 2024 13:36:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] ETXTBSY when running Yarn (Node) since af5d68f
To: Andrew Udvare <audvare@gmail.com>, Christian Heusel <christian@heusel.eu>
Cc: regressions@lists.linux.dev, io-uring <io-uring@vger.kernel.org>
References: <313824bc-799d-414f-96b7-e6de57c7e21d@gmail.com>
 <8979ae0b-c443-4b45-8210-6394471dddd1@kernel.dk>
 <8de221f7-fe5a-4da9-899e-de2a856a4ddc@kernel.dk>
 <yywbp7fjnwgqxvc66zimea4hgdc2eysjx5nezky3vndr7xw25l@jv76rdseqm3e>
 <b8018270-6e9a-4888-87fd-69620d62c4e5@kernel.dk>
 <0ec1d936-ee3f-4df2-84df-51c15830091b@kernel.dk>
 <bcf1e758-66de-47fd-8cfe-ce77c545a8bc@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <bcf1e758-66de-47fd-8cfe-ce77c545a8bc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/24 1:33 PM, Andrew Udvare wrote:
> On 21/05/2024 14:29, Jens Axboe wrote:
>> On 5/21/24 12:25 PM, Jens Axboe wrote:
>>> Outside of that, only other thing I can think of is that the final
>>> close would be punted to task_work by fput(), which means there's also
>>> a dependency on the task having run its kernel task_work before it's
>>> fully closed.
>>
>> Yep I think that's it, the below should fix it.
> 
> Tested-by: Andrew Udvare <audvare@gmail.com>

Added, thanks.

-- 
Jens Axboe



