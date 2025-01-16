Return-Path: <io-uring+bounces-5912-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33609A13177
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 03:34:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BE1E3A7F3C
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 02:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B8AE45027;
	Thu, 16 Jan 2025 02:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q8UBQvJq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541917082D;
	Thu, 16 Jan 2025 02:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736994745; cv=none; b=SEZgLPUttAzI2bbwQTQnzyHAF151XbvJjEWUQVvd/VRrJibaTDhFWorxiAcwMFxY7EACmRi+yQG9S20Fgyfyh0HzDs9ckNqZkEtrP1U+eMY1V4H9qQvN6JARZUDzL4QJi5pel+veAN7TAU8HyvPsyzAxAHoAprRUuXtsFtG3f+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736994745; c=relaxed/simple;
	bh=mlZF2KzEKTCQLyWxk2mMb72L0SIqh7F5h/n7Xgy5HV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fQYDLc+JiDvuzw+mKs5MrPiq4yqAg3rxGeUw6AOKegUKI9bke6V6KgsIOfh89ZaSZrDHz11I67Xp4enm5xWWZ6oBSaDoD7xIDaNfhEgv8nda4WXrfT4G9aS0F3DQVGONODRF+Z92774liMmkSRum0r2P5H2w8KKyC+2gLqljz8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q8UBQvJq; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aaec61d0f65so96378366b.1;
        Wed, 15 Jan 2025 18:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736994741; x=1737599541; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=azrkXtzoOMBRva/zKYDVVsxqYQXPULoD/TFyqPsj3tA=;
        b=Q8UBQvJqcnwbF81h+ZF8RsXXpX1+r+xAZ3jcM44mO8cQQAKei7JjyTF53oo3V/Stb5
         aYcAxOPyzSRnej+96gYlQpgpQWqjm/XKrDt4r9xgwfHfUb+IMtlCaQ71iwJORvGVryWc
         LyOXJwE7qsP+L4tFtcOJOvQKzlc3/HHNmH2WS4Qgvn3TpER4tqXBeYV7jOXsPz0nGmwx
         svUwqZIgMRqr3dDSHbV8D5CethLFMAu7avB7jEqG+tC7Bwnf75ICW1DeiupyPoucuhdn
         7/l+sutkEbZnS6WuVaOVMHe6sBQ/TQIC2KI8ECwARrwtdTi2g2Hmfh9YDUYRevMqvJPe
         w9kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736994741; x=1737599541;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=azrkXtzoOMBRva/zKYDVVsxqYQXPULoD/TFyqPsj3tA=;
        b=PrnuZA3BFDxpHC27fvdETVMc3E9btLPKCsxN4p93UIQPRdy2CL78iBCD2OEsuyOejC
         8ii5FB5A1jgPi2PS6k5lmCNMOzCPvY10Q74vdg/f43N5Rty2CB6BV9UJMb46V/lJn0Co
         HptAcy+J1A7F+tDNuSPehb/WXsdAFBLARCsZpl4x+CFAxxMOTDF6SzW0XJbAxfqlU6dT
         yXf2WRCL/AHROSwqeFguU8ktWhKsAB2LPVZtDopXZ4bE6XNNKZGaGLlBAKsfpbadnhYx
         E51HB3JVgaVNf7mi5rRO9YxIXXUuJYOJ3YpNna2jFoUGlJdGc8n4BX4qcvnqxEn+pquo
         QJpw==
X-Forwarded-Encrypted: i=1; AJvYcCVGDvDnCKPD2c6Y5tee9uLFGeuEyqUJKGs0v4ZLuv8VIJyVTNxQFxqhnEGxdNGNMwy/26ute+c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzmubrzbZqhN6/QTX4hTuX+9nG6PJhPy5XXXqwCE2YYncCbJtD
	lDpQL3WiwXkfepkXAXSYBriFHFfbT41ymm04xnRgzW6PsAXquFUN
X-Gm-Gg: ASbGncvmyIwnzXPCkPxr8a3dS4014DBk0RGch6Y95o+m1CWoRn3890FOrENgC+O3PRi
	3kxmk8bst52Ceh3POf6xf8vCVaq6brl2BYBrVzUlywfqoa6mVX4dMsyj2WvLbPaV7nfZu3DGDCJ
	mATFTP6l/8NGDxLKjDMgE2wva2vGDOv7WoLjvSk4VWLDy8+PZjLwro3P9Fqa8pDvvRz5MqTiTup
	E6QJ7/dKRC8syCueSQgI31j86anZz0LL4yJJqA4yPFFc+qiJgSJ5H2MaILo7QJL0Rc=
X-Google-Smtp-Source: AGHT+IHU9PhGUtYrV/uxBobHRmGKihlPiypiDAKawHcNoQkRHSXU1PjyPSq3aOg2AGAmZniQWZUYwg==
X-Received: by 2002:a17:907:1b03:b0:aab:eefd:4ceb with SMTP id a640c23a62f3a-ab2ab66d63cmr3274819566b.10.1736994741276;
        Wed, 15 Jan 2025 18:32:21 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c90dacf1sm846550066b.63.2025.01.15.18.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 18:32:20 -0800 (PST)
Message-ID: <bb19ef4d-6871-4ae9-b478-34dd2efcb361@gmail.com>
Date: Thu, 16 Jan 2025 02:33:06 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v10 14/22] io_uring/zcrx: grab a net device
To: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250108220644.3528845-1-dw@davidwei.uk>
 <20250108220644.3528845-15-dw@davidwei.uk>
 <20250115170644.57409b2f@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250115170644.57409b2f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/25 01:06, Jakub Kicinski wrote:
> On Wed,  8 Jan 2025 14:06:35 -0800 David Wei wrote:
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Zerocopy receive needs a net device to bind to its rx queue and dma map
>> buffers. As a preparation to following patches, resolve a net device
>> from the if_idx parameter with no functional changes otherwise.
> 
> How do you know if someone unregisters this netdevice?
> The unregister process waits for all the refs to be released,
> for *ekhm* historic reasons. Normally ref holders subscribe
> to netdev events and kill their dependent objects. Perhaps
> it is somewhere else/later in the series...

Ok, I can pin the struct device long term instead and kill
netdev in the uninstall callback off
unregister_netdevice_many_notify(), if that works with you.

>> +#include <linux/rtnetlink.h>
> 
> Do you need anything more than rtnl_lock from this header?

No, I don't believe so

-- 
Pavel Begunkov


