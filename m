Return-Path: <io-uring+bounces-2453-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5600592902F
	for <lists+io-uring@lfdr.de>; Sat,  6 Jul 2024 05:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D84832831BB
	for <lists+io-uring@lfdr.de>; Sat,  6 Jul 2024 03:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E24EC156;
	Sat,  6 Jul 2024 03:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jz0DfIJg"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F37E56A
	for <io-uring@vger.kernel.org>; Sat,  6 Jul 2024 03:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720235443; cv=none; b=fXpTiExwKyEh98Ha6WR71+3nJHkX1q7RoKm1ldwJBSOVnOWdkLg2WBjli6LQGKdhr7r15FEOPNMe44olTcE06Qh/l/H7JHbU8Vfk6UryyqCGB8I9b2O4ewHIkiSTGEDSpgYwn9CxG2aZvYshNTQZ2w85mDOtwzNaagYRtQxI8/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720235443; c=relaxed/simple;
	bh=7aUWbAJSIs/urCvDMp26AN1zOjM8z35tp1oHnHZaNqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgoLJCn0ryk587siiYviV8ql9FFxTKBf6nTG2ko3Wg/mUHnPs/AaqGTSz9cNSYwsIYoCbnjx5wS8384EGPdzfumuz/dGNLQkcuryXIlpAbH8WF3nYJ9PuxT2gECs0FQkO/WyYCBpXH6hlLH/ZwvZA5hK3KVx+HO+c/WK54WkeQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jz0DfIJg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720235440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z+v5dy5ngR3sUEhHmjoDOcCBsZMHy1k2+ue7A8QD+lI=;
	b=Jz0DfIJgakED853Md6TabCQIjJkLRggBGudkc53WmnK74xMJlI4ezeds9Upos+FRp9sRNc
	xiTYv7NAUTjpd74fIpLH2nQxEjr9v/NqsM0QNnmEe80Xfscht5Kxr4JIFWMIWJnQpabHuE
	v86oylMExySiMkyk2EiebxhqibRhCPk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-20-B05tLQPCNeK-QytTBpCAqA-1; Fri,
 05 Jul 2024 23:10:37 -0400
X-MC-Unique: B05tLQPCNeK-QytTBpCAqA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A09A2195608A;
	Sat,  6 Jul 2024 03:10:35 +0000 (UTC)
Received: from localhost (unknown [10.72.112.32])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4B02C19560B2;
	Sat,  6 Jul 2024 03:10:33 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 5/8] io_uring: support sqe group with members depending on leader
Date: Sat,  6 Jul 2024 11:09:55 +0800
Message-ID: <20240706031000.310430-6-ming.lei@redhat.com>
In-Reply-To: <20240706031000.310430-1-ming.lei@redhat.com>
References: <20240706031000.310430-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

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
 io_uring/io_uring.c            | 15 ++++++++++++++-
 io_uring/io_uring.h            |  5 ++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index b5cc3dee8fa2..f56f37833239 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -471,6 +471,7 @@ enum {
 	REQ_F_BL_NO_RECYCLE_BIT,
 	REQ_F_BUFFERS_COMMIT_BIT,
 	REQ_F_SQE_GROUP_LEADER_BIT,
+	REQ_F_SQE_GROUP_DEP_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -555,6 +556,8 @@ enum {
 	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
 	/* sqe group lead */
 	REQ_F_SQE_GROUP_LEADER	= IO_REQ_FLAG(REQ_F_SQE_GROUP_LEADER_BIT),
+	/* sqe group with members depending on leader */
+	REQ_F_SQE_GROUP_DEP	= IO_REQ_FLAG(REQ_F_SQE_GROUP_DEP_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b5415f0774e5..986048bdc546 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -882,7 +882,13 @@ static __always_inline void io_req_commit_cqe(struct io_ring_ctx *ctx,
 
 static inline bool need_queue_group_members(io_req_flags_t flags)
 {
-	return flags & REQ_F_SQE_GROUP_LEADER;
+	if (likely(!(flags & REQ_F_SQE_GROUP)))
+		return false;
+
+	if (!(flags & REQ_F_SQE_GROUP_LEADER) ||
+			(flags & REQ_F_SQE_GROUP_DEP))
+		return false;
+	return true;
 }
 
 /* Can only be called after this request is issued */
@@ -930,6 +936,9 @@ void io_queue_group_members(struct io_kiocb *req, bool async)
 
 		if (unlikely(member->flags & REQ_F_FAIL)) {
 			io_req_task_queue_fail(member, member->cqe.res);
+		} else if (unlikely((req->flags & REQ_F_FAIL) &&
+			     (req->flags & REQ_F_SQE_GROUP_DEP))) {
+			io_req_task_queue_fail(member, -ECANCELED);
 		} else if (member->flags & REQ_F_FORCE_ASYNC) {
 			io_req_task_queue(member);
 		} else {
@@ -1012,6 +1021,10 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 		return;
 	}
 
+	/* queue members which may depend on leader */
+	if (req_is_group_leader(req) && (req->flags & REQ_F_SQE_GROUP_DEP))
+		io_queue_group_members(req, true);
+
 	io_cq_lock(ctx);
 	if (!(req->flags & REQ_F_CQE_SKIP) && !req_is_group_leader(req)) {
 		if (!io_fill_cqe_req(ctx, req))
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 8cc347959f7e..72cbbf883a46 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -365,7 +365,10 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
 
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


