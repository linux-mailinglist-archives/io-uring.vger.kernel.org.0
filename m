Return-Path: <io-uring+bounces-10103-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2BCABFC675
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 16:11:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AF3F628196
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 13:47:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A54C34B418;
	Wed, 22 Oct 2025 13:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hMrioFTT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E32534B1AD
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 13:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761140778; cv=none; b=sOEYq/qmHCpyx97HS5lLMhY4/U3am1AxhPj63wAbzkrXNtiHioyfNc7IZedy19LLQJvPqEhBaGCIwoA51W4jAp614EXrtfPd5fBQtbhJ+dADQN5PPpYuTkDtIuhC8aj5QWbX/QU+ZG2yTCVK+kP+/JeK4OaEdrT1PAl7LqVpyBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761140778; c=relaxed/simple;
	bh=yA2lWnYeOsGMIHc6VyQMkPT2YEEU6Yd6eVJPkXh8Tyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y8vdwpcoY7C75Hd6LT3OFI4/KTmqo4wyxWK19HwhZyAeWPx/aleGRx/0/Saywx7isOHToGmEVkvs+uGbbLD2aVyulEZm99uMOIRJZOF9DuO19FwLConhXVfhugFzJ/5mCwLaqRdw9Qdo53+7KSBTSEnVyz/2q83QiOByzpa1O84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hMrioFTT; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-430abca3354so63596075ab.2
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 06:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761140774; x=1761745574; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LMa8S3z385kl/4H9dQfYkDdJgEgDVCU2D6eCwoHGu/o=;
        b=hMrioFTTW1Y0wTK7/XdqDASYG7XFxQFuc9MrjO1lsqw05EEb+wTV36ANpIqJlR4Aqo
         YGo+TPR0Ly3GRSZYprFTvowj5MRQiBd23sAiOGYufjnNNyltzMFO0BkuX0Nvf/acZ6mo
         snEfoQ0P8kb+qsy+NnhDyMlZvcR5eOkaXcVCnyBVeH4+Zc7OJskDWLePNVFjxRkbd6tP
         YKKgToaITRQLfIoIbOii6Gkn25gFtWmpjzrskOShBTP0IzKU8KRCN3TiGgbPRYBbCGvh
         AKlfOfZ180XdOrX90gF91PDrKC1KAzBojYRDQETneoGFS5ZxO4MlW5fi2jMuf3bPOIhs
         29Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761140774; x=1761745574;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LMa8S3z385kl/4H9dQfYkDdJgEgDVCU2D6eCwoHGu/o=;
        b=XUBnwpx4wb/1uyeP3upu27z5k0TYejuTFppW9AcQ2mUieC5ZjyELsyhBtdDXTlSL9s
         ORA4Ue3Mquxi9tWTWloTTbssKZh23yLTdjqGF0XXzbsJF3mkqXSwinR7eqjf1YUplabm
         BiHU7bbhHEwYuvvCGZr0u/rvcQqWz30NEKEEFQ1Fh8nybE7V5C1Ehn1M2Fq2fmiycEuB
         y/rupECtUTuei4fJgJoHYFg+ZMlYZ6Co2N8SdVYpjdikVCBi3gfASvrOtO/nwjnbz33n
         gWJvSZCRkBYUVSbBXKy1yBT/Bkw/siFZ8uBWrI1A2NpRLormu59CsAQU27WWicUGQ9+j
         GgBw==
X-Forwarded-Encrypted: i=1; AJvYcCU8UrXM5KAlcuUIr+CAI9bMD6g9gVplIt+H05HmAjwDrcC3NSUPQqmY2RoSwyoMOBmsPDEXilnq+A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzcFIMBY28FPL7gPwCfJHdSIRyy00LaF72haH2tQxZQ67xTugQu
	ta4E1PNeM5Q0gTgn8xQw9/Ah1sJPJf3TDVCUljWLUYtmaOJPbRi08Pxc7IM3yBKDvhs=
X-Gm-Gg: ASbGncuCPoimPaU+wMxqypYUybDwQelx4OW7AHWKlTP06w6LeD/dU53IL10YV0ap36M
	NCzg2oZ6UsW7crAWTcpxup/BrDncfl21XfPS5GlVQh/L9shVz6ezs7t3kscDHknmMp2ewSyuMEd
	u6RPEgzxMYhTEtKY9/qkylvsejcMJEFq6WBJ4g7DYyUe6mWOLSaU3bX1edOpPQBZvNlO2mfRope
	hkFvF5AnMwH6/sO7OTRpuuof4R5iQns5XQDwtt3rMXzInACITP3r8YA3tZKOzuVtyIbtyrGmDJ6
	xM/veAhtK7nTgjgFFdXxEMuvveT117gKTSAoVHKlg55idkcjgkm+AgTePLvkusMzUTIDUQlQonG
	6Vb39ojSM6JgyN9sXE5BZ3Y2abQw6wYwHuoRNxzrB7MB8s4uT9PvOAKUYP6O7dawYl5nRD2Iu
X-Google-Smtp-Source: AGHT+IEfD6GtwrizjSnSJ/vma0lV9Pjo5jtl6uYqaNlzb2Hov9ADryiCCr909jA9XOYjXdKBJYINOw==
X-Received: by 2002:a05:6e02:156c:b0:430:acb1:e785 with SMTP id e9e14a558f8ab-430c5208dacmr295440795ab.6.1761140773944;
        Wed, 22 Oct 2025 06:46:13 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-430d07a8220sm55488655ab.25.2025.10.22.06.46.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 06:46:13 -0700 (PDT)
Message-ID: <e5f234a2-ef18-4a54-8436-f23f7490c9e4@kernel.dk>
Date: Wed, 22 Oct 2025 07:46:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] io_uring: Fix incorrect ordering of assinments of
 sqe and opcode
To: Colin Ian King <coking@nvidia.com>, Keith Busch <kbusch@kernel.org>,
 io-uring@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251022134431.8220-1-coking@nvidia.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251022134431.8220-1-coking@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/22/25 7:44 AM, Colin Ian King wrote:
> Currently opcode is being assigned to a dereferenced pointer sqe before
> sqe is being assigned. It appears the order of these two assignments cs
> the wrong way around. Fix this by swapping the order of the assignments.

Fix for this has already been folded in.

-- 
Jens Axboe


