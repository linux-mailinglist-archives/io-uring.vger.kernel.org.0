Return-Path: <io-uring+bounces-4243-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7037B9B6E23
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 21:51:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F097CB20F7B
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 20:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 119311EBFEF;
	Wed, 30 Oct 2024 20:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dke4ZVv1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14B819CC24
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 20:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730321434; cv=none; b=hwyy4CEjrIcK4zYJ2CWeNbO+PgYhDoGRBWSM2VJZzOaQSt95CsrptKctUPd/bte5Jy7mTXg32TCDv8CCJ9IebrQ//oK5N2HYZhsKXvIfVCwH0vUdRxbJQDXRLTBtaYDSoKvZH6tNvF/hNsiWr1ut3X+MC8J8hcXgrLHzoF2GwiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730321434; c=relaxed/simple;
	bh=3pHlmcpo8YA4y490N9OoT9tIs+5u/LLUf3zRzKJ5URI=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TKfXWTu0Rt3cHBKf1vYVt9vsYDu3bDRBu6ThwEgJF6v3K2pMEZpXatsOGEXBAfptqxmhQ6n7WPR2kVQ3bvM7A98EOmrMgj/H2bx635YDrskSq3KTQew7uba4UZZPL0PLWqFTmYHpOk0PnqilhOzAot6X5tc8Dn97SSZtqGzNYJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dke4ZVv1; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-83a9be2c028so9147639f.1
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 13:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730321429; x=1730926229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u1ARA/ksH/6VfH4Rm5NsoeoxTmnLeapUXlRo+hN92J8=;
        b=dke4ZVv10doTmqAwiHGcX3/m5eDxqN6iAB+Fm26tc/rqFejYKJZP2AJbQUv6nlcS8L
         NZlmaf9u9/l8dI37QJ2gmWYVlWPHl53w8WK1szf4/DrcdwxrKD0UZrz1zWb82W2N71g0
         U+E2+ONt3oL8MGAIOZM27a6bWcMEl5OVsnm1HyruP26sB3xjymEOaW8Rqi7S644h7I+I
         ROo1UowIckj64pEPP/0zhp93NmHhwu7J0c4Ou2toacUcICIrkrI8rWWPGbulhqOcts3c
         vMOZ3F/DdzdnPi33T7eNAcYt1BXkmLj6WCtJT46NwXhppZULZlwVkdWppl6JZXkkVYiC
         xo/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730321429; x=1730926229;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u1ARA/ksH/6VfH4Rm5NsoeoxTmnLeapUXlRo+hN92J8=;
        b=p3ZekmdZ3qNUSfcJ2ltEhYalVurTx/Os0or/r6hlQwNqSsXTfawZSt1r/qlOllYBVf
         oqmaszIuiKx1xXtBd36HERCcAJPTUOgRaCAsAZQEWd1S8NG8RlrYAWIk248tkpFc+8Xf
         7ort+V6XJMftS1Iaxj2nVfFu+3rzpKze1HBqBQE7rMpv7gZ9tjEyAQMFYunevFSkVYMf
         JGSp1SRj1IF44HTLeSiGjuKPuG7kydxh9sFSB1dKX1sWlWsNgWDtqlLsNjRuANnfkffz
         5vB14hxmJRZ4lxDevYKUpv8enZ1NvmMCSp87fYzgLPD5OtzboGWlrlX2k3fdMmlPjrpK
         afrg==
X-Gm-Message-State: AOJu0YxwBX5MYv0VxCPZvM1RwntvKMI0Uwq0IO4N259W0bKSldNScY8L
	YH5T1xNPO/Vr55ziCel85v002oZKHP+yKg+9j6lEneXctCiRq9mCVV2IUKRn31DtcKZuRGvTsvu
	PyYQ=
X-Google-Smtp-Source: AGHT+IE27tqNlXjxIjv4qjHvxc80R1ZTzxgNvH8vy1YawEaerUnJjGmfeO4GK/EHW09lNih+3z43yg==
X-Received: by 2002:a05:6602:6d10:b0:83a:aa8e:5f72 with SMTP id ca18e2360f4ac-83b1c484d25mr1536192639f.4.1730321429202;
        Wed, 30 Oct 2024 13:50:29 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc727b23aasm3057796173.172.2024.10.30.13.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 13:50:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Haiyue Wang <haiyuewa@163.com>
In-Reply-To: <20241030175348.569-1-haiyuewa@163.com>
References: <20241030175348.569-1-haiyuewa@163.com>
Subject: Re: [PATCH liburing v1] Remove the redundant include
 "liburing/compat.h"
Message-Id: <173032142829.103392.5604936100310118191.b4-ty@kernel.dk>
Date: Wed, 30 Oct 2024 14:50:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Thu, 31 Oct 2024 01:53:45 +0800, Haiyue Wang wrote:
> Since these C source files have included the "liburing/liburing.h",
> which has included "liburing/compat.h".
> 
> 

Applied, thanks!

[1/1] Remove the redundant include "liburing/compat.h"
      commit: 99a09d92097f3362aa624fe9b1172de28203eea5

Best regards,
-- 
Jens Axboe




