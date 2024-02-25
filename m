Return-Path: <io-uring+bounces-702-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D5C29862897
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 01:39:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B20DB2152D
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 00:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5048EEC2;
	Sun, 25 Feb 2024 00:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DJVPPn6w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AD710E4
	for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 00:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708821590; cv=none; b=ONpnLvuMgEbO5qfQOeWJSWhnvj9Qy2JGazlMFWNu8lw9nDgTgEYC812HjrHxdPviekoRoyk5nflp9LEDk/aRmwGBaPKLFoE9KPfq9QiSTFAfdfEmjXv0NadQVwgGqJn/JIV9vcqWZtPdK0nfUZE4LCCDjfUdfpitmCs0sI/zgIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708821590; c=relaxed/simple;
	bh=fCyD9l12nlVFS0uM8gSt7z43duSz7ZNJ2TW72BvnVw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaSsfds1/L37DXPJwnOmJe/Gz1ULGybiPrfEnI/Oz1UG8XbrcZYMxTh7LrIDTGfmzeM5fBlEeiF432eFliMMj08lqd8WAbdr1pOekzymjWiDyXcCRZ9isTJ9TdNGgtG0YgBsZ3ABV9PVCZjVtfJX3Ud+UReI/eNrVjFlMBMNwT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DJVPPn6w; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5a0dc313058so169537a12.0
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 16:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708821586; x=1709426386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8NMa6cdlS4mwHyd9OSd9n4AxIpngpcBlX+GZ3KJr7wY=;
        b=DJVPPn6wuFHI3Q8+wxj3z5kItw+L1j5PrnxAOUY9Fgif3m1+7YKkjgVojw+GOHUzD8
         jseRdRSfIvNAdDA3cVDVzSmr1x+4d9Bh4NmZbZ2EBVTlrokZG7/rzhy8/II2nW3x36i0
         tSr3n062//FhHOw8PGQwrTA2IXkk0Nr17wuIvmU3N10kfDNMDju5FA+f6Td6kau9UVhX
         A7P50U+qAlGXnq69geIF9Yj7azFRbHMVxOfLINy7gFRe4nDOKdir6YvnjO75dp116vV3
         oSaRXSeId5S/M0MLJ+OCQxxuvv6QytvOcDaSrvToAPgSbvZZOOr/YvQzlnpn+du5c+Ou
         3x7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708821586; x=1709426386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8NMa6cdlS4mwHyd9OSd9n4AxIpngpcBlX+GZ3KJr7wY=;
        b=dPdxfhBJk58ZHAxMgHzSTaDu97ZIkEToYX+vRx627Ro3pKWIZxkUfmEYtcXp0Wasz3
         c5orDJ+cQf0rpL1uDo6+SKhEu3K9ThunSZToCvnNLoDPnGRAfxRyFPUe7g0YHKOW1Eqe
         HNNE5a3YsP2f/j4CozGdw7JgPRxvngVUGBheZKUUKzQVMypU/nkciu/uovFt/+tdELv+
         fGeT8mEyShXrTS+oxckMfPfnJmbThM/+TooHTUUYc3/8jN7NxxrXJPFPRH7ZzTr646lX
         DOSuYlyGVlHw/jku1BXZ9PP2Xm6KJ47vAelgzrENTGZItoJxhRBfK0CsT2NTat2Rc9cj
         2pkQ==
X-Gm-Message-State: AOJu0YxMKwzCNP3EoTcf2ognf+c0GlbT/F+Z3cMI8JStTJPF/UPDxNF9
	ysi8IBZY3Zu1aD4HzgrthLRGUqJbXR9UdjmwNAgEFuaxXCBD+WpNJJ3TGtka7K99MzMbnw1mGXt
	w
X-Google-Smtp-Source: AGHT+IHQL4QDx+B3z1baskFz/sg6EwH689IXC8swsgisY1Hc9dViRb8gAXn6eKTZPjWXnc1iQXBXhQ==
X-Received: by 2002:a05:6a00:1792:b0:6e4:f431:847d with SMTP id s18-20020a056a00179200b006e4f431847dmr4016707pfg.2.1708821586226;
        Sat, 24 Feb 2024 16:39:46 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id u3-20020a62d443000000b006e24991dd5bsm1716170pfl.98.2024.02.24.16.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Feb 2024 16:39:44 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/8] io_uring/net: unify how recvmsg and sendmsg copy in the msghdr
Date: Sat, 24 Feb 2024 17:35:47 -0700
Message-ID: <20240225003941.129030-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240225003941.129030-1-axboe@kernel.dk>
References: <20240225003941.129030-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For recvmsg, we roll our own since we support buffer selections. This
isn't the case for sendmsg right now, but in preparation for doing so,
make the recvmsg copy helpers generic so we can call them from the
sendmsg side as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 275 +++++++++++++++++++++++++------------------------
 1 file changed, 140 insertions(+), 135 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 161622029147..fcbaeb7cc045 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -204,16 +204,148 @@ static int io_setup_async_msg(struct io_kiocb *req,
 	return -EAGAIN;
 }
 
+static bool io_recvmsg_multishot_overflow(struct io_async_msghdr *iomsg)
+{
+	int hdr;
+
+	if (iomsg->namelen < 0)
+		return true;
+	if (check_add_overflow((int)sizeof(struct io_uring_recvmsg_out),
+			       iomsg->namelen, &hdr))
+		return true;
+	if (check_add_overflow(hdr, (int)iomsg->controllen, &hdr))
+		return true;
+
+	return false;
+}
+
+#ifdef CONFIG_COMPAT
+static int __io_compat_msg_copy_hdr(struct io_kiocb *req,
+				    struct io_async_msghdr *iomsg,
+				    struct sockaddr __user **addr, int ddir)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct compat_msghdr msg;
+	struct compat_iovec __user *uiov;
+	int ret;
+
+	if (copy_from_user(&msg, sr->umsg_compat, sizeof(msg)))
+		return -EFAULT;
+
+	ret = __get_compat_msghdr(&iomsg->msg, &msg, addr);
+	if (ret)
+		return ret;
+
+	uiov = compat_ptr(msg.msg_iov);
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		compat_ssize_t clen;
+
+		iomsg->free_iov = NULL;
+		if (msg.msg_iovlen == 0) {
+			sr->len = 0;
+		} else if (msg.msg_iovlen > 1) {
+			return -EINVAL;
+		} else {
+			if (!access_ok(uiov, sizeof(*uiov)))
+				return -EFAULT;
+			if (__get_user(clen, &uiov->iov_len))
+				return -EFAULT;
+			if (clen < 0)
+				return -EINVAL;
+			sr->len = clen;
+		}
+
+		if (ddir == ITER_DEST && req->flags & REQ_F_APOLL_MULTISHOT) {
+			iomsg->namelen = msg.msg_namelen;
+			iomsg->controllen = msg.msg_controllen;
+			if (io_recvmsg_multishot_overflow(iomsg))
+				return -EOVERFLOW;
+		}
+	} else {
+		iomsg->free_iov = iomsg->fast_iov;
+		ret = __import_iovec(ddir, (struct iovec __user *)uiov,
+				     msg.msg_iovlen, UIO_FASTIOV,
+				     &iomsg->free_iov, &iomsg->msg.msg_iter,
+				     true);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+#endif
+
+static int __io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
+			     struct sockaddr __user **addr, int ddir)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct user_msghdr msg;
+	int ret;
+
+	if (copy_from_user(&msg, sr->umsg, sizeof(*sr->umsg)))
+		return -EFAULT;
+
+	ret = __copy_msghdr(&iomsg->msg, &msg, addr);
+	if (ret)
+		return ret;
+
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		if (msg.msg_iovlen == 0) {
+			sr->len = iomsg->fast_iov[0].iov_len = 0;
+			iomsg->fast_iov[0].iov_base = NULL;
+			iomsg->free_iov = NULL;
+		} else if (msg.msg_iovlen > 1) {
+			return -EINVAL;
+		} else {
+			if (copy_from_user(iomsg->fast_iov, msg.msg_iov,
+					   sizeof(*msg.msg_iov)))
+				return -EFAULT;
+			sr->len = iomsg->fast_iov[0].iov_len;
+			iomsg->free_iov = NULL;
+		}
+
+		if (ddir == ITER_DEST && req->flags & REQ_F_APOLL_MULTISHOT) {
+			iomsg->namelen = msg.msg_namelen;
+			iomsg->controllen = msg.msg_controllen;
+			if (io_recvmsg_multishot_overflow(iomsg))
+				return -EOVERFLOW;
+		}
+	} else {
+		iomsg->free_iov = iomsg->fast_iov;
+		ret = __import_iovec(ddir, msg.msg_iov, msg.msg_iovlen,
+				     UIO_FASTIOV, &iomsg->free_iov,
+				     &iomsg->msg.msg_iter, false);
+		if (ret > 0)
+			ret = 0;
+	}
+
+	return ret;
+}
+
+static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
+			   struct sockaddr __user **addr, int ddir)
+{
+	iomsg->msg.msg_name = &iomsg->addr;
+	iomsg->msg.msg_iter.nr_segs = 0;
+
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		return __io_compat_msg_copy_hdr(req, iomsg, addr, ddir);
+#endif
+
+	return __io_msg_copy_hdr(req, iomsg, addr, ddir);
+}
+
 static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 			       struct io_async_msghdr *iomsg)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	int ret;
 
-	iomsg->msg.msg_name = &iomsg->addr;
-	iomsg->free_iov = iomsg->fast_iov;
-	ret = sendmsg_copy_msghdr(&iomsg->msg, sr->umsg, sr->msg_flags,
-					&iomsg->free_iov);
+	ret = io_msg_copy_hdr(req, iomsg, NULL, ITER_SOURCE);
+	if (ret)
+		return ret;
+
 	/* save msg_control as sys_sendmsg() overwrites it */
 	sr->msg_control = iomsg->msg.msg_control_user;
 	return ret;
@@ -435,142 +567,15 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-static bool io_recvmsg_multishot_overflow(struct io_async_msghdr *iomsg)
-{
-	int hdr;
-
-	if (iomsg->namelen < 0)
-		return true;
-	if (check_add_overflow((int)sizeof(struct io_uring_recvmsg_out),
-			       iomsg->namelen, &hdr))
-		return true;
-	if (check_add_overflow(hdr, (int)iomsg->controllen, &hdr))
-		return true;
-
-	return false;
-}
-
-static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
-				 struct io_async_msghdr *iomsg)
-{
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct user_msghdr msg;
-	int ret;
-
-	if (copy_from_user(&msg, sr->umsg, sizeof(*sr->umsg)))
-		return -EFAULT;
-
-	ret = __copy_msghdr(&iomsg->msg, &msg, &iomsg->uaddr);
-	if (ret)
-		return ret;
-
-	if (req->flags & REQ_F_BUFFER_SELECT) {
-		if (msg.msg_iovlen == 0) {
-			sr->len = iomsg->fast_iov[0].iov_len = 0;
-			iomsg->fast_iov[0].iov_base = NULL;
-			iomsg->free_iov = NULL;
-		} else if (msg.msg_iovlen > 1) {
-			return -EINVAL;
-		} else {
-			if (copy_from_user(iomsg->fast_iov, msg.msg_iov, sizeof(*msg.msg_iov)))
-				return -EFAULT;
-			sr->len = iomsg->fast_iov[0].iov_len;
-			iomsg->free_iov = NULL;
-		}
-
-		if (req->flags & REQ_F_APOLL_MULTISHOT) {
-			iomsg->namelen = msg.msg_namelen;
-			iomsg->controllen = msg.msg_controllen;
-			if (io_recvmsg_multishot_overflow(iomsg))
-				return -EOVERFLOW;
-		}
-	} else {
-		iomsg->free_iov = iomsg->fast_iov;
-		ret = __import_iovec(ITER_DEST, msg.msg_iov, msg.msg_iovlen, UIO_FASTIOV,
-				     &iomsg->free_iov, &iomsg->msg.msg_iter,
-				     false);
-		if (ret > 0)
-			ret = 0;
-	}
-
-	return ret;
-}
-
-#ifdef CONFIG_COMPAT
-static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
-					struct io_async_msghdr *iomsg)
-{
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct compat_msghdr msg;
-	struct compat_iovec __user *uiov;
-	int ret;
-
-	if (copy_from_user(&msg, sr->umsg_compat, sizeof(msg)))
-		return -EFAULT;
-
-	ret = __get_compat_msghdr(&iomsg->msg, &msg, &iomsg->uaddr);
-	if (ret)
-		return ret;
-
-	uiov = compat_ptr(msg.msg_iov);
-	if (req->flags & REQ_F_BUFFER_SELECT) {
-		compat_ssize_t clen;
-
-		iomsg->free_iov = NULL;
-		if (msg.msg_iovlen == 0) {
-			sr->len = 0;
-		} else if (msg.msg_iovlen > 1) {
-			return -EINVAL;
-		} else {
-			if (!access_ok(uiov, sizeof(*uiov)))
-				return -EFAULT;
-			if (__get_user(clen, &uiov->iov_len))
-				return -EFAULT;
-			if (clen < 0)
-				return -EINVAL;
-			sr->len = clen;
-		}
-
-		if (req->flags & REQ_F_APOLL_MULTISHOT) {
-			iomsg->namelen = msg.msg_namelen;
-			iomsg->controllen = msg.msg_controllen;
-			if (io_recvmsg_multishot_overflow(iomsg))
-				return -EOVERFLOW;
-		}
-	} else {
-		iomsg->free_iov = iomsg->fast_iov;
-		ret = __import_iovec(ITER_DEST, (struct iovec __user *)uiov, msg.msg_iovlen,
-				   UIO_FASTIOV, &iomsg->free_iov,
-				   &iomsg->msg.msg_iter, true);
-		if (ret < 0)
-			return ret;
-	}
-
-	return 0;
-}
-#endif
-
-static int io_recvmsg_copy_hdr(struct io_kiocb *req,
-			       struct io_async_msghdr *iomsg)
-{
-	iomsg->msg.msg_name = &iomsg->addr;
-	iomsg->msg.msg_iter.nr_segs = 0;
-
-#ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
-		return __io_compat_recvmsg_copy_hdr(req, iomsg);
-#endif
-
-	return __io_recvmsg_copy_hdr(req, iomsg);
-}
-
 int io_recvmsg_prep_async(struct io_kiocb *req)
 {
+	struct io_async_msghdr *iomsg;
 	int ret;
 
 	if (!io_msg_alloc_async_prep(req))
 		return -ENOMEM;
-	ret = io_recvmsg_copy_hdr(req, req->async_data);
+	iomsg = req->async_data;
+	ret = io_msg_copy_hdr(req, iomsg, &iomsg->uaddr, ITER_DEST);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return ret;
@@ -793,7 +798,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (req_has_async_data(req)) {
 		kmsg = req->async_data;
 	} else {
-		ret = io_recvmsg_copy_hdr(req, &iomsg);
+		ret = io_msg_copy_hdr(req, &iomsg, &iomsg.uaddr, ITER_DEST);
 		if (ret)
 			return ret;
 		kmsg = &iomsg;
-- 
2.43.0


