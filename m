Return-Path: <io-uring+bounces-13172-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uPGeAjcj8mlmoQEAu9opvQ
	(envelope-from <io-uring+bounces-13172-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 17:26:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8491C496D44
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 17:26:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B28C33018BF5
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 15:26:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D114A37F721;
	Wed, 29 Apr 2026 15:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XWB8xc98"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0350A37DEA3
	for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 15:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476385; cv=none; b=XwMWQQHuURhApwYUcGXKFBM1Zp/ZTFT6epuGuscuhaPw95XkU/YQO5aNxtBCtnJKNljcykSE7xPS3gtMHohsKLNrZs5xnlUGSqT9sXdxvt2FXOJ2uxRt9Ohj4W9BOZIulAuUZFAOm375+fvgVw7dFzuCKlLVsv64XUfXQaNzX20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476385; c=relaxed/simple;
	bh=hELMxdIqirWfZE9lS3jphk/Hs00RokLAMWOkF4lalT0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qjQLtd91VmFzBupBlFSt9oT87H+8fR6b08zwHrTj4JvdS3QFhtskCq0dnIeYvjI0ITjOF96T+aNTT5ujWCDz+8orvz76pHHRyWMutmwp0KwhYT6XiWoYklBg5eusW8l39G/Qgqeu9Cb8tdURT9eMEiAAGkBRmv0I1te4wPPfRZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XWB8xc98; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488a9033b2cso133240645e9.2
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 08:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777476378; x=1778081178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G9kqbgnidQC23bEvrBAVDYa4e7L0vOouqvUY0ysfe8Y=;
        b=XWB8xc98up29GzY7kFjywBjNyG9lgycOlMLs1dHgrQ32RQEWjh6cxO4yMt8G/UntSC
         4kksswLeJ03wupTCWEvdS7ZG2if40crUlus2GT8pR5xWNiEWI/uiK7N0mIrzbrNFKnOL
         PySlG5myV9tLCrrkUmRq49nU7xHF8nIgRKHwlG1Qw6DzKvYg+kl+vYewodjHeZ/fQUEU
         HY93XBkBemETwZXXuPpu1nm9a0NV/vd06xGE571ZmDtPeca3KlAnQ65PZTTkTqnPOBbw
         REGD+nzd0M52LFRdTDuoc0l8KZasOYu1p3bNIERwFJvAJXQABZDlS0H/3MO75ARW9ztW
         V5ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777476378; x=1778081178;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G9kqbgnidQC23bEvrBAVDYa4e7L0vOouqvUY0ysfe8Y=;
        b=rUPwl8g/2skF8w+QOF+BWPq/D/ZPgbLNiUYP2YHuz3aXhgtyAGiGB13pfRHCnA/ZF7
         fOqpJNyXvGzlVZwGVarLdE+/SE3yVgSo5km2q1sRXmhEL7LEnfRG2cQA9tRlDsnG8sAv
         GB58+F9j9W9d+APoTjrWRRG+JzvA45CkGhVuIElT/PmB3MA0eVmCM/PwWczyLXVIXTaL
         b2nJg1E4QtmpzRlhNDsQmQ6PrYM+/ZLWCF+g1thtGLf6+knzUSIQ67xJdg98RrpmL/t2
         yWTqgh6285QbAMCy1s710T2bd8iId/ruSPF+CqlQ8OXrijgGusHq94ZBqiTxWMX0hXl5
         EOsw==
X-Forwarded-Encrypted: i=1; AFNElJ9vUpeGxAN7TvEwMDXTuJf0qPXetj3HGh5EfhkO26kxdFvNVC5+diFPlu/J499EwE93H9fpynl+WQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0pVHFI65Tx3y8QoHIqmTK4eF9v2grfXnBV7LVPdku5ZJK3ZmA
	P73Bdv9SZgojpTT5g6ILvqiuXS+nXGAl8tWPppHqYrAoHeSNaUicUzjl
X-Gm-Gg: AeBDies7sG8Dxt9F9kNAjY65jc4bMUXZZbzfITcn4tdBNNvuM9lITGAe0Fz/Z/y2AKj
	m0D6SNeug08MfZ7L9YTekMBFYydiZdLGYhO4zWDow++rRI5XNRtU3MjWGQusXfLIZ4tNsSqpJ6W
	6jvfthp2Iw6X1xLYKEa1S3Q2qfqoB+SQ6kkRvd2snyJYNu69/7BVvonW7QlhLMKLKLPZu8pkcQj
	C4wAvH69vmireDWdYQJyY/blvlpWNWnbDCvt66jJ7Xwyqg4yX6OKpoPMaTFuCVSjfjOnuNQ4qBW
	vgSYivHpCDYsgXQPTZkxWHF/dXPb46RX96R/esCYhoGlQ22LunzasJ8aYb1V9INVHjWd2Ip71Jq
	je790bZrQUjoyURy3wED5DeW0YVldtgik1gx8GZh2FAUOwdCMvh/OOT97/qCDyunsnVugAktrHB
	Qw3iEu2iKoLikN6dOe++j278oyvfKSMfYWfY15RksFT+6b+D6hzt+wHSCDQzujUzYpzBx9TJ2U6
	vXCmM4n27gZxsbr/aX3+2l5g1tQ6ip6xeLJ/sW96qSb
X-Received: by 2002:a05:600c:4f92:b0:489:1ff1:74df with SMTP id 5b1f17b1804b1-48a77ae5430mr125646225e9.1.1777476377153;
        Wed, 29 Apr 2026 08:26:17 -0700 (PDT)
Received: from 127.0.0.1localhost ([82.132.184.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b76e5c22sm6382951f8f.28.2026.04.29.08.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 08:26:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v3 00/10] Add dmabuf read/write via io_uring
Date: Wed, 29 Apr 2026 16:25:46 +0100
Message-ID: <cover.1777475843.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8491C496D44
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[25];
	FREEMAIL_CC(0.00)[gmail.com,samsung.com,intel.com,nvidia.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13172-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.990];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

The patch set allows to register a dmabuf to an io_uring instance for
a specified file and use it with io_uring read / write requests. The
infrastructure is not tied to io_uring and there could be more users
in the future. A similar idea was attempted some years ago by Keith [1],
from where I borrowed a good number of changes, and later was brough up
by Tushar and Vishal from Intel.

It's an opt-in feature for files, and they need to implement a new
file operation to use it. Only NVMe block devices are supported in this
series. The user API is built on top of io_uring's "registered buffers",
where a dmabuf is registered in a special way, but after it can be used
as any other "registered buffer" with IORING_OP_{READ,WRITE}_FIXED
requests. It's created via a new file operation and the resulted map is
then passed through the I/O stack in a new iterator type. There is some
additional infrastructure to bind it all, which also counts requests
using a dmabuf map and managing lifetimes, which is used to implement
map invalidation.

It was tested for GPU <-> NVMe transfers. Also, as it maintains a
long-term dma mapping, it helps with the IOMMU cost. The numbers
below are for udmabuf reads previously run by Anuj for different
IOMMU modes:

- STRICT: before = 570 KIOPS, after = 5.01 MIOPS
- LAZY: before = 1.93 MIOPS, after = 5.01 MIOPS
- PASSTHROUGH: before = 5.01 MIOPS, after = 5.01 MIOPS

There are some liburing tests that can serve as an example:
git: https://github.com/isilence/liburing.git rw-dmabuf-tests-v3
url: https://github.com/isilence/liburing/tree/rw-dmabuf-tests-v3

[1] https://lore.kernel.org/io-uring/20220805162444.3985535-1-kbusch@fb.com/

v3: - Rework io_uring registration
    - Move token/map infrastructure code out of blk-mq
    - Simplify callbacks: remove a separate blk-mq table, which was
      mostly just forwarding calls (to nvme).
    - Don't skip dma sync depending on request direction
    - Fix a couple of hangs
    - Rename s/dma/dmabuf/
    - Other small changes

v2: - Don't pass raw dma addresses, wrap it into a driver specific object
    - Split into two objects: token and map
    - Implement move_notify

Pavel Begunkov (10):
  file: add callback for creating long-term dmabuf maps
  iov_iter: add iterator type for dmabuf maps
  block: move bvec init into __bio_clone
  block: introduce dma map backed bio type
  lib: add dmabuf token infrastructure
  block: forward create_dmabuf_token to drivers
  nvme-pci: implement dma_token backed requests
  io_uring/rsrc: introduce buf registration structure
  io_uring/rsrc: extend buffer update
  io_uring/rsrc: add dmabuf backed registered buffers

 block/bio.c                     |  28 +++-
 block/blk-merge.c               |  14 ++
 block/blk.h                     |   3 +-
 block/fops.c                    |  16 ++
 drivers/nvme/host/pci.c         | 282 ++++++++++++++++++++++++++++++++
 include/linux/bio.h             |  19 ++-
 include/linux/blk-mq.h          |   9 +
 include/linux/blk_types.h       |   8 +-
 include/linux/fs.h              |   2 +
 include/linux/io_dmabuf_token.h |  92 +++++++++++
 include/linux/io_uring_types.h  |   5 +
 include/linux/uio.h             |  11 ++
 include/uapi/linux/io_uring.h   |  31 +++-
 io_uring/io_uring.c             |   3 +-
 io_uring/rsrc.c                 | 266 +++++++++++++++++++++++++-----
 io_uring/rsrc.h                 |  30 +++-
 io_uring/rw.c                   |   4 +-
 lib/Kconfig                     |   4 +
 lib/Makefile                    |   2 +
 lib/io_dmabuf_token.c           | 272 ++++++++++++++++++++++++++++++
 lib/iov_iter.c                  |  29 +++-
 21 files changed, 1071 insertions(+), 59 deletions(-)
 create mode 100644 include/linux/io_dmabuf_token.h
 create mode 100644 lib/io_dmabuf_token.c

-- 
2.53.0


