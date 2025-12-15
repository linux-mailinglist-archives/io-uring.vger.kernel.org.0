Return-Path: <io-uring+bounces-11047-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 05A13CBFB3F
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 21:14:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3726B3013ED3
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 20:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 357BF30BF65;
	Mon, 15 Dec 2025 20:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="StntWg7t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vk1-f227.google.com (mail-vk1-f227.google.com [209.85.221.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7102E7BCA
	for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 20:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765829430; cv=none; b=NB7OCOkM7O1GB2fQBzoEv/rF5UPZUbTFl9C8r3RURkySgvli8N6hAbmus+ZVz+doH0ujJNKcKm86RpNMRK1DyClgF56mxFkreKrMXwOwGihs+NPdSWxUb4cBAJYRkkVzcq1t6l+2Sl/kC3bUWu1fJfwBd9vJ7ueKeDusjGDMexU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765829430; c=relaxed/simple;
	bh=r3aZL/nPRHVdgXvS1uHrExxfnyWcDLDYHy9oUaLcqxU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tNt0zlDD5aCNtOfjlTNbrEJZh7LYPCpL8tJRHehYvBIa9/XBHNI22JmAzkkl8iO774SMZLeHgCCp0AlT6zA2Dn9AxW73IHPLoDewFkWDm3IaqXlHth93r9F8rhC6LyZsIGeKu4gM1Ihz27JIWZo3XQ6EqyY3Y5J3HrY3gbHgD/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=StntWg7t; arc=none smtp.client-ip=209.85.221.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-vk1-f227.google.com with SMTP id 71dfb90a1353d-55b9bef45c0so104665e0c.0
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 12:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765829427; x=1766434227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xdM4XJ2ez7XOjy41ohA0SOEmeTWMsFYcc3ndm6aDi5w=;
        b=StntWg7tBJOSNC+RwjQEZm5aew/j/ri1YLJpT8r/iK1KkxxwYegDoxkDu0EO13+vjA
         nViInaVJrl85MHNATb8+CQ5VKUrt8Kwx+1Yyex/59jMFACp5lFxFEgi0yIDZIT4DjYeC
         Rjqw10IaRyr4ZjBJnGDbsMYg8MBvfp40MsaJMgxi95g8kRer4s90+RBtaKLhdpcgZMpc
         Ed9aqQSbDGSBvMnte6hc7q8sea9CI/fKcdi/fZb7QIBZOdTJ1rT0nUDl9S5i4KCHt/CL
         hKAA4IAV7lU3xaSr84l/GiSNR43eItLq0MQhFkIr0+PCqp0wfvNTFMqKBKpobvcYnzvY
         9hMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765829427; x=1766434227;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xdM4XJ2ez7XOjy41ohA0SOEmeTWMsFYcc3ndm6aDi5w=;
        b=HyfJQsizJ/jQAhcSM3BhVXrXZ3pfynn0PsrfcPw8c67GvPfjGkNJT4bXYfsOwuBRAu
         G1qpQdO0Cr4MhO3cY90BrL5qsuPOoj+xAzuFnIxpEBggo65CrVB5yOKa+V/UftXUy+To
         8Dl7v2ucpnfojxrxqgdxc2hMFNbS6jkA0Ar3FfxN5L5MLGyt3zhTQ0/9mO9o28a6R/h2
         ynobuTpCHGMHHagq6dgz/2KLvieDNlSNvzOVRGhdkAGqOmn7LaykAGh9MEvZ7pfIMVY1
         ntRjgKYg+Z4hJZu98hj/aUAhGd6FxZpQfhmlAWlImmCKzXvU0SAX+zWuNWgME43Iyibl
         9IJw==
X-Forwarded-Encrypted: i=1; AJvYcCWocOVsasPWkUCjEAf/wa5bfFySpurea/wErXEJUQxs9BG8UofAddTlL1nVdiNI5fAehry1PPVzmA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFK5VAndo01lZLwTRrfLpJLi5hV+CJKLZroty8+TASrn2hhSDA
	vSsjJKH0Sp3wRQp33KtRihxDG62AS/1Tf2a8+VrB/cGwmPpiI2mkHzQBClHaKZO+Qn5v8M7KJbO
	scvBllTxilVubSL31R5VgGsXIh7cXgwmkeLa8nFteCETKWXtQgkHO
X-Gm-Gg: AY/fxX4sZsVojfAIHAvbsA3XUn28AL47ZJx18YTzYzSflUaaSf9tgG1MJQcx1c95XAO
	REkk57LxEy4AhBZwuXMVDm3gH1MKqmFC1SDOEum5IT4R/GyaL/dUhODFkV7iJEDZWj5ULRsfQfV
	WnDiQL85r59jhpoGj+era2YnxWk+R9CTNRrSrXyxZg1iojwkpHy/P3pLe5X22cIc45oi7wC/E2h
	iVZdpRMr5g4x5tc64PmsEtnTWuXYzFtL/ykJx+c0ej8RkTPbLVhUB50A+P5de/j7lESyymdqE/p
	v6Bi1uOu0g1GdFbHEo/o6jogWwhbrNXdENt59isu0piNbZUOHnstE15drNtBAD+85fx/qHw9jYR
	xZCbYJLjIo46miGacbByFDl40BzM=
X-Google-Smtp-Source: AGHT+IFC7r65Zy9vDexVlbYPsn+B9b4vwDI8VlclB2tKlUjAl0k+02cbkKszwk3p6YyO1x0q2iq13gImsq+/
X-Received: by 2002:ac5:ccc2:0:b0:559:a3ec:d35d with SMTP id 71dfb90a1353d-55fed626732mr1907036e0c.2.1765829427082;
        Mon, 15 Dec 2025 12:10:27 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-55fdc5ef7d6sm1987757e0c.2.2025.12.15.12.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 12:10:27 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id F08F03401D2;
	Mon, 15 Dec 2025 13:10:25 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id DEC89E41D23; Mon, 15 Dec 2025 13:10:25 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Joanne Koong <joannelkoong@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v5 0/6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
Date: Mon, 15 Dec 2025 13:09:03 -0700
Message-ID: <20251215200909.3505001-1-csander@purestorage.com>
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
item to suspend the SQ thread, but seems complex for a niche use case.

Then we factor out helpers for interacting with uring_lock to centralize
the logic.

Finally, we implement the optimization for IORING_SETUP_SINGLE_ISSUER.
If the io_ring_ctx is setup with IORING_SETUP_SINGLE_ISSUER, skip the
uring_lock mutex_lock() and mutex_unlock() on the submitter_task. On
other tasks acquiring the ctx uring lock, use a task work item to
suspend the submitter_task for the critical section.
If the io_ring_ctx is IORING_SETUP_R_DISABLED (possible during
io_uring_setup(), io_uring_register(), or io_uring exit), submitter_task
may be set concurrently, so acquire the uring_lock before checking it.
If submitter_task isn't set yet, the uring_lock suffices to provide
mutual exclusion.

v5:
- Ensure submitter_task is initialized in io_uring_create() before
  calling io_ring_ctx_wait_and_kill() (kernel test robot)
- Correct Fixes tag (Joanne)
- Add Reviewed-by tag

v4:
- Handle IORING_SETUP_SINGLE_ISSUER and IORING_SETUP_R_DISABLED
  correctly (syzbot)
- Remove separate set of helpers for io_uring_register()
- Add preliminary fix to prevent races between accessing ctx->flags and
  submitter_task

v3:
- Ensure mutual exclusion on threads other than submitter_task via a
  task work item to suspend submitter_task
- Drop patches already merged

v2:
- Don't enable these optimizations for IORING_SETUP_SQPOLL, as we still
  need to synchronize SQ thread submission with io_uring_register()

Caleb Sander Mateos (6):
  io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
  io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
  io_uring: ensure io_uring_create() initializes submitter_task
  io_uring: use io_ring_submit_lock() in io_iopoll_req_issued()
  io_uring: factor out uring_lock helpers
  io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER

 include/linux/io_uring_types.h |  12 +-
 io_uring/cancel.c              |  40 +++---
 io_uring/cancel.h              |   5 +-
 io_uring/eventfd.c             |   5 +-
 io_uring/fdinfo.c              |   8 +-
 io_uring/filetable.c           |   8 +-
 io_uring/futex.c               |  14 +-
 io_uring/io_uring.c            | 226 ++++++++++++++++++++-------------
 io_uring/io_uring.h            | 183 +++++++++++++++++++++++---
 io_uring/kbuf.c                |  32 +++--
 io_uring/memmap.h              |   2 +-
 io_uring/msg_ring.c            |  33 +++--
 io_uring/notif.c               |   5 +-
 io_uring/notif.h               |   3 +-
 io_uring/openclose.c           |  14 +-
 io_uring/poll.c                |  21 +--
 io_uring/register.c            |  81 ++++++------
 io_uring/rsrc.c                |  51 +++++---
 io_uring/rsrc.h                |   6 +-
 io_uring/rw.c                  |   2 +-
 io_uring/splice.c              |   5 +-
 io_uring/sqpoll.c              |   5 +-
 io_uring/tctx.c                |  27 ++--
 io_uring/tctx.h                |   5 +-
 io_uring/uring_cmd.c           |  13 +-
 io_uring/waitid.c              |  13 +-
 io_uring/zcrx.c                |   2 +-
 27 files changed, 547 insertions(+), 274 deletions(-)

-- 
2.45.2


