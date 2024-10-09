Return-Path: <io-uring+bounces-3501-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34C0F99727C
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:58:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF85A282D10
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 16:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 827321547CF;
	Wed,  9 Oct 2024 16:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cbuZk7r6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095102D7BF
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 16:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728493075; cv=none; b=rOTf+YPqYJJTneJEctSMxW6oal915XlOJB22sCanyjXxsDl6ottAwaHpHJN6NL6YK4/mZAI/tlZMfnb8KRntDx4mADDiH8d0zJ57aPIJS++mxT1TOsuVRExK2CCZjvL4aWkQP8nc9bt9/3ZHTpMOsQg5GYLBGptVN3G+2TW05uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728493075; c=relaxed/simple;
	bh=Ju4hZ5bZoH8UntlFeshzeL1LyX5BnYG+8f73zLzxi+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BTRp7cTDPHiCMooGopBpI0QqI797/8XfMycPMrM0WfGQJVRQNrCGEf8Xon8fXusKWY7kdmHeIY3ntTr7+0iM0j0DyDjIL/vdD5FFaGEa9+73VsuuGHeFVEHaWLM7DxNa817oNpjTudrqxBiLe/fFEjSNUmwGOko/T3uiuNIBsU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cbuZk7r6; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-82ce1cd2026so279468439f.3
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 09:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728493073; x=1729097873; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bw7VwXAIznwpICo3kV2k/LCYf2ehWSVoVVH7gRs38NI=;
        b=cbuZk7r6GxWb2GHlDvO5shJ8HxBuJRT25J74OQMBH5AN1mBwIxntiummN6nyjPIwkj
         arxHVGHNgBK5+5uq22YB39ubgcc+1qta5xHUODCZbv2GP8X9tbiepbI5evTYcr3GSyYN
         nbkmmosDmfIimUfhfNtoaDFUseFLFybKqm1S14/rigrX7DXDZtIM1hdBaj82FO6BLARb
         a2jZN55cnDUeeuIQ3Tkyclry3UAoBU2qDkIiSQnwjeQlWHYWJYFpc7iNqxZDkjMfzzzX
         AsoiXu+7M1jKPKALlBDYd7tcUogjEqOOAi/WHizE2MwfC6zmukZuLm7X2XY0cbm+5EuQ
         nPwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728493073; x=1729097873;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bw7VwXAIznwpICo3kV2k/LCYf2ehWSVoVVH7gRs38NI=;
        b=H3uuhcI98L7n/S3i2m65i3O6D6tBEakrD5dClvCVr1dJkjs9eYLAtklBf2XfRfsNWv
         2UCwe7/616KA0voR9qjl/fXxSvqaPiQ/oH+9Ssw+Ka3Xdq2WR+0d5RnW7KD3VHyplpwm
         r6LT3/d+SsD7bjX6ippNao1sHXQ2Sp3Wx0bIJc6enydTlISjFDemYP8FZwWUdvCppO7/
         4L3U0s7ZVzofX/m7Jzj4u+DF/c3w1rUFXUc4y7qTcg2GaygI9hYNK8GGFenm2mm9qXJl
         gND5akp0WHxVMWI2WxAyTXu+HAG2e1iWku8smpuq9SySYztJbgNzwBHna1WMSWzmWdOO
         egWA==
X-Gm-Message-State: AOJu0YwVXihQ7xbCOQta1HLl+x1z2nJKAE+xzReNFCvq66g4/ey69gCB
	rqrLyJzpYUkbw1Gq5hKb8iAUD1fkAZiOrsucOpmXHNj/n0YjyISwcc6iRQpS9oQ=
X-Google-Smtp-Source: AGHT+IGdh7EgQyozYxNrOGrr9QuWmEDNHnNyIda/hil5TWKH9O1j55aApx0++gBFJWR3wL4VphHMfQ==
X-Received: by 2002:a05:6602:2c07:b0:82c:eeaa:b1e0 with SMTP id ca18e2360f4ac-8353d5263e5mr413582139f.11.1728493073056;
        Wed, 09 Oct 2024 09:57:53 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4db6ec72819sm2098146173.170.2024.10.09.09.57.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 09:57:52 -0700 (PDT)
Message-ID: <016059c6-b84d-4b55-937c-e56edbedc53a@kernel.dk>
Date: Wed, 9 Oct 2024 10:57:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <CAHS8izOv9cB60oUbxz_52BMGi7T4_u9rzTOCb23LGvZOX0QXqg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHS8izOv9cB60oUbxz_52BMGi7T4_u9rzTOCb23LGvZOX0QXqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 10:55 AM, Mina Almasry wrote:
> On Mon, Oct 7, 2024 at 3:16?PM David Wei <dw@davidwei.uk> wrote:
>>
>> This patchset adds support for zero copy rx into userspace pages using
>> io_uring, eliminating a kernel to user copy.
>>
>> We configure a page pool that a driver uses to fill a hw rx queue to
>> hand out user pages instead of kernel pages. Any data that ends up
>> hitting this hw rx queue will thus be dma'd into userspace memory
>> directly, without needing to be bounced through kernel memory. 'Reading'
>> data out of a socket instead becomes a _notification_ mechanism, where
>> the kernel tells userspace where the data is. The overall approach is
>> similar to the devmem TCP proposal.
>>
>> This relies on hw header/data split, flow steering and RSS to ensure
>> packet headers remain in kernel memory and only desired flows hit a hw
>> rx queue configured for zero copy. Configuring this is outside of the
>> scope of this patchset.
>>
>> We share netdev core infra with devmem TCP. The main difference is that
>> io_uring is used for the uAPI and the lifetime of all objects are bound
>> to an io_uring instance.
> 
> I've been thinking about this a bit, and I hope this feedback isn't
> too late, but I think your work may be useful for users not using
> io_uring. I.e. zero copy to host memory that is not dependent on page
> aligned MSS sizing. I.e. AF_XDP zerocopy but using the TCP stack.

Not David, but come on, let's please get this moving forward. It's been
stuck behind dependencies for seemingly forever, which are finally
resolved. I don't think this is a reasonable ask at all for this
patchset. If you want to work on that after the fact, then that's
certainly an option. But gating this on now new requirements for
something that isn't even a goal of this patchset, that's getting pretty
silly imho.

-- 
Jens Axboe

