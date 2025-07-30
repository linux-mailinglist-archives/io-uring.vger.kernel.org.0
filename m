Return-Path: <io-uring+bounces-8863-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2361BB16034
	for <lists+io-uring@lfdr.de>; Wed, 30 Jul 2025 14:22:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E19E3AA6A4
	for <lists+io-uring@lfdr.de>; Wed, 30 Jul 2025 12:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF65296159;
	Wed, 30 Jul 2025 12:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="G1/flBPv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD7C295DBC
	for <io-uring@vger.kernel.org>; Wed, 30 Jul 2025 12:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753878074; cv=none; b=bF54fq0dXapq1LYVebeB5EAUoPTxRzKip31fOFHRq+P7NbTQb9Al+JeroiZ205tUDP17qSly0hlmRaS/8kgBR+9BjP2vuNDL43OKt8nyhAuUPbJ52cmHTIuma0AHBdsleFGJT58FkKzCiT9NKZAZXeNFmjbnPID2nIUxTfZB4Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753878074; c=relaxed/simple;
	bh=mdQ4T8FbSW9QYhhy16V0i6WbvU/KGsJK4xsoYhER+Hk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hbTvwks5t0JvnEQ6cXZHja+/L9mw9osLzEbJb8AGMPw5mVVvYNQqC+5nQBNQuPBMN7Urta23T+7Yfng9BvLxQ/qC1FIHGBMi2dk6gRHtf2yJX5HYr0o1aFJJrXiOKUTpZmNDiRbwuLgmkLDzLKNzJJAplnVagLm43kiyHB7oSR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=G1/flBPv; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3e3e926fdeaso8858315ab.1
        for <io-uring@vger.kernel.org>; Wed, 30 Jul 2025 05:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1753878069; x=1754482869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o5rs/NvIMRFBMw7vrKixT/bTcNuYp7ql7PwpzCtDkdU=;
        b=G1/flBPvGD9T2P0to4u6tbN2a1AFTFFTjz7oOXODvEQ69f6Kxd6OITViMqpc/fJ8dJ
         TSMYjZORNbGEKxXZg0JPVDuT58gHklt55S6Bj30mSdZ9NQ2EM6SGa9BugcGflIZd8H3O
         +XD9FXOLX2swCUwyIbMGfc5i81+J1QcID1EKtesPYSf5TXo7/m8DngbBssAAeuiZ3nQC
         J4LEjmm67Igzr5J6gshgyhMEWvDVT+RIQNatU3y8RkNLXzai/oRXSHuepUC5eGjX1dBG
         l8ekfYbCRR0cWizz9kk/zxcexz4SwWESRbXCoXi7tH/mi19eGBK96IgBb4o1jRp9wbij
         kLDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753878069; x=1754482869;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o5rs/NvIMRFBMw7vrKixT/bTcNuYp7ql7PwpzCtDkdU=;
        b=TTC3EP1yb0DZAbDbi2DOEH+ms2DEk+kl5hpfpL/SJm+vH5QeJySpjeKy6AtLS3f/lf
         LrgD5VJiFDvK0Y9b5ma1SVXSRirs2NKim7g210IwYQWQfN81QtZk1MirRaXUIVgPRAjh
         luq2dOH1Gxx1q87vky203oAtEroWvwljVx1Iz0uOoCmztcKcBAutwFIxIh5niVKwYjgl
         2zLIPc4suHHEqonzGCj62JvfS1EBaiRmBdEvYs47tWOGuZM/D5Itbi2E+v0bQS4H3CZx
         F0LWfDldR13Ofqis1PyxMNZ6PZqsrVMKyw2ak3FVawGkkjtFoNWDiiN+rhMKcj5nTz/8
         u8OQ==
X-Gm-Message-State: AOJu0YzD5IGYyuVyfR5hEBXjkD3q11m7kfaM3+ErT84NdA9FDOD5PGQ1
	vpTByEukoJtzqBo0fAZYZ8I44g3/nZR/9IW5eFFdOUIJNTNZJgw7Sw7fusjh62SQ0wg=
X-Gm-Gg: ASbGncsq7Ir0b4fmYAUmoArUAfaTcXmqdTw7SE4JojPPpTtFgBjRG3Wxt1AvT/yiVFr
	lg0C/0rw+llJZ8wAI2BH1mCqrxV0U1dD/bXFHGOmcIsokly0aeNTg95KkPKYWkZ2GN09V3VavEq
	/9rswIopo5w8qHEfpSh/JtgesvQdkRxAdr6fZ5zL4hsH3swt+a/1g4f8A+L3jk+hQ441ExivGr6
	GdRbP6pzkb/+f7Mp4N3zkC9H7UFD9dIAIkW95oPSGNYx9qyACjp5JCpGZ8YpJQJVHbAB8p0vnt4
	EBoN2MpOlwifjKLPLwyhnjt71hQj3FJunL/X1jVpjccgFi3GbGlVKKb8ZA2T4hp1XZb1wHV29hy
	OepoZF+m2dXrnlQ==
X-Google-Smtp-Source: AGHT+IFmNRwpjAJv4+8ZcpaFpMRLcddqKNQdws7j2/dS0H9URafwrK0SkzbVnUy0fISr+R4YYV9SHQ==
X-Received: by 2002:a05:6e02:2788:b0:3e3:f90f:85ca with SMTP id e9e14a558f8ab-3e3f90f9e66mr39042755ab.8.1753878069052;
        Wed, 30 Jul 2025 05:21:09 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e3f0d669d5sm11555045ab.35.2025.07.30.05.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 05:21:08 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, norman.maurer@googlemail.com
Cc: Norman Maurer <norman_maurer@apple.com>
In-Reply-To: <20250729065952.26646-1-norman_maurer@apple.com>
References: <20250729065952.26646-1-norman_maurer@apple.com>
Subject: Re: [PATCH v3] io_uring/net: Allow to do vectorized send
Message-Id: <175387806823.286703.10174957893702756372.b4-ty@kernel.dk>
Date: Wed, 30 Jul 2025 06:21:08 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Mon, 28 Jul 2025 20:59:53 -1000, norman.maurer@googlemail.com wrote:
> At the moment you have to use sendmsg for vectorized send.
> While this works it's suboptimal as it also means you need to
> allocate a struct msghdr that needs to be kept alive until a
> submission happens. We can remove this limitation by just
> allowing to use send directly.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring/net: Allow to do vectorized send
      commit: 423a72545c7b59f304781bf38050d537b6a7ed5e

Best regards,
-- 
Jens Axboe




