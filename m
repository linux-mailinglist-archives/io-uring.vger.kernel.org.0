Return-Path: <io-uring+bounces-8708-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FF06B08078
	for <lists+io-uring@lfdr.de>; Thu, 17 Jul 2025 00:24:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 462493B388C
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 22:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5466C1F2BAD;
	Wed, 16 Jul 2025 22:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eL+mTdOS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E34B660
	for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 22:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752704642; cv=none; b=eG4O4iBbSe4ybZr77adz+b52IOMmhsGTLUeSPKuVLe69Oe+w5Ud+SfPGenlyOd3J3ndiwEC97ETOI6dWv+wQFHuHhk7G4ZUyZRu9jP5xyAWjcvy1NqPgHRThBGSr/G0G5n+8C0dNBmsUlP3PhnAlFN+CcEyotUXLJF+8KhjgOR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752704642; c=relaxed/simple;
	bh=seZdRAYTBmxNuMl50LDsc/CH2c2IaYrAmXI7Fepx6xI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YY+1Ytsx3KK0NiFODqtfgK1ep+gbKiTGiPDxcKwrHednh9tYhjQEhmUdg50dBo+5jONUhjGDYhFg00kuaPlBS34dggxFRVT88UxhYOgfgqbBKLjKnjVW2L7beeVJFIOfBFAgJCokgZVpBT7sqa5M3pa6A1xCeQLH7YssvbpVlzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eL+mTdOS; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3e281f82060so2843535ab.2
        for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 15:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752704636; x=1753309436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9rwIFgiiYdhwB2kvdGvafwg5PEM6edVv1Ly76l+PpDY=;
        b=eL+mTdOSQIC1Z6I3XqFbafba2jteoMQFBSOvyIlB74VtCwf5RygVqV+RgZBWxbhnia
         N+1PmIXTnfkF6tzMj/X5HeEju7Dg4SmN4U1oKnLVtmH5+fX99DxgSYo4JPNwPbbFW8My
         icx7kFa8CUjITo1YhtTxDL80LGn9g0zreboYJS6efREePozXMGw78SsAvQqnjs8wOk22
         keBPp/+zi5YU9dG3F7E7czcZP6rSwt7TBgxJ12sIcqjtjCjRgVdqx55d6TTyDuOwxs/v
         16ogJY93tueTbRxvA6JwDevJod4kAwvA6DBKzsaJWuurMO3C+Es8lDnYnKecabJ9QNaW
         Zytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752704636; x=1753309436;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9rwIFgiiYdhwB2kvdGvafwg5PEM6edVv1Ly76l+PpDY=;
        b=jaWCA4F44ZHbsVnw1mTHspfIBv99jUtZDoonoVOBTGqMnwm4SqAvJF+jVGWDESC0wE
         xqd95OVGX898u4AMC6DoyV2ma9R9xnwU2PDW6yyqhALfTD2+ztISEESlXIwFgpYJZHF6
         16a8AFJj7MVeUihg6PtSBp+awQXZBcE6U9FDdlx8rpj+yx1CksWphajIcDDYSy7l0tYo
         FJNJ1OVWWqoUyIJJqJO2yeB+eUvHt+2IFS/JYj33Kv/6bsQK3cFXmMgtvbUVDwfcxq5E
         VLHGeeBVgiGKESUfr9aDl51JeN/Ze6r03YXGH4hptyObdnbMQFg7Yd12A6wYnefHvOKM
         yZcA==
X-Gm-Message-State: AOJu0Yw6cyGlk/bMAa3uu7zo7zUq5q2AG/G+Gf8NH2cCqj9LmFnI/4tT
	OVAFNTljZANkZMEpAeSrOX6xoSkcNzfn8a0D0JB9HF1bm0ocSc4hBwXjp7voBEnuLl35psiG+ft
	l/4xD
X-Gm-Gg: ASbGncvJcY7cVwWxZqdsPFjH2qBp7uPf5SeMImHHmg1+ER8FYyy4M5ZyfUazd7cal8K
	51y3cfybUJnfmfruw2WamnqBdVyFmX3uJAgcH6L3/HZpAPLv0PF2cF2V32mzmbZ9/StS/tfSl+l
	ULaQO6+PNdgL71r/bbCmFlZMOnLBTJMUc10gU8kwMS9lX45Juo9nSI6zF2FXOHtr3a+TLkEAC7E
	8LeAwPIRv+BYonQfPIFabAgsAmhJ3sMY1uN/59XHMIylTA4l8kuGiUAYwDP1j4V4FtPWGiTH3Yu
	aUtPUA1RgLL6tCfAQ5edtlH0FvNr3CMp7RWp/Tb9FV5/FSmHwsa6E7FQOypdFWakBh5Ip1Arswf
	eH7kGQbt48ROemw==
X-Google-Smtp-Source: AGHT+IHUeah28/kLYeMwxibutCqGoHPb7wVVdj6ijHuMypWsjOBWBIdzgJDB2V8QEPUZCPQWchbwow==
X-Received: by 2002:a05:6e02:3113:b0:3dd:b808:be68 with SMTP id e9e14a558f8ab-3e282474739mr48840305ab.16.1752704636561;
        Wed, 16 Jul 2025 15:23:56 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50556b0fc3bsm3252971173.127.2025.07.16.15.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 15:23:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: dw@davidwei.uk
In-Reply-To: <cover.1752699568.git.asml.silence@gmail.com>
References: <cover.1752699568.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/2] account zcrx area pinned memory
Message-Id: <175270463567.350203.14212720423307361681.b4-ty@kernel.dk>
Date: Wed, 16 Jul 2025 16:23:55 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Wed, 16 Jul 2025 22:04:07 +0100, Pavel Begunkov wrote:
> Honour RLIMIT_MEMLOCK while pinning zcrx areas.
> 
> Pavel Begunkov (2):
>   io_uring: export io_[un]account_mem
>   io_uring/zcrx: account area memory
> 
> io_uring/rsrc.c |  4 ++--
>  io_uring/rsrc.h |  2 ++
>  io_uring/zcrx.c | 27 +++++++++++++++++++++++++++
>  io_uring/zcrx.h |  1 +
>  4 files changed, 32 insertions(+), 2 deletions(-)
> 
> [...]

Applied, thanks!

[1/2] io_uring: export io_[un]account_mem
      commit: 11fbada7184f9e19bcdfa2f6b15828a78b8897a6
[2/2] io_uring/zcrx: account area memory
      commit: 262ab205180d2ba3ab6110899a4dbe439c51dfaa

Best regards,
-- 
Jens Axboe




