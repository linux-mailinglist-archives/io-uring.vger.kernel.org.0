Return-Path: <io-uring+bounces-11768-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E286FD38A0A
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:31:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9C2DB30428D5
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE08B1FE44A;
	Fri, 16 Jan 2026 23:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f4O2qSOq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E4317993
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606264; cv=none; b=kv18Ne322xQPbQI8qy/Di5Lr5JC0nnP+M2W8kz5YpEES42YNbYWXIx7CIxEmsYgyT0guGr/Gizmh9AE9kYJpjyUmFLPJOmcEMB0c1VB6163a7N+YBes1S4Dv/a8EpUMdc06IVuuN+ZM5bGw4LLDLOEl2VZVtwQHpUs+6hoM07p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606264; c=relaxed/simple;
	bh=K1wRh3492mMGZGUAJjjSNwOi2kzUyrx4DUiil4ld6iI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cJh4qsFu7rdyYIbbth7WZDSlvH5dj/4fx5iVkv9iZp57bjsuMGy0djJKrIRDbYWlAdT8vGBOO4kM/mamN+D78Tke7ZanKic1E/AWVE4lWxm6Ikj2BJrXqdbTZJOa7TYKuMQ62gzAv5hYsN/x5EPl9VDkEcg1NuzATwMQ0cv7Hvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f4O2qSOq; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-81dab89f286so1215559b3a.2
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606262; x=1769211062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rpq5WWSHKss0mptOYewsQ0k57/noiEkYB0tSl1wVDPc=;
        b=f4O2qSOq5Af3YeluXwCh4K9L8En/SW3w7PqdSdnsGiZRRoG78V0J3Ugbyq/SjhbpQg
         Jvmjmaw9JCl2lOljelLW4p6r1OI0piWowd+7zpNXtWoEyPDeQioKq/zM9EDcn4NnzYuL
         l/jyLc1kZWPl2e7H9UP9gpBMLwUYI+2w9KXFvP4saFOZR7iCioh6bS92Vh2/y+Wvs1oo
         U36wSNzFaFXGrggC3tD1xqjrtfl8duboo8MrFVKwOpyFBQBABlEm5qVOY8YY1xNbhAdG
         SPmPCdrSy3ZiSCce3KGskruQ8x4qIwMt3qaXSNlJpMzWCN/e3PLRi7rrRuFLDLo4tAQ7
         DQ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606262; x=1769211062;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rpq5WWSHKss0mptOYewsQ0k57/noiEkYB0tSl1wVDPc=;
        b=v2qKUtoc1pZIu3PiPMNytDMbMS+6xyyktnzce6A1tCFpt/4DnRyK7Ru1dFNuOfDRdr
         XXuks6HBSnZ0gnkCUuFgO5Q+YZQ28YhtNtg6+TlhMkvKmsAzmwTTONL6PQD70+Rt7ABd
         cHA4w8DAvuqiTl1V2wOys2IMgwYyVIJ5JTJkOK2wlqzGth0UPmDoHJakA1ou4vAdUNwd
         0QxmrOJOnRPh3R5D2ewuWXHptQhCEc2XwdcK+jLE9Eb3ngbsDPlxc9mxe8R5bxdI40qt
         dkcE01DBg5I5vDHEPUXmO7aCtoQMsc5nZWw+wdQonIDil4Uz1ztsmYv2bnw9QS8WbVdD
         kntw==
X-Forwarded-Encrypted: i=1; AJvYcCXDuVt09nzh/32FZgQrotNHsrDVurXeS41ZAEz32+R0Ne3407+CdU2GzA+rfgUSv9G/HNScvNadRg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQWBCjpCu1/kEvQRsTfGXKFLek5fjWjeZI3SuuvYFvu8rWMbke
	MupvFXeT1Lo7q3g/yAEasZxKowQfPKdG+RCT6qbG1IcO9YJtQAuYU4u+
X-Gm-Gg: AY/fxX7GURok11Hewv9pDizyzXYFVVAG7XN4U0btAAfujMvmF/7Zd8bA+H+ecEwxugN
	oABtKrg8YqtCSrAfzQbgoe4tOFoqSUEktxq2hVtfBWb5qYJVY1BMWAbQUqv0B2mXfWtys6zXG2Z
	W0/Db66AImzpnela3BztxLeOnDL+T736bOXogBRMuW6KWtJN9qXIQKBjmqj/08V9mHlE7Y7+aMg
	Swv6AF0U3TqGXC8QpRdjrv6neP5bUmkGcLnh223yAvbjCyCMqGJyDqodmSc2Qo9p6u7KoGRJiQf
	fOpdBsUUImh602g9Dr0Vcn4c9TOTknfVNasdUrlDqnEo7rNjPia34IAYy/lNhp2H53tUD7F2BC8
	lt2Ye8t8yd3KiAsEm8uariw2FFGyibmkwo4GW7FFSRqpLWGCQ7HwwUMpwEzz1rIdug+WhWt3usa
	x/oBkFf5Zrb/spphUA
X-Received: by 2002:a05:6a20:728d:b0:34e:cc0a:40b2 with SMTP id adf61e73a8af0-38dfe64be4emr4502943637.30.1768606262384;
        Fri, 16 Jan 2026 15:31:02 -0800 (PST)
Received: from localhost ([2a03:2880:ff:52::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7190ce6a9sm30997025ad.34.2026.01.16.15.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:01 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	miklos@szeredi.hu
Cc: bschubert@ddn.com,
	csander@purestorage.com,
	krisman@suse.de,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	xiaobing.li@samsung.com,
	safinaskar@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 00/25] fuse/io-uring: add kernel-managed buffer rings and zero-copy
Date: Fri, 16 Jan 2026 15:30:19 -0800
Message-ID: <20260116233044.1532965-1-joannelkoong@gmail.com>
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

This series is on top of commit b71e635feefc in the io-uring tree.

The libfuse changes can be found in [2]. This has a dependency on the liburing
changes in [3]. To test the server, you can run it with:
sudo ~/libfuse/build/example/passthrough_hp ~/src ~/mounts/tmp
--nopassthrough -o io_uring_zero_copy -o io_uring_q_depth=8

Thanks,
Joanne 

[1] https://lore.kernel.org/linux-fsdevel/20251027222808.2332692-1-joannelkoong@gmail.com/
[2] https://github.com/joannekoong/libfuse/tree/zero_copy
[3] https://github.com/joannekoong/liburing/tree/kmbuf

v3: https://lore.kernel.org/linux-fsdevel/20251223003522.3055912-1-joannelkoong@gmail.com/
v3 -> v4:
* Get rid of likely()s and get rid of going through cmd interface layer (Gabriel)
* Fix io_uring_cmd_fixed_index_get() to return back the node pointer (Caleb)
* Add documentation for io_buffer_register_bvec (Caleb)
* Remove WARN_ON_ONCE() for io_buffer_unregister() call (Caleb)

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
  io_uring: add io_uring_fixed_index_get() and
    io_uring_fixed_index_put()
  io_uring/kbuf: add io_uring_is_kmbuf_ring()
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
 fs/fuse/dev_uring.c                           | 692 ++++++++++++++----
 fs/fuse/dev_uring_i.h                         |  42 +-
 fs/fuse/fuse_dev_i.h                          |   8 +-
 include/linux/io_uring/buf.h                  |  25 +
 include/linux/io_uring/cmd.h                  |  97 ++-
 include/linux/io_uring_types.h                |  10 +-
 include/uapi/linux/fuse.h                     |  17 +-
 include/uapi/linux/io_uring.h                 |  17 +-
 io_uring/kbuf.c                               | 355 +++++++--
 io_uring/kbuf.h                               |  19 +-
 io_uring/memmap.c                             | 117 ++-
 io_uring/memmap.h                             |   4 +
 io_uring/register.c                           |   9 +-
 io_uring/rsrc.c                               | 183 ++++-
 io_uring/uring_cmd.c                          |   6 +-
 19 files changed, 1447 insertions(+), 275 deletions(-)
 create mode 100644 include/linux/io_uring/buf.h

-- 
2.47.3


