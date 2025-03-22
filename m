Return-Path: <io-uring+bounces-7205-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59443A6CBB5
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 18:30:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6D64173AAF
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 17:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61DC71F55EB;
	Sat, 22 Mar 2025 17:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NrmHuhUu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944151DAC95
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 17:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742664528; cv=none; b=s3YcRShP+4kFoWkMbhORZ+ou+ZIS141j9eilvIPaIZbkxQqorT3mZyR2Zy0gaj+EKN6rIiZaaMWGRzm31QKchXeyWzFPM8v4SG1GgQdLGNgy4BYpDihUKPie3kbb7Tdd5eJNQOh4WFi1Hpz7oTR4AKsJHmAYGtBMqemCouFvPTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742664528; c=relaxed/simple;
	bh=OjCiELvV7zDcxwxu5xvUw/AoKHBEMTMI32zWMEod0Gc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=j27ng4cKqKvycAHwEoA6Eh3vfIuLa5iwOvMXXt5lUNX2p55uQM0eUAavgcTd4uoMedX3rV9qHuFlRb499kXWvphwV58ntFkbchA/We3HdZDyLY2qOxvExymb47UtICY+VRKyDrjh5EjgjxUy3wlqsLZ5+ahsPto3q1+ofGJgX+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NrmHuhUu; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3cf82bd380bso32760455ab.0
        for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 10:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742664523; x=1743269323; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fgCqiyO3j04+M10V/a3OgT1C9u0GCZY0rSY8HfftfZg=;
        b=NrmHuhUuI5eoONaX4mD9RcCxJbo2Yp4WqCaJ0k9EWRFMCX0EsLX0bM+fMkem7D0JvD
         2FXhzxqmtDVQ4ctHQFiDDLh1Pmp5D5hcceHM5xm+NTFRFQ8Ql6ZreKxs0nVAIWYbHiZ1
         xXfVCWmW76ftUKMKl7bERcByo6xtBwJVM7s42NjKPGrEqw6Mv65JPRNFs+a9oo4wd4j1
         ASRcfHL86afCGH+mJfeaWdKMfYLOuPDaIoHjwS6Kt7dUG10IiffQ39RxYR40j+XtGU/g
         lpOZ4+wIYy1IyPD/gbWK40/8EdYx7K2RLqzJNPDio2OzXaf61pb9NTtxKQLDlalli/IH
         ojpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742664523; x=1743269323;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fgCqiyO3j04+M10V/a3OgT1C9u0GCZY0rSY8HfftfZg=;
        b=fkeKywZ/KE6V67RslPdSAPEJBm0ofTL3cbcXYK7D5/bmFRETmvtF1r+QMKO4NVu+Dx
         9DAONYDYJTS46gTzvmk9gAgpx40DfTt7Aq30kdLAPOJNaGveL9K5Nc27YT+NAjCI52yz
         6ONoToJwmgAaXmRy2mUGPIpE7q5hbcZ1qP0JXx1vUXBJJvMXa0vkpsepDuCbK+GEKBuM
         ipwujgGcULaVa2hJhl/3qYSHi0XRxyHv0e9l/1fH3nCLOgae7mcj/7SSL2ACPilZedCr
         XsqvzOWNy66Sj2M9es1YCXPl5ZnAMMWAa0zustWliC7LVrY4XDItJva38Ryz9N/PboVy
         M9pQ==
X-Gm-Message-State: AOJu0YyVjECmPE7wyojMVWUYTtIQpD4AOxBharX7tI1mTZN+6i8jVAfD
	mWdMjPz3FNxO1XkWgwdAOM4S7hyoDIAYyJoncgHmO0qi+tGZJQvuyzjAlxoGS2r6pWyzfpm572Z
	T
X-Gm-Gg: ASbGnctn0Be2cefy6fZ6owon1KjxG53Y0DU8fFODhV1K0YpOc+rRH7/9y9I6vMWTNDL
	PSo0ZZYaiDKrx3gug/PDTW30JLhcY36YktU7RkYkB9eeopHFBATi7RDDxmSz+jIygrbEccwsaxS
	dEfx38a43zSbEhislI/lV4mH8iUR5PTefAMgueRPeUcW3MVcyHQYGmh1SxrLe4zQLrcLzg+6DVX
	ntWaKvmSoqRfkcSGYavIEXsmghp6x7WMKiaEiQmS7sTdeBq++BWu+T2i3jAsCAYpbS333Unl8yv
	cMxKVBTEuTWnyy/nqLIg+oVSMr4DLVwcVlRRgtzguw==
X-Google-Smtp-Source: AGHT+IGfJNnw49+wKUKC6h3VFP60Dr1EpOuNUsnIImPNxQ6o8o9ZBiCCaNHjVcWoTl4eyjJokgDhmg==
X-Received: by 2002:a05:6e02:3f08:b0:3d4:3fed:81f7 with SMTP id e9e14a558f8ab-3d5961cb366mr71229835ab.19.1742664523495;
        Sat, 22 Mar 2025 10:28:43 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbdb3ac0sm993573173.6.2025.03.22.10.28.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Mar 2025 10:28:42 -0700 (PDT)
Message-ID: <c8ee770c-09a8-41d1-a417-0455361d1045@kernel.dk>
Date: Sat, 22 Mar 2025 11:28:42 -0600
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
Subject: [GIT PULL] io_uring updates for 6.15-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

This is the first of the io_uring pull requests for the 6.15 merge
window, there will be others once the net tree has gone in. Sending it
off a bit early as I'll be at LSFMM in Montreal most of next week, with
a bunch of other folks. This pull request contains:

- Cleanup and unification of cancelation handling across various request
  types.

- Improvement for bundles, supporting them both for incrementally
  consumed buffers, and for non-multishot requests.

- Enable toggling of using iowait while waiting on io_uring events or
  not. Unfortunately this is still tied with CPU frequency boosting on
  short waits, as the scheduler side has not been very receptive to
  splitting the (useless) iowait stat from the cpufreq implied boost.

- Add support for kbuf nodes, enabling zero-copy support for the ublk
  block driver.

- Various cleanups for resource node handling.

- Series greatly cleaning up the legacy provided (non-ring based)
  buffers. For years, we've been pushing the ring provided buffers as
  the way to go, and that is what people have been using. Reduce the
  complexity and code associated with legacy provided buffers.

- Series cleaning up the compat handling.

- Series improving and cleaning up the recvmsg/sendmsg iovec and msg
  handling.

- Series of cleanups for io-wq.

- Start adding a bunch of selftests. The liburing repository generally
  carries feature and regression tests for everything, but at least for
  ublk initially, we'll try and go the route of having it in selftests
  as well. We'll see how this goes, might decide to migrate more tests
  this way in the future.


- Various little cleanups and fixes.

Please pull!


The following changes since commit 6ebf05189dfc6d0d597c99a6448a4d1064439a18:

  io_uring/net: save msg_control for compat (2025-02-25 09:03:51 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.15/io_uring-20250322

for you to fetch changes up to 0f3ebf2d4bc0296c61543b2a729151d89c60e1ec:

  selftests: ublk: add stripe target (2025-03-22 08:35:08 -0600)

----------------------------------------------------------------
for-6.15/io_uring-20250322

----------------------------------------------------------------
Arnd Bergmann (1):
      io_uring/net: fix build warning for !CONFIG_COMPAT

Caleb Sander Mateos (20):
      io_uring: use IO_REQ_LINK_FLAGS more
      io_uring: pass ctx instead of req to io_init_req_drain()
      io_uring/rsrc: avoid NULL check in io_put_rsrc_node()
      io_uring: introduce type alias for io_tw_state
      io_uring: pass struct io_tw_state by value
      io_uring: use lockless_cq flag in io_req_complete_post()
      io_uring/rsrc: use rq_data_dir() to compute bvec dir
      io_uring/uring_cmd: specify io_uring_cmd_import_fixed() pointer type
      io_uring: convert cmd_to_io_kiocb() macro to function
      io_uring/ublk: report error when unregister operation fails
      io_uring/rsrc: declare io_find_buf_node() in header file
      io_uring/nop: use io_find_buf_node()
      ublk: don't cast registered buffer index to int
      io_uring/rsrc: include io_uring_types.h in rsrc.h
      io_uring/rsrc: split out io_free_node() helper
      io_uring/rsrc: free io_rsrc_node using kfree()
      io_uring/rsrc: call io_free_node() on io_sqe_buffer_register() failure
      io_uring/rsrc: avoid NULL node check on io_sqe_buffer_register() failure
      io_uring/rsrc: skip NULL file/buffer checks in io_free_rsrc_node()
      io_uring: introduce io_cache_free() helper

Jens Axboe (10):
      io_uring/cancel: add generic remove_all helper
      io_uring/futex: convert to io_cancel_remove_all()
      io_uring/waitid: convert to io_cancel_remove_all()
      io_uring/cancel: add generic cancel helper
      io_uring/futex: use generic io_cancel_remove() helper
      io_uring/waitid: use generic io_cancel_remove() helper
      io_uring/net: improve recv bundles
      Merge branch 'io_uring-6.14' into for-6.15/io_uring
      io_uring/kbuf: enable bundles for incrementally consumed buffers
      io_uring: enable toggle of iowait usage when waiting on CQEs

Keith Busch (8):
      io_uring/rsrc: remove redundant check for valid imu
      io_uring/nop: reuse req->buf_index
      io_uring/rw: move buffer_select outside generic prep
      io_uring/rw: move fixed buffer import to issue path
      io_uring: add support for kernel registered bvecs
      ublk: zc register/unregister bvec
      io_uring: cache nodes and mapped buffers
      Revert "io_uring/rsrc: simplify the bvec iter count calculation"

Max Kellermann (6):
      io_uring/io-wq: eliminate redundant io_work_get_acct() calls
      io_uring/io-wq: add io_worker.acct pointer
      io_uring/io-wq: move worker lists to struct io_wq_acct
      io_uring/io-wq: cache work->flags in variable
      io_uring/io-wq: do not use bogus hash value
      io_uring/io-wq: pass io_wq to io_get_next_work()

Ming Lei (27):
      selftests: ublk: add kernel selftests for ublk
      selftests: ublk: add file backed ublk
      selftests: ublk: add ublk zero copy test
      selftests: ublk: make ublk_stop_io_daemon() more reliable
      selftests: ublk: fix build failure
      selftests: ublk: add --foreground command line
      selftests: ublk: fix parsing '-a' argument
      selftests: ublk: support shellcheck and fix all warning
      selftests: ublk: don't pass ${dev_id} to _cleanup_test()
      selftests: ublk: move zero copy feature check into _add_ublk_dev()
      selftests: ublk: load/unload ublk_drv when preparing & cleaning up tests
      selftests: ublk: add one stress test for covering IO vs. removing device
      selftests: ublk: add stress test for covering IO vs. killing ublk server
      selftests: ublk: improve test usability
      selftests: ublk: add one dependency header
      selftests: ublk: don't show `modprobe` failure
      selftests: ublk: add variable for user to not show test result
      selftests: ublk: fix write cache implementation
      selftests: ublk: fix starting ublk device
      selftests: ublk: add generic_01 for verifying sequential IO order
      selftests: ublk: add single sqe allocator helper
      selftests: ublk: increase max buffer size to 1MB
      selftests: ublk: move common code into common.c
      selftests: ublk: prepare for supporting stripe target
      selftests: ublk: enable zero copy for null target
      selftests: ublk: simplify loop io completion
      selftests: ublk: add stripe target

Pavel Begunkov (35):
      io_uring: deduplicate caches deallocation
      io_uring: check for iowq alloc_workqueue failure
      io_uring: sanitise ring params earlier
      io_uring/kbuf: remove legacy kbuf bulk allocation
      io_uring/kbuf: remove legacy kbuf kmem cache
      io_uring/kbuf: move locking into io_kbuf_drop()
      io_uring/kbuf: simplify __io_put_kbuf
      io_uring/kbuf: remove legacy kbuf caching
      io_uring/kbuf: open code __io_put_kbuf()
      io_uring/kbuf: introduce io_kbuf_drop_legacy()
      io_uring/kbuf: uninline __io_put_kbufs
      io_uring: introduce io_is_compat()
      io_uring/cmd: optimise !CONFIG_COMPAT flags setting
      io_uring/rw: compile out compat param passing
      io_uring/rw: shrink io_iov_compat_buffer_select_prep
      io_uring/waitid: use io_is_compat()
      io_uring/net: use io_is_compat()
      io_uring/net: fix accept multishot handling
      io_uring/net: canonise accept mshot handling
      io_uring: make io_poll_issue() sturdier
      io_uring/rw: allocate async data in io_prep_rw()
      io_uring/rw: rename io_import_iovec()
      io_uring/rw: extract helper for iovec import
      io_uring/rw: open code io_prep_rw_setup()
      io_uring/net: reuse req->buf_index for sendzc
      io_uring/nvme: pass issue_flags to io_uring_cmd_import_fixed()
      io_uring: combine buffer lookup and import
      io_uring/net: remove unnecessary REQ_F_NEED_CLEANUP
      io_uring/net: simplify compat selbuf iov parsing
      io_uring/net: isolate msghdr copying code
      io_uring/net: verify msghdr before copying iovec
      io_uring/net: derive iovec storage later
      io_uring/net: unify *mshot_prep calls with compat
      io_uring/net: extract iovec import into a helper
      io_uring: rearrange opdef flags by use pattern

Xinyu Zhang (1):
      nvme: map uring_cmd data even if address is 0

Yue Haibing (1):
      io_uring: Remove unused declaration io_alloc_async_data()

 MAINTAINERS                                   |    1 +
 drivers/block/ublk_drv.c                      |   56 +-
 drivers/nvme/host/ioctl.c                     |   12 +-
 include/linux/io_uring/cmd.h                  |   17 +-
 include/linux/io_uring_types.h                |   20 +-
 include/uapi/linux/io_uring.h                 |    2 +
 include/uapi/linux/ublk_cmd.h                 |    4 +
 io_uring/alloc_cache.h                        |    6 +
 io_uring/cancel.c                             |   42 +
 io_uring/cancel.h                             |    8 +
 io_uring/filetable.c                          |    2 +-
 io_uring/futex.c                              |   62 +-
 io_uring/io-wq.c                              |  230 ++--
 io_uring/io-wq.h                              |    7 +-
 io_uring/io_uring.c                           |  249 ++--
 io_uring/io_uring.h                           |   15 +-
 io_uring/kbuf.c                               |  200 ++-
 io_uring/kbuf.h                               |  100 +-
 io_uring/msg_ring.c                           |    2 +-
 io_uring/net.c                                |  257 ++--
 io_uring/nop.c                                |   18 +-
 io_uring/notif.c                              |    4 +-
 io_uring/opdef.c                              |    4 +-
 io_uring/opdef.h                              |   12 +-
 io_uring/poll.c                               |   18 +-
 io_uring/poll.h                               |    4 +-
 io_uring/rsrc.c                               |  246 +++-
 io_uring/rsrc.h                               |   24 +-
 io_uring/rw.c                                 |  200 +--
 io_uring/rw.h                                 |    5 +-
 io_uring/splice.c                             |    3 +-
 io_uring/timeout.c                            |   16 +-
 io_uring/uring_cmd.c                          |   33 +-
 io_uring/waitid.c                             |   56 +-
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/ublk/.gitignore       |    3 +
 tools/testing/selftests/ublk/Makefile         |   27 +
 tools/testing/selftests/ublk/common.c         |   55 +
 tools/testing/selftests/ublk/config           |    1 +
 tools/testing/selftests/ublk/file_backed.c    |  169 +++
 tools/testing/selftests/ublk/kublk.c          | 1138 +++++++++++++++++
 tools/testing/selftests/ublk/kublk.h          |  370 ++++++
 tools/testing/selftests/ublk/null.c           |  106 ++
 tools/testing/selftests/ublk/stripe.c         |  318 +++++
 tools/testing/selftests/ublk/test_common.sh   |  246 ++++
 .../testing/selftests/ublk/test_generic_01.sh |   44 +
 tools/testing/selftests/ublk/test_loop_01.sh  |   32 +
 tools/testing/selftests/ublk/test_loop_02.sh  |   22 +
 tools/testing/selftests/ublk/test_loop_03.sh  |   31 +
 tools/testing/selftests/ublk/test_loop_04.sh  |   22 +
 tools/testing/selftests/ublk/test_null_01.sh  |   20 +
 tools/testing/selftests/ublk/test_null_02.sh  |   20 +
 .../testing/selftests/ublk/test_stress_01.sh  |   47 +
 .../testing/selftests/ublk/test_stress_02.sh  |   47 +
 .../testing/selftests/ublk/test_stripe_01.sh  |   34 +
 .../testing/selftests/ublk/test_stripe_02.sh  |   24 +
 tools/testing/selftests/ublk/trace/seq_io.bt  |   25 +
 tools/testing/selftests/ublk/ublk_dep.h       |   18 +
 58 files changed, 3883 insertions(+), 872 deletions(-)

-- 
Jens Axboe


