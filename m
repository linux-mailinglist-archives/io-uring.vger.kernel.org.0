Return-Path: <io-uring+bounces-64-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABE337E4AF6
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:42:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 601CF28146A
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA9D2BD09;
	Tue,  7 Nov 2023 21:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="gDtc3u1g"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C722B2FA
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:41:08 +0000 (UTC)
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2498E10E5
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:41:08 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id 006d021491bc7-589d4033e84so99360eaf.1
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393267; x=1699998067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s+zqFsNP24K5w+diErx4CzW6YBVojNR7U9nZFqFAmk4=;
        b=gDtc3u1gMwnzHQL3L1vzps0uGTtOkdnxpt8nJUVFBNtNQj78wjpNz5u9LWTDIlYE3u
         t0NmiEwIpRsclDiqPAOp8Tcl3/0rYEnULju6hybc1Mhdwf34rjZAPTYd3BB/I0dz74/I
         zNTIdh7/JjSu3uBz0lOSInTax6IA42enVOw/IH30DW7NaeOicGrGz4oXQs7Zry5F9a4K
         AISif66Agc4kWID1+PnHkYxUMISeWHUbQCt2S9NkX1rh6jKHyItqYkGbrZAn0GxqGptS
         Osm9ZcxKM3qQKHgWZeqMooedYFJXqdRidR+N5Hw9laPbeJsydagu+ijTS/sdGuORigGH
         Zt3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393267; x=1699998067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s+zqFsNP24K5w+diErx4CzW6YBVojNR7U9nZFqFAmk4=;
        b=LYVK+svLEZ+caEvcdpbgyeqZj9arl2eW/8mqGMRaz1azJLJAnsQxxocS0HwaCepu7N
         QNRrYPS6V/5+YBtDrRb17H09/1LhmMh2Pu+dhl3h8dfAhKFgtLe6TMp4WWa/rxZF4U8W
         HUwq697apOs1y7d/PYyMzABCuTjFvRJI1rYHQZGnowc+BMtKY+soTmj7/niDRr+mAAvC
         2xf0zHz+oqWNyH+nIL50pMvb7stOZYvwlNKm9IHoHq8m8rJMN1d+JxSsW9h++R7it/0V
         5CwHQMYFESP6mC8paPLnmA/GKap+546Uus4MflEniUBvNJtLApAyBF7HDPWm4q0iGtx8
         OA9w==
X-Gm-Message-State: AOJu0YzxmtW5rFzKpLbn8ww4npe3K5KyxeA476xBDnFsA2FsAlGiniFI
	8cLXPhBH3lmPQ/68Uh1hgWBw6cB6SjOLlYkxKXi5qg==
X-Google-Smtp-Source: AGHT+IEqd2GTfWpxVSSb6gx/b5KY6FAhjT7V3Wr2G0n7DZUoTC7yAI6Pbm2twIB7w7C+XmvVpNJCTQ==
X-Received: by 2002:a05:6358:904c:b0:16b:858c:a140 with SMTP id f12-20020a056358904c00b0016b858ca140mr1333273rwf.9.1699393267134;
        Tue, 07 Nov 2023 13:41:07 -0800 (PST)
Received: from localhost (fwdproxy-prn-119.fbsv.net. [2a03:2880:ff:77::face:b00c])
        by smtp.gmail.com with ESMTPSA id m33-20020a635821000000b0059d219cb359sm1816160pgb.9.2023.11.07.13.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:41:06 -0800 (PST)
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
	Mina Almasry <almasrymina@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>
Subject: [PATCH 12/20] io_uring: add io_recvzc request
Date: Tue,  7 Nov 2023 13:40:37 -0800
Message-Id: <20231107214045.2172393-13-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231107214045.2172393-1-dw@davidwei.uk>
References: <20231107214045.2172393-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

  addr3 = (readlen << 32) | ifq_id;

readlen is the max amount of data to read from the socket. ifq_id is the
interface queue id, and currently only 0 is supported.

Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h |   1 +
 io_uring/net.c                | 122 ++++++++++++++++-
 io_uring/opdef.c              |  16 +++
 io_uring/zc_rx.c              | 239 ++++++++++++++++++++++++++++++++++
 io_uring/zc_rx.h              |   4 +
 5 files changed, 376 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 917d0025cc94..603d07d0a791 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -240,6 +240,7 @@ enum io_uring_op {
 	IORING_OP_URING_CMD,
 	IORING_OP_SEND_ZC,
 	IORING_OP_SENDMSG_ZC,
+	IORING_OP_RECV_ZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/net.c b/io_uring/net.c
index fc0b7936971d..79f2ed3a6fc0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -70,6 +70,16 @@ struct io_sr_msg {
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
@@ -588,7 +598,8 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (sr->msg_flags & MSG_ERRQUEUE)
 		req->flags |= REQ_F_CLEAR_POLLIN;
 	if (sr->flags & IORING_RECV_MULTISHOT) {
-		if (!(req->flags & REQ_F_BUFFER_SELECT))
+		if (!(req->flags & REQ_F_BUFFER_SELECT)
+		    && req->opcode != IORING_OP_RECV_ZC)
 			return -EINVAL;
 		if (sr->msg_flags & MSG_WAITALL)
 			return -EINVAL;
@@ -636,7 +647,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	unsigned int cflags;
 
 	cflags = io_put_kbuf(req, issue_flags);
-	if (msg->msg_inq && msg->msg_inq != -1)
+	if (msg && msg->msg_inq && msg->msg_inq != -1)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
@@ -651,7 +662,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 			io_recv_prep_retry(req);
 			/* Known not-empty or unknown state, retry */
 			if (cflags & IORING_CQE_F_SOCK_NONEMPTY ||
-			    msg->msg_inq == -1)
+			    (msg && msg->msg_inq == -1))
 				return false;
 			if (issue_flags & IO_URING_F_MULTISHOT)
 				*ret = IOU_ISSUE_SKIP_COMPLETE;
@@ -955,9 +966,8 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -974,6 +984,106 @@ struct io_zc_rx_ifq *io_zc_verify_sock(struct io_kiocb *req,
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
+	ret = io_zc_rx_recv(sock, zc->datalen, flags);
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
index 3b9c6489b8b6..4dee7f83222f 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -33,6 +33,7 @@
 #include "poll.h"
 #include "cancel.h"
 #include "rw.h"
+#include "zc_rx.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -426,6 +427,18 @@ const struct io_issue_def io_issue_defs[] = {
 		.issue			= io_sendmsg_zc,
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
@@ -648,6 +661,9 @@ const struct io_cold_def io_cold_defs[] = {
 		.fail			= io_sendrecv_fail,
 #endif
 	},
+	[IORING_OP_RECV_ZC] = {
+		.name			= "RECV_ZC",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index bebcd637c893..842aae760deb 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -6,6 +6,7 @@
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
 #include <linux/nospec.h>
+#include <net/tcp.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -40,6 +41,13 @@ struct io_zc_rx_pool {
 	u32			freelist[];
 };
 
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
@@ -311,6 +319,8 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 	size_t ring_sz, rqes_sz, cqes_sz;
 	int ret;
 
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+		return -EINVAL;
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
 	if (ctx->ifq)
@@ -444,6 +454,14 @@ int io_register_zc_rx_sock(struct io_ring_ctx *ctx,
 	return 0;
 }
 
+static void io_zc_rx_get_buf_uref(struct io_zc_rx_pool *pool, u32 pgid)
+{
+	if (WARN_ON(pgid >= pool->nr_pages))
+		return;
+
+	atomic_add(IO_ZC_RX_UREF, &pool->bufs[pgid].refcount);
+}
+
 static bool io_zc_rx_put_buf_uref(struct io_zc_rx_buf *buf)
 {
 	if (atomic_read(&buf->refcount) < IO_ZC_RX_UREF)
@@ -549,4 +567,225 @@ struct io_zc_rx_buf *io_zc_rx_buf_from_page(struct io_zc_rx_ifq *ifq,
 }
 EXPORT_SYMBOL(io_zc_rx_buf_from_page);
 
+static struct io_zc_rx_ifq *io_zc_rx_ifq_skb(struct sk_buff *skb)
+{
+	struct ubuf_info *uarg = skb_zcopy(skb);
+
+	if (uarg && uarg->callback == io_zc_rx_skb_free)
+		return container_of(uarg, struct io_zc_rx_ifq, uarg);
+	return NULL;
+}
+
+static int zc_rx_recv_frag(struct io_zc_rx_ifq *ifq, const skb_frag_t *frag,
+			   int off, int len)
+{
+	struct io_uring_rbuf_cqe *cqe;
+	unsigned int cq_idx, queued, free, entries;
+	struct page *page;
+	unsigned int mask;
+	u32 pgid;
+
+	page = skb_frag_page(frag);
+	off += skb_frag_off(frag);
+
+	if (likely(ifq && is_zc_rx_page(page))) {
+		mask = ifq->cq_entries - 1;
+		pgid = page_private(page) & 0xffffffff;
+		io_zc_rx_get_buf_uref(ifq->pool, pgid);
+		cq_idx = ifq->cached_cq_tail & mask;
+		smp_rmb();
+		queued = min(io_zc_rx_cqring_entries(ifq), ifq->cq_entries);
+		free = ifq->cq_entries - queued;
+		entries = min(free, ifq->cq_entries - cq_idx);
+		if (!entries)
+			return -ENOBUFS;
+		cqe = &ifq->cqes[cq_idx];
+		ifq->cached_cq_tail++;
+		cqe->region = 0;
+		cqe->off = pgid * PAGE_SIZE + off;
+		cqe->len = len;
+		cqe->flags = 0;
+	} else {
+		/* TODO: copy frags that aren't backed by zc pages */
+		WARN_ON_ONCE(1);
+		return -ENOMEM;
+	}
+
+	return len;
+}
+
+static int
+zc_rx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
+	       unsigned int offset, size_t len)
+{
+	struct io_zc_rx_ifq *ifq;
+	struct sk_buff *frag_iter;
+	unsigned start, start_off;
+	int i, copy, end, off;
+	int ret = 0;
+
+	ifq = io_zc_rx_ifq_skb(skb);
+	if (!ifq) {
+		pr_debug("non zerocopy pages are not supported\n");
+		return -EFAULT;
+	}
+	start = skb_headlen(skb);
+	start_off = offset;
+
+	// TODO: copy payload in skb linear data */
+	WARN_ON_ONCE(offset < start);
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
+			ret = zc_rx_recv_frag(ifq, frag, off, copy);
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
+static int io_zc_rx_tcp_read(struct sock *sk)
+{
+	read_descriptor_t rd_desc = {
+		.count = 1,
+	};
+
+	return tcp_read_sock(sk, &rd_desc, zc_rx_recv_skb);
+}
+
+static int io_zc_rx_tcp_recvmsg(struct sock *sk, unsigned int recv_limit,
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
+		ret = io_zc_rx_tcp_read(sk);
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
+
+	release_sock(sk);
+
+	/* TODO: handle timestamping */
+
+	if (used)
+		return used;
+
+	return ret;
+}
+
+int io_zc_rx_recv(struct socket *sock, unsigned int limit, unsigned int flags)
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
+	ret = io_zc_rx_tcp_recvmsg(sk, limit, flags, &addr_len);
+
+	return ret;
+}
+
 #endif
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
index b99be0227e9e..bfba21c370b0 100644
--- a/io_uring/zc_rx.h
+++ b/io_uring/zc_rx.h
@@ -60,4 +60,8 @@ static inline int io_register_zc_rx_sock(struct io_ring_ctx *ctx,
 }
 #endif
 
+int io_recvzc(struct io_kiocb *req, unsigned int issue_flags);
+int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_zc_rx_recv(struct socket *sock, unsigned int limit, unsigned int flags);
+
 #endif
-- 
2.39.3


