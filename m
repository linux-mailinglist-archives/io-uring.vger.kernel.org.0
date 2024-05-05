Return-Path: <io-uring+bounces-1760-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED0AD8BC2FE
	for <lists+io-uring@lfdr.de>; Sun,  5 May 2024 20:11:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 229AB1C2096D
	for <lists+io-uring@lfdr.de>; Sun,  5 May 2024 18:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3EE053363;
	Sun,  5 May 2024 18:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nmzD12c9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E8B50297
	for <io-uring@vger.kernel.org>; Sun,  5 May 2024 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714932676; cv=none; b=SmagLmVgZ3amVm7UTcLIfV+uvU+Hw9lfyAjuRoSF9EDPnpmjf4Ui2cue0ImfZZyKvl6hUBZEbiwybrGbkur25dv5I70bypIzg1bR9rVTdL1GHlXh68BVkNb5u+uGbDTavQJ2n63n0aaoSMvtrzWdO/0yv81G+UEdnKsRLYIX/ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714932676; c=relaxed/simple;
	bh=k5jNgrzGGbB2SvX2lsGfqjuVDXY9NBn3s5nTft65hiY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LHmqZW6a92911njXRuBHwvG5rZ8GrA1MMPTbSagwrkyGUO3Qn70jPvGNMj77UroK+Vryd8JAtHoVDhgkHjcezY7MvgwzUKeMdPPK0cFt9mPsqEddhE5iJA4VqB8SbNKMxqV9MNBXEj1TOeI52Ms/hqzVhs/16x41udiKuC3thrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nmzD12c9; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2b360096cc4so361496a91.1
        for <io-uring@vger.kernel.org>; Sun, 05 May 2024 11:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1714932674; x=1715537474; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tvHkh+5kPDtKzELkpdAuxAbICGRQaj83JbyqcP/eSAU=;
        b=nmzD12c9Q1P8BZhkvlXv6AHqVQIo4Ok1aSpf1V2yqx2ppIcOcIaMIUyVKFRfkEViut
         rXMpLkc+fcbaDvECzJYmrG9bLunx2yiEPJwB9sXjGpcwC+DuhiZw1daYeb4QmaM14l1M
         LBKeNNt2DFjTp3fULGxTvIdJ8DLTyyHgiov0XDRQYg+yBGpljf0OKDoSm4vbfmYtQsaV
         3Xzbmv8oreVvhG2YNlgmJKy8pgs6+WKctgSJCtuS+zP4oyij/NJgaETMKVMjg9EKwfxx
         uFaEOfWEW25sJi++X2tjIdV3Qv6qcBZr35bP5AEe1rUElFfpA9c2aNXl4IjQaenEtKN/
         TTWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714932674; x=1715537474;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tvHkh+5kPDtKzELkpdAuxAbICGRQaj83JbyqcP/eSAU=;
        b=hNvQgEdg5OprdJ6v7NKOWVvGQyouT2xVn4e6TxpXHFd0/vlpR2Hf2kfLJ1HyzX2vRb
         f8lOSRTmODnpNQRkKYExCPpZV+D5Mm5aVjZIsXVmTVsxzEI88FIs+SaYHcOS2qPLssra
         lTO49tTvwieRyEWDrG6ARR5DLcVEAeDFWtQTTeslOIv0ywl+RCL4wO506679XkRevR9T
         D7yHFRqlL6gaHRAuqcqzyXxhfOIWTZ43zAjvGkzgX3DBol8qXN1OJi4mz7ROHpD85rE3
         WvQO/Ymm91UzEY+HcHT5QHTAxYazm0mzBOHo2CqIzrC2+6DrVYZC21m74O8kpeyoP6Qh
         2pHw==
X-Forwarded-Encrypted: i=1; AJvYcCW91VPB3isbtQc/68ST5UtF7/VkQGSLQn7fWncNGJVcMCqT/QnNd1kozuqI2yuWbQXVaCLD4phq461WEfa2CNgreS01nfthyhU=
X-Gm-Message-State: AOJu0YyHHepFEdlWHp9Jhrsw07jpb/j1qGK1MOsJg76pA5ISjzYEOQ09
	PjKDMkMsSkowdWf6wLtXq85qzIuiHRwh/SyOImZFb0cucsHcnsrCyBrD0abJerWwUx199GENQse
	w
X-Google-Smtp-Source: AGHT+IGj6N9fxxnYXC4h6uBDX32Dot6YiT9LutH6nE805dGPLKECQeOiPMh4BlgEE6SvAgJ6nH2eqA==
X-Received: by 2002:a17:902:e84e:b0:1e5:1138:e299 with SMTP id t14-20020a170902e84e00b001e51138e299mr10911914plg.1.1714932674659;
        Sun, 05 May 2024 11:11:14 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id e15-20020a17090301cf00b001ec852124f6sm6760889plh.309.2024.05.05.11.11.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 May 2024 11:11:14 -0700 (PDT)
Message-ID: <15ea2df8-f2e3-4cc5-89e0-1abb2279a55b@kernel.dk>
Date: Sun, 5 May 2024 12:11:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Submitting IO events with IORING_FEAT_NODROP and overflown CQ
 ring
To: Alexander Babayants <babayants.alexander@gmail.com>,
 io-uring@vger.kernel.org
References: <CAB92dJbb3aMD14sHwQGDQYofj3H5hH84QTXuzQZ44TZQp0j1Ew@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAB92dJbb3aMD14sHwQGDQYofj3H5hH84QTXuzQZ44TZQp0j1Ew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/3/24 5:21 PM, Alexander Babayants wrote:
> Hi!
> 
> Per io_uring_setup(2):
> 
>> IORING_FEAT_NODROP
> ...
>> If this overflow condition is entered,
>> attempting to submit more IO will fail with the -EBUSY
>> error value, if it can't flush the overflown events to the
>> CQ ring. If this happens, the application must reap events
>> from the CQ ring and attempt the submit again.
> 
> But I'm not getting -EBUSY on a 6.2 kernel when submitting to the ring
> with a full CQ ring and an overflow flag set. I'm not an expert in
> uring code, but it seems the error was removed in commit
> 1b346e4aa8e79227391ffd6b7c6ee5acf0fa8bfc. Could you please check if
> I'm right and if that change was intentional?

This is correct and intentional. The man page should get updated with a
note on the current behavior.

-- 
Jens Axboe


