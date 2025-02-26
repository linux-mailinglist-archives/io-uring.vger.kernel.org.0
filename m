Return-Path: <io-uring+bounces-6784-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AEF5AA45D62
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 12:40:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D5C9169554
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 11:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52365215F7F;
	Wed, 26 Feb 2025 11:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZZskVEL4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BF5215F7A
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 11:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740570044; cv=none; b=AFX8NbCaGi+/4Uol0nTcc9eByRi47Md1HI85fzro11OMZmjT04rYAagUu25k0YsozX1ugXAqlnxgp05KryhUuG5ARzOx4e0f5T43Apw2ENvEBXzPF5ukDOYQHHd+TesgBWV8R/FkOLseuO1cIIOa/SB4wajpphIuow6G7aKwZQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740570044; c=relaxed/simple;
	bh=ClYm6cbQqyX0JpAqY8whR/FFUBrkwCmdlj1N+8SItsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwLN4pXKIEae47rtWUHGyZLHZIUBmcOzFIIa5gN9HFxuwRtDD6Y2rMjmjvSSq2ubVVd3QYxqp2H7XJUryRj+6pB+W/PRiUnMrFdelq3fWrgQ58aAv8gh2lCJz6sZ0rrGpAtLm1rgSzVXkyeUOiT8TCRLdPNZsQnQLSkPoznBrjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZZskVEL4; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-abbae92be71so732348166b.2
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 03:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740570039; x=1741174839; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PL5SI83UJTbPXLKlQ3hxjCmTfTXlIzKEVpKcOTSPXkI=;
        b=ZZskVEL4L3T33jsR/Z76zO/RLvi5MOuUCJH+9giC4K0Z2FFwRrhO62AYZ/vc/Jy/9U
         CofBFgUMGs2lWdTVumdSb8KI5twp2+b0GOHTgnr6cf+jbfnvNb1Bx7VhB/FwifFzJfbH
         wPbbf/8JXKnjnpMxD5Qp/kMni+68bhSQE8fKOPwihbUbyIfkd+AQ9iqHLxDBvmYnr0W5
         Jmcro1PB7hTIBomB3x0Eoxw60Uz7fukuD3DOSjYmUjTiUtF6R7GqrDBPDs9rYQ9KrdPj
         kxlhRtOjiCXxDVQeqHn76DwxmgdbJnNxD4sA2hUlzpO0oazvlfc0cp6Xrp9O7gImRQkj
         Y0qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740570039; x=1741174839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PL5SI83UJTbPXLKlQ3hxjCmTfTXlIzKEVpKcOTSPXkI=;
        b=usuUekAM3KdPU2a/CwJ75KBzU/yBFndMOPqCtHm40wzwyijjxTZNIsfGtWAKhc48Zj
         8DiTSHmZ2Ya1bKYW75VKmLtwdyFkuxjVyoTMJ1kcti2hxG5GwiRaHge435ozC8lPX5eR
         1yi4KyiZT/WSLU1phn2KPfpHxfFK/pDows3Ou6APnRArPESbX9MSqKInrwR2/w7P82f8
         rwWjC1P3DML2k/BFx3Yo0mTJ1UNFzgZ8r4iaeqKmpQbXdkwBOqiIPhz5KkQDP9qiheTa
         TF8131XvLJMfRvjFXM0W30pH3JD5YvfcOhXxMKJCGgMb2cXO02/l2oyNclKmXRn/A5rE
         8r1A==
X-Gm-Message-State: AOJu0YwINS9fd9/EJBFbswJk37T5PG1Co4W0fpZ4dj6K8EzuQNJAju7w
	TOfSy0VhTo9eki2I+/Pr2zyaEd6osj8rw7rcgDTnvsoZq5u0HdPZF2/3SA==
X-Gm-Gg: ASbGncvBHJqxgh9KJ9XKdCoBA3qjFf4IpUMXK9VkhhYWhqPfa4xBWFyOY0SNljklzSu
	0fiWDDXmljnfFkxw3YDaUnTTvFa8RcC4KtXRyfWGqwsmhw8Quv3JSTBY8R9Rj30LjJgHBUCfMKR
	NLa+0pqK0ISzmCka0XenCVs8gCIIuaX999oWknopwQCA0zx8dkvFhvdtbm6yrs57jKWb2LnSGFm
	1ZHWcZR7upJr2lO+QF1dXQbZlSO29tcLfUTHpFGIG2x5RhHuQyfUbRYkdJ1/0EdAs42EamQgXej
	U+wm41GpZKOAtilvoPjZBVxQXv/s
X-Google-Smtp-Source: AGHT+IGKCq8m3lak+yXKDeSGpcY5VuJ1aruejcye2OkblPMK330FSDcoAivvX/kQg/swZzBz+PX/ew==
X-Received: by 2002:a05:6402:35d4:b0:5dc:6e27:e6e8 with SMTP id 4fb4d7f45d1cf-5e44a256a84mr16885209a12.24.1740570038907;
        Wed, 26 Feb 2025 03:40:38 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:7b07])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e45b80b935sm2692418a12.41.2025.02.26.03.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 03:40:38 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 4/7] io_uring/net: verify msghdr before copying iovec
Date: Wed, 26 Feb 2025 11:41:18 +0000
Message-ID: <cd35dc1b48d4e6e31f59ae7304c037fbe8a3fd3d.1740569495.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740569495.git.asml.silence@gmail.com>
References: <cover.1740569495.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Normally, net/ would verify msghdr before importing iovec, for example
see copy_msghdr_from_user(), which further assumed by __copy_msghdr()
validating msg->msg_iovlen.

io_uring does it in reverse order, which is fine, but it'll be more
convenient for flip it so that the iovec business is done at the end and
eventually can be nicely pulled out of msghdr parsing section and
thought as a sepaarate step. That also makes structure accesses more
localised, which should be better for caches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 43 ++++++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 67d768e6ecdd..14eeebfd8a5a 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -195,7 +195,8 @@ static inline void io_mshot_prep_retry(struct io_kiocb *req,
 #ifdef CONFIG_COMPAT
 static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 				  struct io_async_msghdr *iomsg,
-				  struct compat_msghdr *msg, int ddir)
+				  struct compat_msghdr *msg, int ddir,
+				  struct sockaddr __user **save_addr)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct compat_iovec __user *uiov;
@@ -213,6 +214,10 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 	if (copy_from_user(msg, sr->umsg_compat, sizeof(*msg)))
 		return -EFAULT;
 
+	ret = __get_compat_msghdr(&iomsg->msg, msg, save_addr);
+	if (ret)
+		return ret;
+
 	uiov = compat_ptr(msg->msg_iov);
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		if (msg->msg_iovlen == 0) {
@@ -262,7 +267,8 @@ static int io_copy_msghdr_from_user(struct user_msghdr *msg,
 }
 
 static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
-			   struct user_msghdr *msg, int ddir)
+			   struct user_msghdr *msg, int ddir,
+			   struct sockaddr __user **save_addr)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct user_msghdr __user *umsg = sr->umsg;
@@ -283,6 +289,10 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 
 	msg->msg_flags = 0;
 
+	ret = __copy_msghdr(&iomsg->msg, msg, save_addr);
+	if (ret)
+		return ret;
+
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		if (msg->msg_iovlen == 0) {
 			sr->len = iov->iov_len = 0;
@@ -322,22 +332,14 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 	if (io_is_compat(req->ctx)) {
 		struct compat_msghdr cmsg;
 
-		ret = io_compat_msg_copy_hdr(req, iomsg, &cmsg, ITER_SOURCE);
-		if (unlikely(ret))
-			return ret;
-
-		ret = __get_compat_msghdr(&iomsg->msg, &cmsg, NULL);
+		ret = io_compat_msg_copy_hdr(req, iomsg, &cmsg, ITER_SOURCE,
+					     NULL);
 		sr->msg_control = iomsg->msg.msg_control_user;
 		return ret;
 	}
 #endif
 
-	ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_SOURCE);
-	if (unlikely(ret))
-		return ret;
-
-	ret = __copy_msghdr(&iomsg->msg, &msg, NULL);
-
+	ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_SOURCE, NULL);
 	/* save msg_control as sys_sendmsg() overwrites it */
 	sr->msg_control = iomsg->msg.msg_control_user;
 	return ret;
@@ -719,27 +721,18 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 	if (io_is_compat(req->ctx)) {
 		struct compat_msghdr cmsg;
 
-		ret = io_compat_msg_copy_hdr(req, iomsg, &cmsg, ITER_DEST);
+		ret = io_compat_msg_copy_hdr(req, iomsg, &cmsg, ITER_DEST,
+					     &iomsg->uaddr);
 		if (unlikely(ret))
 			return ret;
-
-		ret = __get_compat_msghdr(&iomsg->msg, &cmsg, &iomsg->uaddr);
-		if (unlikely(ret))
-			return ret;
-
 		return io_recvmsg_mshot_prep(req, iomsg, cmsg.msg_namelen,
 						cmsg.msg_controllen);
 	}
 #endif
 
-	ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_DEST);
+	ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_DEST, &iomsg->uaddr);
 	if (unlikely(ret))
 		return ret;
-
-	ret = __copy_msghdr(&iomsg->msg, &msg, &iomsg->uaddr);
-	if (unlikely(ret))
-		return ret;
-
 	return io_recvmsg_mshot_prep(req, iomsg, msg.msg_namelen,
 					msg.msg_controllen);
 }
-- 
2.48.1


