Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B725789220
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 00:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjHYW4r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 18:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjHYW4S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 18:56:18 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591CB1BF1
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:14 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1bc3d94d40fso11647565ad.3
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1693004174; x=1693608974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZyOGiEo7fxbB4EEi1N2igx6I6zFU58A0GhJQnNqswuk=;
        b=Ip2WFRPMRxls5HyTqNZ5HvQ8JMFd0udlIaKhG+yFXK+vrsRKM1O25ldZ4kdnBlPk4a
         BwJ4+PtTeTdMUD1VFVaMQXBpIjrjSXvRPUnsfXWR4kwumLodVOhyJYYXDnGuSJIRui6e
         jz6A6Q3XsHBOnGaeGauNhvIbKyaG2EviT78L1cAEr42HiYKXjme0K2GNadp/JzXlWOXL
         0givBW57pj8TxKvzbkX/0a3cG9eb9CrspcjY7SVa5gW8RsDRCeluKNjCSrUOt5SCfzuC
         Ksa6z0+wF7SCT8SR6ud5V8/rhFkvqKO+E3ayCx0bGqSHM0LgoBZnMotGQmWH2GPPe6W+
         jrMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693004174; x=1693608974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZyOGiEo7fxbB4EEi1N2igx6I6zFU58A0GhJQnNqswuk=;
        b=b0Bq2bC9ta6G6YqfZ7vtZdbOhjjI0aZr24TO9i6bsV01OeojyrXI6IVjeqyjIlVzIZ
         mxze/vhUM1DpW3a77A/1zciG/YRJnr0pBZk9bP4Y4GSbk+ETb5ODkfOaqIagvrJNUXO7
         dGUGLyjevnPprOy1u5FJW56Yaee9VKiE9aiXOCelsCmj4tv+I3pUWumCyQZM274MELOn
         a5GOme3NQ8WjiEcKWf3qmiVgaBjsEJlQ/SdXN7UcvT5DTE44CEjJoLtxEcxM5Zm2jw+H
         ltEviQhVCW9jhD6yt0WumhLRwxl7vJ1/WyS/r1Wye9UYlBXd0t1ayYFSDuM8NlP5tSly
         0xwg==
X-Gm-Message-State: AOJu0YyRrwzR/Etb4OtRbouzKf+2l69gm8I7krwgr5CTlMFUA7FdvnZu
        TTBaobQ86XhHuC8bUPcqXh/VIg==
X-Google-Smtp-Source: AGHT+IFmxxF7YMh2NuUhE52TCix6goRIuD+Wh/xanKoFwq3IwtQSjqz4R2ertxfXWzVeWushGXNing==
X-Received: by 2002:a17:902:f80e:b0:1bc:9651:57c6 with SMTP id ix14-20020a170902f80e00b001bc965157c6mr16338093plb.57.1693004173819;
        Fri, 25 Aug 2023 15:56:13 -0700 (PDT)
Received: from localhost (fwdproxy-prn-120.fbsv.net. [2a03:2880:ff:78::face:b00c])
        by smtp.gmail.com with ESMTPSA id z1-20020a170903018100b001bdb167f6ebsm2300069plg.94.2023.08.25.15.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 15:56:13 -0700 (PDT)
From:   David Wei <dw@davidwei.uk>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 11/11] io_uring: add io_recvzc request
Date:   Fri, 25 Aug 2023 15:55:50 -0700
Message-Id: <20230825225550.957014-12-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230825225550.957014-1-dw@davidwei.uk>
References: <20230825225550.957014-1-dw@davidwei.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: David Wei <davidhwei@meta.com>

This patch adds an io_uring opcode OP_RECV_ZC for doing ZC reads from a
socket that is set up for ZC RX. The request reads skbs from a socket
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

Signed-off-by: David Wei <davidhwei@meta.com>
Co-developed-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/uapi/linux/io_uring.h |   1 +
 io_uring/net.c                |  83 +++++++++++-
 io_uring/opdef.c              |  16 +++
 io_uring/zc_rx.c              | 232 ++++++++++++++++++++++++++++++++++
 io_uring/zc_rx.h              |   4 +
 5 files changed, 335 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 28154abfe6f4..c43e5cc7de0a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -223,6 +223,7 @@ enum io_uring_op {
 	IORING_OP_URING_CMD,
 	IORING_OP_SEND_ZC,
 	IORING_OP_SENDMSG_ZC,
+	IORING_OP_RECV_ZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/net.c b/io_uring/net.c
index 89e839013837..9a0a008418ec 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -69,6 +69,12 @@ struct io_sr_msg {
 	struct io_kiocb 		*notif;
 };
 
+struct io_recvzc {
+	struct io_sr_msg		sr;
+	u32				datalen;
+	u16				ifq_id;
+};
+
 static inline bool io_check_multishot(struct io_kiocb *req,
 				      unsigned int issue_flags)
 {
@@ -574,7 +580,8 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (sr->msg_flags & MSG_ERRQUEUE)
 		req->flags |= REQ_F_CLEAR_POLLIN;
 	if (sr->flags & IORING_RECV_MULTISHOT) {
-		if (!(req->flags & REQ_F_BUFFER_SELECT))
+		if (!(req->flags & REQ_F_BUFFER_SELECT)
+		    && req->opcode != IORING_OP_RECV_ZC)
 			return -EINVAL;
 		if (sr->msg_flags & MSG_WAITALL)
 			return -EINVAL;
@@ -931,6 +938,80 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
+int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
+	u64 recvzc_cmd;
+
+	recvzc_cmd = READ_ONCE(sqe->addr3);
+	zc->datalen = recvzc_cmd >> 32;
+	zc->ifq_id = recvzc_cmd & 0xffff;
+	if (zc->ifq_id != 0)
+		return -EINVAL;
+
+	return io_recvmsg_prep(req, sqe);
+}
+
+int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
+	struct socket *sock;
+	unsigned flags;
+	int ret, min_ret = 0;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+
+	if (!(req->flags & REQ_F_POLLED) &&
+	    (zc->sr.flags & IORING_RECVSEND_POLL_FIRST))
+		return -EAGAIN;
+
+	sock = sock_from_file(req->file);
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+retry_multishot:
+	flags = zc->sr.msg_flags;
+	if (force_nonblock)
+		flags |= MSG_DONTWAIT;
+	if (flags & MSG_WAITALL)
+		min_ret = zc->sr.len;
+
+	ret = io_zc_rx_recv(sock, zc->datalen, flags);
+	if (ret < min_ret) {
+		if (ret == -EAGAIN && force_nonblock) {
+			if (issue_flags & IO_URING_F_MULTISHOT) {
+				io_kbuf_recycle(req, issue_flags);
+				return IOU_ISSUE_SKIP_COMPLETE;
+			}
+
+			return -EAGAIN;
+		}
+		if (ret > 0 && io_net_retry(sock, flags)) {
+			zc->sr.len -= ret;
+			zc->sr.buf += ret;
+			zc->sr.done_io += ret;
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
+		ret += zc->sr.done_io;
+	else if (zc->sr.done_io)
+		ret = zc->sr.done_io;
+	else
+		io_kbuf_recycle(req, issue_flags);
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
index 70e39f851e47..a861be50fd61 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -5,6 +5,7 @@
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
 #include <linux/nospec.h>
+#include <net/tcp.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -38,6 +39,13 @@ struct io_zc_rx_pool {
 	u32			freelist[];
 };
 
+static inline u32 io_zc_rx_cqring_entries(struct io_zc_rx_ifq *ifq)
+{
+	struct io_rbuf_ring *ring = ifq->ring;
+
+	return ifq->cached_cq_tail - READ_ONCE(ring->cq.head);
+}
+
 static struct device *netdev2dev(struct net_device *dev)
 {
 	return dev->dev.parent;
@@ -381,6 +389,14 @@ int io_unregister_zc_rx_ifq(struct io_ring_ctx *ctx)
 	return 0;
 }
 
+static void io_zc_rx_get_buf_uref(struct io_zc_rx_pool *pool, u16 pgid)
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
@@ -489,3 +505,219 @@ struct io_zc_rx_buf *io_zc_rx_buf_from_page(struct io_zc_rx_ifq *ifq,
 	return &pool->bufs[pgid];
 }
 EXPORT_SYMBOL(io_zc_rx_buf_from_page);
+
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
+	unsigned int pgid, cq_idx, queued, free, entries;
+	struct page *page;
+	unsigned int mask;
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
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
index ee7e36295f91..63ff81a7900a 100644
--- a/io_uring/zc_rx.h
+++ b/io_uring/zc_rx.h
@@ -35,4 +35,8 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 int io_unregister_zc_rx_ifq(struct io_ring_ctx *ctx);
 int io_zc_rx_pool_create(struct io_zc_rx_ifq *ifq, u16 id);
 
+int io_recvzc(struct io_kiocb *req, unsigned int issue_flags);
+int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_zc_rx_recv(struct socket *sock, unsigned int limit, unsigned int flags);
+
 #endif
-- 
2.39.3

