Return-Path: <io-uring+bounces-10802-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F4DAC877A5
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 00:40:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 369FB3546C5
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 23:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6BEA2F261A;
	Tue, 25 Nov 2025 23:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="YZ3fvPAO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5337F2F1FCB
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 23:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764113982; cv=none; b=VkMT9GBlggAXp4HfDx79zx/84ZMgQpLPv61iFVD+1eNsUWBzPZhHoy5WBpN8tvqCRABJi2mlZ6hmjWqZlfbFx4a499Scrup5a22atDHi5u9AlxWFqckXaLrrBZYUEuvxqKnLHwQ/rXLcSZOxQei90MDGBOya13Ni2AS9PQWq/PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764113982; c=relaxed/simple;
	bh=Zmv6adIPrhxTxZdGq2k/taaoHQDIlClAwvXAJdCB1rE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ice+DwuvJu2nahWgvM7GpWzE4PNOhA5oCl8w0eiOsMig3gyXUNCCbn+US+o8Rx/3ngulQT7Y52bJAnxbEdiyVnyuWouh+NhHDuDyZZrhB6OlLAX83bGSc9ZCwMT/+G8qj7QOSnqDPzzYWZoC/U6iyBAcG6H27sjj9yqy0/w8yJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=YZ3fvPAO; arc=none smtp.client-ip=209.85.215.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-b983fbc731bso684767a12.2
        for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 15:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764113979; x=1764718779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BXOFyBMI9vDu+epolmTOAoq+vMSQmowSeWfjwvlQsks=;
        b=YZ3fvPAOTnI1gTQPZ5/ikJPIhkDHoYasUTnvuZ26aCd4jzV8R7WjLa5dm4fX9wkady
         hpDFMjqe2LUq7M0klhmFqp2pme0XTK532OWy4gsrqevyJhIaCVLT67vkzWNzmda8UXud
         MhDO7SELtPAw47wusu1DE7FCHAB5447vSSCw/nNadqouQ6b3xscLotAXemaZOqD5pTyF
         se4YOTqdJJ+KUwxkxWWtCZGPDv9ZXveNbNgSofPqoSo7b4457oYmPRT4IDw+7UXeEvYb
         gNCMlA1nI1PWnwf6KTIARV2BXsU1wP6wlCSbfAySdwxYaPq3NEjDT3JxyOjuDg/UwkU5
         /KMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764113979; x=1764718779;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BXOFyBMI9vDu+epolmTOAoq+vMSQmowSeWfjwvlQsks=;
        b=w4CVTHQ8XRr0v3ZWxmXm4d3rkFRpQthhSexdLEIwK8NxLwa+6sXXJm9pPdMbNodHd/
         3M/53FWv7rIyuohfTFpl1XvaHRfMAVe1YhwYks4RQVHI7x70MCtP9rWJTQ7tuNVxdCQJ
         lcDBpSjSb6VGFOVX2sHF/PQMSNCOJjZZDe/f8PTdbqEUtCILR2ir25MafsBU4aaR/UjW
         e/TuRMszXbf1xoI9xUyJI1FUvusZ08EFPrIRSqVp6XH1qBqaXWH2jhDSN0HCQPxmR22k
         vyOoIacb4QpyjtRaC3sVzMeF38el52D4scZRNcWBdGtO3tYBcVQSwx9plBtzPUh0V2GA
         lhPg==
X-Gm-Message-State: AOJu0YwJUn8jfNnTeKNLyBL86ReFjEDPUvDZMxLqJbW5KTxTKCUMxK9t
	3sbXHbJwcl7V5MNYWASMX0FvjUKcdPu6txJ0/JetdkFH+c20tjX0vUODouGjN6NylLgVJ7eLafn
	vJHKcjrSsT6IJnGeSffsG5eO5bPRqQ6PiYpkF
X-Gm-Gg: ASbGncuyr5YWTB77qhuUGJBrrN7a4am3RjxUHRsImvIj5TIeUDNwpVWJuW9uhpx3egG
	6/5CAE+8oVXgwBjiM6w0UaKtpErBKyZtBpTdZMueGlml6Vel0UYMk26dzVtNk7sw4KYlDy/SEYw
	VvXjsWS4gaJwyNa4dl59kCTHmcAp9ryda1Q3NqOw870EqNmVa0J5If6Q7aPGGmApqVyFo5YYzu/
	5zF6hmxBk0E8nkxqMtTEBB3HVxdwefGFy4E3syX3lcnKKtEBNNhGbUF9ThbPIXkdNKzgNAF3Adi
	z4pHpdhmmGD/pwx4x67YOYRsMgDDYNtY709TIyr9m9sNHFdDyO4/JQLSuLGpFSTqwGDmYp4yCYk
	k2335SZbMenpvdPd+erMiucm6SaBeAfk5mq/sziitrw==
X-Google-Smtp-Source: AGHT+IEjqtiph+olPBliP3h0AsgaH3qy4zQi8HFaEbLOv/SAphKZtcCRWIzpJJ+J9ngKoDhttB8VAmdzZKmG
X-Received: by 2002:a17:903:37ce:b0:297:fe30:3b94 with SMTP id d9443c01a7336-29b6bfb527fmr98592285ad.9.1764113979452;
        Tue, 25 Nov 2025 15:39:39 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-29b5b1365cdsm20923805ad.19.2025.11.25.15.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 15:39:39 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id F3BAA3404B9;
	Tue, 25 Nov 2025 16:39:38 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id E6875E41EF2; Tue, 25 Nov 2025 16:39:38 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v3 0/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
Date: Tue, 25 Nov 2025 16:39:24 -0700
Message-ID: <20251125233928.3962947-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Setting IORING_SETUP_SINGLE_ISSUER when creating an io_uring doesn't
actually enable any additional optimizations (aside from being a
requirement for IORING_SETUP_DEFER_TASKRUN). This series leverages
IORING_SETUP_SINGLE_ISSUER's guarantee that only one task submits SQEs
to skip taking the uring_lock mutex for the issue and task work paths.

First, we need to disable this optimization for IORING_SETUP_SQPOLL by
clearing the IORING_SETUP_SINGLE_ISSUER flag. For IORING_SETUP_SQPOLL,
the SQ thread is the one taking the uring_lock mutex in the issue path.
Since concurrent io_uring_register() syscalls are allowed on the thread
that created/enabled the io_uring, some additional synchronization
method would be required to synchronize the two threads. This is
possible in principle by having io_uring_register() schedule a task work
item to suspend the SQ thread, but this seems very complex for a niche
use case.

Then we factor out helpers for interacting with uring_lock to centralize
the logic.

Finally, we implement the optimization for IORING_SETUP_SINGLE_ISSUER.
If the io_ring_ctx is setup with IORING_SETUP_SINGLE_ISSUER, skip the
uring_lock mutex_lock() and mutex_unlock() on the submitter_task. On
other tasks acquiring the ctx uring lock, use a task work item to
suspend the submitter_task for the critical section.
In io_uring_register(), continue to always acquire the uring_lock mutex.
io_uring_register() can be called on a disabled io_ring_ctx (indeed,
it's required to enable it), when submitter_task isn't set yet. After
submitter_task is set, io_uring_register() is only permitted on
submitter_task, so uring_lock suffices to exclude all other users.

v3:
- Ensure mutual exclusion on threads other than submitter_task via a
  task work item to suspend submitter_task
- Drop patches already merged

v2:
- Don't enable these optimizations for IORING_SETUP_SQPOLL, as we still
  need to synchronize SQ thread submission with io_uring_register()

Caleb Sander Mateos (4):
  io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
  io_uring: use io_ring_submit_lock() in io_iopoll_req_issued()
  io_uring: factor out uring_lock helpers
  io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER

 include/linux/io_uring_types.h |  12 +-
 io_uring/cancel.c              |  36 +++---
 io_uring/eventfd.c             |   5 +-
 io_uring/fdinfo.c              |   6 +-
 io_uring/filetable.c           |   8 +-
 io_uring/futex.c               |  14 ++-
 io_uring/io_uring.c            | 205 ++++++++++++++++++++-------------
 io_uring/io_uring.h            | 204 +++++++++++++++++++++++++++++---
 io_uring/kbuf.c                |  38 +++---
 io_uring/memmap.h              |   2 +-
 io_uring/msg_ring.c            |  29 +++--
 io_uring/notif.c               |   5 +-
 io_uring/notif.h               |   3 +-
 io_uring/openclose.c           |  14 ++-
 io_uring/poll.c                |  21 ++--
 io_uring/register.c            |  34 +++---
 io_uring/rsrc.c                |  37 +++---
 io_uring/rsrc.h                |   3 +-
 io_uring/rw.c                  |   2 +-
 io_uring/splice.c              |   5 +-
 io_uring/sqpoll.c              |   5 +-
 io_uring/tctx.c                |  24 ++--
 io_uring/uring_cmd.c           |  13 ++-
 io_uring/waitid.c              |  13 ++-
 io_uring/zcrx.c                |   2 +-
 25 files changed, 506 insertions(+), 234 deletions(-)

-- 
2.45.2


