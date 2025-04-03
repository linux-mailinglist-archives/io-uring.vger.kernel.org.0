Return-Path: <io-uring+bounces-7382-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13FDDA7B204
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 00:23:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E015189AF42
	for <lists+io-uring@lfdr.de>; Thu,  3 Apr 2025 22:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3EC2E62AE;
	Thu,  3 Apr 2025 22:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kL/hE8Vh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7AA18CBFB
	for <io-uring@vger.kernel.org>; Thu,  3 Apr 2025 22:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743718996; cv=none; b=ktEtLBbbm++Wg0dX0XlBoBpKIgC+VtI5YFEPv8VT+xx8iVrbRjySWQ1J4Fcxq3m06jy/9egKV8Lq34w4sK+VJuaBF6LVPtoiz40+6hbNd/PTS/V1nLWCTCudGAUkN1jzlidofUBXGaiap8Pyl9JvVTK8sdT1MvqL1hUgwZPJCZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743718996; c=relaxed/simple;
	bh=opVZbBqBReuW36Vy+9r/IkhG6aZI8JbfmChiSky7BUs=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=KgGR/3X8rJodn04zEBdhzfuXJD6eyy6XFx5xB5T7+6vcRfZHDohbU3m7HeS+CRjigd2SjXSm86vU6tg6rfjiHU/JQ/cMCQh7nztzmNeS4WNF6HcsUrQiGeGjaaBtGX7CAFW3L965FvYdpiFSgB/FQnoT5piOiDKAPESznqLRis4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kL/hE8Vh; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3d4436ba324so13445755ab.2
        for <io-uring@vger.kernel.org>; Thu, 03 Apr 2025 15:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743718991; x=1744323791; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YMDkGkGsFc6bLNhDydJiLiUCQZo2g13CLPlUjPWAPnY=;
        b=kL/hE8VhjtZvqGbAI+ws+KRhFxMjeSQVJsvCDCP5DE9s3rfkmOsGbWOHp5n4bLb7Tj
         B4lgHl041F9kQUzDBBbuRoJnoFz0QnNoDWs9ZpS4lEJV7GYzz8zqf9ToV4SFTCrkJpqK
         77sISkeKkKZ1iLmbhpZxwNdjYul4r0hJwFgUDxuEsUiP645zNYKxhFyXdILjU11ApiMb
         +8XhAkMkKnYbbqtsPOr0n18Edl8V6AUaFXk8TTwaQAULTHUmEhVXGFNbf8e8oGCilGR6
         bjeuJY/PbrJXFeREjYGJttkaWm2Ur4gR1Rj0rLoqDB4JP5aLz3lSlgxh2mGkSbruqd5X
         n8Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743718991; x=1744323791;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YMDkGkGsFc6bLNhDydJiLiUCQZo2g13CLPlUjPWAPnY=;
        b=rkchwHbkDrIzNGZJZnj62l3DE+du4KHCjTudjeLiYNJXLs25nmpwXtvPL68ONotqqT
         tgmY0W8RR3d1VEUZm2ppcNO3yC0I4gYetsXH1ZxJgpUGSwOhc++/oTTAIfC/YCABfkys
         uUgrlwsr3LmPV1A07Ik9FqItw19p+tVZKDj9PaUcHOl2Fy+tL71wF8VjjS/0dvbdJbrr
         9+1EPJ/T7pOYAjpWf+tIZfLbDAuHiyl0bnY5gfodzK3CLTkv5ivzZFJzWW0CleW4Hyov
         NYjwfzhGPmBuA4htspaac+ggsZfViNuySw32YjczSt+IkSPmZ49YixBY51FXCyhZ0YF8
         tx/w==
X-Gm-Message-State: AOJu0YyIINRQTm7ZtIQpNDSiEYotcocIB7Vxwg+B8GxmU2bAk8GCBnpV
	7MK8P5/eMSVkOcXKEUr3CJKazpmt+94e4y2lbQmlxHG+ikBCsrbWR07TZCdXjxf+mtUUiG45EBJ
	o
X-Gm-Gg: ASbGncuhET5rAoNbjHeNGQeSWvAefkICZviCZhC9WFM1YUo8/m34VRBMB9Unw7ztC75
	2NhBE1QvkX8jkpV+nzKv4sfBAFm2FF/IhCL2S3WtNAMHt3nPXh0WO+e7GMN+bS/KL/gVkOFMtsB
	D8nq3kWNoQ+n3zhXkV/7L/vAj48IkgAqh6Uevgi6gR5e10qn0+DBiX8GbmEoLkZ+jCfiFSLQVYM
	QWayB5A+VJK+DXGosqa2hVPX1PeztPzoAXttE3DmAhFa69QhO6Kk8dR72MP+9LGI4FiaCM9aDaD
	clIi/mhjzX4fB6xq9JC2jdlcq/fpRPx05kSEMIVaZO9Qz0cn+f07
X-Google-Smtp-Source: AGHT+IHG0Zdm/hNwzrRzbB4oRg/AXx/TKglOABebm//DJBAFcC3tqCBBbqAm7PV/KcsefFhhDTzBwQ==
X-Received: by 2002:a05:6e02:3e05:b0:3d6:cbad:235c with SMTP id e9e14a558f8ab-3d6e3efb961mr13077705ab.6.1743718991500;
        Thu, 03 Apr 2025 15:23:11 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f4b5c2e8acsm511550173.1.2025.04.03.15.23.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Apr 2025 15:23:10 -0700 (PDT)
Message-ID: <2f74c42b-7f6a-4d04-b7f2-e0ca5eb33ff4@kernel.dk>
Date: Thu, 3 Apr 2025 16:23:10 -0600
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
Subject: [GIT PULL] Final io_uring updates for 6.15-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Set of fixes/updates for io_uring that should go into this release. The
ublk bits could've gone via either tree - usually I put them in block,
but they got a bit mixed this series with the zero-copy supported that
ended up dipping into both trees.

This pull request contains:

- Fix for sendmsg zc, include in pinned pages accounting like we do for
  the other zc types.

- Series for ublk fixing request aborting, doing various little
  cleanups, fixing some zc issues, and adding queue_rqs support.

- Another ublk series doing some code cleanups.

- Series cleaning up the io_uring send path, mostly in preparation for
  registered buffers.

- Series doing little MSG_RING cleanups.

- Fix for the newly added zc rx, fixing len being 0 for the last
  invocation of the callback.

- Add vectored registered buffer support for ublk. With that, then ublk
  also supports this feature in the kernel revision where it could
  generically introduced for rw/net.

- A bunch of selftest additions for ublk. This is the majority of the
  diffstat.

- Silence a KCSAN data race warning for io-wq

- Various little cleanups and fixes.

Please pull!


The following changes since commit eff5f16bfd87ae48c56751741af41a825d5d4618:

  Merge tag 'for-6.15/io_uring-reg-vec-20250327' of git://git.kernel.dk/linux (2025-03-28 15:07:04 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.15-20250403

for you to fetch changes up to 390513642ee6763c7ada07f0a1470474986e6c1c:

  io_uring: always do atomic put from iowq (2025-04-03 08:31:57 -0600)

----------------------------------------------------------------
io_uring-6.15-20250403

----------------------------------------------------------------
Caleb Sander Mateos (7):
      ublk: remove unused cmd argument to ublk_dispatch_req()
      ublk: skip 1 NULL check in ublk_cmd_list_tw_cb() loop
      ublk: get ubq from pdu in ublk_cmd_list_tw_cb()
      ublk: avoid redundant io->cmd in ublk_queue_cmd_list()
      ublk: store req in ublk_uring_cmd_pdu for ublk_cmd_tw_cb()
      ublk: specify io_cmd_buf pointer type
      selftests: ublk: specify io_cmd_buf pointer type

David Wei (1):
      io_uring/zcrx: return early from io_zcrx_recv_skb if readlen is 0

Jens Axboe (1):
      Documentation: ublk: remove dead footnote

Ming Lei (15):
      ublk: make sure ubq->canceling is set when queue is frozen
      ublk: comment on ubq->canceling handling in ublk_queue_rq()
      ublk: remove two unused fields from 'struct ublk_queue'
      ublk: add helper of ublk_need_map_io()
      ublk: call io_uring_cmd_to_pdu to get uring_cmd pdu
      ublk: add segment parameter
      ublk: document zero copy feature
      ublk: implement ->queue_rqs()
      ublk: rename ublk_rq_task_work_cb as ublk_cmd_tw_cb
      selftests: ublk: add more tests for covering MQ
      selftests: ublk: add test for checking zero copy related parameter
      io_uring: add validate_fixed_range() for validate fixed buffer
      block: add for_each_mp_bvec()
      io_uring: support vectored kernel fixed buffer
      selftests: ublk: enable zero copy for stripe target

Pavel Begunkov (18):
      io_uring/net: account memory for zc sendmsg
      io_uring/net: open code io_sendmsg_copy_hdr()
      io_uring/net: open code io_net_vec_assign()
      io_uring/net: combine sendzc flags writes
      io_uring/net: unify sendmsg setup with zc
      io_uring/net: clusterise send vs msghdr branches
      io_uring/net: set sg_from_iter in advance
      io_uring/net: import zc ubuf earlier
      io_uring/msg: rename io_double_lock_ctx()
      io_uring/msg: initialise msg request opcode
      io_uring: don't pass ctx to tw add remote helper
      io_uring: add req flag invariant build assertion
      io_uring: make zcrx depend on CONFIG_IO_URING
      io_uring: hide caches sqes from drivers
      io_uring: cleanup {g,s]etsockopt sqe reading
      io_uring/rsrc: check size when importing reg buffer
      io_uring/net: avoid import_ubuf for regvec send
      io_uring: always do atomic put from iowq

Uday Shankar (2):
      selftests: ublk: kublk: use ioctl-encoded opcodes
      selftests: ublk: kublk: fix an error log line

 Documentation/block/ublk.rst                    |  37 ++--
 drivers/block/ublk_drv.c                        | 223 +++++++++++++++++++-----
 include/linux/bvec.h                            |   6 +
 include/linux/io_uring/cmd.h                    |   1 -
 include/uapi/linux/ublk_cmd.h                   |  25 +++
 io_uring/Kconfig                                |   1 +
 io_uring/io_uring.c                             |  18 +-
 io_uring/io_uring.h                             |   3 +-
 io_uring/msg_ring.c                             |  11 +-
 io_uring/net.c                                  | 135 ++++++--------
 io_uring/refs.h                                 |   7 +
 io_uring/rsrc.c                                 | 126 +++++++++++--
 io_uring/uring_cmd.c                            |  22 +--
 io_uring/uring_cmd.h                            |   1 +
 io_uring/zcrx.c                                 |   8 +
 tools/testing/selftests/ublk/Makefile           |   5 +
 tools/testing/selftests/ublk/kublk.c            |   8 +-
 tools/testing/selftests/ublk/kublk.h            |   4 +-
 tools/testing/selftests/ublk/null.c             |  11 +-
 tools/testing/selftests/ublk/stripe.c           |  69 ++++++--
 tools/testing/selftests/ublk/test_common.sh     |   6 +
 tools/testing/selftests/ublk/test_generic_02.sh |  44 +++++
 tools/testing/selftests/ublk/test_generic_03.sh |  28 +++
 tools/testing/selftests/ublk/test_loop_01.sh    |  14 +-
 tools/testing/selftests/ublk/test_loop_03.sh    |  14 +-
 tools/testing/selftests/ublk/test_loop_05.sh    |  28 +++
 tools/testing/selftests/ublk/test_stress_01.sh  |   6 +-
 tools/testing/selftests/ublk/test_stress_02.sh  |   6 +-
 tools/testing/selftests/ublk/test_stripe_01.sh  |  14 +-
 tools/testing/selftests/ublk/test_stripe_03.sh  |  30 ++++
 30 files changed, 673 insertions(+), 238 deletions(-)
 create mode 100755 tools/testing/selftests/ublk/test_generic_02.sh
 create mode 100755 tools/testing/selftests/ublk/test_generic_03.sh
 create mode 100755 tools/testing/selftests/ublk/test_loop_05.sh
 create mode 100755 tools/testing/selftests/ublk/test_stripe_03.sh

-- 
Jens Axboe


