Return-Path: <io-uring+bounces-8308-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF389AD6086
	for <lists+io-uring@lfdr.de>; Wed, 11 Jun 2025 23:01:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F100174612
	for <lists+io-uring@lfdr.de>; Wed, 11 Jun 2025 21:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2FC119A;
	Wed, 11 Jun 2025 21:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xB1VpbDf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41FF24339D
	for <io-uring@vger.kernel.org>; Wed, 11 Jun 2025 21:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749675688; cv=none; b=Y5za/UMfKnemCYfm/1WbxE2qjyFVPVuekcEjfceav+ZpPl/froNwFPiCiBmI12/20oMoTjUvDQrCuoWPAFGiC3OjHzooKpTAbd21MO310eZPP9aqT0W8Hgh1sKtMvEVqAP6w90PNHucvflzJR8XIdgOOdXDbe8u68tYnIn6ibVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749675688; c=relaxed/simple;
	bh=rNLzMBCu7KME28gQHCLVzpwfMWTlSdKokkJMHDIYV/E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=UF1hsbkrFPIdP/SD7owr8hk/kaHW/qNcazqrCy93RY4CEI4tS+iASxoEr5ulu5fAm09zOQZP5pMzSHV2e515DkBZYGRbqp2IXpJ/2hi/Q6WDMx+XYEetKc9G52xyQRO4wA66nPvNfzMZnV1XX2airvdvlTm7oQ4MJyNIdZMDkjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xB1VpbDf; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-8731c4ba046so22372439f.3
        for <io-uring@vger.kernel.org>; Wed, 11 Jun 2025 14:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749675685; x=1750280485; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nir0zDDr25veH1wBt30eRugJ6W4jIk54HPROAXW/G8A=;
        b=xB1VpbDfqMqhNpRt9AKh317s4qj0srY7wJpyVEGoO89h/SKWFma+v064bc0f+urqa3
         HKcn7pZWhklIXXeKaGeI07jg6RJEQoRD4c8rRNVh6CO6A+r43UUtBafemDqEDj7x/6ri
         sBuUoQTAsqh1TOcGJRmHcELBs4NEUv85BB4ZF/s+07OxI4ysGg3edvv/zufAGB6AeJKx
         f4CZXz+OSW9HtHbFzyp7k/y4ySvyEAjRS1oahbN1mUzr4ptGgwRotHoBpiT2hBKJdqFL
         QY+iahvWvuGK59vxkx7NQyP62ON1Qtt9D+tkVFqodKDefoLBOMea3Ow9zDxW6e0SyxcC
         t5aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749675685; x=1750280485;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nir0zDDr25veH1wBt30eRugJ6W4jIk54HPROAXW/G8A=;
        b=StdAaUOi80Og3VuqN6/sayHYM+U3aRAoQVUaH/Lkx6xKlPrN80OmPnl4QZu7gzuh7o
         SWyJ/gX8gKYPUW0KdCTPLncaDSBmLUvExSFzyNJzX2xAU7sDSz919TUmDvzO7TAFsKZk
         AuPMq8IpMNitdoO/D34PvmiFcKeSXidOy/75b67SJQijtbPwgSVbSpCXoJYx6nolkDdk
         WAD3wXiWaqRfus8Y1qUqAwlBxprN6a0F0Md+Gv3qCSsG7CMOpoRVEuKMRZwZDboN4w72
         i6Ih+dCO02q5u8ezVb4jXTl4wrrWXmuS/w0MBaXaVvhVnYneJZE73kucUSvhSFJyoo3q
         VRmA==
X-Gm-Message-State: AOJu0YxtTas/u6CE53Jo2khLx6o4gnDi+r27SdhJguVdnT5b8RYeKZ5c
	6bGu6BJMzRUVZ7HU8JZyzDDcGWj7INkP2gQZHjJa+JZt46HLkGqQVCsJYZtaoKb6Gvc=
X-Gm-Gg: ASbGncvB/sYRh5kOIWbwUd6zBljxyPsfq9riOtco0CT17cb07d4ErU1AokZzlC5fMV7
	Pw80hGOSLOn0zzqgBKo2GdXoIZmV6OZXCbsFUY/m1tSPyw5yRf6/UYlDs/YrJgdQPpxGpfUNy5W
	rT076mcjWVtx7stPZ8x2sIariei9sy+t2ZMKxvTJUx4f0yEYoQzK4hY1ptHbQR0f1Dj99IrMD10
	pgsC5H8ZndSbHZo97iz+oDjUa2rs1cegUPE0xr2rY4mJhqaiKxvEoeAnFeQTxinSqPubGDKNO7l
	r+8QkK4B9hqSg7FD+nVCKsoCQUPZalW/+VzjdEKmk7DoiSKyS45hTb+r/iE8wkG8
X-Google-Smtp-Source: AGHT+IEiKiCvb1MT4Ze+CdwaNhQnetWkZ1jA6JNfZR+DWNwKfUnfUK1W/Pp5/R2RzS/toZnphkM3kg==
X-Received: by 2002:a05:6602:1415:b0:85b:3f06:1fd4 with SMTP id ca18e2360f4ac-875c7d9ce03mr34139839f.9.1749675684724;
        Wed, 11 Jun 2025 14:01:24 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-875c7d8a061sm3437239f.6.2025.06.11.14.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jun 2025 14:01:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Keith Busch <kbusch@meta.com>
Cc: superman.xpt@gmail.com, Keith Busch <kbusch@kernel.org>
In-Reply-To: <20250611205343.1821117-1-kbusch@meta.com>
References: <20250611205343.1821117-1-kbusch@meta.com>
Subject: Re: [PATCHv2] io_uring: consistently use rcu semantics with sqpoll
 thread
Message-Id: <174967568374.462788.11409454167475921556.b4-ty@kernel.dk>
Date: Wed, 11 Jun 2025 15:01:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Wed, 11 Jun 2025 13:53:43 -0700, Keith Busch wrote:
> The sqpoll thread is dereferenced with rcu read protection in one place,
> so it needs to be annotated as an __rcu type, and should consistently
> use rcu helpers for access and assignment to make sparse happy.
> 
> Since most of the accesses occur under the sqd->lock, we can use
> rcu_dereference_protected() without declaring an rcu read section.
> Provide a simple helper to get the thread from a locked context.
> 
> [...]

Applied, thanks!

[1/1] io_uring: consistently use rcu semantics with sqpoll thread
      commit: 89f607e88c9f885187a0144d0b540fb257b912ea

Best regards,
-- 
Jens Axboe




