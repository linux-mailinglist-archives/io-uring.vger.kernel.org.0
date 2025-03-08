Return-Path: <io-uring+bounces-7035-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ECFBA57C43
	for <lists+io-uring@lfdr.de>; Sat,  8 Mar 2025 18:18:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C23E41883366
	for <lists+io-uring@lfdr.de>; Sat,  8 Mar 2025 17:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44D2B1E5215;
	Sat,  8 Mar 2025 17:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZYGQhmKB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6890A190470
	for <io-uring@vger.kernel.org>; Sat,  8 Mar 2025 17:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741454330; cv=none; b=Y95ZKzR0GWNPrrG7VAx2D8g2jVLDnF9hR7qsk1Hr9lkdL5NXZ2ai0XqjPBV8bVxqWGDPrpxK9ivQbvX6jvDEx0tP5ugIlmTo/57HUclBXlnhZxL2t/ZscjVB+wZ/2v+xzshQ/cVqgvMXKlltmSBsnrwC5xkEiVMqSTxEAG6h4dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741454330; c=relaxed/simple;
	bh=3A8Y6YUb7rsSuSmBvvPbmFYnPhoHu03bD2he3yxVf7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t360yzcnatdfQxREAO7GhKTmf6sU2OWaI03N5fivrEE2iQxD2LeeMTSzxaT90PYlkVI/hhx9H3PmmWldS7ncNbHJ+M3DMWOCKq1mQAQacDkKIZZ6LBnBC4ZySrQPIMHbNx6xQ294Yq7ePk5e5X9j4vb1WHh7kJvZieoMvhkMPyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZYGQhmKB; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3912e96c8e8so1525065f8f.2
        for <io-uring@vger.kernel.org>; Sat, 08 Mar 2025 09:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741454326; x=1742059126; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IrfV06AGx1xESncwZXqS4RDr35jlCOstJ8qP3MW0Z4U=;
        b=ZYGQhmKBwzNSiewLl3vQu6WJW8nqCAYLtLSeEyqBt0Y0YFHZr9ZvHnRKaN3MIZs/lZ
         0CDf8wnJZwzCsP0aD2wJxcrqXFvHwfxmOZaEfs4bbtTAGkwRKhDdU9Fv4L58Yuopqp6R
         Hd4H5+10oX9U+lkPNVJv93EIv6EI/4o9kpg2/EdLRkRflCRrsJFnyQFcjaV4hxpZst5j
         fX0h1i1RN5FvR6N3c1xWPlOf8SW+pFF2/COzMJO3g/RcslFCafAYCozJxEqFh525khr5
         UQN1ZxUtpDFUb2G7VR1bRdENQR6uc/0Tno+YNU/fpByXfsqVGHfd39q+AzTicBmnqa+w
         8hPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741454326; x=1742059126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IrfV06AGx1xESncwZXqS4RDr35jlCOstJ8qP3MW0Z4U=;
        b=jMoYdLLQE1yNlhOg737V1jHB9gGBplKANCUqGcrVmtZeV5ZeuVBvpqavScWGXey7v3
         u+IRW0m/R9WKs42u+jNXMF7HGz2aoyhlFLq47ywW2OjFGR/VhaXgoy9qVygp8wqJiSwV
         AKmHFdm2oQM/L9Wy+oPLGsCNCtF9wE2Q/BXybdnJk6HBT3sRZCbi/wxdYXaC2dmz1goJ
         ErHmq2MRuVAoJdKk4ZcxZCpzy7Tkribnib0UX06hi9m6WtI8tDiZa9ffFafH/j4bZ2t7
         rII0t5WX/u+z2tGlvds+X7U730I6XAMRsjw1+tmcMV6Ps/UfXrwDHSDH+IvrxpwUaXqc
         Htew==
X-Gm-Message-State: AOJu0Yyt1hrWi6IBfrSceVJrBHRGKFdGfJHzR7asz3UvURZ2bOMLaCXu
	WsFpygtV3G0yeH3HG6d+DkNFIeBalpajh6jqmW3xyGO3xEZuD87sLUU8CQ==
X-Gm-Gg: ASbGncsjjrx6X2DWyWSEp1No86TC0n08DfJNLAZIoiNT9ZvJsVUoNDGiuskkHITOL4n
	yJZ0t4sJTjwTbJKfvd4rCi3bvAyL77eQC64DI7gHbSY0Ov8jVamOhIqGsnA5Hi2HiCc72Lc3iSY
	u+sp0vV/1NtV/Qw43M1jaM9hMHstW0/abGBBJdKgVheQRyvWym435qSyrghGQogroYG88RaOaRg
	EcO1bxWAHsZldFeibv0x2GnWqtp/7ybXEIsrHPjv4akO8C4zi/PWkCsXwDYt+G97TcsyIHgBuPP
	1IsBCEFiagbwL5OnTA3X8tXXtUWdTJSA8W58KhRocyFv80bKW11z2XZGWw==
X-Google-Smtp-Source: AGHT+IF8kAXBHsTLpHGTl+IXL6I1WMOD7EFYyzfwi5vBpk+hdI5Z/knviphZDMkoVoctn2NmqKtV4Q==
X-Received: by 2002:a5d:5f93:0:b0:391:2e6a:30fe with SMTP id ffacd0b85a97d-39132da07d0mr5482701f8f.39.1741454326252;
        Sat, 08 Mar 2025 09:18:46 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.236.160])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c015c2csm9196679f8f.49.2025.03.08.09.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Mar 2025 09:18:45 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring: unify STOP_MULTISHOT with IOU_OK
Date: Sat,  8 Mar 2025 17:19:33 +0000
Message-ID: <e6a5b2edb0eb9558acb1c8f1db38ac45fee95491.1741453534.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741453534.git.asml.silence@gmail.com>
References: <cover.1741453534.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IOU_OK means that the request ownership is now handed back to core
io_uring and it has to complete it using the result provided in
req->cqe. Same is true for multishot and IOU_STOP_MULTISHOT.

Rename it into IOU_COMPLETE to avoid confusion and use for both modes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  1 -
 io_uring/io_uring.h | 11 +++--------
 io_uring/net.c      | 19 ++++---------------
 io_uring/poll.c     |  2 +-
 io_uring/rw.c       |  4 +---
 5 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6499d8e4d3d0..5ff30a7092ed 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1792,7 +1792,6 @@ int io_poll_issue(struct io_kiocb *req, io_tw_token_t tw)
 	ret = __io_issue_sqe(req, issue_flags, &io_issue_defs[req->opcode]);
 
 	WARN_ON_ONCE(ret == IOU_ISSUE_SKIP_COMPLETE);
-	WARN_ON_ONCE(ret == IOU_OK);
 	return ret;
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 3409740f6417..2308f39ed915 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -19,7 +19,9 @@
 #endif
 
 enum {
-	IOU_OK			= 0,
+	IOU_OK			= 0, /* deprecated, use IOU_COMPLETE */
+	IOU_COMPLETE		= 0,
+
 	IOU_ISSUE_SKIP_COMPLETE	= -EIOCBQUEUED,
 
 	/*
@@ -36,13 +38,6 @@ enum {
 	 * valid error code, yet less than -MAX_ERRNO and valid internally.
 	 */
 	IOU_REQUEUE		= -3072,
-
-	/*
-	 * Intended only when both IO_URING_F_MULTISHOT is passed
-	 * to indicate to the poll runner that multishot should be
-	 * removed and the result is set on req->cqe.res.
-	 */
-	IOU_STOP_MULTISHOT	= -ECANCELED,
 };
 
 struct io_wait_queue {
diff --git a/io_uring/net.c b/io_uring/net.c
index d9befb6fb8a7..9fa5c9570875 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -915,11 +915,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	/* Finish the request / stop multishot. */
 finish:
 	io_req_set_res(req, *ret, cflags);
-
-	if (issue_flags & IO_URING_F_MULTISHOT)
-		*ret = IOU_STOP_MULTISHOT;
-	else
-		*ret = IOU_OK;
+	*ret = IOU_COMPLETE;
 	io_req_msg_cleanup(req, issue_flags);
 	return true;
 }
@@ -1288,9 +1284,7 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 	if (len && zc->len == 0) {
 		io_req_set_res(req, 0, 0);
 
-		if (issue_flags & IO_URING_F_MULTISHOT)
-			return IOU_STOP_MULTISHOT;
-		return IOU_OK;
+		return IOU_COMPLETE;
 	}
 	if (unlikely(ret <= 0) && ret != -EAGAIN) {
 		if (ret == -ERESTARTSYS)
@@ -1300,10 +1294,7 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 
 		req_set_fail(req);
 		io_req_set_res(req, ret, 0);
-
-		if (issue_flags & IO_URING_F_MULTISHOT)
-			return IOU_STOP_MULTISHOT;
-		return IOU_OK;
+		return IOU_COMPLETE;
 	}
 	return IOU_RETRY;
 }
@@ -1709,9 +1700,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, cflags);
 	if (ret < 0)
 		req_set_fail(req);
-	if (!(issue_flags & IO_URING_F_MULTISHOT))
-		return IOU_OK;
-	return IOU_STOP_MULTISHOT;
+	return IOU_COMPLETE;
 }
 
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 52e3c3e923f4..8eb744eb9f4c 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -290,7 +290,7 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 		} else {
 			int ret = io_poll_issue(req, tw);
 
-			if (ret == IOU_STOP_MULTISHOT)
+			if (ret == IOU_COMPLETE)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			else if (ret == IOU_REQUEUE)
 				return IOU_POLL_REQUEUE;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 9a9c636defad..50037313555f 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1104,9 +1104,7 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	io_req_set_res(req, ret, cflags);
 	io_req_rw_cleanup(req, issue_flags);
-	if (issue_flags & IO_URING_F_MULTISHOT)
-		return IOU_STOP_MULTISHOT;
-	return IOU_OK;
+	return IOU_COMPLETE;
 }
 
 static bool io_kiocb_start_write(struct io_kiocb *req, struct kiocb *kiocb)
-- 
2.48.1


