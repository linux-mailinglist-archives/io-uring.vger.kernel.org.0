Return-Path: <io-uring+bounces-9241-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52280B30B90
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 04:08:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71E8A188F2C8
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 02:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5960233E1;
	Fri, 22 Aug 2025 01:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yBXnzYec"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B231B0437
	for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 01:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755827966; cv=none; b=o0DCafBqt6Zkp4KBqW8+X9yF/hQ3BtyjSTv+vC8o/afZ+F1J3FtHeYRQ2oTczX/MK/nUAHvvz2+BvZZM/qZJXflvuxN0lBbDv0M43KS+2HDFKqSjP6P2Ce74uc43F8TyhZiPl/ot0g1NqfdlU51NKgKXPFg2GRPOTzBGU1dYrnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755827966; c=relaxed/simple;
	bh=ZhJAlxN/zK2CTtWQrzyMCAXtn2zrVhFB9PSH+2r7W0g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jVCDHMcOtC4tM2ubpkQE2fdqb8cWT8e6NvCLiBCqD09KRuliXWbyeJlNm8m4LOQ4KdipOJajOWfVKSqMbVDcsLXrEPbfVFlSZJ2m8CLc3Wukdt1QdqU7TkVRKS8FjV9AtLnlbVLsIOiNhkg8murgY48O5JFet+MFQDoA6A0W1Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yBXnzYec; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b47173749dbso1133130a12.1
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 18:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755827962; x=1756432762; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W3ExG9+05vu/oFJsYb9+SXD6pfJ3edq8ts3LpfwXibE=;
        b=yBXnzYecCbsD9qVbl0JT8IPbMCYMTRpya8MkujPnWWUgoLwWJxj2Nx/zmcNoJnXZ39
         GDSD61GNPU7CnPIqZYeVsOR3d720nLObZPlYMuVRlNJ/xGBti4dEbi7xAe4t+SFn+CCI
         cPE+5P6ZDIdooV8pZ9O0/027GejGDOMxeOOQz6ynQ9FtYCT5RPjMvprEWfxUFvLyRaTw
         wb2zxdP7j5eD6XUvBK735nnRmf6QqSqSF1BPhaGqCDmyc09m6Ui805mr7S/Ef8kB35zS
         WBk7ihLFRafdaSVcvP9p9XswPxTjEffxETNhtH9lux04bjAHwB5RIyMlwD78cUaz2hC3
         o9/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755827962; x=1756432762;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W3ExG9+05vu/oFJsYb9+SXD6pfJ3edq8ts3LpfwXibE=;
        b=KbmHK3xJg4A7jN44lh8xvb9ke9SYcYx4XLTRWbynfCWOOFxMjMCuYP+VtKpSvd2QrT
         AqUfdAMPHpYXBCkLV/QqASOm/RGlQrnIzp3thWnbTZCWzJmkqIONPHxeakhzyZZelBj3
         D4A8m6Uyteg7P4Ral+Rj0PG1tn3P2xlhCDMLpe18i1C3vS66BbAUIKdnYO6tUmBnhyNv
         4wMO7Q/4uFVcVQFB3KfBng6KHQ07XJ1p4eRRooMaVPt8z7qUAwGcNI0TEX1ZOEYoDgZQ
         z13ogSZa+wTi/Jps8fg/EvhCVsSDTxRmaEUqWsrQUjrjtJCwZ3jUp/z9sin2VHsHzThj
         qZFQ==
X-Gm-Message-State: AOJu0YydXJzqE7fFCwVk28DPNz9sQWxz+V7LqPj10X/Lwh9xl0+0nKKL
	Pw8fM5jtp79piNIfCm2prz5P0K31LoXaBv71LHLOq88naRrw5QLSiHjlxEakBbM6AbEBLLYQHVG
	F6M6d
X-Gm-Gg: ASbGncsCQuDzYQ543bW/0wEN8wRYtZ7XaC1k5PkRufbhFvocMTYVSIAT7xSQUIDZdHZ
	23C9lNBnFdtgWC7DvGrkMy6bvkqOlAn1bmQLXBPWPLm+DSk/7s1pBFKOGvI/OqW2slzaEhNYO2i
	rnCU+xUfbzc3LFotnDKRid7MDYKg0ZPiM8xo0CPGY9ajS/SBYKFPYNQQyFwRtvAmWGhVmOtG5vg
	ex2GQgIMOa7AXnp4aTwY7gghQ4sS0pKEqhE0Irh6k+p8CgaUxHNmoWEoN6d3mHgDj435aHY2+kS
	sdy5sx0u8aCr76NiF4YdlEFOOkX8y7hTQWwSFATwsWm5bsTZb6eDGKQqNzSwaCaLEX0mIIm0XaJ
	yhQmWSxqX1jeYg50=
X-Google-Smtp-Source: AGHT+IFfJ758VzziKxo1LH6p348AzxFpggFcNVv3XX6Qyrvk52t3xmcSP2GFRO9m8yLtkzlCdqomIA==
X-Received: by 2002:a17:903:38cd:b0:240:3c0e:e8c3 with SMTP id d9443c01a7336-2462ef8580emr16804435ad.51.1755827962242;
        Thu, 21 Aug 2025 18:59:22 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245ed4e979csm67568145ad.103.2025.08.21.18.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 18:59:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Ming Lei <ming.lei@redhat.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20250821163308.977915-1-csander@purestorage.com>
References: <20250821163308.977915-1-csander@purestorage.com>
Subject: Re: (subset) [PATCH 0/3] IORING_URING_CMD_MULTISHOT fixups
Message-Id: <175582796116.874791.3708590590013164582.b4-ty@kernel.dk>
Date: Thu, 21 Aug 2025 19:59:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Thu, 21 Aug 2025 10:33:05 -0600, Caleb Sander Mateos wrote:
> One compile fix and a couple code simplifications for the recent series
> adding support for multishot uring_cmd buffer selection.
> 
> Caleb Sander Mateos (3):
>   io_uring/cmd: fix io_uring_mshot_cmd_post_cqe() for !CONFIG_IO_URING
>   io_uring/cmd: deduplicate uring_cmd_flags checks
>   io_uring/cmd: consolidate REQ_F_BUFFER_SELECT checks
> 
> [...]

Applied, thanks!

[2/3] io_uring/cmd: deduplicate uring_cmd_flags checks
      commit: a9a2fe50a46df5a494811dd3840ceaa652e79c9e
[3/3] io_uring/cmd: consolidate REQ_F_BUFFER_SELECT checks
      commit: ae6b528ace2fa1d0ed3daebbb39f76b9c7133861

Best regards,
-- 
Jens Axboe




