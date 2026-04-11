Return-Path: <io-uring+bounces-13026-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UC93E7TZ2mlI6wgAu9opvQ
	(envelope-from <io-uring+bounces-13026-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2026 01:31:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C21C3E1ECA
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2026 01:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 748BA3010DB1
	for <lists+io-uring@lfdr.de>; Sat, 11 Apr 2026 23:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F37DA1C84BB;
	Sat, 11 Apr 2026 23:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="EGiWlSqw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054093376A9
	for <io-uring@vger.kernel.org>; Sat, 11 Apr 2026 23:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775950239; cv=none; b=DeieDnbiwGKfPHN0ShLS52TKBT35TZXB5InWsF5mLyeAZ+aStOMa6WjwCtLijG9aACRCOiG1kvHaPMDvpZXsE8u+wVxpdYoQMxtFEQw8b9BgVZQWQaMJpDzZkVJm0VuhulD5xhLfOyKSer9j77GMXNcqg06KX1lgr1nt07pbQRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775950239; c=relaxed/simple;
	bh=gJCspux6uv1BIBqrnL0AJ3Gz6LC72FQtIjTNzEQysnY=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=ZB7HZHco5MzJmaBc4UKuW65gxw900okSs9j3MfYPXYVLHy7CMUBesycVqiTT6TOJkBcXWFd7NjzbcY91nS8IwAFDHfi4ryiciFPqPnG4uXmY5ftSCLiCgAaxGU4fWkMt1n5T93LYnaNJZl2240A4gE0HL2qk60jb6MtApdX7qV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=EGiWlSqw; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-12c444dbe8eso1080508c88.0
        for <io-uring@vger.kernel.org>; Sat, 11 Apr 2026 16:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775950236; x=1776555036; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nM0gHfg9CKkY+CEVzfbUHrvpjuawplgVc1riD7hVbaY=;
        b=EGiWlSqwg+RVpBYgLCln/ULKyLNEYDYheUVr2DiO95BJ1oiyNEx6FCYFuGyk4AuFGl
         qyyLgRTU2FgF66aGo1sxIlDFfGTZpEShmO1lv/GEjaedUcqWqZ3Gkj368venxnAdaKsr
         B31Bs75NPQBM//yc5f+TsIlGj8EiUAoXI5vaG24D/1YHcLKZwy0qEhP98scTCzHAfD8i
         lNERGyL327yqwwNSEzNSFuVkfhLqMURGvCxz3U82KyakAyPO0XCrOSQoAIFJXgiPUk5A
         3w+O3kEgMK2qYmgyAS2r4BTb7TFGkvDGqUduy0USeXpuXBUhgvF1uka/+ksp6Twy7N49
         8Vjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775950236; x=1776555036;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nM0gHfg9CKkY+CEVzfbUHrvpjuawplgVc1riD7hVbaY=;
        b=W70VD/tt9Fp56GYotlio9IWDAZbxyPuBD5cQyPtlalwrmlc86c+8WmGu92bFUqnMbf
         Dpg9AnFbcDN6qSmZpToCPUFZPrdVnhFxHQE2gap7306KsRA4AHGTZKVLwyH++y6Z2EW+
         3Du2vu7YlxsOL/DvQFtMqoQ1LzTi1Q5CT++mY5f/XIGLyFfQx6MbrRn9Byu5ygIJaBW1
         qLEIc53EKO33wIxU77dboWdTXosG3iZmGKP0eOwyqhvlRljrjjeuQECdgB8McZlO4CWE
         72m+jM++kcMmxs0ab1gudEtK5SSwkKSyoEZ7pgMk4fVijByu6gdlvFu1pYrycydFxEK1
         L9Eg==
X-Gm-Message-State: AOJu0YyFTzLa80kawLJNDi7fPQGKWVoPGr9tpUjnG2uAOtrex74z8rJV
	qSRyg1XxyOZ8eJRGvPQibNunyYMRha4N0J1gfEutmjrlcsYBlofyrxxK+iluzUwJUbE=
X-Gm-Gg: AeBDiett+naSIPnB8w/awtNO3wZUjG9yMZUNwOv2YK43Y4nWz00pWFOgfDJS9rG1iOM
	+5HyMOeSoIhzR9S2vrsJkBf5kUZxsmqJtvuzuEWvw974iKESHvbKcCCXjyc1DHnMcpKMaW0YQm5
	lTsgz+iiqG0BxXDCAkU0+v6V6R5l7ctF8kaH/vdwGeiQeD+aC1ItTzHjNU7yNbgJKcCP/V0a9He
	Mifhp3bCERl8znK+r8RYvMENEuhNY2hCkcr4C3zaURg9ONW+XUycfhER0RpZva5QOQT+wkl09ro
	MrrlMLYw+mhfSuGRLsGDgVpomnVX7OfFahujHR6GkUbngOEj2Sw5g9LhoMKm+MGTrAgTAcsLdMh
	feyFzeaJmDhzQPB0PeuTMMTRzow7CwYKPFDRgOx7qy6bPjZ2745lcu4ucwf1inS5cH+X4eagp8f
	T7MIewRre5V+AteEnhNs2nr5VED6U2jw4Y+jQkd4bqZYmzSOpJZgwjzAoWF7rBZWB9SY5oW7M2d
	3S5ZZpG+toC3s5SEk88qu9+SSY/RNbHXvQ9V5aQDgRkj20Ww5kh
X-Received: by 2002:a05:7301:fd88:b0:2d5:e2b9:5a32 with SMTP id 5a478bee46e88-2d5e2b95cc8mr2892267eec.21.1775950232715;
        Sat, 11 Apr 2026 16:30:32 -0700 (PDT)
Received: from [192.168.68.67] (239.sub-75-226-114.myvzw.com. [75.226.114.239])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d562db64c4sm10211651eec.27.2026.04.11.16.30.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Apr 2026 16:30:30 -0700 (PDT)
Message-ID: <759b8298-18e1-4bb2-a5f9-eeb9341b0c6c@kernel.dk>
Date: Sat, 11 Apr 2026 17:30:28 -0600
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
Subject: [GIT PULL] io_uring changes for the 7.1 merge window
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13026-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+]
X-Rspamd-Queue-Id: 9C21C3E1ECA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Linus,

Sending this a little early as a) I'm currently OOO and traveling, and
b) I won't be back until later in the merge window. These are the core
io_uring changes queued for the 7.1 merge window:

 - Add a callback driven main loop for io_uring, and BPF struct_ops
   on top to allow implementing custom event loop logic.

 - Decouple IOPOLL from being a ring-wide all-or-nothing setting,
   allowing IOPOLL use cases to also issue certain white listed
   non-polled opcodes.

 - Timeout improvements. Migrate internal timeout storage from
   timespec64 to ktime_t for simpler arithmetic and avoid copying of
   timespec data.

 - Zero-copy receive (zcrx) updates
	- Add a device-less mode (ZCRX_REG_NODEV) for testing and
	  experimentation where data flows through the copy fallback
	  path.
	- Fix two-step unregistration regression, DMA length
	  calculations, xarray mark usage, and a potential 32-bit
	  overflow in id shifting.
	- Refactoring toward multi-area support: dedicated refill queue
	  struct, consolidated DMA syncing, netmem array refilling
	  format, and guard-based locking.

 - Zero-copy transmit (zctx) cleanup
	- Unify io_send_zc() and io_sendmsg_zc() into a single
	  function.
	- Add vectorized registered buffer send for
	  IORING_OP_SEND_ZC.
	- Add separate notification user_data via sqe->addr3 so
	  notification and completion CQEs can be distinguished
	  without extra reference counting.

 - Switch struct io_ring_ctx internal bitfields to explicit flag bits
   with atomic-safe accessors, and annotate the known harmless races
   on those flags.

 - Various optimizations caching ctx and other request fields in local
   variables to avoid repeated loads, and cleanups for tctx setup,
   ring fd registration, and read path early returns.

Note - diffstat manually generated because of pulling io_uring-7.0 back
into this branch as later patches depend on changes/fixes in the 7.0
branch. Also note that there's a rename change in the netdev branch, if
you pull post that:

https://lore.kernel.org/all/adjrToW4h60zwxVG@sirena.co.uk/

Please pull!


The following changes since commit c2c185be5c85d37215397c8e8781abf0a69bec1f:

  io_uring/kbuf: check if target buffer list is still legacy on recycle (2026-03-12 08:59:25 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/for-7.1/io_uring-20260411

for you to fetch changes up to c5e9f6a96bf7379da87df1b852b90527e242b56f:

  io_uring: unify getting ctx from passed in file descriptor (2026-04-08 13:21:35 -0600)

----------------------------------------------------------------
for-7.1/io_uring-20260411

----------------------------------------------------------------
Amir Mohammad Jahangirzad (1):
      io_uring/cancel: validate opcode for IORING_ASYNC_CANCEL_OP

Anas Iqbal (1):
      io_uring: cast id to u64 before shifting in io_allocate_rbuf_ring()

Asbjørn Sloth Tønnesen (1):
      io_uring/cmd_net: split ioctl code out of io_uring_cmd_sock()

Caleb Sander Mateos (5):
      io_uring: add REQ_F_IOPOLL
      io_uring: remove iopoll_queue from struct io_issue_def
      io_uring: count CQEs in io_iopoll_check()
      io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
      nvme: remove nvme_dev_uring_cmd() IO_URING_F_IOPOLL check

Jackie Liu (1):
      io_uring/rsrc: use io_cache_free() to free node

Jens Axboe (11):
      io_uring: switch struct io_ring_ctx internal bitfields to flags
      io_uring: mark known and harmless racy ctx->int_flags uses
      io_uring/kbuf: use 'ctx' consistently
      io_uring/poll: cache req->apoll_events
      io_uring/net: use 'ctx' consistently
      io_uring/rw: use cached file rather than req->file
      io_uring: avoid req->ctx reload in io_req_put_rsrc_nodes()
      io_uring/tctx: have io_uring_alloc_task_context() return tctx
      io_uring/tctx: clean up __io_uring_add_tctx_node() error handling
      io_uring/register: don't get a reference to the registered ring fd
      io_uring: unify getting ctx from passed in file descriptor

Joanne Koong (1):
      io_uring/rw: clean up __io_read() obsolete comment and early returns

Pavel Begunkov (36):
      io_uring/zctx: rename flags var for more clarity
      io_uring/zctx: move vec regbuf import into io_send_zc_import
      io_uring/zctx: unify zerocopy issue variants
      io_uring/zcrx: declare some constants for query
      io_uring/zcrx: move zcrx uapi into separate header
      io_uring/timeout: check unused sqe fields
      io_uring/timeout: add helper for parsing user time
      io_uring/timeout: migrate reqs from ts64 to ktime
      io_uring/timeout: immediate timeout arg
      io_uring/net: allow vectorised regbuf send zc
      io_uring/zctx: separate notification user_data
      io_uring: introduce callback driven main loop
      io_uring/bpf-ops: implement loop_step with BPF struct_ops
      io_uring/bpf-ops: add kfunc helpers
      io_uring/bpf-ops: implement bpf ops registration
      io_uring/zcrx: return back two step unregistration
      io_uring/zcrx: fully clean area on error in io_import_umem()
      io_uring/zcrx: always dma map in advance
      io_uring/zcrx: extract netdev+area init into a helper
      io_uring/zcrx: implement device-less mode for zcrx
      io_uring/zcrx: use better name for RQ region
      io_uring/zcrx: add a struct for refill queue
      io_uring/zcrx: use guards for locking
      io_uring/zcrx: move count check into zcrx_get_free_niov
      io_uring/zcrx: warn on alloc with non-empty pp cache
      io_uring/zcrx: netmem array as refiling format
      io_uring/zcrx: consolidate dma syncing
      io_uring/zcrx: warn on a repeated area append
      io_uring/zcrx: cache fallback availability in zcrx ctx
      io_uring/zcrx: check ctrl op payload struct sizes
      io_uring/zcrx: rename zcrx [un]register functions
      io_uring/zcrx: reject REG_NODEV with large rx_buf_size
      io_uring/zcrx: don't use mark0 for allocating xarray
      io_uring/zcrx: don't clear not allocated niovs
      io_uring/zcrx: use dma_len for chunk size calculation
      io_uring/zcrx: use correct mmap off constants

Yang Xiuwei (1):
      io_uring/timeout: use 'ctx' consistently

 drivers/nvme/host/ioctl.c          |   4 -
 include/linux/io_uring_types.h     |  50 +++--
 include/uapi/linux/io_uring.h      | 101 +---------
 include/uapi/linux/io_uring/zcrx.h | 115 +++++++++++
 io_uring/Kconfig                   |   5 +
 io_uring/Makefile                  |   3 +-
 io_uring/bpf-ops.c                 | 270 ++++++++++++++++++++++++++
 io_uring/bpf-ops.h                 |  28 +++
 io_uring/cancel.c                  |   9 +-
 io_uring/cmd_net.c                 |  34 ++--
 io_uring/eventfd.c                 |   4 +-
 io_uring/fdinfo.c                  |   4 +-
 io_uring/io_uring.c                | 190 ++++++++++--------
 io_uring/io_uring.h                |  45 ++---
 io_uring/kbuf.c                    |  18 +-
 io_uring/loop.c                    |  91 +++++++++
 io_uring/loop.h                    |  27 +++
 io_uring/msg_ring.c                |   2 +-
 io_uring/net.c                     | 152 +++++----------
 io_uring/net.h                     |   1 -
 io_uring/opdef.c                   |  12 +-
 io_uring/opdef.h                   |   2 -
 io_uring/poll.c                    |  17 +-
 io_uring/query.c                   |   4 +-
 io_uring/register.c                |  59 +-----
 io_uring/register.h                |   1 -
 io_uring/rsrc.c                    |  19 +-
 io_uring/rw.c                      |  24 +--
 io_uring/sqpoll.c                  |   8 +-
 io_uring/tctx.c                    |  79 +++++---
 io_uring/tctx.h                    |   4 +-
 io_uring/timeout.c                 |  78 +++++---
 io_uring/timeout.h                 |   2 +-
 io_uring/tw.c                      |   2 +-
 io_uring/uring_cmd.c               |   9 +-
 io_uring/wait.c                    |  50 ++---
 io_uring/wait.h                    |   8 +-
 io_uring/zcrx.c                    | 384 +++++++++++++++++++++++--------------
 io_uring/zcrx.h                    |  34 ++--
 39 files changed, 1220 insertions(+), 729 deletions(-)

-- 
Jens Axboe


