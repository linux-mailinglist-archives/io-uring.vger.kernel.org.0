Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D118F6172DF
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 00:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiKBXkW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 2 Nov 2022 19:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbiKBXj6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 19:39:58 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B88C271D
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 16:33:11 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVrnR020799
        for <io-uring@vger.kernel.org>; Wed, 2 Nov 2022 16:33:10 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3kkhd9grny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 16:33:10 -0700
Received: from twshared9088.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:33:09 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id BE355235B618B; Wed,  2 Nov 2022 16:32:44 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v3 12/15] io_uring: add OP_RECV_ZC command.
Date:   Wed, 2 Nov 2022 16:32:41 -0700
Message-ID: <20221102233244.4022405-13-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
References: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: X0xUrLm4D0wBtUYgnguQeVKwApq4G6Yq
X-Proofpoint-ORIG-GUID: X0xUrLm4D0wBtUYgnguQeVKwApq4G6Yq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is still a WIP.  The current code (temporarily) uses addr3
as a hack in order to leverage code in io_recvmsg_prep.

The recvzc opcode uses a metadata buffer either supplied directly
with buf/len, or indirectly from the buffer group.  The expectation
is that this buffer is then filled with an array of io_uring_zctap_iov
structures, which point to the data in user-memory.

    addr3 = (readlen << 32) | (copy_bgid << 16) | ctx->ifq_id;

The amount of returned data is limited by the number of iovs that
the metadata area can hold, and also the readlen parameter.

As a fallback (and for testing purposes), if the skb data is not
present in user memory (perhaps due to system misconfiguration), then
a seprate buffer is obtained from the copy_bgid and the data is
copied into user-memory.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/uapi/linux/io_uring.h |   1 +
 io_uring/net.c                | 121 ++++++++++++
 io_uring/opdef.c              |  15 ++
 io_uring/zctap.c              | 340 ++++++++++++++++++++++++++++++++++
 io_uring/zctap.h              |  20 ++
 5 files changed, 497 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 4d211d224c19..3d553c6662d1 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -215,6 +215,7 @@ enum io_uring_op {
 	IORING_OP_URING_CMD,
 	IORING_OP_SEND_ZC,
 	IORING_OP_SENDMSG_ZC,
+	IORING_OP_RECV_ZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/net.c b/io_uring/net.c
index 15dea91625e2..3a40e87afe54 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -16,6 +16,7 @@
 #include "net.h"
 #include "notif.h"
 #include "rsrc.h"
+#include "zctap.h"
 
 #if defined(CONFIG_NET)
 struct io_shutdown {
@@ -67,6 +68,12 @@ struct io_sr_msg {
 	struct io_kiocb 		*notif;
 };
 
+struct io_recvzc {
+	struct io_sr_msg		sr;
+	u32				datalen;
+	u16				copy_bgid;
+};
+
 #define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
 
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -908,6 +915,120 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
+int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
+	u64 recvzc_cmd;
+
+	/* XXX hack so we can temporarily use io_recvmsg_prep */
+	recvzc_cmd = READ_ONCE(sqe->addr3);
+
+	zc->copy_bgid = (recvzc_cmd >> 16) & 0xffff;
+	zc->datalen = recvzc_cmd >> 32;
+
+	return io_recvmsg_prep(req, sqe);
+}
+
+int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
+	struct zctap_read_desc zrd;
+	struct msghdr msg;
+	struct socket *sock;
+	struct iovec iov;
+	unsigned int cflags;
+	unsigned flags;
+	int ret, min_ret = 0;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	size_t len = zc->sr.len;
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
+	if (io_do_buffer_select(req)) {
+		void __user *buf;
+
+		buf = io_buffer_select(req, &len, issue_flags);
+		if (!buf)
+			return -ENOBUFS;
+		zc->sr.buf = buf;
+	}
+
+	ret = import_single_range(READ, zc->sr.buf, len, &iov, &msg.msg_iter);
+	if (unlikely(ret))
+		goto out_free;
+
+	msg.msg_name = NULL;
+	msg.msg_namelen = 0;
+	msg.msg_control = NULL;
+	msg.msg_get_inq = 1;
+	msg.msg_flags = 0;
+	msg.msg_controllen = 0;
+	msg.msg_iocb = NULL;
+	msg.msg_ubuf = NULL;
+
+	flags = zc->sr.msg_flags;
+	if (force_nonblock)
+		flags |= MSG_DONTWAIT;
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&msg.msg_iter);
+
+	zrd = (struct zctap_read_desc) {
+		.iov_limit = msg_data_left(&msg),
+		.recv_limit = zc->datalen,
+		.iter = &msg.msg_iter,
+		.ctx = req->ctx,
+		.copy_bgid = zc->copy_bgid,
+	};
+
+	ret = io_zctap_recv(sock, &zrd, &msg, flags);
+	if (ret < min_ret) {
+		if (ret == -EAGAIN && force_nonblock) {
+			if ((req->flags & IO_APOLL_MULTI_POLLED) == IO_APOLL_MULTI_POLLED) {
+				io_kbuf_recycle(req, issue_flags);
+				return IOU_ISSUE_SKIP_COMPLETE;
+			}
+
+			return -EAGAIN;
+		}
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		if (ret > 0 && io_net_retry(sock, flags)) {
+			zc->sr.len -= ret;
+			zc->sr.buf += ret;
+			zc->sr.done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
+			return -EAGAIN;
+		}
+		req_set_fail(req);
+	} else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
+out_free:
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
+	cflags = io_put_kbuf(req, issue_flags);
+	if (msg.msg_inq)
+		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
+
+	if (!io_recv_finish(req, &ret, cflags, ret <= 0))
+		goto retry_multishot;
+
+	return ret;
+}
+
 void io_send_zc_cleanup(struct io_kiocb *req)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 83dc0f9ad3b2..14b42811a78e 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -33,6 +33,7 @@
 #include "poll.h"
 #include "cancel.h"
 #include "rw.h"
+#include "zctap.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -521,6 +522,20 @@ const struct io_op_def io_op_defs[] = {
 		.fail			= io_sendrecv_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
+#endif
+	},
+	[IORING_OP_RECV_ZC] = {
+		.name			= "RECV_ZC",
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.buffer_select		= 1,
+		.ioprio			= 1,
+#if defined(CONFIG_NET)
+		.prep			= io_recvzc_prep,
+		.issue			= io_recvzc,
+#else
+		.prep			= io_eopnotsupp_prep,
 #endif
 	},
 };
diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index a84204c6eb96..32efa7e9199d 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -7,6 +7,7 @@
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
 #include <linux/nospec.h>
+#include <net/tcp.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -53,6 +54,11 @@ static u64 zctap_page_info(const struct page *page)
 	return page_private(page);
 }
 
+static u16 zctap_page_region_id(const struct page *page)
+{
+	return (zctap_page_info(page) >> 16) & 0xffff;
+}
+
 static u16 zctap_page_id(const struct page *page)
 {
 	return zctap_page_info(page) & 0xffff;
@@ -72,6 +78,14 @@ static bool zctap_page_ours(struct page *page)
 #define IO_ZCTAP_UREF		0x10000
 #define IO_ZCTAP_KREF_MASK	(IO_ZCTAP_UREF - 1)
 
+static void io_zctap_get_buf_uref(struct ifq_region *ifr, u16 pgid)
+{
+	if (WARN_ON(pgid >= ifr->nr_pages))
+		return;
+
+	atomic_add(IO_ZCTAP_UREF, &ifr->buf[pgid].refcount);
+}
+
 /* return user refs back, indicate whether buffer is reusable */
 static bool io_zctap_put_buf_uref(struct io_zctap_buf *buf)
 {
@@ -392,6 +406,18 @@ static void io_zctap_ifq_callback(struct sk_buff *skb, struct ubuf_info *uarg,
 	}
 }
 
+static struct io_zctap_ifq *io_zctap_skb_ifq(struct sk_buff *skb)
+{
+	struct io_zctap_ifq_priv *priv;
+	struct ubuf_info *uarg = skb_zcopy(skb);
+
+	if (uarg && uarg->callback == io_zctap_ifq_callback) {
+		priv = container_of(uarg, struct io_zctap_ifq_priv, uarg);
+		return &priv->ifq;
+	}
+	return NULL;
+}
+
 static struct io_zctap_ifq *io_zctap_ifq_alloc(struct io_ring_ctx *ctx)
 {
 	struct io_zctap_ifq_priv *priv;
@@ -485,3 +511,317 @@ void io_unregister_zctap_all(struct io_ring_ctx *ctx)
 	for (i = 0; i < NR_ZCTAP_IFQS; i++)
 		io_unregister_zctap_ifq(ctx, i);
 }
+
+static int __zctap_get_user_buffer(struct zctap_read_desc *zrd, int len)
+{
+	if (!zrd->buflen) {
+		zrd->req = (struct io_kiocb) {
+			.ctx = zrd->ctx,
+			.buf_index = zrd->copy_bgid,
+		};
+
+		zrd->buf = (u8 *)io_zctap_buffer(&zrd->req, &zrd->buflen);
+		zrd->offset = 0;
+	}
+	return len > zrd->buflen ? zrd->buflen : len;
+}
+
+static int zctap_copy_data(struct zctap_read_desc *zrd, int len, u8 *kaddr)
+{
+	struct io_uring_zctap_iov zov;
+	u32 space;
+	int err;
+
+	space = zrd->iov_space + sizeof(zov);
+	if (space > zrd->iov_limit)
+		return 0;
+
+	len = __zctap_get_user_buffer(zrd, len);
+	if (!len)
+		return -ENOBUFS;
+
+	err = copy_to_user(zrd->buf + zrd->offset, kaddr, len);
+	if (err)
+		return -EFAULT;
+
+	zov = (struct io_uring_zctap_iov) {
+		.off = zrd->offset,
+		.len = len,
+		.bgid = zrd->copy_bgid,
+		.bid = zrd->req.buf_index,
+	};
+
+	if (copy_to_iter(&zov, sizeof(zov), zrd->iter) != sizeof(zov))
+		return -EFAULT;
+
+	zrd->offset += len;
+	zrd->buflen -= len;
+	zrd->iov_space = space;
+
+	return len;
+}
+
+static int zctap_copy_frag(struct zctap_read_desc *zrd, struct page *page,
+			   int off, int len, struct io_uring_zctap_iov *zov)
+{
+	u8 *kaddr;
+	int err;
+
+	len = __zctap_get_user_buffer(zrd, len);
+	if (!len)
+		return -ENOBUFS;
+
+	kaddr = kmap(page) + off;
+	err = copy_to_user(zrd->buf + zrd->offset, kaddr, len);
+	kunmap(page);
+
+	if (err)
+		return -EFAULT;
+
+	*zov = (struct io_uring_zctap_iov) {
+		.off = zrd->offset,
+		.len = len,
+		.bgid = zrd->copy_bgid,
+		.bid = zrd->req.buf_index,
+	};
+
+	zrd->offset += len;
+	zrd->buflen -= len;
+
+	return len;
+}
+
+static int zctap_recv_frag(struct zctap_read_desc *zrd,
+			   struct io_zctap_ifq *ifq,
+			   const skb_frag_t *frag, int off, int len)
+{
+	struct io_uring_zctap_iov zov;
+	struct page *page;
+	u32 space;
+	int pgid;
+
+	space = zrd->iov_space + sizeof(zov);
+	if (space > zrd->iov_limit)
+		return 0;
+
+	page = skb_frag_page(frag);
+	off += skb_frag_off(frag);
+
+	if (likely(ifq && ifq->ctx == zrd->ctx && zctap_page_ours(page))) {
+		pgid = zctap_page_id(page);
+		io_zctap_get_buf_uref(ifq->region, pgid);
+		zov = (struct io_uring_zctap_iov) {
+			.off = off,
+			.len = len,
+			.bgid = zctap_page_region_id(page),
+			.bid = pgid,
+		};
+	} else {
+		len = zctap_copy_frag(zrd, page, off, len, &zov);
+		if (len <= 0)
+			return len;
+	}
+
+	if (copy_to_iter(&zov, sizeof(zov), zrd->iter) != sizeof(zov))
+		return -EFAULT;
+
+	zrd->iov_space = space;
+
+	return len;
+}
+
+/* Our version of __skb_datagram_iter  -- should work for UDP also. */
+static int
+zctap_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
+	       unsigned int offset, size_t len)
+{
+	struct zctap_read_desc *zrd = desc->arg.data;
+	struct io_zctap_ifq *ifq;
+	unsigned start, start_off;
+	struct sk_buff *frag_iter;
+	int i, copy, end, off;
+	int ret = 0;
+
+	if (zrd->iov_space >= zrd->iov_limit) {
+		desc->count = 0;
+		return 0;
+	}
+	if (len > zrd->recv_limit)
+		len = zrd->recv_limit;
+
+	start = skb_headlen(skb);
+	start_off = offset;
+
+	ifq = io_zctap_skb_ifq(skb);
+
+	if (offset < start) {
+		copy = start - offset;
+		if (copy > len)
+			copy = len;
+
+		/* copy out linear data */
+		ret = zctap_copy_data(zrd, copy, skb->data + offset);
+		if (ret < 0)
+			goto out;
+		offset += ret;
+		len -= ret;
+		if (len == 0 || ret != copy)
+			goto out;
+	}
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
+			ret = zctap_recv_frag(zrd, ifq, frag, off, copy);
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
+			ret = zctap_recv_skb(desc, frag_iter, off, copy);
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
+static int __io_zctap_tcp_read(struct sock *sk, struct zctap_read_desc *zrd)
+{
+	read_descriptor_t rd_desc = {
+		.arg.data = zrd,
+		.count = 1,
+	};
+
+	return tcp_read_sock(sk, &rd_desc, zctap_recv_skb);
+}
+
+static int io_zctap_tcp_recvmsg(struct sock *sk, struct zctap_read_desc *zrd,
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
+	while (zrd->recv_limit) {
+		ret = __io_zctap_tcp_read(sk, zrd);
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
+		zrd->recv_limit -= ret;
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
+	/* XXX, handle timestamping */
+
+	if (used)
+		return used;
+
+	return ret;
+}
+
+int io_zctap_recv(struct socket *sock, struct zctap_read_desc *zrd,
+		  struct msghdr *msg, unsigned int flags)
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
+	ret = io_zctap_tcp_recvmsg(sk, zrd, flags, &addr_len);
+	if (ret >= 0) {
+		msg->msg_namelen = addr_len;
+		ret = zrd->iov_space;
+	}
+	return ret;
+}
diff --git a/io_uring/zctap.h b/io_uring/zctap.h
index bb44f8e972e8..4db516707d19 100644
--- a/io_uring/zctap.h
+++ b/io_uring/zctap.h
@@ -2,10 +2,30 @@
 #ifndef IOU_ZCTAP_H
 #define IOU_ZCTAP_H
 
+struct zctap_read_desc {
+	struct io_ring_ctx *ctx;
+	struct iov_iter *iter;
+	u32 iov_space;
+	u32 iov_limit;
+	u32 recv_limit;
+
+	struct io_kiocb req;
+	u8 *buf;
+	size_t offset;
+	size_t buflen;
+
+	u16 copy_bgid;			/* XXX move to register ifq? */
+};
+
 int io_register_ifq(struct io_ring_ctx *ctx,
 		    struct io_uring_ifq_req __user *arg);
 void io_unregister_zctap_all(struct io_ring_ctx *ctx);
 
 int io_provide_ifq_region(struct io_zctap_ifq *ifq, u16 id);
 
+int io_recvzc(struct io_kiocb *req, unsigned int issue_flags);
+int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_zctap_recv(struct socket *sock, struct zctap_read_desc *zrd,
+		  struct msghdr *msg, unsigned int flags);
+
 #endif
-- 
2.30.2

