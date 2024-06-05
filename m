Return-Path: <io-uring+bounces-2130-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EB748FD674
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 21:29:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32EB81C21EBF
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 19:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C81CE22064;
	Wed,  5 Jun 2024 19:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IhVG7mWs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD9379F0
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 19:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717615787; cv=none; b=ELtC2EsZjVTKMREUNgfum6ALlI2tZabHp2sqfByUtn6yKY2LtIFnPqZ5FBkeXWZzfVppwYq7igKYRjvhyH/GlBJw8QUs0XYxUElzbUFCSGrlA9plZsN36zwEoJ6FfFNVyZaTTRVV3HPPEVftQKh5gDN+Vqp/ZsKVi54bICSoYaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717615787; c=relaxed/simple;
	bh=Dav0tvjIhomaVnEca1k+UZl1i0hbP4q0gMST4Ncz/aQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rcnWrMy9PEY+w8yua0cJkyCLMVIgvhxIfv8299aPCR3vDPvWHDEzeut6UToHjTS1JD5ps5xNN2I2pNx3tzb+ZJqWDt65KnI0isVEqE/jYoL/9JXdftPnYHtHsO/9QgP/gu7+XDdzmHzd6es6PM03p2lIzSK9W1OKM9RJbjQYL/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IhVG7mWs; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5ba7ae85264so12335eaf.3
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 12:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717615784; x=1718220584; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vUygRPOLfaaHuG4Df4OEaz76NA3q73gQ880OUTdgExI=;
        b=IhVG7mWsxl8AtsJj8lSQ3Z55/sWQ5bGExZ3CK1e+aYbdawyOLuKQ3VdMGvBgzfL3ub
         ZH8nQFu8F7ylsPAvmmHf++8EhfudBg2mr/0MXSPyDWB1K4hNAg7SCansuWvxQT+AJNUX
         g8tyI8KISNu+G+wyQQht2Cp/O8Jf4NeRtUVmn1VhQ9Ke4H4GuP/1+Q6vlthCF+F1ONpp
         eMCM2t1v3gFQwfYTlZRD2aSLPyCCNpcoifqw0FK6fP2LLIlZ64jPMIePJOgohtYfBdW9
         G2ywnx+tquiVqIR33wdmAFhQkgHY4EqZKkq/fHr0flNVswC+vaYZXttgmlN9Aw6aLixX
         CooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717615784; x=1718220584;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vUygRPOLfaaHuG4Df4OEaz76NA3q73gQ880OUTdgExI=;
        b=s1/Ce5aQlXRSnoEkOTlWCBZSdUQYnoj9f93wVdSxKIGhnSVQyyDRveETB+8nT/D3iR
         YL77fgQhgbAiUEg+I4cEVP6O/xTedbm81gIZcEBRFishnLP4JBgJdC+eej+/VAbmk2Lw
         P20wC0Gil3P1wd0VI8UslS0H77DL9kOfp1DC0bcZKb6E3MRFEZLHhaRND64KmjqscCo5
         oLjLGH4LfroUhAOLj0Wld5Y3TFe2Lw9xTD0bs22+vDg6N3Y/MUj3dIaEyG7hL+59TK/t
         T+TbVGGgdnOvSIAHENZLg26aWGgcebQGrRxJ43tt5VE0JT2Pvw4oDHZyow4KOfWOIHLn
         OTKA==
X-Forwarded-Encrypted: i=1; AJvYcCUQYdqyED6yccoq6Ok9ZSloMfrn2jcR8cT8YHDH1pmpJ8nyyT/5K/zikNUzIchDfAv9k12vrsEeIUF+AiQv++Q25pXpAVnogjI=
X-Gm-Message-State: AOJu0Yyd9iJuBRsP+GmawlzECHcP0gEfU9oE4pdxvgBhicNEuUwhZq/Z
	XHyowyjSW6vGUga0WUZKnD1lnTtBEWdtbWjLkhcybBdcp/kz6diScdkjzEV8NfFVsBRsNodGStp
	C
X-Google-Smtp-Source: AGHT+IGfSAroF04z3LParMPXY3f7YCic5zubovmYqbt9NBPcA84RpghPvFcXTs/0F+N3lKzZuVeVIA==
X-Received: by 2002:a05:6871:294:b0:24f:ea59:4e1c with SMTP id 586e51a60fabf-2512242cc12mr3937761fac.4.1717615784131;
        Wed, 05 Jun 2024 12:29:44 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f9409ebfe1sm601594a34.81.2024.06.05.12.29.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 12:29:43 -0700 (PDT)
Message-ID: <9514cccc-791e-4cd3-be55-3381092d8167@kernel.dk>
Date: Wed, 5 Jun 2024 13:29:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: move to using private ring references
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240604191314.454554-1-axboe@kernel.dk>
 <20240604191314.454554-4-axboe@kernel.dk>
 <138bf208-dbfa-4d56-b3fe-ff23c59af294@gmail.com>
 <7ac50791-031d-453f-9722-8c7235573a21@gmail.com>
 <04539e03-da04-47d9-9363-59c2f4ba0b03@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <04539e03-da04-47d9-9363-59c2f4ba0b03@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/5/24 1:13 PM, Pavel Begunkov wrote:
> On 6/5/24 17:31, Pavel Begunkov wrote:
>> On 6/5/24 16:11, Pavel Begunkov wrote:
>>> On 6/4/24 20:01, Jens Axboe wrote:
>>>> io_uring currently uses percpu refcounts for the ring reference. This
>>>> works fine, but exiting a ring requires an RCU grace period to lapse
>>>> and this slows down ring exit quite a lot.
>>>>
>>>> Add a basic per-cpu counter for our references instead, and use that.
>>>
>>> All the synchronisation heavy lifting is done by RCU, what
>>> makes it safe to read other CPUs counters in
>>> io_ring_ref_maybe_done()?
>>
>> Other options are expedited RCU (Paul saying it's an order of
>> magnitude faster), or to switch to plain atomics since it's cached,
>> but it's only good if submitter and waiter are the same task. Paul
> 
> I mixed it with task refs, ctx refs should be cached well
> for any configuration as they're bound to requests (and req
> caches).

That's a good point, maybe even our current RCU approach is overkill
since we do the caching pretty well. Let me run a quick test, just
switching this to a basic atomic_t. The dead mask can just be the 31st
bit.

-- 
Jens Axboe


