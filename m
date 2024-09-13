Return-Path: <io-uring+bounces-3187-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6278978654
	for <lists+io-uring@lfdr.de>; Fri, 13 Sep 2024 19:02:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D24711C22376
	for <lists+io-uring@lfdr.de>; Fri, 13 Sep 2024 17:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCEEE82D66;
	Fri, 13 Sep 2024 17:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Oni/lgAf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8925857CBB
	for <io-uring@vger.kernel.org>; Fri, 13 Sep 2024 17:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726246935; cv=none; b=O64yCRXT+acY4k3y8gJ2waCd7tZ2PmWfDdIH+iQ40zgB3JTz9YrT5cZWWe8DHMOO8lMM4ZeDjuGZx3UY+Rs8Mk6LFuxy9gJHEW9lh2QkeCpPSnuZhMxtiozY69ihqwvspqNzuA9mpgrQBUwQoCzqbWONnbWHzuCpPQqPwCCu9tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726246935; c=relaxed/simple;
	bh=ciUXSuloLBlw7bBIPEWstBfP2e1ZPSKb/saVNoFnmFE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=LUX/cBQLzgQPP704rjDnH0CFEly8/+N9eKgkx6VEV3c5NptKiCoedEyqiozFr05lihnIIDJbQtpHF9VjSBQRLIm+b9rP1wgAm89NIUzUQm7wq2uWpMFLy/seJp3M91PWqDlw4JMepwd1fa6KHYK68e23mbVeEMeH6On//269Omg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Oni/lgAf; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-718d962ad64so1975336b3a.0
        for <io-uring@vger.kernel.org>; Fri, 13 Sep 2024 10:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726246930; x=1726851730; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WMUDT9aIpMQ5ZxifNuNp/jGIFGlERgK9UuPxM5GZn/g=;
        b=Oni/lgAfwTVZwKrYB7AcSLPDhK4QTDXLnu+orUxBgwEQmTUMM+GlDlYxRYB/LpFPyW
         gpN8i26ml+f6YtxEE+7N5BtaPoUStqboVR7CnZ2XMu4slHKy0dxo+YfDyFpPSeYIll3Z
         PvyE/C68Z1rfdzUzwZBvHkYXNnxeKqgDDizqe9USqLOwslkM9sXSfsHqKwdJycCo0ZzS
         3kgoBrcRDI3YRvgwoCEHbepHGpN+dDtm5VkuwIDpqewqRIErtsngCGxZoNA2tX8enuV2
         63ZpU2lMCsi0XjRK0zl87WWdKgseRtTkH5x5DqhaD+p2fga7k8YivXtaJpQ3ACPbBIYb
         IIUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726246930; x=1726851730;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WMUDT9aIpMQ5ZxifNuNp/jGIFGlERgK9UuPxM5GZn/g=;
        b=Ydb6lndGJ5IYMY5YVF910s7Y9W9mF/IRlPBXpjb8S9F2A9YRrYlba6cl07CuC47WAG
         G2rPKSyvCxSb8uVmCjr4L5R8EyVOjwuDcbr3Xkmm0sfjwbgilDfsYtwtOr55kUHz0ehR
         xGAR3qbQGu1hUiGpBe5L7a/cybwtQ8ddQrQfHQm+Sipq1KMay5y1lRiwCJNaSYNU4iL2
         utsp7Wsiw90s3iD5u/Kfx8U7gGmYsAlCa4NwXtMlaZRXdU+wJU7HwC+w6BZD+n+ovfgs
         PD7uI8DWsVserOyRY7dEa2wNr0fzaWZ6bChWP5muoKAuZud8i05Dl1v9AmbBRGvN5J7W
         XZOQ==
X-Gm-Message-State: AOJu0YzFjLKETdwdTfzrqmvw0xcvGh9m3i3OgopwJGoRyxA73JTMcIe7
	H7BzcgracqNklteRIIpli8rlqCkdmSILn/Cux04MmT+N7110/VsI1X+s0Ot7NLMFj4GiSsMPEzI
	j
X-Google-Smtp-Source: AGHT+IHY1g3Kx5dLM1uPTT3NOylbwDGrZSHB07K8GGJZwgsFJ10s6Tj/iDN0b8GLTzMohKhwdHfdzQ==
X-Received: by 2002:a05:6a00:14d0:b0:717:9768:a4ed with SMTP id d2e1a72fcca58-7192609318dmr12268508b3a.16.1726246929521;
        Fri, 13 Sep 2024 10:02:09 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-719090c37efsm6306053b3a.187.2024.09.13.10.02.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Sep 2024 10:02:08 -0700 (PDT)
Message-ID: <aa117c13-193f-479d-a0de-9fca9bfc00a8@kernel.dk>
Date: Fri, 13 Sep 2024 11:02:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 6.12-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Here are the main io_uring changes for the 6.12 merge window. There will
be a followup one that adds discard support, but since that depends on
both this branch and the block branch, it'll be sent post both of those.

This pull request contains:

- NAPI fixes and cleanups (Pavel, Olivier)

- Add support for absolute timeouts (Pavel)

- Fixes for io-wq/sqpoll affinities (Felix)

- Efficiency improvements for dealing with huge pages (Chenliang)

- Support for a minwait mode, where the application essentially has two
  timouts - one smaller one that defines the batch timeout, and the
  overall large one similar to what we had before. This enables
  efficient use of batching based on count + timeout, while still working
  well with periods of less intensive workloads.

- Use ITER_UBUF for single segment sends

- Add support for incremental buffer consumption. Right now each
  operation will always consume a full buffer. With incremental
  consumption, a recv/read operation only consumes the part of the
  buffer that it needs to satisfy the operation.

- Add support for GCOV for io_uring, to help retain a high coverage of
  test to code ratio.

- Fix regression with ocfs2, where an odd -EOPNOTSUPP wasn't correctly
  converted to a blocking retry.

- Add support for cloning registered buffers from one ring to another.

- Misc cleanups (Anuj, me)

Please pull!


The following changes since commit 5be63fc19fcaa4c236b307420483578a56986a37:

  Linux 6.11-rc5 (2024-08-25 19:07:11 +1200)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.12/io_uring-20240913

for you to fetch changes up to 7cc2a6eadcd7a5aa36ac63e6659f5c6138c7f4d2:

  io_uring: add IORING_REGISTER_COPY_BUFFERS method (2024-09-12 10:14:15 -0600)

----------------------------------------------------------------
for-6.12/io_uring-20240913

----------------------------------------------------------------
Anuj Gupta (2):
      io_uring: add new line after variable declaration
      io_uring: remove unused rsrc_put_fn

Chenliang Li (2):
      io_uring/rsrc: store folio shift and mask into imu
      io_uring/rsrc: enable multi-hugepage buffer coalescing

Felix Moessbauer (3):
      io_uring/sqpoll: do not allow pinning outside of cpuset
      io_uring/io-wq: do not allow pinning outside of cpuset
      io_uring/io-wq: inherit cpuset of cgroup in io worker

Jens Axboe (22):
      io_uring/kbuf: use 'bl' directly rather than req->buf_list
      io_uring/net: use ITER_UBUF for single segment send maps
      io_uring/kbuf: turn io_buffer_list booleans into flags
      io_uring: encapsulate extraneous wait flags into a separate struct
      io_uring: move schedule wait logic into helper
      io_uring: implement our own schedule timeout handling
      io_uring: add support for batch wait timeout
      io_uring: wire up min batch wake timeout
      io_uring/kbuf: shrink nr_iovs/mode in struct buf_sel_arg
      io_uring/kbuf: add io_kbuf_commit() helper
      io_uring/kbuf: move io_ring_head_to_buf() to kbuf.h
      Revert "io_uring: Require zeroed sqe->len on provided-buffers send"
      io_uring/kbuf: pass in 'len' argument for buffer commit
      io_uring/kbuf: add support for incremental buffer consumption
      io_uring: add GCOV_PROFILE_URING Kconfig option
      io_uring/eventfd: move refs to refcount_t
      io_uring/rw: treat -EOPNOTSUPP for IOCB_NOWAIT like -EAGAIN
      io_uring/rw: drop -EOPNOTSUPP check in __io_complete_rw_common()
      io_uring/rsrc: clear 'slot' entry upfront
      io_uring/rsrc: add reference count to struct io_mapped_ubuf
      io_uring/register: provide helper to get io_ring_ctx from 'fd'
      io_uring: add IORING_REGISTER_COPY_BUFFERS method

Olivier Langlois (2):
      io_uring: add napi busy settings to the fdinfo output
      io_uring: micro optimization of __io_sq_thread() condition

Pavel Begunkov (4):
      io_uring/napi: refactor __io_napi_busy_loop()
      io_uring/napi: postpone napi timeout adjustment
      io_uring: add absolute mode wait timeouts
      io_uring: user registered clockid for wait timeouts

 include/linux/io_uring_types.h |   3 +
 include/uapi/linux/io_uring.h  |  42 ++++++-
 init/Kconfig                   |  13 +++
 io_uring/Makefile              |   4 +
 io_uring/eventfd.c             |  13 ++-
 io_uring/fdinfo.c              |  14 ++-
 io_uring/io-wq.c               |  25 ++++-
 io_uring/io_uring.c            | 212 ++++++++++++++++++++++++++---------
 io_uring/io_uring.h            |  12 ++
 io_uring/kbuf.c                |  96 ++++++++--------
 io_uring/kbuf.h                |  94 +++++++++++-----
 io_uring/napi.c                |  35 ++----
 io_uring/napi.h                |  16 ---
 io_uring/net.c                 |  27 +++--
 io_uring/register.c            |  91 +++++++++++----
 io_uring/register.h            |   1 +
 io_uring/rsrc.c                | 245 ++++++++++++++++++++++++++++++++++-------
 io_uring/rsrc.h                |  14 ++-
 io_uring/rw.c                  |  19 +++-
 io_uring/sqpoll.c              |   7 +-
 20 files changed, 723 insertions(+), 260 deletions(-)

-- 
Jens Axboe


