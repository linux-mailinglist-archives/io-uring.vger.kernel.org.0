Return-Path: <io-uring+bounces-606-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4015985693D
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 17:15:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E92351F22FD0
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 16:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5781134724;
	Thu, 15 Feb 2024 16:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="s8AwGazo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD5D13959C
	for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 16:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708013409; cv=none; b=G7Tr+A7fpteBNGaHEdREU3S225aWXzNslg1WSBt1M2hA7jaR0ta7iWgMS41UzIRi1uUKzKl+kNVgFCM1/Au+/48VHMCP+S+Bn8W6+x1fmuu4rqMTYn4XzsfoxnQAXr5jCVT2Qmq1BvAPfW1+sgFQx2LFtX68gfEUigeeSdisMf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708013409; c=relaxed/simple;
	bh=LNmpqxV0YfHJbBxdYuunJibXydwG9f0jXBrhnN46hVI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=PdDPNf0lBBdVWU+rEic5hQ4EV7b9nZx3WmaLR3gvO6gHFBej8UQKkYFmTTb6mpfpYPzYNv8Yc3/OPHWnsorCzGjWGFacm0Kex7bDNTgoAo7R5x9FwnDgKv2ytQ/DN/3tiDvSeOrRxxWN9DsHanh+V7OjnrQKgjKmf4te2khvaYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=s8AwGazo; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7c49c979b5dso8385039f.1
        for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 08:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708013404; x=1708618204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=rpijjQEzBgnLD/uY93UCJeV5MDh99Jzq/Yr+mGAGQm4=;
        b=s8AwGazowtQy+D5DoL6BwazbVwKeoFazz0Y3bmdSe0HjABLk4qjJ39unqaKXNkNw68
         aJ7jy0VyoeB5okoeyfaUkKRrQ+L1buUGqiwfIR+3gj2z1OiA2V78br5+lcyHv42EJc/Z
         7+OjPgSao6vbb1uuBkA92nyHawpfEbhp0n54xBeW1Q3umxlHEroEd0/amuE++Zb9Gf3r
         1t80CaCuurO/V6JpanDIrY3OWZmEyJ7hqN/Lw6RPHJ+jZ39PS9hcd7ituTtSSadgGcj0
         U1JkFM1kaljH886HRGTZOcC2LD/qnTxp6d4yf10uJMV9l5HScUjxhU0ueIA/7W6Pj4qU
         7ZIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708013404; x=1708618204;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rpijjQEzBgnLD/uY93UCJeV5MDh99Jzq/Yr+mGAGQm4=;
        b=O9zSAgxxtsXWMNAwyl3mgIXzlVLyZw4ocGxJKgj13ZBGVT8809mL4K2etQI0Wofvuf
         iIn9KzwZZbKlKlig+kvyt04vLJ+p57o9Yip0zzIOOnKCa3nIuGqV8f8Z9UoyyDny4iEF
         b/UD1SjgeWKdS2FYztGd3FejcUypOPiSxBu8kGislagBn73M70BX6J495g0moUJRVhzr
         rRxLx5fDyZ2v18OAJw1K+GG4QHRXBj6t+L8PmwbnnetdaTUQWR6alSnDyAXkDKgRjDwc
         kfwGIyFGQkFRZQtnlbxNtMgyguoX6FO1lI44jPYjf8LUa1KmKBYLN07QPVPYDaFZlwzO
         wf4g==
X-Gm-Message-State: AOJu0YyJaC1iHNQrhajqzNJ12Z2+zWpJfc5LlKl9cFWcyKSlv+ZMqHVt
	mvJzkE1V92pw/02deD0dm13hcshnCI8ZAJbgwbxfbZ1cDSogz6gaF0oQ8XAAAj34IzQbZ1TvRbu
	D
X-Google-Smtp-Source: AGHT+IEMX6gag3SN8iJXXG2PEk23g9jJ/oxQkXbCeksGUv1o4W8O7kSs4uk7sbb8SR92LNPDDauZ5g==
X-Received: by 2002:a05:6e02:1c84:b0:363:ac1d:ae0f with SMTP id w4-20020a056e021c8400b00363ac1dae0fmr2208699ill.2.1708013404569;
        Thu, 15 Feb 2024 08:10:04 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x4-20020a056e02074400b0036275404ab3sm458524ils.85.2024.02.15.08.10.03
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 08:10:04 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/4] Add support for batched min timeout
Date: Thu, 15 Feb 2024 09:06:55 -0700
Message-ID: <20240215161002.3044270-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Normal CQE waiting is generally either done with a timeout, or without
one. Outside of the timeout, the other key parameter is how many events
to wait for. If we ask for N events and we get that within the timeout,
then we return successfully. If we do not, then we return with -ETIME
and the application can then check how many CQEs are actually available,
if any.

This works fine, but we're increasingly using smaller timeouts in
applications for targeted batch waiting. Eg "give me N requests in T
usec". If the application has other things do do every T usec, this
works fine. But if it's an event loop that wants to process completions
to make progress, it's pointless to return after T usec if there's
nothing to do. The application can't really make T bigger reliably, as
this may be the target it has to meet at busier times of the day.

This patchset adds support for min timeout waiting, which adds a third
parameter to how waits are done. The N and T timeout remain, but we add
a min_timeout option, M. The batch is now defined by N and M. The
application can now say "give me N requests in M usec, but if none have
arrived, just sleep until T has passed". This allows for using a sane
N+M, while avoid waking and returning all the time if nothing happens.

The semantics are as follows:

- If M expires and no events are available, keep waiting until T has
  expired. This is identical to using N+T without setting M at all,
  except if an event arrives after M has expired, we return immediately.

- If M expires and events are available, return those even if it's
  less than N.

- If N events arrive before M expires, return those events. This is
  identical to T == M, and M not being set.

There's a liburing branch with test cases here:

https://git.kernel.dk/cgit/liburing/log/?h=min-wait

and the patches are on top of the current for-6.9/io_uring branch. They
can also be viewed here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-min-wait

 include/uapi/linux/io_uring.h |   3 +-
 io_uring/io_uring.c           | 156 ++++++++++++++++++++++++++++------
 io_uring/io_uring.h           |   4 +
 3 files changed, 134 insertions(+), 29 deletions(-)

Changes since v1:
- Fix issue with both min_wait and timeout, and transitioning to the long
  timeout. We'd add the current time potentially more than once, causing
  much longer waits than what was asked for. Test case has been added for
  that as well.

-- 
Jens Axboe


