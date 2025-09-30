Return-Path: <io-uring+bounces-9885-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8883CBAAD9F
	for <lists+io-uring@lfdr.de>; Tue, 30 Sep 2025 03:15:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3B177A645C
	for <lists+io-uring@lfdr.de>; Tue, 30 Sep 2025 01:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FB2834BA40;
	Tue, 30 Sep 2025 01:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hU3F7V/u"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460028C1F
	for <io-uring@vger.kernel.org>; Tue, 30 Sep 2025 01:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759194931; cv=none; b=s1Pz/9aZUsPO7kG60t7Xomr8o3EQX/eYmXtqJoKEPqG8qEHgNc8Mxf+zayLNIAuZv6sbYp3ZSWsmY+AmqVsY5nkn9sArdFKD2z6bgdNwy/WBVymZ8whDpTN0Aq3BYzpmM+ai4XD5NfTV3Q/MgItxnleI0h9zREvEp9NOQisuSXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759194931; c=relaxed/simple;
	bh=JDXF2bWe2Z2YF6wzgvOU/++e5IzXdr8KARyM4glxPVM=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=DsxLOZPKMkM7dibPQpGzNrFwm4ZrLXZlMNZovRG6u3WoS1iZ0VNQmZgIAKU9Rtd4AMwsnFq8ak0Nq7Eu0X3EeHAwUHGDhRuYHJ9ZdorhQKxGIPtHsU7jCGDPp57MDhoDtJQe5aId6EyNrx5VUyxvPfYk2HIENzPAejLOeod3Of8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hU3F7V/u; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-424d3c1256fso32672555ab.1
        for <io-uring@vger.kernel.org>; Mon, 29 Sep 2025 18:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759194926; x=1759799726; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t3NItORSAHIKfkk079VilBaAOcplmzKmeQRUDwrOsGU=;
        b=hU3F7V/upxisDhTFBlyVHXgOAqfSpHBQoT+FLmFKcBDiV5ERQ9Dvb7/HiYCCiIYS5v
         CiyrMPaJubqGz1+g70CgInoGm0hW0QIFvA+th5dCyfdjdRD+ZlaIEWh0alzDp5W9rXPZ
         /QWzVvtRAOC7DIuoj80s7szenzXVk212Z1b9wQMJWfc6RGAYEtERqTHEs6k6W8He/ZkV
         ieVbngir8i5oLo4MDJ4uxnoTsXkz3BSVIETTtK3FK/QAtWXNe7tVTe6bAqkOhn7zz7eh
         BmHgioaHGkCPvhkE/Wc+Po00KbQq/LD9KTh7IYX4m8nCyyYtq1WFHZjHr9amhiTYeDZx
         iu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759194926; x=1759799726;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t3NItORSAHIKfkk079VilBaAOcplmzKmeQRUDwrOsGU=;
        b=CLOptmVn5RQ9fQ65xYWKiXeWur2DdrHh4TbIX4QjcjWpIBBA5A4q4y7g7uMDWNue9G
         XTbU7mzVkFRIqzswesTygmRP6wF+xW807t6iNNLnhme5NPuqNGSFkJJyg+xcDQwFPZeV
         e7XawA/fhELeYAvh9ft+WqX7u4FdNEUxhtUU89ICkzIduxZx0EuWcSVc0x2mm3xEY7jP
         WkywuhnnSy5OnRaXNdM4b3tXN27Dh+V1GZhXd+l5deM+ORUWEBCruNmqpUDEEDwc95/9
         REu5CNrwJhuGYfgW1prooDUpEQPg4vh5Ucokn79qX0ViUVuZ3pTUZ8iU3poXrgq80sd/
         ppLw==
X-Gm-Message-State: AOJu0YyB3fJUIbLfiQs/9CguJr9hoJfEgTyXAmY3Ifen29rcQgQGI1+x
	KKpvhpPI2W7IwGjMb7O5ph5UUp369wxA5i0SvF1EfG0y8g/PKgONzJkWh21zThITb1P8OWkBxf7
	nFjcC
X-Gm-Gg: ASbGncta6ZrsPK+kdCLbJh9C1ZE2YNsv7L2Wl0cKLxqw2WON2DdIyLTcTcHYikWQIic
	CSavOp7ekYY3P/4R0gfkZUs4UKAMv/ll+kRCENK3xRm7rnSlzOv3VfEQxmg7zT9jhHiBXeu1S/Q
	u/mrGrX4mc8Ao9aAWiVZDhlAbXF2dQsrKizp7nmHIbQoZbOq7ulBdu31m3dbs8BA943icHGk4Yi
	5jmOXi8fhVVvwOCV582kZNtnXGoBoX1KCn2zVt60DZwfLfYkQtxacygebjfPmIJWUGsE3PvMEkE
	8RtXh3SnWPBuztAiYBVEfltnllg9a1Hcn7jG3qKRbHPHYvmSHBCm249NAofg+oxF9jq1v7NGS2j
	/qvQT3XfKNGEtXHwBrTRQ6ZoThsfw5oU=
X-Google-Smtp-Source: AGHT+IEefZXr9mnKmK2elb6HD54k18Ca4WRd+dqZlk0OO9R4IBYNMa+2iAtUjIg1kjp1y0xGAUwlbQ==
X-Received: by 2002:a05:6e02:3b84:b0:425:8bfc:b7da with SMTP id e9e14a558f8ab-42d0eb47d43mr44104495ab.7.1759194925945;
        Mon, 29 Sep 2025 18:15:25 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-56a6a5b0033sm5352557173.71.2025.09.29.18.15.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 18:15:25 -0700 (PDT)
Message-ID: <41da83f9-0816-46fe-bbda-db1b93d786bd@kernel.dk>
Date: Mon, 29 Sep 2025 19:15:24 -0600
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
Subject: [GIT PULL] io_uring changes for 6.18-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Here are the io_uring changes slated for the 6.18 merge window. Not
sending early as per usual due to travel and other things. This pull
request contains:

- Series storing ring provided buffers locally for the users, rather
  than stuff them into struct io_kiocb. These types of buffers must
  always be fully consumed or recycled in the current context, and
  leaving them in struct io_kiocb is hence not a good ideas as that
  struct has a vastly different life time. Basically just an
  architecture cleanup, that can help prevent issues with ring provided
  buffers in the future.

- Support for mixed CQE sizes in the same ring. Before this change, a CQ
  ring either used the default 16b CQEs, or it was setup with 32b CQE
  using IORING_SETUP_CQE32. For use cases where a few 32b CQEs were
  needed, this caused everything else to use big CQEs. This is wasteful
  both in terms of memory usage, but also memory bandwidth for the
  posted CQEs. With IORING_SETUP_CQE_MIXED, applications may use request
  types that post both normal 16b and big 32b CQEs on the same ring.

- Add helpers for async data management, to make it harder for opcode
  handlers to mess it up.

- Add support for multishot for uring_cmd, which ublk can use. This
  helps improve efficiency, by providing a persistent request type that
  can trigger multiple CQEs.

- Add initial support for ring feature querying. We had basic support
  for probe operations, but the API isn't great. Rather than expand
  that, add support for QUERY which is easily expandable and can cover a
  lot more cases than the existing probe support. This will help
  applications get a better idea of what operations are supported on a
  given host.

- zcrx improvements from Pavel
	- Improve refill entry alignment for better caching
	- Various cleanups, especially around deduplicating normal
	  memory vs dmabuf setup.
	- Generalisation of the niov size (Patch 12). It's still hard
	  coded to PAGE_SIZE on init, but will let the user to specify
	  the rx buffer length on setup.
	- Syscall / synchronous bufer return. It'll be used as a slow
	  fallback path for returning buffers when the refill queue is
	  full. Useful for tolerating slight queue size misconfiguration
	  or with inconsistent load.
	- Accounting more memory to cgroups.
	- Additional independent cleanups that will also be useful for
	  mutli-area support.

- Various fixes and cleanups

Note that this will throw a trivial conflict in io_uring/kbuf.c, where
the resolution is just to get rid of the void __user *ret argument as it
got killed by the io_br_sel provided ring buffer localization changes.

Please pull!


The following changes since commit 1b237f190eb3d36f52dffe07a40b5eb210280e00:

  Linux 6.17-rc3 (2025-08-24 12:04:12 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/for-6.18/io_uring-20250929

for you to fetch changes up to ef9f603fd3d4b7937f2cdbce40e47df0a54b2a55:

  io_uring/cmd: drop unused res2 param from io_uring_cmd_done() (2025-09-23 00:15:02 -0600)

----------------------------------------------------------------
for-6.18/io_uring-20250929

----------------------------------------------------------------
Caleb Sander Mateos (10):
      io_uring/cmd: deduplicate uring_cmd_flags checks
      io_uring/cmd: consolidate REQ_F_BUFFER_SELECT checks
      io_uring/register: drop redundant submitter_task check
      io_uring/uring_cmd: add io_uring_cmd_tw_t type alias
      io_uring/uring_cmd: correct io_uring_cmd_done() ret type
      io_uring/cmd: remove unused io_uring_cmd_iopoll_done()
      io_uring: remove WRITE_ONCE() in io_uring_create()
      io_uring: don't include filetable.h in io_uring.h
      io_uring/rsrc: respect submitter_task in io_register_clone_buffers()
      io_uring/cmd: drop unused res2 param from io_uring_cmd_done()

Jens Axboe (25):
      io_uring/kbuf: drop 'issue_flags' from io_put_kbuf(s)() arguments
      io_uring/net: don't use io_net_kbuf_recyle() for non-provided cases
      io_uring/net: clarify io_recv_buf_select() return value
      io_uring/kbuf: pass in struct io_buffer_list to commit/recycle helpers
      io_uring/kbuf: introduce struct io_br_sel
      io_uring/rw: recycle buffers manually for non-mshot reads
      io_uring/kbuf: use struct io_br_sel for multiple buffers picking
      io_uring/net: use struct io_br_sel->val as the recv finish value
      io_uring/net: use struct io_br_sel->val as the send finish value
      io_uring/kbuf: switch to storing struct io_buffer_list locally
      io_uring: remove async/poll related provided buffer recycles
      io_uring/kbuf: check for ring provided buffers first in recycling
      io_uring: remove io_ctx_cqe32() helper
      io_uring: add UAPI definitions for mixed CQE postings
      io_uring/fdinfo: handle mixed sized CQEs
      io_uring/trace: support completion tracing of mixed 32b CQEs
      io_uring: add support for IORING_SETUP_CQE_MIXED
      io_uring/nop: add support for IORING_SETUP_CQE_MIXED
      io_uring/uring_cmd: add support for IORING_SETUP_CQE_MIXED
      io_uring/zcrx: add support for IORING_SETUP_CQE_MIXED
      io_uring: add async data clear/free helpers
      io_uring/net: correct type for min_not_zero() cast
      io_uring/uring_cmd: fix __io_uring_cmd_do_in_task !CONFIG_IO_URING typo
      io_uring: correct size of overflow CQE calculation
      io_uring/uring_cmd: correct signature for io_uring_mshot_cmd_post_cqe()

Keith Busch (1):
      io_uring: fix nvme's 32b cqes on mixed cq

Marco Crivellari (2):
      io_uring: replace use of system_wq with system_percpu_wq
      io_uring: replace use of system_unbound_wq with system_dfl_wq

Ming Lei (2):
      io-uring: move `struct io_br_sel` into io_uring_types.h
      io_uring: uring_cmd: add multishot support

Pavel Begunkov (27):
      io_uring: add request poisoning
      io_uring/zctx: check chained notif contexts
      io_uring: add helper for *REGISTER_SEND_MSG_RING
      io_uring: add macros for avaliable flags
      io_uring: introduce io_uring querying
      io_uring/zcrx: improve rqe cache alignment
      io_uring/zcrx: replace memchar_inv with is_zero
      io_uring/zcrx: use page_pool_unref_and_test()
      io_uring/zcrx: remove extra io_zcrx_drop_netdev
      io_uring/zcrx: don't pass slot to io_zcrx_create_area
      io_uring/zcrx: move area reg checks into io_import_area
      io_uring/zcrx: check all niovs filled with dma addresses
      io_uring/zcrx: pass ifq to io_zcrx_alloc_fallback()
      io_uring/zcrx: deduplicate area mapping
      io_uring/zcrx: remove dmabuf_offset
      io_uring/zcrx: set sgt for umem area
      io_uring/zcrx: make niov size variable
      io_uring/zcrx: rename dma lock
      io_uring/zcrx: protect netdev with pp_lock
      io_uring/zcrx: reduce netmem scope in refill
      io_uring/zcrx: use guards for the refill lock
      io_uring/zcrx: don't adjust free cache space
      io_uring/zcrx: introduce io_parse_rqe()
      io_uring/zcrx: allow synchronous buffer return
      io_uring/zcrx: account niov arrays to cgroup
      io_uring/query: prevent infinite loops
      io_uring/query: cap number of queries

Thorsten Blum (1):
      io_uring: Replace kzalloc() + copy_from_user() with memdup_user()

 Documentation/networking/iou-zcrx.rst |   2 +-
 block/ioctl.c                         |   2 +-
 drivers/block/ublk_drv.c              |   6 +-
 drivers/nvme/host/ioctl.c             |   2 +-
 fs/btrfs/ioctl.c                      |   2 +-
 fs/fuse/dev_uring.c                   |   8 +-
 include/linux/io_uring/cmd.h          |  69 +++++---
 include/linux/io_uring_types.h        |  31 ++--
 include/linux/poison.h                |   3 +
 include/trace/events/io_uring.h       |   4 +-
 include/uapi/linux/io_uring.h         |  38 ++++-
 include/uapi/linux/io_uring/query.h   |  41 +++++
 io_uring/Makefile                     |   2 +-
 io_uring/cancel.c                     |   1 +
 io_uring/cmd_net.c                    |   3 +-
 io_uring/fdinfo.c                     |  24 +--
 io_uring/futex.c                      |  13 +-
 io_uring/io_uring.c                   | 145 +++++++++++------
 io_uring/io_uring.h                   | 120 ++++++++++++--
 io_uring/kbuf.c                       |  67 ++++----
 io_uring/kbuf.h                       |  39 +++--
 io_uring/net.c                        | 160 +++++++++---------
 io_uring/nop.c                        |  17 +-
 io_uring/notif.c                      |   5 +
 io_uring/opdef.c                      |   1 +
 io_uring/openclose.c                  |   1 +
 io_uring/poll.c                       |   4 -
 io_uring/query.c                      | 101 ++++++++++++
 io_uring/query.h                      |   9 ++
 io_uring/register.c                   |  60 ++++---
 io_uring/rsrc.c                       |   8 +
 io_uring/rw.c                         |  63 ++++----
 io_uring/splice.c                     |   1 +
 io_uring/uring_cmd.c                  |  83 ++++++++--
 io_uring/waitid.c                     |   4 +-
 io_uring/zcrx.c                       | 295 ++++++++++++++++++++++------------
 io_uring/zcrx.h                       |  19 ++-
 37 files changed, 1001 insertions(+), 452 deletions(-)
 create mode 100644 include/uapi/linux/io_uring/query.h
 create mode 100644 io_uring/query.c
 create mode 100644 io_uring/query.h

-- 
Jens Axboe


