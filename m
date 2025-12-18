Return-Path: <io-uring+bounces-11172-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CEB4CCA1A9
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 03:45:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8C182301F029
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 02:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ED522FDC40;
	Thu, 18 Dec 2025 02:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="NKzsp4BC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f100.google.com (mail-oa1-f100.google.com [209.85.160.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2978A2C21FB
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 02:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766025908; cv=none; b=fpi8paAfstNymadFzVq3Xbv1RV7p/fPjHJVua5wJe73wAk+UvNJ6+mL1h9PQlHUnLEdWIjnlgd/kqTTC/BB+nvR/HaryeersqGQD2xb5cjrc7+pQ1qfB96DWWaQkn5PuSCOWzlgXOCBWsPup3Fsg59eP8Zen+lHnv+8aujaqvlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766025908; c=relaxed/simple;
	bh=eXCgCRCKdSO0csyTYrKRVrmaHC/gr+nwY1ZLSsrl7bs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rGfiNwMwjZTihttYr8+mS3EURn8U1SlalIWvPZ6u+Q+BqfCqg2OauCH71Hv+fonOAhyp2bUjBJELHeyUSoVzCt8dXsbsGAfDltZAjVqf3X0Opw/OM9MejqqUZ61MpKA/jEwbReVey3Zz59g3mVVVumpbq/LpnUmXtnrOWF7G7BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=NKzsp4BC; arc=none smtp.client-ip=209.85.160.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oa1-f100.google.com with SMTP id 586e51a60fabf-3f0bb52e609so33659fac.2
        for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 18:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1766025904; x=1766630704; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o6csX3SZUNHC/5FLP8PfuB/w7jNl/4Op/eZdAbh0yUE=;
        b=NKzsp4BCQpUOdhVJrXNpssdf5HMh1iV+cSzkDjSF4eHFA/xFa+nBldTdfCd2zH4orb
         1HcpGWmEEXNrheFobV3yFnvZ/1hHX/f21gMUyNEQ6r2RTb8x7QJFI6c6XvjKsyKKFhBg
         RRgH1VSb5/7DxPP9/kNre5Lch2qFb33LJFh1eWBZsMPYg4KhzP9MwyfACnEJtAWTdquh
         ALW7Ac5FIn+2jgTiuhlsP6K+0G8mpqPyU3oLouC0twrkcJsdcHYqHGvAACw2/VGVn2/i
         trMYPCXTGNYbgL7NwJnlDwv1ppGi9FezHZbdd47J1ADe36yWfXAWTloXRrm6tyVc3F4j
         d9yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766025904; x=1766630704;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o6csX3SZUNHC/5FLP8PfuB/w7jNl/4Op/eZdAbh0yUE=;
        b=O0lvVCXsxO3WVM4+xqqBFfVBjOQnbxlEI+O/4VPW1xhO/44CbAMTlnL/ip8g4fG1/8
         THJB7mWUeTHh8YGi/03ODDz/dTIHtEfB9zggkoL7DwXlsToo7P8pHZEwupjUzNWygaQI
         VM2f91xCS4I4rmqkKj1WygcdwBwFnsLTu5l+h0d8bR++mAUGsOL9AddkdsFIAu52TD3N
         VGp/5TWTbfml8PxoLH6EdPrpdYv5aLpoKu5CF9AnrSUQS9uCd3y1AdMcqEdIseq1a8+9
         TpbWHTqJOiIdg1TG5/1+Ze9BBI8sbTFejWzMuIcIJY5t+tbtSRjM9Vaqb6N0hdWWtW6o
         Weww==
X-Forwarded-Encrypted: i=1; AJvYcCVrviawWsN8bJDE1o8K6MMYv9+NjOfiVwinEBP5AC2JZ4cJZ3Q2Dpt6/GYnGqbVCxQ2dFbVvrZ5pw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyHal0fBUv6pA8veKJhZYumWGN7R0yINlc1QC/SFa01cLb30qQy
	sotO6Nwy3QI8FVIv6TI87CFUm7Zi9BMA01XDtiMUzYDDqv3lgZCGZgnGm1lxMfjphXgraD/FLjX
	QClE2/nQH2kTayYLOHt2sTQSKJgkw7EOR6+VB4AEKL/Qg4PN5pbFx
X-Gm-Gg: AY/fxX5/XpMPIF8NUrjdaZlwZQM3zn9whLytecSkx8OcPo+L1RohmudKEp8Kg9UM8Ah
	jgRp5edRb7fIfMOy/zc1OP/rSnG3rX9966z0YNEU2IzcMlgPrAXUJWSNmV+mi+VVm/yfZ/AgLTn
	2JygHTTGQdVSSpWKAYpIiOhztOOdk0GFwvXyTmNzcGuDweSy5zb+jwMAyzoA6i+FhgttNZlh9bu
	Kla+J1C7l60QMjTQmHpEfAS891adN/iYDeJWHKCpJvYFvMg/wLhfZU2Wv3KZ/WjiQBVHyHUZwRm
	ohZkUjfbjV/wrZMiOjJs2lFUh+RvSrO64qG9AA4d2lKvWx++789p5pF5OU94IeFrytbM7ri+Zvd
	cRkHd/Et0mGlGACG2itr/gcyNG8Y=
X-Google-Smtp-Source: AGHT+IEAWQlaRzZhV9fnz5iLlZJFwJyFBjcjGrI+fWTITbbN7enw/VjqMR9tvR9m4wH7HmiALNRrL4NCJbKv
X-Received: by 2002:a05:6870:e191:b0:3ec:3bfe:bda7 with SMTP id 586e51a60fabf-3fa1adc04edmr427710fac.1.1766025903949;
        Wed, 17 Dec 2025 18:45:03 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-3fa17d08d1csm128937fac.3.2025.12.17.18.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 18:45:03 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id ED48C34141D;
	Wed, 17 Dec 2025 19:45:02 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id E2015E417CF; Wed, 17 Dec 2025 19:45:01 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Joanne Koong <joannelkoong@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v6 0/6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
Date: Wed, 17 Dec 2025 19:44:53 -0700
Message-ID: <20251218024459.1083572-1-csander@purestorage.com>
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
mutual exclusion. If task work can't be queued because submitter_task
has exited, also use the uring_lock for mutual exclusion.

v6:
- Release submitter_task reference last in io_ring_ctx_free() (syzbot)
- Use the uring_lock to provide mutual exclusion if task_work_add()
  fails because submitter_task has exited
- Add Reviewed-by tag

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
  io_uring: ensure submitter_task is valid for io_ring_ctx's lifetime
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
 io_uring/io_uring.c            | 232 ++++++++++++++++++++-------------
 io_uring/io_uring.h            | 187 +++++++++++++++++++++++---
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
 27 files changed, 555 insertions(+), 276 deletions(-)

-- 
2.45.2


