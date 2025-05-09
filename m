Return-Path: <io-uring+bounces-7936-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFC27AB16D8
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 16:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7DBCA236CF
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 14:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89B622AC17;
	Fri,  9 May 2025 14:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tczUil9r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0022F28F536
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 14:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746799339; cv=none; b=qRQPjQNdlmgwsINtysGkPM2/1VlVIGvGdHEyuPcIwBV9XPquhkavM1Dfpx6dDLRDd7ERCmRnktVK6bxqClg4rzUW/WCJtgyIIex5f2Tv78FMzrkgvXkLi/szf0jMrIW6fHfGRCBWKUenZYCHupWkT7whuJFiIomRGaBNzgSRcjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746799339; c=relaxed/simple;
	bh=XJBN+gZq4YCvoi636c59AR6bxhWhg1dYhhUMZ+0mH5k=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pGzPCMBQqeCo49mBG/k8lOZzK426iO/OOMNZW8CDwbFgW4gcJRCLv0fmVK7e5L2zcjJgAEfMObmeUozS8H1sKHhu6y0lKa7TnKU34O3AvnB8PgTQX8RiLgDQ+ORW65rgFu6j4NZwYdwq/8btpcbDfJQH0CAdRoX27bYAW9BFeaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tczUil9r; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3da73e9cf17so19432535ab.2
        for <io-uring@vger.kernel.org>; Fri, 09 May 2025 07:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746799337; x=1747404137; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kt15YDnhY9zooXmPl3xYs2bbTM8s30KnoeLIITcWsvY=;
        b=tczUil9rqMt6Pi5uAWcgfxf4IpOASQbzJ1G92qO0/n+WK2OaQXoHXuYvGypx0bjBLu
         FgK5Rg/XL5TpmDkqWBAKSBe5im1xpQHHY9dbeNyNaxxs7cNqU4i63IjlQsx7SCY1oOGn
         HIr4rJtRkjpp0ECx1cR2k0DJb1W2l+lZYZZqSHtv2D9xhFCO7lOuzh7wd0ZtNp0xdJzH
         +soVp0a8QHBop3VYdBs7SefOPeZvfmiXutj++9G+pA9Go9ptcNREyWqB8/qJJ+BqqYeT
         Xm+C/0ieJt5W7GAmPAZbGvtFG2kxbs1lgQfvwAaWKAJA2SUHFhy2Zn235Gq9Mom/M6uX
         hMmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746799337; x=1747404137;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kt15YDnhY9zooXmPl3xYs2bbTM8s30KnoeLIITcWsvY=;
        b=rFvZuuWn+455ZVsLRMSO6vyKsop8BWNmBdGpa61yqNH5H3stjkWEIKuFxoNQPAoFow
         g0ZOrbjVMJ7sWZ38F+u+S5kEBxHsejszka9bL8U7L+zeQmj39hQK8K+EQCIVMy+Ei2zT
         Gp+AqibiLTfNFJur0bGVm8aoCBUuAtsStYQvKA+X40osNuCqIOp6V7e14VkV8qz/s0Fu
         bZWgianxJNgGi2TAi/sonbCC/zNU8tV7qaB1bqflowcZF0MtVaLBq7vKWEW7yGWspb3A
         U6yRhYRBBrsYY2SGZYRaLw6AxeyM2DQg9cRRYZR6ch4tshsku6JilJctXh39YTxQ3Irp
         8ooQ==
X-Gm-Message-State: AOJu0Yzsc0NTtuaVvnUFunaeH+7EkqRMq1eoGAIzOPLMaXTtwld6VFa/
	ZqAWTvsZkHV74gh4k9GZ7iYyU4yEHaCIkzGkeaTBO9w6zjbe5Lbt4f30sYo77KgAWZ4GeB/cIn/
	D
X-Gm-Gg: ASbGncu5ly8mlmiOFSMffTm7jTGDT1o2WIOSG1XSz2tcfdAeGxn6gnSrl4hiebpY6JF
	U1rb8jNLpx8piC209nEMAyBtaOixeX4xq8VIC/z1zg/BVE+a44RJGYkL0fXCer0ky2fSR0JnEL/
	mKeNFqVMClULkLKPh9C0XEKySGe2tcwVP+wbU2aAc54vhWjSybxWmvL7XRtWCKYKed5+1nOAdit
	aqaCUintikw1bkA77PGyBcL85///BJPqTOAoVX9W+yMWvwvBp18Cs8n081fFoWIpUulAbzia85W
	RwVt9CmCgN7uncsG7ummX7gXckCnLkI=
X-Google-Smtp-Source: AGHT+IE7mzNkdPX5ref9u9fLrsgnsaKVl0z3sfSrIIerbwDRkaz3VMjU/rn4lTGqt6FAt3J+EdAr9Q==
X-Received: by 2002:a05:6e02:3e90:b0:3d9:2fbe:2bb1 with SMTP id e9e14a558f8ab-3da7e1f1d23mr45750735ab.12.1746799335204;
        Fri, 09 May 2025 07:02:15 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3da7e113335sm5768685ab.31.2025.05.09.07.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 07:02:13 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c010eab7b94a187c00a9d46d8b67bf7fcad18af4.1746788592.git.asml.silence@gmail.com>
References: <c010eab7b94a187c00a9d46d8b67bf7fcad18af4.1746788592.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: add lockdep asserts to io_add_aux_cqe
Message-Id: <174679933371.96108.5685752215446502237.b4-ty@kernel.dk>
Date: Fri, 09 May 2025 08:02:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 09 May 2025 12:03:43 +0100, Pavel Begunkov wrote:
> io_add_aux_cqe() can only be called for rings with uring_lock protected
> completion queues, add a couple of assertions in regards to that.
> 
> 

Applied, thanks!

[1/1] io_uring: add lockdep asserts to io_add_aux_cqe
      commit: 81a22c86ec7060be43404d4e6d68fca03dbafcf4

Best regards,
-- 
Jens Axboe




