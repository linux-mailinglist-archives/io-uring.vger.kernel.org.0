Return-Path: <io-uring+bounces-7934-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2EF4AB16DA
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 16:08:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42B8F3B4411
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 14:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29E791EB39;
	Fri,  9 May 2025 14:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iIFZKzlL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E942918D2
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 14:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746799338; cv=none; b=kdJt+Ke3U7LLizaD/YTM5CpgSHYdXKzoyZS2+Gnyvs01owqrABk+c9wZDgb80gWwJry+zb/GuxAjMaf+hTb6ljPvuXUTTTxiFfZTzLREikWRC430W0X3I1eNAhaLrYYAUJrWdTbDlwfX4JoMEplOuYMXMRy8wwC1OvBUmclUS4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746799338; c=relaxed/simple;
	bh=wJW1Ldxq2BQB7bpeWjtVSUDSMcESt+FFBPX41+ngbOk=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=T8Edf7ZrXxqk64J9UALIGtPFIj/pZZ6DXy+cjosxaKT7zABURGnwRcUuTidm2ayWnL5ZOd+lkk1o/ie/IHNG9ukYrMo2cu6xpIwntBr9LOC99tpgOXvr/i8oveFWkRa1Kpgq4gnWKqNySHmlSuNkt9QvZ9+rlzOK5hmQ7c6ldIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iIFZKzlL; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3d96d16b375so10218095ab.1
        for <io-uring@vger.kernel.org>; Fri, 09 May 2025 07:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746799333; x=1747404133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oMpgmQhh2pRMyBOayk3B3ch5LPmUO6EiYwBdpes7Y0A=;
        b=iIFZKzlLWgNnfdciJM4UQJudJ87PrLcgEGixL+dsG+/6oRVsM0C9WmQjNbB3VpMm+s
         r1K+RjfPfa21G/gluDn/9o2Ee/WqTxHza0Sxj8wGAQegpTYJc+lxgpgneP+9sYerNLQH
         I9TG//BLjOMICSqENXhx0cp0JXOfPeMFnJ1oFyJX3fKtU/3ZYSWXWXwsZF6HJhQof+Mt
         9wwEAfQ5rtDSDcaDtogZHQebVoJ9tg4TCnzYl/6WdNUI/g0SNpTIRxFz/r4nToLGTW8j
         9fa/KccDlVcGq0lBtum6K9rWMFnDyvmWjFCPa/5YiRGMfeXICRvYmeJ6Z+JBfEPa57ix
         MhKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746799333; x=1747404133;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oMpgmQhh2pRMyBOayk3B3ch5LPmUO6EiYwBdpes7Y0A=;
        b=tRblC+t0+pSLVOtLcBxBg9Rq+CDHtM6WIwW57E6dWaBrmyEYPm3JsRpXZF4X8SD7U/
         xNWTugGrFuDKYeMexDTJD4jJKwT63NAMRkVBWELLOzy+Dh83RkCJfEoEtKsffB4rmUXg
         Ksa9eD73mDxNMNRTiDab+zDIQMTNC5R68wbTgahe2HIUxkzhp5ozRQrmEwgT/T0c1rUJ
         2E617fu8NIkZ6zbyPuf/dNkbD6vlPldQ8OvcxLe53N4t+4vX4bzaFU28v55F1Jwcomcy
         tjjGbddUjqzBiOCggowKd8GJstzhcx9/XsNwK4lACT5iLtX/lmqV+tJ4ftg9j7xzP3wS
         NH/g==
X-Gm-Message-State: AOJu0Ywdn5MuKRZWCm6m315on93ly78IBwRcgqXZ2wzbTIGPXNAY7x6v
	EW+0RELfaHMjDmFLu6NFK5E4lH2w9gGBmbet3oRj5pzo2X5GuIP1HUIpYYGfPa0rLbXLJFAw1Ni
	J
X-Gm-Gg: ASbGnct5SAiH0jvHajpzxMm2kwsQQdLYNRAvgDlyiCHfdsNHzSuk12uOI9ETgCCOYXC
	2e0cpGE7jx0R0+mcQ1bUDTwDeoafa+w7aSHCPAJ4zXDoH0dmmdqpxsmLItk5mMENrVPx/blcoK5
	U/V6zBjEWimTMOQ+BisNPa+yVRUclshOYRx+LpobFaYnWzwoHLtKsms+herfd4cgeaKFrNXTuGq
	iAnXtGI5Y1FfdqvgVmBlRv6zsFWnJ/4mmkJK60Xpw/HT/TlKIYNzy2itWsQ2j7Ci+1Yzbcbdpy3
	YGtJ4j9cfcmEkGxw8m5O7rrTADfv15U=
X-Google-Smtp-Source: AGHT+IHjcf8oSAcEYJN1JfuSZ5+Swd9rZLKRM/zNZbRrgsqHAt9wXsii/lA7sxQ5BQAtiyPMaoMJVw==
X-Received: by 2002:a05:6e02:1a09:b0:3d8:1a41:69a9 with SMTP id e9e14a558f8ab-3da7e1efac6mr45064535ab.12.1746799333636;
        Fri, 09 May 2025 07:02:13 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3da7e113335sm5768685ab.31.2025.05.09.07.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 07:02:13 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f466400e20c3f536191bfd559b1f3cd2a2ab5a1e.1746788579.git.asml.silence@gmail.com>
References: <f466400e20c3f536191bfd559b1f3cd2a2ab5a1e.1746788579.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/net: move CONFIG_NET guards to Makefile
Message-Id: <174679933288.96108.18092636887725360405.b4-ty@kernel.dk>
Date: Fri, 09 May 2025 08:02:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 09 May 2025 12:03:28 +0100, Pavel Begunkov wrote:
> Instruct Makefile to never try to compile net.c without CONFIG_NET and
> kill ifdefs in the file.
> 
> 

Applied, thanks!

[1/1] io_uring/net: move CONFIG_NET guards to Makefile
      commit: 28b8cd864da516ea87162015e490b1dea444888f

Best regards,
-- 
Jens Axboe




