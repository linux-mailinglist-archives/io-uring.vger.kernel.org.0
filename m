Return-Path: <io-uring+bounces-11400-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EE9E5CF7B12
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 11:11:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 021B7301C3BC
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 10:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83979235BE2;
	Tue,  6 Jan 2026 10:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bScYzJ5K"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCEE30FC1D
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 10:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694308; cv=none; b=MK9oEK0tmf2fxDn7/jVLQf3PaFhWnfY2BJirHTAVRAWntzmV7P/Y/oXPiuy+durALLiQTWu+rehw6591XhfhEL9T6l3bgYrc4PjBaqcZhjApJOL12xjE/pzvBfq4a2pDeDWwjMeP3AY4dp7xMs0ANRTOta1oA6VPSfIgAyZBW70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694308; c=relaxed/simple;
	bh=VI3NBkn78DeOAmBuSqzd8/WWLatYMwdAu1ht30aSoBY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VljRZ+VVmm0bZOeDk09uadHeJy2X0QOTaFqdWz+NSBNrQEcQYf+HyquJ3CQVlXYehU3u2Su3diRNsDoSF2vnGVBC2g38UI0OGogjJtGQHpyAyk35/jkscQx/PLq3o2MzUccX0l9sz0w6Q/f87g/vWjThTKTgn5qh3heDTtLmqb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bScYzJ5K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767694302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gmZZl0FgCrKwR6S6hnJNbXg5YonM5BtPybPNJWxbZ5c=;
	b=bScYzJ5KmNnd9tUGgcYz7XQEjRKFvnomAMRZSXR/qHz7S5OPbkCfGalC5CsOGVoCDheA63
	Ab4m/awxKZi8fwpg0Xj9+fY+Ce/7lp5YNl8pIRJ/cTOV8pMVQrVyoL8MiL8G/H7oXX+EA4
	IvvxEop3jA4pHMOzzpP9Eyxw86k1KxY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-oDYYi07KPQyYgG-VDYxDeA-1; Tue,
 06 Jan 2026 05:11:39 -0500
X-MC-Unique: oDYYi07KPQyYgG-VDYxDeA-1
X-Mimecast-MFC-AGG-ID: oDYYi07KPQyYgG-VDYxDeA_1767694298
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA96B1956050;
	Tue,  6 Jan 2026 10:11:37 +0000 (UTC)
Received: from localhost (unknown [10.72.116.130])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BFD3330001A8;
	Tue,  6 Jan 2026 10:11:36 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Stefan Metzmacher <metze@samba.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 0/13] io_uring: add IORING_OP_BPF for extending io_uring
Date: Tue,  6 Jan 2026 18:11:09 +0800
Message-ID: <20260106101126.4064990-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hello,

Add IORING_OP_BPF for extending io_uring operations, follows typical cases:

- buffer registered zero copy [1]

Also there are some RAID like ublk servers which needs to generate data
parity in case of ublk zero copy

- extend io_uring operations from application

Easy to add one new syscall with IORING_OP_BPF

- extend 64 byte SQE

bpf map can store IO data conveniently

- communicate in IO chain

IORING_OP_BPF can be used for communicate among IOs seamlessly without requiring
extra syscall

- pretty handy to inject error for test purpose

Any comments & feedback are welcome!


[1] lpc2024: ublk based zero copy I/O - use case in Android

https://lpc.events/event/18/contributions/1710/attachments/1440/3070/LPC2024_ublk_zero_copy.pdf


V2:
	- per-ring struct ops (Stefan Metzmacher, Caleb Sander Mateos)
	- refactor io_import_fixed()/io_prep_reg_iovec()/io_import_reg_vec()
	  for allowing to handle multiple buffers for single request
	- kernel selftests
	- all kinds of comments from Caleb Sander Mateos
	- support vectored and registered vector buffer


Ming Lei (12):
  io_uring: make io_import_fixed() global
  io_uring: refactor io_prep_reg_iovec() for BPF kfunc use
  io_uring: refactor io_import_reg_vec() for BPF kfunc use
  io_uring: prepare for extending io_uring with bpf
  io_uring: bpf: extend io_uring with bpf struct_ops
  io_uring: bpf: implement struct_ops registration
  io_uring: bpf: add BPF buffer descriptor for IORING_OP_BPF
  io_uring: bpf: add uring_bpf_memcpy() kfunc
  selftests/io_uring: add BPF struct_ops and kfunc tests
  selftests/io_uring: add bpf_memcpy selftest for uring_bpf_memcpy()
    kfunc
  selftests/io_uring: add copy_user_to_fixed() and copy_fixed_to_user()
    bpf_memcpy tests
  selftests/io_uring: add copy_user_to_reg_vec() and
    copy_reg_vec_to_user() bpf_memcpy tests

Pavel Begunkov (1):
  selftests/io_uring: update mini liburing

 include/linux/io_uring_types.h                |   5 +
 include/uapi/linux/io_uring.h                 |  40 ++
 init/Kconfig                                  |   7 +
 io_uring/Makefile                             |   1 +
 io_uring/bpf_op.c                             | 669 ++++++++++++++++++
 io_uring/bpf_op.h                             |  61 ++
 io_uring/io_uring.c                           |   5 +
 io_uring/io_uring.h                           |   6 +-
 io_uring/opdef.c                              |  16 +
 io_uring/rsrc.c                               |  46 +-
 io_uring/rsrc.h                               |  68 +-
 tools/include/io_uring/mini_liburing.h        |  67 +-
 tools/testing/selftests/Makefile              |   3 +-
 tools/testing/selftests/io_uring/.gitignore   |   2 +
 tools/testing/selftests/io_uring/Makefile     | 173 +++++
 .../selftests/io_uring/basic_bpf_ops.bpf.c    |  94 +++
 .../selftests/io_uring/basic_bpf_ops.c        | 215 ++++++
 .../selftests/io_uring/bpf_memcpy.bpf.c       |  98 +++
 tools/testing/selftests/io_uring/bpf_memcpy.c | 517 ++++++++++++++
 .../selftests/io_uring/include/iou_test.h     |  98 +++
 tools/testing/selftests/io_uring/runner.c     | 206 ++++++
 21 files changed, 2339 insertions(+), 58 deletions(-)
 create mode 100644 io_uring/bpf_op.c
 create mode 100644 io_uring/bpf_op.h
 create mode 100644 tools/testing/selftests/io_uring/.gitignore
 create mode 100644 tools/testing/selftests/io_uring/Makefile
 create mode 100644 tools/testing/selftests/io_uring/basic_bpf_ops.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/basic_bpf_ops.c
 create mode 100644 tools/testing/selftests/io_uring/bpf_memcpy.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/bpf_memcpy.c
 create mode 100644 tools/testing/selftests/io_uring/include/iou_test.h
 create mode 100644 tools/testing/selftests/io_uring/runner.c

-- 
2.47.0


