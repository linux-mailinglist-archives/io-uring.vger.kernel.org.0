Return-Path: <io-uring+bounces-6632-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 01D72A40486
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 02:07:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4318819C72D6
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 01:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB300132103;
	Sat, 22 Feb 2025 01:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HpelUik9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B1D15853B
	for <io-uring@vger.kernel.org>; Sat, 22 Feb 2025 01:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740186472; cv=none; b=sO+hgq9ut5Xx9wfKT+E9JmdsYTsayrIdtRj9U/0wLhhAG0pwP3SWo2iKf0wP0IA6igRtR9mbpdovrPwwbsYKGsqFsjfFcoDOGil9ASWUc2NK21HiJig1pK0eHpbOdtut6B2f0V3JbZnjvXyK85vM9LPxX0bsJDP7+Kdy8bY2+TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740186472; c=relaxed/simple;
	bh=jRCh9PGyLJIdlEplAogSd5BH1appCfrUD/DyqKy0EuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=vElyo3QJUykT32tGoG9NbPYUdneLlV/kMLGfKxabSz+CfaPeACiIMaWnH1xj79VP6166vicM9i32Ped6K2/FdXJdqxICJwEYqylCUsEyJROe3mCmN8g0Idtwe1gaPpcRbQ6/yAw858YTgMTe3/HNSOTw1evDvXhxfmPSiuGdM1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HpelUik9; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3cfe17f75dfso23653495ab.2
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 17:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740186468; x=1740791268; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CpCVpg8qALXzOm1VW+Ct2xQ8dtp2ExGWm/pHaG7PVUE=;
        b=HpelUik9oms82CiA2JPFOzavMHoAQFeNMu8+JCakCRmzVFI+koFQRX66XyNhHKad9M
         TRoOxtl2ifPhyoXIRJ6VSXI+az66/4vssqbzI8vuhEhl4rsrdK3fcxKwsIgTuTIR1TSf
         LB/caZ7+ZV5OwBFDsSVaXxxXDDpvWVZyu/vdUXmdFWwbeBNeJz0dZ5vsn+HI7N/dvjO7
         91XP/BJTEC+/l46Wa9BG138/R/ZSRq+HIkS37PX6K8xNilDonowObu3lTA130TDE2/C1
         l2RYwu2Qp2tkqDdeXs1fOi1wMe+FmBONoh2LRFNAb02ukRMISufKZXdZNN2M7dN8bO9K
         6USg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740186468; x=1740791268;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CpCVpg8qALXzOm1VW+Ct2xQ8dtp2ExGWm/pHaG7PVUE=;
        b=g8hgsEFYIPh/MXRTpau3lkm1AmqRZjQuRBwJEbNwbif6QFC3xEKnjj8jcS0IJoOfjF
         p9Y0DAjaDZZZpCV3SxC+IAX3w6/KATola07ksske1WAHyBrSmkaZHt+P8ZbBiJ6EIYEy
         baw9v95BODzPKbHf5O3siqGVctyC7IvltkxuuCWUSt/1fkU4/p0yn45AdgO0BXKq2HF/
         xccXcFi5MqWd/HjpcRW0QcLSveQmPqoWwP3FrNGu9M5tO6anNhzegjzXWRwwpLoovuDn
         ZdkDrizoY6xtLyYVNcMhSVOwIffweWYly5CzVil0qkPZ2dXa0F/P9e629xDlfH+mK1ne
         /LGg==
X-Forwarded-Encrypted: i=1; AJvYcCV4ffm6XPnu0xfWrf8moN35Zv/FrOJN/7OsiS9Pfsgb/Vd/k2W+/mSsHI8C+sDrUvgDFS0+ZiSi/g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzlBSPig+ZV1A8PWvoltckbrqMeSyBoDWl001W1uvvhJls2MfGs
	TxceQ2bXbN/P+eM90CMdZKDrZNBMuCxs7v6Xa5WpfLPbmlz9PeggSnujCBlbKBk=
X-Gm-Gg: ASbGncs0GClwXHq8y1SPKY0Ey9IsmvyJo9GCa0/WF32du1ZSdlRWz0zZmzPOhHAvDwF
	NiLUgz/uDVCL2i/EH/TKc3q+FPnwTaO6aFfjNa6tneugFNCNlcjqcyeOI6c5uRYh+LaBt451ZfN
	g9XnEe2BHtH/FLIEIwasui1lPfSEcBL75uWGIHliJatYWyD82ZV7Y47AP18GRZhg6+PjiJz19iF
	3/3YbNotwS2xN4q5M+ojUZt83X1fsZnoaH1sJ/wo3/2C4eyYKN8MMVQ9ajXJBEMZAmJf9MLFAZc
	ag1RbRNKAq4Ugs8jF4jDAAs=
X-Google-Smtp-Source: AGHT+IE53cvl/cDmPIbHGcSamrjM1vq6Up8LIXcbr9/N59/B+TBIHW3+7E11k6I6P6jpJCE4p4N4qQ==
X-Received: by 2002:a05:6e02:12c6:b0:3d0:618c:1b22 with SMTP id e9e14a558f8ab-3d2cb492ea0mr54454415ab.11.1740186468625;
        Fri, 21 Feb 2025 17:07:48 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4eeaf1cf709sm2008625173.133.2025.02.21.17.07.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 17:07:47 -0800 (PST)
Message-ID: <16aef2a7-d20e-48a1-aa5d-747619c8a2c9@kernel.dk>
Date: Fri, 21 Feb 2025 18:07:47 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring/zcrx: add single shot recvzc
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20250221205146.1210952-1-dw@davidwei.uk>
 <20250221205146.1210952-2-dw@davidwei.uk>
 <9d081ae3-6f9d-48d2-a14c-f53430a523d0@kernel.dk>
 <f8409430-a83d-4bda-a654-3f9bedb36bbc@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <f8409430-a83d-4bda-a654-3f9bedb36bbc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/21/25 6:01 PM, Pavel Begunkov wrote:
> On 2/22/25 00:08, Jens Axboe wrote:
>> Just a few minor drive-by nits.
>>
>>> @@ -1250,6 +1251,12 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>       zc->ifq = req->ctx->ifq;
>>>       if (!zc->ifq)
>>>           return -EINVAL;
>>> +    zc->len = READ_ONCE(sqe->len);
>>> +    if (zc->len == UINT_MAX)
>>> +        return -EINVAL;
>>> +    /* UINT_MAX means no limit on readlen */
>>> +    if (!zc->len)
>>> +        zc->len = UINT_MAX;
>>
>> Why not just make UINT_MAX allowed, meaning no limit? Would avoid two
>> branches here, and as far as I can tell not really change anything in
>> terms of API niceness.
> 
> I think 0 goes better as a special uapi value. It doesn't alter the
> uapi, and commonly understood as "no limits", which is the opposite
> to the other option, especially since UINT_MAX is not a max value for
> an unlimited request, I'd easily expect it to drive more than 4GB.

Yeah that's certainly better, and as you say also has the same (forced)
semantics for multishot.

-- 
Jens Axboe

