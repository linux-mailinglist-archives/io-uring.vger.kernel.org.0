Return-Path: <io-uring+bounces-7263-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A2918A73499
	for <lists+io-uring@lfdr.de>; Thu, 27 Mar 2025 15:38:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B29E1685D5
	for <lists+io-uring@lfdr.de>; Thu, 27 Mar 2025 14:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8478C2163B2;
	Thu, 27 Mar 2025 14:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FvynlWdq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7DD216393
	for <io-uring@vger.kernel.org>; Thu, 27 Mar 2025 14:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743086312; cv=none; b=T9FxRa/DKcHeBsIWT04xoQ+gYrwCMxdvKtNMlPHSQA6f3cLAipQRmUF1N7oFgZE88cipbAoUyV5MhMILs0eWs2MPTX55EDALkmeQNLtEGWJ4ic+4baL+wVsmu6detGOHVUskyJw6XkUy0jy/Nz0fs8yrd4T7ozOtNLxVcvcPWcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743086312; c=relaxed/simple;
	bh=kczoMx+hqboU1Di1FfiRCVA/R2eT/upu6EH3X8VQW4Q=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=tVoaS7FLIBCz2aZ/qzwseekSN63KQL0n2MXZ3BoPZl5JxXTE5xHh/47aibMqw/+vCpD0w18vSINIDQONXMPZ9jeDV3yk63gzhjIhlHQb6ekjK8sm4i9bASPC15I1NIYn0AnUE3+eC8FliJQBjzb42SS5PjpGMVfoTdXgFJlYLSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FvynlWdq; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22398e09e39so23801855ad.3
        for <io-uring@vger.kernel.org>; Thu, 27 Mar 2025 07:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743086308; x=1743691108; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8RvXEo4RQJ+G/KeqXQEZnFonjqiesvKFxB7CpULs2qc=;
        b=FvynlWdqHCoHbPHjFeLJph3hEeYWvOitYpqRTQO5cd7EmmlCS9F3AY3bb96wK5wJmB
         9+Ji9HSWiXdUfPPdcqQa4nx4k6A9xT833moGzUOLGHuYCRPjj2tC93Bqrcaa8TyzTP8t
         UojgTV6cMU9x70AZWMa/rhd+dolEJR8BsCuhiqWSaIrBAZtJFT9Fevxs6EUZITLbcKgQ
         EBdOqTmRv9GNXEzey1SMzu28uhaUw9YgzgWKxafl573gtHt53DhHAo0q0CTkcuWadiuG
         fTzqkqamqOf/xpvBKhCf/aV5SkeQFiuMySNtUlkHmgeFE0IIyufpafC8fbihiYlwfhwl
         WWHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743086308; x=1743691108;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8RvXEo4RQJ+G/KeqXQEZnFonjqiesvKFxB7CpULs2qc=;
        b=mfT+3p+Ukzj/VVIwuZluqEoWVVYVWZm6+eDSngaw5KzeC2vrf+10JBvx41GlynQM1A
         2gNwMn9ghE/OeW/DfCFK0A2JBiI+9VXYXhCetlzsyo3d+C7YsdnQo0VhNpMMQ4UDA7Jz
         7EB03Dnl8QRjSYrAQvzX9Eny0EEMgXOK0mM9uKZkdE0EXdQP2xgvicCInnwZi3bVEL+R
         iCP9B5tXtrfzg4ZmRAPmejKxdqHgye8amqH2c3DaQ+m2uPdJ/R7+L3+Y8WeBsJqtv0RE
         /rbeBUVi36iRhBq9g1eka4f0y6hlv2GeFWHqyf9+Z0jMRp6rxY5uyGxgGmrlwOQrvhY4
         1HQQ==
X-Gm-Message-State: AOJu0YznSwZvy1ugNppMXLkx7OK3Xa8gBAhsCk2J7z9F+alArAB+mNk0
	W2WoqpKdRdWPjw/8m04qmLf0wqW6lsVZ3/lGIGPzD5ZPHUUitVZX8OFpx0gR3hQNEPlou+4ccIi
	0XKQ=
X-Gm-Gg: ASbGncuIQOImgvP5i4cn3FhC6MKeUn0Alzr7sWGIBWCBwr/3xh3J81cytttpL3Se6ow
	JFc5r6v9s7bVyj4cassQfwfCHm0Yl20rgIdO/zyqv8w3V65fgyJcTIOcyo4Htwq3/YVq/pc2tx3
	+Jf1FrAKjm93kKFvttawMXu0qt5GwlN/B7UIqD/JOdUjSDCoOexugXRFZmgD7xMmoTVOpIbWvV1
	USErXdj1HiPR/mbx/lD+uHJjklWH47JpWjRVCxm74h5XNpks43i8BPcogkw6W0eDHn/DTc6Paav
	ZxsBw4uQ2GQstxAcKxqGHOgyJ/6fC+WGqkUGSZpl4Yu9SFxU1PKqhiWjMcECBBxXNCmwiEA7vBD
	XpC2al1BQ
X-Google-Smtp-Source: AGHT+IGBuYd7ty3yO4n62oI7HcrhIfIrD/9aMdKn4J8QBvaoH97y+A2P9LjVW/Kbsl6vlKNvJwYecg==
X-Received: by 2002:a05:6a00:18a9:b0:736:32d2:aa82 with SMTP id d2e1a72fcca58-739610c174dmr5162218b3a.23.1743086308017;
        Thu, 27 Mar 2025 07:38:28 -0700 (PDT)
Received: from ?IPV6:2600:380:863b:551:3a8d:2504:4577:2126? ([2600:380:863b:551:3a8d:2504:4577:2126])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73906156184sm14818311b3a.132.2025.03.27.07.38.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Mar 2025 07:38:27 -0700 (PDT)
Message-ID: <7994e6dd-e5da-4527-b08b-337b5cb3e3dd@kernel.dk>
Date: Thu, 27 Mar 2025 08:38:25 -0600
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
Subject: [GIT PULL] Final io_uring updates/fixes for 6.15-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Final separate pull request for io_uring. Started out as a series of
cleanups improvements and improvements for registered buffers, but as
the last series of the io_uring changes for 6.15, it also collected a
few fixes for the other branches on top. Sits on top of the previously
sent out zc-rx and epoll-wait pull requests. This pull request contains:

- Add support for vectored fixed/registered buffers. Previously only
  single segments have been supported for commands, now vectored
  variants are supported as well. This series includes networking
  and file read/write support.

- Small series unifying return codes across multi and single shot.

- Small series cleaning up registerd buffer importing.

- Adding support for vectored registered buffers for uring_cmd.

- Fix for io-wq handling of command reissue.

- Various little fixes and tweaks.

Please pull!


The following changes since commit 0d83b8a9f180436a84fbdeb575696b0c3ae0ac0c:

  io_uring: introduce io_cache_free() helper (2025-03-05 07:38:55 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.15/io_uring-reg-vec-20250327

for you to fetch changes up to 6889ae1b4df1579bcdffef023e2ea9a982565dff:

  io_uring/net: fix io_req_post_cqe abuse by send bundle (2025-03-27 05:48:32 -0600)

----------------------------------------------------------------
Caleb Sander Mateos (2):
      io_uring/net: only import send_zc buffer once
      io_uring/net: use REQ_F_IMPORT_BUFFER for send_zc

Jens Axboe (3):
      Merge branch 'for-6.15/io_uring' into for-6.15/io_uring-reg-vec
      Merge branch 'for-6.15/io_uring-rx-zc' into for-6.15/io_uring-reg-vec
      Merge branch 'for-6.15/io_uring-epoll-wait' into for-6.15/io_uring-reg-vec

Pavel Begunkov (23):
      io_uring: introduce struct iou_vec
      io_uring: add infra for importing vectored reg buffers
      io_uring/rw: implement vectored registered rw
      io_uring/rw: defer reg buf vec import
      io_uring/net: combine msghdr copy
      io_uring/net: pull vec alloc out of msghdr import
      io_uring/net: convert to struct iou_vec
      io_uring/net: implement vectored reg bufs for zctx
      io_uring: cap cached iovec/bvec size
      io_uring: return -EAGAIN to continue multishot
      io_uring: unify STOP_MULTISHOT with IOU_OK
      io_uring: introduce io_prep_reg_iovec()
      io_uring: rely on io_prep_reg_vec for iovec placement
      io_uring: rename the data cmd cache
      io_uring/cmd: don't expose entire cmd async data
      io_uring/cmd: add iovec cache for commands
      io_uring/cmd: introduce io_uring_cmd_import_fixed_vec
      io_uring: fix retry handling off iowq
      io_uring: defer iowq cqe overflow via task_work
      io_uring: open code __io_post_aux_cqe()
      io_uring: rename "min" arg in io_iopoll_check()
      io_uring: move min_events sanitisation
      io_uring/net: fix io_req_post_cqe abuse by send bundle

 include/linux/io_uring/cmd.h   |  13 ++
 include/linux/io_uring_types.h |  19 ++-
 include/uapi/linux/io_uring.h  |   2 +
 io_uring/alloc_cache.h         |   9 --
 io_uring/io_uring.c            |  65 ++++-----
 io_uring/io_uring.h            |  19 +--
 io_uring/net.c                 | 235 +++++++++++++++++----------------
 io_uring/net.h                 |   6 +-
 io_uring/opdef.c               |  42 +++++-
 io_uring/poll.c                |   5 +-
 io_uring/rsrc.c                | 163 +++++++++++++++++++++++
 io_uring/rsrc.h                |  24 ++++
 io_uring/rw.c                  |  94 ++++++++++---
 io_uring/rw.h                  |   6 +-
 io_uring/uring_cmd.c           |  59 +++++++--
 io_uring/uring_cmd.h           |  17 +++
 16 files changed, 567 insertions(+), 211 deletions(-)

-- 
Jens Axboe


