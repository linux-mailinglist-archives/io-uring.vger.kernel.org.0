Return-Path: <io-uring+bounces-6698-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F3E0A42C96
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 20:20:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA9F71882C84
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 19:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C7651ACEAD;
	Mon, 24 Feb 2025 19:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IGlM1cTZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDCB16CD1D
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 19:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740424806; cv=none; b=N5a4GVWeJ3G4w9mGpNHlCwD+96diDcGEl3dGn9LujniekfBLqGkug8bzZv0NK+IhjO/gxNAoG0AkljXg82lf9giwxJohFCzZIbMd5QheqhTdGpMXPcYuYMJzwIBlPMgaUf5TnrTR8RlIRlvq0gt29K3S3lRZbSEBBOX4jg+uzSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740424806; c=relaxed/simple;
	bh=p+K+dAINBvJotiJ1GyxsKQoJA5lH6zll3zFg1OWleC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UGP3me4EmIKVT27TtdsDJCJ2t5Cf2FdkEqO9GlSFp9Lf6Qpv1+m3SxuWOKbmlnIdT2pp8Ps7IRzAB9mCMWpyRuqcSY8KUeq+G+lB/Aiu2xnVMBT1qPoU1THpufS/qwo19dTCgLXHCfQ0aqV0NlgJTdk4ioNVutOxalaB4Xzv+lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IGlM1cTZ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4397dff185fso42039095e9.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 11:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740424803; x=1741029603; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=142htfNBYxpoZfPwN+amwwqqNf0f1hAIVck097mkGss=;
        b=IGlM1cTZx7N2tvvztya2RbrB9qHECqwjIZxb3Bo1aP25sO/Yx/ik/fNa4gojuxcnpM
         JoVrXYejr84gB/I/ZhVCUtWLj9y7k6+66w5+y1E8INHbGfI0Xs++xVttsJcEQRrYFaoc
         RlCkMikw76cNtweBdyGZFVcSJW9O5VoRG8jlsEEXF9YjStvPTj+Mn+PxP3uXjXV5+DpG
         qMv/8q8JuwiAss29y2cODq/dc//Tm9XFrvQyw8FsNQFrLGlu9taDplQyfaeWBfGttlME
         sLluNtfzB4EI6hMlMPSkRX2hBC3ow8mavyFlCQEBx/cwCsX5FjiuCfpui7a2sHYcAkv0
         JG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740424803; x=1741029603;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=142htfNBYxpoZfPwN+amwwqqNf0f1hAIVck097mkGss=;
        b=ei0Kc9tKa2dHhnHahCaRAPQznhDmy17wMdiZzBSMKypG0lWYKWS5ln/1uhF8zpNj8V
         0/f1V9qBpVJ8GdyQMtaaz1viDUVheOw63+/QalG3Pq2c2mcFD84SBK4xX7eZqv0rgD+8
         ulkeOnp9cSqOfgwSAn50o4JWfBpHLAEKpFGdF0bhkRYvpu2nrS6eh1AeidAwmAwKoKKJ
         9vmoQVgdQTD/LM1bzXDNLrjvlnF8UVB3gq7zVxLkYTi2mrT1hqLoHiOXLeu/sM6rrekr
         4F4h+0vwBzmA95D3Qk5SL5E8cyzU2iIn7JzVjV8IeSRvwYBbMErhHJls0Cfc/B3xnuBw
         cBlA==
X-Gm-Message-State: AOJu0YzgWqoVhZyzViW591DL78D3wfoD0LPAomk/wMk8fcYdK706e8KU
	3fj70StbNAkFSvF5Aa7kG0ebUFmT7Lh9wqUeZ6FFlVvd27WOpiOL2t4WVw==
X-Gm-Gg: ASbGncuvT0k495OBiGi9589NUSTzybYEtD1PKsR0zB++5Y2ewO5Q1sn50cahWfLK+wN
	3NU2g3clvg+6vvKyt6ItVn2qgGTHJf4ojx83Y/Vx4D/AoXe/h6O1RKWMWRnq/6OHchyBdWNXx6e
	oKxTdkZILU1OTtmQTpFol1AnNrT+CQ31GHGpmM7EpB6t2sVU97mDBlbHnltApcrqql5VK08HS4g
	rCHfmVkLty2A3jRE1aMmxChAT2JdEGf2BJlOC1xEWZKAo9AhF3uDEqWgEsEXL3g2koP5obfk+mU
	J2Z4ua7sLS4ZjDEINicDccxgfJFOZbkwTTo=
X-Google-Smtp-Source: AGHT+IGXzSpIVR/rocq3hNpHMmN9g8ecFSWOvIvmNrxE2zRizOqoGFDy4EJ7k8UDB8QcUNaLFfmRKg==
X-Received: by 2002:a05:600c:3c9f:b0:439:34dd:c3cc with SMTP id 5b1f17b1804b1-439ae2197d1mr101061175e9.22.1740424802596;
        Mon, 24 Feb 2025 11:20:02 -0800 (PST)
Received: from [192.168.8.100] ([148.252.146.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439b0367577sm115091475e9.25.2025.02.24.11.20.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 11:20:01 -0800 (PST)
Message-ID: <c359d152-d541-4305-bc05-1259be924670@gmail.com>
Date: Mon, 24 Feb 2025 19:21:03 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] io_uring/rw: allocate async data in io_prep_rw()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <cover.1740412523.git.asml.silence@gmail.com>
 <2bedcfe941cd2b594c4ee1658276f5c1b008feb8.1740412523.git.asml.silence@gmail.com>
 <CADUfDZp7SWy_pcL+GL9SbFY-qMaNV+gja+gRiY=XeefDoZjnDQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZp7SWy_pcL+GL9SbFY-qMaNV+gja+gRiY=XeefDoZjnDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/24/25 16:52, Caleb Sander Mateos wrote:
> On Mon, Feb 24, 2025 at 8:07 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> io_prep_rw() relies on async_data being allocated in io_prep_rw_setup().
>> Be a bit more explicit and move the allocation earlier into io_prep_rw()
>> and don't hide it in a call chain.
> 
> Hmm, where is async_data currently used in io_prep_rw()? I don't see

It calls io_prep_rw_pi(), which uses it inside, that's the "relies"
part.

> any reference to async_data in io_prep_rw() until your patch 4,
> "io_uring/rw: open code io_prep_rw_setup()". Would it make sense to
> combine the 2 patches?

Sure, if it rebases cleanly.

-- 
Pavel Begunkov


