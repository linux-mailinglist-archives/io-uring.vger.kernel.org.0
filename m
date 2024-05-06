Return-Path: <io-uring+bounces-1789-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BF3FE8BD2A1
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 18:24:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E0247B22B15
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 16:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 121DC155A55;
	Mon,  6 May 2024 16:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MM/LkG4y"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A01E156669
	for <io-uring@vger.kernel.org>; Mon,  6 May 2024 16:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715012624; cv=none; b=X+n10PXv7gheC7tzMDaMcpeagVuZ8iw+/txpKIxYCfJTL/fuTb77AfOkmoQTyH3FLNQwLrAo8WhOfbEFLhOkN/YNg6UXIiF7j4EPY0wKrGQ4TgRSxSjMf6dmS7BzNOOyaPqwrF4uWrRFFfM2T/eluZDq3nOuXc2f6YC8pNoPqQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715012624; c=relaxed/simple;
	bh=F2lYvY+5SE+Jkx0odMLihfOXhmxv+pI56/mI1nfw53U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjcktQVs9sgG1o9unuWcYpFga9OGzesDzmpHsDJ9s01jwlH1gXICa072pO7Za9zRSe1Eouq/fvv3EqUO94GHegD0ZbtZmDu2GnenGmnAgED/UeJ0OnyA2fB5WCSe1gQrs8yJ7wcWLx9lHiSQuqz8v0jWL1Gh0DHTQnIDoH5dNN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MM/LkG4y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715012620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P/uPU1PZkJrKUxtyLt7k8LKrI2JUUc/DXMGKwGvSTgA=;
	b=MM/LkG4ykjRv0CSwsn6jLqa/RpCl0IeC1NOUYi5IXUMusmdc4c+QjJjAYlFhwIPE9hXRtf
	mcjp6nc2ydpUpaEaWecaA/I/HYChWQa4MqdOuhzAEkqZOV9V3VD+WhlqwxpKradKvAD+oZ
	eejDs3ZAd0ACEsPrX+YrXwrCJW5Y8Jk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-121-w7qsXptbOOyxuUGmPgsOaA-1; Mon,
 06 May 2024 12:23:36 -0400
X-MC-Unique: w7qsXptbOOyxuUGmPgsOaA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 098C03C025C2;
	Mon,  6 May 2024 16:23:36 +0000 (UTC)
Received: from localhost (unknown [10.72.116.15])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1898DEC682;
	Mon,  6 May 2024 16:23:34 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH V2 6/9] io_uring: support sqe group with members depending on leader
Date: Tue,  7 May 2024 00:22:42 +0800
Message-ID: <20240506162251.3853781-7-ming.lei@redhat.com>
In-Reply-To: <20240506162251.3853781-1-ming.lei@redhat.com>
References: <20240506162251.3853781-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

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
 io_uring/io_uring.c            | 36 +++++++++++++++++++++++++---------
 io_uring/io_uring.h            |  3 +++
 3 files changed, 33 insertions(+), 9 deletions(-)

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
index 465f4244fa0b..236765bc786c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -936,7 +936,14 @@ static __always_inline void io_req_commit_cqe(struct io_kiocb *req,
 
 static inline bool need_queue_group_members(struct io_kiocb *req)
 {
-	return req_is_group_leader(req) && !!req->grp_link;
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
@@ -969,7 +976,7 @@ static void io_fail_group_members(struct io_kiocb *req)
 	req->grp_link = NULL;
 }
 
-static void io_queue_group_members(struct io_kiocb *req, bool async)
+void io_queue_group_members(struct io_kiocb *req, bool async)
 {
 	struct io_kiocb *member = req->grp_link;
 
@@ -980,13 +987,20 @@ static void io_queue_group_members(struct io_kiocb *req, bool async)
 		struct io_kiocb *next = member->grp_link;
 
 		member->grp_link = req;
-		trace_io_uring_submit_req(member);
-		if (async)
-			member->flags |= REQ_F_FORCE_ASYNC;
-		if (member->flags & REQ_F_FORCE_ASYNC)
-			io_req_task_queue(member);
-		else
-			io_queue_sqe(member);
+
+		/* members have to be failed if they depends on leader */
+		if (unlikely((req->flags & REQ_F_FAIL) &&
+			     (req->flags & REQ_F_SQE_GROUP_DEP))) {
+			io_req_task_queue_fail(member, -ECANCELED);
+		} else {
+			trace_io_uring_submit_req(member);
+			if (async)
+				member->flags |= REQ_F_FORCE_ASYNC;
+			if (member->flags & REQ_F_FORCE_ASYNC)
+				io_req_task_queue(member);
+			else
+				io_queue_sqe(member);
+		}
 		member = next;
 	}
 	req->grp_link = NULL;
@@ -1065,6 +1079,10 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 		return;
 	}
 
+	/* now queue members if they depends on this leader */
+	if (req_is_group_leader(req) && (req->flags & REQ_F_SQE_GROUP_DEP))
+		io_queue_group_members(req, true);
+
 	io_cq_lock(ctx);
 	if (!(req->flags & REQ_F_CQE_SKIP))
 		io_req_commit_cqe(req, false);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 416c14c6f050..6cf27204503a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -69,6 +69,7 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 bool __io_complete_group_req(struct io_kiocb *req,
 			     struct io_kiocb *lead);
+void io_queue_group_members(struct io_kiocb *req, bool async);
 
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
@@ -374,6 +375,8 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
 	if (likely(!req_is_group_leader(req)) ||
 	    __io_complete_group_req(req, req))
 		wq_list_add_tail(&req->comp_list, &state->compl_reqs);
+	else if (req_is_group_leader(req) && (req->flags & REQ_F_SQE_GROUP_DEP))
+		io_queue_group_members(req, false);
 }
 
 static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
-- 
2.42.0


