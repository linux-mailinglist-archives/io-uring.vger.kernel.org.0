Return-Path: <io-uring+bounces-314-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C28B5819201
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:05:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 050CF1F21458
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC071405DB;
	Tue, 19 Dec 2023 21:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="XfHxmjbw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF073FB11
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5ca1b4809b5so1742960a12.3
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019859; x=1703624659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EseMquZ+ud914kgVcMqdU4pc5Hd6eVscu9u0Nzy12vg=;
        b=XfHxmjbw/YAU1WsBGvOQc6EaJ6VM8unnd7mW5cWXcN2yPX8+g78cXiTF61i42H2y+c
         2SZsfsXfCVXI69KXTKB87S8pFG++5NbUYOxasySWnzkuWe9CgHTyqQ3lau1wakOq2e3s
         PJWR2Vqg+8lWj3x7HDuKw6AfgEmJkVx6iThxV6a26jFPBiXleHF4ad8UwfynvNyBX0Oe
         sBpc6HGE0HYdhpmPhoNr49RnOrpsOHisXqkww4cbfd2KpDFOxPHOJ0uHGpfMthCErbb/
         lug0unYJxquvLoq2/HrCoCGtw6dN+wGEFOWJO9TgpBDDvEzfD2FVI/Wf2VwqB/UKajpn
         B9rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019859; x=1703624659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EseMquZ+ud914kgVcMqdU4pc5Hd6eVscu9u0Nzy12vg=;
        b=KiTUudjXvFgp+ggBn4w6tQIUdWyS1hk/NYR0XfarblunntfFQED/+C6A8rVrtq18BG
         TRF63m2I8eXA7DqD6NgGT8MWkpZ0RlTa3O/6wz71vL1fxk8GCSnT+0BYIdE90a/yNxxv
         udlqbMr52JH546wThciUIt9h4Q2JzNLzPmdoK8D7T8tCcSeGU6U399jjhqT7NtkY8VVJ
         kGD05ZIzyhalW5I9VCQnpQ/FxYyiOE4EjPX1J4MU/7kxjMDfRBCNxHuWG+CxKJndATXJ
         WTYRn2QFEEghZsWayan4LSK4E5FOYaQZflDoaohgldhty87AzlULKgopcRrzkmq9WkX/
         eAIg==
X-Gm-Message-State: AOJu0Yy6oyt+c6q/wjS6cFnAdJ9+HaU5kFYDZvV/VQFCQEpnYHjumQIr
	ylJEOsmaD33pSmA+Bg4Ip3dSu8lZ5FFGfjH7/g1XXw==
X-Google-Smtp-Source: AGHT+IGKtSzi/RRmXkuPnD6lrUqbaSUkwLiVuC2nC80xHz/yFrUKP7xukH1K1+e1c60fL24LqB6u4g==
X-Received: by 2002:a05:6a21:1a6:b0:194:bb77:b263 with SMTP id le38-20020a056a2101a600b00194bb77b263mr703965pzb.55.1703019859125;
        Tue, 19 Dec 2023 13:04:19 -0800 (PST)
Received: from localhost (fwdproxy-prn-000.fbsv.net. [2a03:2880:ff::face:b00c])
        by smtp.gmail.com with ESMTPSA id v4-20020aa78084000000b006cde2090154sm20613615pff.218.2023.12.19.13.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:18 -0800 (PST)
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
Subject: [RFC PATCH v3 15/20] io_uring: add io_recvzc request
Date: Tue, 19 Dec 2023 13:03:52 -0800
Message-Id: <20231219210357.4029713-16-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231219210357.4029713-1-dw@davidwei.uk>
References: <20231219210357.4029713-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Wei <davidhwei@meta.com>

This patch adds an io_uring opcode OP_RECV_ZC for doing ZC reads from a
socket that is set up for ZC Rx. The request reads skbs from a socket
where its page frags are tagged w/ a magic cookie in their page private
field. For each frag, entries are written into the ifq rbuf completion
ring, and the total number of bytes read is returned to user as an
io_uring completion event.

Multishot requests work. There is no need to specify provided buffers as
data is returned in  the ifq rbuf completion rings.

Userspace is expected to look into the ifq rbuf completion ring when it
receives an io_uring completion event.

The addr3 field is used to encode params in the following format:

  addr3 = (readlen << 32);

readlen is the max amount of data to read from the socket. ifq_id is the
interface queue id, and currently only 0 is supported.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h |   1 +
 io_uring/net.c                | 119 ++++++++++++++++-
 io_uring/opdef.c              |  16 +++
 io_uring/zc_rx.c              | 240 +++++++++++++++++++++++++++++++++-
 io_uring/zc_rx.h              |   5 +
 5 files changed, 375 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f4ba58bce3bd..f57f394744fe 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -253,6 +253,7 @@ enum io_uring_op {
 	IORING_OP_FUTEX_WAIT,
 	IORING_OP_FUTEX_WAKE,
 	IORING_OP_FUTEX_WAITV,
+	IORING_OP_RECV_ZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/net.c b/io_uring/net.c
index 454ba301ae6b..7a2aadf6962c 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -71,6 +71,16 @@ struct io_sr_msg {
 	struct io_kiocb 		*notif;
 };
 
+struct io_recvzc {
+	struct file			*file;
+	unsigned			len;
+	unsigned			done_io;
+	unsigned			msg_flags;
+	u16				flags;
+
+	u32				datalen;
+};
+
 static inline bool io_check_multishot(struct io_kiocb *req,
 				      unsigned int issue_flags)
 {
@@ -637,7 +647,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	unsigned int cflags;
 
 	cflags = io_put_kbuf(req, issue_flags);
-	if (msg->msg_inq && msg->msg_inq != -1)
+	if (msg && msg->msg_inq && msg->msg_inq != -1)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
@@ -652,7 +662,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 			io_recv_prep_retry(req);
 			/* Known not-empty or unknown state, retry */
 			if (cflags & IORING_CQE_F_SOCK_NONEMPTY ||
-			    msg->msg_inq == -1)
+			    (msg && msg->msg_inq == -1))
 				return false;
 			if (issue_flags & IO_URING_F_MULTISHOT)
 				*ret = IOU_ISSUE_SKIP_COMPLETE;
@@ -956,9 +966,8 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -975,6 +984,106 @@ struct io_zc_rx_ifq *io_zc_verify_sock(struct io_kiocb *req,
 	return ifq;
 }
 
+int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
+	u64 recvzc_cmd;
+
+	recvzc_cmd = READ_ONCE(sqe->addr3);
+	zc->datalen = recvzc_cmd >> 32;
+	if (recvzc_cmd & 0xffff)
+		return -EINVAL;
+	if (!(req->ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+		return -EINVAL;
+	if (unlikely(sqe->file_index || sqe->addr2))
+		return -EINVAL;
+
+	zc->len = READ_ONCE(sqe->len);
+	zc->flags = READ_ONCE(sqe->ioprio);
+	if (zc->flags & ~(RECVMSG_FLAGS))
+		return -EINVAL;
+	zc->msg_flags = READ_ONCE(sqe->msg_flags);
+	if (zc->msg_flags & MSG_DONTWAIT)
+		req->flags |= REQ_F_NOWAIT;
+	if (zc->msg_flags & MSG_ERRQUEUE)
+		req->flags |= REQ_F_CLEAR_POLLIN;
+	if (zc->flags & IORING_RECV_MULTISHOT) {
+		if (zc->msg_flags & MSG_WAITALL)
+			return -EINVAL;
+		if (req->opcode == IORING_OP_RECV && zc->len)
+			return -EINVAL;
+		req->flags |= REQ_F_APOLL_MULTISHOT;
+	}
+
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		zc->msg_flags |= MSG_CMSG_COMPAT;
+#endif
+	zc->done_io = 0;
+	return 0;
+}
+
+int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
+	struct socket *sock;
+	unsigned flags;
+	int ret, min_ret = 0;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	struct io_zc_rx_ifq *ifq;
+
+	if (issue_flags & IO_URING_F_UNLOCKED)
+		return -EAGAIN;
+
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
+retry_multishot:
+	flags = zc->msg_flags;
+	if (force_nonblock)
+		flags |= MSG_DONTWAIT;
+	if (flags & MSG_WAITALL)
+		min_ret = zc->len;
+
+	ret = io_zc_rx_recv(ifq, sock, zc->datalen, flags);
+	if (ret < min_ret) {
+		if (ret == -EAGAIN && force_nonblock) {
+			if (issue_flags & IO_URING_F_MULTISHOT)
+				return IOU_ISSUE_SKIP_COMPLETE;
+			return -EAGAIN;
+		}
+		if (ret > 0 && io_net_retry(sock, flags)) {
+			zc->len -= ret;
+			zc->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
+			return -EAGAIN;
+		}
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		req_set_fail(req);
+	} else if ((flags & MSG_WAITALL) && (flags & (MSG_TRUNC | MSG_CTRUNC))) {
+		req_set_fail(req);
+	}
+
+	if (ret > 0)
+		ret += zc->done_io;
+	else if (zc->done_io)
+		ret = zc->done_io;
+
+	if (!io_recv_finish(req, &ret, 0, ret <= 0, issue_flags))
+		goto retry_multishot;
+
+	return ret;
+}
+
 void io_send_zc_cleanup(struct io_kiocb *req)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 799db44283c7..a90231566d09 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -35,6 +35,7 @@
 #include "rw.h"
 #include "waitid.h"
 #include "futex.h"
+#include "zc_rx.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -467,6 +468,18 @@ const struct io_issue_def io_issue_defs[] = {
 		.issue			= io_futexv_wait,
 #else
 		.prep			= io_eopnotsupp_prep,
+#endif
+	},
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
 #endif
 	},
 };
@@ -704,6 +717,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_FUTEX_WAITV] = {
 		.name			= "FUTEX_WAITV",
 	},
+	[IORING_OP_RECV_ZC] = {
+		.name			= "RECV_ZC",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index ff1dac24ac40..acb70ca23150 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -6,6 +6,7 @@
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
 #include <linux/nospec.h>
+#include <net/tcp.h>
 #include <trace/events/page_pool.h>
 
 #include <uapi/linux/io_uring.h>
@@ -15,8 +16,20 @@
 #include "zc_rx.h"
 #include "rsrc.h"
 
+struct io_zc_rx_args {
+	struct io_zc_rx_ifq	*ifq;
+	struct socket		*sock;
+};
+
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 
+static inline u32 io_zc_rx_cqring_entries(struct io_zc_rx_ifq *ifq)
+{
+	struct io_rbuf_ring *ring = ifq->ring;
+
+	return ifq->cached_cq_tail - READ_ONCE(ring->cq.head);
+}
+
 static inline struct device *netdev2dev(struct net_device *dev)
 {
 	return dev->dev.parent;
@@ -399,7 +412,7 @@ static inline unsigned io_buf_pgid(struct io_zc_rx_pool *pool,
 	return buf - pool->bufs;
 }
 
-static __maybe_unused void io_zc_rx_get_buf_uref(struct io_zc_rx_buf *buf)
+static void io_zc_rx_get_buf_uref(struct io_zc_rx_buf *buf)
 {
 	refcount_add(IO_ZC_RX_UREF, &buf->ppiov.refcount);
 }
@@ -590,5 +603,230 @@ const struct pp_memory_provider_ops io_uring_pp_zc_ops = {
 };
 EXPORT_SYMBOL(io_uring_pp_zc_ops);
 
+static inline struct io_uring_rbuf_cqe *io_zc_get_rbuf_cqe(struct io_zc_rx_ifq *ifq)
+{
+	struct io_uring_rbuf_cqe *cqe;
+	unsigned int cq_idx, queued, free, entries;
+	unsigned int mask = ifq->cq_entries - 1;
+
+	cq_idx = ifq->cached_cq_tail & mask;
+	smp_rmb();
+	queued = min(io_zc_rx_cqring_entries(ifq), ifq->cq_entries);
+	free = ifq->cq_entries - queued;
+	entries = min(free, ifq->cq_entries - cq_idx);
+	if (!entries)
+		return NULL;
+
+	cqe = &ifq->cqes[cq_idx];
+	ifq->cached_cq_tail++;
+	return cqe;
+}
+
+static int zc_rx_recv_frag(struct io_zc_rx_ifq *ifq, const skb_frag_t *frag,
+			   int off, int len, unsigned sock_idx)
+{
+	off += skb_frag_off(frag);
+
+	if (likely(page_is_page_pool_iov(frag->bv_page))) {
+		struct io_uring_rbuf_cqe *cqe;
+		struct io_zc_rx_buf *buf;
+		struct page_pool_iov *ppiov;
+
+		ppiov = page_to_page_pool_iov(frag->bv_page);
+		if (ppiov->pp->p.memory_provider != PP_MP_IOU_ZCRX ||
+		    ppiov->pp->mp_priv != ifq)
+			return -EFAULT;
+
+		cqe = io_zc_get_rbuf_cqe(ifq);
+		if (!cqe)
+			return -ENOBUFS;
+
+		buf = io_iov_to_buf(ppiov);
+		io_zc_rx_get_buf_uref(buf);
+
+		cqe->region = 0;
+		cqe->off = io_buf_pgid(ifq->pool, buf) * PAGE_SIZE + off;
+		cqe->len = len;
+		cqe->sock = sock_idx;
+		cqe->flags = 0;
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
+	struct socket *sock = args->sock;
+	unsigned sock_idx = sock->zc_rx_idx & IO_ZC_IFQ_IDX_MASK;
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
+		WARN_ON(start > offset + len);
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
+			ret = zc_rx_recv_frag(ifq, frag, off, copy, sock_idx);
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
+		WARN_ON(start > offset + len);
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
+	smp_store_release(&ifq->ring->cq.tail, ifq->cached_cq_tail);
+	if (offset == start_off)
+		return ret;
+	return offset - start_off;
+}
+
+static int io_zc_rx_tcp_read(struct io_zc_rx_ifq *ifq, struct sock *sk)
+{
+	struct io_zc_rx_args args = {
+		.ifq = ifq,
+		.sock = sk->sk_socket,
+	};
+	read_descriptor_t rd_desc = {
+		.count = 1,
+		.arg.data = &args,
+	};
+
+	return tcp_read_sock(sk, &rd_desc, zc_rx_recv_skb);
+}
+
+static int io_zc_rx_tcp_recvmsg(struct io_zc_rx_ifq *ifq, struct sock *sk,
+				unsigned int recv_limit,
+				int flags, int *addr_len)
+{
+	size_t used;
+	long timeo;
+	int ret;
+
+	ret = used = 0;
+
+	lock_sock(sk);
+
+	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+	while (recv_limit) {
+		ret = io_zc_rx_tcp_read(ifq, sk);
+		if (ret < 0)
+			break;
+		if (!ret) {
+			if (used)
+				break;
+			if (sock_flag(sk, SOCK_DONE))
+				break;
+			if (sk->sk_err) {
+				ret = sock_error(sk);
+				break;
+			}
+			if (sk->sk_shutdown & RCV_SHUTDOWN)
+				break;
+			if (sk->sk_state == TCP_CLOSE) {
+				ret = -ENOTCONN;
+				break;
+			}
+			if (!timeo) {
+				ret = -EAGAIN;
+				break;
+			}
+			if (!skb_queue_empty(&sk->sk_receive_queue))
+				break;
+			sk_wait_data(sk, &timeo, NULL);
+			if (signal_pending(current)) {
+				ret = sock_intr_errno(timeo);
+				break;
+			}
+			continue;
+		}
+		recv_limit -= ret;
+		used += ret;
+
+		if (!timeo)
+			break;
+		release_sock(sk);
+		lock_sock(sk);
+
+		if (sk->sk_err || sk->sk_state == TCP_CLOSE ||
+		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
+		    signal_pending(current))
+			break;
+	}
+	release_sock(sk);
+	/* TODO: handle timestamping */
+	return used ? used : ret;
+}
+
+int io_zc_rx_recv(struct io_zc_rx_ifq *ifq, struct socket *sock,
+		  unsigned int limit, unsigned int flags)
+{
+	struct sock *sk = sock->sk;
+	const struct proto *prot;
+	int addr_len = 0;
+	int ret;
+
+	if (flags & MSG_ERRQUEUE)
+		return -EOPNOTSUPP;
+
+	prot = READ_ONCE(sk->sk_prot);
+	if (prot->recvmsg != tcp_recvmsg)
+		return -EPROTONOSUPPORT;
+
+	sock_rps_record_flow(sk);
+
+	ret = io_zc_rx_tcp_recvmsg(ifq, sk, limit, flags, &addr_len);
+
+	return ret;
+}
 
 #endif
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
index 00d864700c67..3e8f07e4b252 100644
--- a/io_uring/zc_rx.h
+++ b/io_uring/zc_rx.h
@@ -72,4 +72,9 @@ static inline int io_register_zc_rx_sock(struct io_ring_ctx *ctx,
 }
 #endif
 
+int io_recvzc(struct io_kiocb *req, unsigned int issue_flags);
+int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_zc_rx_recv(struct io_zc_rx_ifq *ifq, struct socket *sock,
+		  unsigned int limit, unsigned int flags);
+
 #endif
-- 
2.39.3


