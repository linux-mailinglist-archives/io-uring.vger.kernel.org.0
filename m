Return-Path: <io-uring+bounces-6565-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17AD8A3C623
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 18:26:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA7031899D5C
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 17:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166C02144D9;
	Wed, 19 Feb 2025 17:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="a8M6GXUl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078032144A9
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 17:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739985967; cv=none; b=hchxr1IHluotIzEqmBXrCHSoP0YqufaK2nOLuTX9cvSYGo+49EzN206jxwB/AXV0ONmrPFJ6sD/h9Ip7Nb6HLB/fq3EGtBD/HWa4Dz6T9DEPewBWinZhSo0v13/bn4qWb7IN8A0qNu3UsfULCuWd3h4g8rUzd56E4tn2GDwnP0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739985967; c=relaxed/simple;
	bh=Vb8puaYaf4qh6IftRFHY3ubbcPpUa3MqsZmps1cu4Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SwXOlAodBUpgLLARL5lelbCnfU77MvwWxNuiJsRqJtmIVPjjhemnJTD5OCPMTHanJYEaWn6HUR/m86HJ0CzAGslzmS3RxBujRAqqriZRY70BFiGjbBVMWmET71+a0csoMixtFKxfmzO++JPP4CU0THmlkpJw08AjK4POv5RP090=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=a8M6GXUl; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-855bd88ee2cso1683839f.0
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 09:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739985964; x=1740590764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TfPTNsgwewaMi/I6T8YKicRBwigMcUu267PkW1ACicU=;
        b=a8M6GXUlw9fVR/RFa07/tx1lCVk1yd89l+ZEANbG6ThRJISQDxKiHMRown8l0oULf6
         2aIdiR+nESKsgK78v76GynNpd5Rq9G16ulmXdnCK1bDOYloSSswokPrvHT56EPGjeb/9
         RFPq7V3oRI6yJLPyTSxrhJCbJamE021K+FOrQ9oTwFoEtAhRboo+mYCFFqERuMt+owkO
         IuEe0F1hzFDH+JyYwdSAW89/KY6D3zuf8il7t82b+abCGzxHKw4gw6asH9kC3Rks/I/l
         EqHu2UshTY8JgTuOqo1r4NMcLwEsk7dDjxuOQBQhWYfj0Z6kTZQX9lW4GvIuekk7HvHw
         /UcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739985964; x=1740590764;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TfPTNsgwewaMi/I6T8YKicRBwigMcUu267PkW1ACicU=;
        b=AEPWTzR+au8U2YwV2UqXBWFDzpPqdPidJHMwwI61EcrARahKrSmE1/OdtGZhOtETFO
         ceaVZXXjtYGAXDoh8xlxHauLnmhMIE0QG6MIvd8300oBf7vUq6+C2jRNxResqOnWiBTc
         uXZvPCCRwVZA4gf673InLuFxggw7h5tYIQW+d4kUZqbm0rUrj6Y1nSmZSTclXQiJVUZM
         YEQ8lHFyzlYxR14Re4KQflA92XbV5x5kxviFJ782f+JU0CoYv+gis1i2xxEP9EzOqo5a
         pQl67x8S2RlGGWFRS4UHR1kYu2jCopnL7yFwHby26ZqyAp4MnI/MOJd+dz3TYuKYln0U
         3AsA==
X-Gm-Message-State: AOJu0Yy+Th/QYXkUhL20aqNRMX1WpcotrGNQBAXJlA9CyYWPhSgyCVsk
	1cOPTQQ+LzuXFdouNDjjo0RJac44CEg+rg9k3z87QsPPmwazOz6tGKz/FrmVrvpkQ5JbmNfQ390
	P
X-Gm-Gg: ASbGncvmIWEURPfIwDbRV2XxQ1cBVuEPB5fLpybQl404kXkmCgeOIZt15Unac4wj0M6
	nLriepHDdhW5A63NXhEQnP2gEpzZ5rFIGL785lvgBVy5gWS0yGnwDC4sAzd8eZHZU+XbpGU+hv0
	7AUe6m8z6VJj2xaSctIcmirCx3ZfjNY047nGZ6itNpk5lgvl7hj0HPexSGUIXjTuPSra4r1GaXV
	IVhAgbCUTpUNsZuEYUYEoj/OL6cZLhz1WkeJqOUrQ9dAY8Xq1gmD20GPATixTYo23FaiX1HOn/Q
	365pYAxgUMBdoPURBPA=
X-Google-Smtp-Source: AGHT+IHRbnXFprQioxsNmDJfE4DH9qvXachSbjIeaQGOzZwDaRtaGp5GeuBmc5sm6WVdwa64MMDwWQ==
X-Received: by 2002:a05:6602:6408:b0:855:3056:6513 with SMTP id ca18e2360f4ac-8557a0a5b58mr1864661539f.2.1739985963683;
        Wed, 19 Feb 2025 09:26:03 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8558f3ccdcesm142192839f.16.2025.02.19.09.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 09:26:03 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	asml.silence@gmail.com
Subject: [PATCHSET v4 0/7] io_uring epoll wait support
Date: Wed, 19 Feb 2025 10:22:23 -0700
Message-ID: <20250219172552.1565603-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

One issue people consistently run into when converting legacy epoll
event loops with io_uring is that parts of the event loop still needs to
use epoll. And since event loops generally need to wait in one spot,
they add the io_uring fd to the epoll set and continue to use
epoll_wait(2) to wait on events. This is suboptimal on the io_uring
front as there's now an active poller on the ring, and it's suboptimal
as it doesn't give the application the batch waiting (with fine grained
timeouts) that io_uring provides.

This patchset adds support for IORING_OP_EPOLL_WAIT, which does an async
epoll_wait() operation. No sleeping or thread offload is involved, it
relies on the internal poll infrastructure that io_uring uses to drive
retries on pollable entities. With that, then the above event loops can
continue to use epoll for certain parts, but bundle it all under waiting
on the ring itself rather than add the ring fd to the epoll set.

Patches 1..2 are just prep patches, and patch 3 adds the epoll change
to allow io_uring to queue a callback, if no events are available. Patch
4 is just prep the io_uring side, and patch 5 finally adds
IORING_OP_EPOLL_WAIT support

Patches can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-epoll-wait

and are against 6.14-rc3 + already pending io_uring patches.

 fs/eventpoll.c                | 87 +++++++++++++++++++++++++----------
 include/linux/eventpoll.h     |  4 ++
 include/uapi/linux/io_uring.h |  1 +
 io_uring/Makefile             |  9 ++--
 io_uring/epoll.c              | 35 +++++++++++++-
 io_uring/epoll.h              |  2 +
 io_uring/opdef.c              | 14 ++++++
 7 files changed, 122 insertions(+), 30 deletions(-)

Since v3:
- Base on poll infrastructure rather than rolling our own, thanks to
  Pavel's suggestion.
- Rebase on top of 6.15 changes, which shifted the opcode value due
  to the addition of zc rx.

-- 
Jens Axboe


