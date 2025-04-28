Return-Path: <io-uring+bounces-7763-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86D30A9F7BE
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 19:52:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E506C16CD21
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 17:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F32A1AA1E0;
	Mon, 28 Apr 2025 17:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jJfeh0ow"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A2115B0EF
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 17:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745862719; cv=none; b=o1J8/ql5iMhgKRz2slm1WvC2WYV7cxlo7fc2LxGCicNhPN8k4JUaG9rha7/E+t5XD2QgqQZr1OfYNrlupUdc4wtS6Z5dghY83uD7VKvYH/H6reyFJVtBZrHKi19Vp2h6Kh6ETQoMLRChr8Slx0Vh9i/ZcyK1s36WW/F0icWGG80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745862719; c=relaxed/simple;
	bh=zhYH78GqNvZShdaSUHnD88uw8TtVZ1lXjMLzTmakue8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GBxbT8aZbf9u6F/K0sDWUvmAUUxBuCJTmy/BV2XC6phNqHB+PAMXGMBEjur6RKy0DUhI8sY4oXW/BXxmy79cOAouy2vRYuQPo588IP1DkpCCPG0Zuw5Dlfvzjfp5zv0bnwV2XL0NbzA2x5rUxb+KtB3w6KQocrjlGAaklOCFFn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jJfeh0ow; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3d93f4fe5baso11074385ab.2
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 10:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745862716; x=1746467516; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XK/240S4QlEpPe80sS9S4/yVGGRDnCl4/SlRcTX2Eew=;
        b=jJfeh0owhdtZKpeMXQtwkyyKRA62Ch+PDJOZmSgs3no5JcnC+yYbs/fiP//48D65Fm
         uLB45IIpeXo4cAKLS2WxdDYXAdPidBgm2KZJyciRRJCEV2l2NNDXqShgoSzQOPVv+723
         xutDAPakO3Y6dVhUyVOfhuWZH/I6MPzKhGPJPNUoTXM9XjtYQr1PCF4v6NuuoGlWYTVT
         M8DiZBYMamlR+K9hdE2/KJmPkHNl8Uy4gOXmAXd8zlABnr9phul3s52AWgVaRI3TcVpw
         YzQqVd8WxH+HuRMVUnghTEwMZcHloWMbS9WIYm/WhBQnfU8hKjvc3Z1Nx1BqQBwAqXNR
         gckg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745862716; x=1746467516;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XK/240S4QlEpPe80sS9S4/yVGGRDnCl4/SlRcTX2Eew=;
        b=G98iuOoS6bUDw0x+xYB6Q+fm4fUn1lL0hFO1XiIsts74Km81jmveDJbH9EGZdtAU1c
         xzwbVBLP+EO/UeznXbZHLOv0Kg8QcU60epgxbWS0agxRzpSjbQintEaE2vmfdrECEyRX
         FM3A7oaSd8nCb4v7+ALMZW9jt7tW1fZlULMkcauWN2Rj0OxBklFYK+qg9pCTaNjxRMCr
         ES9vnol5floq4VW5BbUSxW3zpZLGTpmSYGSjEeqmxnPjD8l05xOJTFClvv4227mfY2Ro
         X2v29wTeEmd7QTvFg40qcCB8kHKVNqWAaepArYbdb0HjSQBA2YBcJrClRd5Jv7IzwYBj
         B07A==
X-Gm-Message-State: AOJu0YxiY0FTiQqBpzHzqa3sfv56F3F6rP/pq5RUJUsMRdOxgOltLX+3
	UR4x+RTec1S8ulpm3BTkplz1Dj+lhGTw58LU/psz3sWshKgTW8gROy2BUG0NJulO2OowFDxX4KH
	X
X-Gm-Gg: ASbGncsUDyg+8+b/M4oDU6ZtRw1G2gl2dNpIaPaXFM9cqVExOi0ceBzLa+ZvMzuE5bU
	ZSreijYqZeExrtQpwJNLiXfQHgDiCDXS3J7bYfAjoDkQx3xIPUxPBfFkL2xduVAe1sM7VVjf+yO
	+0UXf1/6xC12gYtMEcWnk2Vv8mS9xeB8fYzbzsBFdqamnk/4mp+MN7EjNPcbzXVQjvC3wWLcG4T
	s9ExUkHKLWV75vqjPNN+Acxk/2+DoCrYzpzwhN37TYkjhdPCMOoJpMas4xgUHN94YkvQ+yhA3DZ
	9X6KvrueBKDr9ozQXLKRUjz+kSm3PNY=
X-Google-Smtp-Source: AGHT+IFduR7TalngXjjZvVxPJY50+bHbIh0bbizUpourVCL8dSCwzpdZBzzCTgO13foqy3+y5pqcvQ==
X-Received: by 2002:a05:6e02:170f:b0:3d3:dfb6:2203 with SMTP id e9e14a558f8ab-3d95d2ec470mr5745855ab.19.1745862716248;
        Mon, 28 Apr 2025 10:51:56 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f824b81cfcsm2351848173.90.2025.04.28.10.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 10:51:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <cover.1745843119.git.asml.silence@gmail.com>
References: <cover.1745843119.git.asml.silence@gmail.com>
Subject: Re: (subset) [PATCH RFC 0/7] tx timestamp io_uring commands
Message-Id: <174586271563.1437675.14971185974783092304.b4-ty@kernel.dk>
Date: Mon, 28 Apr 2025 11:51:55 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Mon, 28 Apr 2025 13:52:31 +0100, Pavel Begunkov wrote:
> Vadim expressed interest in having an io_uring API for tx timestamping,
> and the series implements a rough prototype to support that. It
> introduces a new socket command, which works in a multishot polling
> mode, i.e. it polls the socket and posts CQEs when a timestamp arrives.
> It reuses most of the bits on the networking side by grabbing timestamp
> skbs from the socket's error queue.
> 
> [...]

Applied, thanks!

[1/7] io_uring: delete misleading comment in io_fill_cqe_aux()
      commit: 27d2fed790ce6407e321e89aac3c8c0e28986fff
[2/7] io_uring/cmd: move net cmd into a separate file
      commit: 91db6edc573bf238c277602b2ea4b4f4688fdedc

Best regards,
-- 
Jens Axboe




