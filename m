Return-Path: <io-uring+bounces-2673-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D885594C2A8
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 18:25:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46DA5B28083
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 16:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB7F646;
	Thu,  8 Aug 2024 16:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ESzrT6cp"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A7018B47A
	for <io-uring@vger.kernel.org>; Thu,  8 Aug 2024 16:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723134291; cv=none; b=k/w5jBoF3z00f1DLUqetdfw75iag/WHlJD551MZFjfuwOOP992vMNYE/fRRwDiaQBgeojm+WdZsEavux6RsXXBGrv/GMdSBYW4+AfXdj0bIaglm8MMKDzKPaP+ZAiEBMQ/YXUm4G/AmEegMlWaP/xwkOH/YOhY1cCHlLrGACtgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723134291; c=relaxed/simple;
	bh=goLjLGKXLxxfU24JVFqFOLm3RrLf6nKyUBY1Oi5Sb+0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZA7ECl0hVttskkg4ZWmIASWkgXcWpL6XIXGxhGZLuJ+Q7m1Kbo79Ju/gPBY+3V4+101V1P/LRwReaQ1WmRK+kS2Cp68cgzBNEQZGeDZ9DVvJSxfmLfiDCOTjAvl7pGSyOgCWnVrYM9ZC/uD91Jz3wldzVxcqduccXz7Jgh+/RYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ESzrT6cp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723134289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zyMi9Ro6GIfw7SugBcpTjwyoSOpWoq8JwyMq/fjCsAY=;
	b=ESzrT6cpQPvKyuwjthIPuEltCl92Zjq1ip/Nbljgb9GTxUiAE1VR4IE8rnprXXLRDMAGBm
	jxp+bFl4owPzEKeTp3zGU/twUwLiD1vj4dJAsKj5GGGBKWBwhWmCZCceXsvkOI8QUdFetk
	9T4SnT/ZKn2MIn2dzUVumCct4PBOzdc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-pPUOQiLjOUCuvt4o2vR9Cw-1; Thu,
 08 Aug 2024 12:24:47 -0400
X-MC-Unique: pPUOQiLjOUCuvt4o2vR9Cw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B747196CDFE;
	Thu,  8 Aug 2024 16:24:46 +0000 (UTC)
Received: from localhost (unknown [10.72.116.29])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F0D403000197;
	Thu,  8 Aug 2024 16:24:44 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 0/8] io_uring: support sqe group and provide group kbuf
Date: Fri,  9 Aug 2024 00:24:38 +0800
Message-ID: <20240808162438.345884-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hello,

The 1st 3 patches are cleanup, and prepare for adding sqe group.

The 4th patch supports generic sqe group which is like link chain, but
allows each sqe in group to be issued in parallel and the group shares
same IO_LINK & IO_DRAIN boundary, so N:M dependency can be supported with
sqe group & io link together. sqe group changes nothing on
IOSQE_IO_LINK.

The 5th patch supports one variant of sqe group: allow members to depend
on group leader, so that kernel resource lifetime can be aligned with
group leader or group, then any kernel resource can be shared in this
sqe group, and can be used in generic device zero copy.

The 6th & 7th patches supports providing sqe group buffer via the sqe
group variant.

The 8th patch supports ublk zero copy based on io_uring providing sqe
group buffer.

Tests:

1) pass liburing test
- make runtests

2) write/pass two sqe group test cases:

https://github.com/axboe/liburing/compare/master...ming1:liburing:sqe_group_v2

- covers related sqe flags combination and linking groups, both nop and
one multi-destination file copy.

- cover failure handling test: fail leader IO or member IO in both single
  group and linked groups, which is done in each sqe flags combination
  test

3) ublksrv zero copy:

ublksrv userspace implements zero copy by sqe group & provide group
kbuf:

	git clone https://github.com/ublk-org/ublksrv.git -b group-provide-buf_v2
	make test T=loop/009:nbd/061	#ublk zc tests

When running 64KB/512KB block size test on ublk-loop('ublk add -t loop --buffered_io -f $backing'),
it is observed that perf is doubled.

Any comments are welcome!

V5:
	- follow Pavel's suggestion to minimize change on io_uring fast code
	  path: sqe group code is called in by single 'if (unlikely())' from
	  both issue & completion code path

	- simplify & re-write group request completion
		avoid to touch io-wq code by completing group leader via tw
		directly, just like ->task_complete

		re-write group member & leader completion handling, one
		simplification is always to free leader via the last member

		simplify queueing group members, not support issuing leader
		and members in parallel

	- fail the whole group if IO_*LINK & IO_DRAIN is set on group
	  members, and test code to cover this change

	- misc cleanup

V4:
	- address most comments from Pavel
	- fix request double free
	- don't use io_req_commit_cqe() in io_req_complete_defer()
	- make members' REQ_F_INFLIGHT discoverable
	- use common assembling check in submission code path
	- drop patch 3 and don't move REQ_F_CQE_SKIP out of io_free_req()
	- don't set .accept_group_kbuf for net send zc, in which members
	  need to be queued after buffer notification is got, and can be
	  enabled in future
	- add .grp_leader field via union, and share storage with .grp_link
	- move .grp_refs into one hole of io_kiocb, so that one extra
	cacheline isn't needed for io_kiocb
	- cleanup & document improvement

V3:
	- add IORING_FEAT_SQE_GROUP
	- simplify group completion, and minimize change on io_req_complete_defer()
	- simplify & cleanup io_queue_group_members()
	- fix many failure handling issues
	- cover failure handling code in added liburing tests
	- remove RFC

V2:
	- add generic sqe group, suggested by Kevin Wolf
	- add REQ_F_SQE_GROUP_DEP which is based on IOSQE_SQE_GROUP, for sharing
	  kernel resource in group wide, suggested by Kevin Wolf
	- remove sqe ext flag, and use the last bit for IOSQE_SQE_GROUP(Pavel),
	in future we still can extend sqe flags with one uring context flag
	- initialize group requests via submit state pattern, suggested by Pavel
	- all kinds of cleanup & bug fixes

Ming Lei (8):
  io_uring: add io_link_req() helper
  io_uring: add io_submit_fail_link() helper
  io_uring: add helper of io_req_commit_cqe()
  io_uring: support SQE group
  io_uring: support sqe group with members depending on leader
  io_uring: support providing sqe group buffer
  io_uring/uring_cmd: support provide group kernel buffer
  ublk: support provide io buffer

 drivers/block/ublk_drv.c       | 160 ++++++++++++++-
 include/linux/io_uring/cmd.h   |   7 +
 include/linux/io_uring_types.h |  54 +++++
 include/uapi/linux/io_uring.h  |  11 +-
 include/uapi/linux/ublk_cmd.h  |   7 +-
 io_uring/io_uring.c            | 359 ++++++++++++++++++++++++++++++---
 io_uring/io_uring.h            |  16 ++
 io_uring/kbuf.c                |  60 ++++++
 io_uring/kbuf.h                |  13 ++
 io_uring/net.c                 |  23 ++-
 io_uring/opdef.c               |   4 +
 io_uring/opdef.h               |   2 +
 io_uring/rw.c                  |  20 +-
 io_uring/timeout.c             |   2 +
 io_uring/uring_cmd.c           |  28 +++
 15 files changed, 720 insertions(+), 46 deletions(-)

-- 
2.42.0


