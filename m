Return-Path: <io-uring+bounces-6194-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DCF0A23FD7
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 16:45:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBF651650FC
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 15:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C4B1B424F;
	Fri, 31 Jan 2025 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QX265/Yy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A663EA98
	for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 15:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738338350; cv=none; b=IUtO4aRTRLXf1pXnvHBJFBNlyLjWPyK9spvJueK0J/nXJboO5wM3031OyJmopNnQcdV3+bX+wLhUvM0cSr08eMIdiQNCgKa11AnoemoiCmTrXoCFze9Q2FEjVpJsQM40ZMxA/lzngSGsY5lQqNlcUMr20zfq9gIMsXTdgn5SLBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738338350; c=relaxed/simple;
	bh=p6/MFqCzWcc9s2XzZWe1DalMOOYR9fU7KMKNz+BgYTY=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Fd9eG9tSjQb55dfWt6BqZbf8ccXgmcRuLoWlaYfZF+gMr4KCLvxGxXcBRmsVHTZVVz7QZoeuuC6IwfSgj+/DYVH3tKs9gh/jHDuuk5E56I+LGDTL5nRg/QhoFJNLz5fDFVmn/iahgMlxsFQl8fL9Z0xL1Dm6QXcRWaYUWau4q2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QX265/Yy; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-852050432a8so56066639f.1
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 07:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738338347; x=1738943147; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VTO+VWZOzndb7AXQUXt8pYr4IST+6MKBqq+HexQ3dkI=;
        b=QX265/YyM3zB2rKlnpyHH3MNbr+XEh2UM1oLYJcB2JU7WITvxAzS6dLeD91w0GMH6Q
         dCjmcMyctRiGpQi98uDR9FitCKclMmg1b99m/yVHpoIery7+FyK/v3WtZY+kSFA95uGN
         X1WgQP6Kza/5JfXIyBg0AS0ziNfO4GgYjnd8U2uQsKr/Lcreli0QqMPlEPuw7MqqVXKw
         hJ/EdO1HbZ5l8r+MGsK/+U763Ry6g68unD8c36T27splqq5O5lZW2c0IE64df566VT5Q
         6q59/xDaBYzVheCTBDM47iZOGlCztd6sVJ38Q2YAc9tBmCJlC5StA/siKVm3aGTo5OrF
         c4NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738338347; x=1738943147;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VTO+VWZOzndb7AXQUXt8pYr4IST+6MKBqq+HexQ3dkI=;
        b=err3/F2m9nLJ7GzjukN30VvpN7ELZFCAOCpJAp/I4ZbPGtigPNE2Vto+67GciPtoL8
         0mhV1bUs4gw79zlRhTsld4hZOL2Vzupp8ai3GkpWC3bSbAZLIJ7qWMIN0o9QM5Vnu/4P
         NSNIjezRD3ivrcTupJ330+BxHVujjBQ3EGqpEhOS48CrHf+MjmuMG8/SJmOSPan0l44Q
         M4F8byQK3N+8QMM7OEpjH7ZQLpEMCvg7nlc+bAU2UKT4R6/C1doZ7a5mHV4anbo1w3nU
         0+TD8v98+9dp0ali8nApaceHQQgQDO//wqa4hY2J6a5BvJRZEdAvsyyeT2fusNqoXv9w
         luTg==
X-Gm-Message-State: AOJu0Yys/4CT8hLegf2W4IndR5wXwNtGM+oz2CSDQU/KBVFejSNqEP81
	sfGuo5KU+tlSevdLNte9+cR82g8x7kBTJn51fB9OU49VTl/iGBvuRvZjcZ0Sk6OYxlfJBBnzzgd
	o
X-Gm-Gg: ASbGncsfgNG0MII0kdfK3VWnmiHp+0hnjeaI3k4lO5Kqb6SpC7HebcIFaBQQ+5D6alx
	uPP7NgxU6On4XFM87WX6O+Baw61enuMQC+vKA5N43O+00a/N+S0g0AUl2RCdGfAOaDf+ThA43fO
	Luw+hCYF07nyigcICTO1p51KQbEA31JsdS5EqF9hmYZ2/CQ9rR7VJGH0an8teyzcMEzUTJ0RlQR
	Dgjx7nzMfMVDUXJemTS3MEPNbK9ApoYiOz6E3ZUWauU509v5OpzHMfxuiTzqbgDiXEdvFf4rGNS
	ckKSSha0YoM=
X-Google-Smtp-Source: AGHT+IF4TJVrHNUYny6Z2vYwTFQz98TCCtQiEnf22O8g9GJqTcPDyh896ksowTRkqXaxaRpSP7LAAA==
X-Received: by 2002:a05:6602:3e97:b0:852:317a:23c9 with SMTP id ca18e2360f4ac-8549fa9435bmr671337339f.6.1738338346727;
        Fri, 31 Jan 2025 07:45:46 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-854a15f846bsm93185339f.13.2025.01.31.07.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2025 07:45:46 -0800 (PST)
Message-ID: <d4331bf1-d6bd-4883-a460-fbd40ea837ab@kernel.dk>
Date: Fri, 31 Jan 2025 08:45:45 -0700
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
Subject: [GIT PULL] Final io_uring updates for 6.14-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Followup pull request for io_uring for the 6.14 merge window. This pull
request contains:

- Series cleaning up the alloc cache changes from this merge window, and
  then another series on top making it better yet. This also solves an
  issue with KASAN_EXTRA_INFO, by making io_uring resilient to KASAN
  using parts of the freed struct for storage.

- Cleanups and simplications to buffer cloning and io resource node
  management.

- Fix an issue introduced in this merge window where READ/WRITE_ONCE was
  used on an atomic_t, which made some archs complain.

- Fix for an errant connect retry when the socket has been shut down.

- Fix for multishot and provided buffers.

Please pull!


The following changes since commit 95ec54a420b8f445e04a7ca0ea8deb72c51fe1d3:

  Merge tag 'powerpc-6.14-1' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux (2025-01-20 21:40:19 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.14-20250131

for you to fetch changes up to 8c8492ca64e79c6e0f433e8c9d2bcbd039ef83d0:

  io_uring/net: don't retry connect operation on EPOLLERR (2025-01-30 09:41:25 -0700)

----------------------------------------------------------------
io_uring-6.14-20250131

----------------------------------------------------------------
Jann Horn (2):
      io_uring/rsrc: Simplify buffer cloning by locking both rings
      io_uring/rsrc: Move lockdep assert from io_free_rsrc_node() to caller

Jens Axboe (7):
      io_uring/msg_ring: don't leave potentially dangling ->tctx pointer
      io_uring/uring_cmd: use cached cmd_op in io_uring_cmd_sock()
      io_uring/uring_cmd: cleanup struct io_uring_cmd_data layout
      io_uring: get rid of alloc cache init_once handling
      io_uring/alloc_cache: get rid of _nocache() helper
      io_uring/register: use atomic_read/write for sq_flags migration
      io_uring/net: don't retry connect operation on EPOLLERR

Pavel Begunkov (10):
      io_uring: clean up io_uring_register_get_file()
      io_uring: fix multishots with selected buffers
      io_uring: include all deps for alloc_cache.h
      io_uring: dont ifdef io_alloc_cache_kasan()
      io_uring: add alloc_cache.c
      io_uring/net: make io_net_vec_assign() return void
      io_uring/net: clean io_msg_copy_hdr()
      io_uring/net: extract io_send_select_buffer()
      io_uring: remove !KASAN guards from cache free
      io_uring/rw: simplify io_rw_recycle()

Sidong Yang (1):
      io_uring/rsrc: remove unused parameter ctx for io_rsrc_node_alloc()

 include/linux/io_uring/cmd.h   |   2 +-
 include/linux/io_uring_types.h |   3 +-
 io_uring/Makefile              |   2 +-
 io_uring/alloc_cache.c         |  44 ++++++++++++++
 io_uring/alloc_cache.h         |  69 ++++++++++-----------
 io_uring/filetable.c           |   2 +-
 io_uring/futex.c               |   4 +-
 io_uring/io_uring.c            |  12 ++--
 io_uring/io_uring.h            |  21 +++----
 io_uring/msg_ring.c            |   4 +-
 io_uring/net.c                 | 134 +++++++++++++++++++++--------------------
 io_uring/net.h                 |  20 +++---
 io_uring/poll.c                |   6 +-
 io_uring/register.c            |   8 ++-
 io_uring/rsrc.c                |  88 ++++++++++++++-------------
 io_uring/rsrc.h                |   5 +-
 io_uring/rw.c                  |  41 +++----------
 io_uring/rw.h                  |  27 +++++----
 io_uring/timeout.c             |   2 +-
 io_uring/uring_cmd.c           |  19 ++----
 io_uring/waitid.c              |   2 +-
 21 files changed, 272 insertions(+), 243 deletions(-)
 create mode 100644 io_uring/alloc_cache.c

-- 
Jens Axboe


