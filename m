Return-Path: <io-uring+bounces-10895-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F961C9D661
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:36:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 368424E056B
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E1A01EEA5F;
	Wed,  3 Dec 2025 00:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="izzmBhvR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A0613A258
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722190; cv=none; b=GsgGDPA682kd7QC/Lw4E65qPELug/kywIPY7gYQDZTI/gRWXBBYOEPVJRzx1rXAXGa5PMxFhZ0iRpY2sj+qnvQR6Ibw0YflFPPGIsUAWPyqqT1BnACOQm6uhPqirTUH8f6nLzJ2TEw/fsVk2+Xx6PmhdOeP35cnwPRVcZnG2Rqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722190; c=relaxed/simple;
	bh=VIg1WkgKMVD7+v35Am30e6icHUiZcV8NaOoAnDCXoWI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XJr2gAHbescAFhAsfndJqymiFonS3VFjd60ZlABs+vAQ+OUXk82moFeaa02wI/tbsIQ6U+L64bcOg1sihsDcZSOxASLVVFdO9RqSKweyW6OnMKL3Jy/A0Nra7qXmsYRVW1JsGoCO4ltXGpSkISaCtfQTZamc65WBMGbuyDRRFE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=izzmBhvR; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-29555b384acso68412485ad.1
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722188; x=1765326988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fWmuSmiXylmuip1U2BdjPhRjRWy4QYepb0ZebOPIhIU=;
        b=izzmBhvRhQxex0kwSPfFFVkyIlu+g+jpLzasPCAkeF6kEjS//i5hZCcizfp2pwZ7sH
         AUNoud/8Qdh9x2d9/imv53GbN0mIpccu+JBvUX2LOSJ8zgVzEYNoZ4Rl3GKyudbg2IRM
         yv0kSikU/wpeGBcJP9tqUY2oBjPG5A1gVqZ5kpi9zixa5vjZ0SdPgHia/4/ojBST8C95
         3HwCIf9VE1R3TA+BIEDrVanwjkaSDY1x3rG5v/MC6Xjt4tYQ0uBfVba3Tv2/x2UPIW9i
         rc4n0h7WyonreNkxuNiMx46ig48ODir7lFTSbSzsMs7+Gt3cYhHycQ8anbTsUjbJkJ2t
         hRsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722188; x=1765326988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fWmuSmiXylmuip1U2BdjPhRjRWy4QYepb0ZebOPIhIU=;
        b=D1cdgo6Ix+wzcsS0sGpkhoqiBuo4PJFWUctUhZGeMUfI6A0tN+3/AGCwzfowmUOcd3
         KbhvmEdu0Ix5z5IGtvwVuyWmHh252qoYs5DgdPzMg4z6AbL/CGWfy6Zqo3Wh3jwJPIv/
         Bwt/qQkLQWgegZgKhVl97mlAF0CEbzJJEYcsWlOoHld5CzI21jFoZ3Vciz57iQ9yKgNJ
         aK9aDzMshL+gGjbB0YRSZu7xtxvVaF3QEVn4ceZUFklPRVTPkdImcdlxOqFWdvv//rnf
         578NY2j0ZuY0a8pCZ1uAdAaVfStmL3JoVcit+RCkVrjCJa+6Ldpf5p+/VNPBgOGsGu03
         DCtA==
X-Forwarded-Encrypted: i=1; AJvYcCUC5Jy5oNwcjcHs69DbuJymO17MtjJWALEm2BFDRU2OXFZBW4OXhCr9rEk6+2oOvq/IDyLpSbrOdA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzAeqaMJMyPsdTaxzGTl3KAPWhEvLoeaxbQf9HiB6xeA8hquX/N
	mC5L8CF56ylHcwhsuM3sU/TZGLIJFYhaEhYRbPNDDT3Ex3FWCtOqN4tu
X-Gm-Gg: ASbGnctP8uwvjsTmtLYaSYqK5kiV3wAQkycYDTQmP0ANYRpufYupL7tdwqB2aRQY10t
	n++pU+g5SMGYuX0HMy80efMZ1K+aX0C5CiRD+ZPd6vthg/3D8Ud26jYLsGs2aw/1CIdqVtW0AKc
	9wOGnYorp6A8bNYBXA6/UDiFbtTzUAa8/jlXRA49dnkEKDw3fmUOQvGi4fcofYOxdWTPD7nM6Wr
	mTiciiQEnbxyv4JAsGhG+cg9nBKLz21PMFOBJUFPzvaYyn49DqU0V3XRPOvE5Pbbq70vAZ7nB5R
	X4JxiCgHHTmP2uYURphf+HSKXRZoEAU6TkJ6brtgr4bxS9xMIF4wOmmOm/VQPYaBp72MA23w3J+
	1fn6dtucOxYDObUDLTlL1iSfu4iC1bLppy38XdCJOoE/Tx37/OSw1Dj+DroWViP3uBUGlGgTOHG
	SY1qAyottu3dw2VEwg9g==
X-Google-Smtp-Source: AGHT+IF2CtwNTTs27w0pkZZY3QjfSmk+E0aezKhuZv3TgGH7Ja5GcN92IhibDCFoeVbE8YsXifP7XA==
X-Received: by 2002:a17:902:cccd:b0:295:96bc:868c with SMTP id d9443c01a7336-29d682bf2d6mr6405695ad.5.1764722188075;
        Tue, 02 Dec 2025 16:36:28 -0800 (PST)
Received: from localhost ([2a03:2880:ff:50::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb559d6sm167201045ad.94.2025.12.02.16.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:27 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 00/30] fuse/io-uring: add kernel-managed buffer rings and zero-copy
Date: Tue,  2 Dec 2025 16:34:55 -0800
Message-ID: <20251203003526.2889477-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds buffer ring and zero-copy capabilities to fuse over io-uring.
This requires adding a new kernel-managed buf (kmbuf) ring type to io-uring
where the buffers are provided and managed by the kernel instead of by
userspace.

On the io-uring side, the kmbuf interface is basically identical to pbufs.
They differ mostly in how the memory region is set up and whether it is
userspace or kernel that recycles back the buffer. Internally, the
IOBL_KERNEL_MANAGED flag is used to mark the buffer ring as kernel-managed. 

Patches 6 and 7 add the capability to pin buffer rings and the fixed buffer
table. While originally desired as an optimization, this is a necessity for
fuse because the ent headers reside at a different index than the sqe's buf
index, which would require having to track the refcount for the imported
buffer in a gnarlier way. There are some cases where fuse needs to select
buffers from the buffer ring in atomic contexts where the uring mutex is not
held, and pinning the buffer ring allows the selection of buffers using the
underlying buffer list pointer with synchronization from the fuse queue
spinlock.

The zero-copy work builds on top of the infrastructure added for
kernel-managed buffer rings (the bulk of which is in patch 21: "fuse: add
io-uring kernel-managed buffer ring") and that informs some of the design
choices for how fuse uses the kernel-managed buffer ring without zero-copy.

There was a previous submission for supporting registered buffers in fuse [1]
but that was abandoned in favor of using kernel-managed buffer rings, which,
once incremental buffer consumption is added in a later patchset, gives
significant memory usage advantages in allowing the full buffer capacity to be
utilized across multiple requests, as well as offers more flexibility for
future additions. As well, it also makes the userspace side setup simpler.
The relevant refactoring fuse patches from the previous submission are carried
over into this one.

Benchmarks for zero-copy (patch 29) show approximately the following
differences in throughput for bs=1M:

direct randreads: ~20% increase (~2100 MB/s -> ~2600 MB/s)
buffered randreads: ~25% increase (~1900 MB/s -> 2400 MB/s)
direct randwrites: no difference (~750 MB/s)
buffered randwrites: ~10% increase (950 MB/s -> 1050 MB/s)

The benchmark was run using fio on the passthrough_hp server:
fio --name=test_run --ioengine=sync --rw=rand{read,write} --bs=1M
--size=1G --numjobs=2 --ramp_time=30 --group_reporting=1

This series is on top of commit 5d24321e4c15 ("io_uring: Introduce
sockname...") in the io-uring tree, and on top of two locally patched fixups
[2] and [3].

Thanks,
Joanne 

[1] https://lore.kernel.org/linux-fsdevel/20251027222808.2332692-1-joannelkoong@gmail.com/
[2] https://lore.kernel.org/linux-fsdevel/20251125181347.667883-1-joannelkoong@gmail.com/
[3] https://lore.kernel.org/linux-fsdevel/20251021-io-uring-fixes-copy-finish-v1-0-913ecf8aa945@ddn.com/

Joanne Koong (30):
  io_uring/kbuf: refactor io_buf_pbuf_register() logic into generic
    helpers
  io_uring/kbuf: rename io_unregister_pbuf_ring() to
    io_unregister_buf_ring()
  io_uring/kbuf: add support for kernel-managed buffer rings
  io_uring/kbuf: add mmap support for kernel-managed buffer rings
  io_uring/kbuf: support kernel-managed buffer rings in buffer selection
  io_uring/kbuf: add buffer ring pinning/unpinning
  io_uring/rsrc: add fixed buffer table pinning/unpinning
  io_uring/kbuf: add recycling for pinned kernel managed buffer rings
  io_uring: add io_uring_cmd_import_fixed_index()
  io_uring/kbuf: add io_uring_is_kmbuf_ring()
  io_uring/kbuf: return buffer id in buffer selection
  io_uring/kbuf: export io_ring_buffer_select()
  io_uring/cmd: set selected buffer index in __io_uring_cmd_done()
  io_uring: add release callback for ring death
  fuse: refactor io-uring logic for getting next fuse request
  fuse: refactor io-uring header copying to ring
  fuse: refactor io-uring header copying from ring
  fuse: use enum types for header copying
  fuse: refactor setting up copy state for payload copying
  fuse: support buffer copying for kernel addresses
  fuse: add io-uring kernel-managed buffer ring
  io_uring/rsrc: refactor
    io_buffer_register_bvec()/io_buffer_unregister_bvec()
  io_uring/rsrc: split io_buffer_register_request() logic
  io_uring/rsrc: Allow buffer release callback to be optional
  io_uring/rsrc: add io_buffer_register_bvec()
  io_uring/rsrc: export io_buffer_unregister
  fuse: rename fuse_set_zero_arg0() to fuse_zero_in_arg0()
  fuse: enforce op header for every payload reply
  fuse: add zero-copy over io-uring
  docs: fuse: add io-uring bufring and zero-copy documentation

 Documentation/block/ublk.rst                  |  15 +-
 .../filesystems/fuse/fuse-io-uring.rst        |  55 +-
 drivers/block/ublk_drv.c                      |  20 +-
 fs/fuse/dax.c                                 |   2 +-
 fs/fuse/dev.c                                 |  32 +-
 fs/fuse/dev_uring.c                           | 775 +++++++++++++++---
 fs/fuse/dev_uring_i.h                         |  47 +-
 fs/fuse/dir.c                                 |  13 +-
 fs/fuse/file.c                                |  11 +-
 fs/fuse/fuse_dev_i.h                          |   8 +-
 fs/fuse/fuse_i.h                              |   8 +-
 fs/fuse/readdir.c                             |   2 +-
 fs/fuse/xattr.c                               |  18 +-
 include/linux/io_uring.h                      |   9 +
 include/linux/io_uring/buf.h                  |  98 +++
 include/linux/io_uring/cmd.h                  |  25 +-
 include/linux/io_uring_types.h                |  21 +-
 include/uapi/linux/fuse.h                     |  15 +-
 include/uapi/linux/io_uring.h                 |  17 +-
 io_uring/io_uring.c                           |  15 +
 io_uring/kbuf.c                               | 337 ++++++--
 io_uring/kbuf.h                               |  19 +-
 io_uring/memmap.c                             | 117 ++-
 io_uring/memmap.h                             |   4 +
 io_uring/register.c                           |   9 +-
 io_uring/rsrc.c                               | 188 ++++-
 io_uring/rsrc.h                               |   6 +
 io_uring/uring_cmd.c                          |  39 +-
 28 files changed, 1632 insertions(+), 293 deletions(-)
 create mode 100644 include/linux/io_uring/buf.h

-- 
2.47.3


