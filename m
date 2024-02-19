Return-Path: <io-uring+bounces-645-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A4C985ADA6
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 22:28:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81FED282B8A
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 21:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 422E32D605;
	Mon, 19 Feb 2024 21:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nAWoIoXt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2CE5025C
	for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 21:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708378079; cv=none; b=jYGQJonwcK7Sq7SJFAZ8XPirT04fjyMjD23Z5csuYa9eO6EZV7oaRsCEASJZP1BpWCU9CrGC+Km6kXHSItUnk6c8tAU7fbfSp1gP8lwROpkcUxxWmhrzbd5uzK6meB+S/m1mZSmeCgjNqonPX2CRJkNUaz3OIDlOf6ojus1ojaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708378079; c=relaxed/simple;
	bh=fCyD9l12nlVFS0uM8gSt7z43duSz7ZNJ2TW72BvnVw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHCL60ax4ZrmVvF2OKTJkdyMVpNap8eIrx6oTs89HvGHv9H/SUKomhV8Z/7edCvJc8e3cJTbG8XGWf9cQ6kSZWZTljJMVK2KZpvWZ+1wiZCuIMyJmGRWMM6L13HrEFB0kHbVvtUc9SKKM7EeYqG7yjf5RHEyfaKzDG+66NF6N1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nAWoIoXt; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6e28029f2b4so36581b3a.1
        for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 13:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708378075; x=1708982875; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8NMa6cdlS4mwHyd9OSd9n4AxIpngpcBlX+GZ3KJr7wY=;
        b=nAWoIoXtrgGon1i2HeINcdJx+HXsCrwLcRnEyuIriU6W9s3VFVGAbdlbRjva/V29a3
         r5TQ0BS3XMk9t9IkEw7LNkMRP5qm+f36IEx4pf+57Y71o+jVP9FKDw3JWeoLACRLmvJk
         HwStEr5lBBS3Wu+EU8stVLPaV+p61YesO3edEHtWhY6s+mP7TK/2vW123Vwi6D+/syHR
         LqICfY4a3ZhmvAf0nGfD9gfFIqIT0uyvOSgGbPzGJ5H/OXht0ittt+Y0F+9aLZxVVxu8
         EJxnjAzzV+FHgs5/2i61JvHoRJZi+Kd6+JKh1KqkBcEDS2HD/8+ftunpqS5mseqMHLxh
         s0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708378075; x=1708982875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8NMa6cdlS4mwHyd9OSd9n4AxIpngpcBlX+GZ3KJr7wY=;
        b=L1WmxwESP6zN7fBE0FTJAnx84OwayAOotsi6oxlk8u5lwy1o8xHz3JC8CMRY7lsqHq
         uUDxRtBNQ0Y9/0RMVjsEsxkpV1guow1rBk1oA1D+G2XLY/uJFedV3wWT9BYASqFapTeJ
         q3VFd4ojJYdx+YhFNWJEzXZrrUlA0mS6FEJr0iNeRmuCZp+1fVeBV3zVLP25QfOgfK5W
         zrtWPCy5NOqAc/50A0fALGITIHAaVSGaomJMyEVg02VH7yttk26bPGCU1OUJ5MG5kMrK
         N894BlzyEU2c96TDtSq1Tdy593LdzlQAoXG14jH3LV0LQbo8/QzMqUVcAavQmc+8B8aj
         UO9A==
X-Gm-Message-State: AOJu0Yxm0KH7W7Gz5wT/4VcEnQP8USfL30flHAnJNBl9eXks3Vlhcwsd
	IWOHuqN5aAeNEhgDY/G/mSDa9cmPprBetATx8Wnj54/sUkFsC6fRQIOe5RcX0AZ+6xxb7UYX1Xx
	Z
X-Google-Smtp-Source: AGHT+IGYEh7G4dv3ZO160wn6HVKjPzPyUW/WjeizQjIgjGMWwO/YkltLCJTr11Y+7v6IgMH4Wh45Ew==
X-Received: by 2002:a05:6a20:7284:b0:1a0:9121:2227 with SMTP id o4-20020a056a20728400b001a091212227mr10576365pzk.3.1708378074621;
        Mon, 19 Feb 2024 13:27:54 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id q13-20020a056a00088d00b006e05c801748sm5279770pfj.199.2024.02.19.13.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 13:27:54 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/net: unify how recvmsg and sendmsg copy in the msghdr
Date: Mon, 19 Feb 2024 14:25:25 -0700
Message-ID: <20240219212748.3826830-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219212748.3826830-1-axboe@kernel.dk>
References: <20240219212748.3826830-1-axboe@kernel.dk>
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


