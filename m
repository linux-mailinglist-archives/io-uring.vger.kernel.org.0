Return-Path: <io-uring+bounces-784-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46A54869F67
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 19:48:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 682D91C232DC
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 18:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AFC150A6A;
	Tue, 27 Feb 2024 18:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="khp5BQF4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BDC4E1CF
	for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 18:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059735; cv=none; b=EHXaBAOa9iLVp/XL4assKWNSJreeok+wM9zlCY6YYLIxCiaHnTqo1uqW0SKxeaQwpb/Iakv4Z4sL26DXmobV6dp8lNu/NVkIEXVZX/RYy8j6vZGIdGDuZCWf/4mED6x0I3NtULai7xQoxm/u37Ut79sbn+J2eEr7mR9KANBDwdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059735; c=relaxed/simple;
	bh=PTI7AoBBKPlVbATwuk88n8/DPJn7loFHIpoMPNdnVZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uzbqp+uhUQan2MzFKHhfj5b8XhAML2Ve81ldHtHVA5QwXv3VY3MAJ42RTBTHgHcrPOhOdFQTmky3S87ud21IhM29bCZtBooE02M9IQPh9giP27c0B9FD6nXKVzurq+S4USg4+Zrq1Nq5cDIcvyzRiGyzUTi7NbyCpu1AzR5PIYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=khp5BQF4; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6e2b466d213so1087767a34.0
        for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 10:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709059732; x=1709664532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JAwXJVEwY3pE0HGSRE7b+X6KLN9ymt6KBTvlVLJ9lrg=;
        b=khp5BQF4RNuzhQ79lziUvMaiMCF2aOd9A0QW47Dl5bGLh8L31sxxQO3/rPc9FD66M5
         Ydge8o/1yO0mcNU1xhSDwxUigLtU0twF+Il2CosP2q2uNxgNRH91Rn4yidooA1YQrJCA
         GWPJQWaUjDmCn91khGsuVg9BRf7PPq3UPGIBN2xH82K9aAaYJPjMZsKzeU/Z/lcpHWU8
         MOhIFrh1MEHOb12qHY5dMXRHiRtko8eZTR8MrBC7TNhEbGi5OrYuTLylQot3mErOmxr2
         5hibtwN3Sl/uaIrqd1EkmC6lQC1zZfdTO46lX37ksF+8+cNlGqClBbWFLRu9SjIi2Pya
         3R0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709059732; x=1709664532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JAwXJVEwY3pE0HGSRE7b+X6KLN9ymt6KBTvlVLJ9lrg=;
        b=itxW+mcyoZfs9lU9wMv1IxV8EqeNv2/WdbT9XMsg4B7Qo54VnATAM+BGLasilWvklI
         t5A9RBKZ1bgsEP2+0uYIOyC/qNAbkqpkqoRPUIs5q9/rZNIHUcHA+SaYlnSJcJ8vbXZW
         uipPhUSW/0kM3JyqdKl4UvbMQj0/gLhqSCbjNIsWnG3Bf/KYKLsgywXAWec4qf5z5KZb
         G/+2TVZuI7QcsMQxFw7cBcIM3yvdmQdFIuDEF6rfVPf2ibY2ccWYrjxSfKj2hDDu/rCP
         jLcEJJbNV7NGifxo++9DEq0lO6Xv40P/Bi2G2v+apIiJUOT0J/hOxB1wOpQmAz5nOFXO
         CMwQ==
X-Gm-Message-State: AOJu0Yyy0qM5kM4WOuVYykPZNDmT60Y9nLvaHWupclr+32bQJHjObD1H
	7r+FKX25zebbm1I6pzeZgCpo2yheemwodRXgxyG9H9av0WILQXl1KAsK52RlVB9AtZiDuLBRXNt
	O
X-Google-Smtp-Source: AGHT+IFe1IXNQzuw5caqdR+RfspVKg6bEsMWNeUKIoGTrI56JM8pMRc4Tk6zD5HfdHgtkoGEToPiag==
X-Received: by 2002:a05:6830:14:b0:6e2:ead9:f43d with SMTP id c20-20020a056830001400b006e2ead9f43dmr11726380otp.3.1709059732394;
        Tue, 27 Feb 2024 10:48:52 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id it2-20020a056a00458200b006e543b59587sm2282119pfb.126.2024.02.27.10.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 10:48:51 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/net: move receive multishot out of the generic msghdr path
Date: Tue, 27 Feb 2024 11:46:31 -0700
Message-ID: <20240227184845.985268-3-axboe@kernel.dk>
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

Move the actual user_msghdr / compat_msghdr into the send and receive
sides, respectively, so we can move the uaddr receive handling into its
own handler, and ditto the multishot with buffer selection logic.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 161 ++++++++++++++++++++++++++++---------------------
 1 file changed, 91 insertions(+), 70 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 8c64e552a00f..7a07c5563d66 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -204,46 +204,26 @@ static int io_setup_async_msg(struct io_kiocb *req,
 	return -EAGAIN;
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
 #ifdef CONFIG_COMPAT
-static int __io_compat_msg_copy_hdr(struct io_kiocb *req,
-				    struct io_async_msghdr *iomsg,
-				    struct sockaddr __user **addr, int ddir)
+static int io_compat_msg_copy_hdr(struct io_kiocb *req,
+				  struct io_async_msghdr *iomsg,
+				  struct compat_msghdr *msg, int ddir)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct compat_msghdr msg;
 	struct compat_iovec __user *uiov;
 	int ret;
 
-	if (copy_from_user(&msg, sr->umsg_compat, sizeof(msg)))
+	if (copy_from_user(msg, sr->umsg_compat, sizeof(*msg)))
 		return -EFAULT;
 
-	ret = __get_compat_msghdr(&iomsg->msg, &msg, addr);
-	if (ret)
-		return ret;
-
-	uiov = compat_ptr(msg.msg_iov);
+	uiov = compat_ptr(msg->msg_iov);
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		compat_ssize_t clen;
 
 		iomsg->free_iov = NULL;
-		if (msg.msg_iovlen == 0) {
+		if (msg->msg_iovlen == 0) {
 			sr->len = 0;
-		} else if (msg.msg_iovlen > 1) {
+		} else if (msg->msg_iovlen > 1) {
 			return -EINVAL;
 		} else {
 			if (!access_ok(uiov, sizeof(*uiov)))
@@ -255,18 +235,11 @@ static int __io_compat_msg_copy_hdr(struct io_kiocb *req,
 			sr->len = clen;
 		}
 
-		if (ddir == ITER_DEST && req->flags & REQ_F_APOLL_MULTISHOT) {
-			iomsg->namelen = msg.msg_namelen;
-			iomsg->controllen = msg.msg_controllen;
-			if (io_recvmsg_multishot_overflow(iomsg))
-				return -EOVERFLOW;
-		}
-
 		return 0;
 	}
 
 	iomsg->free_iov = iomsg->fast_iov;
-	ret = __import_iovec(ddir, (struct iovec __user *)uiov, msg.msg_iovlen,
+	ret = __import_iovec(ddir, (struct iovec __user *)uiov, msg->msg_iovlen,
 				UIO_FASTIOV, &iomsg->free_iov,
 				&iomsg->msg.msg_iter, true);
 	if (unlikely(ret < 0))
@@ -276,47 +249,35 @@ static int __io_compat_msg_copy_hdr(struct io_kiocb *req,
 }
 #endif
 
-static int __io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
-			     struct sockaddr __user **addr, int ddir)
+static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
+			   struct user_msghdr *msg, int ddir)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct user_msghdr msg;
 	int ret;
 
-	if (copy_from_user(&msg, sr->umsg, sizeof(*sr->umsg)))
+	if (copy_from_user(msg, sr->umsg, sizeof(*sr->umsg)))
 		return -EFAULT;
 
-	ret = __copy_msghdr(&iomsg->msg, &msg, addr);
-	if (ret)
-		return ret;
-
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		if (msg.msg_iovlen == 0) {
+		if (msg->msg_iovlen == 0) {
 			sr->len = iomsg->fast_iov[0].iov_len = 0;
 			iomsg->fast_iov[0].iov_base = NULL;
 			iomsg->free_iov = NULL;
-		} else if (msg.msg_iovlen > 1) {
+		} else if (msg->msg_iovlen > 1) {
 			return -EINVAL;
 		} else {
-			if (copy_from_user(iomsg->fast_iov, msg.msg_iov,
-					   sizeof(*msg.msg_iov)))
+			if (copy_from_user(iomsg->fast_iov, msg->msg_iov,
+					   sizeof(*msg->msg_iov)))
 				return -EFAULT;
 			sr->len = iomsg->fast_iov[0].iov_len;
 			iomsg->free_iov = NULL;
 		}
 
-		if (ddir == ITER_DEST && req->flags & REQ_F_APOLL_MULTISHOT) {
-			iomsg->namelen = msg.msg_namelen;
-			iomsg->controllen = msg.msg_controllen;
-			if (io_recvmsg_multishot_overflow(iomsg))
-				return -EOVERFLOW;
-		}
-
 		return 0;
 	}
 
 	iomsg->free_iov = iomsg->fast_iov;
-	ret = __import_iovec(ddir, msg.msg_iov, msg.msg_iovlen, UIO_FASTIOV,
+	ret = __import_iovec(ddir, msg->msg_iov, msg->msg_iovlen, UIO_FASTIOV,
 				&iomsg->free_iov, &iomsg->msg.msg_iter, false);
 	if (unlikely(ret < 0))
 		return ret;
@@ -324,30 +285,34 @@ static int __io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg
 	return 0;
 }
 
-static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
-			   struct sockaddr __user **addr, int ddir)
+static int io_sendmsg_copy_hdr(struct io_kiocb *req,
+			       struct io_async_msghdr *iomsg)
 {
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct user_msghdr msg;
+	int ret;
+
 	iomsg->msg.msg_name = &iomsg->addr;
 	iomsg->msg.msg_iter.nr_segs = 0;
 
 #ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
-		return __io_compat_msg_copy_hdr(req, iomsg, addr, ddir);
-#endif
+	if (unlikely(req->ctx->compat)) {
+		struct compat_msghdr cmsg;
 
-	return __io_msg_copy_hdr(req, iomsg, addr, ddir);
-}
+		ret = io_compat_msg_copy_hdr(req, iomsg, &cmsg, ITER_SOURCE);
+		if (unlikely(ret))
+			return ret;
 
-static int io_sendmsg_copy_hdr(struct io_kiocb *req,
-			       struct io_async_msghdr *iomsg)
-{
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	int ret;
+		return __get_compat_msghdr(&iomsg->msg, &cmsg, NULL);
+	}
+#endif
 
-	ret = io_msg_copy_hdr(req, iomsg, NULL, ITER_SOURCE);
-	if (ret)
+	ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_SOURCE);
+	if (unlikely(ret))
 		return ret;
 
+	ret = __copy_msghdr(&iomsg->msg, &msg, NULL);
+
 	/* save msg_control as sys_sendmsg() overwrites it */
 	sr->msg_control = iomsg->msg.msg_control_user;
 	return ret;
@@ -569,10 +534,66 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+static int io_recvmsg_mshot_prep(struct io_kiocb *req,
+				 struct io_async_msghdr *iomsg,
+				 size_t namelen, size_t controllen)
+{
+	if ((req->flags & (REQ_F_APOLL_MULTISHOT|REQ_F_BUFFER_SELECT)) ==
+			  (REQ_F_APOLL_MULTISHOT|REQ_F_BUFFER_SELECT)) {
+		int hdr;
+
+		if (unlikely(namelen < 0))
+			return -EOVERFLOW;
+		if (check_add_overflow((int)sizeof(struct io_uring_recvmsg_out),
+					namelen, &hdr))
+			return -EOVERFLOW;
+		if (check_add_overflow(hdr, (int)controllen, &hdr))
+			return -EOVERFLOW;
+
+		iomsg->namelen = namelen;
+		iomsg->controllen = controllen;
+		return 0;
+	}
+
+	return 0;
+}
+
 static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 			       struct io_async_msghdr *iomsg)
 {
-	return io_msg_copy_hdr(req, iomsg, &iomsg->uaddr, ITER_DEST);
+	struct user_msghdr msg;
+	int ret;
+
+	iomsg->msg.msg_name = &iomsg->addr;
+	iomsg->msg.msg_iter.nr_segs = 0;
+
+#ifdef CONFIG_COMPAT
+	if (unlikely(req->ctx->compat)) {
+		struct compat_msghdr cmsg;
+
+		ret = io_compat_msg_copy_hdr(req, iomsg, &cmsg, ITER_DEST);
+		if (unlikely(ret))
+			return ret;
+
+		ret = __get_compat_msghdr(&iomsg->msg, &cmsg, &iomsg->uaddr);
+		if (unlikely(ret))
+			return ret;
+
+		return io_recvmsg_mshot_prep(req, iomsg, cmsg.msg_namelen,
+						cmsg.msg_controllen);
+	}
+#endif
+
+	ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_DEST);
+	if (unlikely(ret))
+		return ret;
+
+	ret = __copy_msghdr(&iomsg->msg, &msg, &iomsg->uaddr);
+	if (unlikely(ret))
+		return ret;
+
+	return io_recvmsg_mshot_prep(req, iomsg, msg.msg_namelen,
+					msg.msg_controllen);
 }
 
 int io_recvmsg_prep_async(struct io_kiocb *req)
-- 
2.43.0


