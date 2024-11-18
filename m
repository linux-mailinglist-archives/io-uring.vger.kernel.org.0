Return-Path: <io-uring+bounces-4771-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3076A9D12E9
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 15:24:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5316284261
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 14:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F0721A00EE;
	Mon, 18 Nov 2024 14:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="069dxj2q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080691A265E
	for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 14:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731939787; cv=none; b=H9D+b5q4rWv+MT56TmNqYdy2RzRW8I0qVYz8sSwb39l0HOUlrtW6JzwZkLKBKfTAlxW6EnBR+xSXLrbeMt0pRN3C2pYMZKfOKJJfOLRFmY7rQ/N1+a8kLx1C7VkgneLJTXW9HlEjmu9yJRMG/jVikiEXkQcUu/KACcNIbn9b7n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731939787; c=relaxed/simple;
	bh=FM+NTFpYsgJOuhZJkAMqgcukbqzz9hs9sx8ySGSKUlQ=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=M2JCpL54+MY/002y42wJYWIcTx0P6Pg8vnJV0kOWAIAWtj+YcOl1t7Y1JkY2aS+2u8wXCee8HAV6rj7MZLXkuV8PJ69KDKlpT43D/tCYn+9S6JHxGjxH0B6tOxcWidWL340Vr0xEx9Lwe9LyLdL2qGh/f8JJVzaIZBp1lyC/0mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=069dxj2q; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3e7bb53fdb1so2023896b6e.3
        for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 06:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731939782; x=1732544582; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1PdnaaBaI4oqWEHDeRKbFs4e6O4rjzeXkgAsIqSqNao=;
        b=069dxj2qaul3kPRzQEvw9/uL/0a9GpTZCt919SdVOSADGPr0XX7xmZ/a4VfvjHgXVT
         Qwg7/ZSI1yL2fB0Nxx86d6vu1Zw8peABUrXHJgijOLAZE1uZ26wmBjydCuttEsJx+ZzL
         Ct0bnc3d/GHX616SOi4dkXaemUH9oir2Y27fdd73Wor0Rg2vQVuK2URPQqdZUhYb5OPE
         mMePErsIO/D+7EIu+p7vp5HX9N9NaI9G5f8DSR4P8oHorJaJ7cevIQZgl7zSpGCOFHz5
         zv7X/S553S5FYgcwbBQBeLeYNwzCs13PK3M2InYpIAou1JXvb2uxH0luEaYHvhseVL5J
         qTcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731939782; x=1732544582;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1PdnaaBaI4oqWEHDeRKbFs4e6O4rjzeXkgAsIqSqNao=;
        b=mBssaO9WngVP/s5DZdabYUXzvUm/khNGslFGPt5JZelCNLOmqkm4Bv3KG9UVidt91H
         ZuVaDdJrovjX93T/Gb373VnSbkks4VTFt8Llhktfhs5sl7mjl1tYvvcMc9ICYtXBPjJ0
         YFXQcmlB2ugq0b4unRxDRujtbutVtfjUd1E+6X2T97hSY5na9P+VpjqpF/HgkXHaHHnG
         jMGPZQuu/jQfYovWI/tfJic/vjqRd1XmE0cK0vJTZiF0V001MBD++A3TB4FDJbSXw65b
         THNIlyRWHvgJEEs2UddE0JewU1q/uzpq9neAzM63M4aKL4nuAwaIZWhvoBVLNXenSOj2
         zntg==
X-Gm-Message-State: AOJu0YybpCZ91XYgjraUkWA8I2RdBcvR7642UXJ4tSTK+ZQMO9pWey9p
	M7t8PEcpjGK98GDC68TOwCFNTyWuXb00iOw9++GO62qFTTSSZyUJsxT7JVFdPHrf0AXkCxRErUF
	GbiE=
X-Google-Smtp-Source: AGHT+IEdHdPTzKZ2+D6VuWbjCN5M/TKRTQxIKNpMsBiK4W8Cm6MqxjjmqnmLWkkdiFtQ7MD0B3fXIA==
X-Received: by 2002:a05:6808:1a26:b0:3e6:147c:b41d with SMTP id 5614622812f47-3e7bc8702fdmr9425464b6e.35.1731939781647;
        Mon, 18 Nov 2024 06:23:01 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e7bcd93efdsm2853385b6e.51.2024.11.18.06.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2024 06:23:00 -0800 (PST)
Message-ID: <ad411989-3695-4ac9-9f96-b95f71918285@kernel.dk>
Date: Mon, 18 Nov 2024 07:22:59 -0700
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
Subject: [GIT PULL] io_uring changes for 6.13-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Here are the io_uring changes slated for the 6.13 kernel release. This
pull request contains:

- Cleanups of the eventfd handling code, making it fully private.

- Support for sending a sync message to another ring, without having a
  ring available to send a normal async message.

- Get rid of the separate unlocked hash table, unify everything around
  the single locked one.

- Add support for ring resizing. It can be hard to appropriately size
  the CQ ring upfront, if the application doesn't know how busy it will
  be. This results in applications sizing rings for the most busy case,
  which can be wasteful. With ring resizing, they can start small and
  grow the ring, if needed.

- Add support for fixed wait regions, rather than needing to copy the
  same wait data tons of times for each wait operation.

- Rewrite the resource node handling, which before was serialized per
  ring. This caused issues with particularly fixed files, where one file
  waiting on IO could hold up putting and freeing of other unrelated
  files. Now each node is handled separately. New code is much simpler
  too, and was a net 250 line reduction in code.

- Add support for just doing partial buffer clones, rather than always
  cloning the entire buffer table.

- Series adding static NAPI support, where a specific NAPI instance is
  used rather than having a list of them available that need lookup.

- Add support for mapped regions, and also convert the fixed wait
  support mentioned above to that concept. This avoids doing special
  mappings for various planned features, and folds the existing
  registered wait into that too.

- Add support for hybrid IO polling, which is a variant of strict IOPOLL
  but with an initial sleep delay to avoid spinning too early and
  wasting resources on devices that aren't necessarily in the < 5 usec
  category wrt latencies.

- Various cleanups and little fixes.

Please pull!


The following changes since commit 42f7652d3eb527d03665b09edac47f85fb600924:

  Linux 6.12-rc4 (2024-10-20 15:19:38 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.13/io_uring-20241118

for you to fetch changes up to a652958888fb1ada3e4f6b548576c2d2c1b60d66:

  io_uring/region: fix error codes after failed vmap (2024-11-17 09:01:35 -0700)

----------------------------------------------------------------
for-6.13/io_uring-20241118

----------------------------------------------------------------
Al Viro (1):
      switch io_msg_ring() to CLASS(fd)

Jens Axboe (50):
      io_uring/eventfd: abstract out ev_fd put helper
      io_uring/eventfd: check for the need to async notifier earlier
      io_uring/eventfd: move actual signaling part into separate helper
      io_uring/eventfd: move trigger check into a helper
      io_uring/eventfd: abstract out ev_fd grab + release helpers
      io_uring/eventfd: move ctx->evfd_last_cq_tail into io_ev_fd
      io_uring/msg_ring: refactor a few helper functions
      io_uring/msg_ring: add support for sending a sync message
      io_uring/poll: remove 'ctx' argument from io_poll_req_delete()
      io_uring/poll: get rid of unlocked cancel hash
      io_uring/poll: get rid of io_poll_tw_hash_eject()
      io_uring/poll: get rid of per-hashtable bucket locks
      io_uring/cancel: get rid of init_hash_table() helper
      io_uring: move cancel hash tables to kvmalloc/kvfree
      io_uring/rsrc: don't assign bvec twice in io_import_fixed()
      io_uring/uring_cmd: get rid of using req->imu
      io_uring/rw: get rid of using req->imu
      io_uring: remove 'issue_flags' argument for io_req_set_rsrc_node()
      io_uring/net: move send zc fixed buffer import to issue path
      io_uring: kill 'imu' from struct io_kiocb
      io_uring: move max entry definition and ring sizing into header
      io_uring: abstract out a bit of the ring filling logic
      io_uring/memmap: explicitly return -EFAULT for mmap on NULL rings
      io_uring/register: add IORING_REGISTER_RESIZE_RINGS
      io_uring/sqpoll: wait on sqd->wait for thread parking
      io_uring: switch struct ext_arg from __kernel_timespec to timespec64
      io_uring: change io_get_ext_arg() to use uaccess begin + end
      io_uring: add support for fixed wait regions
      io_uring/nop: add support for testing registered files and buffers
      io_uring/rsrc: move struct io_fixed_file to rsrc.h header
      io_uring: specify freeptr usage for SLAB_TYPESAFE_BY_RCU io_kiocb cache
      io_uring/splice: open code 2nd direct file assignment
      io_uring/rsrc: kill io_charge_rsrc_node()
      io_uring/rsrc: get rid of per-ring io_rsrc_node list
      io_uring/rsrc: get rid of io_rsrc_node allocation cache
      io_uring/rsrc: add an empty io_rsrc_node for sparse buffer entries
      io_uring: only initialize io_kiocb rsrc_nodes when needed
      io_uring/rsrc: unify file and buffer resource tables
      io_uring/rsrc: add io_rsrc_node_lookup() helper
      io_uring/filetable: remove io_file_from_index() helper
      io_uring/filetable: kill io_reset_alloc_hint() helper
      io_uring/rsrc: add io_reset_rsrc_node() helper
      io_uring/rsrc: get rid of the empty node and dummy_ubuf
      io_uring/rsrc: allow cloning at an offset
      io_uring/rsrc: allow cloning with node replacements
      io_uring/rsrc: encode node type and ctx together
      io_uring/rsrc: split io_kiocb node type assignments
      io_uring: move cancelations to be io_uring_task based
      io_uring: remove task ref helpers
      io_uring: move struct io_kiocb from task_struct to io_uring_task

Ming Lei (4):
      io_uring/rsrc: pass 'struct io_ring_ctx' reference to rsrc helpers
      io_uring/rsrc: remove '->ctx_ptr' of 'struct io_rsrc_node'
      io_uring/rsrc: add & apply io_req_assign_buf_node()
      io_uring/uring_cmd: fix buffer index retrieval

Olivier Langlois (6):
      io_uring/napi: protect concurrent io_napi_entry timeout accesses
      io_uring/napi: fix io_napi_entry RCU accesses
      io_uring/napi: improve __io_napi_add
      io_uring/napi: Use lock guards
      io_uring/napi: clean up __io_napi_do_busy_loop
      io_uring/napi: add static napi tracking strategy

Pavel Begunkov (17):
      io_uring: kill io_llist_xchg
      io_uring: static_key for !IORING_SETUP_NO_SQARRAY
      io_uring: clean up cqe trace points
      io_uring/net: split send and sendmsg prep helpers
      io_uring/net: don't store send address ptr
      io_uring/net: don't alias send user pointer reads
      io_uring/net: clean up io_msg_copy_hdr
      io_uring: prevent speculating sq_array indexing
      io_uring: avoid normal tw intermediate fallback
      io_uring: fix invalid hybrid polling ctx leaks
      io_uring: fortify io_pin_pages with a warning
      io_uring: disable ENTER_EXT_ARG_REG for IOPOLL
      io_uring: temporarily disable registered waits
      io_uring: introduce concept of memory regions
      io_uring: add memory region registration
      io_uring: restore back registered wait arguments
      io_uring/region: fix error codes after failed vmap

hexue (1):
      io_uring: add support for hybrid IOPOLL

 include/linux/io_uring/cmd.h    |   2 +-
 include/linux/io_uring_types.h  |  88 ++++--
 include/trace/events/io_uring.h |  24 +-
 include/uapi/linux/io_uring.h   | 119 +++++++-
 io_uring/cancel.c               |  20 +-
 io_uring/cancel.h               |   1 -
 io_uring/eventfd.c              | 137 ++++++---
 io_uring/fdinfo.c               |  88 ++++--
 io_uring/filetable.c            |  71 ++---
 io_uring/filetable.h            |  35 +--
 io_uring/futex.c                |   4 +-
 io_uring/futex.h                |   4 +-
 io_uring/io_uring.c             | 433 ++++++++++++++------------
 io_uring/io_uring.h             |  30 +-
 io_uring/memmap.c               |  83 +++++
 io_uring/memmap.h               |  14 +
 io_uring/msg_ring.c             |  91 ++++--
 io_uring/msg_ring.h             |   1 +
 io_uring/napi.c                 | 184 +++++++----
 io_uring/napi.h                 |   8 +-
 io_uring/net.c                  | 112 ++++---
 io_uring/nop.c                  |  47 ++-
 io_uring/notif.c                |   7 +-
 io_uring/opdef.c                |   2 +
 io_uring/poll.c                 | 181 +++--------
 io_uring/poll.h                 |   2 +-
 io_uring/register.c             | 299 +++++++++++++++++-
 io_uring/rsrc.c                 | 657 +++++++++++++++-------------------------
 io_uring/rsrc.h                 |  97 +++---
 io_uring/rw.c                   | 105 +++++--
 io_uring/splice.c               |  42 ++-
 io_uring/splice.h               |   1 +
 io_uring/sqpoll.c               |   3 +-
 io_uring/tctx.c                 |   1 +
 io_uring/timeout.c              |  16 +-
 io_uring/timeout.h              |   2 +-
 io_uring/uring_cmd.c            |  27 +-
 io_uring/uring_cmd.h            |   2 +-
 io_uring/waitid.c               |   6 +-
 io_uring/waitid.h               |   2 +-
 40 files changed, 1825 insertions(+), 1223 deletions(-)

-- 
Jens Axboe


