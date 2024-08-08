Return-Path: <io-uring+bounces-2679-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ECBF94C2B3
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 18:25:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE5DD2814EF
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 16:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60BDA18F2FE;
	Thu,  8 Aug 2024 16:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HKsG4jJs"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27E9154C17
	for <io-uring@vger.kernel.org>; Thu,  8 Aug 2024 16:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723134340; cv=none; b=c7ZTGUcvqIpyhb0JiYipQUkzKmd3qk4m2eD4sG4XXjOIHC8qXcttHJtqSG01kiM32RfLtyBkBiwAjFFtOfJ5jkp1rSZKjxOK7wAd2yhYV3RxROlralTPgcDJ2WAaFkwlDipu3LCoS/zyGe7FpuDoXGdStei/7mrF+luREdEUzMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723134340; c=relaxed/simple;
	bh=6jRTkA7NE2gy0TH8+LtPFYsg5kPC89nx5OP10TUsXjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNng0MWijiptjOK1Cz3j4NB9uI3eX+yGi1wLgplu3+iunzET5y7W4hH6fjlUF33kHVqdwz8mvlwsZfbPQ6tebKTsojAbBWiRvly53WeGxgIV1TO9jb2ttsZqXNf8L7RXSquJ9AjE7ULXYVfU0iqHUcrfQNGxvBscHCijMmlU8ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HKsG4jJs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723134337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=whNq6N/CVp43KwtlK6MlFmaDo3qzPu/mXyExiz9JuFw=;
	b=HKsG4jJsygh7xxOlEJCAzruq6baz1ny5ngJzDKUrH2/Wwf2qSM2J+qQM16MawpME2ZPG0f
	6voSmSGXDPtImeiNYi5Psyt6k+U40cH2h9u/VXeiJRNtk2YOmNi6L/qBzT94sN4dyaLVHh
	bR+dwTRiUozO7DZXDff7dE0fdL/DOpw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-117-gZ-tBcolM9KLi_QSYI4CZQ-1; Thu,
 08 Aug 2024 12:25:36 -0400
X-MC-Unique: gZ-tBcolM9KLi_QSYI4CZQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 908D01944B29;
	Thu,  8 Aug 2024 16:25:35 +0000 (UTC)
Received: from localhost (unknown [10.72.116.29])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 802FF195916B;
	Thu,  8 Aug 2024 16:25:34 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 5/8] io_uring: support sqe group with members depending on leader
Date: Fri,  9 Aug 2024 00:24:54 +0800
Message-ID: <20240808162503.345913-6-ming.lei@redhat.com>
In-Reply-To: <20240808162503.345913-1-ming.lei@redhat.com>
References: <20240808162503.345913-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

IOSQE_SQE_GROUP just starts to queue members after the leader is completed,
which way is just for simplifying implementation, and this behavior is never
part of UAPI, and it may be relaxed and members can be queued concurrently
with leader in future.

However, some resource can't cross OPs, such as kernel buffer, otherwise
the buffer may be leaked easily in case that any OP failure or application
panic.

Add flag REQ_F_SQE_GROUP_DEP for allowing members to depend on group leader
explicitly, so that group members won't be queued until the leader request is
completed, and we still commit leader's CQE after all members CQE are posted.
With this way, the kernel resource lifetime can be aligned with group leader
or group, one typical use case is to support zero copy for device internal
buffer.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h | 3 +++
 io_uring/io_uring.c            | 8 +++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index c5250e585289..d0972e2a098f 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -469,6 +469,7 @@ enum {
 	REQ_F_BL_NO_RECYCLE_BIT,
 	REQ_F_BUFFERS_COMMIT_BIT,
 	REQ_F_SQE_GROUP_LEADER_BIT,
+	REQ_F_SQE_GROUP_DEP_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -551,6 +552,8 @@ enum {
 	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
 	/* sqe group lead */
 	REQ_F_SQE_GROUP_LEADER	= IO_REQ_FLAG(REQ_F_SQE_GROUP_LEADER_BIT),
+	/* sqe group with members depending on leader */
+	REQ_F_SQE_GROUP_DEP	= IO_REQ_FLAG(REQ_F_SQE_GROUP_DEP_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 45a292445b18..b4f5dac85fa4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -982,7 +982,13 @@ static void io_complete_group_leader(struct io_kiocb *req)
 	req->grp_refs -= 1;
 	WARN_ON_ONCE(req->grp_refs == 0);
 
-	/* TODO: queue members with leader in parallel */
+	/*
+	 * TODO: queue members with leader in parallel
+	 *
+	 * So far, REQ_F_SQE_GROUP_DEP depends that members are queued
+	 * after leader is completed, which may be changed in future,
+	 * then REQ_F_SQE_GROUP_DEP has to be respected in another way.
+	 */
 	if (req->grp_link)
 		io_queue_group_members(req);
 }
-- 
2.42.0


