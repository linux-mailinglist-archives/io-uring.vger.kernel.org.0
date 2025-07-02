Return-Path: <io-uring+bounces-8594-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04B58AF6621
	for <lists+io-uring@lfdr.de>; Thu,  3 Jul 2025 01:19:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89F603B401D
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 23:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ECD9242D64;
	Wed,  2 Jul 2025 23:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3Rg8gRyi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E29F238150
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 23:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751498353; cv=none; b=OwTz+HIb+oS27dOH3i2DTQoePPrfa/lkn6Kf8Z9MMZqK+J9LUQj8DYZolhjLv/+bFfLL3RoDviyV6lzgrWNBY2yUSIErfF6bdLuaAX09Owb+d4vyNzuRm/KEdV0j0Nthnqp20/Uaidj7uueSiTKzJwotALsMrxhixlC2S1kCo6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751498353; c=relaxed/simple;
	bh=UMFScJeOc6qsluI+E/E6pD8WSw4nf88dqWqk7UUMBrs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XweIKdrRwfG8o302xoqXEWFmLSz7xX2KgTKaN72eGJGtCTXUeMq30fxIMu0FYdVE3xRZX9HweAlGaGCTB6ntrT4WC/zdO6wDHME5O6NuCWcwtTw8DCWquZFFx1quYaRHoKDPQHUxh5ut8s7dMVj2K8vRDCnOLPkqCvt+dLfC7p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3Rg8gRyi; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3df2e7cdc64so60245895ab.1
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 16:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751498350; x=1752103150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BfhKYUqRIGLxlhZ7kF1P70N5Tl1tZU5yK4O2SrkXhJY=;
        b=3Rg8gRyivchd3e2UNkCMR4+hWU4Z1HhRSm3XiTH0hha49q4fGJ0t8cMl0PYtpwn2hu
         Af3WZOlQwneYujJsksiFA5lZjlsZbkY70pAOsH/S/bn27Zf9lXY9pUX7puMUpPwx4d57
         tsFHRmqSl8yPHekui7q/jrTy//GIogcLdBAM3uzUeCwXafi08cg/EjRCwtv9uhfoOris
         eljsYc/4I7KXxBMMIxGFwiepNQUObGVzKqTM21gnyJvBl5qtKM1rcbIekLquAbT/e8C6
         PrE0eC+NbsRS63SN69IcFHgQbAC5FpzJNQnqsojkmFajvQ8Z/ysrHArg01KdcKrklVdl
         rHAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751498350; x=1752103150;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BfhKYUqRIGLxlhZ7kF1P70N5Tl1tZU5yK4O2SrkXhJY=;
        b=EA8A9L0ltccNUrq8UtLAjvQB12WWMrOySRKj8NNqEJVZKQpDyXLKRuY9rMedHPI9qS
         Mom/SRJvCsPWlB3ZjI5NaFrd7xzYMFzBj/P4r+lABJT7p6Eta2zYilHHnYbMUTc17Vu4
         AckYfRUy50TkjItxB73hq6TFjQXnXHirqtRSj2aLiTqdqULmsGBbT31mmE68N4gAPtwG
         Y/GiFRvEmePSYixjb8uZKfB9ZkcBw3qfE1l42dFrEc+lQ/mnoeJjqg9u8rQ6v1ROYIHB
         pF0NzxQQjT1bTEPBCGz8e4P+CZiexWHBvU+2Re5+KghEDxh06F04L2c3/DMaFKXuEn1q
         bNIQ==
X-Gm-Message-State: AOJu0YyqUXqKGo9HzLb0fuqdDP20KnW6YiDqaJbb6oyNYvertPcdhCdK
	czO9ZvEHdsdlzHXhszc6UmZieolzGSfrVH0z+Kgoc/hU4pQ82+2GNQiLhWBifS5zmCA=
X-Gm-Gg: ASbGncuZKQQy99SYmabDMJoZ9ytCjT5cVhlwWA7iv49v5VoDJQVjNCmuhB5MSOZmNzw
	B6ylmJwnHmArD7eIdtBtYJfgHQCZrfAAcyhuEqnsTVvI+yOYqy/04eBew+irtc2g90wB/7hrCPg
	PDmrfoQf48Vvsm9Wl9MyYNNsznPpEAdCDbwyPUIkRNcSdATeSlFMU+cby+3lBetyNU8vlnNyYIj
	3lZQl7G5roSn3bjf2p7A/V1Ssez7FYOptSFNWIm8d0CKbvntZHsxO/6fdRGZZUGl93bn6BKUlS6
	8wisWG9L1Qeu3Bxi/RXvf4brBHUP4PWUrBIFhJ4COPylTEjjOm9jBg==
X-Google-Smtp-Source: AGHT+IGDBXlZaxl8oIM6dft8hUFa8ZtyX3QM/pPU5YMkBmwPlrxqF/SzbV23u/xjhjoqV57aBpgyQQ==
X-Received: by 2002:a92:ca4e:0:b0:3df:3bdc:2e49 with SMTP id e9e14a558f8ab-3e0549e5af3mr63138415ab.12.1751498350422;
        Wed, 02 Jul 2025 16:19:10 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3df4a09165dsm38313005ab.43.2025.07.02.16.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 16:19:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250619143435.3474028-1-csander@purestorage.com>
References: <20250619143435.3474028-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/rsrc: skip atomic refcount for uncloned
 buffers
Message-Id: <175149834929.467027.590610605534865564.b4-ty@kernel.dk>
Date: Wed, 02 Jul 2025 17:19:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-d7477


On Thu, 19 Jun 2025 08:34:34 -0600, Caleb Sander Mateos wrote:
> io_buffer_unmap() performs an atomic decrement of the io_mapped_ubuf's
> reference count in case it has been cloned into another io_ring_ctx's
> registered buffer table. This is an expensive operation and unnecessary
> in the common case that the io_mapped_ubuf is only registered once.
> Load the reference count first and check whether it's 1. In that case,
> skip the atomic decrement and immediately free the io_mapped_ubuf.
> 
> [...]

Applied, thanks!

[1/1] io_uring/rsrc: skip atomic refcount for uncloned buffers
      commit: daa01d954b13a178c216b6a91f8451a7b83b3bf6

Best regards,
-- 
Jens Axboe




