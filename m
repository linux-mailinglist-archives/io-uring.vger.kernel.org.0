Return-Path: <io-uring+bounces-1152-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DD96F880908
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 02:23:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43B731F24528
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 01:23:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 923CC1364;
	Wed, 20 Mar 2024 01:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UMzWuVL4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE732582
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 01:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710897794; cv=none; b=sFPfdOmn+xzEiWc2WCgnKYceh6VCYmIQwAiEkCeM+qLMBKh1/+uHDo7PiofUnobL7CHhu8SAbP0Heffx+Ft2H2srPGYlsUZHnv0QZwlEWghCo7w3dOjwLRsl6KWeHYKiv0EivkttxDq5SRk71dZvitSRDj89wj/IdjFecsIdbck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710897794; c=relaxed/simple;
	bh=UIhOmHPdU5wmx5HAhnDwKdfPc0rtoh0ZntsczzeHj5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5jTRB76O96q6L9TP0vj7430tKoNDoicMhTjMXxz8u909bgk/UgHiSxbtWspTIOQCIfTxUZBTD42YOxgiR09R+yWnVTaVHL2J0f4DHoeLnJk0AIr3th+DK12dHnqN/1+2eUCnn/yD5Ow0N03ohUJpuQxbMcaSIS1c+biuYPvnu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UMzWuVL4; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1def81ee762so8810785ad.0
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 18:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710897792; x=1711502592; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ewoOwa6YRNZRmf7sqsHhcXXE2VqnL08XbKy4FXWlxnM=;
        b=UMzWuVL4fg3z0p67lsnSxmpGKgUkGgUpl0Dd9fMfdLCzPBH/0GFHQOPwoO2TSCpjXR
         fgqofZZDqElTY55ymTVQvlofksZ/CWzJZOl39TGLlaV71alLa4Mq1LtnDy74VtFg3Snn
         PiRFvxnGUaQG5/mAw4yHjew+HPp+eyHGpTZ4lflHJj1db05p101m2u2aF6ENYvw/FMJG
         jujh42R9ECVjUDhyR2jvnumbEDvuxETC5+fl74LiWhryAW7FA6ulX9V5PbzD9qc3tr0C
         2w2cyTw2dkrMcXnGEdy66aqGGODyVRwPj4N0ubeHmoveBfZWQf2GkQW6A8nrKJxGQgDT
         SjBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710897792; x=1711502592;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ewoOwa6YRNZRmf7sqsHhcXXE2VqnL08XbKy4FXWlxnM=;
        b=Q0ucV1qxhhz+PR0wv89zC/Y0THq35uf1taN8Kg8IxUB10A20hNXvm0bCMwsgqSeFN3
         E78Yx83X04vLNVebJW5aP1gMGrVC2srl2YmakeP8coH0XBgDi/809CIoTRmRMHOzpsGI
         wfzua8vEwBrkfDl2LP5082UaLS4HvqLcuZ6BLKMV6TAdQB0EKjnd5lJEXRAu8cB8BJBu
         sCeYBl6LDeoHClnsk7B2tzbrRpXco5N6mzpG1SO+55+lq2FckQk2aFJaV3tCJPpEH523
         lrXLbaXUllpMpLCW6rE4oc/GZl4meIjE62a0UXGw9IN+Usxxq5chnvrwUIIZi6QRyV02
         ZjGw==
X-Gm-Message-State: AOJu0Yy7ixte+/dChq6qq/htmtRvTa94/Ap5oam7wjnCDMrDG3EJT14K
	ReMTMJDOoq7A1xlMzTR8VK/NmHgBEG2V3gxjtcbyzuwIvE1CLf3PjsshZ+X3iuYP885wpvzxxRk
	g
X-Google-Smtp-Source: AGHT+IH8n3TjK+qWeEO5mTxlPmSnLTIaCmtaj1U78nc31c6s+8MCOK83yIybLwgmSf/fR+DWxtUTQA==
X-Received: by 2002:a05:6a20:7f8f:b0:1a3:4721:ded3 with SMTP id d15-20020a056a207f8f00b001a34721ded3mr4417282pzj.1.1710897791600;
        Tue, 19 Mar 2024 18:23:11 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v22-20020a634816000000b005dc26144d96sm9618007pga.75.2024.03.19.18.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 18:23:10 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/15] io_uring/net: add iovec recycling
Date: Tue, 19 Mar 2024 19:17:36 -0600
Message-ID: <20240320012251.1120361-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320012251.1120361-1-axboe@kernel.dk>
References: <20240320012251.1120361-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Right now the io_async_msghdr is recycled to avoid the overhead of
allocating+freeing it for every request. But the iovec is not included,
hence that will be allocated and freed for each transfer regardless.
This commit enables recyling of the iovec between io_async_msghdr
recycles. This avoids alloc+free for each one if we use it, and on top
of that, it extends the cache hot nature of msg to the iovec as well.

Enable KASAN for the iovec, if we're recycling it, to provide some extra
protection against it being reused while in the cache.

The io_async_msghdr also shrinks from 376 -> 272 bytes, a 104 byte
saving (or ~28% smaller), as the fast_iovec entry is dropped from 8
entries to a single entry. There's no point keeping a big fast iovec
entry, if we're keeping the iovec around.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 107 +++++++++++++++++++++++++++++++------------------
 io_uring/net.h |   6 ++-
 2 files changed, 74 insertions(+), 39 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 21624b7ead8a..bae8cab08e36 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -115,14 +115,30 @@ static bool io_net_retry(struct socket *sock, int flags)
 	return sock->type == SOCK_STREAM || sock->type == SOCK_SEQPACKET;
 }
 
+static void io_netmsg_iovec_free(struct io_async_msghdr *kmsg)
+{
+	if (kmsg->free_iov) {
+		kfree(kmsg->free_iov);
+		kmsg->free_iov_nr = 0;
+		kmsg->free_iov = NULL;
+	}
+}
+
 static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr *hdr = req->async_data;
 
-	if (!req_has_async_data(req) || issue_flags & IO_URING_F_UNLOCKED)
+	if (!req_has_async_data(req))
 		return;
+	/* can't recycle, ensure we free the iovec if we have one */
+	if (issue_flags & IO_URING_F_UNLOCKED) {
+		io_netmsg_iovec_free(hdr);
+		return;
+	}
 
 	/* Let normal cleanup path reap it if we fail adding to the cache */
+	if (hdr->free_iov)
+		kasan_mempool_poison_object(hdr->free_iov);
 	if (io_alloc_cache_put(&req->ctx->netmsg_cache, &hdr->cache)) {
 		req->async_data = NULL;
 		req->flags &= ~REQ_F_ASYNC_DATA;
@@ -138,14 +154,17 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req)
 	entry = io_alloc_cache_get(&ctx->netmsg_cache);
 	if (entry) {
 		hdr = container_of(entry, struct io_async_msghdr, cache);
-		hdr->free_iov = NULL;
-		req->flags |= REQ_F_ASYNC_DATA;
+		if (hdr->free_iov)
+			kasan_mempool_unpoison_object(hdr->free_iov,
+				hdr->free_iov_nr * sizeof(struct iovec));
+		req->flags |= REQ_F_ASYNC_DATA | REQ_F_NEED_CLEANUP;
 		req->async_data = hdr;
 		return hdr;
 	}
 
 	if (!io_alloc_async_data(req)) {
 		hdr = req->async_data;
+		hdr->free_iov_nr = 0;
 		hdr->free_iov = NULL;
 		return hdr;
 	}
@@ -159,7 +178,8 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct compat_iovec __user *uiov;
-	int ret;
+	struct iovec *iov;
+	int ret, nr_segs;
 
 	if (copy_from_user(msg, sr->umsg_compat, sizeof(*msg)))
 		return -EFAULT;
@@ -168,7 +188,6 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		compat_ssize_t clen;
 
-		iomsg->free_iov = NULL;
 		if (msg->msg_iovlen == 0) {
 			sr->len = 0;
 		} else if (msg->msg_iovlen > 1) {
@@ -186,13 +205,22 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 		return 0;
 	}
 
-	iomsg->free_iov = iomsg->fast_iov;
+	if (iomsg->free_iov) {
+		nr_segs = iomsg->free_iov_nr;
+		iov = iomsg->free_iov;
+	} else {
+		iov = &iomsg->fast_iov;
+		nr_segs = 1;
+	}
 	ret = __import_iovec(ddir, (struct iovec __user *)uiov, msg->msg_iovlen,
-				UIO_FASTIOV, &iomsg->free_iov,
-				&iomsg->msg.msg_iter, true);
+				nr_segs, &iov, &iomsg->msg.msg_iter, true);
 	if (unlikely(ret < 0))
 		return ret;
-
+	if (iov) {
+		iomsg->free_iov_nr = iomsg->msg.msg_iter.nr_segs;
+		kfree(iomsg->free_iov);
+		iomsg->free_iov = iov;
+	}
 	return 0;
 }
 #endif
@@ -201,7 +229,8 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 			   struct user_msghdr *msg, int ddir)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	int ret;
+	struct iovec *iov;
+	int ret, nr_segs;
 
 	if (!user_access_begin(sr->umsg, sizeof(*sr->umsg)))
 		return -EFAULT;
@@ -217,9 +246,8 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		if (msg->msg_iovlen == 0) {
-			sr->len = iomsg->fast_iov[0].iov_len = 0;
-			iomsg->fast_iov[0].iov_base = NULL;
-			iomsg->free_iov = NULL;
+			sr->len = iomsg->fast_iov.iov_len = 0;
+			iomsg->fast_iov.iov_base = NULL;
 		} else if (msg->msg_iovlen > 1) {
 			ret = -EINVAL;
 			goto ua_end;
@@ -227,10 +255,9 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 			/* we only need the length for provided buffers */
 			if (!access_ok(&msg->msg_iov[0].iov_len, sizeof(__kernel_size_t)))
 				goto ua_end;
-			unsafe_get_user(iomsg->fast_iov[0].iov_len,
+			unsafe_get_user(iomsg->fast_iov.iov_len,
 					&msg->msg_iov[0].iov_len, ua_end);
-			sr->len = iomsg->fast_iov[0].iov_len;
-			iomsg->free_iov = NULL;
+			sr->len = iomsg->fast_iov.iov_len;
 		}
 		ret = 0;
 ua_end:
@@ -239,12 +266,22 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 	}
 
 	user_access_end();
-	iomsg->free_iov = iomsg->fast_iov;
-	ret = __import_iovec(ddir, msg->msg_iov, msg->msg_iovlen, UIO_FASTIOV,
-				&iomsg->free_iov, &iomsg->msg.msg_iter, false);
+	if (iomsg->free_iov) {
+		nr_segs = iomsg->free_iov_nr;
+		iov = iomsg->free_iov;
+	} else {
+		iov = &iomsg->fast_iov;
+		nr_segs = 1;
+	}
+	ret = __import_iovec(ddir, msg->msg_iov, msg->msg_iovlen, nr_segs,
+				&iov, &iomsg->msg.msg_iter, false);
 	if (unlikely(ret < 0))
 		return ret;
 
+	if (nr_segs == 1 && iov) {
+		iomsg->free_iov_nr = iomsg->msg.msg_iter.nr_segs;
+		iomsg->free_iov = iov;
+	}
 	return 0;
 }
 
@@ -285,7 +322,7 @@ void io_sendmsg_recvmsg_cleanup(struct io_kiocb *req)
 {
 	struct io_async_msghdr *io = req->async_data;
 
-	kfree(io->free_iov);
+	io_netmsg_iovec_free(io);
 }
 
 static int io_send_setup(struct io_kiocb *req)
@@ -374,9 +411,6 @@ static void io_req_msg_cleanup(struct io_kiocb *req,
 			       unsigned int issue_flags)
 {
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	/* fast path, check for non-NULL to avoid function call */
-	if (kmsg->free_iov)
-		kfree(kmsg->free_iov);
 	io_netmsg_recycle(req, issue_flags);
 }
 
@@ -625,11 +659,6 @@ static inline void io_recv_prep_retry(struct io_kiocb *req,
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
-	if (kmsg->free_iov) {
-		kfree(kmsg->free_iov);
-		kmsg->free_iov = NULL;
-	}
-
 	req->flags &= ~REQ_F_BL_EMPTY;
 	sr->done_io = 0;
 	sr->len = 0; /* get from the provided buffer */
@@ -943,13 +972,13 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 void io_send_zc_cleanup(struct io_kiocb *req)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *io;
 
 	if (req_has_async_data(req)) {
-		io = req->async_data;
+		struct io_async_msghdr *io = req->async_data;
+
 		/* might be ->fast_iov if *msg_copy_hdr failed */
-		if (io->free_iov != io->fast_iov)
-			kfree(io->free_iov);
+		if (io->free_iov != &io->fast_iov)
+			io_netmsg_iovec_free(io);
 	}
 	if (zc->notif) {
 		io_notif_flush(zc->notif);
@@ -1220,11 +1249,6 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -EINTR;
 		req_set_fail(req);
 	}
-	/* fast path, check for non-NULL to avoid function call */
-	if (kmsg->free_iov) {
-		kfree(kmsg->free_iov);
-		kmsg->free_iov = NULL;
-	}
 
 	io_netmsg_recycle(req, issue_flags);
 	if (ret >= 0)
@@ -1482,6 +1506,13 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 
 void io_netmsg_cache_free(struct io_cache_entry *entry)
 {
-	kfree(container_of(entry, struct io_async_msghdr, cache));
+	struct io_async_msghdr *kmsg;
+
+	kmsg = container_of(entry, struct io_async_msghdr, cache);
+	if (kmsg->free_iov)
+		kasan_mempool_unpoison_object(kmsg->free_iov,
+				kmsg->free_iov_nr * sizeof(struct iovec));
+	io_netmsg_iovec_free(kmsg);
+	kfree(kmsg);
 }
 #endif
diff --git a/io_uring/net.h b/io_uring/net.h
index 2713dc90fdd4..783dd601a432 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -8,7 +8,11 @@
 struct io_async_msghdr {
 #if defined(CONFIG_NET)
 	union {
-		struct iovec		fast_iov[UIO_FASTIOV];
+		struct {
+			struct iovec	fast_iov;
+			/* entry size of ->free_iov, if valid */
+			int			free_iov_nr;
+		};
 		struct {
 			__kernel_size_t	controllen;
 			int		namelen;
-- 
2.43.0


