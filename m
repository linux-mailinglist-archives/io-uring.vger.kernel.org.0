Return-Path: <io-uring+bounces-2590-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FEC393DF7D
	for <lists+io-uring@lfdr.de>; Sat, 27 Jul 2024 15:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70F13281A69
	for <lists+io-uring@lfdr.de>; Sat, 27 Jul 2024 13:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0CB71459E6;
	Sat, 27 Jul 2024 13:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="o7Lu3q+6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977551459E4
	for <io-uring@vger.kernel.org>; Sat, 27 Jul 2024 13:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722085620; cv=none; b=ByGepZTZJb5FfIr7ZwWvuXiPUiewggS196hB+NORJs2bHUuIsB5h01RyBGVxeWc02XvZuoB3PnROzEsPlGuFWd2U+pTpxO45TFt/ExrmiJnMfqjv2o2ytzMuu7sx1IS3Vj/ip2tygTegxicqcko9nLhbcZINTazVA91jf9xBeO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722085620; c=relaxed/simple;
	bh=/uKl+cdRwBby/LHQ9djXzrAWbPUeYolr+25IEUKYrhk=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=f3zaSfUk/zJ5LF4bWJsjVmIsC4rNd93oPJCo2g9KZcS21vXE3Jqx+xOQDn2QYzlYopHKKWpPa/UZtoEcw1jRKtOZkxJD2YT8ZIF183co5oXK4bP/+caOuITiYFvgtpKi948Rniwz5IJbLqkidjasoqZEXp0oWEQmJrGL3MI/NJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=o7Lu3q+6; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2cb4e1dca7aso328090a91.0
        for <io-uring@vger.kernel.org>; Sat, 27 Jul 2024 06:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1722085616; x=1722690416; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i1dxHJwVebbdMYvQbmjnP1V9TQoNvZ/ScorXhT0ur2I=;
        b=o7Lu3q+6xeYsNnaNEwEGInLBnYS1qUHoJOg7o8H6KaEbeuC+PhRhRa49rXZ5AdicSw
         ocBI3Pf/muwR9YveHxy6h/nWa1VQrlPzeUaURqRKqXco3NpiFpt4OU5EJtRqUZFRK1ju
         dOfaHRChlZPtbVG6XkMFr/9y+ajP/1nV9O1SrWHZhmKCALlNW6SDEm+EdgTg8oY90Xb0
         Ik+F57bOKVHC1lb7AdFR2GHSpzw0j/Pn1+poH317JtKe7jbWnD9NA8cWGO93Z4Fei66o
         Q3mILu7tzaF3JBcNfg5BYadNkvJg1AL86qHCCCyZehGCQvP9PWsVH+udhuE8ULpkU3MP
         6P0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722085616; x=1722690416;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=i1dxHJwVebbdMYvQbmjnP1V9TQoNvZ/ScorXhT0ur2I=;
        b=XPxw7tBxvKZf8aUo9xlkoIr1i54krXe2YjxfL8g1yfQ0px6wyzdqPBNElS8OpGpJ22
         6eWeQBQlkwtbUqWUmIkyBGYgnIch1ALJpgifGt2P21JOnTqXvaOnQoKEeghfA2bNSCk4
         OQO4HpwAwqr0XZyZe/21bfF/oKhvmflk2c0yXrqnCG2joEExTG0WLuedG0HzqLYJbGeQ
         uCrEkcspx5bEi1DfrnsyzLwNPex9tUcVCeVjE9bCyF3WA40l5wPnvUw0VrFUbsEBrjaI
         6tvNHd3nMY/LkjCb/V/55Jt8myBk6kYL9z6HX4Tp/PGXVflO/V9f5WsaWEzTH96KQwO0
         F6ww==
X-Gm-Message-State: AOJu0YyES1r7NLkUIXdk2RwvOzK9KJQlZXmWi+A3FpND+I0U/QO39DAw
	dzIG6xz/aEOj2q4P22dpckV+CU6HpAEjuNAiTQ76c2EeSzmIMmE0HmcS2M/HmqqO9qBECq4PxMS
	q
X-Google-Smtp-Source: AGHT+IEqJnB313TReZU9bjIfYpfyyS/3PNDbvAGuvVdg9GFQmzif2buW4YFqFYWtu2DxdI8ied6msA==
X-Received: by 2002:a17:902:fa86:b0:1fb:1d7:5a89 with SMTP id d9443c01a7336-1fed6c5f9a7mr59456245ad.5.1722085615792;
        Sat, 27 Jul 2024 06:06:55 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7fdadb5sm50106555ad.286.2024.07.27.06.06.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Jul 2024 06:06:54 -0700 (PDT)
Message-ID: <0b085a98-80a5-43ef-9b6b-2508b4c70959@kernel.dk>
Date: Sat, 27 Jul 2024 07:06:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.11-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A few fixes that should go into the 6.11-rc1 kernel release:

- Fix a syzbot issue for the msg ring cache added in this release. No
  ill effects from this one, but it did make KMSAN unhappy (me)

- Sanitize the NAPI timeout handling, by unifying the value handling
  into all ktime_t rather than converting back and forth (Pavel)

- Fail NAPI registration for IOPOLL rings, it's not supported (Pavel)

- Fix a theoretical issue with ring polling and cancelations (Pavel)

- Various little cleanups and fixes (Pavel)

Please pull!


The following changes since commit bcc87d978b834c298bbdd9c52454c5d0a946e97e:

  io_uring: fix error pbuf checking (2024-07-20 11:04:57 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.11-20240726

for you to fetch changes up to 358169617602f6f71b31e5c9532a09b95a34b043:

  io_uring/napi: pass ktime to io_napi_adjust_timeout (2024-07-26 08:31:59 -0600)

----------------------------------------------------------------
io_uring-6.11-20240726

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/msg_ring: fix uninitialized use of target_req->flags

Pavel Begunkov (8):
      io_uring: tighten task exit cancellations
      io_uring: don't allow netpolling with SETUP_IOPOLL
      io_uring: fix io_match_task must_hold
      io_uring: simplify io_uring_cmd return
      io_uring: kill REQ_F_CANCEL_SEQ
      io_uring: align iowq and task request error handling
      io_uring/napi: use ktime in busy polling
      io_uring/napi: pass ktime to io_napi_adjust_timeout

 include/linux/io_uring_types.h |  5 +---
 io_uring/io_uring.c            | 13 ++++++---
 io_uring/io_uring.h            |  2 +-
 io_uring/msg_ring.c            |  6 ++---
 io_uring/napi.c                | 60 +++++++++++++++++++++---------------------
 io_uring/napi.h                | 10 +++----
 io_uring/timeout.c             |  2 +-
 io_uring/uring_cmd.c           |  2 +-
 8 files changed, 51 insertions(+), 49 deletions(-)

-- 
Jens Axboe


