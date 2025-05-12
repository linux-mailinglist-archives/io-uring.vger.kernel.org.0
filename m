Return-Path: <io-uring+bounces-7948-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B81AAB3854
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 15:19:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6597B1B622BE
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 13:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2AFC2620E8;
	Mon, 12 May 2025 13:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mTFwBGDS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC00293743
	for <io-uring@vger.kernel.org>; Mon, 12 May 2025 13:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747055898; cv=none; b=twdo0ILK9ZT0IIKst+tS+Q+JSBLInYPEUszerfT79XYBvoJyuXEO5pChnuqdaxzP46vwc41aghPD3mfeTezbdVjtEcYr+5fzF3zxD4YlsCkRBoEf7U4uDQ8duSxt4Ari8NoOVlq56tBkQTbz/mCbGnqQP4CJHQm18AZKUEgmahA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747055898; c=relaxed/simple;
	bh=P2dRAMFX0qcGaFDfPPQRhczLoo1DwJLvuyQrydHY100=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pdsBw3FYjK9xlMGvkSuOUBLAdQZiJzXPBQOjv8iniOUoExHNAAfRjiqiI9+Ahw49yP4J3z5W/WVTiWeoPSLPeq182FhGWsrAqpG6TO0FdbkvlRYUDc3MyAIlgCRrcKHyF8l7jCJBopktsOWdjoGkaFm/9/6KFQEr3KX+oxuQNUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mTFwBGDS; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-40337dd3847so2988761b6e.0
        for <io-uring@vger.kernel.org>; Mon, 12 May 2025 06:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747055896; x=1747660696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sWBT4negj8RQi0XhwnIgygPRIevoAEB3n/nLguidEBg=;
        b=mTFwBGDSrdo7Z0mGaMloOBTTb6YH7hpbHY/cLSvbFtxD/76cJBSa457GNOMsIpGdRv
         Kl0bVrZ4KLOJ0WR2IZ594JBRz8OA7nqz2rBAmVP9ayXnmJnGtfJuGQ5wD5wPcWvD5Vxr
         hmb7QxgtEMUfwPdM01wkbrFMrGZh4M1gS8n07JUbJJgPRgYquoVi/ZCt77Aw2IAluNsI
         ouRRPylZ/NFMYWCKs/LpZFz4KpJErs/trvEr6Pivw47M8TPqz83bBjXDpm/PyQClZYcL
         4gG3nlFZV3JWaveHZQkWuzAJr5M+f1N3gGXZVQftqRDS2EjeKVpDt9oOF6ROAJrV+/ND
         Fqig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747055896; x=1747660696;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sWBT4negj8RQi0XhwnIgygPRIevoAEB3n/nLguidEBg=;
        b=a82bhC6HbP/t6/IZ98Yc/sXplpHdfp0Bg8Gc80wygcAdAWB0eaAQ8nGnpF/UYgklWM
         XDINfcj149EF0Vjg1aWzWSaG9UtBK873dDpZBk+XYVSknABcv1yINrlndQvAU/Mif3YH
         q2+Ph4vAkEgzt70nL9zFX74WUofcahIQKoZgclFTl7sUkRGgzyGlFOMFzIfYPSQbRLnX
         JPlB9FcV2QDuhVjc6sWGegcnl97jl33O0W4/d/NROPQ9NQqj1CB1xetIQx1ULzebZtbN
         SOc6NYLCnJBeDAg08FejbYKRPdMXMZKJ1RvG5yi8W67SpTxvHCXy7sLOQmXPCZsXWYNr
         X6rw==
X-Forwarded-Encrypted: i=1; AJvYcCVLf5a6fWVssxdwShtj2V1CbwoqHJclj4tFpTIaDlk0Vbht6FK+qLSZKz6svfDY/Lt2kL+N5gR5BQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbDB4uckQSFCnDcn2OMEv1iCIdcl0pKtFfXjOw1HzVo/6eVoRv
	5YBf4OXgrlix3q3NROIduoMlOrPdjVQHcyoFcSamNFOUqnU6w0f4fOVIpfnMS9D3AIeps9+sb+E
	i
X-Gm-Gg: ASbGncsB12vcx+ycVM/IHZRL445WY28rLyfyCiMMJ8sycMPJpTbgcaxDOtLLaQGY4Af
	0gbAFwVCEKoS9LaFHa9oHvlSHj/NWXuSnkKEy3zRKrVz5OUR59jqZ1XcVMfqc+GYhSzx4MFbG1A
	NkMzkr3+u8K3M+QinrAwIta5CJ38cY9lAL2xF7RBS0gnVHLh1RiwyM9GG8R4Q4dYdvVlv1eMIwA
	mWp5UTisZdRltTn/s2hG168IVqT2LT7hxvAxCR+PpZX+E+s9pqaTZOTsW2NSlnLmpzAOs4KIgfO
	IjzSdzZolfRIBUe/vWRBN3kNAgaEuFw47M3HVMM3hg==
X-Google-Smtp-Source: AGHT+IG/5zeiMFHKS8IyQonI63vNtLgrs9uV3VjFWgQcIiC59hYMOOfeXSTOWS9fAtpxxqoHMH5LeQ==
X-Received: by 2002:a05:6602:14c2:b0:864:4a1b:dfc5 with SMTP id ca18e2360f4ac-8676363f86fmr1352730739f.9.1747055885202;
        Mon, 12 May 2025 06:18:05 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8676359ba29sm176561939f.15.2025.05.12.06.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 06:18:04 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, io-uring@vger.kernel.org, 
 linux-kernel@vger.kernel.org, hexue <xue01.he@samsung.com>
In-Reply-To: <20250512052025.293031-1-xue01.he@samsung.com>
References: <CGME20250512052032epcas5p46bb23adcb4a467aa7f66b82d3548b124@epcas5p4.samsung.com>
 <20250512052025.293031-1-xue01.he@samsung.com>
Subject: Re: [PATCH] io_uring/uring_cmd: fix hybrid polling initialization
 issue
Message-Id: <174705588448.247808.6501961684516109149.b4-ty@kernel.dk>
Date: Mon, 12 May 2025 07:18:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Mon, 12 May 2025 13:20:25 +0800, hexue wrote:
> Modify the defect that the timer is not initialized during IO transfer
> when passthrough is used with hybrid polling to ensure that the program
> can run normally.
> 
> 

Applied, thanks!

[1/1] io_uring/uring_cmd: fix hybrid polling initialization issue
      commit: 63166b815dc163b2e46426cecf707dc5923d6d13

Best regards,
-- 
Jens Axboe




