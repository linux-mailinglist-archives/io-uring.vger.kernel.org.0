Return-Path: <io-uring+bounces-4479-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FE1E9BE8BB
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 13:27:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92D6C1C21A84
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 12:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C48B71DF251;
	Wed,  6 Nov 2024 12:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JNrG/aMd"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53E51DF726
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 12:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896035; cv=none; b=lPPk9sbgkqz3dl+tR+U09oBzasvcx+7gmhNFgcqUVdXcdop+NbfgTJQObRaZAIwFBrciF67RHZVRV1Y0mV+a1FYh+WnphX/edtRdyNA6bea4CNH5d9qCqQv0V246/hgOPfWBUC0Yvpdp38t0nAKcAYuds3ZF1+PZdp9JsuSS0b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896035; c=relaxed/simple;
	bh=+CD0KQayN/Zpv0ZpHNGAAUaSjkqhd4IrvQeUZEAdgC4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qSj6vyPUlskT2cSuEELi+iPfHt4pG/ZPjEnO5b9/1qP8w8F+YWc2WaN69Ld6HVQzOGEqOHphbp8QzpEhoEDyHKJNdhohy/94PAN8Mt6er8fVfq4f+aeNZKMZMzW0Angxx1q6aopapssiwVHZBtw0TMtdXJG5oVMAcyPclhO8MjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JNrG/aMd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730896032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+OKB6TI8ANpl0bhfb+8pZNymVuKYsSCq5VO6dDBCZyg=;
	b=JNrG/aMdHxVIriFv2EDGEUVs+5zIK832N42pnjj45QwwNn0/nWB4wcU/BxJtMYbHNTc2Ad
	nW07YXOH0orqH+DUy40sf8286HFDYLQLDUJpk+bDYZyawPV93nuCwhmYFCrJWfUBL0CGUj
	oP6OC9qAf+DI5s9mTIXVw/3D2PuQvi0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-135-_1d-ndHuOQKlFxNOh8PD9Q-1; Wed,
 06 Nov 2024 07:27:11 -0500
X-MC-Unique: _1d-ndHuOQKlFxNOh8PD9Q-1
X-Mimecast-MFC-AGG-ID: _1d-ndHuOQKlFxNOh8PD9Q
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83DE719560BD;
	Wed,  6 Nov 2024 12:27:09 +0000 (UTC)
Received: from localhost (unknown [10.72.116.107])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 405DE1955F42;
	Wed,  6 Nov 2024 12:27:07 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V9 0/7] io_uring: support group buffer & ublk zc
Date: Wed,  6 Nov 2024 20:26:49 +0800
Message-ID: <20241106122659.730712-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Hello,

The 1st ~ 4th patches reuse `io_mapped_ubuf` for group kernel buffer.

The 5th patch supports group buffer, so far only kernel buffer is
supported, but it is pretty easy to extend for userspace group buffer.

The 6th patch adds uring_cmd interface for driver.

The last patch applies group kernel buffer for supporting ublk zc.

Tests:

1) pass liburing test
- make runtests

2) add ublk loop-zc test code
https://github.com/ming1/liburing/tree/uring_group

V9:
	- reuse io_mapped_ubuf for group kernel buffer(Jens)
	- rename as REQ_F_GROUP_BUF which can be extended for userspace
	group buffer easily
	- rebase on the latest for-6.13/io_uring
	- make sure that group buffer is imported once
	- use group buffer exclusively with buffer node & buffer select
	- misc cleanup

V8:
	- simplify & clean up group request completion, don't reuse 
	SQE_GROUP as state; meantime improve document; now group
	implementation is quite clean
	- handle short read/recv correctly by zeroing out the remained
	  part(Pavel)
	- fix one group leader reference(Uday Shankar)
	- only allow ublk provide buffer command in case of zc(Uday Shankar)

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
  io_uring: rename io_mapped_ubuf as io_mapped_buf
  io_uring: rename ubuf of io_mapped_buf as start
  io_uring: shrink io_mapped_buf
  io_uring: reuse io_mapped_buf for kernel buffer
  io_uring: support leased group buffer with REQ_F_GROUP_BUF
  io_uring/uring_cmd: support leasing device kernel buffer to io_uring
  ublk: support leasing io buffer to io_uring

 drivers/block/ublk_drv.c       | 160 +++++++++++++++++++++++++++++++--
 include/linux/io_uring/cmd.h   |   7 ++
 include/linux/io_uring_types.h |  50 +++++++++++
 include/uapi/linux/ublk_cmd.h  |  11 ++-
 io_uring/fdinfo.c              |   4 +-
 io_uring/io_uring.c            |  32 +++++--
 io_uring/io_uring.h            |   5 ++
 io_uring/kbuf.c                |  83 +++++++++++++++++
 io_uring/kbuf.h                |  46 ++++++++++
 io_uring/net.c                 |  27 +++++-
 io_uring/rsrc.c                |  19 ++--
 io_uring/rsrc.h                |  16 +---
 io_uring/rw.c                  |  37 ++++++--
 io_uring/uring_cmd.c           |  10 +++
 14 files changed, 463 insertions(+), 44 deletions(-)

-- 
2.47.0


