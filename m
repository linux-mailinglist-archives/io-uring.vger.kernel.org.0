Return-Path: <io-uring+bounces-2508-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A6E09308EF
	for <lists+io-uring@lfdr.de>; Sun, 14 Jul 2024 09:50:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11B06B212FD
	for <lists+io-uring@lfdr.de>; Sun, 14 Jul 2024 07:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 139D110958;
	Sun, 14 Jul 2024 07:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pzAi5Npm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5391625761
	for <io-uring@vger.kernel.org>; Sun, 14 Jul 2024 07:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720943424; cv=none; b=RuFKwtTlnirTlc31ZK/JCsm/ZEozRDVou5HUyC6hGtkzLkVd7D+6jbB89S8HGyAqwpl9CrI0izHjzv/7KIalpZ64tAtsDPmoRBF8OfVYHS/2QIRFilLFOXT4JzdVMFr5Kw8XnxdFjt3azPE4KRxbmyJZ8kAoaD2AMLpVGetM8Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720943424; c=relaxed/simple;
	bh=/oLxtDl4Yk0M8+/He+4G8AaatQ/Pbr1nFKit8rWDPBY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=gR7HEJdD34+OA0DTPFSlxS/FamfWJsP5QA+s1eDF6l8vPse0+ZYoQsUpClcxP30jRyKE9A/xE6k99Xb1tQ+kVf2NKqOvTd3aiyiEKtS7Si8Yth1xTrJs6bhT4NSXSD7Ck8gPbPuLqmtK1FV+/Kxkgg3jaM2XXeRXZFfnhudOtkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pzAi5Npm; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-59adf476c9dso150043a12.1
        for <io-uring@vger.kernel.org>; Sun, 14 Jul 2024 00:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1720943418; x=1721548218; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cYHB98M1MaUdcSL6GDcZ4ARPQl+R/zPbF/ZKr4YI7Yg=;
        b=pzAi5NpmmVsJxwNNiDjjIfqFaJ47dzJwVv1+cVmC/Xhx17idYC8hEqXfIFJYFDxxYq
         gI2Du65Lp9RscWns8FGGhUFF3qAKsetKACoyHGaR2tGNekt/bnNx0e5miaVOrhM4CPeJ
         IoyxGURSxulhMC7e5ZiHhumKZ8GynMrx0F0yIy7/97pRi49ZPalunLjzlQnKZoqaz3Bb
         Hnc2T/OyclPOX+dbcFXkTuQxNSUw3unl23xW7Qo6IwWgf2faek2IC6mVtw9ZJG1TdPL/
         RP2PchwsN9L1W9Z7Hj53Y/Id1R3TIq32qmwtIFAKXX78zNVmVzVMMcpA+i0EXnXW5oda
         x3sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720943418; x=1721548218;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cYHB98M1MaUdcSL6GDcZ4ARPQl+R/zPbF/ZKr4YI7Yg=;
        b=nABS2HaPo7t/32SR4rE6Whyeh4dgYZziUTHKwKu9EgqSrOTIfEdQdD3FfShxK0AU1F
         X/HLGahsXZI1Rj0ju+yJR6tWItia3FaulgTH4E3e1IoES8DK5CDGKtXkWoNhuSfJdT99
         eFFTSSafzCWVY7iUsDOICylP8PL2xn08os4719B95DtSA7C4TZP4Qo8Ko/0ssr9lvziw
         phGwMqTgKI5WqeqiNZoZGFNE9O8JJXR4ZTML65+/LdBeO8lHoMnpzDFIvHYIxdq6K88L
         eBiR3oX9i2mjN+EUlyZYetHJBgywo6b7r4FNmhY12bd8/+PI65mJ+/dJaZ/L6AGBkrgB
         Q2lQ==
X-Gm-Message-State: AOJu0YxbrleFxhJO5A4XQa19CmfgVhHdG+gXNTltjDWJSKFy0g/F3vrE
	l7eUWARIMx+liu77/J5J1dKpJTCovoTuWjUlnhvNBU7VVg7t6UVeyiAgxCAUcvvrXN/5AN/dmpj
	2mW9VUY+7
X-Google-Smtp-Source: AGHT+IH6046nHPEGTZ4gsDzLJ2xIa1Mo1MCg3w6hsUcbnIiI+7OHXUn9jYEDf5meO1mBzyDHz//w6g==
X-Received: by 2002:a17:906:795:b0:a72:b5c7:d635 with SMTP id a640c23a62f3a-a798b511715mr422796566b.4.1720943418197;
        Sun, 14 Jul 2024 00:50:18 -0700 (PDT)
Received: from ?IPV6:2a02:aa7:464b:1644:7862:56e0:794e:2? ([2a02:aa7:464b:1644:7862:56e0:794e:2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc5b8366sm106249066b.61.2024.07.14.00.50.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jul 2024 00:50:17 -0700 (PDT)
Message-ID: <5808867d-c2dc-4c34-a14c-ece564b28cc2@kernel.dk>
Date: Sun, 14 Jul 2024 01:50:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] io_uring updates for 6.11-rc1
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
References: <5e5b2431-dd9b-488e-a0c9-578008e14208@kernel.dk>
Content-Language: en-US
In-Reply-To: <5e5b2431-dd9b-488e-a0c9-578008e14208@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/11/24 11:43 PM, Jens Axboe wrote:
> Hi Linus,
> 
> Sending this one early as I'm out on vacation.
> 
> Here are the io_uring updates queued up for the 6.11 merge window.
> Nothing major this time around, various minor improvements and
> cleanups/fixes. This pull request contains:
> 
> - Add bind/listen opcodes. Main motivation is to support direct
>   descriptors, to avoid needing a regular fd just for doing these two
>   operations (Gabriel)
> 
> - Probe fixes (Gabriel)
> 
> - Treat io-wq work flags as atomics. Not fixing a real issue, but may
>   as well and it silences a KCSAN warning (me)
> 
> - Cleanup of rsrc __set_current_state() usage (me)
> 
> - Add 64-bit for {m,f}advise operations (me)
> 
> - Improve performance of data ring messages (me)
> 
> - Fix for ring message overflow posting (Pavel)
> 
> - Fix for freezer interaction with TWA_NOTIFY_SIGNAL. Not strictly an
>   io_uring thing, but since TWA_NOTIFY_SIGNAL was originally added for
>   faster task_work signaling for io_uring, bundling it with this pull.
>   (Pavel)
> 
> - Add Pavel as a co-maintainer
> 
> - Various cleanups (me, Thorsten)
> 
> Please pull!

Added one more patch to fix an issue with the bind/listen additions
mentioned above, otherwise no other changes. Updated git pull request
details below:
 
The following changes since commit 6ba59ff4227927d3a8530fc2973b80e94b54d58f:

  Linux 6.10-rc4 (2024-06-16 13:40:16 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.11/io_uring-20240714

for you to fetch changes up to ad00e629145b2b9f0d78aa46e204a9df7d628978:

  io_uring/net: check socket is valid in io_bind()/io_listen() (2024-07-13 06:40:15 -0600)

----------------------------------------------------------------
for-6.11/io_uring-20240714

----------------------------------------------------------------
Gabriel Krisman Bertazi (8):
      io_uring: Drop per-ctx dummy_ubuf
      io_uring/rsrc: Drop io_copy_iov in favor of iovec API
      net: Split a __sys_bind helper for io_uring
      net: Split a __sys_listen helper for io_uring
      io_uring: Introduce IORING_OP_BIND
      io_uring: Introduce IORING_OP_LISTEN
      io_uring: Fix probe of disabled operations
      io_uring: Allocate only necessary memory in io_probe

Jens Axboe (15):
      io_uring/eventfd: move to more idiomatic RCU free usage
      io_uring/eventfd: move eventfd handling to separate file
      io_uring: use 'state' consistently
      io_uring/io-wq: make io_wq_work flags atomic
      io_uring/rsrc: remove redundant __set_current_state() post schedule()
      io_uring/advise: support 64-bit lengths
      io_uring/msg_ring: tighten requirement for remote posting
      io_uring: add remote task_work execution helper
      io_uring: add io_add_aux_cqe() helper
      io_uring/msg_ring: improve handling of target CQE posting
      io_uring/msg_ring: add an alloc cache for io_kiocb entries
      io_uring/msg_ring: check for dead submitter task
      io_uring/msg_ring: use kmem_cache_free() to free request
      MAINTAINERS: change Pavel Begunkov from io_uring reviewer to maintainer
      io_uring/net: cleanup io_recv_finish() bundle handling

Pavel Begunkov (3):
      io_uring/msg_ring: fix overflow posting
      io_uring/io-wq: limit retrying worker initialisation
      kernel: rerun task_work while freezing in get_signal()

Tetsuo Handa (1):
      io_uring/net: check socket is valid in io_bind()/io_listen()

Thorsten Blum (1):
      io_uring/napi: Remove unnecessary s64 cast

 MAINTAINERS                    |   2 +-
 include/linux/io_uring_types.h |  14 ++--
 include/linux/socket.h         |   3 +
 include/uapi/linux/io_uring.h  |   2 +
 io_uring/Makefile              |   6 +-
 io_uring/advise.c              |  16 +++--
 io_uring/eventfd.c             | 160 +++++++++++++++++++++++++++++++++++++++++
 io_uring/eventfd.h             |   8 +++
 io_uring/io-wq.c               |  29 ++++----
 io_uring/io-wq.h               |   2 +-
 io_uring/io_uring.c            | 150 ++++++++++++++------------------------
 io_uring/io_uring.h            |   9 +--
 io_uring/msg_ring.c            | 122 +++++++++++++++++++------------
 io_uring/msg_ring.h            |   1 +
 io_uring/napi.c                |   2 +-
 io_uring/net.c                 |  94 +++++++++++++++++++++---
 io_uring/net.h                 |   6 ++
 io_uring/opdef.c               |  34 +++++++++
 io_uring/opdef.h               |   4 +-
 io_uring/register.c            |  65 ++---------------
 io_uring/rsrc.c                |  63 ++++++----------
 kernel/signal.c                |   8 +++
 net/socket.c                   |  48 ++++++++-----
 23 files changed, 538 insertions(+), 310 deletions(-)
 create mode 100644 io_uring/eventfd.c
 create mode 100644 io_uring/eventfd.h

-- 
Jens Axboe


