Return-Path: <io-uring+bounces-8101-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F2E77AC2B13
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 22:45:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F9451B62C68
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 20:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC92E1607AC;
	Fri, 23 May 2025 20:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Yt3XwVVL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA3E1EEF9
	for <io-uring@vger.kernel.org>; Fri, 23 May 2025 20:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748033121; cv=none; b=BVMPOPHvlayYROM/Sm+wnHk4AGFbsE4cLUvnxmg2uqI2uSCIJ/2upY/bmqdvYnthbLdxxnonxnC7eDz+7RsbcUSTWi40asouhQNvwo8cgFmSyucu6htm0MKxSwkyAUfSarE9ahyRT/mhZ9d7D2O3/TwmchMEQf1h5mwsg32mmRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748033121; c=relaxed/simple;
	bh=kk3rwkYgJZaIug/zByzcSIEdw62Qp+H3FMishPW6lMo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=a+sJ+zj6S9W8NN1DFEBGjfIgrHRcSz58UCKZ1vczbgPVH5bjCEwtars3lYDScRMY3dpRbBLUQkigFyJ8pBQf0mNUtNi2R4PKKdCBDeUzpMaIOTCuJT4VjVeq8bBOHexeaJzSagSfRRWTnEdL4AmTW6VDHX0xAL6wUgaG4S6RFv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Yt3XwVVL; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d948ce7d9dso1005985ab.2
        for <io-uring@vger.kernel.org>; Fri, 23 May 2025 13:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748033115; x=1748637915; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uJzB0ArkTYZhn++AMMyQZIBNAdmNnQnnZ454mypDwKo=;
        b=Yt3XwVVL0itA932MPKMb2UOI74CjioQjW1lScgD4UnmkEAspeA3nAw0a96OX6qzFhm
         1Zg5NKuRAM1ivmiw/wPSZf3XRq+cdqxynwVAVJ6MiQiGhPo8U4TxPfWJLsKAC3gGHgyW
         EMqnYGFunQXBSS2I231IPGBwOX1k2piC7ct64HhqahAs5MSB/IGXHB5YbgWPKqzhLom1
         J5kaTdGlyK2Xvauu0B5XQkd3ew0gvTBc6M1nVAzMrLlLr3fxRxLYsabr3AV9kdKAQdqP
         f9TYgdVysmiW21K2yZMjEydUS3QqF8XGnfcmSIEjdII8hG/e7b7p87u0vVznd0JGps0h
         huiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748033115; x=1748637915;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uJzB0ArkTYZhn++AMMyQZIBNAdmNnQnnZ454mypDwKo=;
        b=igabn7QJGfPeujBM9/86CL/X+1insyzMsKYpJyKIIzTgY1zKDdbi51brv2peeHitqh
         VfNjpzYDdmM0fA9tEIqTgjg2oQN778ZiUJoHLSrC8tQm7AUTZBbDlJjaH4gR2d3nCrTX
         irzQtTv3Sled4ELYbrCncZCV9HgTUN4RvwVjSVbJMQfCzM/HJAmWwmRBGcMJMV4yCzXw
         qU0H9eBn+JrhBGiCXaP/qkRZUtsVI5jz1S4psv53KUY3FO75sGPTyyj4FJYvr7mpjQ0I
         v6cXDazQAP4FMuygq4bteQ7enZke999KqngvLjXiHmyMd2FPZgbUTynu48SuqHADPiwA
         n3Xg==
X-Gm-Message-State: AOJu0YwVKnzZm5zb4tibY6Fbqe96FjMa04+wF+0f8NsvqvcqRAhIiuEj
	PSFqs/clHejN8yX86Ip6voJ/ORJMl614oJAd79uJtYNCykT69cTEmybXL/8Y23k1QHvw0qdn/R/
	QiMmq
X-Gm-Gg: ASbGncvmqPTMLAykMb5Sm2NFi9UlpfdM3qFZEg8G1wZSLdmWE4Qm9CVOzQrYu7mlvY6
	Eu2cQoylBnuCBGS4OGEwa0/iuewxlVFUe8iMQ4KyEpK9BoeJSHIoTDjt1isz7wo41YrXuXfBOMh
	e2Uc/xUi/kQymK/85GGHl/0iBspRzAKs0fgBs7cP1wmTRaVjR37Sl32iCpZfjEWmtmc+6BH9Uuz
	lXq5hHc5W4PYWVBMSeomlx92DV2xj9Y/ARa1VbqfNAvtJjWvefPwL6YwF+okcu6UfCsmcEuNP5U
	NuEwsaL0GPohetnZsKw8gMLDPlhaXf/znxOCzA1V+wSNRYyOChGNHpQKjY4=
X-Google-Smtp-Source: AGHT+IGa30U3gs/rKVyXDESdco57g7aXc25yreJ+Cto91H5Lgo1ZsPXdxyhyz1otVkdxrB7keNRoMA==
X-Received: by 2002:a05:6e02:180a:b0:3dc:854a:ef3e with SMTP id e9e14a558f8ab-3dc9b686aedmr5257325ab.8.1748033115209;
        Fri, 23 May 2025 13:45:15 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dc76c160acsm24780845ab.24.2025.05.23.13.45.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 May 2025 13:45:14 -0700 (PDT)
Message-ID: <1849db19-119a-4b1f-8ed6-df861d7d9c8f@kernel.dk>
Date: Fri, 23 May 2025 14:45:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 6.16-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Here are the io_uring updated scheduled for the 6.16-rc1 kernel release.
Pretty quiet round this time, mostly just cleanups and fixes. This pull
request contains:

- Avoid indirect function calls in io-wq for executing and freeing work.
  The design of io-wq is such that it can be a generic mechanism, but as
  it's just used by io_uring now, may as well avoid these indirect
  calls.

- Series cleaning up registered buffers for networking.

- Add support for IORING_OP_PIPE. Pretty straight forward, allows
  creating pipes with io_uring, particularly useful for having these be
  instantiated as direct descriptors.

- Series cleaning up the coalescing support fore registered buffers.

- Add support for multiple interface queues for zero-copy rx networking.
  As this feature was merged for 6.15 it supported just a single ifq per
  ring.

- Series cleaning up the eventfd support.

- Series adding dma-buf support to zero-copy rx.

- Series cleaning up and improving the request draining support.

- Series cleaning up provided buffer support, most notably with an eye
  toward making the legacy support less intrusive.

- Minor fdinfo cleanups, dropping support for dumping what credentials
  are registered.

- Improve support for overflow CQE handling, getting rid of GFP_ATOMIC
  for allocating overflow entries where possible.

- Improve detection of cases where io-wq doesn't need to spawn a new
  worker unnecessarily.

- Various little cleanups.

Please pull!


The following changes since commit d871198ee431d90f5308d53998c1ba1d5db5619a:

  io_uring/fdinfo: grab ctx->uring_lock around io_uring_show_fdinfo() (2025-05-14 07:15:28 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.16/io_uring-20250523

for you to fetch changes up to 6faaf6e0faf1cc9a1359cfe6ecb4d9711b4a9f29:

  io_uring/cmd: warn on reg buf imports by ineligible cmds (2025-05-23 06:31:06 -0600)

----------------------------------------------------------------
for-6.16/io_uring-20250523

----------------------------------------------------------------
Caleb Sander Mateos (2):
      io_uring/wq: avoid indirect do_work/free_work calls
      trace/io_uring: fix io_uring_local_work_run ctx documentation

Jens Axboe (13):
      io_uring: add support for IORING_OP_PIPE
      io_uring/rsrc: remove node assignment helpers
      Merge branch 'io_uring-6.15' into for-6.16/io_uring
      io_uring/fdinfo: only compile if CONFIG_PROC_FS is set
      io_uring/fdinfo: get rid of dumping credentials
      io_uring: split alloc and add of overflow
      io_uring: make io_alloc_ocqe() take a struct io_cqe pointer
      io_uring: pass in struct io_big_cqe to io_alloc_ocqe()
      io_uring: add new helpers for posting overflows
      io_uring: finish IOU_OK -> IOU_COMPLETE transition
      io_uring/io-wq: move hash helpers to the top
      io_uring/io-wq: ignore non-busy worker going to sleep
      io_uring/io-wq: only create a new worker if it can make progress

Long Li (1):
      io_uring: update parameter name in io_pin_pages function declaration

Pavel Begunkov (44):
      io_uring/net: don't use io_do_buffer_select at prep
      io_uring: set IMPORT_BUFFER in generic send setup
      io_uring/kbuf: pass bgid to io_buffer_select()
      io_uring: don't store bgid in req->buf_index
      io_uring/rsrc: use unpin_user_folio
      io_uring/rsrc: clean up io_coalesce_buffer()
      io_uring/rsrc: remove null check on import
      io_uring/zcrx: remove duplicated freelist init
      io_uring/zcrx: move io_zcrx_iov_page
      io_uring/zcrx: remove sqe->file_index check
      io_uring/zcrx: let zcrx choose region for mmaping
      io_uring/zcrx: move zcrx region to struct io_zcrx_ifq
      io_uring/zcrx: add support for multiple ifqs
      io_uring/eventfd: dedup signalling helpers
      io_uring/eventfd: clean up rcu locking
      io_uring/eventfd: open code io_eventfd_grab()
      io_uring: delete misleading comment in io_fill_cqe_aux()
      io_uring/cmd: move net cmd into a separate file
      io_uring/zcrx: improve area validation
      io_uring/zcrx: resolve netdev before area creation
      io_uring/zcrx: split out memory holders from area
      io_uring/zcrx: split common area map/unmap parts
      io_uring/zcrx: dmabuf backed zerocopy receive
      io_uring/timeout: don't export link t-out disarm helper
      io_uring: remove io_preinit_req()
      io_uring: move io_req_put_rsrc_nodes()
      io_uring/net: move CONFIG_NET guards to Makefile
      io_uring: add lockdep asserts to io_add_aux_cqe
      io_uring: account drain memory to cgroup
      io_uring: fix spurious drain flushing
      io_uring: simplify drain ret passing
      io_uring: remove drain prealloc checks
      io_uring: consolidate drain seq checking
      io_uring: open code io_account_cq_overflow()
      io_uring: count allocated requests
      io_uring: drain based on allocates reqs
      io_uring/kbuf: account ring io_buffer_list memory
      io_uring/kbuf: use mem_is_zero()
      io_uring/kbuf: drop extra vars in io_register_pbuf_ring
      io_uring/kbuf: don't compute size twice on prep
      io_uring/kbuf: refactor __io_remove_buffers
      io_uring/kbuf: unify legacy buf provision and removal
      io_uring: open code io_req_cqe_overflow()
      io_uring/cmd: warn on reg buf imports by ineligible cmds

 include/linux/io_uring_types.h  |  15 +-
 include/trace/events/io_uring.h |   2 +-
 include/uapi/linux/io_uring.h   |   8 +-
 io_uring/Makefile               |   6 +-
 io_uring/advise.c               |   4 +-
 io_uring/cancel.c               |   2 +-
 io_uring/cmd_net.c              |  83 +++++++
 io_uring/epoll.c                |   4 +-
 io_uring/eventfd.c              |  66 ++----
 io_uring/eventfd.h              |   3 +-
 io_uring/fdinfo.c               |  40 ----
 io_uring/fs.c                   |  10 +-
 io_uring/futex.c                |   6 +-
 io_uring/io-wq.c                |  65 ++++--
 io_uring/io-wq.h                |   5 -
 io_uring/io_uring.c             | 285 ++++++++++++------------
 io_uring/io_uring.h             |   4 +-
 io_uring/kbuf.c                 | 148 +++++--------
 io_uring/kbuf.h                 |   8 +-
 io_uring/memmap.c               |  11 +-
 io_uring/memmap.h               |   4 +-
 io_uring/msg_ring.c             |   2 +-
 io_uring/net.c                  |  62 +++---
 io_uring/nop.c                  |   2 +-
 io_uring/notif.c                |   1 +
 io_uring/opdef.c                |  11 +-
 io_uring/openclose.c            | 139 +++++++++++-
 io_uring/openclose.h            |   3 +
 io_uring/poll.c                 |   4 +-
 io_uring/rsrc.c                 |  91 ++++----
 io_uring/rsrc.h                 |  28 +--
 io_uring/rw.c                   |   7 +-
 io_uring/rw.h                   |   2 +
 io_uring/splice.c               |   4 +-
 io_uring/statx.c                |   2 +-
 io_uring/sync.c                 |   6 +-
 io_uring/tctx.c                 |   2 -
 io_uring/timeout.c              |  13 +-
 io_uring/timeout.h              |  13 --
 io_uring/truncate.c             |   2 +-
 io_uring/uring_cmd.c            |  91 +-------
 io_uring/waitid.c               |   2 +-
 io_uring/xattr.c                |   8 +-
 io_uring/zcrx.c                 | 372 +++++++++++++++++++++++++-------
 io_uring/zcrx.h                 |  26 ++-
 45 files changed, 958 insertions(+), 714 deletions(-)

-- 
Jens Axboe


