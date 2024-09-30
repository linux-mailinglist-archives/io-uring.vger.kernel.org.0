Return-Path: <io-uring+bounces-3323-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D2B98A6FD
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 16:28:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 486E61F2359F
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 14:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25F981917F3;
	Mon, 30 Sep 2024 14:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YrP6mLIm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0968A18EFEB
	for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 14:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727706518; cv=none; b=iO8tc8Oiv8zr027y6iHNWOZUOgJgp5/kMFedzouk1cANK+++O7Ur/lrov7v4/onN8wviezvAqGPSSmvlwfbnEtSQ+wSfNRTSm1WoF9q0GGFnC+/zEzn7obBlgUy+JQemseuyqkwCL36pygOq66Uv8tbxabTFVp4c4jtT7VPZd1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727706518; c=relaxed/simple;
	bh=WRmrYJmJ8yY2e/aMh/4xVC33j3QfQjgVbE+b9JKSE9s=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=A25P2mjwNU2GO9qzGIk5wJCRUoNkl13OWFJGLcf0/0oGkLwD2fSqIxHMGv+Mizq/Bc9gXhD3vnbojsP42+nrwbnWCHyFiDx0hDtHpOPp8UPqxpV7m+3y+tsoNGMBTpgfnXjGswIc6Kty5hTG25xchPVkD9STV/4FjeADBchHKic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YrP6mLIm; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-82ab349320fso181592139f.1
        for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 07:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727706513; x=1728311313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lmyRMSx05FC5TcMXSNeqHYcIG7S+8TzgNzmH7id7ECs=;
        b=YrP6mLImeA+ffRQyjZSBmy0aHJVUiWTqtBGk4E+1R4QdMl+GWqZjXpms+/1iaV82HS
         r24ssqbEQoKP1fyjFC0TLu/Gh6/JxjCFTr13P1lrz8C0DnM02Ge+1xU6C1p4NN5iJZpi
         8S6nEC3o9s4s1DzQ4zg9ZYlKIlXOkkPLQORIA+Sh0SbVZPbVapGUHNJS+AA6k1rcV3Ql
         ySevUm8P3A1bufsN5Dw8Pr2eZMgiufN8C3nhTlPKAXs4KnkOj6fKO+gvxMwOw84Jyd0O
         hngRe3ZoK/fCSSPLjOpLEhz5GCyeC+uo5QrAWihbMWiSKyKgINkbS1ppvaapPzE2no2q
         RlyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727706513; x=1728311313;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lmyRMSx05FC5TcMXSNeqHYcIG7S+8TzgNzmH7id7ECs=;
        b=E/r0rCl73cpGuli3tp2vqILUOM97cPrBWCkiwUUYISKGcFdYyEwCTe+2XfwDAvd5dp
         G/brEgXKd9YzlADDDXAIFeuCxkQzgR/XLUWmwBIMyqmG33qgH+ZZxfv+utc6t40Km0GG
         g5B5RZ0UfloXZ3reA78SwuDDOQiHn3AkUmMxKIhcpkjJ+Uv3EY47uAnDvqBJJ1bvfjwU
         bVuaeNTXHQJYmKX8Z5kLWnc1PLysUqpErvkjE0tsGcLRYzsprxUHjRSO/WOIETTiVVs6
         5G4G1wU4l4bcJmN2Q/1tfUAvki9JOjPA5QnHR9KzQsaCoyqDDhDlxf2R8lJnR2hxCYel
         WsjA==
X-Gm-Message-State: AOJu0YwsOgEhQlAdI0P6FHpYTowfucbFCJPXNfnYUYUuIervBW/lS8Rd
	spt7Eojykg1ly3mq6YNOcEjsBoYmsRYf+TOHxkEIV7OZHrNMF5ONkeWvitMIecBMMyne+OpDa4R
	mkLw=
X-Google-Smtp-Source: AGHT+IHuacDA8P0SQ2lPHoi/n49C5A1GGPdWcwL5/a+IKBtxpmF4xmJ1Do8sOOcpHvyR97ovlRcs9g==
X-Received: by 2002:a05:6602:2b04:b0:82d:96a:84f4 with SMTP id ca18e2360f4ac-8349318d38amr1232700139f.1.1727706512999;
        Mon, 30 Sep 2024 07:28:32 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d8888d9dc3sm2124611173.150.2024.09.30.07.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 07:28:32 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240921080307.185186-1-axboe@kernel.dk>
References: <20240921080307.185186-1-axboe@kernel.dk>
Subject: Re: [PATCHSET next 0/6] Move eventfd cq tracking into io_ev_fd
Message-Id: <172770651230.9692.6096261870125518575.b4-ty@kernel.dk>
Date: Mon, 30 Sep 2024 08:28:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2-dev-648c7


On Sat, 21 Sep 2024 01:59:46 -0600, Jens Axboe wrote:
> For some reason this ended up being a series of 6 patches, when the
> goal was really just to move evfd_last_cq_tail out of io_ring_ctx
> and into struct io_ev_fd, where it belongs. But this slowly builds to
> that goal, and the final patch does the move unceremoniously.
> 
> Patches are on top of current -git with for-6.12/io_uring pulled in.
> 
> [...]

Applied, thanks!

[1/6] io_uring/eventfd: abstract out ev_fd put helper
      commit: a2656907e0e2bd817f18ae5ba0c0bc47373031e0
[2/6] io_uring/eventfd: check for the need to async notifier earlier
      commit: e18ccce7024f18ada55e7bb714b28990e1fd3034
[3/6] io_uring/eventfd: move actual signaling part into separate helper
      commit: 0fa1e1b85857005aa7777dd3c92fa1f9324909ef
[4/6] io_uring/eventfd: move trigger check into a helper
      commit: bc9cd77386b3e5b9e7e4f2b016d0dbe4db2344bd
[5/6] io_uring/eventfd: abstract out ev_fd grab + release helpers
      commit: bb4fd7c94e41777b7980e0d06ea521311f7330be
[6/6] io_uring/eventfd: move ctx->evfd_last_cq_tail into io_ev_fd
      commit: e4355ab51156d5ca83733229fc6b3dfd7c5a4785

Best regards,
-- 
Jens Axboe




