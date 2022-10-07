Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140445F7F98
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 23:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiJGVRa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Fri, 7 Oct 2022 17:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiJGVR3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 17:17:29 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41CC32A8A
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 14:17:17 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 297I5hrp027849
        for <io-uring@vger.kernel.org>; Fri, 7 Oct 2022 14:17:17 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3k2hshchb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 07 Oct 2022 14:17:17 -0700
Received: from twshared3028.05.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 7 Oct 2022 14:17:16 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 8977221DAFDA8; Fri,  7 Oct 2022 14:17:13 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
Subject: [RFC v1 9/9] io_uring: add OP_RECV_ZC command.
Date:   Fri, 7 Oct 2022 14:17:13 -0700
Message-ID: <20221007211713.170714-10-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221007211713.170714-1-jonathan.lemon@gmail.com>
References: <20221007211713.170714-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 7g-0Z_DVOEdsEw4ppzH8TtXizIBvRwGj
X-Proofpoint-GUID: 7g-0Z_DVOEdsEw4ppzH8TtXizIBvRwGj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-07_04,2022-10-07_01,2022-06-22_01
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
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
 io_uring/net.c                | 123 ++++++++++++
 io_uring/opdef.c              |  14 ++
 io_uring/zctap.c              | 354 ++++++++++++++++++++++++++++++++++
 io_uring/zctap.h              |   5 +
 5 files changed, 497 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 145d55280919..3c31a966687e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -207,6 +207,7 @@ enum io_uring_op {
 	IORING_OP_URING_CMD,
 	IORING_OP_SEND_ZC,
 	IORING_OP_PROVIDE_IFQ_REGION,
+	IORING_OP_RECV_ZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/net.c b/io_uring/net.c
index 60e392f7f2dc..89c57ad83a79 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -16,6 +16,7 @@
 #include "net.h"
 #include "notif.h"
 #include "rsrc.h"
+#include "zctap.h"
 
 #if defined(CONFIG_NET)
 struct io_shutdown {
@@ -73,6 +74,14 @@ struct io_sendzc {
 	struct io_kiocb 		*notif;
 };
 
+struct io_recvzc {
+	struct io_sr_msg		sr;
+	struct io_zctap_ifq		*ifq;
+	u32				datalen;
+	u16				ifq_id;
+	u16				copy_bgid;
+};
+
 #define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
 
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -879,6 +888,120 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
+int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
+	u64 recvzc_cmd;
+	u16 ifq_id;
+
+	/* XXX hack so we can temporarily use io_recvmsg_prep */
+	recvzc_cmd = READ_ONCE(sqe->addr3);
+
+	ifq_id = recvzc_cmd & 0xffff;
+	zc->copy_bgid = (recvzc_cmd >> 16) & 0xffff;
+	zc->datalen = recvzc_cmd >> 32;
+
+	zc->ifq = xa_load(&req->ctx->zctap_ifq_xa, ifq_id);
+	if (!zc->ifq)
+		return -EINVAL;
+	if (zc->ifq->ctx != req->ctx)
+		return -EINVAL;
+
+	return io_recvmsg_prep(req, sqe);
+}
+
+int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
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
+	ret = io_zctap_recv(zc->ifq, sock, &msg, flags, zc->datalen,
+			    zc->copy_bgid);
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
 void io_sendzc_cleanup(struct io_kiocb *req)
 {
 	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index bf28c43117c3..f3782e7b707b 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -497,6 +497,20 @@ const struct io_op_def io_op_defs[] = {
 		.prep			= io_provide_ifq_region_prep,
 		.issue			= io_provide_ifq_region,
 	},
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
+#endif
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index 8bebe7c36c82..1d334ac55c0b 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -7,6 +7,7 @@
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
 #include <linux/nospec.h>
+#include <net/tcp.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -393,3 +394,356 @@ bool io_zctap_ifq_put_page(struct io_zctap_ifq *ifq, struct page *page)
 
 	return true;
 }
+
+static inline bool
+zctap_skb_ours(struct sk_buff *skb)
+{
+	return skb->pp_recycle;
+}
+
+struct zctap_read_desc {
+	struct iov_iter *iter;
+	struct ifq_region *ifr;
+	u32 iov_space;
+	u32 iov_limit;
+	u32 recv_limit;
+
+	struct io_kiocb req;
+	u8 *buf;
+	size_t offset;
+	size_t buflen;
+
+	struct io_zctap_ifq *ifq;
+	u16 ifq_id;
+	u16 copy_bgid;			/* XXX move to register ifq? */
+};
+
+static int __zctap_get_user_buffer(struct zctap_read_desc *ztr, int len)
+{
+	if (!ztr->buflen) {
+		ztr->req = (struct io_kiocb) {
+			.ctx = ztr->ifq->ctx,
+			.buf_index = ztr->copy_bgid,
+		};
+
+		ztr->buf = (u8 *)io_zctap_buffer(&ztr->req, &ztr->buflen);
+		ztr->offset = 0;
+	}
+	return len > ztr->buflen ? ztr->buflen : len;
+}
+
+static int zctap_copy_data(struct zctap_read_desc *ztr, int len, u8 *kaddr)
+{
+	struct io_uring_zctap_iov zov;
+	u32 space;
+	int err;
+
+	space = ztr->iov_space + sizeof(zov);
+	if (space > ztr->iov_limit)
+		return 0;
+
+	len = __zctap_get_user_buffer(ztr, len);
+	if (!len)
+		return -ENOBUFS;
+
+	err = copy_to_user(ztr->buf + ztr->offset, kaddr, len);
+	if (err)
+		return -EFAULT;
+
+	zov = (struct io_uring_zctap_iov) {
+		.off = ztr->offset,
+		.len = len,
+		.bgid = ztr->copy_bgid,
+		.bid = ztr->req.buf_index,
+		.ifq_id = ztr->ifq_id,
+	};
+
+	if (copy_to_iter(&zov, sizeof(zov), ztr->iter) != sizeof(zov))
+		return -EFAULT;
+
+	ztr->offset += len;
+	ztr->buflen -= len;
+
+	ztr->iov_space = space;
+
+	return len;
+}
+
+static int zctap_copy_frag(struct zctap_read_desc *ztr, struct page *page,
+			   int off, int len, int id,
+			   struct io_uring_zctap_iov *zov)
+{
+	u8 *kaddr;
+	int err;
+
+	len = __zctap_get_user_buffer(ztr, len);
+	if (!len)
+		return -ENOBUFS;
+
+	if (id == 0) {
+		kaddr = kmap(page) + off;
+		err = copy_to_user(ztr->buf + ztr->offset, kaddr, len);
+		kunmap(page);
+	} else {
+		kaddr = page_address(page) + off;
+		err = copy_to_user(ztr->buf + ztr->offset, kaddr, len);
+	}
+
+	if (err)
+		return -EFAULT;
+
+	*zov = (struct io_uring_zctap_iov) {
+		.off = ztr->offset,
+		.len = len,
+		.bgid = ztr->copy_bgid,
+		.bid = ztr->req.buf_index,
+		.ifq_id = ztr->ifq_id,
+	};
+
+	ztr->offset += len;
+	ztr->buflen -= len;
+
+	return len;
+}
+
+static int zctap_recv_frag(struct zctap_read_desc *ztr,
+			   const skb_frag_t *frag, int off, int len)
+{
+	struct io_uring_zctap_iov zov;
+	struct page *page;
+	int id, pgid;
+	u32 space;
+
+	space = ztr->iov_space + sizeof(zov);
+	if (space > ztr->iov_limit)
+		return 0;
+
+	page = skb_frag_page(frag);
+	id = zctap_page_ifq_id(page);
+	off += skb_frag_off(frag);
+
+	if (likely(id == ztr->ifq_id)) {
+		pgid = zctap_page_id(page);
+		io_add_page_uref(ztr->ifr, pgid);
+		zov = (struct io_uring_zctap_iov) {
+			.off = off,
+			.len = len,
+			.bgid = zctap_page_region_id(page),
+			.bid = pgid,
+			.ifq_id = id,
+		};
+	} else {
+		len = zctap_copy_frag(ztr, page, off, len, id, &zov);
+		if (len <= 0)
+			return len;
+	}
+
+	if (copy_to_iter(&zov, sizeof(zov), ztr->iter) != sizeof(zov))
+		return -EFAULT;
+
+	ztr->iov_space = space;
+
+	return len;
+}
+
+/* Our version of __skb_datagram_iter  -- should work for UDP also. */
+static int
+zctap_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
+	       unsigned int offset, size_t len)
+{
+	struct zctap_read_desc *ztr = desc->arg.data;
+	unsigned start, start_off;
+	struct sk_buff *frag_iter;
+	int i, copy, end, ret = 0;
+
+	if (ztr->iov_space >= ztr->iov_limit) {
+		desc->count = 0;
+		return 0;
+	}
+	if (len > ztr->recv_limit)
+		len = ztr->recv_limit;
+
+	start = skb_headlen(skb);
+	start_off = offset;
+
+	if (offset < start) {
+		copy = start - offset;
+		if (copy > len)
+			copy = len;
+
+		/* copy out linear data */
+		ret = zctap_copy_data(ztr, copy, skb->data + offset);
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
+			ret = zctap_recv_frag(ztr, frag, offset - start, copy);
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
+			int off;
+
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
+int io_zctap_recv(struct io_zctap_ifq *ifq, struct socket *sock,
+		  struct msghdr *msg, int flags, u32 datalen, u16 copy_bgid)
+{
+	struct sock *sk = sock->sk;
+	struct zctap_read_desc zrd = {
+		.iov_limit = msg_data_left(msg),
+		.recv_limit = datalen,
+		.iter = &msg->msg_iter,
+		.ifq = ifq,
+		.ifq_id = ifq->id,
+		.copy_bgid = copy_bgid,
+		.ifr = ifq->region,
+	};
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
+	ret = io_zctap_tcp_recvmsg(sk, &zrd, flags, &addr_len);
+	if (ret >= 0) {
+		msg->msg_namelen = addr_len;
+		ret = zrd.iov_space;
+	}
+	return ret;
+}
diff --git a/io_uring/zctap.h b/io_uring/zctap.h
index 709c803220f4..2c3e23a6a07a 100644
--- a/io_uring/zctap.h
+++ b/io_uring/zctap.h
@@ -12,4 +12,9 @@ int io_provide_ifq_region_prep(struct io_kiocb *req,
                                const struct io_uring_sqe *sqe);
 int io_provide_ifq_region(struct io_kiocb *req, unsigned int issue_flags);
 
+int io_recvzc(struct io_kiocb *req, unsigned int issue_flags);
+int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_zctap_recv(struct io_zctap_ifq *ifq, struct socket *sock,
+		  struct msghdr *msg, int flags, u32 datalen, u16 copy_bgid);
+
 #endif
-- 
2.30.2

