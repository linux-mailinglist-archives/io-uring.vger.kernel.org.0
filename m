Return-Path: <io-uring+bounces-9144-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E8FB2EB1B
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 04:08:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5B41567664
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 02:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A0722D8DB9;
	Thu, 21 Aug 2025 02:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oStKyugL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B441A194124
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 02:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755742127; cv=none; b=oOhkkqpjk6/3d9dshdJxI5Pm+KeHbatWbLTTWj8KAMwGJ3YLBTLnf/k1ecV9h2QVye9QsfVzzyUcJmt8aMePLN6DH0B/9bhYC9pFobfxlmMzSmERfEbV6XbKB0g80GVaK4gwOMvJv6lRMlG8VriOtnVMtLxCt+L7yFGq1TR0oFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755742127; c=relaxed/simple;
	bh=9WPaLLvf+gMi2qW2s+chLM8BogNAddc9QDNTp7oTorg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwJ9dx3bE8BvNxVejVIQHsL55Wq1YWYaEZKcSjEN6i2HbtY42wNO//KXEneq1cL97Bo1H1QIsS9cGw7yiwaauwJuV9wPrsPX5EM1eEk+prRZEznPeAFUV+iDSCRRaDdM3kBLzGbwhEP4pRty8jC02wLNoI5TY5FWpm3As3wB+rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oStKyugL; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-32326e67c95so585693a91.3
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755742124; x=1756346924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BKg4wpEye3gMUrAEkhlUvmlCxPR0bdwX6fqLD2hVM6M=;
        b=oStKyugLDi/cAldeGJnVpbwIKSg2r91M60TBCj3nSXUkhjeIgFV+Olw/1DnelPsgYP
         tsbkK1NXeol7PYDrewUNAvmleAhygKbh9ox6NDOKcGuORUB5ICIOfwF4zO5CGTS0E5ub
         EffSEbQJyoLZj/S2WgIwQKOaD6HERQ9KFtyGjirWCUjf4hCdjy5X8kHwirJSytVI6j8/
         cKZ/XVvilp43n8xKpkFNRvr3xxIFsIuxDErCieXEYrJFk1wZtGmOKz3Ia5twIIt5R76E
         XGzPztgirW2s4nuE1GJv/u5wPaTF+7un3YB/fN7uHHgtqTUIOwQLxoGnLjplHtudVQ18
         U5/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755742124; x=1756346924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BKg4wpEye3gMUrAEkhlUvmlCxPR0bdwX6fqLD2hVM6M=;
        b=tBdr2pJvrjKnBO+ucc49NxjBVxabXLQjTDUQjz4xcokCIAHEdHmjhWD3wAfGzeZMst
         6ltJj22/UtG6HI+qcWdUhfoyMPtTi+gxbZRvb3DxlvoXDEOK/MCWW0XUx/2F2MZv07kl
         JKd6TtdAuTEuoPEvNWCfZMLIK8zuDCmfjYLl85ZOM0RBAy6oGhLPs2J2layArzPhveEL
         5rK93YLHjsa5zZZshUb93NA8Rz74d8sdxsXRlu+UpKKKpANkvyGOXW3EZ2tzbLz6qRfu
         vlptcmUFs7gDNnCxVSquHVyX0pIIbr0PxLEkCDTbiFDLd2uhcry56mFip0rEX8fg669A
         S7uw==
X-Gm-Message-State: AOJu0Yx9FOFnvU2csfApriUdxFzU8pEY26zI2MbUVLOOyiMI9xLY8Qiu
	6sQPA7BG/xMKOB0V+WWIPZgDqiJP/RyWNZSNkXKm7Sl7QhvdpnhxD5V2eEd/42q9fXXe6YyRZGo
	auTTH
X-Gm-Gg: ASbGncvJblSXv9aMilV/xz1sxy31khda9RZnacnFltCYVWQg8cjpNtBxNfGFno4iO4N
	dZOUJ7COiEuxPQgHluTtfdVKBeAUN9x0lvIzWcr8SfZqXkf9hdqSndtcFrFT/AvAz3sc92twCw6
	DDj5AEy9K/wTNQkR/Ov9oI8czJtX9sXNwiTp925WnhvEwwA/OsgqXLQe0mhbrx5LlKT7OPApGBD
	gbOGdsYPSwYIYh2U9tcCYv0yQBxyuQwjlurFNe4uExV6zxXzL0X2AZVLXLGGjFgCro2D1x/mZuL
	gxmQDHtaykOvA1bahPBBZf+qJfJaUOhpPDKTJbA9gmQnNf3YjoocUetMSHau+2jOIQQwlxZlaSs
	A3j6HUKk=
X-Google-Smtp-Source: AGHT+IFLxI0hzT5vMJTfXqFrgZCKY5+i0TqaDYhGJ02lsYcVP3gUU2X2fVpF0OHeWQXgBJYo7bpjuw==
X-Received: by 2002:a17:90b:2890:b0:31f:6f8c:6c92 with SMTP id 98e67ed59e1d1-324ed0829d1mr1046081a91.11.1755742124172;
        Wed, 20 Aug 2025 19:08:44 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324f381812asm104827a91.0.2025.08.20.19.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 19:08:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/12] io_uring/net: use struct io_br_sel->val as the send finish value
Date: Wed, 20 Aug 2025 20:03:38 -0600
Message-ID: <20250821020750.598432-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821020750.598432-2-axboe@kernel.dk>
References: <20250821020750.598432-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently a pointer is passed in to the 'ret' in the send mshot handler,
but since we already have a value field in io_br_sel, just use that.
This is also in preparation for needing to pass in struct io_br_sel
to io_send_finish() anyway.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index a7a4443e3ee7..4eb208d24169 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -503,19 +503,20 @@ static int io_net_kbuf_recyle(struct io_kiocb *req, struct io_buffer_list *bl,
 	return IOU_RETRY;
 }
 
-static inline bool io_send_finish(struct io_kiocb *req, int *ret,
-				  struct io_async_msghdr *kmsg)
+static inline bool io_send_finish(struct io_kiocb *req,
+				  struct io_async_msghdr *kmsg,
+				  struct io_br_sel *sel)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	bool bundle_finished = *ret <= 0;
+	bool bundle_finished = sel->val <= 0;
 	unsigned int cflags;
 
 	if (!(sr->flags & IORING_RECVSEND_BUNDLE)) {
-		cflags = io_put_kbuf(req, *ret, req->buf_list);
+		cflags = io_put_kbuf(req, sel->val, req->buf_list);
 		goto finish;
 	}
 
-	cflags = io_put_kbufs(req, *ret, req->buf_list, io_bundle_nbufs(kmsg, *ret));
+	cflags = io_put_kbufs(req, sel->val, req->buf_list, io_bundle_nbufs(kmsg, sel->val));
 
 	if (bundle_finished || req->flags & REQ_F_BL_EMPTY)
 		goto finish;
@@ -524,15 +525,15 @@ static inline bool io_send_finish(struct io_kiocb *req, int *ret,
 	 * Fill CQE for this receive and see if we should keep trying to
 	 * receive from this socket.
 	 */
-	if (io_req_post_cqe(req, *ret, cflags | IORING_CQE_F_MORE)) {
+	if (io_req_post_cqe(req, sel->val, cflags | IORING_CQE_F_MORE)) {
 		io_mshot_prep_retry(req, kmsg);
 		return false;
 	}
 
 	/* Otherwise stop bundle and use the current result. */
 finish:
-	io_req_set_res(req, *ret, cflags);
-	*ret = IOU_COMPLETE;
+	io_req_set_res(req, sel->val, cflags);
+	sel->val = IOU_COMPLETE;
 	return true;
 }
 
@@ -692,11 +693,12 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	else if (sr->done_io)
 		ret = sr->done_io;
 
-	if (!io_send_finish(req, &ret, kmsg))
+	sel.val = ret;
+	if (!io_send_finish(req, kmsg, &sel))
 		goto retry_bundle;
 
 	io_req_msg_cleanup(req, issue_flags);
-	return ret;
+	return sel.val;
 }
 
 static int io_recvmsg_mshot_prep(struct io_kiocb *req,
-- 
2.50.1


