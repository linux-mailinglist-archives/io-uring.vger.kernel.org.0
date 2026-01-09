Return-Path: <io-uring+bounces-11571-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ED44D0BF76
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 19:54:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1829D30086D7
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 18:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DAA32DC34B;
	Fri,  9 Jan 2026 18:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2Kwa6LLH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEAE2DB7A3
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 18:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767984723; cv=none; b=oum9QzsT493HoqZbPPXZg1u2WYy85B+TgIF9hn4Pil2wprDGhhMwz0HnJcKJZXv6G953v08x2ANAWD0gJWt7RnVdaSseUJJqCnSnsgPXfqzmPQBxiQMJjpGAigJkAd1HAkFCMDkE2nSOkhVooJqLrjz9p2LAY+sgxHsoaUMWYyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767984723; c=relaxed/simple;
	bh=YRzpQi5UErSOMVvYP6R3M5UWFcVjzaUrbN/0LfZ3rak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=topKvPRpPWqqZE7PVnPh6NX12r8zQaLgjxrs5/2/muGAnF02lGDG3romFFaBN139z9pwUyWknt5ODCsOglqSR0CdQBivILr5jmp8yYaMHLpdn530Bq+xqlDRGO5p0WuMjCrHHWlcBM1cEigRskbhIYTG4mSTZS1iinSDmK4Q9dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2Kwa6LLH; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-455ddb90934so1508998b6e.0
        for <io-uring@vger.kernel.org>; Fri, 09 Jan 2026 10:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767984718; x=1768589518; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X6OAi4NSQfJKvgwAn0ieX2ZeN8/8JAZY3eRAr8mnCpM=;
        b=2Kwa6LLH4RTgWqK/NQFu/WHFypHJDpPFiRrZPKnThwOE6FDv1KRTDyx8o1p6TXtRUX
         4+bb9gwLl2QMXqKmbf4fTlU870W1mDF5pFYWlnjDPohwBPaX61x15gqiItNIy4XH6/Dm
         NzRfLksnGxKZHzKWLXQgC7dLLUetE9vf9Zs0/IBha7hVJTMpzKvm0Hc39IquqjGdAx3r
         cgZg6Kfym9sBTsQl4qESj8tkhb89zNrOpWxKdbWWpvYkh6ldNIA4NJe5+FBw927mJ14b
         84A7vm2vUgLvjTGQ0Qt9vp0umxSxkoWNnCINrhOKAe59NGBRUw4Ppp57v/oRntrYDEOd
         7fYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767984718; x=1768589518;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X6OAi4NSQfJKvgwAn0ieX2ZeN8/8JAZY3eRAr8mnCpM=;
        b=HWIo3Gvu37ucU9StilxvOlFxK2ffHVejPMlHovxqSFHHZ8oaPIOrpWaUmplAkSBhwB
         5wWKsoBkBZXxPp9dV2KWJ0xwKrzYPS/Mcfxm92v2+Nr1LlLv1aV6EZXtU9miM5a7oiAy
         ve1ElnBDNoE9m/tsMGq4VDQn16o/KRtgDHGZOQLWdxJVBRoB/qq09oWq6g5lg8gqjRos
         4vLpcEpkg8MotWMl1IzXgSWX4UKsVwe6ldLQQ5/en5y6QRpvqdIJDC5mDrxwuhe7UlvO
         742aNXBch87Q8iy20dldbhpYFJXfTOvp2MEOPWTdc0QQtZMsdq65BA1+c0ki2j9uzTzC
         HYGA==
X-Gm-Message-State: AOJu0YyV2IEAvuEjHNdMpwBjmmE0DR/Pu4H1kHmzxqUKBVp8IaSYYeUt
	UrPiuxbLajocEUQWOx7P/J2NbTPxLDqIXwhd23rwtY9dEBOzt4bilTXbYJbYFnLvkzF2xJSYyRj
	2Ie5K
X-Gm-Gg: AY/fxX6mSsn2iryNOGq20nxI0eahJPbtRY/dTz+IdaQMKiu1ebTmffBkH/yvR3bNG+t
	JLn7ufABR4nDS0Mc+OaY61YYduHFLZu8URI6xzJfecpdF2M+/WJMfeOTA7dfzNOTvY4WyYEHqwf
	TiNvSm3B3lylkCpg6U2mFPBnmVjNO7bUheNrZBHeKQY9iEZCi0jxC6oNeGOd4UszyA9guJxwsqu
	pSEtCWGH+M3KRbJVEIoi529sb6i3yIIOFLDTMoG6yY5NfFNOBw8mn1NEHgar1MshCcvppsD2rT/
	QPZqVSOarvaxJWnw+lE0K5iGXR/caKfVVRA1+cVVSP6jgtEGyueWhGALpABd6dOJMqGSsu/vTeo
	eseVkh1ct8rV1XLUn4cpzEeK4ShjmXzwqyLe2S9HijYcIYAwFgMQF9uLp+B565BZOwvD1Mt+E8+
	a9ns1z
X-Google-Smtp-Source: AGHT+IEbhPhzwexMuBjzlGpOYUvrtI6nScf18j6QzTBu9JymsxNFPxJ865ReULhEPCBAQMG0t73GUQ==
X-Received: by 2002:a05:6808:150c:b0:43f:64bc:8b7e with SMTP id 5614622812f47-45a6bd8812amr5824861b6e.15.1767984718296;
        Fri, 09 Jan 2026 10:51:58 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e288bc7sm5371868b6e.12.2026.01.09.10.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 10:51:57 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: krisman@suse.de
Subject: [PATCHSET RFC v2 0/3] Per-task io_uring opcode restrictions
Date: Fri,  9 Jan 2026 11:48:24 -0700
Message-ID: <20260109185155.88150-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

For details on this patchset, see the v1 posting here:

https://lore.kernel.org/io-uring/20260108202944.288490-1-axboe@kernel.dk/

This code can also be found here:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=io_uring-task-restrictions

and a corresponding liburing branch here:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/liburing.git/log/?h=task-restrictions

with basic support and test cases.

 include/linux/io_uring.h       |   2 +-
 include/linux/io_uring_types.h |   2 +
 include/linux/sched.h          |   1 +
 include/uapi/linux/io_uring.h  |  18 ++++++
 io_uring/io_uring.c            |  10 +++
 io_uring/register.c            | 110 ++++++++++++++++++++++++++++++---
 io_uring/tctx.c                |  25 +++++---
 kernel/fork.c                  |   4 ++
 8 files changed, 153 insertions(+), 19 deletions(-)

Changes since v1
- Remove IORING_REG_RESTRICTIONS_INHERIT flag, restrictions are
  inherited across fork by default now.
- Allow original creator of a restriction set to unregister it as well.
- Add IORING_REG_RESTRICTIONS_MASK flag, which allows anyone to further
  restrict the currently assigned restriction set.
- Ensure failure operations restore old set.
- Add more test cases on the liburing side.

-- 
Jens Axboe


