Return-Path: <io-uring+bounces-1864-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C5E48C2DDA
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 02:13:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 375C0285387
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 00:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76CC6802;
	Sat, 11 May 2024 00:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aMF+7imy"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB547367
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 00:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715386377; cv=none; b=k22nZL4vq/ZN9C9bQoGuncKA7cLjJTbDfi/TKg13mrMGccAeSY31pOGre8Z1hZr4rc5tch9DmjGTU9LvaXR9Ogg0LcgogSS2NdaaSmWBdowQeSYvT9NmzPp2mbh/oSqF6tPYvbsluYC4f2sW8JoCx+kTqrFzD6/mnRlMiFBb6Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715386377; c=relaxed/simple;
	bh=fDmCWWyvn6c7ZWZmuODSwE2CPQI/6yN4F8QF3T8s7S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOBarg7QtoSwITZN5yrleUOfBYjqxIDf9VIBtiHVJbRZWq1+MpZjYcIWc5GTxSozXIDWfuLbnCNmqQqGxOG46nBzo92qnfappZ2FbzrALSgz8/9A8w54c28TcQZjUXx/7fRhj5qoJ3Med3LHr1+Yfs8GXD3a7bYTM209rlehl78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aMF+7imy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715386374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zmksbor9K1AjjeVGOcASf4mlen+v2ui9MojoF3Muytw=;
	b=aMF+7imyw85DmEiuFGAZGAYCKuadyGi5SaFSnfp/QbCVmKRN5Ego1+UHuih5M6N76d9sWU
	aIupu9h9jQwjE9P5qeFZsUAGVcN4OqZIf/ndjQGO5fvuXEQ8hR/ZuvNzz400TlJkNrUFOK
	mkNqccfq9/DLfl/AAUSslTmiBiT/Bnw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-353-ac0VIsb-NTKqslghWNVBHA-1; Fri,
 10 May 2024 20:12:43 -0400
X-MC-Unique: ac0VIsb-NTKqslghWNVBHA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0649C29AA3B3;
	Sat, 11 May 2024 00:12:43 +0000 (UTC)
Received: from localhost (unknown [10.72.116.30])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1423A40004D;
	Sat, 11 May 2024 00:12:41 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 6/9] io_uring: support sqe group with members depending on leader
Date: Sat, 11 May 2024 08:12:09 +0800
Message-ID: <20240511001214.173711-7-ming.lei@redhat.com>
In-Reply-To: <20240511001214.173711-1-ming.lei@redhat.com>
References: <20240511001214.173711-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

Generic sqe group provides flexible way for supporting N:M dependency
between groups.

However, some resource can't cross OPs, such as kernel buffer, otherwise
the buffer may be leaked easily in case that any OP failure or application
panic.

Add flag REQ_F_SQE_GROUP_DEP for allowing members to depend on group leader,
so that group members won't be queued until the leader request is completed,
and we still commit leader's CQE after all members CQE are posted. With this
way, the kernel resource lifetime can be aligned with group leader or group,
one typical use case is to support zero copy for device internal buffer.

This use case may not be generic enough, so set it only for specific OP which
can serve as group leader, meantime we have run out of sqe flags.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h |  3 +++
 io_uring/io_uring.c            | 16 +++++++++++++++-
 io_uring/io_uring.h            |  5 ++++-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 62311b0f0e0b..5cbc9d3346a7 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -477,6 +477,7 @@ enum {
 	REQ_F_BL_NO_RECYCLE_BIT,
 	REQ_F_BUFFERS_COMMIT_BIT,
 	REQ_F_SQE_GROUP_LEADER_BIT,
+	REQ_F_SQE_GROUP_DEP_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -561,6 +562,8 @@ enum {
 	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
 	/* sqe group lead */
 	REQ_F_SQE_GROUP_LEADER	= IO_REQ_FLAG(REQ_F_SQE_GROUP_LEADER_BIT),
+	/* sqe group with members depending on leader */
+	REQ_F_SQE_GROUP_DEP	= IO_REQ_FLAG(REQ_F_SQE_GROUP_DEP_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b87c5452de43..5d94629c01b8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -936,7 +936,14 @@ static __always_inline void io_req_commit_cqe(struct io_kiocb *req,
 
 static inline bool need_queue_group_members(struct io_kiocb *req)
 {
-	return req_is_group_leader(req) && req->grp_link;
+	if (likely(!(req->flags & REQ_F_SQE_GROUP)))
+		return false;
+
+	if (!(req->flags & REQ_F_SQE_GROUP_LEADER) ||
+			(req->flags & REQ_F_SQE_GROUP_DEP))
+		return false;
+
+	return !!req->grp_link;
 }
 
 /* Can only be called after this request is issued */
@@ -983,6 +990,9 @@ void io_queue_group_members(struct io_kiocb *req, bool async)
 
 		if (unlikely(member->flags & REQ_F_FAIL)) {
 			io_req_task_queue_fail(member, member->cqe.res);
+		} else if (unlikely((req->flags & REQ_F_FAIL) &&
+			     (req->flags & REQ_F_SQE_GROUP_DEP))) {
+			io_req_task_queue_fail(member, -ECANCELED);
 		} else if (member->flags & REQ_F_FORCE_ASYNC) {
 			io_req_task_queue(member);
 		} else {
@@ -1065,6 +1075,10 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 		return;
 	}
 
+	/* queue members which may depend on leader */
+	if (req_is_group_leader(req) && (req->flags & REQ_F_SQE_GROUP_DEP))
+		io_queue_group_members(req, true);
+
 	io_cq_lock(ctx);
 	if (!(req->flags & REQ_F_CQE_SKIP))
 		io_req_commit_cqe(req, false);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index b11db3bdd8d8..f593ff8b2deb 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -368,7 +368,10 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
 
 	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
 
-	/* members may not be issued when leader is completed */
+	/*
+	 * Members may not be issued when leader is completed, or members
+	 * depend on leader in case of REQ_F_SQE_GROUP_DEP
+	 */
 	if (unlikely(req_is_group_leader(req) && req->grp_link))
 		io_queue_group_members(req, false);
 }
-- 
2.42.0


