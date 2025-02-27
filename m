Return-Path: <io-uring+bounces-6834-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55066A47EEF
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 14:23:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FA081787E0
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 13:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D6A022F38E;
	Thu, 27 Feb 2025 13:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RjyEevJE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E971922F17B;
	Thu, 27 Feb 2025 13:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740662423; cv=none; b=LbNc3uyOStCpzx/snNz9+nLZy9/TzJ/8BvXtY1j2ovmA4j+SuCqqRpSZzxu5/w1SUEHvhuNN0xDvoCx71CyFkXBW6cxnNg/rRXQUQfbXFri+bCec/NWN7xUsLy5hxAcQCEVYU6T+3svlS7eAXHvVtFNn2wtR1g/YgLUtWwQg8W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740662423; c=relaxed/simple;
	bh=M8PrRnoT4Q0uXpJb8PUVUTxCaP3avGrxW6lnhAqNHLo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=r1t4zhbUKms8CXrqLAue3aaSh8L27/lYAhd8pO4uzhfR00j++6N/qM4woFVfSJ3gRNwvLCjEiXro3ZtFF1OmXSs/tNwOT9Kw47IfexP+Q8Tie/Rb7QOGfRebtSvrgwuMh82wQjngqJ0xfD3n8mXSpxTBdmPBOrdvl3azbqRIUWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RjyEevJE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39B9C4CEDD;
	Thu, 27 Feb 2025 13:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740662422;
	bh=M8PrRnoT4Q0uXpJb8PUVUTxCaP3avGrxW6lnhAqNHLo=;
	h=From:To:Cc:Subject:Date:From;
	b=RjyEevJENsJbXa2vmHV9jQSyrjmk10sk4G40IfuoStOTEE/NWJwbNYNxTn2yqPLlp
	 2QEMetqWuYXBDgydyMKaM8u1LM00KjuXhQYiU9KP5i1kNY07l708ookrb1/iPXL+z3
	 aYrRv4LmQR3RacQvrEwbia43a+1fGep+MgGNXEpsFp7vsn1mYUnlnbWT46abVqTgq+
	 QEw6YfrA0X+UzZHo28xlH6JAtv9knRZ9h1TD2oxAJaeLxKFAPqHdxRaDRQmBEUOjl7
	 twruJrPXGMDFg/2D2+PsnbMHJpTjIMqKxZrfhGxaXhonMldpZqf8e69xLCNp1ZU+VQ
	 RZkDUExpep++g==
From: Arnd Bergmann <arnd@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	David Wei <dw@davidwei.uk>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/net: fix build warning for !CONFIG_COMPAT
Date: Thu, 27 Feb 2025 14:20:09 +0100
Message-Id: <20250227132018.1111094-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

A code rework resulted in an uninitialized return code when COMPAT
mode is disabled:

io_uring/net.c:722:6: error: variable 'ret' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
  722 |         if (io_is_compat(req->ctx)) {
      |             ^~~~~~~~~~~~~~~~~~~~~~
io_uring/net.c:736:15: note: uninitialized use occurs here
  736 |         if (unlikely(ret))
      |                      ^~~

Since io_is_compat() turns into a compile-time 'false', the #ifdef
here is completely unnecessary, and removing it avoids the warning.

Fixes: 685252678757 ("io_uring/net: unify *mshot_prep calls with compat")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 io_uring/net.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index bb454b9f6a4c..33e9be094131 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -224,7 +224,6 @@ static int io_net_import_vec(struct io_kiocb *req, struct io_async_msghdr *iomsg
 	return 0;
 }
 
-#ifdef CONFIG_COMPAT
 static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 				  struct io_async_msghdr *iomsg,
 				  struct compat_msghdr *msg, int ddir,
@@ -263,7 +262,6 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 	return io_net_import_vec(req, iomsg, (struct iovec __user *)uiov,
 				 msg->msg_iovlen, ddir);
 }
-#endif
 
 static int io_copy_msghdr_from_user(struct user_msghdr *msg,
 				    struct user_msghdr __user *umsg)
@@ -330,7 +328,6 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 	iomsg->msg.msg_name = &iomsg->addr;
 	iomsg->msg.msg_iter.nr_segs = 0;
 
-#ifdef CONFIG_COMPAT
 	if (io_is_compat(req->ctx)) {
 		struct compat_msghdr cmsg;
 
@@ -339,7 +336,6 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 		sr->msg_control = iomsg->msg.msg_control_user;
 		return ret;
 	}
-#endif
 
 	ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_SOURCE, NULL);
 	/* save msg_control as sys_sendmsg() overwrites it */
@@ -720,7 +716,6 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 	iomsg->msg.msg_iter.nr_segs = 0;
 
 	if (io_is_compat(req->ctx)) {
-#ifdef CONFIG_COMPAT
 		struct compat_msghdr cmsg;
 
 		ret = io_compat_msg_copy_hdr(req, iomsg, &cmsg, ITER_DEST,
@@ -728,7 +723,6 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 		memset(&msg, 0, sizeof(msg));
 		msg.msg_namelen = cmsg.msg_namelen;
 		msg.msg_controllen = cmsg.msg_controllen;
-#endif
 	} else {
 		ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_DEST, &iomsg->uaddr);
 	}
-- 
2.39.5


