Return-Path: <io-uring+bounces-764-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A9AF8680F2
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 20:25:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86FD21F2C313
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 19:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA8C12FB2A;
	Mon, 26 Feb 2024 19:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tSUbtsDA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639BA12FF9C
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 19:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708975524; cv=none; b=i2pTiY7C28Vthc4fBvSfHBYd3NmosFXo9iYb4m1VsTR/WtE+v5+ZSA/lXDxmrx+rLtSNxmrjc62BsMUw9rYLovsJRK/VoeCFjNwUMd4cSMFh53nFI7ZJixSdUIgKMPNSUJ8PYHixtsLkvP+TzAK8O/PqfixKz+pFvm0fTMOWbBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708975524; c=relaxed/simple;
	bh=X5JjzQ1BeSKFM9aA0ELmTfsofFkg93zHq7aQu3afbI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXWBheUOSMfrphqt7BnLQaiXWeluQeexS+hwfIohKlMVVN1GjWzm0bfJiwVAB4u4zYM7O9phzXFmrLfqbtHDVB0hcY3dKKfBGfeIovGvUOYi86oOLJUk62DvGQOYbIfbJFAGDpAF4HgUIBRNdKO1QCXyaDV+AjREhQaojqnwUEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tSUbtsDA; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7c45829f3b6so27408039f.1
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 11:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708975521; x=1709580321; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A+1BT2SbKbFe4m/gssB3A8RiJ133+OKSUxeeTv8Ok8s=;
        b=tSUbtsDA2xk1SCX1FOnFqHB2TA6WiPgwVywPxwogVTcVO7TP398V5DUHGQauyXDMR7
         NlyefhwMk1gjfc6Bmb/pw8q2cORk09d+Mwv7ApBRrojREww7wevMrE2h98w14eCSyYVS
         42WhmN3eQzzg+U+qumHqF/4TyjZYif1khV4fpqEJ/xHr1oM5yWLq5uZsXSkZG9xLB3Jl
         Hji2LwS+IjJxy8xYxJhF41Gr6o23ysL/lLL2kTkTuomMLX1aketVDWC/nJvUSZ3sHuv/
         BaS8X0h9QePGgq5oQcKRFL1NGQ1HGoq+abEtHq28bErvu/T5xuns+nAyj3i4Ic8e1hzd
         CbTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708975521; x=1709580321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A+1BT2SbKbFe4m/gssB3A8RiJ133+OKSUxeeTv8Ok8s=;
        b=BZLYfgHT6kRBDhtHkUJYaFwmAMbcdqtT86QnI0igb0jebFzyjEwCXTeaPwhM6eket3
         opMyyeGnfgrurlQe7umT5S086zSBC7cktSq4rzk98I4uuUEnqYhqgeumKW532lKQldgF
         mB0omlOwQ5E4IRO6umfmzuPhC2XUC6thmxo84M8SyznDQL1QL0ysuxUwZZA27eeWI4oL
         Awy862aNbGTP625EzgertxO9jot81ki/BnecHQScW7TlC35xIgciqG2QAD1ZeY8TITA+
         F98iodvZZO7irfY44Axu3JKefXW4nj3sF8JXsNpxZp1TUnAC0VDokx9Vu7Y/ovngTm4M
         5o7w==
X-Gm-Message-State: AOJu0YxW/OMzBQfY41m0oLJ2W/vIhPOs15Y4iTKQrIWHEDyhNQOKRJ4x
	yQjfhGFITKD8P656uGuFpxnIsbhl4M/pM1nD/35RqtYPsLUVG3E6H+zu2Vr1ClLxTlET8LsCUq7
	C
X-Google-Smtp-Source: AGHT+IGcGo0MYMOKGLfQ8uEkK7Vnm59uuAOtKzYjrWeQIPQkCMiiRPv6yth/BfLUB5zxQaRiXBuzvg==
X-Received: by 2002:a6b:da17:0:b0:7c7:a02d:f102 with SMTP id x23-20020a6bda17000000b007c7a02df102mr7466195iob.0.1708975521016;
        Mon, 26 Feb 2024 11:25:21 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id eh3-20020a056638298300b0047466fd3b1dsm1370484jab.22.2024.02.26.11.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 11:25:19 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 9/9] io_uring/net: support multishot for sendmsg
Date: Mon, 26 Feb 2024 12:21:21 -0700
Message-ID: <20240226192458.396832-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240226192458.396832-1-axboe@kernel.dk>
References: <20240226192458.396832-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Same as the IORING_OP_SEND multishot mode. Needs further work, but it's
functional and can be tested.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 47 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 0b990df04ac7..c9d9dc611087 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -492,7 +492,6 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
-	unsigned int cflags;
 	unsigned flags;
 	int min_ret = 0;
 	int ret;
@@ -515,6 +514,14 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return io_setup_async_msg(req, kmsg, issue_flags);
 
+	if (!io_check_multishot(req, issue_flags))
+		return io_setup_async_msg(req, kmsg, issue_flags);
+
+	flags = sr->msg_flags;
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+
+retry_multishot:
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
 		size_t len = sr->len;
@@ -526,17 +533,25 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		iov_iter_ubuf(&kmsg->msg.msg_iter, ITER_SOURCE, buf, len);
 	}
 
-	flags = sr->msg_flags;
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		flags |= MSG_DONTWAIT;
-	if (flags & MSG_WAITALL)
+	/*
+	 * If MSG_WAITALL is set, or this is a multishot send, then we need
+	 * the full amount. If just multishot is set, if we do a short send
+	 * then we complete the multishot sequence rather than continue on.
+	 */
+	if (flags & MSG_WAITALL || req->flags & REQ_F_APOLL_MULTISHOT)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
 	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
 
 	if (ret < min_ret) {
-		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
-			return io_setup_async_msg(req, kmsg, issue_flags);
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK)) {
+			ret = io_setup_async_msg(req, kmsg, issue_flags);
+			if (ret == -EAGAIN && (issue_flags & IO_URING_F_MULTISHOT)) {
+				io_kbuf_recycle(req, issue_flags);
+				return IOU_ISSUE_SKIP_COMPLETE;
+			}
+			return ret;
+		}
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			kmsg->msg.msg_controllen = 0;
 			kmsg->msg.msg_control = NULL;
@@ -548,18 +563,22 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -EINTR;
 		req_set_fail(req);
 	}
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
+	else
+		io_kbuf_recycle(req, issue_flags);
+
+	if (!io_send_finish(req, &ret, &kmsg->msg, issue_flags))
+		goto retry_multishot;
+
 	/* fast path, check for non-NULL to avoid function call */
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_netmsg_recycle(req, issue_flags);
-	if (ret >= 0)
-		ret += sr->done_io;
-	else if (sr->done_io)
-		ret = sr->done_io;
-	cflags = io_put_kbuf(req, issue_flags);
-	io_req_set_res(req, ret, cflags);
-	return IOU_OK;
+	return ret;
 }
 
 int io_send(struct io_kiocb *req, unsigned int issue_flags)
-- 
2.43.0


