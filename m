Return-Path: <io-uring+bounces-7462-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AE33A89FB7
	for <lists+io-uring@lfdr.de>; Tue, 15 Apr 2025 15:40:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5F79580DED
	for <lists+io-uring@lfdr.de>; Tue, 15 Apr 2025 13:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D89C01537A7;
	Tue, 15 Apr 2025 13:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2h4UztaM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD3E126C02
	for <io-uring@vger.kernel.org>; Tue, 15 Apr 2025 13:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744724338; cv=none; b=HeL2DtWpWRyFiyl63fSKooP4p3SAp4GcpSp35RIkpCzRrooZtwFoaJt230zrlCZt25mbNhRYd9mzF10P8GJUpwZPNR4F2VcHTkSRwM0YQhACLXRZyLksYqvtT6VkmYi9HrBsM9REsuCNTWVAp9gSv2efQL8Y7x/a1pXsgo2JYFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744724338; c=relaxed/simple;
	bh=7w7ImXjDmRWAep81c7LMMpjXyJRD6wI2e1OL+ERdLEA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=cu1Ol6XtVtnD7tTMmffQFk27lLJWsnWhOJ0pcZUrzPSMeTkc+5hTNykvvBldya/uhDjCnMsXZIyFFzjGXk5oqpwcef1vemMWUDFkBgfnmBMz4Kuq+4mBm3KWsyLFxb+k5hnDi5vtkpM5qZOzAhhyBsjQrzZ156L3UNJ6FaEdtPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2h4UztaM; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-85df99da233so518334639f.3
        for <io-uring@vger.kernel.org>; Tue, 15 Apr 2025 06:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744724334; x=1745329134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ESLHtk429zyVq+YJ6VRw3fV83MPMMnFDcwIjaGw62y8=;
        b=2h4UztaMGgzguc94gZJa7utLibg8NUHbsQ9cHslYXeX/RWsQI7HpEz7KdFUNEakeMQ
         dhMDGlIkM9eVa0e4XrB2xyh2fDbzP5+G7SmTfara9/FLkRWNzbpOvMCJl/mWbTH1gc1K
         tGlbOlEa5qFLEmozp6M26aD3SOLYCEAETorTfzKSvhNMn0do4zepn9Vi4nnFhR0n2/KQ
         5Kki4Mp+XKkgRvbmbK8rtWOSsnpJ/I3cRA8msg3GM9ojdVNx7F+eN62Kfb3MY/40v9ZU
         KclB0lNhch1jYZbnXbNR07qdiWST1ziHgfI5LfJwTT7uRlawBCPXws194bdUlG0xw6tE
         Um6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744724334; x=1745329134;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ESLHtk429zyVq+YJ6VRw3fV83MPMMnFDcwIjaGw62y8=;
        b=Rj2Rk733fE1eH2Opo3hKvrkgTbo+WSVEJvF92FmYfesVgOhsYF0HZobPEhbNrp19k9
         9gnmp40nUMyM+WNTw1GbtxHgUJmzTnf8dcD/t1bzqL69a2IGmYYdm1DeKIC6RiOhq+Vf
         uy50yxvWgtKgfyeHxgFcuAfD5VlWr2oT+SAkt5CVD7LAsSQ2HtrKC4PIDbiEWDfc1H0h
         v0MQ8oq0+5BTObAgtM4KX4SuN+lTgifGk2RPIBZsfKnTzB2N49ljmt44v9a2Shjmmiff
         zJmNo5f+oYf1DU6VFb6ifnidk9e0vEltyDAVmwYd5vJ13TvsCaQFuZwfZS95+NZJQgut
         /hAA==
X-Gm-Message-State: AOJu0YyrfKY8Ee2Ch7iRWge08mAQLeSKENxhBpmXUaxqRNdPzB38EuG5
	pa9AzsABmuXRPQYVXGqEihiHB1UKld35aMPXmgqdmEOjX5BsCXwEBNfHUoRRKb49KjdaSKSMzZF
	g
X-Gm-Gg: ASbGnctSgwOZynv2ckdAk2LdxFKZIuP8Ziw5tOxRj/5wz331122MjnHcnsIGYCebcnE
	+uAyKRsahhISPiu1BDbau8HEh1d8fjwaFEJpn4Fmei1WEs+rO214zr60DX334rjVr5EQQkREGGN
	YYObAIrRjH7PEXGGW9B18tRZOBgsK+4mvSJKO221P3R40NUd9O6y1QIVcHtKCk/N4Hi5A06Tnoq
	w6aZ1eTW872oTZwPxM5+VqLlCYQIjrkBaJ0MvNC1bm1FSlj3f02Shn4XyxA25oN8+lFd9wcFDJ8
	hU/ddYSYkIxU1Z7C49Z3MPM4GagObyCj
X-Google-Smtp-Source: AGHT+IFYgw7l9oZNjWjefUktnqs20/VqFU0ssI5HqCXR1A9FBb+9CQEFgkaO+DjEZY8Kt0Ii9aPPBA==
X-Received: by 2002:a05:6e02:2601:b0:3d3:fdb8:1796 with SMTP id e9e14a558f8ab-3d7ec1cb5e0mr178248425ab.2.1744724334488;
        Tue, 15 Apr 2025 06:38:54 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e2eaeesm3170439173.126.2025.04.15.06.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 06:38:53 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>
In-Reply-To: <8714667d370651962f7d1a169032e5f02682a73e.1744722517.git.asml.silence@gmail.com>
References: <8714667d370651962f7d1a169032e5f02682a73e.1744722517.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: return ifq id to the user
Message-Id: <174472433374.141496.2363721659417836988.b4-ty@kernel.dk>
Date: Tue, 15 Apr 2025 07:38:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Tue, 15 Apr 2025 14:09:45 +0100, Pavel Begunkov wrote:
> IORING_OP_RECV_ZC requests take a zcrx object id via sqe::zcrx_ifq_idx,
> which binds it to the corresponding if / queue. However, we don't return
> that id back to the user. It's fine as currently there can be only one
> zcrx and the user assumes that its id should be 0, but as we'll need
> multiple zcrx objects in the future let's explicitly pass it back on
> registration.
> 
> [...]

Applied, thanks!

[1/1] io_uring/zcrx: return ifq id to the user
      commit: 25744f849524e806a13ade17c4fb83f6888fe954

Best regards,
-- 
Jens Axboe




