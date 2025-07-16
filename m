Return-Path: <io-uring+bounces-8707-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63632B07F46
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 23:04:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91C824E61CC
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 21:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E92618C008;
	Wed, 16 Jul 2025 21:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BgEUX/FP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82901D86FF
	for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 21:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752699849; cv=none; b=hwtpYLzxKcy1DQLeOqhExJWiQt1jDEI+/uznJjZbFPL3rWa7nqh33PMaXjAlUsdz66i9mR4MsR6G9qYG3WHATW4aOl758XkSuzCm7sml7HOLv74ckz9tJKdZYwSrWCpxCnJZcI1/OgFVXI6jFFhyVgSucVObd2v1U98fIcur0CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752699849; c=relaxed/simple;
	bh=3+rdfEESYcZ8D1sZttOQVoJKXEbQZgR+hr0TGXCVvZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WdZv3Ge9nhm4D1jk2bTCm57NoYaIjfdycBxBE+YUcvG8U8ntLVylevL2LFeyi90nxxGWX0Zs+rZWpgGUgw+1emvKBiBqUAZgJVRQKgy0l9Gz/kxBmCX1DUZEhubmrFx5SpI5meTPe9XuqVNTARm1Z5UhXMeBwWUn3oQROY3BvK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BgEUX/FP; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-611f74c1837so432017a12.3
        for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 14:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752699845; x=1753304645; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hMcQ6iwue9cmjvaiJoXNuIwKroANNE6hg9hZ/cjEEPI=;
        b=BgEUX/FP26n8OgUR3GJh8OIeafMEvZhVtMZZBzXtCxJY7sUGS2sosVCixzNW/+IGMw
         GYD6rKbYIJ6fznsjQAGf+aPyGHDB5MiuGfF0fehI2tRwPf7m82Q/J5ZP2+6nXR7wDSHm
         bOz8kUdqUkNIhNUhWVeddAWEE4Sdy+qxEDPh+hm2pBU6chodMtFd69ogEfKcJWVm+76U
         vsN6ywHkdkalpMNnItcr6C9/tNlDCHXiYWrA5U1UMU6gIoDCcbKtytLyEQ388DJBCn9j
         uRYUwszI/fNTozdV7Tb4eK9tXNsAITzRSrD5JUc/Hj5llAwtQohropabQfVivFiK8NUF
         2h3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752699845; x=1753304645;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hMcQ6iwue9cmjvaiJoXNuIwKroANNE6hg9hZ/cjEEPI=;
        b=V5wRQahkmRF7GXdVkBc3kzpthbXSv2pwUrbT+597elOH43Vkr4wjC2TFe94RwbAOlB
         lVhwSDnQqN3T0gInUSYChUkgk5yIrt3FMDPI+H5PCzGfMiG8Uo2JkZRzHFJkyrRR2R/r
         4UjgEAppa27Uqqo0bCnBbjQTP4iGae9qONvzaawYiFzp+KsjyDvzD7G/yOrkd1qBno5G
         K9hZ+5Dk4CRXI/JgBE9iEB/Fn4tYl+Oct/s4VUstf+yU4cVmhBixaTgv2z2O/xwpesQd
         4ZqSVMDd9UCOZlt3GRT8B5Yas23yBButlTFvHCkYxXs67+h/BYnixoCJ2iCRdQQP4hqj
         8CJQ==
X-Gm-Message-State: AOJu0YzoWJsifyKgJO+DtX94sLrRjlfI7ku0nRda7UsX9z3WH3WysrUq
	We19NzRa9yoEwRXpza6R/F+T67bdJ6B+x3QmJWVefcP5koxC9hyqA+Zu/uV35A==
X-Gm-Gg: ASbGncvy++KZJO2a5rFN2qOKxpN1uPEkrHqq2q65gCwmzhEmFwhgnBS7Sk6TcqsBlu5
	2s60aymC0uP58qWNseL2Mym+cEVCcQBNZ4Rc3gI6PiGJctu4Rniux+mwa0Srjz5MdJcg8EF8LDZ
	4Uo820zmm+13K3VhquOTuFtzpWxZTCHEzjltQVa0JRzmCKOsCu9Q/gkCp5SK/XqzM1Vxu4YmJrm
	YdeI9cRBpXSfoe7Yn4p5HO4grNS+UTwyg393hWSPHUvZ9yMhqbRo7M0q7AbD0Hj3djgyS7Oj9OS
	/GVESXT8ZV5PyW35E/5l8XI2FbO75Zm2ngLwqvpExac7xOz775MD11aiKblHs2srwOawfmTv60Q
	r+y/RnCnNoC8iFFYG7oSDtYCT2V9AOkKPuIbmN8tq
X-Google-Smtp-Source: AGHT+IGID/2i2nfGYzlNBpJb2kQoYckwoZwONHJskpcwGgZbUcJw6bStzF/9GpRcEjd3RfJUEfNesw==
X-Received: by 2002:a05:6402:3596:b0:605:878:3560 with SMTP id 4fb4d7f45d1cf-612823dd9e5mr4305770a12.26.1752699845300;
        Wed, 16 Jul 2025 14:04:05 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.234.71])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-611c9734c06sm9132942a12.51.2025.07.16.14.04.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 14:04:04 -0700 (PDT)
Message-ID: <0926df8e-7a28-465c-93f6-571584043892@gmail.com>
Date: Wed, 16 Jul 2025 22:05:30 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] account zcrx area pinned memory
To: io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <cover.1752699568.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1752699568.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/25 22:04, Pavel Begunkov wrote:
> Honour RLIMIT_MEMLOCK while pinning zcrx areas.

Base on for-next


> Pavel Begunkov (2):
>    io_uring: export io_[un]account_mem
>    io_uring/zcrx: account area memory
> 
>   io_uring/rsrc.c |  4 ++--
>   io_uring/rsrc.h |  2 ++
>   io_uring/zcrx.c | 27 +++++++++++++++++++++++++++
>   io_uring/zcrx.h |  1 +
>   4 files changed, 32 insertions(+), 2 deletions(-)
> 

-- 
Pavel Begunkov


