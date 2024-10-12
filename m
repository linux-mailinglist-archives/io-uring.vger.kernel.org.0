Return-Path: <io-uring+bounces-3620-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA5D99B24B
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 10:54:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F039A1F22C12
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 08:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA0C14A4DC;
	Sat, 12 Oct 2024 08:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DWwtkwQx"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6C8149E1A
	for <io-uring@vger.kernel.org>; Sat, 12 Oct 2024 08:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728723238; cv=none; b=nw6uh9vY/j6O5vMnNCluNeMPQkREiasEWQzHTN0HQShOSqSg2tvUHKbS24eQzQneHF7GfqK6w+GEB8PFo1Q9g2CLch2H7H/MEpdUb0b2j6CQYBt4B1hoR3KKtE4eEwa3UEbk2O5gJVBEGuPuxSDTHBvkdG/EVzqLAmcVdXmPh6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728723238; c=relaxed/simple;
	bh=j56yQ/+zKz0rxtCIZZnX4JDBpesXkyUfwHDJD+MHGTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/Kf1XMRfm33LH0YOBhhuTHcYh+gur4JK6kz29VDXwD80SBvdcKFNfT+lwT1OYlDlaJahB1bA2rRcCGWSm43VXBedO+Rj1prG1VOjFe/PaBlzcWDIk2hX6oUZZXtPpgrhU3WQueLC5oscYGEcgwKBDYtCbtHe5LW/wsh65YLiwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DWwtkwQx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728723235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XKKCS1EErSCuuqT6YFEUg109+H+CyDDctezQlYubN0A=;
	b=DWwtkwQxn3ixR5aDwqe+uv0jJqY+Cg54ZOiiwuUkrHyntAMpwq22zDjJ/nHnAy8sra1AU1
	TmnmX/4Y5kXJVfZyDf9qA3QmXvoy1E5bkOmFmFhA4k9t7YM6ApNpGfPbgXbKRb0U+tSqCH
	/zT+9K3aQu6gdQRm6FGcAaL/XbCs0GY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-333-Wb2UiEeyO8-gPweItOjSJg-1; Sat,
 12 Oct 2024 04:53:52 -0400
X-MC-Unique: Wb2UiEeyO8-gPweItOjSJg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A72319560AD;
	Sat, 12 Oct 2024 08:53:51 +0000 (UTC)
Received: from localhost (unknown [10.72.116.121])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3B3F31956089;
	Sat, 12 Oct 2024 08:53:49 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V7 3/7] io_uring: add helper of io_req_commit_cqe()
Date: Sat, 12 Oct 2024 16:53:23 +0800
Message-ID: <20241012085330.2540955-4-ming.lei@redhat.com>
In-Reply-To: <20241012085330.2540955-1-ming.lei@redhat.com>
References: <20241012085330.2540955-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Add helper of io_req_commit_cqe() for simplifying
__io_submit_flush_completions() a bit.

No functional change, and the added helper will be reused in sqe group
code with same lock rule.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/io_uring.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a8a112078584..da852b4605dd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -887,6 +887,20 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	return posted;
 }
 
+static __always_inline void io_req_commit_cqe(struct io_ring_ctx *ctx,
+		struct io_kiocb *req)
+{
+	if (unlikely(!io_fill_cqe_req(ctx, req))) {
+		if (ctx->lockless_cq) {
+			spin_lock(&ctx->completion_lock);
+			io_req_cqe_overflow(req);
+			spin_unlock(&ctx->completion_lock);
+		} else {
+			io_req_cqe_overflow(req);
+		}
+	}
+}
+
 static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1439,16 +1453,8 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 					    comp_list);
 
-		if (!(req->flags & REQ_F_CQE_SKIP) &&
-		    unlikely(!io_fill_cqe_req(ctx, req))) {
-			if (ctx->lockless_cq) {
-				spin_lock(&ctx->completion_lock);
-				io_req_cqe_overflow(req);
-				spin_unlock(&ctx->completion_lock);
-			} else {
-				io_req_cqe_overflow(req);
-			}
-		}
+		if (!(req->flags & REQ_F_CQE_SKIP))
+			io_req_commit_cqe(ctx, req);
 	}
 	__io_cq_unlock_post(ctx);
 
-- 
2.46.0


