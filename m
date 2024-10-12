Return-Path: <io-uring+bounces-3617-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DCCC99B242
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 10:53:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8EC561F22AC7
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 08:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 664BB145B0F;
	Sat, 12 Oct 2024 08:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hPMMGAcH"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B3AD517
	for <io-uring@vger.kernel.org>; Sat, 12 Oct 2024 08:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728723224; cv=none; b=JPURhDmWp3g2bKxpsZnyJa59LMcbGNJpEvfetMaJ4cnUtQeeNalUg8SZtGjxiB8a7raf5vsZ+/nSZfFsVKYjV//65dMBKMwmz/ISL0i2QtR/Cogwff8qN/KYGIafdtafpp6SraYjfV0VOmXW1L++Q1njgMI7PIGq8hDtK6ZySLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728723224; c=relaxed/simple;
	bh=m0MoSSh0wgiqnwJBltdxVEJE1rD8anUzmaeGx0r0tS0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P/PAwhSAC2rxKmk5pA+GCD5A09x+0fWYuCwdKN3N9+DSCS33J8hEkqatGkANE1XhTMkKDDH/fH9vM2HHVfI5AvkXJhr9LS/iRPhjrfmmcw4vxlKcrr14ZMN7NVHGCsvVd1vl229S3oWQmYjZj339OQzogWc69J4U63Tch4fBgBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hPMMGAcH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728723221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pmmPzgIs/vs2Xp/A8ftfT2TPwinHJ7c0cIDSFUJ4u8A=;
	b=hPMMGAcHHJTcYY9Jr2wJWmxl+Xc+VeKaBEqioZ3soYpjq6MBwxHfLJxXfBp2rmHc9r/s4D
	on8zRDhGQVCDunZ1qu9tKn1P7fH3EeQuRfUQe5x2cOHPDRRgvDAarvaIhdwWw9lvxtQysF
	SzVvARaCyHR+kY3rpcRGn6xTYr3iivs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-235-IPvIziPbMOmeOJnAQi3d7Q-1; Sat,
 12 Oct 2024 04:53:39 -0400
X-MC-Unique: IPvIziPbMOmeOJnAQi3d7Q-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61B3619560AB;
	Sat, 12 Oct 2024 08:53:38 +0000 (UTC)
Received: from localhost (unknown [10.72.116.121])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2E5481956089;
	Sat, 12 Oct 2024 08:53:36 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V7 0/8] io_uring: support sqe group and leased group kbuf
Date: Sat, 12 Oct 2024 16:53:20 +0800
Message-ID: <20241012085330.2540955-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

The 1st 3 patches are cleanup, and prepare for adding sqe group.

The 4th patch supports generic sqe group which is like link chain, but
allows each sqe in group to be issued in parallel and the group shares
same IO_LINK & IO_DRAIN boundary, so N:M dependency can be supported with
sqe group & io link together.

The 5th & 6th patches supports to lease other subsystem's kbuf to
io_uring for use in sqe group wide.

The 7th patch supports ublk zero copy based on io_uring sqe group &
leased kbuf.

Tests:

1) pass liburing test
- make runtests

2) write/pass sqe group test case and sqe provide buffer case:

https://github.com/ming1/liburing/tree/uring_group

- covers related sqe flags combination and linking groups, both nop and
one multi-destination file copy.

- cover failure handling test: fail leader IO or member IO in both single
  group and linked groups, which is done in each sqe flags combination
  test

- cover io_uring with leased group kbuf by adding ublk-loop-zc

V7:
	- remove dead code in sqe group support(Pavel)
	- fail single group request(Pavel)
	- remove IORING_PROVIDE_GROUP_KBUF(Pavel)
	- remove REQ_F_SQE_GROUP_DEP(Pavel)
	- rename as leasing buffer
	- improve commit log
	- map group member's IOSQE_IO_DRAIN to GROUP_KBUF, which
	aligns with buffer select use, and it means that io_uring starts
	to support leased kbuf from other subsystem for group member
	requests only

V6:
	- follow Pavel's suggestion to disallow IOSQE_CQE_SKIP_SUCCESS &
	  LINK_TIMEOUT
	- kill __io_complete_group_member() (Pavel)
	- simplify link failure handling (Pavel)
	- move members' queuing out of completion lock (Pavel)
	- cleanup group io complete handler
	- add more comment
	- add ublk zc into liburing test for covering
	  IOSQE_SQE_GROUP & IORING_PROVIDE_GROUP_KBUF 

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


Ming Lei (7):
  io_uring: add io_link_req() helper
  io_uring: add io_submit_fail_link() helper
  io_uring: add helper of io_req_commit_cqe()
  io_uring: support SQE group
  io_uring: support leased group buffer with REQ_F_GROUP_KBUF
  io_uring/uring_cmd: support leasing device kernel buffer to io_uring
  ublk: support lease io buffer to io_uring

 drivers/block/ublk_drv.c       | 157 +++++++++++++-
 include/linux/io_uring/cmd.h   |   7 +
 include/linux/io_uring_types.h |  58 +++++
 include/uapi/linux/io_uring.h  |   4 +
 include/uapi/linux/ublk_cmd.h  |   7 +-
 io_uring/io_uring.c            | 382 ++++++++++++++++++++++++++++++---
 io_uring/io_uring.h            |  11 +
 io_uring/kbuf.c                |  58 +++++
 io_uring/kbuf.h                |  22 ++
 io_uring/net.c                 |  23 +-
 io_uring/rw.c                  |  21 +-
 io_uring/timeout.c             |   6 +
 io_uring/uring_cmd.c           |  13 ++
 13 files changed, 721 insertions(+), 48 deletions(-)

-- 
2.46.0


