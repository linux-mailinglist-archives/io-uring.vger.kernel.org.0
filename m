Return-Path: <io-uring+bounces-3167-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FE189766E8
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 12:50:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5143C285C18
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 10:50:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C3D419F12D;
	Thu, 12 Sep 2024 10:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OKLtrkTQ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D578E15D5D9
	for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 10:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726138210; cv=none; b=Yyoc7y0SREz1M4MoTWnLQFpUZzd2HnHQSwxmCJrHdl1dqqzpwPpxwi+sYmf6V+2ZJA5Jnj5dtPH+oRHMtjv5JOOdf7QgzHJ5+AZngRHp/flf40RbWyFKuy5l/RjMdY+K8l1TZ3uposzpgyf/ukluu1yEV3aOkDkCkVXQNRrAW3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726138210; c=relaxed/simple;
	bh=LkI7mwnW0lgzLbEltclh3VvO9G1qXsTj5yLVCGe4rOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVNDx1HtR1r52fGDNW9I5uEWGv/tKwbeq3ipOAO6I0UaPHiivWfjPBAHEs7Jtc4FQXQDKmHTRlDBW45UtNfvurY+Q33q3YmuM+W0tX0WtRpnsMpAvKjimdEJVDrNQEb4qov408MEe0LE4aqldXPPBHNPc1LbmJRYicSZmJgJm4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OKLtrkTQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726138207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YzGqB4trPe/vhMMrVDQAeyy20DttZoUCiI/1n/igGNY=;
	b=OKLtrkTQFNbA1ZNnL9KPxZCQoKiK76HPgB+3lA1WDWAoUK/j13DIaOJU7Xg4Ad5EwWdZan
	1puFO+a0N9BYO8ysHAAVeJPTO+x3Klpw2mlk46BxexgrZoXjaCHskJY2MQa/DPPxTi4/lt
	eEYtYyWoIoWq4IGOI3OwfDofhfttOHQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-42-3P7T77cDOj-gIQUAANNo2Q-1; Thu,
 12 Sep 2024 06:50:06 -0400
X-MC-Unique: 3P7T77cDOj-gIQUAANNo2Q-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 79E591955D47;
	Thu, 12 Sep 2024 10:50:05 +0000 (UTC)
Received: from localhost (unknown [10.72.116.81])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0E5B919560AA;
	Thu, 12 Sep 2024 10:50:03 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V6 5/8] io_uring: support sqe group with members depending on leader
Date: Thu, 12 Sep 2024 18:49:25 +0800
Message-ID: <20240912104933.1875409-6-ming.lei@redhat.com>
In-Reply-To: <20240912104933.1875409-1-ming.lei@redhat.com>
References: <20240912104933.1875409-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

IOSQE_SQE_GROUP just starts to queue members after the leader is completed,
which way is just for simplifying implementation, and this behavior is never
part of UAPI, and it may be relaxed and members can be queued concurrently
with leader in future.

However, some resource can't cross OPs, such as kernel buffer, otherwise
the buffer may be leaked easily in case that any OP failure or application
panic.

Add flag REQ_F_SQE_GROUP_DEP for allowing members to depend on group leader
explicitly, so that group members won't be queued until the leader request is
completed, the kernel resource lifetime can be aligned with group leader
or group, one typical use case is to support zero copy for device internal
buffer.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 11c6726abbb9..793d5a26d9b8 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -472,6 +472,7 @@ enum {
 	REQ_F_BL_NO_RECYCLE_BIT,
 	REQ_F_BUFFERS_COMMIT_BIT,
 	REQ_F_SQE_GROUP_LEADER_BIT,
+	REQ_F_SQE_GROUP_DEP_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -554,6 +555,8 @@ enum {
 	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
 	/* sqe group lead */
 	REQ_F_SQE_GROUP_LEADER	= IO_REQ_FLAG(REQ_F_SQE_GROUP_LEADER_BIT),
+	/* sqe group with members depending on leader */
+	REQ_F_SQE_GROUP_DEP	= IO_REQ_FLAG(REQ_F_SQE_GROUP_DEP_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
-- 
2.42.0


