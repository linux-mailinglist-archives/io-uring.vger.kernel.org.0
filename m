Return-Path: <io-uring+bounces-6304-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5496EA2CA4C
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 18:37:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A50F16B12C
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 17:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00E7A19DF52;
	Fri,  7 Feb 2025 17:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GdtCE5ve"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34DF199E8D
	for <io-uring@vger.kernel.org>; Fri,  7 Feb 2025 17:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738949805; cv=none; b=OC452QYRwKYBkpxlrdmdTOQNx9OEKyCRvL56Cezvrx4r5KcyP1Gu5XBegDjsR9PktAlhnxH7hkUtmd05hHI3HXh1l673NUInwuyeCDpDMv7x5YXYkujcMhsGDmaoZ45I8ddHgmENiTevwWBy8RPAX68kUW67qqhD7VvH4D1ef5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738949805; c=relaxed/simple;
	bh=jVs61PierNiTqkPVDmWFETbkY75KDTUSaQwXKjPn3YM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NCrTXirpHWaByZ4IeVig9t53Q84U2Qb6y6+GUuOPG9kB5UBZlw+8hsQu70tx6eSimPpuJnlv4CmOQQ/lyUcFPmrWPToo+ekscmobIQ0r/oVv7/tCnh6cvQu+qF59f2lcKOmnh8n2eeuwWqKsmWng5EzsSl0VVEJ/9RS6K/PIDio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GdtCE5ve; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d050fdf2ffso6686705ab.0
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2025 09:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738949802; x=1739554602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LSoBBvU7ywT3hNwAq6aMomh4rrzpxK+7oT/RYGwDXko=;
        b=GdtCE5veo5XwRdl1mJLWMxm7qQ/o8Y59FkJjgZHNOinTD3OpWKkvy4JdCFUm9Rxk0n
         mjIKpIfdpT0q8nNm4AmzYHFTaNxR7+xykxBv0DjZReXv3EIWRV0hsoa3PUnivKciXFM3
         tIa0zXmI/zILvHcOrKDz25/cjvSJ1p5MWl9JOOovPVrfH3pj/lf0TANtyDmAUqLswZa3
         KnA8GDu4Vjk3JhAaqFuucO5Sp9JmDVmLn6k2WRxqf8yqHSrw8+KkrUCT8NK1KKwBn/gb
         7AuhDAO+/Njv3PDR/BoVlY8KtfctGnXLVVEKDMEPQjZdNSWQUaBnQdCoVgsGU8PRIzjc
         1DyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738949802; x=1739554602;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LSoBBvU7ywT3hNwAq6aMomh4rrzpxK+7oT/RYGwDXko=;
        b=m2cQz7e4PPmdv4X/Qc5StIJ8/fF8Txx7nkf8C7KWrKz9hkJbYh3jzXKIbaX2CCA/9w
         S3ZMnLHMJAPX7LZZuI3dwwqZ4UN0Fx9EdOUSnBLcV+VtQVySY+pQeFFGuBBE0goz++ov
         zgpn4uFnT1idyoE4DQmKmsxi4slNrEI8GirSA1WhnddxExp87Ou2N2Uq8hllOLabaB17
         /UT6X1I8mLiCxqhK8nhvF/Q5xJSH9QbCGtl3JKD8nAjbQTY4W7n1Mdx/t/r9Q+3k41yK
         cmOVP3f3I25wWyPHTsBu6b7h5ISKJjDIgxPr4AJYxrLXYeKtuMjkrYCEwJyq6OnhWdMx
         PRdA==
X-Gm-Message-State: AOJu0YzSyjuigbGNZk10RQl87y+ZLssOoz5R1l1tSd4ci3EW5ZsO+U2T
	spIoT3pWqIJyKM97ZYjKtpocVAdk0fMdB523buGDCAu/LS46R+gGleFcYO6DtXnmMMJZuUPNEhH
	n
X-Gm-Gg: ASbGncuGjG6ZZPXaJl9z+DlAilJG2jY32MPNSzWMfmLeCg6cT2TYSpL5M8mbpwRgtnT
	O3+kTyuCjzI1gCqjZoF6TBovQLu2IwJWEVSUdIhyZ9smr5UD0cd5VAi6tgARlXUUTmig9pA4vHw
	rou9txO5N1uakcbIrI9nWR6Buryz+1v/9imw0zrjabSq+PuQXhuyx9ex88Hfc5Xchm7xki7ZFVC
	yUEiz5Kd1cpYKzZbE9oWpfDNFqWlDwqJjqHDsA+MoFeg84lREXEI/iNH2fA4FHwVgSbD3de8IwY
	fssV/lymdrSYWsXJCT0=
X-Google-Smtp-Source: AGHT+IFq+mH/6dEEvBq3HtXFg8OdM2MrA6SkJsi8ng/OZobuons/ZhuSKJfrOFUmuS7Iw8azo1/gIA==
X-Received: by 2002:a05:6e02:1a23:b0:3cf:cd3c:bdfd with SMTP id e9e14a558f8ab-3d13dd3f2c2mr32658215ab.12.1738949802326;
        Fri, 07 Feb 2025 09:36:42 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ece0186151sm206241173.111.2025.02.07.09.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 09:36:41 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org
Subject: [PATCHSET v3 0/7] io_uring epoll wait support
Date: Fri,  7 Feb 2025 10:32:23 -0700
Message-ID: <20250207173639.884745-1-axboe@kernel.dk>
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
relies on the wait_queue_entry callback for retries. With that, then
the above event loops can continue to use epoll for certain parts, but
bundle it all under waiting on the ring itself rather than add the ring
fd to the epoll set.

Patches 1..2 are just prep patches, and patch 3 adds the epoll change
to allow io_uring to queue a callback, if no events are available.
Patches 5..6 are just prep patches on the io_uring side, and patch 7
finally adds IORING_OP_EPOLL_WAIT support

Patches can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-epoll-wait

and are against 6.14-rc1 + already pending io_uring patches.

Since v2:
- Drop multishot support, to keep the initial version much simpler
- Drop provided buffers support, not required without multishot
- Cleanup epoll bits, notably adding a separate helper for queueing and
  checking for events
- Various other fixes and cleanups

-- 
Jens Axboe


