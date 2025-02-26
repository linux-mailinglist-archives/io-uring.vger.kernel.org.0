Return-Path: <io-uring+bounces-6828-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F9F5A46F8A
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 00:41:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64C1416BD16
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 23:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1499F2620D4;
	Wed, 26 Feb 2025 23:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xt7YelHA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5EC2620D5
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 23:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740613261; cv=none; b=Hb55DWHL6RvdOU3+n+Atagh5hVFSWyLGaMM/NvJA3TDZpWf9pZDcroODwytADiGOPShX+jhaNh/mWJBBBsPPmdHtVPVlL4SSH323AsTdH+gCxal+eQ4wlnYJwfEjSOc7Sr8B5FO+I7GsRAZDfX6WI16wBvhd+YDTi+uCQLx0K+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740613261; c=relaxed/simple;
	bh=OcTprQYsCNncI/yHQi/j4DqvV0MHPbHGPdtZdxCPMbw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uYUEcav2NyhcOCb51yiWT15+oo1hUgB+gwqoSsyvSchQ8F4TmUCDfgybDtU/hNDlBPNANx+Nc/wNJi7xrURi0U0v24SuETQyVUm7bmjHrzdcC1kj1tLZQFvBwgwv9CZzKJ8F/G8VVggtIVCZJPr+o3J+QXhiQi6UN/EFGhzYS/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xt7YelHA; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3ce87d31480so1303235ab.2
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 15:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740613256; x=1741218056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oenO3/wjx+8AeLvGGR47yo4y3J64HhsJG1iyXd6aras=;
        b=xt7YelHAI/Q9l6PDSbUsbyFaUdICejlkeNWwI2pIilYHEUpXl3SDCbBHFzod6Od5ok
         IGSU0prgt9iG6M2E272xLrHVVVq0noWkjgwTMMJIhMSzYVtAnstkgWlpaXuxr/17C2dQ
         xig9Xju4U4/YSHr4TK6T3OOGwq7WXr8mvv5im+73ItXyTk+RJ9ZwsEKKu16cngLq2qWL
         3IbsdiS+1k4EXYHtFq/+r/0WoF9Tt7T8XQK+sYmHh3vfAYblPEq5grUtZAj/oFQBIUg8
         JfC/LV2qcm8wqLGNsrW2Z08j11xYUntI9aZPJncUMX0IZWFLjbBUBaVRIEdL+Fi7a/WH
         nXXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740613256; x=1741218056;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oenO3/wjx+8AeLvGGR47yo4y3J64HhsJG1iyXd6aras=;
        b=UfYkuTbS0mlPsxd6ggWhwJpcx88rsV/ibC0aGVYErSRps8ofgJIR2CTTykbP4jlWIS
         LVJSMhgQ9nSH4OOvC6g7ejCK9XgLm4vLtjvn194OdIXdp5A6WM04U8evc7nbEnX8S9C4
         gMBTtDO3nwuV7Mak0IXC25/URsob/lFqeMQyLiPX4SLVu1xMzSwEQkpR26K6mNRtG1MZ
         19fXtRrUtPyoWSZPSjjNxGvoISNXIBg10CE+QxXyDAncR+TL1B+3Ko6ET8320kDtSffg
         2C0BBPtGH7sCKcNS1yCxkCKuEpLdrB2Jn+xgG/sprc4PBTgHRyQMW2hG5o7J0bY3qGGD
         P/sQ==
X-Gm-Message-State: AOJu0Yz73ue70drbok01q01pQrJhnLt9hUs62vq4H8qIRdcpCUsICBdw
	s/J4l5Tl0AhFaO2pTq0y7yQNdAyys+yma+wvWE23ayyJC7jaSv60Xpwa+S4NZxLddSlrFR1SesW
	E
X-Gm-Gg: ASbGnctMz7tq/PsvE24pNsIjFOkSGzDsTcVTCnyIFmZVco8wekeyRDbAY3PVOUUOXAK
	WWHDmHGP7QGrLNqRSlCPx/XJyhSM19qQQQ8YggCOnhj8lBPIiMoYYs0GzGjS1yCkviQj2k4wsc4
	g3BwKoyVnEr7uU2NlrT17CgacbatFHCFANbuehPxgXn5geHmxxzcxBnso75h4kkTavW8BfhiFcn
	Itj4ArhHs3bCrsB63z7SSHFoYjev2NPQuGHqixN25A3TuuJ7ggiG4ekWDJJqP0bBk1t3BqiO8fF
	KL1m3qDOk/gAebyybA==
X-Google-Smtp-Source: AGHT+IH+bYYsmjjMrV6R6mg5NPiavcYNXNeSAZIJP79Mi5d/QvdgLZ11LdkgwLjM1RuMytYN+IR7Wg==
X-Received: by 2002:a05:6e02:144d:b0:3d2:b34d:a25b with SMTP id e9e14a558f8ab-3d3048a664cmr84631245ab.16.1740613256592;
        Wed, 26 Feb 2025 15:40:56 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f061fa766asm81936173.133.2025.02.26.15.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 15:40:55 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0ba2c9c8302b4d2318bd33580e6170e3bce90e86.1740602134.git.asml.silence@gmail.com>
References: <0ba2c9c8302b4d2318bd33580e6170e3bce90e86.1740602134.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] tests/rw: test iowq offload
Message-Id: <174061325533.2398306.9979027783101211859.b4-ty@kernel.dk>
Date: Wed, 26 Feb 2025 16:40:55 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Wed, 26 Feb 2025 20:37:09 +0000, Pavel Begunkov wrote:
> We miss fixed read/write + IOSQE_ASYNC tests, so add it
> 
> 

Applied, thanks!

[1/1] tests/rw: test iowq offload
      commit: e1003e496e66f9b0ae06674869795edf772d5500

Best regards,
-- 
Jens Axboe




