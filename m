Return-Path: <io-uring+bounces-2640-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6E83945E63
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 15:11:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 572DA285450
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 13:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A14051DAC5F;
	Fri,  2 Aug 2024 13:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XRW2//2M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067511E3CD5
	for <io-uring@vger.kernel.org>; Fri,  2 Aug 2024 13:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722604269; cv=none; b=YxPVTSoryImmyTmA0x6AfRTQSYzQO0WNXzJncK/MNR5X3TBTCf4hTexZUWqaLvt25Pp6uanP/kO+3Ii8GWPFYFrsNqISs1vD1gLuTFDKQT/bHfTHWF+DwcghRa9XgIRNYEMEgpz5NyVpMg3H+xPgo00bEaHXdXNeIFOi8C4Sd7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722604269; c=relaxed/simple;
	bh=2VXy1P4TwW8JdSKB8O8bcff3+MRmIkkBwzCOUP08IBY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=fYjMkk+2vUhxVcmzGw2ExXEwTGJgC7tXl5GLuH85kkYeiMAl+v64sa+qZ18//Uhd9dG1OOySs8oLN22QmTn2pEZNoR1B7kwT5OxkFnzWScRmthrvxM/mnKs1yrkYP7gQwOdPBicuhbMN90aHeNxLA6QBeISaB/fpTeu8yge1vRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XRW2//2M; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1fc4b03fca0so5118055ad.3
        for <io-uring@vger.kernel.org>; Fri, 02 Aug 2024 06:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1722604266; x=1723209066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5CCtvZ1Hq9dtTMtJQQWXHWK8pwk/jw5t+b8E3gK4Mqw=;
        b=XRW2//2MbLPs0yVm9lC4eY+RiQtDogkwgkUd1ibdVTM5kq3pUvg/mcb8z+7k/8U2Rb
         p6VF7FBk48MoCxyzrV1mLVeUWHr5/ZlT1o1PtdLGzprjR/V1FNNmy3i0Et+z/yHNGwxF
         HGhYZB+sE+4Qv7X1syrMWyqUeVt76wTDTQkycvOTRDqQz1oDbldH+3vZANu62xhY1i32
         0iHXcp32wdZ3hwP5OgDVXHu/5DZdam6a71ioCfeTiZY9Im/UAFsCn4isjyXwH7c67v0p
         IfkNDga+QC9NL+nPPyZcW61RtmP2h31W6UjGirqdq1WCRNBUTSIUgMKH6Owwr6m0ohfu
         0OyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722604266; x=1723209066;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5CCtvZ1Hq9dtTMtJQQWXHWK8pwk/jw5t+b8E3gK4Mqw=;
        b=NNAYuez5mniBgMAGPU2/sWUx8cXf8gWp/x+57Y0u2zNt7+1HZ8IoRtl4eJNn/IMs/Y
         YWf187aSCI4URDDQon7094AjJGXpnWX3lzpYgVnH6n2hGDxBTiqjQtOngmpWFVYTDvdG
         iHoBmk5zENybPwuZoC76v+MqwtnyjPTpANPCFwrP9FTOOaKCfz/stPs0al5GHFpZuBKZ
         ObKzE+ZqeuQI8GnjcObhWkdTSLWY67hxIz0LDZ0K/OmC3cV3nHTg/nghu1b34XhY1F4j
         2T8ZocRnczuXcOn+etaDlx0t5WjSdbP2OsuVxRzPZiLulWYPlA+mHf0vTqavh9ZC0u1g
         0I2g==
X-Forwarded-Encrypted: i=1; AJvYcCVMGD386J25rugfPN+l+QAQ61yOZJ0wpYdHxFQOYHGzPBzKFDGmjtgbmom1YSY3UFwy7o1Y7Np1TA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2L5SmbkQ/rEjeM1yJ45qeWAIVEikaE8DIE4WKxY8JZvCPV80m
	vr5FsUlh4n5eLC+dKoGi8ddxxb3PKAmzMJ3urgAT0sxno/CWj2opkvDck9ETs+L7mY9OX69t28C
	B
X-Google-Smtp-Source: AGHT+IGhGVEIF/ouMYe9OSvwr3jEqNYtuC/V2wcLI3feQw+lRCHJK+MFjp0lkk9pOf6I+D2ckIxUrw==
X-Received: by 2002:a17:903:1c3:b0:1fc:611a:bca with SMTP id d9443c01a7336-1ff57405d0dmr25761575ad.8.1722604265938;
        Fri, 02 Aug 2024 06:11:05 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff5916eaffsm16611305ad.194.2024.08.02.06.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Aug 2024 06:11:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Chenliang Li <cliang01.li@samsung.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, peiwei.li@samsung.com, 
 joshi.k@samsung.com, kundan.kumar@samsung.com, anuj20.g@samsung.com, 
 gost.dev@samsung.com
In-Reply-To: <20240531052023.1446914-1-cliang01.li@samsung.com>
References: <CGME20240531052031epcas5p3730deb2a19b401e1f772be633b4c6288@epcas5p3.samsung.com>
 <20240531052023.1446914-1-cliang01.li@samsung.com>
Subject: Re: [PATCH liburing v3] test: add test cases for hugepage
 registered buffers
Message-Id: <172260426458.62322.18366513044649945402.b4-ty@kernel.dk>
Date: Fri, 02 Aug 2024 07:11:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Fri, 31 May 2024 13:20:23 +0800, Chenliang Li wrote:
> Add a test file for hugepage registered buffers, to make sure the
> fixed buffer coalescing feature works safe and soundly.
> 
> Testcases include read/write with single/multiple/unaligned/non-2MB
> hugepage fixed buffers, and also a should-not coalesce case where
> buffer is a mixture of different size'd pages.
> 
> [...]

Applied, thanks!

[1/1] test: add test cases for hugepage registered buffers
      (no commit info)

Best regards,
-- 
Jens Axboe




