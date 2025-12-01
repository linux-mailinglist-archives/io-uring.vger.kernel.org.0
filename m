Return-Path: <io-uring+bounces-10869-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 797AEC981DC
	for <lists+io-uring@lfdr.de>; Mon, 01 Dec 2025 16:51:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E36764E16AE
	for <lists+io-uring@lfdr.de>; Mon,  1 Dec 2025 15:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCB5C30AACB;
	Mon,  1 Dec 2025 15:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iZ1UrEKa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0228D332EAD
	for <io-uring@vger.kernel.org>; Mon,  1 Dec 2025 15:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764604315; cv=none; b=XAa4ihDrpD4dUnLCKKK0jiep1ig76ojlrF3gDIBleVQwmVSheP9V9kYPxALt+T0sE2p7jFNJRhZIgMX7TOLsoZlR6yqj1j15O3suZS68RhD6xKSzCgY65Bo9G7P0RceiZ0PoKE+iCHu9KZ4LLssb9rBrCI5L2hE8TF/J9g2Mv1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764604315; c=relaxed/simple;
	bh=UilB4RdIQWa5lkC0MGcoFWATFGHlxaGMDIgG+Rin4LQ=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=DyGzoBaePCQLRPq+yCjRCYQc1E5MLaPVOMBeUV3lRbnSE+c/AR4vMsJYjh+TxSTZFNxTnH6+7rsVpjb4+FZFxYM33sVpsDtZnuscYXedgO2VZJ5UY4TtSJX46RLdaUs0bl1gUd/lb0bjuH9LRhR8RUtv2/c2DksU0xJp3VAie7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iZ1UrEKa; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-3ec3cdcda4eso2978304fac.1
        for <io-uring@vger.kernel.org>; Mon, 01 Dec 2025 07:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764604308; x=1765209108; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RB/yl0OPu1Lusa6V7QA/LefZ6s8yXfN+HezREPCiwXQ=;
        b=iZ1UrEKanzn2mOZGgQKv0RQBkqFVoFxHqpbTz8KW3elFKJTXpv6N1z1RQJHJbcajEf
         zGkvioDpvAPIrDTXofhDKHw4Dv/cHHy7crtzPBJ4IWHsyolIK7V5VHAK7NVrjYrPbah9
         1BusbhVD/He0oWQhwLS7Bj8PHa8wWo03P+x8t4JPjVecAXD4fJRn4Xq4MJBtJlfIlqqq
         LdWRsLlRuMAls4kXax8KrDcymXS6y5R/wD2m5rM4b+f7dHfhtHFdqEzmeUSYqgShJepY
         9NgZDpj5SvIU7Uszb5hgJo3z9DpbrOwkARQIWHKVrn4bubtjmjUgTvvJY49cbItHutcj
         Z+Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764604308; x=1765209108;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RB/yl0OPu1Lusa6V7QA/LefZ6s8yXfN+HezREPCiwXQ=;
        b=AjLE3deBHHwzFg/j8EcLurRa5k44lGdA4TNhGnov9JcE8AhA8s2jtS6Rm+nzGH3eN7
         Nnq4rLWXcyh34EjdmLyiq2jn6KrcjsLZLV14NbnsmsBMJU+LDXyVqlCA5+ukeCHTp+7J
         k6N4xpIDNAFXpLcC2fYANGktO1dPGVqXJMPU8MHL+GCCKZIo65rgIdEWKZXTWQGsE/tG
         cfQnzv7lo/u/ncxaV+7KJ6LR+hYGVCIWsxyBtTlXW1GX7adWPZIws/6C/gEUscoYxyg2
         m5fVkDhc/kCqoSyN9tSWbP5gzrm37g9rS3NDGLU0SX56rFvNbIPUJu/26SvGOBcr/Dei
         M+jQ==
X-Gm-Message-State: AOJu0YxnPe4oswvoFbhkT5h9xuzdXlYjhpaMGvewOXIaI2cKt5uGjexZ
	MIVMrsHfoqgk2oi/T+yvcLw7IZOgx0Oga2IOgMs2vYgK2Ur+ktvS2uplCMou1mCl9WOSC1fJTXZ
	Vr9B0n4w=
X-Gm-Gg: ASbGncsiDNjsWC77rZVBUdEHrQEpkgj26QYEUUzhOVFdR60evd9C6zls3JCtxmoc8lx
	Md4iGFoAp4RQljjyDschygZwvK7VC+n1CeY8yKRnsv26JZHr0lfmfngFOk/ngQZ3F0YU9X++zck
	BeXCUoWK4j0DfziUiMct2erQchOyYO2WLPLxu/tL/VgBOxMWoONMgnKR1Ufa1x3UgiPr5wgzw/w
	L1V60zj0ka2Id2/vgJuiHqQ8cFIjpuEImjjSLR+12+ilCu8LMwlVrLVxvVFSBgBHmmfkY1WmzyJ
	+t1y8V+JC2t/8xKG0SocvMAWgemzeLsEk11jPXrNX5OgYSnwhfpus2Vz5fbNQqDX4jWn7bW3Hwa
	tsQHCrGII2dMpzygHugV7V0e83747yJvFtAdvydHC/VfsUGYI6H4Eg23GtpyxWY4RMcF43un5wf
	l+35x+9esozGF1/Juh
X-Google-Smtp-Source: AGHT+IHCDwBs0b/tsPIxjdqD7tbrRQrqB51kBcKeGKzN0SeYy+r9ctntCSsCyeE0IDKsra2JE4k43Q==
X-Received: by 2002:a05:6870:70a4:b0:3e8:973e:e011 with SMTP id 586e51a60fabf-3ed1ffd81b2mr13066109fac.47.1764604307917;
        Mon, 01 Dec 2025 07:51:47 -0800 (PST)
Received: from [192.168.1.99] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3f0dca01676sm5351695fac.5.2025.12.01.07.51.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Dec 2025 07:51:47 -0800 (PST)
Message-ID: <973ff83d-995b-4b0a-a800-3941aa0082ef@kernel.dk>
Date: Mon, 1 Dec 2025 08:51:46 -0700
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
Subject: [GIT PULL] io_uring updates for 6.19-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Here are the io_uring changes queued for the 6.19 kernel release. This
pull request contains:

- Unify how task_work cancelations are detected, placing it in the
  task_work running state rather than needing to check the task state.

- Series cleaning up and moving the cancelation code to where it
  belongs, in cancel.c.

- Cleanup of waitid argument handling.

- Cleanup of futex argument handling.

- Add support for mixed sized SQEs. 6.18 added support for mixed sized
  CQEs, improving flexibility and efficiency of workloads that need big
  CQEs. This adds similar support for SQEs, where the occasional need
  for a 128b SQE doesn't necessitate having all SQEs be 128b in size.

- Introduce zcrx and SQ/CQ layout queries. The former returns what zcrx
  features are available. And both return the ring size information to
  help with allocation size calculation for user provided rings like
  IORING_SETUP_NO_MMAP and IORING_MEM_REGION_TYPE_USER

- Zcrx updates for 6.19. It includes a bunch of small patches,
  IORING_REGISTER_ZCRX_CTRL and RQ flushing and David's work on sharing
  zcrx b/w multiple io_uring instances.

- Series cleaning up ring initializations, notable deduplicating ring
  size and offset calculations. It also moves most of the checking
  before doing any allocations, making the code simpler.

- Add support for getsockname and getpeername, which is mostly a trivial
  hookup after a bit of refactoring on the networking side.

- Various fixes and cleanups.

Please pull!


The following changes since commit 2d0e88f3fd1dcb37072d499c36162baf5b009d41:

  io_uring/rsrc: don't use blk_rq_nr_phys_segments() as number of bvecs (2025-11-12 08:25:33 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/for-6.19/io_uring-20251201

for you to fetch changes up to 5d24321e4c159088604512d7a5c5cf634d23e01a:

  io_uring: Introduce getsockname io_uring cmd (2025-11-26 13:45:23 -0700)

----------------------------------------------------------------
for-6.19/io_uring-20251201

----------------------------------------------------------------
Alok Tiwari (1):
      io_uring: fix typos and comment wording

Caleb Sander Mateos (5):
      io_uring: only call io_should_terminate_tw() once for ctx
      io_uring: add wrapper type for io_req_tw_func_t arg
      io_uring/uring_cmd: avoid double indirect call in task work dispatch
      io_uring/memmap: return bool from io_mem_alloc_compound()
      io_uring/query: drop unused io_handle_query_entry() ctx arg

David Wei (12):
      io_uring/memmap: remove unneeded io_ring_ctx arg
      io_uring/memmap: refactor io_free_region() to take user_struct param
      io_uring/rsrc: refactor io_{un}account_mem() to take {user,mm}_struct param
      io_uring/zcrx: add io_zcrx_ifq arg to io_zcrx_free_area()
      io_uring/zcrx: add user_struct and mm_struct to io_zcrx_ifq
      io_uring/zcrx: move io_unregister_zcrx_ifqs() down
      io_uring/zcrx: reverse ifq refcount
      net: export netdev_get_by_index_lock()
      io_uring/zcrx: call netdev_queue_get_dma_dev() under instance lock
      io_uring/zcrx: move io_zcrx_scrub() and dependencies up
      io_uring/zcrx: add io_fill_zcrx_offsets()
      io_uring/zcrx: share an ifq between rings

Gabriel Krisman Bertazi (3):
      socket: Unify getsockname and getpeername implementation
      socket: Split out a getsockname helper for io_uring
      io_uring: Introduce getsockname io_uring cmd

Jens Axboe (17):
      io_uring: unify task_work cancelation checks
      io_uring/waitid: have io_waitid_complete() remove wait queue entry
      io_uring/waitid: use io_waitid_remove_wq() consistently
      io_uring/fdinfo: cap SQ iteration at max SQ entries
      io_uring/fdinfo: validate opcode before checking if it's an 128b one
      io_uring/slist: remove unused wq list splice helpers
      io_uring/rsrc: use get/put_user() for integer copy
      io_uring/memmap: remove dead io_create_region_mmap_safe() declaration
      io_uring/cancel: move request/task cancelation logic into cancel.c
      io_uring/cancel: move __io_uring_cancel() into cancel.c
      io_uring/cancel: move cancelation code from io_uring.c to cancel.c
      io_uring/futex: move futexv async data handling to struct io_futexv_data
      io_uring/futex: move futexv owned status to struct io_futexv_data
      Merge branch 'io_uring-6.18' into for-6.19/io_uring
      Merge branch 'zcrx-query-6.19' into for-6.19/io_uring
      Merge branch 'zcrx-updates-6.19' into for-6.19/io_uring
      io_uring/register: use correct location for io_rings_layout

Joanne Koong (1):
      io_uring/kbuf: remove obsolete buf_nr_pages and update comments

Keith Busch (2):
      io_uring: add support for IORING_SETUP_SQE_MIXED
      io_uring/fdinfo: show SQEs for no array setup

Pavel Begunkov (29):
      io_uring: deduplicate array_size in io_allocate_scq_urings
      io_uring: sanity check sizes before attempting allocation
      io_uring: use no mmap safe region helpers on resizing
      io_uring: remove extra args from io_register_free_rings
      io_uring: don't free never created regions
      io_uring/kbuf: use io_create_region for kbuf creation
      io_uring: only publish fully handled mem region
      io_uring: check for user passing 0 nr_submit
      io_uring: use WRITE_ONCE for user shared memory
      io_uring/query: buffer size calculations with a union
      io_uring: add helper calculating region byte size
      io_uring: pass sq entries in the params struct
      io_uring: use mem_is_zero to check ring params
      io_uring: move flags check to io_uring_sanitise_params
      io_uring: refactor rings_size nosqarray handling
      io_uring: use size_add helpers for ring offsets
      io_uring: convert params to pointer in ring reisze
      io_uring: introduce struct io_ctx_config
      io_uring: keep ring laoyut in a structure
      io_uring: pre-calculate scq layout
      io_uring: move cq/sq user offset init around
      io_uring/query: introduce zcrx query
      io_uring/query: introduce rings info query
      io_uring/zcrx: convert to use netmem_desc
      io_uring/zcrx: elide passing msg flags
      io_uring/zcrx: introduce IORING_REGISTER_ZCRX_CTRL
      io_uring/zcrx: add sync refill queue flushing
      io_uring/zcrx: count zcrx users
      io_uring/zcrx: export zcrx via a file

Pedro Demarchi Gomes (1):
      io_uring/zcrx: use folio_nr_pages() instead of shift operation

 block/ioctl.c                       |   6 +-
 drivers/block/ublk_drv.c            |  22 +-
 drivers/nvme/host/ioctl.c           |   7 +-
 fs/btrfs/ioctl.c                    |   5 +-
 fs/fuse/dev_uring.c                 |   7 +-
 include/linux/io_uring/cmd.h        |  22 +-
 include/linux/io_uring_types.h      |  12 +-
 include/linux/netdevice.h           |   1 +
 include/linux/socket.h              |   6 +-
 include/uapi/linux/io_uring.h       |  43 +++
 include/uapi/linux/io_uring/query.h |  24 ++
 io_uring/cancel.c                   | 270 ++++++++++++++
 io_uring/cancel.h                   |   8 +-
 io_uring/cmd_net.c                  |  22 ++
 io_uring/fdinfo.c                   |  37 +-
 io_uring/futex.c                    |  57 +--
 io_uring/io_uring.c                 | 547 ++++++++--------------------
 io_uring/io_uring.h                 |  63 ++--
 io_uring/kbuf.c                     |   6 +-
 io_uring/kbuf.h                     |   5 +-
 io_uring/memmap.c                   |  59 +--
 io_uring/memmap.h                   |  24 +-
 io_uring/msg_ring.c                 |   3 +-
 io_uring/net.c                      |   7 +-
 io_uring/notif.c                    |   7 +-
 io_uring/opdef.c                    |  26 ++
 io_uring/opdef.h                    |   2 +
 io_uring/poll.c                     |  13 +-
 io_uring/poll.h                     |   2 +-
 io_uring/query.c                    |  55 ++-
 io_uring/query.h                    |   2 +-
 io_uring/register.c                 | 105 +++---
 io_uring/rsrc.c                     |  30 +-
 io_uring/rsrc.h                     |   6 +-
 io_uring/rw.c                       |  11 +-
 io_uring/rw.h                       |   2 +-
 io_uring/slist.h                    |  18 -
 io_uring/sqpoll.c                   |   1 +
 io_uring/timeout.c                  |  20 +-
 io_uring/uring_cmd.c                |  34 +-
 io_uring/waitid.c                   |  48 ++-
 io_uring/zcrx.c                     | 421 ++++++++++++++++-----
 io_uring/zcrx.h                     |  16 +-
 net/compat.c                        |   4 +-
 net/core/dev.h                      |   1 -
 net/socket.c                        |  67 ++--
 46 files changed, 1298 insertions(+), 856 deletions(-)

-- 
Jens Axboe


