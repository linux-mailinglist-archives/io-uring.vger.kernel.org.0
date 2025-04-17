Return-Path: <io-uring+bounces-7525-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A688A9251C
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 20:01:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A544466C4F
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 18:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C4A2580C0;
	Thu, 17 Apr 2025 17:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="z6van2kq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED317257443
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 17:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912725; cv=none; b=gycfv3tARr7CLzVYvXRCA2P0ntRnxn/iz2bzDCdFLnIb9B1Kl973rqPDUPGcMlVyVWyVGFYLkXDGXusg5MzWij3mmcHx6Fa7s0ULBuimT8bIobWemzrzHatx/KKGMNrQFJPM7XayMrbzL3bt6FSNdCLl5z196g47iHfxH1oaG9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912725; c=relaxed/simple;
	bh=Bs5SCkOVySPKeGtVbyBhS1WPbEpKWdnuLF1Ek6on3yU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I6WSomVa2RBkJzBKE2zL+aT1CPBx/96/ydYrqcRiQDnvsYRP/N4HLs9gTxUeU8GskWtatNNJ5wkd0oxzLZeTI6BVJQlU3Iy0r7zmqkjm8qLL9xWUKJDyl5kOllW39kl51/YGn9DIpyVNwpWeCeOK84OFlTHjLHoJlWTG6ljawkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=z6van2kq; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-855bd88ee2cso28885339f.0
        for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 10:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744912723; x=1745517523; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lbc8tv95Wm48XTivRQLot66sPcLLH5kDzb3ZX/Hnfp0=;
        b=z6van2kqeuxe3LRqs69fqb0n2V5ZaIreFpuAC/OH07IUO2buJ+Lf+n2OI6eSjiTIG3
         gEPPtKsm12CNR92SQe82WqhnVJSw/xJ8Gk57mUQz+0DTF/odfnr20Jt7gbvGBkpQDXIb
         WpW8euHqwBwRQwsyuoe9lKyNt2LiMbX/w49txu/gXhal1U18lg3w4Pt/T4SJF1L9asL0
         q1YjtP+wWDcfs/IWFSTMq9A9PMV+yra7pueo7uZN4Oe3+QvH1Hzh/8JWQV53LPjjkEMm
         dteRqjOdqizH9BUdGMNBQlnlS41dPkIAasYRHcfPzocEUX/5NuRCXYHCkT22fuA1BzP/
         tfrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744912723; x=1745517523;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lbc8tv95Wm48XTivRQLot66sPcLLH5kDzb3ZX/Hnfp0=;
        b=v6OsC+GVCcle1+9HM+1rNZCXDICqs1QmHDljHFh4e06D7SAMKvjQIgMkdf//naZDmt
         NztgBx/A7guVLDp+gK58lXyxoEYtcwMWf1szrmtyagY19/PzG9mExi787Ce6WOuzXiV3
         QNhPS2Ws4BkmLj/WLCxtAS4aUpEHF9T1mBTXT30NyQK+7FC+nFspRy9bFEKYuTNyfknQ
         0/o+rKGPU6yuKOpx+2xAJSPOSRW/2SlZ4k6mjnPJady44iAdPAKlTCZehe/SnAcN6VpV
         5dVgeaBHy0bb6FC2aKod5lH4vOIPEpU1wZ5QSW4O6IHd6z80UwYg4+UaQzGCLOclfHJ/
         u2HA==
X-Forwarded-Encrypted: i=1; AJvYcCUVuk0EsodAoujhG7kzKD3Vcy0HVTdu8Q/kB9Q0aiNrhK9sPC2sfs1K0eVV00iK4vR2CFt718ghEQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxzzRvch0ZUd/t+DRm4x06+Y1kk5k48zyBznmeoDWyWhRBqc+t1
	MvW8kSTVlyqOdRaUyW6otVMub7Jd100UOLu7iYDAzdUBZXcAgl1mWuCtrLJU0as=
X-Gm-Gg: ASbGnctqAKteX0V4f8rseffUJCxRo91UEUphuL8liUkRtGMXuMgxqqrhSDA//+H0h6i
	H/w78RLxj8W2OyTUErEI5hBu3MO59Cts8m7gogF/sIzBiYg8c1AHYg9iLkiNEVi24VSv+qlVJrY
	ZxTqgrqDk43ad4DYfsZApZseABXr7aANrBsz4AVqPCJcN2GZO+YdsIOcMUMCATLQ0dnCFlPzs+4
	H1fhbPUWAcTBG/rT2EAymyLkK1znn555Q1ojmRqO4AfRHHGtESWfRv8HyFMhgE1teBLJpCIjw1n
	2QDGqdWxtoG4OeNLrcolcKcbTbTUVzU3O/J0hQ==
X-Google-Smtp-Source: AGHT+IGhnXFhAoK20gE/YOBSvPiWGC/tr2SXmWdunqYH0pqB+f1afJCFBZtiLXCNmPmGFJdAsiF2Aw==
X-Received: by 2002:a05:6e02:32ca:b0:3d8:2085:a16e with SMTP id e9e14a558f8ab-3d88ed7c379mr323385ab.1.1744912723080;
        Thu, 17 Apr 2025 10:58:43 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a39991desm55087173.136.2025.04.17.10.58.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 10:58:42 -0700 (PDT)
Message-ID: <67cffda3-c211-419c-8e49-cf38def85b63@kernel.dk>
Date: Thu, 17 Apr 2025 11:58:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] liburing/io_passthrough: use metadata if format requires
 it
To: Kanchan Joshi <joshi.k@samsung.com>, Keith Busch <kbusch@meta.com>,
 io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <CGME20250416162937epcas5p462a7895320769fbf9f5011c104def842@epcas5p4.samsung.com>
 <20250416162802.3614051-1-kbusch@meta.com>
 <3606b88e-67f3-45c1-94b5-db01c20c9d2a@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3606b88e-67f3-45c1-94b5-db01c20c9d2a@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/17/25 8:51 AM, Kanchan Joshi wrote:
> The patch looks fine.
> Just that it seems to have a conflict with the topmost patch [*] at this 
> point.
> 
> [*] man: Fix syscall wrappers in example code

Confused, there should be zero overlap between this patch and the
posted one?

-- 
Jens Axboe


