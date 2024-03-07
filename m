Return-Path: <io-uring+bounces-860-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3127187586A
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 21:32:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 833FFB23983
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 20:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 114B012FB38;
	Thu,  7 Mar 2024 20:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="x/fu2mBQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE5264CEC
	for <io-uring@vger.kernel.org>; Thu,  7 Mar 2024 20:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709843486; cv=none; b=DdwFLaQJZ3iSr63lCXweAWYhLMdUJRkWBAbsyzyd09JCknkUGrm/u2ywPtmhcNylQq6242mClhIkxHLtng54cXtRvUf3A1qb5OWuolP3SH+SzRtLyYFtKeXh06/dl3DaX4KmYvTnnWB/c4dyQfJXaeV5If9GdKyrEkmJo5ncA9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709843486; c=relaxed/simple;
	bh=qGjoEIIbEt53uegd1JPCjUDPb12JVfDqcK4UZILwJqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkJqoKO8OVkTqKsUf+AZwha9q+J1eIchapj/sjE/x25MnfZqEBKyn2cjIuY14a6BrMF7AEI8i4XNjLKiDbOpSnMklTogT+mNrpT2qtEC/pOCZlzSiuZin+17fPd7t/f7qEF5SAmFv1O5LTBLoI+BiK8t6T0VKTHMR9UKOyz42kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=x/fu2mBQ; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so19315039f.0
        for <io-uring@vger.kernel.org>; Thu, 07 Mar 2024 12:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709843483; x=1710448283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VPeh0CbqPDrdMwbZbcHzwzoJ4zR73fb7DgUBw9dW0fU=;
        b=x/fu2mBQRNKE19IXyu/rVsMQhP7POGwWLNs2gmH/2yXYpsI98Lqy5Lo2DRaKTeP1c8
         kelyqa3j0hNQL4JvhRE2cpRNuUWVNPRXZqjRMT7hn4L2RKihpV6VbhEveQlXqrH831ea
         nxoI1bVXcuBRSaanaO5PZtymV9YbfZKWiKAcKOQOhQEvAxMajd5zGOasoOEiIPVKjtIc
         gK5ue2VA76CarSBKOgZGK8M6M1irz8QDD1EJGFw67nwDvkfcHNL9e5/mQsBnnbHs9cL5
         uMDua81w5DoxXzZTnAx8GvDKw0UQXmUvNILHp1iScsra0j+ICdGFRfuEUcxkxPA9xFSI
         M7Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709843483; x=1710448283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VPeh0CbqPDrdMwbZbcHzwzoJ4zR73fb7DgUBw9dW0fU=;
        b=HbRBZDbQVUYbeJxCEVqAojaZmMsMlgRblPNgdGABcCMWMj2ph49m73HoQ78/mrtPhn
         4YOWV4yrKtUanjhlrPtHzUQxtAAw0JTQTIwJ2xScVHdrYcgr2F8gBYY6WRhqdIcWqYYd
         itQqShEGPEJvXrdm1zcxL4S+sRK1i+ugicmwvQ9dJOvSw7HKqx3DFN2VhrQAJF+4tN2a
         HQ4imyHP7ZOpQMowdyfimjdWVd8e/K3NJgiRnp1Y2AYT9yZJEHQhrdtraM+fZbz5alOh
         NdZ5U2ADDtAEU3yLQWHcFZ54lG4/sWLIqf4lS7K/EDeo2F9gfbQL7MAtqVam/R4j+qoj
         4h4Q==
X-Gm-Message-State: AOJu0YwPLR+QFfaDTFLwtD4jpsX1At4y7P0Fuydjnx296X2P5DcDF2HB
	uXIC00UWDrkjElVmUWitvGQWsYnxG/xdw3AtgEitVnhw7iogjvtSnA3RDe2teTzwE+72SEJ0uH1
	7
X-Google-Smtp-Source: AGHT+IE9a2HatPfNa3yv1+gUPtyYY1lQnR8M8/8mhmyGd5dJ62B+/PUWpQ1c7WnyPPPLmdMiIK559A==
X-Received: by 2002:a5d:990c:0:b0:7c8:789b:b3d8 with SMTP id x12-20020a5d990c000000b007c8789bb3d8mr6087228iol.0.1709843482917;
        Thu, 07 Mar 2024 12:31:22 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f1-20020a028481000000b0047469b04c35sm4198921jai.65.2024.03.07.12.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 12:31:21 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring/net: add io_req_msg_cleanup() helper
Date: Thu,  7 Mar 2024 13:30:27 -0700
Message-ID: <20240307203113.575893-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240307203113.575893-1-axboe@kernel.dk>
References: <20240307203113.575893-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the fast inline path, we manually recycle the io_async_msghdr and
free the iovec, and then clear the REQ_F_NEED_CLEANUP flag to avoid
that needing doing in the slower path. We already do that in 2 spots, and
in preparation for adding more, add a helper and use it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index e24baf765c0e..848dc14060b2 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -414,6 +414,17 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+static void io_req_msg_cleanup(struct io_kiocb *req,
+			       struct io_async_msghdr *kmsg,
+			       unsigned int issue_flags)
+{
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	/* fast path, check for non-NULL to avoid function call */
+	if (kmsg->free_iov)
+		kfree(kmsg->free_iov);
+	io_netmsg_recycle(req, issue_flags);
+}
+
 int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
@@ -463,11 +474,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -EINTR;
 		req_set_fail(req);
 	}
-	/* fast path, check for non-NULL to avoid function call */
-	if (kmsg->free_iov)
-		kfree(kmsg->free_iov);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-	io_netmsg_recycle(req, issue_flags);
+	io_req_msg_cleanup(req, kmsg, issue_flags);
 	if (ret >= 0)
 		ret += sr->done_io;
 	else if (sr->done_io)
@@ -927,13 +934,8 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (!io_recv_finish(req, &ret, &kmsg->msg, mshot_finished, issue_flags))
 		goto retry_multishot;
 
-	if (mshot_finished) {
-		/* fast path, check for non-NULL to avoid function call */
-		if (kmsg->free_iov)
-			kfree(kmsg->free_iov);
-		io_netmsg_recycle(req, issue_flags);
-		req->flags &= ~REQ_F_NEED_CLEANUP;
-	}
+	if (mshot_finished)
+		io_req_msg_cleanup(req, kmsg, issue_flags);
 
 	return ret;
 }
-- 
2.43.0


