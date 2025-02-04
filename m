Return-Path: <io-uring+bounces-6253-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FDF2A27BD9
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 20:48:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF3FF3A00F5
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 19:48:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E402054EF;
	Tue,  4 Feb 2025 19:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wV5FOXya"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86732045A8
	for <io-uring@vger.kernel.org>; Tue,  4 Feb 2025 19:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698500; cv=none; b=iyEQHlWD0wLOwErN/buO8b2oN9odXh36xEOUgPdKHwNwlV8l5B7GuptE5B5jB7ddYGyRPKttK6aSNtwx1RLa4zvZQ5NIa9HdwzrM4hC6PVTPG9e+Ux0QjrLsE3dQr8KxpOgLUyjsyG/fv5BYAZBYhnkF4EyKGOmJFbWaQAknano=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698500; c=relaxed/simple;
	bh=j7Zjf2INBfzuB4mtiIIERkayItXNq2h82jgUfLKhVuM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V4y/RM7/xMKgt4ODSSjMdVRIXHZRA/jVdfpjjHY9vQG7gXYgnmQEcZ7tcQTTWhFTeR11VRCVMhv3C9zfAj8rLA6OTOY0klfZ6IomrXbAO9BF6p3eZT1a+UVVo1qr5F6nIBYlBOM5uCHw8ybqlfxcEJhnZKxL+9uGS9Ddlp68m2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wV5FOXya; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3ce7c4115e8so462105ab.1
        for <io-uring@vger.kernel.org>; Tue, 04 Feb 2025 11:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738698497; x=1739303297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EvsrvCpHRoJHRfK/sZpZWPkYiJ/JUv7gpZVagLfyaIU=;
        b=wV5FOXyaV6uCmW9A5MaBgdx9z6wbZttjfF6ALRAYfQU2N8/iXaMwIDTdKhegs/wI7x
         nqFK/vzf0V01fervjiW+Vjbi9FY1CykS6/GafCZzEOLQ/4fair8vN5tgJmUiI/wIb6DO
         kP8aZ4tJzCkFvnxemfHlTWIprSppwfuWQWVfYXUzRLyko2tiXUqzEBOBZ3kh7Rtg7M6M
         ZrazB/J6HdCLiIvY0Z8/4IVgeMJuHJFLqjlHTbe1qehHf1CgbxgzECmnM+xKNsAwpvc1
         KeQ9S31J17BpbFiIpH/Dvu6H1YE4gw1kbhTT9mxoIJJ9qhExsZnJmIDCdt9DEveEtYI7
         HxxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698497; x=1739303297;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EvsrvCpHRoJHRfK/sZpZWPkYiJ/JUv7gpZVagLfyaIU=;
        b=qXXMx02J7MnkIIv5aEtkgjzzeo8zXB9Lar9ILzZO0pm4qwvRDfu5Vx82Avx/b9CqDU
         OLq+HtxZL5fIlh65w7oJ28vVAHgPZUGYSrcswA7vAmC8zH3niVu1WYrR0KCkiGPA0jkD
         1fy64zdMr2JSeVcM6gMNI8Gm7XxaJ7HpyvBWHm1eSagDri6TuO2LG5uj8OJ8VacOFpKE
         oFfoJQp1Klf0O+y+++phFQep9mE01YzVV1TDTOtqg0x1LnqlEjs8iNgJG5DWofbPJAKh
         PSDhir8go2B14PmkWimM7SERrysdkaRvXzZA0M/uA4A5qO77Jse1dma1HeE+R3t1Rc6o
         Y2Jg==
X-Gm-Message-State: AOJu0YxQfEzmSmDfwwVEZKzqE2m0rs7nvPmEk7cFYzM8Vxy0IPUcT4Vb
	UbzXkw0gCcpjETxc2gxd2P4ATrFyhE7mNwiDbjSSGnkxBPLvsjrULeOGtWuWKfvN5fJHfpAJPqA
	f
X-Gm-Gg: ASbGncs7o9EKnXql31+J/xcsXz7Or46G21AanXD4wTOKf8I/wWIxDgfXbbNOY0zjoXi
	bOGkH2DoqR2bjmtMS61fzZRcNkV/lzccFQzlPkI7KanwnC4KpeyiPeuj4KwUJ0rLGj8RZeF4rS+
	dUWd8KR9YRmEXCpO2/O1oyT9Ej8rRzFJ2G8zNqcmdzNNcsIQmGFIL7ABMKcJ77QZOMFn9JobnNt
	M5xC0xV+RKXCYSiMmUxcFo2bOVW41ioEI7cLM9ENEYrejAYvDr5W/2BCq/ye8keWRhLD8Kc2XqE
	E517Z12Lg10P7/3tKPw=
X-Google-Smtp-Source: AGHT+IGHEwpThstK0EApszsBtPZfG2+AbhSHLaiY8I7mzj7cuHjlYGlN22O6Ubp1rYHX1SwnVaZfNw==
X-Received: by 2002:a05:6e02:1a0b:b0:3d0:294b:49c4 with SMTP id e9e14a558f8ab-3d03f5216dfmr32687265ab.8.1738698497326;
        Tue, 04 Feb 2025 11:48:17 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746c95c4sm2841466173.127.2025.02.04.11.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:48:16 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org
Subject: [PATCHSET v2 0/11] io_uring epoll wait support
Date: Tue,  4 Feb 2025 12:46:34 -0700
Message-ID: <20250204194814.393112-1-axboe@kernel.dk>
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

Patches 1..4 are just prep patches, and patch 5 adds the epoll change
to allow io_uring to queue a callback, if no events are available.
Patches 6..7 are just prep patches on the io_uring side, and patch 8
finally adds IORING_OP_EPOLL_WAIT support. Patch 9 adds multishot
support, which further gets rid of repeated write_lock and list
manipulations on the struct eventpoll waitqueue head. This last bit
should be a nice win, having a persistent waitqueue entry rather
than needing to lock/add/unlock for each epoll_wait() equivalent
operation.

Patches can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-epoll-wait

and are against 6.14-rc1 + already pending io_uring patches.

Since v1:
- Add provided buffer support and require it for multishot
- Fixup various multishot issues
- Various other fixes

 fs/eventpoll.c                 | 155 ++++++++++++++++-------
 include/linux/eventpoll.h      |   8 ++
 include/linux/io_uring_types.h |   4 +
 include/uapi/linux/io_uring.h  |   7 ++
 io_uring/Makefile              |   9 +-
 io_uring/cancel.c              |   5 +
 io_uring/epoll.c               | 222 ++++++++++++++++++++++++++++++++-
 io_uring/epoll.h               |  22 ++++
 io_uring/io_uring.c            |   5 +
 io_uring/opdef.c               |  15 +++
 io_uring/poll.c                |  30 +----
 io_uring/poll.h                |  32 +++++
 12 files changed, 434 insertions(+), 80 deletions(-)

-- 
Jens Axboe



