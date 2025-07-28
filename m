Return-Path: <io-uring+bounces-8834-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FFD2B13AF4
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 15:03:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9489C1894F4C
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 759491A0BD0;
	Mon, 28 Jul 2025 13:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kTLNAuur"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610C743147
	for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 13:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753707796; cv=none; b=tHp1dia6ie1Xzy3GMvQzb8ATqfSswfSSH0mwXmySYbbFzPHfJ1l0UrpQ3Z14ZyIEXY2rObg+JbUV408HCREe3kZF1a2xcaFuUsQDjEAfAZxfd5TSW8RjfUXqquHkFxAQ3k8++rZyMN1aT7FPz0mDDrzEBA65s5TVpkFhO7KpGV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753707796; c=relaxed/simple;
	bh=zKN4Na6K9OBNMJZ8HPaOaBi8yBlSn7DzhoRI4PMaw6s=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=SFBGhkz7ExAYefpm/wi+DhZDHu7ATMxdpD3RMo6I5nE+tUV/we4+25Fpidn9ovJvIp94lMJi0Clp3YGLyFYKO9pCM25HNCQCwgKGYISISuiHbJsviE3+CuFABKlUkTAlHHASXvo475Mm4vAdH9P4doyqBbbt5AZNmWGHyTvxPN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kTLNAuur; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-875acfc133dso167378739f.1
        for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 06:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1753707791; x=1754312591; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tZN/mWby+6pmWFafZWmigaSXf+xWDt07YdQlOiyALsI=;
        b=kTLNAuurRSLI9tIBrjUfAc9AT77/zhS5PoDTZqdh8jBFBvY+BJ6qcjvUgR2HZ96PcX
         EyIAmyf1WGrupE26RagpXATm7sl12IbhqeLNvBkoAauQ7tdRun1jUAb0vwg+QzpbbY3D
         EIopFvSwi8MOz0MaD2A9O7ImD154N4nIEC8VA8IrWxiAal2iesv314PsCTlaNlGNW5e7
         Te7/NKkoOUYguZ/nUWB6+WKN2Hm6Fj0sz6Jv/+v7oZKP/AcLZ1OfDW+d7rRnaia3pOwS
         MsSSjx1P2LckpJUgnAZ6+qpLVib8bFuvWIfuvq5A0s6QFgOXeMCP9LreG20DBJifrz5E
         SYlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753707791; x=1754312591;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tZN/mWby+6pmWFafZWmigaSXf+xWDt07YdQlOiyALsI=;
        b=Y5eYNCqwEA/OYTsJMxivJOxbG11MkNxUamCyEi4GwRCBf81DwM1Ry8/QzK7T6l5UXO
         b8qcLH4qSXMFyEKneiv8bf9nw024pk3w9PlyfztNizCigm2tJCXX77WS6PW3WmjQjcUT
         5IQ6x3CyVZ1kRfhUS30hre7cFSyvr4pLBSqruGHbCEwS+fPI6rsHuBaiPZBJy1CVF+XA
         VtSIl923Pv6SJtIyreUAtNOz/BN8vlqzKg8xq1AbWh7tRLXjqeV7ZbPbgPXkspqfqxR5
         8Tr4hF4llh4yU8zHMCRa4y0a0pOTUTvlXxiywYv1AYPzO7mA/r7kf1SUK7/qa3PAmbhY
         iDrg==
X-Gm-Message-State: AOJu0YzzXNkYPwFm0av4GgiW4hOFhgk98NoYGULTRGtMG9UBIFE0f+SL
	+3EqBtMxyuMJq/Rt+iRp+HBmtcijDveYnqiTKz0YBIr0jgFQqbSxcJ7Nqe50f+cBDVeuGCvrR9q
	/cbim
X-Gm-Gg: ASbGnct2PIr3gcs+dlvaeEhPrtphAm1n+YnQsNtu3bvWhOgAqPlaSjOCF/La2luzDnp
	SjJ4EWeurNzYrhKHYuAdUOSICwyjfzz5TVctAawIqMk4qf75AVgpP7RIcEMRNflq9U+ec/6xHQO
	Wo6hMDyQLOud+O6QeAaoMYI8UJRbmT7Uq73cI2vAqakebOTfILINqIi9VY5TF9J0sa8lupyAAOo
	ykmfI2OzTdE0SeBUIsEJqQOUoJzKl9v+T5VcEzIthxYVXacSsrChGYhvd8xUe7NodpopbwDQj1k
	SzIpuF3cDPYuiA7p24uq+4OQie1iCdAalfMpATusJ3DRo1dq9DVl8qWdzpXnolG8zbGqRIlo9bu
	GVBiSUjKCH+43qjvMIbc=
X-Google-Smtp-Source: AGHT+IGW0kT+YnRywMTiAW2Q7Onq7Kw4cryRW7vU3+OaGtM14sweKgSK+8x5dFPHJs4nNuxeDmDAFg==
X-Received: by 2002:a05:6602:158b:b0:879:4b42:1f3a with SMTP id ca18e2360f4ac-8800f0b5620mr1881436639f.5.1753707780322;
        Mon, 28 Jul 2025 06:03:00 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-880f7a296b9sm142938739f.22.2025.07.28.06.02.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 06:02:59 -0700 (PDT)
Message-ID: <1219f4d0-7014-43cc-8fae-26918089795f@kernel.dk>
Date: Mon, 28 Jul 2025 07:02:58 -0600
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
Subject: [GIT PULL] io_uring updates for 6.17-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Pretty quiet round this time around. This pull request contains:

- Optimization to avoid reference counts on non-cloned registered
  buffers. This is how these buffers were handled prior to having
  cloning support, and we can still use that approach as long as the
  buffers haven't been cloned to another ring.

- Cleanup and improvement for uring_cmd, where btrfs was the only user
  of storing allocated data for the lifetime of the uring_cmd. Clean
  that up so we can get rid of the need to do that.

- Avoid unnecessary memory copies in uring_cmd usage. This is
  particularly important as a lot of uring_cmd usage necessitates the
  use of 128b SQEs.

- A few updates for recv multishot, where it's now possible to add
  fairness limits for limiting how much is transferred for each retry
  loop. Additionally, recv multishot now supports an overall cap as
  well, where once reached the multishot recv will terminate. The latter
  is useful for buffer management and juggling many recv streams at the
  same time.

- Add support for returning the TX timestamps via a new socket command.
  This feature can work in either singleshot or multishot mode, where
  the latter triggers a completion whenever new timestamps are
  available. This is an alternative to using the existing error queue.

- Add support for an io_uring "mock" file, which is the start of being
  able to do 100% targeted testing in terms of exercising io_uring
  request handling. The idea is to have a file type that can be anything
  the tester would like, and behave exactly how you want it to behave in
  terms of hitting the code paths you want.

- Improve zcrx by using sgtables to de-duplicate and improve dma address
  handling.

- Prep work for supporting larger pages for zcrx.

- Various little improvements and fixes.

Please pull!


The following changes since commit 6f11adcc6f36ffd8f33dbdf5f5ce073368975bc3:

  io_uring: gate REQ_F_ISREG on !S_ANON_INODE as well (2025-06-29 16:52:34 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.17/io_uring-20250728

for you to fetch changes up to d9f595b9a65e9c9eb03e21f3db98fde158d128db:

  io_uring/zcrx: fix leaking pages on sg init fail (2025-07-21 06:47:45 -0600)

----------------------------------------------------------------
for-6.17/io_uring-20250728

----------------------------------------------------------------
Caleb Sander Mateos (4):
      io_uring/rsrc: skip atomic refcount for uncloned buffers
      io_uring/cmd: introduce IORING_URING_CMD_REISSUE flag
      btrfs/ioctl: store btrfs_uring_encoded_data in io_btrfs_cmd
      io_uring/cmd: remove struct io_uring_cmd_data

Jens Axboe (15):
      io_uring: add IO_URING_F_INLINE issue flag
      io_uring: add struct io_cold_def->sqe_copy() method
      io_uring/uring_cmd: get rid of io_uring_cmd_prep_setup()
      io_uring/uring_cmd: implement ->sqe_copy() to avoid unnecessary copies
      io_uring/nop: add IORING_NOP_TW completion flag
      Merge branch 'timestamp-for-jens' of https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next into for-6.17/io_uring
      io_uring: remove errant ';' from IORING_CQE_F_TSTAMP_HW definition
      Merge branch 'io_uring-6.16' into for-6.17/io_uring
      io_uring/rw: cast rw->flags assignment to rwf_t
      io_uring/net: use passed in 'len' in io_recv_buf_select()
      io_uring/net: move io_sr_msg->retry_flags to io_sr_msg->flags
      io_uring/net: allow multishot receive per-invocation cap
      io_uring/poll: cleanup apoll freeing
      io_uring/net: cast min_not_zero() type
      io_uring: deduplicate wakeup handling

Norman Maurer (1):
      io_uring/net: Support multishot receive len cap

Pavel Begunkov (23):
      net: timestamp: add helper returning skb's tx tstamp
      io_uring/poll: introduce io_arm_apoll()
      io_uring/cmd: allow multishot polled commands
      io_uring: add mshot helper for posting CQE32
      io_uring/netcmd: add tx timestamping cmd support
      io_uring/mock: add basic infra for test mock files
      io_uring/mock: add cmd using vectored regbufs
      io_uring/mock: add sync read/write
      io_uring/mock: allow to choose FMODE_NOWAIT
      io_uring/mock: support for async read/write
      io_uring/mock: add trivial poll handler
      io_uring: don't use int for ABI
      io_uring/zcrx: always pass page to io_zcrx_copy_chunk
      io_uring/zcrx: return error from io_zcrx_map_area_*
      io_uring/zcrx: introduce io_populate_area_dma
      io_uring/zcrx: allocate sgtable for umem areas
      io_uring/zcrx: assert area type in io_zcrx_iov_page
      io_uring/zcrx: prepare fallback for larger pages
      io_uring: export io_[un]account_mem
      io_uring/zcrx: account area memory
      io_uring/zcrx: fix null ifq on area destruction
      io_uring/zcrx: don't leak pages on account failure
      io_uring/zcrx: fix leaking pages on sg init fail

Randy Dunlap (1):
      io_uring: fix breakage in EXPERT menu

 MAINTAINERS                             |   1 +
 fs/btrfs/ioctl.c                        |  38 +++-
 include/linux/io_uring/cmd.h            |  11 +-
 include/linux/io_uring_types.h          |   5 +
 include/net/sock.h                      |   4 +
 include/uapi/linux/io_uring.h           |  19 +-
 include/uapi/linux/io_uring/mock_file.h |  47 +++++
 init/Kconfig                            |  13 +-
 io_uring/Makefile                       |   1 +
 io_uring/cmd_net.c                      |  82 ++++++++
 io_uring/io_uring.c                     |  90 ++++++--
 io_uring/io_uring.h                     |  28 ++-
 io_uring/mock_file.c                    | 363 ++++++++++++++++++++++++++++++++
 io_uring/net.c                          |  79 +++++--
 io_uring/nop.c                          |   8 +-
 io_uring/opdef.c                        |   1 +
 io_uring/opdef.h                        |   1 +
 io_uring/poll.c                         |  44 ++--
 io_uring/poll.h                         |   1 +
 io_uring/rsrc.c                         |  10 +-
 io_uring/rsrc.h                         |   2 +
 io_uring/rw.c                           |   2 +-
 io_uring/uring_cmd.c                    |  93 +++++---
 io_uring/uring_cmd.h                    |   9 +-
 io_uring/zcrx.c                         | 267 +++++++++++++----------
 io_uring/zcrx.h                         |   2 +
 net/socket.c                            |  46 ++++
 27 files changed, 1029 insertions(+), 238 deletions(-)

-- 
Jens Axboe


