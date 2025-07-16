Return-Path: <io-uring+bounces-8702-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4910CB07B05
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 18:20:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 805D47B0DF5
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 16:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 182CF2356BD;
	Wed, 16 Jul 2025 16:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BVyLxZd7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512491C6FFD
	for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 16:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752682738; cv=none; b=bNnRSop6UeOMADhw5Wrd6zmYLeBAiqyWgV7H7UMgBuj7yt9Gaz8yZCoOC9aPEe2btI3tROQbXuNnmXAIMLacxQBfRAD3O1ranjxBsZzZ5NLlCB6FM/nNLw23hvWt8/FVY0b/8GOJ0fRZqBQQ+qb3YwWC6QmLo4hN73DX7fK7z5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752682738; c=relaxed/simple;
	bh=HdIr7yfs4WHNxtDlxbegITykuA4ALaFbJrWARXtxinY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RstMbOGwNna8nbHUmB7FDUWLzDt2ZHLCZ7PaQjDPnK8lzPc1mRKDZJpG9mkVfh1NGax2iOXDdWgfY1nAzuamPdOXzUm91OEUtXoIFRBCUrZkyqJ4l+hUFYsY0IDN1W2/fSCAjn/2J6Ruym2sbaCXB4lrRGYe/DlgS58kVdRCSII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BVyLxZd7; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-60c4521ae2cso4091a12.0
        for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 09:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752682734; x=1753287534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6IYVabbtygSAONvA6gXvqXbWLv5NUFjRKze/b9WExBU=;
        b=BVyLxZd7CZl3H8zs6xnJQCAXDQjm/vUE2HvrOw86Eb6iDzmznSwF78sLuxyN/3HMZn
         8FNOjxL6DgNd3pIrr0NaxQ9Sg8S8tu3bm3+RZ0GEQIwWDkGyppDxbMftg3ahPY6XD6MU
         azHdZTk0+g19CQLVZNRz0miRh+JLQvUsV9MUFDODcielJuFcgTUE3qCTQLa3zXEt/gsy
         ttT4SX3y56qmJBczmQ2+T1vg31Lm96VAWItw/72YqUM7IBzEKDH2rtIhAS+5ztGsB8Ht
         sSj6LVpb9duJPo5xjUpnovWlO1ucaXkyIBBVB/hLB0LMEy96n0/ztj+hW4n7c74Ka3Af
         Fq2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752682734; x=1753287534;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6IYVabbtygSAONvA6gXvqXbWLv5NUFjRKze/b9WExBU=;
        b=mjdsgpYFjaJMsWFMSVCmGhKLhEJne3A7CYNg1c+ckPmEIDqqGvqPwDWQM5bAd0k+ju
         5+MGpjAH+z2UkzAusa/RIaAHfAR3GXHrYzQiGMBb0IZkD8asGdhluqr4CQwmbrqwXSy8
         aVhrJ6SqrLhqTRmEbcxRRHY06uFd4F9D1/090+Atn3mQ+uqAdqdc8Ljx4hsOtl3fLp7k
         gFm5hv0INXRfSK/oIjDF+6899eEeNpJQ77XUJ9l+3BA/qVwhUqpbsTDV2+jWkhGOXEg4
         yz7bk8morc6a2Lf/2l9lpWzWDSOfafxWJopjPCEXBGyjR9DSvR+7LpXwuWLE5P3iFcv/
         GynA==
X-Gm-Message-State: AOJu0YwXfs7Dj8OUzE2tgiMPGtx1j3jueMPtG3kyeSA9KfcLZ/Pi/o8y
	npezafJoV1GYDmhGcl3/qHUkXn6ueVDsDSGoTPbR+rPvNUBgQqUa9uzFr8oTyQ==
X-Gm-Gg: ASbGncvO5vDYSdmr2BoHrfGLiqf03Yv/N8FFSQbmyF6/+n8DrfCMwi7h3slrZPuAr7q
	rSx1cPjWn0o86qTYs+V9KebgbgT3QMSd0gZN65zkZ7kAsFXZuZGfbn6llKcnX3ZD/55uCDByp20
	Elp1gEmsLASC5eKFyCSfbzedE/wiqW65Cy7sHlzaqCvkMQRaNq37pgj5OFq4yjn7iXnjILIOVc4
	QOWgWPZBMGqKt7DPpEU9M8P+U3odXn9syxcT84FUZUjaYuWP9+ZDIIy0YI+T8y3Z4jeGE+8ofDr
	hwKi/MFL0rTUY9J0I6oOWgunhUOZQurKyZwmAPwZKxqQpH8HeeG3WWR6lxqsSfUfwlxhRO+nMoO
	8v3X+kwJ0xk5pLMduG+fPW8FDdLyTJO+uxk9jWisxu2mpEMQ=
X-Google-Smtp-Source: AGHT+IHJutk9uNSp8j7RPrCF5TpueXNVqEZ/3KOIOdUa/krbx8A3WPGohVyGLOwR82CwCLQ8oiUecA==
X-Received: by 2002:a17:907:7208:b0:ad5:4806:4f07 with SMTP id a640c23a62f3a-ae9c9959ca1mr384007866b.2.1752682734094;
        Wed, 16 Jul 2025 09:18:54 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.211])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e7ee45ebsm1211412266b.43.2025.07.16.09.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 09:18:53 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 1/1] io_uring/poll: fix POLLERR handling
Date: Wed, 16 Jul 2025 17:20:17 +0100
Message-ID: <3dc89036388d602ebd84c28e5042e457bdfc952b.1752682444.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

8c8492ca64e7 ("io_uring/net: don't retry connect operation on EPOLLERR")
is a little dirty hack that
1) wrongfully assumes that POLLERR equals to a failed request, which
breaks all POLLERR users, e.g. all error queue recv interfaces.
2) deviates the connection request behaviour from connect(2), and
3) racy and solved at a wrong level.

Nothing can be done with 2) now, and 3) is beyond the scope of the
patch. At least solve 1) by moving the hack out of generic poll handling
into io_connect().

Cc: stable@vger.kernel.org
Fixes: 8c8492ca64e79 ("io_uring/net: don't retry connect operation on EPOLLERR")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c  | 12 ++++++++----
 io_uring/poll.c |  2 --
 2 files changed, 8 insertions(+), 6 deletions(-)

v2: gate on in_progress
    do sock_error() on EPOLLERR

diff --git a/io_uring/net.c b/io_uring/net.c
index 43a43522f406..bec8c6ed0a93 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1738,9 +1738,11 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
-	if (unlikely(req->flags & REQ_F_FAIL)) {
-		ret = -ECONNRESET;
-		goto out;
+	if (connect->in_progress) {
+		struct poll_table_struct pt = { ._key = EPOLLERR };
+
+		if (vfs_poll(req->file, &pt) & EPOLLERR)
+			goto get_sock_err;
 	}
 
 	file_flags = force_nonblock ? O_NONBLOCK : 0;
@@ -1765,8 +1767,10 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 		 * which means the previous result is good. For both of these,
 		 * grab the sock_error() and use that for the completion.
 		 */
-		if (ret == -EBADFD || ret == -EISCONN)
+		if (ret == -EBADFD || ret == -EISCONN) {
+get_sock_err:
 			ret = sock_error(sock_from_file(req->file)->sk);
+		}
 	}
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0526062e2f81..20e9b46a4adf 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -273,8 +273,6 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 				return IOU_POLL_REISSUE;
 			}
 		}
-		if (unlikely(req->cqe.res & EPOLLERR))
-			req_set_fail(req);
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;
 
-- 
2.49.0


