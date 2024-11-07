Return-Path: <io-uring+bounces-4522-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F1429C031E
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 12:02:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2006C2858A8
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 11:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949631EC011;
	Thu,  7 Nov 2024 11:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KwB+wLJI"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDB51D363D
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 11:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730977326; cv=none; b=VSWo5hKn+nHF6I+r2fERRJegF98wvio0+DUBPnkG4VJtk6ZlwaECN6F7JNhzKbg6M/Oa4DLyRGhOThHMUNW/181yrbqzp/SyhuvmtC1mLYsslmLOo6vhGJbppthCKVaasXOgvSNItp5hiqwmsfwH4u04EDOea9iwVUI/HhE98o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730977326; c=relaxed/simple;
	bh=p1eRSZME+XlXA1P2unEgnzwKv3MO/z2NgR80a0EFp1I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wimsz+YQmG9OOhFwUGTsWTgptJe7YSenC3hE15MvjRNLGThkaXJkhbOXLJcrMBrOzs3PUXPx0zrApbORHBMkZcB7W2fdc8szo3FBBG6AQw+O4tsjP9OODVU73sW/03ctyN2V4T++tqWC6Zz/GtcYBWxqRn6MxaLXakmjwOmbq8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KwB+wLJI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730977323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=urFJvNQPHbmn+HYSPpplFEROkYF17MaGBVt7xiGBO80=;
	b=KwB+wLJIdp6jKl3YtpSdlFnX83auyk8RBX4c94+R/QQ7mt2ME1Niub2WZLygrmA69cwMO/
	6Th82FBbLAro6cMOx4NAJwQSJBASglpGF1CC+dpKs4uD/z6UKvpOaU5lA9rRdYcuV8P2y3
	Av+Sbbd9G2ZxMh8oxGHjEP4ow8sacGk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-312-geZxSLxuNnGgvUV7s0DpiA-1; Thu,
 07 Nov 2024 06:02:00 -0500
X-MC-Unique: geZxSLxuNnGgvUV7s0DpiA-1
X-Mimecast-MFC-AGG-ID: geZxSLxuNnGgvUV7s0DpiA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A8BCD19540F0;
	Thu,  7 Nov 2024 11:01:58 +0000 (UTC)
Received: from localhost (unknown [10.72.116.54])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5D4FA1955F3D;
	Thu,  7 Nov 2024 11:01:56 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V10 0/12] io_uring: support group buffer & ublk zc
Date: Thu,  7 Nov 2024 19:01:33 +0800
Message-ID: <20241107110149.890530-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Hello,

Patch 1~3 cleans rsrc code.

Patch 4~9 prepares for supporting kernel buffer. 

The 10th patch supports group buffer, so far only kernel buffer is
supported, but it is pretty easy to extend for userspace group buffer.

The 11th patch adds uring_cmd interface for driver.

The last patch applies group kernel buffer for supporting ublk zc.

Tests:

1) pass liburing test
- make runtests

2) add ublk loop-zc test code
https://github.com/ming1/liburing/tree/uring_group

V10:
	- use io_rsrc_node to deal with group buffer(Jens)
	- rebase on the latest for-6.13/io_uring
	- cleanup rsrc code
	- add request flag for marking if buffer is imported(Jens)
	- misc cleanup

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

Ming Lei (12):
  io_uring/rsrc: pass 'struct io_ring_ctx' reference to rsrc helpers
  io_uring/rsrc: remove '->ctx_ptr' of 'struct io_rsrc_node'
  io_uring/rsrc: add & apply io_req_assign_buf_node()
  io_uring/rsrc: prepare for supporting external 'io_rsrc_node'
  io_uring: rename io_mapped_ubuf as io_mapped_buf
  io_uring: rename io_mapped_buf->ubuf as io_mapped_buf->addr
  io_uring: shrink io_mapped_buf
  io_uring: reuse io_mapped_buf for kernel buffer
  io_uring: add callback to 'io_mapped_buffer' for giving back kernel
    buffer
  io_uring: support leased group buffer with REQ_F_GROUP_BUF
  io_uring/uring_cmd: support leasing device kernel buffer to io_uring
  ublk: support leasing io buffer to io_uring

 drivers/block/ublk_drv.c       | 168 +++++++++++++++++++++++++++++++--
 include/linux/io_uring/cmd.h   |   7 ++
 include/linux/io_uring_types.h |  43 +++++++++
 include/uapi/linux/ublk_cmd.h  |  11 ++-
 io_uring/fdinfo.c              |   4 +-
 io_uring/filetable.c           |  13 +--
 io_uring/filetable.h           |   4 +-
 io_uring/io_uring.c            |  24 ++++-
 io_uring/io_uring.h            |   5 +
 io_uring/kbuf.c                |  82 ++++++++++++++++
 io_uring/kbuf.h                |  27 ++++++
 io_uring/net.c                 |  30 +++++-
 io_uring/nop.c                 |   3 +-
 io_uring/opdef.c               |   4 +
 io_uring/opdef.h               |   2 +
 io_uring/rsrc.c                |  69 ++++++++------
 io_uring/rsrc.h                |  77 +++++++--------
 io_uring/rw.c                  |  40 ++++++--
 io_uring/splice.c              |   2 +-
 io_uring/uring_cmd.c           |  12 ++-
 20 files changed, 521 insertions(+), 106 deletions(-)

-- 
2.47.0


