Return-Path: <io-uring+bounces-783-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5770F869F66
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 19:48:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BF681C20DB3
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 18:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79B0C50271;
	Tue, 27 Feb 2024 18:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HqVuyGwu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A0D3C490
	for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 18:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059734; cv=none; b=LheNAWgq2B56n5kQ+1EOBbIvSR7BKkEdd5NJbA46ZqKTc83Hoe/QHdeWO+2nAwlgt4yYsT+lG+XuXLh5gUoaobaGqMbO0SfTUZgn+41K7DzJqYrgxPwzxmSSJdmPG9rK4wwTLLnAhaGcWZ7P3LPKrtKN4A4qsSqtwUtuGM83TU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059734; c=relaxed/simple;
	bh=v/MOVxL3a54yVwITQAeEijTWUodaSkKZDkBo3SyukPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1dV1Ow5GcNgV0dNlmKRhl0mnrrSXrki/mt6UgRch+/YCYliQExkRuoO+y0xU4Z5VjL+RsmA5Oy7NkAQ6Uv2iT917o4KhgxN5umCbsT/lU+Wl8GsrGBv94Whs0o4s2/fK7sGnlVyfP/LwY2ra+3M1s9T6y/IFnbaFVDwTXmfnv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HqVuyGwu; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5cdbc42f5efso1867159a12.0
        for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 10:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709059730; x=1709664530; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+8eN5RWaGQ5r+5Y9kYSI9PfD3TwopXl/tJtVRs3uPa8=;
        b=HqVuyGwubFYjdXUIz4roJaZTg3/u6/5bCIysTQjun4YIgz2SFqYucKPBgrVIYDL5Fv
         a/URMq1sBQbdpwV6hIoded8SOJXqjUFhagQb33zagzj4Wkl5PEn2/3cEfqv0ivO12EPx
         iwGoGe5186E1K80QN3xRt4m5AGjLzAaWktn3TMvvVSXPCzCJwE61hQdjUVv1QS+X2EQ3
         kMgyzki6rSF8ddD4CAIKKhShANTnjV/xwe5ou0IRRatqia7wpT2GYkPlDdtw59CAcf8H
         /i0YVEeM1VoaguIW7pyrjH01RhmGpNlD+y8nYkqh9cg0+KpoaCPxEAvxJHBLZDSSvzz0
         dDXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709059730; x=1709664530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+8eN5RWaGQ5r+5Y9kYSI9PfD3TwopXl/tJtVRs3uPa8=;
        b=BiQue5aVXSqPbSRl5HvqPNGPo/L/SZmTQ9mqGY3N+4DGgebL2ccMtV89F0M30hFGNy
         GLW1/hitZ9rBhjPlAfBo+U/veplOJkJEri2XLynL8y5wJptft5gPMrE+LGX94o6aRY1o
         RgMqTpcMkT+x7xcDcxjLAXccKIalvdb2xnAJR3NRCq6Bhz4+1xOd8n+Z/7XFlpKNWrAQ
         yXjLrRgKVjAf6XJbMNUEtZDI5NjgGNZWTyjCDMFyywUvALqnLLEoOEam/fsKLnQo0i+T
         tOaO+rqnCBKBHR77WUNXiUzWyq/GdKK0URUWlGlwPAxf5eavsuzmuYBS6oy7+rQe2k07
         Tksg==
X-Gm-Message-State: AOJu0Yyh4EYy246apWMgzSyN+U5hS2s8qu/nUO/PXHh7h5HR7pT6zDV/
	yC6QKvRBxCfLePrLHKXBGyJ1w/LSRfvISuuctWAzKuLVxdJo2ls3W5hGErTzdwck06d93bqpeuw
	C
X-Google-Smtp-Source: AGHT+IG03UqI2nf0DIZ6j5a0gdnkJerGiiMA7QTo0LLc+vWBRqHHC56epnBAxEw0qK9SjhOSrsPo/A==
X-Received: by 2002:a05:6a00:9394:b0:6e5:382e:1890 with SMTP id ka20-20020a056a00939400b006e5382e1890mr5118594pfb.1.1709059730518;
        Tue, 27 Feb 2024 10:48:50 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id it2-20020a056a00458200b006e543b59587sm2282119pfb.126.2024.02.27.10.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 10:48:49 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/net: unify how recvmsg and sendmsg copy in the msghdr
Date: Tue, 27 Feb 2024 11:46:30 -0700
Message-ID: <20240227184845.985268-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240227184845.985268-1-axboe@kernel.dk>
References: <20240227184845.985268-1-axboe@kernel.dk>
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
 io_uring/net.c | 271 ++++++++++++++++++++++++++-----------------------
 1 file changed, 142 insertions(+), 129 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 43bc9a5f96f9..8c64e552a00f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -204,16 +204,150 @@ static int io_setup_async_msg(struct io_kiocb *req,
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
+
+		return 0;
+	}
+
+	iomsg->free_iov = iomsg->fast_iov;
+	ret = __import_iovec(ddir, (struct iovec __user *)uiov, msg.msg_iovlen,
+				UIO_FASTIOV, &iomsg->free_iov,
+				&iomsg->msg.msg_iter, true);
+	if (unlikely(ret < 0))
+		return ret;
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
+
+		return 0;
+	}
+
+	iomsg->free_iov = iomsg->fast_iov;
+	ret = __import_iovec(ddir, msg.msg_iov, msg.msg_iovlen, UIO_FASTIOV,
+				&iomsg->free_iov, &iomsg->msg.msg_iter, false);
+	if (unlikely(ret < 0))
+		return ret;
+
+	return 0;
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
@@ -435,142 +569,21 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
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
 static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 			       struct io_async_msghdr *iomsg)
 {
-	iomsg->msg.msg_name = &iomsg->addr;
-	iomsg->msg.msg_iter.nr_segs = 0;
-
-#ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
-		return __io_compat_recvmsg_copy_hdr(req, iomsg);
-#endif
-
-	return __io_recvmsg_copy_hdr(req, iomsg);
+	return io_msg_copy_hdr(req, iomsg, &iomsg->uaddr, ITER_DEST);
 }
 
 int io_recvmsg_prep_async(struct io_kiocb *req)
 {
+	struct io_async_msghdr *iomsg;
 	int ret;
 
 	if (!io_msg_alloc_async_prep(req))
 		return -ENOMEM;
-	ret = io_recvmsg_copy_hdr(req, req->async_data);
+	iomsg = req->async_data;
+	ret = io_recvmsg_copy_hdr(req, iomsg);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return ret;
-- 
2.43.0


