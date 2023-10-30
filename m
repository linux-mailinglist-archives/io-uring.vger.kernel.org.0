Return-Path: <io-uring+bounces-5-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54EE27DBBDB
	for <lists+io-uring@lfdr.de>; Mon, 30 Oct 2023 15:34:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7911E1C20A20
	for <lists+io-uring@lfdr.de>; Mon, 30 Oct 2023 14:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B07ED182A7;
	Mon, 30 Oct 2023 14:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3SsP/2TK"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603BB182A3
	for <io-uring@vger.kernel.org>; Mon, 30 Oct 2023 14:34:13 +0000 (UTC)
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98184C2
	for <io-uring@vger.kernel.org>; Mon, 30 Oct 2023 07:34:10 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-3575732df7fso1116095ab.0
        for <io-uring@vger.kernel.org>; Mon, 30 Oct 2023 07:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1698676450; x=1699281250; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3K5vr9MFVDJuDt7sckF+/Bpkp9UdGqJQKoupHxjAFPo=;
        b=3SsP/2TKmCXMUTtFfV6Fom2i9xkLj05tzfkyS7ZMmgjtlVz0Xmn68C0HjikXqZSdbV
         cv3MpCriUW2qt9adjdPOcvr9J9Ff4FPGALjgSnDd/n746/FKoMMN7O86vPYZLdyOFhvm
         JrkPgmSRWg2JfInCJVOo81co3kqbdPpcerbsZugoKcXv3OHRYaYleir7gymagTCypQES
         cqKEr6TSYxroX4sSqqHtXw1LO5VhDVvnGmgPf4xkzcidQJ1K7essOBaDFO2uA6e16ILV
         ArKyR9ugIEeHEBpSv/m/UFMZuNupwpCM1VwIMwmW2vTbgCSxVO1lj6NJ23xseGc5Nosg
         PCpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698676450; x=1699281250;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3K5vr9MFVDJuDt7sckF+/Bpkp9UdGqJQKoupHxjAFPo=;
        b=eCr82g6IO2gK7V680Ya6ZJo+sIw437dQD64i0K1h8bhv6FG49/QgKTvdIAO31Zi3Ol
         5gsqSnQFF7Vvk3VGmXasAHub+S8gVHaGD8iHnOeaboq7Y3n+475qrtK9JaVY+zAA6e6Q
         08u/Dz6xNP9uYNKRggruSUUbCgUUIDSv30oAERCxKtRpKC5hk3VAfS4xC+JJxp0jkRLF
         QS+8Rd47MboGKMDkEhbCNUw6AmQisYqmyxaKj7hF4ZjaqbCl+IaJKLDTfQ/MCXcfpIIF
         T/oQtZYC6rVzlw4X7u0e+nGDnFpeSCCG4n+4UypLrB8c+7vrLjEzd2546j/O2pNAu5JD
         xTKg==
X-Gm-Message-State: AOJu0Yxs2b2PC7X9LC4e0IFG+iTnvDY09A6ioz04Esv5Uuk7LyjzQata
	VnzL8ErlfKg2Wrj2bsJMYHlFuw==
X-Google-Smtp-Source: AGHT+IFycfbXxDyyQOW+c8z5L3yI4ghAaaxJimp5/JQtL2XGUcAy5e3MCgf2zLBtxpstCmp1vRp/tg==
X-Received: by 2002:a05:6e02:320b:b0:358:ff34:cd3a with SMTP id cd11-20020a056e02320b00b00358ff34cd3amr9833405ilb.3.1698676449889;
        Mon, 30 Oct 2023 07:34:09 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l14-20020a056e021c0e00b0034e2572bb50sm2449222ilh.13.2023.10.30.07.34.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Oct 2023 07:34:08 -0700 (PDT)
Message-ID: <2a4567f5-7599-4729-8563-3f9c8b23d672@kernel.dk>
Date: Mon, 30 Oct 2023 08:34:07 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>,
 Christian Brauner <brauner@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 6.7-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Here's the first batch of io_uring updates for the 6.7 merge window.
This contains the core bits, of which there are not many, and adds
support for using WAITID through io_uring and hence not needing to block
on these kinds of events. Outside of that, tweaks to the legacy provided
buffer handling and some cleanups related to cancelations for uring_cmd
support.

Please pull!


The following changes since commit ce9ecca0238b140b88f43859b211c9fdfd8e5b70:

  Linux 6.6-rc2 (2023-09-17 14:40:24 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.7/io_uring-2023-10-30

for you to fetch changes up to 6ce4a93dbb5bd93bc2bdf14da63f9360a4dcd6a1:

  io_uring/poll: use IOU_F_TWQ_LAZY_WAKE for wakeups (2023-10-19 06:42:29 -0600)

----------------------------------------------------------------
for-6.7/io_uring-2023-10-30

----------------------------------------------------------------
Gabriel Krisman Bertazi (3):
      io_uring/kbuf: Fix check of BID wrapping in provided buffers
      io_uring/kbuf: Allow the full buffer id space for provided buffers
      io_uring/kbuf: Use slab for struct io_buffer objects

Jens Axboe (10):
      io_uring/rw: split io_read() into a helper
      io_uring/rw: mark readv/writev as vectored in the opcode definition
      io_uring/rw: add support for IORING_OP_READ_MULTISHOT
      exit: abstract out should_wake helper for child_wait_callback()
      exit: move core of do_wait() into helper
      exit: add kernel_waitid_prepare() helper
      exit: add internal include file with helpers
      io_uring: add IORING_OP_WAITID support
      io_uring/rsrc: cleanup io_pin_pages()
      io_uring/poll: use IOU_F_TWQ_LAZY_WAKE for wakeups

Ming Lei (2):
      io_uring: retain top 8bits of uring_cmd flags for kernel internal use
      io_uring: cancelable uring_cmd

 include/linux/io_uring.h       |  18 ++
 include/linux/io_uring_types.h |  10 +-
 include/uapi/linux/io_uring.h  |   8 +-
 io_uring/Makefile              |   3 +-
 io_uring/cancel.c              |   5 +
 io_uring/io_uring.c            |  43 ++++-
 io_uring/io_uring.h            |   1 +
 io_uring/kbuf.c                |  58 ++++---
 io_uring/opdef.c               |  24 ++-
 io_uring/opdef.h               |   2 +
 io_uring/poll.c                |   2 +-
 io_uring/rsrc.c                |  37 ++--
 io_uring/rw.c                  |  92 +++++++++-
 io_uring/rw.h                  |   2 +
 io_uring/uring_cmd.c           |  49 +++++-
 io_uring/waitid.c              | 372 +++++++++++++++++++++++++++++++++++++++++
 io_uring/waitid.h              |  15 ++
 kernel/exit.c                  | 131 ++++++++-------
 kernel/exit.h                  |  30 ++++
 19 files changed, 782 insertions(+), 120 deletions(-)
 create mode 100644 io_uring/waitid.c
 create mode 100644 io_uring/waitid.h
 create mode 100644 kernel/exit.h

-- 
Jens Axboe


