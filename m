Return-Path: <io-uring+bounces-2501-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 191CD92F521
	for <lists+io-uring@lfdr.de>; Fri, 12 Jul 2024 07:43:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D6561C21FF8
	for <lists+io-uring@lfdr.de>; Fri, 12 Jul 2024 05:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD88DFC12;
	Fri, 12 Jul 2024 05:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ElmsGjYT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7960518037
	for <io-uring@vger.kernel.org>; Fri, 12 Jul 2024 05:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720763024; cv=none; b=hWpBegQF7cCmSuJeq/6vWQ3dQFs3YWVQUNFBGMO1NPEew/NJ1J9iiyN2A+N1tsxDtAY8ZRyyT5CI/blIeFPmnk8l8A59mYGtQcwe5fNqXEAgrqCtZ5Fplt/MavUK2hZ16UKEKCUS+jpjnMCYU6O+n6vPvawcjbNQP2WwGOz054A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720763024; c=relaxed/simple;
	bh=84roCgwq53QLWK8CFR5bmLMO4WAvQazzcA+cDmkleW0=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=GOwyHQ1DaXJTreq+mpb0HrdgSNqMdXlgGGgu+T0cnB9tcdxF3UQ25HovTRUYlOBk5URybws4x4d1cWOrQkorATgnz1EHs+CkANw6AUONbhQz3HcLnhZjJFq7LtoBFz0OwCLBS3p1is5hiMMJFwFl+hPkUWqREx7TuRzPqqeCHpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ElmsGjYT; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-52e9d61a4b4so256562e87.3
        for <io-uring@vger.kernel.org>; Thu, 11 Jul 2024 22:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1720763018; x=1721367818; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FUU/YtzkDnki6k2q7yxeYF3IthKrAb3+ThSO0uPkeiM=;
        b=ElmsGjYTBsHecFmFmlSb6NWyJZ7Wn7JVh98vy193OFplmOCQibxP/cnx6if1uqhHh6
         frNDKBHElEzh8TDL1xGqMX5lwKxoe5Pxenpi+mKfUZ25yhSAbjf5deATq9sZW8QtFLWX
         DLhGo/DNm8vsXs5cUsUVeYYPIm1BO/Ot+TxYP8LfQycUlx5ludahYfs+9xvg4x9JelrN
         gHaHX6iyZo2s6is0uOjEZe8+W/lx5YtUyL4Iv0Ozd1QNe0BLXq3+1GldWs1epW5CRR7G
         pWzmZblY33ptLxtw6fOmt3G+RR+wpYJXtV/nIe2arlwQYyftRQlTVkVwi9jPH6bjURdu
         KEGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720763018; x=1721367818;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FUU/YtzkDnki6k2q7yxeYF3IthKrAb3+ThSO0uPkeiM=;
        b=qf0dGV7V8RKdNwWNTBXg68kRkQHs6iJpX8cL1hOC/zcMOJILGlLfOc8xA29ATr0kNF
         XZR6NuKhUuWZVkh1VZLUcFGCqt/PsdodTn4F3JTd8p06qZN2ITFJbPQjJb7UnE+6I40d
         RW1BEZRydMTSjCMStHTR9b//ffF+2RFPmHpRuC8KA7GF7/pK5raZXBGn7GixOMwymGT+
         ATiWzJhz5gvWMoHwVTlHnpjmYZUaO8DKhY1TnuWCLaIC6BgFJsP+LFk+ByKRrbbY/uwt
         iitO7VVibsnAQmGkHIkZW9Ql0T8vuFlAhu0619i+OtDobQcIkPvtAuHZTE+mlnDMaFon
         cmyg==
X-Gm-Message-State: AOJu0YwbNq2EYrvRMtqIbLSMDnH6AGDscpvNCf6nSp4/qpbHUlN+tvRo
	ut88QPKYWI3Js7+AGMGToVumrGsLALwles/dEH70PGGZYtXQxM+xKC1HuIHONWWnalOVj3ekCt7
	n6OHKtXaJ
X-Google-Smtp-Source: AGHT+IE70lVmzrSqlpGtxTcUjIZZbRB4o7YpkAa6PaHrBwAlJj+AJMc0R+HiiJq+UWxMJwTm8ufJzg==
X-Received: by 2002:a2e:bc04:0:b0:2ec:16c4:ead5 with SMTP id 38308e7fff4ca-2eeb31bbf8bmr70876321fa.2.1720763018123;
        Thu, 11 Jul 2024 22:43:38 -0700 (PDT)
Received: from [192.168.1.68] (87-52-80-167-dynamic.dk.customer.tdc.net. [87.52.80.167])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2eeb3421e05sm10443421fa.33.2024.07.11.22.43.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jul 2024 22:43:37 -0700 (PDT)
Message-ID: <5e5b2431-dd9b-488e-a0c9-578008e14208@kernel.dk>
Date: Thu, 11 Jul 2024 23:43:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 6.11-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Sending this one early as I'm out on vacation.

Here are the io_uring updates queued up for the 6.11 merge window.
Nothing major this time around, various minor improvements and
cleanups/fixes. This pull request contains:

- Add bind/listen opcodes. Main motivation is to support direct
  descriptors, to avoid needing a regular fd just for doing these two
  operations (Gabriel)

- Probe fixes (Gabriel)

- Treat io-wq work flags as atomics. Not fixing a real issue, but may
  as well and it silences a KCSAN warning (me)

- Cleanup of rsrc __set_current_state() usage (me)

- Add 64-bit for {m,f}advise operations (me)

- Improve performance of data ring messages (me)

- Fix for ring message overflow posting (Pavel)

- Fix for freezer interaction with TWA_NOTIFY_SIGNAL. Not strictly an
  io_uring thing, but since TWA_NOTIFY_SIGNAL was originally added for
  faster task_work signaling for io_uring, bundling it with this pull.
  (Pavel)

- Add Pavel as a co-maintainer

- Various cleanups (me, Thorsten)

Please pull!


The following changes since commit 6ba59ff4227927d3a8530fc2973b80e94b54d58f:

  Linux 6.10-rc4 (2024-06-16 13:40:16 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.11/io_uring-20240711

for you to fetch changes up to 943ad0b62e3c21f324c4884caa6cb4a871bca05c:

  kernel: rerun task_work while freezing in get_signal() (2024-07-11 01:51:44 -0600)

----------------------------------------------------------------
for-6.11/io_uring-20240711

----------------------------------------------------------------
Gabriel Krisman Bertazi (8):
      io_uring: Drop per-ctx dummy_ubuf
      io_uring/rsrc: Drop io_copy_iov in favor of iovec API
      net: Split a __sys_bind helper for io_uring
      net: Split a __sys_listen helper for io_uring
      io_uring: Introduce IORING_OP_BIND
      io_uring: Introduce IORING_OP_LISTEN
      io_uring: Fix probe of disabled operations
      io_uring: Allocate only necessary memory in io_probe

Jens Axboe (15):
      io_uring/eventfd: move to more idiomatic RCU free usage
      io_uring/eventfd: move eventfd handling to separate file
      io_uring: use 'state' consistently
      io_uring/io-wq: make io_wq_work flags atomic
      io_uring/rsrc: remove redundant __set_current_state() post schedule()
      io_uring/advise: support 64-bit lengths
      io_uring/msg_ring: tighten requirement for remote posting
      io_uring: add remote task_work execution helper
      io_uring: add io_add_aux_cqe() helper
      io_uring/msg_ring: improve handling of target CQE posting
      io_uring/msg_ring: add an alloc cache for io_kiocb entries
      io_uring/msg_ring: check for dead submitter task
      io_uring/msg_ring: use kmem_cache_free() to free request
      MAINTAINERS: change Pavel Begunkov from io_uring reviewer to maintainer
      io_uring/net: cleanup io_recv_finish() bundle handling

Pavel Begunkov (3):
      io_uring/msg_ring: fix overflow posting
      io_uring/io-wq: limit retrying worker initialisation
      kernel: rerun task_work while freezing in get_signal()

Thorsten Blum (1):
      io_uring/napi: Remove unnecessary s64 cast

 MAINTAINERS                    |   2 +-
 include/linux/io_uring_types.h |  14 ++--
 include/linux/socket.h         |   3 +
 include/uapi/linux/io_uring.h  |   2 +
 io_uring/Makefile              |   6 +-
 io_uring/advise.c              |  16 +++--
 io_uring/eventfd.c             | 160 +++++++++++++++++++++++++++++++++++++++++
 io_uring/eventfd.h             |   8 +++
 io_uring/io-wq.c               |  29 ++++----
 io_uring/io-wq.h               |   2 +-
 io_uring/io_uring.c            | 150 ++++++++++++++------------------------
 io_uring/io_uring.h            |   9 +--
 io_uring/msg_ring.c            | 122 +++++++++++++++++++------------
 io_uring/msg_ring.h            |   1 +
 io_uring/napi.c                |   2 +-
 io_uring/net.c                 |  84 +++++++++++++++++++---
 io_uring/net.h                 |   6 ++
 io_uring/opdef.c               |  34 +++++++++
 io_uring/opdef.h               |   4 +-
 io_uring/register.c            |  65 ++---------------
 io_uring/rsrc.c                |  63 ++++++----------
 kernel/signal.c                |   8 +++
 net/socket.c                   |  48 ++++++++-----
 23 files changed, 528 insertions(+), 310 deletions(-)
 create mode 100644 io_uring/eventfd.c
 create mode 100644 io_uring/eventfd.h

-- 
Jens Axboe


