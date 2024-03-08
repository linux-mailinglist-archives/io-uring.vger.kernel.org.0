Return-Path: <io-uring+bounces-866-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0628765CC
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 14:59:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B69B1C217F0
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 13:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2799840870;
	Fri,  8 Mar 2024 13:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d7ddB5mf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D9640861
	for <io-uring@vger.kernel.org>; Fri,  8 Mar 2024 13:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709906333; cv=none; b=fPd6X1ZldVhju63uAR7MDNFNOBhfGah0NyRqqHZ5VA9p0sLOCVeZjgWYbVr6GdnJbLWfpHlYA1XaWZiyAsJZxql1dLimqZt6G43BtwODKKseP3B5uAWeZcuSi7/dlYdoJqFba85AFzRWLt2QlTkQpCMU9DA03bL4o9fkL4A2gjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709906333; c=relaxed/simple;
	bh=khcwLyqqiVRcsZyypFi3ummptCOWvb6cl50HfX4VkXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1jfZUSeXufNt4WYgMQBEX/u8GmY9X1VTctEm2fGgZYsmwLojDtMb0SKnmV+5STcyjV0I0TzYKwyaxFGfAB1N0djEsQM0i/lmYi/9LqlmnqjQXfULnw/0zJbaV3KV+++3kpu4I3RcsMf3CdOpmvS3BxGbsJ3KMDjDHrO4PYxhqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d7ddB5mf; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a44f2d894b7so293957066b.1
        for <io-uring@vger.kernel.org>; Fri, 08 Mar 2024 05:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709906329; x=1710511129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RwlLkpRFPLsQAbqtFkO6qlmsxqFQ5iPS8mUmYKIoc9k=;
        b=d7ddB5mfsqNb+FS14dErEK49mFbW4oZEgpAzYZ7oSFzwzh34D5UMcGgGubyzivvg42
         uDnTn3RH5c2sedJFHP9CiMOfKEqREVhp3BDPoABa8bAhZWiuQ9lldHwdA1uiNhVlsIXy
         GOsvq1NTPgZ7VUKTEjXelOtyvf+dea0Cx8nuaJRhgDoD+YJD7ixPGkBHnl8RV6Myshcw
         XlxD4chGVpgjJL5mx+O0CKaSk7F8LNIfqzqPse5ddkmlI8vf2GOD37AvB/pK8O4XmptV
         Zgt6UBqnfG9+TRdzZRNJEGY7edJWEhbkDLr428eZuLaI3yg2dJsQ/El7OFADsEROYUz2
         4HVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709906329; x=1710511129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RwlLkpRFPLsQAbqtFkO6qlmsxqFQ5iPS8mUmYKIoc9k=;
        b=X4e5oOesKqilfk+SUd7bi7L8B3L3pZuhC4Zh8nDehoJNV9FraDK/1nm7ZfwCpOA+XV
         sj4ogjdmDWRAX8HnEuqPBMl6zOrVG2xMJtriwnhvYb5vbTs+kYQyoVhciQt9N86LGiSS
         b8cmxnYpJpUpBizoD13+en18EkpFkYdRXLguA2wdK8msoYtZDT/UzH0/rLwGzmSyR3rL
         Wc29wIXnxTWAslI+tA5YFmHLxvK8ZjvZlQBdfESrNmAqIa/aYM0hirBvmU/4bHI9BoY0
         /x8n5KtIU2lHb74sjJJZSnQlKrVVjE3UbMw5c68DWY1SuDgw0S8kXjv315+lUfEC1tLX
         CBfA==
X-Gm-Message-State: AOJu0YxUAK8bXAN8ALnSJ0a+JFY01HERJ8deANiNJi+Sx9UsW6zh066t
	UChw/T0jp5PVDFYHl1ILoIW+IdScRhVYSJ0kD5Nulk016iDlmA/d4BD1i5hAkx4=
X-Google-Smtp-Source: AGHT+IH6Z+qu4DmHAVfMnFY5jvZP6EM0hu3R93QO7lpDTNOwQ1ngQq8t43DLJ+5TZs7ZnwuQhpHFYA==
X-Received: by 2002:a17:906:b294:b0:a45:bf15:640b with SMTP id q20-20020a170906b29400b00a45bf15640bmr5071519ejz.70.1709906329247;
        Fri, 08 Mar 2024 05:58:49 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:d306])
        by smtp.gmail.com with ESMTPSA id p16-20020a170906229000b00a442979e5e5sm9303189eja.220.2024.03.08.05.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 05:58:49 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 3/3] io_uring/net: dedup io_recv_finish req completion
Date: Fri,  8 Mar 2024 13:55:58 +0000
Message-ID: <0e338dcb33c88de83809fda021cba9e7c9681620.1709905727.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1709905727.git.asml.silence@gmail.com>
References: <cover.1709905727.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are two block in io_recv_finish() completing the request, which we
can combine and remove jumping.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 14d6bae60747..96808f429b7a 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -685,20 +685,12 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	if (msg->msg_inq && msg->msg_inq != -1)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
-	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
-		io_req_set_res(req, *ret, cflags);
-		*ret = IOU_OK;
-		return true;
-	}
-
-	if (mshot_finished)
-		goto finish;
-
 	/*
 	 * Fill CQE for this receive and see if we should keep trying to
 	 * receive from this socket.
 	 */
-	if (io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
+	if ((req->flags & REQ_F_APOLL_MULTISHOT) && !mshot_finished &&
+	    io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
 				*ret, cflags | IORING_CQE_F_MORE)) {
 		struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 		int mshot_retry_ret = IOU_ISSUE_SKIP_COMPLETE;
@@ -718,8 +710,8 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 			*ret = -EAGAIN;
 		return true;
 	}
-	/* Otherwise stop multishot but use the current result. */
-finish:
+
+	/* Finish the request / stop multishot. */
 	io_req_set_res(req, *ret, cflags);
 
 	if (issue_flags & IO_URING_F_MULTISHOT)
-- 
2.43.0


