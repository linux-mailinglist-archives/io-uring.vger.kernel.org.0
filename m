Return-Path: <io-uring+bounces-11251-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1328ECD77DF
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:36:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C419E30142EC
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D59EC1DF736;
	Tue, 23 Dec 2025 00:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZHtXhY/G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3142D1F3BA4
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450187; cv=none; b=q7jQgVqc24XtQ3WmbFCC+3iaXg/fMtah+DVNYynINy/UEMRyE4hLyKdB9VGuRYh4nk4Br9F/XLDK1c4eYbDhg+b5TNmHnrs8eQ29ZB6fVmBirj9+Eig7uCE8DEPz5DipjuYVqgYiwkEP1i6zeSvR2WRxASFO8l1NyU7UK6dg+Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450187; c=relaxed/simple;
	bh=AqJnUW7ENCU9lhLx82NRORvUSa5ZTWncD0M24Q0Vayw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZKD9O06V0i44elU++ggVYfQBhEkuVVS8+0NJWoag73cP8iD9KDL8iARdrqoRvtmpbDRKzCsGUwx05CbpAHm0yIUbPSdsZ/5ncchS9JJUD4tJAbEM/lzOL2nsrg9Ev+nIuypi3zcam/VpLcYLTgq2Ri1/dbXejsXtwtBxW8MxKO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZHtXhY/G; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so3527470b3a.0
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450185; x=1767054985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UNVVM3iNnsDDZ9LpCf1cMc9PuapDDbJq3uJy9qCzd9M=;
        b=ZHtXhY/GKpyOQjDAdquncmmKZkOFW1cTnYISdeer0mYyfonp5uWXq6d8pLkTJ+kA2F
         lpicKfiWycgl+bAKR6FfGMOdr8dsBas/fbbmFsgkHftGRH6tNpOqnTLITiBZYZ/8VUnE
         E4mOK9tVGIVRI6O46ytl/ZkjwAGtDBIELBpVD4ZSfgfO8pikkqB0pUhaMb+isx9YrYzY
         zoNZfa5XG2qIPPee8AIleh7pSd3Qn/eATdC+UGPUf9qFg5+gstj9wfzZ4LEzBtW7UrIR
         tvD7Jbpxsh9jnI3znHUyDDCPsj8uryg5BehE6YWo++8cdGxJSTOi2KnDkFV+Ra7ehvKx
         r3eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450185; x=1767054985;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UNVVM3iNnsDDZ9LpCf1cMc9PuapDDbJq3uJy9qCzd9M=;
        b=fV+ycE+/WdgKKP6Gjnrzr52Pe9srbFZvlswj5z1+wTwfs7TZbSl0+swcvlLVwDjAE1
         bTuShtQSmoqLYjRrIfzk/KSTH7+mIpn3sUScx0VyX/MVmIGgB2VWry/WUlqlzUEFFj1i
         huDJOABf0lGxxqFgHqkBkwYG2qh68PA1Hqsa/o108PIWzBVCy+a1vdVgg0jMzgkWB7Dg
         92IhrV4Kb5QFvduvaROiF9LIwxi+kN8WtAIIXOcoHhYFGZbz8tV7nuofxlcIFFphYYw4
         hnaO2QAoMoYOiLHF1eleapiNPtY43fMkdvYmw86Y4skV+TNZ+KolSy4kW2Qdd/VpxHcI
         VDrA==
X-Forwarded-Encrypted: i=1; AJvYcCVeeQj1LJ81yf1AiNGDfNhN3N8JqZKXqTBqju5NmAkRi/nu99Wa+FPD0lrA+Ko+2k0mt33sn+97Cw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4Pv10Rv5SEfTRfD0yv+teZ+BahMZ1mGXr60GwHmHSJBxgcGDR
	Xf4oaqqU44RCPkH5jWJ4u6M0WQom3ay3kBwot28FAJA8t+ATT9R8zvE5
X-Gm-Gg: AY/fxX5rM8kQZTjrVksWWdthtF/flqNrXe9wA2IBFr4/SFfYUwdM3qZLZffHjGyifw2
	MEmGIHemn1Q5eo0PUKv5fjLmxIoBd6j8PCwIqSem/jSP7q0VQa2Ded8/ypnsbEhceN+REPxQ+Dw
	/CVskFfv8WuSkQHs/O8KL9yqfNTSoILFJK1JvAIOUsBNOOsyipHI1BwyBDU7GVnWJ7yamJTPZ72
	OsFCcLySMLklY2pRSqiGtqEH+FTQk9+S6+fjYdT5nSXoKmL4lErx2dCIeMsykFSJiuJc4jlMF/L
	Y4jdRLALO/Hv3FcODTGn+sdXkDckE+oJTJMCOcor/VBzvcOTKgdpgT2cejDfz85aY88ts9ow7nH
	9trfzRhCY+BfERDTTnlY2piMt8YT56ekvZyOBtsTg0vkvmVXwQHNFgHMB1pQISIWVML6l4TIeKQ
	WAVbEt/8zzQdGzer9HvUha81gzyc2Z
X-Google-Smtp-Source: AGHT+IHpU+aB1cZ30EAPCwz8qZ4Os4mu4doygI+PUlJ4FMxAwHGXcz7c7pV+/kAqQrzBvVTFwyZfbg==
X-Received: by 2002:a05:6a00:a90d:b0:7e8:43f5:bd52 with SMTP id d2e1a72fcca58-7ff67756c3amr12198184b3a.62.1766450185316;
        Mon, 22 Dec 2025 16:36:25 -0800 (PST)
Received: from localhost ([2a03:2880:ff:45::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e797787sm11558159b3a.60.2025.12.22.16.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:24 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 00/25] fuse/io-uring: add kernel-managed buffer rings and zero-copy
Date: Mon, 22 Dec 2025 16:34:57 -0800
Message-ID: <20251223003522.3055912-1-joannelkoong@gmail.com>
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

The zero-copy work builds on top of the infrastructure added for
kernel-managed buffer rings (the bulk of which is in patch 19: "fuse: add
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

Benchmarks for zero-copy (patch 24) show approximately the following
differences in throughput for bs=1M:

direct randreads: ~20% increase (~2100 MB/s -> ~2600 MB/s)
buffered randreads: ~25% increase (~1900 MB/s -> 2400 MB/s)
direct randwrites: no difference (~750 MB/s)
buffered randwrites: ~10% increase (950 MB/s -> 1050 MB/s)

The benchmark was run using fio on the passthrough_hp server:
fio --name=test_run --ioengine=sync --rw=rand{read,write} --bs=1M
--size=1G --numjobs=2 --ramp_time=30 --group_reporting=1

This series is on top of commit 40fbbd64bba6 in the io-uring tree.

The libfuse patch used for testing / verifying functionality is in [2]. This
has a dependency on the liburing changes in [3].

Thanks,
Joanne 

[1] https://lore.kernel.org/linux-fsdevel/20251027222808.2332692-1-joannelkoong@gmail.com/
[2] https://github.com/joannekoong/libfuse/commit/f15094b1881f9488b45026ae51f18d13ced4a554
[3] https://github.com/joannekoong/liburing/tree/kmbuf

v2: https://lore.kernel.org/linux-fsdevel/20251218083319.3485503-1-joannelkoong@gmail.com/
v2 -> v3:
* fix casting between void * and u64 for 32-bit architectures (kernel test robot)
* add newline for documentation bullet points (kernel test robot)
* fix unrecognized "boolean" (kernel test robot), switch it to a flag (me)

v1: https://lore.kernel.org/linux-fsdevel/20251203003526.2889477-1-joannelkoong@gmail.com/
v1 -> v2:
* drop fuse buffer cleanup on ring death, which makes things a lot simpler (Jens)
  - this drops a lot of things (eg needing ring_ctx tracking, needing callback
    for ring death, etc)
* drop fixed buffer pinning altogether and just do lookup every time (Jens)
  (didn't significantly affect the benchmark results seen)
* fix spelling mistake in docs (Askar)
* use -EALREADY for pinning already pinned bufring, return PTR_ERR for
   registration instead of err, move initializations to outside locks (Caleb)
* drop fuse patches for zero-ed out headers (me)

Joanne Koong (25):
  io_uring/kbuf: refactor io_buf_pbuf_register() logic into generic
    helpers
  io_uring/kbuf: rename io_unregister_pbuf_ring() to
    io_unregister_buf_ring()
  io_uring/kbuf: add support for kernel-managed buffer rings
  io_uring/kbuf: add mmap support for kernel-managed buffer rings
  io_uring/kbuf: support kernel-managed buffer rings in buffer selection
  io_uring/kbuf: add buffer ring pinning/unpinning
  io_uring/kbuf: add recycling for kernel managed buffer rings
  io_uring: add io_uring_cmd_fixed_index_get() and
    io_uring_cmd_fixed_index_put()
  io_uring/kbuf: add io_uring_cmd_is_kmbuf_ring()
  io_uring/kbuf: export io_ring_buffer_select()
  io_uring/kbuf: return buffer id in buffer selection
  io_uring/cmd: set selected buffer index in __io_uring_cmd_done()
  fuse: refactor io-uring logic for getting next fuse request
  fuse: refactor io-uring header copying to ring
  fuse: refactor io-uring header copying from ring
  fuse: use enum types for header copying
  fuse: refactor setting up copy state for payload copying
  fuse: support buffer copying for kernel addresses
  fuse: add io-uring kernel-managed buffer ring
  io_uring/rsrc: rename
    io_buffer_register_bvec()/io_buffer_unregister_bvec()
  io_uring/rsrc: split io_buffer_register_request() logic
  io_uring/rsrc: Allow buffer release callback to be optional
  io_uring/rsrc: add io_buffer_register_bvec()
  fuse: add zero-copy over io-uring
  docs: fuse: add io-uring bufring and zero-copy documentation

 Documentation/block/ublk.rst                  |  14 +-
 .../filesystems/fuse/fuse-io-uring.rst        |  59 +-
 drivers/block/ublk_drv.c                      |  18 +-
 fs/fuse/dev.c                                 |  30 +-
 fs/fuse/dev_uring.c                           | 711 ++++++++++++++----
 fs/fuse/dev_uring_i.h                         |  41 +-
 fs/fuse/fuse_dev_i.h                          |   8 +-
 include/linux/io_uring/buf.h                  |  25 +
 include/linux/io_uring/cmd.h                  |  99 ++-
 include/linux/io_uring_types.h                |  10 +-
 include/uapi/linux/fuse.h                     |  17 +-
 include/uapi/linux/io_uring.h                 |  17 +-
 io_uring/kbuf.c                               | 350 +++++++--
 io_uring/kbuf.h                               |  29 +-
 io_uring/memmap.c                             | 117 ++-
 io_uring/memmap.h                             |   4 +
 io_uring/register.c                           |   9 +-
 io_uring/rsrc.c                               | 190 ++++-
 io_uring/rsrc.h                               |   5 +
 io_uring/uring_cmd.c                          |  65 +-
 20 files changed, 1541 insertions(+), 277 deletions(-)
 create mode 100644 include/linux/io_uring/buf.h

-- 
2.47.3


