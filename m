Return-Path: <io-uring+bounces-1873-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 800748C31BC
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 16:03:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AE22282013
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 14:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF80548E7;
	Sat, 11 May 2024 14:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KyTEQyJo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8D76FC6
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 14:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715436182; cv=none; b=Q9TA75HWPxkb9eGmiZwwiqOOMz6+GeDPqoyL6Pkpl9aETzbTYzj2xwZ3X9L7mZfIkntcB+gQtWFK48ZGtgY8SBwLg5hqBB6Qih927Ywly+gysQ6AtYpdQqktmc4/LgmhAhGVD47WY7k5AII34WC6KVjj/Bki9HfzpVViCC+YQR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715436182; c=relaxed/simple;
	bh=ueWuZRywM35d/JtJsFMt1yGfbJpGeN4q7Ci+auAKGKw=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Ps7n6X1/GpQWZc01eFi/QHINMDL5Qd5D+axNUt6tA16a0gTrMhZz+3LgxMGxdyyx16iqJ2+ycN0EyllmvKu/sqsQjJvB5lflpgrhu5My3oa6vk+K5sDT+Ks5P/gNnwC/XLfImlIpFjeUgyG2gtn/T6Dvi/Rtte2GRm+j7bUkt7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KyTEQyJo; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2b4b30702a5so774629a91.1
        for <io-uring@vger.kernel.org>; Sat, 11 May 2024 07:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715436177; x=1716040977; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=plHrfRTJ3W7ZexmCWQBOAGh/CW3PwuWRKgoDY4jVMs8=;
        b=KyTEQyJoAEfdC2JxAXXUIjD+SFocUgrwvw6jB6lVOruCCk4GV46kQ7qwGsbfnJuPFT
         TB28Y7dVFiP6ju2WMnBIzIeGvcJobk6IttGoruChLm6heTrhmrMHOv6L0GIJrUPMohIK
         DWhqnKMSaaLor4VfbK3epW/VjqBR/wmsVH2YRFHJCMwUel7yzl+C1Kl0IhGdIIO1WVZF
         ZhZZht4RCvsskdpSOZo6e4JlWtOgzncGJ4KXty5GjQOXboyyGQmtfHMh6jNj+T77FKKO
         SQCHfIdI7T3LXhx/zy7eAHajnyAZvXORukFQLC/zqWuvZnmYWjkHAqx4OUiaU2TsIhM/
         ccLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715436177; x=1716040977;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=plHrfRTJ3W7ZexmCWQBOAGh/CW3PwuWRKgoDY4jVMs8=;
        b=Gat3A1rYSb5HdyKPhdiSNHKWMqUMJLppz8aQu22dZjdeaz3HUaI6LtAXe+guGtgNL2
         U+u+2JXQTL9UoNHMqYIy7ZL4BFqV5s3WydQJOv9DZlI+djqYrV0NBM1+EqqWIHNGuctC
         wf7rY8WYnn2o1nGymC9pk/642Knho//sL175IqSzP+oclaiBoPCJwGMNqRBxjOuA4wHA
         MxcUeSk10VcM20qH/5t+VByiXSMUlLUdoBzez7fZbLMex95wQ3lEnYKLQM9nNhY7CDjJ
         4kpxvDt2dn8APTfIIzUx0RFk8vTccWhAdPNjtGPb2Spep3T8u5jqO++WsKGMyMAeqlza
         xisw==
X-Gm-Message-State: AOJu0Yz9uQOBf506RU3sCsW4Ho1LkE+SkRESUL/EMEK4jceK4vePlt3k
	92maK3VOVSFLyZQPo2Fc8nDG3GD4K4iQS4AYqfvUwg6cSCVHgdCB+ryCnz4sIQ2BHArTU34G+Lx
	9
X-Google-Smtp-Source: AGHT+IF+c6JIBIL4VLaTO1va15vgPQui7364HgrkdAqJG22lgjG9eeNIjsBeV8cMX1xrDZu8igu7tg==
X-Received: by 2002:a05:6a20:3ca9:b0:1af:aeb7:7a10 with SMTP id adf61e73a8af0-1afde07d850mr6690174637.1.1715436176958;
        Sat, 11 May 2024 07:02:56 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6340a6327e8sm4777854a12.8.2024.05.11.07.02.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 May 2024 07:02:56 -0700 (PDT)
Message-ID: <fef75ea0-11b4-4815-8c66-7b19555b279d@kernel.dk>
Date: Sat, 11 May 2024 08:02:55 -0600
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
Subject: [GIT PULL] io_uring updates for 6.10-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Here are the io_uring updates and fixes for the 6.10 kernel merge
window. This pull request contains:

- Greatly improve send zerocopy performance, by enabling coalescing of
  sent buffers. MSG_ZEROCOPY already does this with send(2) and
  sendmsg(2), but the io_uring side did not. In local testing, the
  crossover point for send zerocopy being faster is now around 3000 byte
  packets, and it performs better than the sync syscall variants as
  well. This feature relies on a shared branch with net-next, which was
  pulled into both branches.

- Unification of how async preparation is done across opcodes.
  Previously, opcodes that required extra memory for async retry would
  allocate that as needed, using on-stack state until that was the case.
  If async retry was needed, the on-stack state was adjusted
  appropriately for a retry and then copied to the allocated memory.
  This led to some fragile and ugly code, particularly for read/write
  handling, and made storage retries more difficult than they needed to
  be. Allocate the memory upfront, as it's cheap from our pools, and use
  that state consistently both initially and also from the retry side.

- Move away from using remap_pfn_range() for mapping the rings. This is
  really not the right interface to use and can cause lifetime issues or
  leaks. Additionally, it means the ring sq/cq arrays need to be
  physically contigious, which can cause problems in production with
  larger rings when services are restarted, as memory can be very
  fragmented at that point. Move to using vm_insert_page(s) for the ring
  sq/cq arrays, and apply the same treatment to mapped ring provided
  buffers. This also helps unify the code we have dealing with
  allocating and mapping memory. Hard to see in the diffstat as we're
  adding a few features as well, but this kills about ~400 lines of code
  from the codebase as well.

- Add support for bundles for send/recv. When used with provided
  buffers, bundles support sending or receiving more than one buffer at
  the time, improving the efficiency by only needing to call into the
  networking stack once for multiple sends or receives.

- Tweaks for our accept operations, supporting both a DONTWAIT flag for
  skipping poll arm and retry if we can, and a POLLFIRST flag that the
  application can use to skip the initial accept attempt and rely purely
  on poll for triggering the operation. Both of these have identical
  flags on the receive side already.

- Make the task_work ctx locking unconditional. We had various code
  paths here that would do a mix of lock/trylock and set the task_work
  state to whether or not it was locked. All of that goes away, we lock
  it unconditionally and get rid of the state flag indicating whether
  it's locked or not. The state struct still exists as an empty type,
  can go away in the future.

- Add support for specifying NOP completion values, allowing it to be
  used for error handling testing.

- Use set/test bit for io-wq worker flags. Not strictly needed, but also
  doesn't hurt and helps silence a KCSAN warning.

- Cleanups for io-wq locking and work assignments, closing a tiny race
  where cancelations would not be able to find the work item reliably.

- Misc fixes, cleanups, and improvements.

Please pull!


The following changes since commit 0bbac3facb5d6cc0171c45c9873a2dc96bea9680:

  Linux 6.9-rc4 (2024-04-14 13:38:39 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.10/io_uring-20240511

for you to fetch changes up to deb1e496a83557896fe0cca0b8af01c2a97c0dc6:

  io_uring: support to inject result for NOP (2024-05-10 06:09:45 -0600)

----------------------------------------------------------------
for-6.10/io_uring-20240511

----------------------------------------------------------------
Breno Leitao (1):
      io_uring/io-wq: Use set_bit() and test_bit() at worker->flags

Gabriel Krisman Bertazi (4):
      io_uring: Avoid anonymous enums in io_uring uapi
      io-wq: write next_work before dropping acct_lock
      io-wq: Drop intermediate step between pending list and active work
      io_uring: Require zeroed sqe->len on provided-buffers send

Jens Axboe (52):
      nvme/io_uring: use helper for polled completions
      io_uring: flush delayed fallback task_work in cancelation
      io_uring: remove timeout/poll specific cancelations
      io_uring/alloc_cache: shrink default max entries from 512 to 128
      io_uring/net: switch io_send() and io_send_zc() to using io_async_msghdr
      io_uring/net: switch io_recv() to using io_async_msghdr
      io_uring/net: unify cleanup handling
      io_uring/net: always setup an io_async_msghdr
      io_uring/net: always set kmsg->msg.msg_control_user before issue
      io_uring/net: get rid of ->prep_async() for receive side
      io_uring/net: get rid of ->prep_async() for send side
      io_uring: kill io_msg_alloc_async_prep()
      io_uring/net: remove (now) dead code in io_netmsg_recycle()
      io_uring/net: add iovec recycling
      io_uring/net: drop 'kmsg' parameter from io_req_msg_cleanup()
      io_uring/rw: always setup io_async_rw for read/write requests
      io_uring: get rid of struct io_rw_state
      io_uring/rw: cleanup retry path
      io_uring/rw: add iovec recycling
      io_uring/net: move connect to always using async data
      io_uring/uring_cmd: switch to always allocating async data
      io_uring/uring_cmd: defer SQE copying until it's needed
      io_uring: drop ->prep_async()
      io_uring/alloc_cache: switch to array based caching
      io_uring/poll: shrink alloc cache size to 32
      io_uring: refill request cache in memory order
      io_uring: re-arrange Makefile order
      io_uring: use the right type for work_llist empty check
      mm: add nommu variant of vm_insert_pages()
      io_uring: get rid of remap_pfn_range() for mapping rings/sqes
      io_uring: use vmap() for ring mapping
      io_uring: unify io_pin_pages()
      io_uring/kbuf: vmap pinned buffer ring
      io_uring/kbuf: use vm_insert_pages() for mmap'ed pbuf ring
      io_uring: use unpin_user_pages() where appropriate
      io_uring: move mapping/allocation helpers to a separate file
      io_uring: fix warnings on shadow variables
      io_uring/kbuf: remove dead define
      io_uring: ensure overflow entries are dropped when ring is exiting
      io_uring/sqpoll: work around a potential audit memory leak
      io_uring/rw: ensure retry condition isn't lost
      io_uring/net: add generic multishot retry helper
      io_uring/net: add provided buffer support for IORING_OP_SEND
      io_uring/kbuf: add helpers for getting/peeking multiple buffers
      io_uring/net: support bundles for send
      io_uring/net: support bundles for recv
      Merge branch 'for-uring-ubufops' of git://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux into for-6.10/io_uring
      io_uring/rw: reinstate thread check for retries
      io_uring/msg_ring: cleanup posting to IOPOLL vs !IOPOLL ring
      io_uring/filetable: don't unnecessarily clear/reset bitmap
      io_uring/net: add IORING_ACCEPT_DONTWAIT flag
      io_uring/net: add IORING_ACCEPT_POLL_FIRST flag

Jiapeng Chong (1):
      io_uring: Remove unused function

Joel Granados (1):
      io_uring: Remove the now superfluous sentinel elements from ctl_table array

Ming Lei (4):
      io_uring: kill dead code in io_req_complete_post
      io_uring: return void from io_put_kbuf_comp()
      io_uring: fail NOP if non-zero op flags is passed in
      io_uring: support to inject result for NOP

Pavel Begunkov (33):
      io_uring/cmd: move io_uring_try_cancel_uring_cmd()
      io_uring/cmd: kill one issue_flags to tw conversion
      io_uring/cmd: fix tw <-> issue_flags conversion
      io_uring/cmd: document some uring_cmd related helpers
      io_uring/rw: avoid punting to io-wq directly
      io_uring: force tw ctx locking
      io_uring: remove struct io_tw_state::locked
      io_uring: refactor io_fill_cqe_req_aux
      io_uring: get rid of intermediate aux cqe caches
      io_uring: remove current check from complete_post
      io_uring: refactor io_req_complete_post()
      io_uring: clean up io_lockdep_assert_cq_locked
      io_uring: turn implicit assumptions into a warning
      io_uring: remove async request cache
      io_uring: remove io_req_put_rsrc_locked()
      io_uring/net: merge ubuf sendzc callbacks
      io_uring/net: get rid of io_notif_complete_tw_ext
      io_uring/net: set MSG_ZEROCOPY for sendzc in advance
      io_uring: separate header for exported net bits
      io_uring: unexport io_req_cqe_overflow()
      io_uring: remove extra SQPOLL overflow flush
      io_uring: open code io_cqring_overflow_flush()
      io_uring: always lock __io_cqring_overflow_flush
      io_uring: consolidate overflow flushing
      io_uring/notif: refactor io_tx_ubuf_complete()
      io_uring/notif: remove ctx var from io_notif_tw_complete
      io_uring/notif: shrink account_pages to u32
      net: extend ubuf_info callback to ops structure
      net: add callback for setting a ubuf_info to skb
      io_uring/notif: simplify io_notif_flush()
      io_uring/notif: implement notification stacking
      io_uring/net: fix sendzc lazy wake polling
      io_uring/notif: disable LAZY_WAKE for linked notifs

Ruyi Zhang (1):
      io_uring/timeout: remove duplicate initialization of the io_timeout list.

linke li (1):
      io_uring/msg_ring: reuse ctx->submitter_task read using READ_ONCE instead of re-reading it

 drivers/net/tap.c                   |   2 +-
 drivers/net/tun.c                   |   2 +-
 drivers/net/xen-netback/common.h    |   5 +-
 drivers/net/xen-netback/interface.c |   2 +-
 drivers/net/xen-netback/netback.c   |  11 +-
 drivers/nvme/host/ioctl.c           |  15 +-
 drivers/vhost/net.c                 |   8 +-
 include/linux/io_uring.h            |   6 -
 include/linux/io_uring/cmd.h        |  24 +
 include/linux/io_uring/net.h        |  18 +
 include/linux/io_uring_types.h      |  19 +-
 include/linux/skbuff.h              |  21 +-
 include/uapi/linux/io_uring.h       |  38 +-
 io_uring/Makefile                   |  15 +-
 io_uring/alloc_cache.h              |  59 ++-
 io_uring/cancel.c                   |   4 +-
 io_uring/fdinfo.c                   |   4 +-
 io_uring/filetable.c                |   4 +-
 io_uring/futex.c                    |  30 +-
 io_uring/futex.h                    |   5 +-
 io_uring/io-wq.c                    |  67 +--
 io_uring/io_uring.c                 | 665 +++++-----------------------
 io_uring/io_uring.h                 |  33 +-
 io_uring/kbuf.c                     | 318 ++++++++------
 io_uring/kbuf.h                     |  64 ++-
 io_uring/memmap.c                   | 336 ++++++++++++++
 io_uring/memmap.h                   |  25 ++
 io_uring/msg_ring.c                 |  12 +-
 io_uring/net.c                      | 852 +++++++++++++++++++++---------------
 io_uring/net.h                      |  29 +-
 io_uring/nop.c                      |  26 +-
 io_uring/notif.c                    | 108 +++--
 io_uring/notif.h                    |  13 +-
 io_uring/opdef.c                    |  65 ++-
 io_uring/opdef.h                    |   9 +-
 io_uring/poll.c                     |  15 +-
 io_uring/poll.h                     |   9 +-
 io_uring/refs.h                     |   7 +
 io_uring/register.c                 |   3 +-
 io_uring/rsrc.c                     |  47 +-
 io_uring/rsrc.h                     |  13 +-
 io_uring/rw.c                       | 585 ++++++++++++-------------
 io_uring/rw.h                       |  25 +-
 io_uring/sqpoll.c                   |   8 +
 io_uring/timeout.c                  |   9 +-
 io_uring/uring_cmd.c                | 122 +++++-
 io_uring/uring_cmd.h                |   8 +-
 io_uring/waitid.c                   |   2 +-
 mm/nommu.c                          |   7 +
 net/core/skbuff.c                   |  36 +-
 net/socket.c                        |   2 +-
 51 files changed, 2050 insertions(+), 1762 deletions(-)
 create mode 100644 include/linux/io_uring/net.h
 create mode 100644 io_uring/memmap.c
 create mode 100644 io_uring/memmap.h

-- 
Jens Axboe


