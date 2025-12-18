Return-Path: <io-uring+bounces-11180-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E9DF9CCAF20
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:39:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AF9DF30D3E3E
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B9C2E22BE;
	Thu, 18 Dec 2025 08:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NNUAefHE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CE82EA48F
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046878; cv=none; b=NA2HWze6MhV/3Dy0KNeC9WLXVHijFXkS8/tBFuhzECkUK7UZqIrpBtfhQH8U1ZXdcCQYB2nF/l1kAVq0HAY9Vzt5kG0EGdh64R2XGG3OwuevqSIi3LdjIAh2zGSlGmo9gopxddR1jDMjnBgihLJiGoDncapfyTBNlmvj+LE1oVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046878; c=relaxed/simple;
	bh=SeJW1PaiWGfj8QqeEhkWXgt+VVvT/XgFlDtLomeoufw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nXE3yqeaL1ItUJQ6JqM7pbD/Zt75fm51m6qXZvSCyFpKTQjl77nl1DqZ4L9uGUQx4Xv7DouycCmVm9xQ/lC/gjDukVszxUhs6Iuar+iXHf68fnfpClbdVU/hewkD3nYtqM98zQtlBvRocoTKKIslWAyxPgPBmsddJ5BxeMnf9nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NNUAefHE; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7ade456b6abso341502b3a.3
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046874; x=1766651674; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/ryKEv83UFMgwQSkwJiJ8ATe2IKAahgjV9yo2n63384=;
        b=NNUAefHEzDhUhzUEvlY1bckXcWx4dR+vWoJzOEPLqGk0c3bNZO+4X9sAukkvLZNYMR
         tnscGnCIMrXZX03St1iVR9ibNYFUbiGTq31GCNa64sBMp07szL1+CY1uAmw9Oxo0Uex9
         rDK3bx14jPEHfwZmuOT8qzN8Q9bx607y8HgJCRKAqglrEnu3ipSH8qcggScgLRpUI7vK
         yyVpEN7M/uIjzWPwMubVn6J4ZuQuVl6LxaqOGf5GWEDkrFADFapy8bR8azWgt3llfmRh
         4hIN0WEjeyxqholM5hmWaAdW8YKjXNzAJpOwsBeUWzdpndGsJMQqkV75f3TFnmihXrwD
         wu7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046874; x=1766651674;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ryKEv83UFMgwQSkwJiJ8ATe2IKAahgjV9yo2n63384=;
        b=nr5mYAG/DzYswa2ySS25sOcv2eAUwVTwhpkOzI9pgS/BSLF4zG2UcgwjLLfhmJ04ny
         BPZrwRwPpRXiWFESAVYe4qYzx8PDRkBn4QkrqQkYKkTi05HlA3Yuu8DBqRyvlZlxQZNu
         fdmTqw3eG9bSlUuM4wHDEKMPIXkizupasE8R8MtBleBbozCCjUysvWjpPzM+c2Ru/iQQ
         unE9dStAzkZLt2f7qIrWxxWeMWSI+rSnuWNEsClVHuL1km6O4qag3MyrgeG+1t01AdSx
         Y06hFRJIBicNQAl59PgDB6/Nmh+BuATbeLoGZcUqI2xRK6BI/F7oDkjnJr1yQ6dvbg29
         07LQ==
X-Forwarded-Encrypted: i=1; AJvYcCXg0MRY2S0x53NZ406ISUzqnvjXeR7i/Wazt+TKt1cd5MqyR9lbt+Vew73kEVOI7x1yDWKl9rZhTA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ9Kdo/Q81ZODv/bhIcMCEV8npNHP4RK3SNZ0H6hY9lFDWQsvX
	O326QsdoC9v+5dYaZKIARQixmVgbLvrL9+FSSCoX7q6fxwlWlo5fTjjV
X-Gm-Gg: AY/fxX4xLPbBoiTfUUoho3PgrY310v1Aaa5MMGnT06kpXZqrpG7bCmYVRYQW4COFxSe
	8wVE7b5v0TuXFS0Tr9or0X/aXSZ3oYB6rP+UX/jDSvbA0lMKPo7BepJXMl4MZDgI0Gn6OWNBbg9
	uRIXpLRiSLGeiQNw/+zwvGYbHc8puaci80OiruzlJFYjkKCU2wSNWEXmL9j4OdiA0NSaKkXWCVO
	qcUqmCedbMAv5lsJJVWaDKsYap/Sqq5H+oMp9ChNGroWPeH6N+Tk65DOZS6gMBTm2B9+P4OMch5
	FqF2w0fuyX2YProZUJ+KMixrJAO2g2k2nk0F/f0nYbPrDNTDnX4Z4YX2EJCvhfArk+KUkO97Pq5
	l9n5iWuZ5sZe7bEYAtLva5ZU4nalmxTYpEKgdyo8fgEZOgQpCQiifMk/ic1ffEPrfnWj88rBE4u
	D1ra9yoCwQtIGdHg6j4w==
X-Google-Smtp-Source: AGHT+IG5zrmlTr7UR67R7uSsS8bFVhvQbzc6eOUVE4YLzIwXn78N7KCNnvPbayZ4Mskm+rF0za72aA==
X-Received: by 2002:a05:6a20:7343:b0:35e:bfe5:ee82 with SMTP id adf61e73a8af0-369af336dffmr22095569637.48.1766046873674;
        Thu, 18 Dec 2025 00:34:33 -0800 (PST)
Received: from localhost ([2a03:2880:ff:54::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1d2dca06e0sm1588644a12.12.2025.12.18.00.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:34:33 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 00/25] fuse/io-uring: add kernel-managed buffer rings and zero-copy
Date: Thu, 18 Dec 2025 00:32:54 -0800
Message-ID: <20251218083319.3485503-1-joannelkoong@gmail.com>
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

This series is on top of commit 40fbbd64bba6  in the io-uring tree.

The libfuse patch used for testing / verifying functionality is in [4].

Thanks,
Joanne 

[1] https://lore.kernel.org/linux-fsdevel/20251027222808.2332692-1-joannelkoong@gmail.com/
[2] https://lore.kernel.org/linux-fsdevel/20251125181347.667883-1-joannelkoong@gmail.com/
[3] https://lore.kernel.org/linux-fsdevel/20251021-io-uring-fixes-copy-finish-v1-0-913ecf8aa945@ddn.com/
[4] https://github.com/joannekoong/libfuse/commit/630db88e600fea515d62ef94d784988cefba05af

v1: https://lore.kernel.org/linux-fsdevel/20251203003526.2889477-1-joannelkoong@gmail.com/
v1 -> v2:
* drop fuse buffer cleanup on ring death, which makes things a lot simpler (Jens)
  - this drops a lot of things (eg needing ring_ctx tracking, needing callback
    for ring death, etc)
* drop fixed buffer pinning altogether and just do lookup every time (Jens)
  (didn't significantly affect the benchmark results seen)
* fix spelling mistake in docs (Askar)
* use -EALREADY for pinning already pinned bufring, return PTR_ERR for
   registration instead of err, move initializations to outside locks, etc. (Caleb)
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
 .../filesystems/fuse/fuse-io-uring.rst        |  55 +-
 drivers/block/ublk_drv.c                      |  18 +-
 fs/fuse/dev.c                                 |  30 +-
 fs/fuse/dev_uring.c                           | 710 ++++++++++++++----
 fs/fuse/dev_uring_i.h                         |  41 +-
 fs/fuse/fuse_dev_i.h                          |   8 +-
 include/linux/io_uring/buf.h                  |  25 +
 include/linux/io_uring/cmd.h                  |  99 ++-
 include/linux/io_uring_types.h                |  10 +-
 include/uapi/linux/fuse.h                     |  14 +-
 include/uapi/linux/io_uring.h                 |  17 +-
 io_uring/kbuf.c                               | 352 +++++++--
 io_uring/kbuf.h                               |  29 +-
 io_uring/memmap.c                             | 117 ++-
 io_uring/memmap.h                             |   4 +
 io_uring/register.c                           |   9 +-
 io_uring/rsrc.c                               | 190 ++++-
 io_uring/rsrc.h                               |   5 +
 io_uring/uring_cmd.c                          |  65 +-
 20 files changed, 1535 insertions(+), 277 deletions(-)
 create mode 100644 include/linux/io_uring/buf.h

-- 
2.47.3


