Return-Path: <io-uring+bounces-476-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E280839D4C
	for <lists+io-uring@lfdr.de>; Wed, 24 Jan 2024 00:41:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3D60B279F4
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 23:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C69C354BD0;
	Tue, 23 Jan 2024 23:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="U5eP2cbs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB821D689
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 23:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706053250; cv=none; b=cKEfuLBrcHCaNF8xTDaUWJPpRkbB5Apt0VEXAeZV/iwBrcPTwCaBMLkMblsUWBVqWfnWJRoGDmi+5Q0Ior9LqPJZjZNn0M/hpuMFvfFGy5XMR++AWDO9UdHF//pj9Ifl5QzvNVjWt06ytw+Pw1+/ZJchSJMt3742EDJTAqO0x3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706053250; c=relaxed/simple;
	bh=qxBk9VdO4HwzDfSSohs1yeNf4oBIcdc4Ht6a1QaVU2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=inRC7+RRAYvT7VGihAUL8zpBcY91WkPx08YzClAJNa4trQbM7EIy+Vor48aiHu3ovfQYcZMj4XZbokMcuSdx/kKkmo95b21bFZd5vKmfM1rboAamL2Eys0LtXUvei98tOYyfBakMszyy7y/P+8rwLWtkLzRtMwPxj66bND1R/20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=U5eP2cbs; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1d748f1320aso3112345ad.0
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 15:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706053247; x=1706658047; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FAX2kXV7/2mkpSlhXjrTg1Hw65Dw07uARTYSHhwk++0=;
        b=U5eP2cbswCTjOgaLwL/lhF5bF5LJ3IFyVWFE6F7bPbyn+eAmEH3Mz1tcRp049/VqvZ
         pla8NYeyjXxcc6lv9LO1xGiBc4sv/b/4HG0Q0ofZ22K7fgvs523gfZvM5Rw4TA5b6DAT
         BNwWO9USt+RIj9Sza2s5j8ud3ZymjOeclaffjjKwxP8RcoQa1BWbQWlwSBSyYWFx4j9I
         FD01H+sl0Jm29OW2IqTB1MBw2BSSy5N3RckqGsDXujd+hPukjCyrL/ibPUW2kRwcAyXL
         Ek68za17SMzVY3y5V5Ft4YHZaML0F0XjYAS1YhbJnw+ybec4UiRpvI3PlbMnCAKTEFHf
         AjyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706053247; x=1706658047;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FAX2kXV7/2mkpSlhXjrTg1Hw65Dw07uARTYSHhwk++0=;
        b=FmEp8EDVPoFaSDdcFm2Eb4qRrH/zNW5DPMcO47mzqsl74CcqW78DbfsiDhJjOI/WTn
         5G56GdIf4m1TMUKJaNm/gJYHaDyI3lmDLtxPlTqDSyBt0VnZbSBXIWITtO8CSbzdjmAy
         HdbQnnSjl02bOgZ7yFDCY/U9lHaC12FhPcf4D2SkRtBheIcb9tDDF/qe0zqOgCTtqK3l
         W837lC/kAuSLrudMranFFjkTfucMPymzoIykdXQNjuPBhxi78mYWeClC/udE4U2rz4r3
         JWdoxPn4Qz53/Fhi25GseKXfsABSNOkrOH9KoXtlMwQsmpplmRP89CMKi5rZc/tuzoQI
         GgLg==
X-Gm-Message-State: AOJu0YwmkMF25NxXOMmoRLXSWZANrau3+A5gZlyt35Thc9iRD7cRhx2O
	/48BQ5WsTnJEtLm8xFDKIAg3tlMngiXhz7W3XZOgqK4tsFvwD8ShIjZgVIb6OhlGwKe8SJCAz/D
	saYg=
X-Google-Smtp-Source: AGHT+IFu9rJlvqtrD9U2gcn0hiB9v5+kS8rD+/HQFiWGb71mrMSofLaEB5vv5ANBUubNxhj9rOoPjA==
X-Received: by 2002:a17:90a:df83:b0:28e:3989:c49f with SMTP id p3-20020a17090adf8300b0028e3989c49fmr843769pjv.1.1706053246933;
        Tue, 23 Jan 2024 15:40:46 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id sv13-20020a17090b538d00b0028d8fa0171asm12266542pjb.35.2024.01.23.15.40.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 15:40:46 -0800 (PST)
Message-ID: <359b10f1-f7bd-474f-8c89-02e6eeff319f@kernel.dk>
Date: Tue, 23 Jan 2024 16:40:45 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] io_uring: add support for ftruncate
Content-Language: en-US
To: Tony Solomonik <tony.solomonik@gmail.com>
Cc: krisman@suse.de, leitao@debian.org, io-uring@vger.kernel.org,
 asml.silence@gmail.com
References: <20240123113333.79503-2-tony.solomonik@gmail.com>
 <20240123223341.14568-1-tony.solomonik@gmail.com>
 <f298acda-f946-45b6-9a4c-659b0be709ee@kernel.dk>
 <CAD62OrEC62Ojh+uvMWMb7X=fNZerUVYfUWFmRHQ-49OvTJ1u4Q@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAD62OrEC62Ojh+uvMWMb7X=fNZerUVYfUWFmRHQ-49OvTJ1u4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/24 4:26 PM, Tony Solomonik wrote:
> Sure I can do that tomorrow (not near my computer anymore).
> 
> By the way, why not just reply with CC to the ones you mentioned, but
> do a v5 instead?

It's harder to read the patch that way, right thing to do is really to
CC the right people from the get-go. You then also get complications of
people replying to the original patch without those folks CC'ed, and
split conversations and missed context that way.

Yeah email sucks...

-- 
Jens Axboe


