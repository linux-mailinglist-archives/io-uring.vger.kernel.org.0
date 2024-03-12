Return-Path: <io-uring+bounces-915-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0655C879DD0
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 22:47:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEE31283337
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 21:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 405D0146010;
	Tue, 12 Mar 2024 21:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ZJFdi2Pi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B46F145FF6
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 21:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279889; cv=none; b=KlC7IrkIVyI+D9+hX5D+rQM5DUPO0X7m7jQZE0WDjRK4VIzWh5Wh1Q7C4swJQdJtF1mU+CPepzwLnllPlm5FCQyBHmNstKKdC+4qMgpVttoY1iLUQqTa+/qiN0kHgOO8kOAtL69Zn9oQMuLJ8goTZNN7CSm7dwDkYHroWkIWn8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279889; c=relaxed/simple;
	bh=mNGLbXfa9NPPeS5WlGJbuh8AL62SbdqEzpioONP8Yso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrU/1b2b2AVcxoUWzl1JpR0EG4MsT/lnm/lVeqk5ktFB+Zxux1OpJgcB52IzbSzws7FLfDzes/svMsau/aOcUAvK/X9wzL0fTaG6b5X1kKQgk/pAcfpXRmv/qV6Vkbv4KSCZfQ9/hLAJpBbYGIeExPOh9TyHJHJdmu1cWsyk3IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ZJFdi2Pi; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5dbf7b74402so303760a12.0
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 14:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1710279887; x=1710884687; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TFThT2VJUbNvR7G2lUNJR/GJIbE8IFg24e5r8fNOtpw=;
        b=ZJFdi2PisycqHUUCbcg328CQrV6U/2KLIgqtglTnhTQ+cIMHMfakfp21BpVBvqkVla
         RiIA0RuGfe2ckaU5W64H0jE/tvnJ8BG8UlvzG+sSg2oOVA+3C15c2iOGM9zNsOpAJ9rB
         Trg7EbfDPdbwlm46Pu/fnW1mVo4Jc/wKT6wyj6NeXCVAICtM9WO5IFLsvzd5imAnj/gS
         SVzX1NnF1K2/+Nqn7kIp6iJJIxHPCSrspojcj3TAkd266D0Z3RuWchp6sg/4h1/olBwY
         +PXW7R7tBDxWmVpgrDDOjqddDnY90Sy9xh6WO6p/BnfMN7bj08wJP6PasyfMFBQ61qbn
         X7jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710279887; x=1710884687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TFThT2VJUbNvR7G2lUNJR/GJIbE8IFg24e5r8fNOtpw=;
        b=PGZpvkWyWMdfKOhKH60eQGPATgL+CYT8SGjiCHiotJhtbR/1AciXmrwFbakTIsBVoQ
         WyTb3AcycZvnSHcnxwiuxzAFXOCUXG+5mf0Sg9/8j+ABxIhR8Nk+xof2/a0goRwVs7zC
         bdz5ZP7cgBiSyXII7/4KMNxBIvFf4RsWBSfL58Cv1sPDnuSWaNp30a+YUeKAz6YG18wB
         BTduvj8zc2/3jm87Fp3Cz3YwLh6MJMVDdpgjPTUUUQBCGHMatPqT5MWUie6KmTjWPpsw
         49yZRGSagEOsJCPt/8Lg4WL/01vhgL2zM9V3De460bRUXPOSd8qafA8JdR3D97swn4CL
         uqZw==
X-Gm-Message-State: AOJu0Yx0FIfQWMV/qNJnSI1UhT9BUy/UwPx5i7Cf2IjDYFm/m3AGtCXI
	+9OgotUTlGcGB2xb+5fgjzUa3aQRGjCVYx/Tl4M3JwdODrSoHSSRkFQUkhXuRtSVLRMIY9mTIur
	D
X-Google-Smtp-Source: AGHT+IESt7nl46Cvv4dYfkhvVIiOkCTWusNIK3SZxhfAujk5rj+rp8Fa5tHuY66FpRgY5FFZ4SwdCQ==
X-Received: by 2002:a17:90b:4f83:b0:29c:3d5b:dd42 with SMTP id qe3-20020a17090b4f8300b0029c3d5bdd42mr2472606pjb.3.1710279886631;
        Tue, 12 Mar 2024 14:44:46 -0700 (PDT)
Received: from localhost (fwdproxy-prn-008.fbsv.net. [2a03:2880:ff:8::face:b00c])
        by smtp.gmail.com with ESMTPSA id i6-20020a17090ac40600b0029bafbd1e02sm56018pjt.14.2024.03.12.14.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 14:44:46 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [RFC PATCH v4 13/16] io_uring: add io_recvzc request
Date: Tue, 12 Mar 2024 14:44:27 -0700
Message-ID: <20240312214430.2923019-14-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240312214430.2923019-1-dw@davidwei.uk>
References: <20240312214430.2923019-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an io_uring opcode OP_RECV_ZC for doing ZC reads from a socket that
is set up for ZC Rx. The request reads skbs from a socket. Completions
are posted into the main CQ for each page frag read.

Big CQEs (CQE32) is required as the OP_RECV_ZC specific metadata (ZC
region, offset, len) are stored in the extended 16 bytes as a
struct io_uring_rbuf_cqe.

For now there is no limit as to how much work each OP_RECV_ZC request
does. It will attempt to drain a socket of all available data.

Multishot requests are also supported. The first time an io_recvzc
request completes, EAGAIN is returned which arms an async poll. Then, in
subsequent runs in task work, IOU_ISSUE_SKIP_COMPLETE is returned to
continue async polling.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h |   1 +
 io_uring/io_uring.h           |  10 ++
 io_uring/net.c                |  94 +++++++++++++++++-
 io_uring/opdef.c              |  16 +++
 io_uring/zc_rx.c              | 177 +++++++++++++++++++++++++++++++++-
 io_uring/zc_rx.h              |  11 +++
 6 files changed, 302 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 26e945e6258d..ad2ec60b0390 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -256,6 +256,7 @@ enum io_uring_op {
 	IORING_OP_FUTEX_WAITV,
 	IORING_OP_FIXED_FD_INSTALL,
 	IORING_OP_FTRUNCATE,
+	IORING_OP_RECV_ZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 6426ee382276..cd1b3da96f62 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -180,6 +180,16 @@ static inline bool io_get_cqe(struct io_ring_ctx *ctx, struct io_uring_cqe **ret
 	return io_get_cqe_overflow(ctx, ret, false);
 }
 
+static inline bool io_defer_get_uncommited_cqe(struct io_ring_ctx *ctx,
+					       struct io_uring_cqe **cqe_ret)
+{
+	io_lockdep_assert_cq_locked(ctx);
+
+	ctx->cq_extra++;
+	ctx->submit_state.flush_cqes = true;
+	return io_get_cqe(ctx, cqe_ret);
+}
+
 static __always_inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
 					    struct io_kiocb *req)
 {
diff --git a/io_uring/net.c b/io_uring/net.c
index 1fa7c1fa6b5d..56172335387e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -79,6 +79,12 @@ struct io_sr_msg {
  */
 #define MULTISHOT_MAX_RETRY	32
 
+struct io_recvzc {
+	struct file			*file;
+	unsigned			msg_flags;
+	u16				flags;
+};
+
 static inline bool io_check_multishot(struct io_kiocb *req,
 				      unsigned int issue_flags)
 {
@@ -695,7 +701,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	unsigned int cflags;
 
 	cflags = io_put_kbuf(req, issue_flags);
-	if (msg->msg_inq && msg->msg_inq != -1)
+	if (msg && msg->msg_inq && msg->msg_inq != -1)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
@@ -723,7 +729,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 			goto enobufs;
 
 		/* Known not-empty or unknown state, retry */
-		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq == -1) {
+		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || (msg && msg->msg_inq == -1)) {
 			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
 				return false;
 			/* mshot retries exceeded, force a requeue */
@@ -1034,9 +1040,8 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
-static __maybe_unused
-struct io_zc_rx_ifq *io_zc_verify_sock(struct io_kiocb *req,
-					struct socket *sock)
+static struct io_zc_rx_ifq *io_zc_verify_sock(struct io_kiocb *req,
+					      struct socket *sock)
 {
 	unsigned token = READ_ONCE(sock->zc_rx_idx);
 	unsigned ifq_idx = token >> IO_ZC_IFQ_IDX_OFFSET;
@@ -1053,6 +1058,85 @@ struct io_zc_rx_ifq *io_zc_verify_sock(struct io_kiocb *req,
 	return ifq;
 }
 
+int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
+
+	/* non-iopoll defer_taskrun only */
+	if (!req->ctx->task_complete)
+		return -EINVAL;
+	if (unlikely(sqe->file_index || sqe->addr2))
+		return -EINVAL;
+	if (READ_ONCE(sqe->len) || READ_ONCE(sqe->addr3))
+		return -EINVAL;
+
+	zc->flags = READ_ONCE(sqe->ioprio);
+	zc->msg_flags = READ_ONCE(sqe->msg_flags);
+
+	if (zc->msg_flags)
+		return -EINVAL;
+	if (zc->flags & ~RECVMSG_FLAGS)
+		return -EINVAL;
+	if (zc->flags & IORING_RECV_MULTISHOT)
+		req->flags |= REQ_F_APOLL_MULTISHOT;
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		zc->msg_flags |= MSG_CMSG_COMPAT;
+#endif
+	return 0;
+}
+
+int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
+	struct io_zc_rx_ifq *ifq;
+	struct socket *sock;
+	int ret;
+
+	/*
+	 * We're posting CQEs deeper in the stack, and to avoid taking CQ locks
+	 * we serialise by having only the master thread modifying the CQ with
+	 * DEFER_TASkRUN checked earlier and forbidding executing it from io-wq.
+	 * That's similar to io_check_multishot() for multishot CQEs.
+	 */
+	if (issue_flags & IO_URING_F_IOWQ)
+		return -EAGAIN;
+	if (WARN_ON_ONCE(!(issue_flags & IO_URING_F_NONBLOCK)))
+		return -EAGAIN;
+	if (!(req->flags & REQ_F_POLLED) &&
+	    (zc->flags & IORING_RECVSEND_POLL_FIRST))
+		return -EAGAIN;
+
+	sock = sock_from_file(req->file);
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+	ifq = io_zc_verify_sock(req, sock);
+	if (!ifq)
+		return -EINVAL;
+
+	ret = io_zc_rx_recv(req, ifq, sock, zc->msg_flags | MSG_DONTWAIT);
+	if (unlikely(ret <= 0)) {
+		if (ret == -EAGAIN) {
+			if (issue_flags & IO_URING_F_MULTISHOT)
+				return IOU_ISSUE_SKIP_COMPLETE;
+			return -EAGAIN;
+		}
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+
+		req_set_fail(req);
+		io_req_set_res(req, ret, 0);
+
+		if (issue_flags & IO_URING_F_MULTISHOT)
+			return IOU_STOP_MULTISHOT;
+		return IOU_OK;
+	}
+
+	if (issue_flags & IO_URING_F_MULTISHOT)
+		return IOU_ISSUE_SKIP_COMPLETE;
+	return -EAGAIN;
+}
+
 void io_send_zc_cleanup(struct io_kiocb *req)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 9c080aadc5a6..78ec5197917e 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -36,6 +36,7 @@
 #include "waitid.h"
 #include "futex.h"
 #include "truncate.h"
+#include "zc_rx.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -481,6 +482,18 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_ftruncate_prep,
 		.issue			= io_ftruncate,
 	},
+	[IORING_OP_RECV_ZC] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.ioprio			= 1,
+#if defined(CONFIG_NET)
+		.prep			= io_recvzc_prep,
+		.issue			= io_recvzc,
+#else
+		.prep			= io_eopnotsupp_prep,
+#endif
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -722,6 +735,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_FTRUNCATE] = {
 		.name			= "FTRUNCATE",
 	},
+	[IORING_OP_RECV_ZC] = {
+		.name			= "RECV_ZC",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 4bd27eda4bc9..bb9251111735 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -6,10 +6,12 @@
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
 #include <linux/nospec.h>
+
+#include <net/page_pool/helpers.h>
 #include <net/tcp.h>
 #include <net/af_unix.h>
+
 #include <trace/events/page_pool.h>
-#include <net/page_pool/helpers.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -18,6 +20,12 @@
 #include "zc_rx.h"
 #include "rsrc.h"
 
+struct io_zc_rx_args {
+	struct io_kiocb		*req;
+	struct io_zc_rx_ifq	*ifq;
+	struct socket		*sock;
+};
+
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 
 static int __io_queue_mgmt(struct net_device *dev, struct io_zc_rx_ifq *ifq,
@@ -371,7 +379,7 @@ static inline unsigned io_buf_pgid(struct io_zc_rx_pool *pool,
 	return buf - pool->bufs;
 }
 
-static __maybe_unused void io_zc_rx_get_buf_uref(struct io_zc_rx_buf *buf)
+static void io_zc_rx_get_buf_uref(struct io_zc_rx_buf *buf)
 {
 	atomic_long_add(IO_ZC_RX_UREF, &buf->niov.pp_ref_count);
 }
@@ -640,5 +648,170 @@ const struct memory_provider_ops io_uring_pp_zc_ops = {
 };
 EXPORT_SYMBOL(io_uring_pp_zc_ops);
 
+static bool zc_rx_queue_cqe(struct io_kiocb *req, struct io_zc_rx_buf *buf,
+			   struct io_zc_rx_ifq *ifq, int off, int len)
+{
+	struct io_uring_rbuf_cqe *rcqe;
+	struct io_uring_cqe *cqe;
+
+	if (!io_defer_get_uncommited_cqe(req->ctx, &cqe))
+		return false;
+
+	cqe->user_data = req->cqe.user_data;
+	cqe->res = 0;
+	cqe->flags = IORING_CQE_F_MORE;
+
+	rcqe = (struct io_uring_rbuf_cqe *)(cqe + 1);
+	rcqe->region = 0;
+	rcqe->off = io_buf_pgid(ifq->pool, buf) * PAGE_SIZE + off;
+	rcqe->len = len;
+	memset(rcqe->__pad, 0, sizeof(rcqe->__pad));
+	return true;
+}
+
+static int zc_rx_recv_frag(struct io_kiocb *req, struct io_zc_rx_ifq *ifq,
+			   const skb_frag_t *frag, int off, int len)
+{
+	off += skb_frag_off(frag);
+
+	if (likely(skb_frag_is_net_iov(frag))) {
+		struct io_zc_rx_buf *buf;
+		struct net_iov *niov;
+
+		niov = netmem_to_net_iov(frag->netmem);
+		if (niov->pp->mp_ops != &io_uring_pp_zc_ops ||
+		    niov->pp->mp_priv != ifq)
+			return -EFAULT;
+
+		buf = io_niov_to_buf(niov);
+		if (!zc_rx_queue_cqe(req, buf, ifq, off, len))
+			return -ENOSPC;
+		io_zc_rx_get_buf_uref(buf);
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return len;
+}
+
+static int
+zc_rx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
+	       unsigned int offset, size_t len)
+{
+	struct io_zc_rx_args *args = desc->arg.data;
+	struct io_zc_rx_ifq *ifq = args->ifq;
+	struct io_kiocb *req = args->req;
+	struct sk_buff *frag_iter;
+	unsigned start, start_off;
+	int i, copy, end, off;
+	int ret = 0;
+
+	start = skb_headlen(skb);
+	start_off = offset;
+
+	if (offset < start)
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		const skb_frag_t *frag;
+
+		if (WARN_ON(start > offset + len))
+			return -EFAULT;
+
+		frag = &skb_shinfo(skb)->frags[i];
+		end = start + skb_frag_size(frag);
+
+		if (offset < end) {
+			copy = end - offset;
+			if (copy > len)
+				copy = len;
+
+			off = offset - start;
+			ret = zc_rx_recv_frag(req, ifq, frag, off, copy);
+			if (ret < 0)
+				goto out;
+
+			offset += ret;
+			len -= ret;
+			if (len == 0 || ret != copy)
+				goto out;
+		}
+		start = end;
+	}
+
+	skb_walk_frags(skb, frag_iter) {
+		if (WARN_ON(start > offset + len))
+			return -EFAULT;
+
+		end = start + frag_iter->len;
+		if (offset < end) {
+			copy = end - offset;
+			if (copy > len)
+				copy = len;
+
+			off = offset - start;
+			ret = zc_rx_recv_skb(desc, frag_iter, off, copy);
+			if (ret < 0)
+				goto out;
+
+			offset += ret;
+			len -= ret;
+			if (len == 0 || ret != copy)
+				goto out;
+		}
+		start = end;
+	}
+
+out:
+	if (offset == start_off)
+		return ret;
+	return offset - start_off;
+}
+
+static int io_zc_rx_tcp_recvmsg(struct io_kiocb *req, struct io_zc_rx_ifq *ifq,
+				struct sock *sk, int flags)
+{
+	struct io_zc_rx_args args = {
+		.req = req,
+		.ifq = ifq,
+		.sock = sk->sk_socket,
+	};
+	read_descriptor_t rd_desc = {
+		.count = 1,
+		.arg.data = &args,
+	};
+	int ret;
+
+	lock_sock(sk);
+	ret = tcp_read_sock(sk, &rd_desc, zc_rx_recv_skb);
+	if (ret <= 0) {
+		if (ret < 0 || sock_flag(sk, SOCK_DONE))
+			goto out;
+		if (sk->sk_err)
+			ret = sock_error(sk);
+		else if (sk->sk_shutdown & RCV_SHUTDOWN)
+			goto out;
+		else if (sk->sk_state == TCP_CLOSE)
+			ret = -ENOTCONN;
+		else
+			ret = -EAGAIN;
+	}
+out:
+	release_sock(sk);
+	return ret;
+}
+
+int io_zc_rx_recv(struct io_kiocb *req, struct io_zc_rx_ifq *ifq,
+		  struct socket *sock, unsigned int flags)
+{
+	struct sock *sk = sock->sk;
+	const struct proto *prot = READ_ONCE(sk->sk_prot);
+
+	if (prot->recvmsg != tcp_recvmsg)
+		return -EPROTONOSUPPORT;
+
+	sock_rps_record_flow(sk);
+	return io_zc_rx_tcp_recvmsg(req, ifq, sk, flags);
+}
 
 #endif
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
index c02bf8cabc6c..c14ea3cf544a 100644
--- a/io_uring/zc_rx.h
+++ b/io_uring/zc_rx.h
@@ -50,6 +50,8 @@ void io_unregister_zc_rx_ifqs(struct io_ring_ctx *ctx);
 void io_shutdown_zc_rx_ifqs(struct io_ring_ctx *ctx);
 int io_register_zc_rx_sock(struct io_ring_ctx *ctx,
 			   struct io_uring_zc_rx_sock_reg __user *arg);
+int io_zc_rx_recv(struct io_kiocb *req, struct io_zc_rx_ifq *ifq,
+		  struct socket *sock, unsigned int flags);
 #else
 static inline int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zc_rx_ifq_reg __user *arg)
@@ -67,6 +69,15 @@ static inline int io_register_zc_rx_sock(struct io_ring_ctx *ctx,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int io_zc_rx_recv(struct io_kiocb *req, struct io_zc_rx_ifq *ifq,
+				struct socket *sock, unsigned int flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
+int io_recvzc(struct io_kiocb *req, unsigned int issue_flags);
+int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+
 #endif
-- 
2.43.0


