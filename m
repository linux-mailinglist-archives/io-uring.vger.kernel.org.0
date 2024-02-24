Return-Path: <io-uring+bounces-692-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B4608625D0
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 16:30:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 580CB2830F5
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 15:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A334502C;
	Sat, 24 Feb 2024 15:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Jn5HFJ0G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E095F2AF04
	for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 15:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708788597; cv=none; b=j3R8QhzMpVLOP4qb4DBTtSShwapm/VwozjIusxhb95d8MfGhbu/LPgWScPTXcmYASOiFbIOXMsddYejaZeXHVcjV+VOjgQ/I+2s0fgV0cZ0u7W+5c8aEv2aDXHY6xOLEVe8+28ERN99d8351QNA1dKV45F1+O/54xh2hlnb2MoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708788597; c=relaxed/simple;
	bh=j0ZFR6r5weQtWC3kndMYSnk/ds8dMpkRg6EZwNIk4Co=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PIirGkgEsRQUIP9C4GUsjkrTxN7iLk8yUFKluG0YmUBDYaZn/ear7FxgPG+wzlO1UcVDENC0ekCAdAfyb2AG4riZ4S7LYLrxs/uQR50LwKLjGVL1zklJPeDU5sJaeLhWNBUA+F7kE1Up5dxBiaXC9ICrBqBxU5iX36zBp4/Q6NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Jn5HFJ0G; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d748f1320aso1580425ad.0
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 07:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708788594; x=1709393394; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k0dDrcI2TYerxhZzS8JKN7B+SUk7MzyNnKes1UUUqWc=;
        b=Jn5HFJ0GXlfaKzjK034KCFW8dGwOJ/aLed4K7PNmJP1LFaUKGZWqle6Ojgi32Fvcln
         NKbBwepMeoJD1AvcGMvsj3f7w/KZRyt8l35BZH4k/hyE+Z8ZyDUZ7sd97OYG9l/z1G85
         OvdDGQA4hKHUv22fplsOce6pvmRXdek1Kg4vTLoIYURhpv20mb13BUq90BMk8Ayq8sDk
         J9AMfRUK6vmD3Ndsfqdn78OQF80JhiOabQU1isJdPiJuQnaQ374hhCyY0FprydUotNu4
         GlP/6xfJrWtLq2cxyxnXy7bjSuNE9wFCiv0T8nce89/tt8nGoEm5b2aoMyZ2YjTzeX0R
         9djQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708788594; x=1709393394;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k0dDrcI2TYerxhZzS8JKN7B+SUk7MzyNnKes1UUUqWc=;
        b=CqmTL2zOqOLupQmYQwOuPpJIix+VWpW34S4hGz9KLpPMp15W5A6CYSaZrFk9cfSilK
         1QGeB35lDC0uWEKtblN6gt0iTDCwzA8kuryqXIW2ydWIBOB2gGuDJlDSYQmoQ2XvjxBH
         w1vUUtekktK4zq2/p0wTkO3NsyQ7XhpAoR+Oxn0JUM0KeDOr5EXLXO9vnAzdB2Lkt36j
         lP/0kdOMIgEio2GqZ5f1qMCvUnAwLARvdzJy5remO/FZ73lbZxfyJSZfzl+LUWpOmYF1
         +1wL0OBlniAXlAASL6jy8OZzyxuguoIJkchnEUcXwwQNMamGZwaQWMzC0Lzcv/EAml8x
         +lFw==
X-Forwarded-Encrypted: i=1; AJvYcCUouQleq1TCZ/XEpPfVRxi/ZHt880DZXovLoi787CUG2S+grQkmVQUdcFsQZ4XXM2GDoHzWKLT27GVoIgoyiSixiYPsAGYPdFU=
X-Gm-Message-State: AOJu0YxthK7HmmT0EpsmTH7b6o347TDPPvJO3bk4kd4tcHzwAEcJ73ev
	7TO0XNrCqa2D7C/slF7lrSoR2BXHX69q4cEobgg/AU7W4O93inNWBuuG2zdWs68=
X-Google-Smtp-Source: AGHT+IEr7aidBe2iRdIHGAcjWPLKh6j5EhGxPYheFWhdMPL2p5/Euo9cxq97MZuMKL+vAZnecgiOvw==
X-Received: by 2002:a17:903:32cc:b0:1d9:f015:b212 with SMTP id i12-20020a17090332cc00b001d9f015b212mr3116731plr.4.1708788594235;
        Sat, 24 Feb 2024 07:29:54 -0800 (PST)
Received: from [172.20.8.9] (071-095-160-189.biz.spectrum.com. [71.95.160.189])
        by smtp.gmail.com with ESMTPSA id i19-20020a170902eb5300b001db5c8202a4sm1143844pli.59.2024.02.24.07.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Feb 2024 07:29:53 -0800 (PST)
Message-ID: <ed86f5e4-2f2b-4d56-9770-95ed3475f2c6@kernel.dk>
Date: Sat, 24 Feb 2024 08:29:53 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/4] liburing: add helper for IORING_REGISTER_IOWAIT
Content-Language: en-US
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20240224050735.1759733-1-dw@davidwei.uk>
 <20240224050735.1759733-3-dw@davidwei.uk>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240224050735.1759733-3-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/23/24 10:07 PM, David Wei wrote:
> From: David Wei <davidhwei@meta.com>
> 
> Sync include/liburing/io_uring.h and add io_uring_register_iowait()
> helper function.
> 
> Currently we unconditionally account time spent waiting for events in CQ
> ring as iowait time.
> 
> Some userspace tools consider iowait time to be CPU util/load which can
> be misleading as the process is sleeping. High iowait time might be
> indicative of issues for storage IO, but for network IO e.g. socket
> recv() we do not control when the completions happen so its value
> misleads userspace tooling.
> 
> Add io_uring_register_iowait() which gates the previously unconditional
> iowait accounting. By default time is not accounted as iowait, unless
> this is explicitly enabled for a ring. Thus userspace can decide,
> depending on the type of work it expects to do, whether it wants to
> consider cqring wait time as iowait or not.

This looks fine, would you be up for writing the man page? If not. I can
do it.

-- 
Jens Axboe


