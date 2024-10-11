Return-Path: <io-uring+bounces-3602-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AFE399AAC1
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 19:57:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2202B21F3A
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 17:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47AD19F12A;
	Fri, 11 Oct 2024 17:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SGDYoiUG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525F6195811
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 17:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728669459; cv=none; b=Z9Q66rlWua1QsC20F1/YOeTSSR+tcObMQVmJ/EhSI+jv1PTIuPFh4P61OIUN8KmpZrnmLaBi2RVPYj82Lv4KCC8ghJ2RXYxut8UsE3vco86GfhydB+TXPlP4ARBk/az6r0aUAFuSerZN73SnZqWBN12VuV1vIfudWbcWc/QiqAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728669459; c=relaxed/simple;
	bh=HASNl3baFUk3DXkPtqWpYSx2LvLmgC0Uc3d6ylrr+40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h9oegUcM0VRGc4USlz4Gd8zl8RbbBk1RHfKpo9mnLZ7hSJ2dsveoDzPtDsmrauIS3zGdDZ5IatIzQbnuNIMocJ9mrVv0uZqEsY8tsAudHmDEf4pESmF1a1wuZGja56NUgK6zJmu0RRYwym8zDnK+aybKYY8MVlKBOX0HYnMaT/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SGDYoiUG; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-8354406f92cso88085439f.0
        for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 10:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728669455; x=1729274255; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8X8KlpY2k8rWPiQoC8GoUeonTyZni3MXAErkSzr+wmg=;
        b=SGDYoiUGI0ORbmbBp88X/5T0o7yPX5bDYk9Tty4VysEVXTCjypeVmo+uzDaOXIQ2al
         o+YKpBpniciBmm//nzn90h5RK3h2CI5QO4fLfDzWdOaIpATfslo4CIF9Koc7Or5eY5KS
         Fx7eTnLG8te3OUwjTHxN9jhCtEr/tZR4MUXF5a53BHJVkN6ZPIwQwy9WHD1G4DbVS2MX
         yBUv197Mzi7bxqDtl59icrGRLL5ICEHLiIV+w3J2n8L1u03P5sobY95GqO8GGamZvZOe
         6tWio6yus1n+qPmsEdMks5VM34cisBLV/OECzEkvrh2gPqFTaJ9Vyf3yTa+F5WJBxGx5
         il8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728669455; x=1729274255;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8X8KlpY2k8rWPiQoC8GoUeonTyZni3MXAErkSzr+wmg=;
        b=wUl5jZ4pqVsdM7tegdh7tn7XbhpJxIbKwQ7sq4eZN+0DFZ1DP4onJi/u+I1rtpTlHp
         DxeiZybN5GPbvtGU4CNIeGbhCumS/XmjLJzYhBXwirdU7loWuSt6iccHPBL63FjPBiol
         JAyO1OajZsp6h2AsWioX9te6125S4N+lJsC+jR3bpE8Zw6iKDKZW8c5Pm6iEyIFfLdRM
         wlnvex7dVj60G/HDzuFhjHdncP9q065zEsTs9a0bEFN8G7ssIIhrS6DRcgQwPntygwgp
         HcxOlcu4Wn+1rg6KqUsa9v97Ec2bNQNPEYOjzEjNP7ajBYFPgaE6XFl67BX9q/5TXkTD
         vxpg==
X-Forwarded-Encrypted: i=1; AJvYcCWO+EwumevwUcwUdOgvqbobePYxi40Q/zxE77GY22Z317X2FzwttDwBVC8JBngjmQ36cDygIE+IRA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxcmLaupMHH6w+ju32YZXB3Vpi2maiPnhEusxdlvr4nyneTZ2H1
	zM55DOrAaVGCrvbB6BuJz2eqhieTVyvdDGawdb3sIxFwU9sKtFWj3uAlrWwjb2A=
X-Google-Smtp-Source: AGHT+IGK4jkXMNvgxN1U3c+bu2mfsU0aAb28nw6kmPhvbFwFGoc8ErzxILM4AlO9MNCCTvFwTSRenw==
X-Received: by 2002:a05:6e02:1c06:b0:3a2:762b:faf0 with SMTP id e9e14a558f8ab-3a3b58ca80fmr19886515ab.11.1728669455315;
        Fri, 11 Oct 2024 10:57:35 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a3afde45e8sm8008935ab.63.2024.10.11.10.57.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 10:57:34 -0700 (PDT)
Message-ID: <f83d5370-f026-4654-810a-199fb3e01038@kernel.dk>
Date: Fri, 11 Oct 2024 11:57:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Large CQE for fuse headers
To: Bernd Schubert <bernd.schubert@fastmail.fm>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>
References: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/10/24 2:56 PM, Bernd Schubert wrote:
> Hello,
> 
> as discussed during LPC, we would like to have large CQE sizes, at least
> 256B. Ideally 256B for fuse, but CQE512 might be a bit too much...
> 
> Pavel said that this should be ok, but it would be better to have the CQE
> size as function argument. 
> Could you give me some hints how this should look like and especially how
> we are going to communicate the CQE size to the kernel? I guess just adding
> IORING_SETUP_CQE256 / IORING_SETUP_CQE512 would be much easier.

Not Pavel and unfortunately I could not be at that LPC discussion, but
yeah I don't see why not just adding the necessary SETUP arg for this
would not be the way to go. As long as they are power-of-2, then all
it'll impact on both the kernel and liburing side is what size shift to
use when iterating CQEs.

Since this obviously means larger CQ rings, one nice side effect is that
since 6.10 we don't need contig pages to map any of the rings. So should
work just fine regardless of memory fragmentation, where previously that
would've been a concern.

-- 
Jens Axboe

