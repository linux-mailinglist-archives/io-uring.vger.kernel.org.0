Return-Path: <io-uring+bounces-10882-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A9F5C9C401
	for <lists+io-uring@lfdr.de>; Tue, 02 Dec 2025 17:41:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7344F4E183C
	for <lists+io-uring@lfdr.de>; Tue,  2 Dec 2025 16:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D422989A2;
	Tue,  2 Dec 2025 16:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="eWh2DLW9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f99.google.com (mail-wr1-f99.google.com [209.85.221.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DBC2848AA
	for <io-uring@vger.kernel.org>; Tue,  2 Dec 2025 16:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764693692; cv=none; b=shK98U/MndGjedgTTTOYoprwRkEQp4ogRfhecho7RlCRQJgB06sTL89tY3y8+Ib1b1X9CFyGUgEHkEiplgcsUdeVAxfCwNBaelpWoJNSA9ha44HT709FGGlLTWTfn+bCOPbwT9l49qRdjPY/sPsJLneo/gBPQiW3wo2FUIWPWcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764693692; c=relaxed/simple;
	bh=irnYtl8EXzDHGZL8lvHm5qFdUZ5dta+1vejjalYvQOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KLMvGM2xAU6T/IIrDtLqQduKjqn8+905B98yvDDzgut2dqAcBpUNwBoVG7SJ+u/DNNGbTTo3a4IWjhGWgBPcTyhNNMVDK3blnWA0u5cLeKUCHMioXlxi/ca4ylLOVRJI/6HajmVC9nFLca6bALAxg/bv0xbj3RY+nr4PV1Kyuvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=eWh2DLW9; arc=none smtp.client-ip=209.85.221.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-wr1-f99.google.com with SMTP id ffacd0b85a97d-42b53b336e6so303892f8f.1
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 08:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764693689; x=1765298489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xmduGFmAx4HiodF0nAVEGX6H2nhW2gSUMOE+oxpssSE=;
        b=eWh2DLW9g++JRomUPKKWyTm6kC7NGN4Ur9h7JbXhh7OXd3kYsC9Eqkmmb3vxITnT6Y
         NwLWpav2FBX3vTNdeemKP0jkJH13vS2J4Htc5bu7lVDrkcFGvPZI1iNxbohfkSpoHbGL
         RGEq4p9qkgUbIECXqPy5SfiiAXt6rcZI9LBIfANUMeJHHOenAQmPnpuCNF92NgyWwd8Y
         eRQrYsXY4RuJ+ZlKXdmt7Xh77nvQAtCgXh9wHBPCbZJGbF5R5ZLf9+iWGibrtyRpfyeB
         XlPRvib+7KDLQWrOQufMk5oUdlhm59EllqOEBtOlaOtaFE+DbJ2nOCaJkYeXOyQXQNNY
         hRTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764693689; x=1765298489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xmduGFmAx4HiodF0nAVEGX6H2nhW2gSUMOE+oxpssSE=;
        b=AqPNzVkv0G2OFPqi09LYQNI8VEeVt+b6zGzylBeB8zIoe/LI8ZesBc+OtDRGy/6BCn
         YxysJukky7NvoWEg0qZEnJtSiznLBiqmDo3ArBI+aFyPUIuYfNZZtHfYWcXwztYvvRp7
         fYAY04l54l/zvJ0fra3wEqEs1fDPNDXUP7BNK7QEWGjS2s3Cbfnab9GSToGlIUx4XzN1
         HEnk9VcCqEXOlLU/RgK5q8QZ/CVnFZ/5sd9oMZqUp3dm9MOrjMhixjqWCskA8i0XrvrC
         yVhe8r5S9Q8Or7sdudaqpqM/7Bn1tLgQnQopLWnl+ryGuWtiD1XIcQpUD6DsDje65OUx
         8FXQ==
X-Gm-Message-State: AOJu0Yz7TsOZznZjg5IC4v8G4gqdD4qc3oUybJonkVdS8dfQrCsvshoE
	IvrnJP4wp+Z5KAAmU+HBB8YLYyRElv0RWvEszy4t2sF0x9KA69EK7zHA7iMybYuGdKlQ5hshqUQ
	kG4hOgcrZGhURu0oECgSRotMUzwUMoWMhPcR0JacXEPTx04ztplyv
X-Gm-Gg: ASbGncvrZDguZu9sUU7He49JodpaK0EpNWpVHm99LgCfvFrYD4kG9BIOhpTwXDCa7sh
	A85vA2ut8y2ux6QRfb6UB5my+UPvSF7wrXPOeat0GUZ4BQMz7S8+K5D/oIf0Q7A3bMfyTf/dnHD
	0KvjdpsbR0BGsTEvnVsl4OV5pvTDfDKEy6UQCiHVGalyqOBWzEILmfgqxP0PG5Q6dk3kshrsRGC
	O4ulVbHvOVcBOI/BrIHw9I2S2xxu3hyjbr8sk3D32kZKfGw2P+/M0N1FwEsxday63Wl5gKM7Oig
	0dByecCojQoT9Yen8ySuziDXv4xaNZ7A8FxzZCAtijavmE+w72V2IFXu5IfveYkmAkzS/H27AZs
	oxKedw5TPttoFuk7oFHasc/xV+V4=
X-Google-Smtp-Source: AGHT+IGebrn44zrWxjmLpNc03b+7fVpKjiUaZd39rgoWPExa4ZscqBeq/mpBmIzjF5VeQd1zxLTlfVDOCqv1
X-Received: by 2002:a05:6000:22c2:b0:429:b4ce:c333 with SMTP id ffacd0b85a97d-42cc3f87177mr25612400f8f.3.1764693688858;
        Tue, 02 Dec 2025 08:41:28 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id ffacd0b85a97d-42e1ca5385asm1719138f8f.31.2025.12.02.08.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 08:41:28 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 7EBB134029E;
	Tue,  2 Dec 2025 09:41:27 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 79F15E41DB4; Tue,  2 Dec 2025 09:41:27 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v4 0/5] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
Date: Tue,  2 Dec 2025 09:41:16 -0700
Message-ID: <20251202164121.3612929-1-csander@purestorage.com>
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

Caleb Sander Mateos (5):
  io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
  io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
  io_uring: use io_ring_submit_lock() in io_iopoll_req_issued()
  io_uring: factor out uring_lock helpers
  io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER

 include/linux/io_uring_types.h |  12 +-
 io_uring/cancel.c              |  40 ++++---
 io_uring/cancel.h              |   5 +-
 io_uring/eventfd.c             |   5 +-
 io_uring/fdinfo.c              |   8 +-
 io_uring/filetable.c           |   8 +-
 io_uring/futex.c               |  14 ++-
 io_uring/io_uring.c            | 208 ++++++++++++++++++++-------------
 io_uring/io_uring.h            | 189 +++++++++++++++++++++++++++---
 io_uring/kbuf.c                |  32 ++---
 io_uring/memmap.h              |   2 +-
 io_uring/msg_ring.c            |  33 +++---
 io_uring/notif.c               |   5 +-
 io_uring/notif.h               |   3 +-
 io_uring/openclose.c           |  14 ++-
 io_uring/poll.c                |  21 ++--
 io_uring/register.c            |  81 +++++++------
 io_uring/rsrc.c                |  51 ++++----
 io_uring/rsrc.h                |   6 +-
 io_uring/rw.c                  |   2 +-
 io_uring/splice.c              |   5 +-
 io_uring/sqpoll.c              |   5 +-
 io_uring/tctx.c                |  27 +++--
 io_uring/tctx.h                |   5 +-
 io_uring/uring_cmd.c           |  13 ++-
 io_uring/waitid.c              |  13 ++-
 io_uring/zcrx.c                |   2 +-
 27 files changed, 544 insertions(+), 265 deletions(-)

-- 
2.45.2


