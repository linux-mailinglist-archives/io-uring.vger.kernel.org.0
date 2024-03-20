Return-Path: <io-uring+bounces-1170-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B14EC8819B1
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D57E21C211F6
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C0A21E87E;
	Wed, 20 Mar 2024 22:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MmsxXidU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDC885C65
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975492; cv=none; b=mvTnTQ3a/KFj/uQK1tgY7dxQmJGPwwGmN4m+1alQyWxHfDa3vSOh0gJm0PYrTbPFYRn4bnoS1SaccZS3jiBZOILUda9ziDhVnSomaHypbt8AoB4Fox/25RCvN9Q6KH++wnUtMJErbKLXjolrRQJTGK5Tn6fg+McbEfYjpExfnXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975492; c=relaxed/simple;
	bh=10ADhEGQYzZGxcBm42itPVIEZFSx7zgsjWVrLVrInvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKjPSeI2aPHxcq2MAeCXhCPVzhTRJoedrjMkN3XdabnsMcZDgHbwI4HSw3NnPt7UUkF8xD9DADLbUcZ24tTBfZ6xXRtoEaKqYSMEpwPFvERb/ZDGov2OkOAMyVExOvEblK8609C4/0sC3ie2Hb2/dA2AbejTe42V2hkipaUWw1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MmsxXidU; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3667b0bb83eso574555ab.0
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975489; x=1711580289; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gqhXeok8GHYy4naqWFY6Hw4mYOo6VHfgqsHImgSaso0=;
        b=MmsxXidUlkolYTsoAlTZjQDfIpMDqT7PzAo86ugsbefXauMTSh29N+BRBxEZSZV0rg
         PTn6oWhwJ0XW2LS69wM8cHAEfjlRYjH7uZRydoy9aGpigrvqIQFTk2exA7kNlNMU2EI4
         5dBivVMmWcTJp7FKJSGBxeCqHvm9N2OWAgd1ae8rESzmNXj/Rr2ino71CkUNsieYCZCl
         qXVjQs1sATcT4ppbsZBMCu4QgxnAuwQ3HCIEPn6VoYP2g7Y4DJxbOucmAYaY5yVzpbSr
         dFUguc0VCGtdBkTcFxD5TGMRz/yzJAGmjcfnsjf498wt9iGh7B2ipA6TDtUb/RjPrt1L
         c3TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975489; x=1711580289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gqhXeok8GHYy4naqWFY6Hw4mYOo6VHfgqsHImgSaso0=;
        b=LDP0P0WEC0SXlka4v6T2U5c5ADEuavAv2LYGFzfi7Nt+s0DSMNXbAvStYMiZYz/BaZ
         HKiyavuZdIIaRuiRjB84BKIkctx0DbKl9sDGZf3l5VCTGXbAGRa+2X++fev5k3bEXK3L
         OlTvas/5h6+KGDNzXOESvlDZGSI1mYjr8hBCvGX3F/pbgdoyJa25TGjvLrW0JOz4qr8y
         I60qHT8cwT/i0SZeHKT0mz+kjtmfcnuElx+1YIWkd6tHpUi0Kk1eMtcgc+oLOIsecFPL
         1aOPxj67+ygcO6BihEDeGA4jZ6OyYnSz+osVURMbC5FFtwUVt4JRFzQbcsSAriG1zGI3
         eiUg==
X-Gm-Message-State: AOJu0YygV8lxAEug31QXOih8IN09Jpi0833fHSIL/JiRqo557la47aF4
	rLMF4R+NwUjW8d4c9SHoHldedOhJlS8BGgLKkQq/ogrBSRpGl02GpGS9Z621RUBedX3FrNrLdIr
	A
X-Google-Smtp-Source: AGHT+IFpQAYyYUIdWYTx7wRkWEuOyXOBCIQQwx28RlGLvAHSxR5HuQmm0nEPeqybPmZ1Zx+j1eELVw==
X-Received: by 2002:a5e:a80c:0:b0:7cf:24de:c5f with SMTP id c12-20020a5ea80c000000b007cf24de0c5fmr1835747ioa.1.1710975489139;
        Wed, 20 Mar 2024 15:58:09 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:58:08 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/17] io_uring/net: add iovec recycling
Date: Wed, 20 Mar 2024 16:55:23 -0600
Message-ID: <20240320225750.1769647-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320225750.1769647-1-axboe@kernel.dk>
References: <20240320225750.1769647-1-axboe@kernel.dk>
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

Also enables KASAN for the iovec entries, so that reuse can be detected
even while they are in the cache.

The io_async_msghdr also shrinks from 376 -> 288 bytes, an 88 byte
saving (or ~23% smaller), as the fast_iovec entry is dropped from 8
entries to a single entry. There's no point keeping a big fast iovec
entry, if we're not allocating and freeing new iovecs all the time.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 133 ++++++++++++++++++++++++++++++++-----------------
 io_uring/net.h |  13 ++---
 2 files changed, 93 insertions(+), 53 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 6b45311dcc08..20d6427f4250 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -115,15 +115,33 @@ static bool io_net_retry(struct socket *sock, int flags)
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
+	struct iovec *iov;
 
-	if (!req_has_async_data(req) || issue_flags & IO_URING_F_UNLOCKED)
+	if (!req_has_async_data(req))
+		return;
+	/* can't recycle, ensure we free the iovec if we have one */
+	if (issue_flags & IO_URING_F_UNLOCKED) {
+		io_netmsg_iovec_free(hdr);
 		return;
+	}
 
 	/* Let normal cleanup path reap it if we fail adding to the cache */
+	iov = hdr->free_iov;
 	if (io_alloc_cache_put(&req->ctx->netmsg_cache, &hdr->cache)) {
+		if (iov)
+			kasan_mempool_poison_object(iov);
 		req->async_data = NULL;
 		req->flags &= ~REQ_F_ASYNC_DATA;
 	}
@@ -138,7 +156,11 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req)
 	entry = io_alloc_cache_get(&ctx->netmsg_cache);
 	if (entry) {
 		hdr = container_of(entry, struct io_async_msghdr, cache);
-		hdr->free_iov = NULL;
+		if (hdr->free_iov) {
+			kasan_mempool_unpoison_object(hdr->free_iov,
+				hdr->free_iov_nr * sizeof(struct iovec));
+			req->flags |= REQ_F_NEED_CLEANUP;
+		}
 		req->flags |= REQ_F_ASYNC_DATA;
 		req->async_data = hdr;
 		return hdr;
@@ -146,12 +168,27 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req)
 
 	if (!io_alloc_async_data(req)) {
 		hdr = req->async_data;
+		hdr->free_iov_nr = 0;
 		hdr->free_iov = NULL;
 		return hdr;
 	}
 	return NULL;
 }
 
+/* assign new iovec to kmsg, if we need to */
+static int io_net_vec_assign(struct io_kiocb *req, struct io_async_msghdr *kmsg,
+			     struct iovec *iov)
+{
+	if (iov) {
+		req->flags |= REQ_F_NEED_CLEANUP;
+		kmsg->free_iov_nr = kmsg->msg.msg_iter.nr_segs;
+		if (kmsg->free_iov)
+			kfree(kmsg->free_iov);
+		kmsg->free_iov = iov;
+	}
+	return 0;
+}
+
 #ifdef CONFIG_COMPAT
 static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 				  struct io_async_msghdr *iomsg,
@@ -159,7 +196,16 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct compat_iovec __user *uiov;
-	int ret;
+	struct iovec *iov;
+	int ret, nr_segs;
+
+	if (iomsg->free_iov) {
+		nr_segs = iomsg->free_iov_nr;
+		iov = iomsg->free_iov;
+	} else {
+		iov = &iomsg->fast_iov;
+		nr_segs = 1;
+	}
 
 	if (copy_from_user(msg, sr->umsg_compat, sizeof(*msg)))
 		return -EFAULT;
@@ -168,9 +214,9 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		compat_ssize_t clen;
 
-		iomsg->free_iov = NULL;
 		if (msg->msg_iovlen == 0) {
-			sr->len = 0;
+			sr->len = iov->iov_len = 0;
+			iov->iov_base = NULL;
 		} else if (msg->msg_iovlen > 1) {
 			return -EINVAL;
 		} else {
@@ -186,14 +232,12 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 		return 0;
 	}
 
-	iomsg->free_iov = iomsg->fast_iov;
 	ret = __import_iovec(ddir, (struct iovec __user *)uiov, msg->msg_iovlen,
-				UIO_FASTIOV, &iomsg->free_iov,
-				&iomsg->msg.msg_iter, true);
+				nr_segs, &iov, &iomsg->msg.msg_iter, true);
 	if (unlikely(ret < 0))
 		return ret;
 
-	return 0;
+	return io_net_vec_assign(req, iomsg, iov);
 }
 #endif
 
@@ -201,7 +245,16 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 			   struct user_msghdr *msg, int ddir)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	int ret;
+	struct iovec *iov;
+	int ret, nr_segs;
+
+	if (iomsg->free_iov) {
+		nr_segs = iomsg->free_iov_nr;
+		iov = iomsg->free_iov;
+	} else {
+		iov = &iomsg->fast_iov;
+		nr_segs = 1;
+	}
 
 	if (!user_access_begin(sr->umsg, sizeof(*sr->umsg)))
 		return -EFAULT;
@@ -217,9 +270,8 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		if (msg->msg_iovlen == 0) {
-			sr->len = iomsg->fast_iov[0].iov_len = 0;
-			iomsg->fast_iov[0].iov_base = NULL;
-			iomsg->free_iov = NULL;
+			sr->len = iov->iov_len = 0;
+			iov->iov_base = NULL;
 		} else if (msg->msg_iovlen > 1) {
 			ret = -EINVAL;
 			goto ua_end;
@@ -227,10 +279,9 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 			/* we only need the length for provided buffers */
 			if (!access_ok(&msg->msg_iov[0].iov_len, sizeof(__kernel_size_t)))
 				goto ua_end;
-			unsafe_get_user(iomsg->fast_iov[0].iov_len,
-					&msg->msg_iov[0].iov_len, ua_end);
-			sr->len = iomsg->fast_iov[0].iov_len;
-			iomsg->free_iov = NULL;
+			unsafe_get_user(iov->iov_len, &msg->msg_iov[0].iov_len,
+					ua_end);
+			sr->len = iov->iov_len;
 		}
 		ret = 0;
 ua_end:
@@ -239,13 +290,12 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 	}
 
 	user_access_end();
-	iomsg->free_iov = iomsg->fast_iov;
-	ret = __import_iovec(ddir, msg->msg_iov, msg->msg_iovlen, UIO_FASTIOV,
-				&iomsg->free_iov, &iomsg->msg.msg_iter, false);
+	ret = __import_iovec(ddir, msg->msg_iov, msg->msg_iovlen, nr_segs,
+				&iov, &iomsg->msg.msg_iter, false);
 	if (unlikely(ret < 0))
 		return ret;
 
-	return 0;
+	return io_net_vec_assign(req, iomsg, iov);
 }
 
 static int io_sendmsg_copy_hdr(struct io_kiocb *req,
@@ -285,7 +335,7 @@ void io_sendmsg_recvmsg_cleanup(struct io_kiocb *req)
 {
 	struct io_async_msghdr *io = req->async_data;
 
-	kfree(io->free_iov);
+	io_netmsg_iovec_free(io);
 }
 
 static int io_send_setup(struct io_kiocb *req)
@@ -369,9 +419,6 @@ static void io_req_msg_cleanup(struct io_kiocb *req,
 			       unsigned int issue_flags)
 {
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	/* fast path, check for non-NULL to avoid function call */
-	if (kmsg->free_iov)
-		kfree(kmsg->free_iov);
 	io_netmsg_recycle(req, issue_flags);
 }
 
@@ -622,11 +669,6 @@ static inline void io_recv_prep_retry(struct io_kiocb *req,
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
@@ -942,14 +984,10 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 void io_send_zc_cleanup(struct io_kiocb *req)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *io;
+	struct io_async_msghdr *io = req->async_data;
 
-	if (req_has_async_data(req)) {
-		io = req->async_data;
-		/* might be ->fast_iov if *msg_copy_hdr failed */
-		if (io->free_iov != io->fast_iov)
-			kfree(io->free_iov);
-	}
+	if (req_has_async_data(req))
+		io_netmsg_iovec_free(io);
 	if (zc->notif) {
 		io_notif_flush(zc->notif);
 		zc->notif = NULL;
@@ -1171,8 +1209,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
 		io_notif_flush(zc->notif);
-		io_netmsg_recycle(req, issue_flags);
-		req->flags &= ~REQ_F_NEED_CLEANUP;
+		io_req_msg_cleanup(req, kmsg, 0);
 	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
 	return IOU_OK;
@@ -1221,13 +1258,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -EINTR;
 		req_set_fail(req);
 	}
-	/* fast path, check for non-NULL to avoid function call */
-	if (kmsg->free_iov) {
-		kfree(kmsg->free_iov);
-		kmsg->free_iov = NULL;
-	}
 
-	io_netmsg_recycle(req, issue_flags);
 	if (ret >= 0)
 		ret += sr->done_io;
 	else if (sr->done_io)
@@ -1239,7 +1270,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
 		io_notif_flush(sr->notif);
-		req->flags &= ~REQ_F_NEED_CLEANUP;
+		io_req_msg_cleanup(req, kmsg, 0);
 	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
 	return IOU_OK;
@@ -1483,6 +1514,14 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 
 void io_netmsg_cache_free(struct io_cache_entry *entry)
 {
-	kfree(container_of(entry, struct io_async_msghdr, cache));
+	struct io_async_msghdr *kmsg;
+
+	kmsg = container_of(entry, struct io_async_msghdr, cache);
+	if (kmsg->free_iov) {
+		kasan_mempool_unpoison_object(kmsg->free_iov,
+				kmsg->free_iov_nr * sizeof(struct iovec));
+		io_netmsg_iovec_free(kmsg);
+	}
+	kfree(kmsg);
 }
 #endif
diff --git a/io_uring/net.h b/io_uring/net.h
index f99ebb9dc0bb..0aef1c992aee 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -8,17 +8,18 @@
 struct io_async_msghdr {
 #if defined(CONFIG_NET)
 	union {
-		struct iovec		fast_iov[UIO_FASTIOV];
+		struct iovec			fast_iov;
 		struct {
-			struct iovec	fast_iov_one;
-			__kernel_size_t	controllen;
-			int		namelen;
-			__kernel_size_t	payloadlen;
+			struct io_cache_entry	cache;
+			/* entry size of ->free_iov, if valid */
+			int			free_iov_nr;
 		};
-		struct io_cache_entry	cache;
 	};
 	/* points to an allocated iov, if NULL we use fast_iov instead */
 	struct iovec			*free_iov;
+	__kernel_size_t			controllen;
+	__kernel_size_t			payloadlen;
+	int				namelen;
 	struct sockaddr __user		*uaddr;
 	struct msghdr			msg;
 	struct sockaddr_storage		addr;
-- 
2.43.0


