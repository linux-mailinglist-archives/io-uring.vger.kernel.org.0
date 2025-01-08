Return-Path: <io-uring+bounces-5771-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 79875A067F0
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:09:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B08E188134F
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 22:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C80A20551E;
	Wed,  8 Jan 2025 22:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="W4UAiKzT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B12C205AA8
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 22:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736374047; cv=none; b=i6aNXRkxocpKbzPxVaOntMHlYhMoG3y3XwuGpI+2vRHbG58Fj4RkoGcuOMn8mDxiGpd8WGy8kBULg7JGl72iSHTngcSfIeCjQpD0//FEz3c3XwgAFUP0lZluWOsztueuove5zFFbKg3o6ZM/bSxvxBuJ47+CY8tar52CbUOHcc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736374047; c=relaxed/simple;
	bh=rSCXub7Sr6CFfE47H/LfbpMvJVQNf6BTBpm9UI0kJ2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFErD7rniKf8RUpnvawtNVErCDu26mpAuKwQo9LHMCLSoCwo+MZcyG5GiQKXXFt7vCSy91ChS9PEdeITtn45R7TDP1jLrSA2GWUr+6RMa58a+uV5LAtafATzDxvgKBCCcgFRGzyezCWxkOlzYaYr+sK1xKBOIXsCVJ5rVMKw9E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=W4UAiKzT; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21636268e43so4120585ad.2
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 14:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736374045; x=1736978845; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O92YYKzY0H2ygBXbf/2/Y4ij/Z3R5LvC20UjCWCkSeA=;
        b=W4UAiKzTashKgx5Kf8XB/34bbyYTFKn5wod7hcoLTV1ks8nFMBPVYAiifGy4eP7u2J
         VesZHrdgoDEcN0pjcjKBWp6o91cHWCARJPQATR088+1V1aZrbGWEym48O8wcW66yrmid
         YjFzPnLdiS53m0nXyo5TMY6QmnUnLHsaE3qFaPb34PGh6I9oRj/nIjxAMFKBBmZ553py
         qBINmhnNdGu+x1UeWwmb1B5O/xuld91vfboUOnjr/suurFiVenFhRhVRuANCPuQlmlrH
         XL5o41uOzF4KSkj47+TDrGAkJspoyaj/3pj6fo1YD8hQoM54ht0r4dewvbVBG5m6Yiy+
         zDeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736374045; x=1736978845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O92YYKzY0H2ygBXbf/2/Y4ij/Z3R5LvC20UjCWCkSeA=;
        b=Sg0wwIQmo2c6YHYWgKUKA2dlzWq+VbP1xdgP3JTpcqrBVQ4ZdjQX7JPzFyRQj7LW8I
         Qw9sBAcb80UPME7RwjM1lEMFopA0v5tltUtNrex/AHD4KYc71Ai+iJMRXq8yy4rqq8FN
         EMuIUWwi1GnfW69jqRQEnf+pe2XSP/Fjil4QlY2lBul+4+fkltH2hu4p85cOXdpqph2/
         yvQVpS+Mby0GP92zhU0BjkvID/n0ydoy/Sx3EUn8YUztQsVxKX1B7zbiopCYkPGi28yP
         LVsupU7XluMHQHZz82wfk5KW4TJO645ah110rCLkKOahb/HRCw7fPd41IbCnBjsm0Cbm
         3R7w==
X-Gm-Message-State: AOJu0YxKXhWgUrIDQpO+ilIlpA3MI0FyOp2rJA5H0JzvW3dF7MQXjUPQ
	lfBLyi6xKvx1HfNpy0OWVbnldZBDI1+P3nntjt+25NcLSq3thvVVptMqBXTXKUGtpFX11JuSIW0
	A
X-Gm-Gg: ASbGnctjaT254h0vikc9DkcfW64XE6KF7cy994poOl1yuJm0+F4Jxz+XuFJMhO6Jilc
	Bld4ZrR3CVhr42Os6vtinF6T8BKENy32JT/uf5rZAzI4bNNieQcpQ8XYw9Oy2yRsM7Ywt0JSvaL
	EETPFm9wCnYd15k7RpjlqGLMzJ6Seaysbs19/YHCprwnbfEcslF3gHXCyzj5Z9mO5CxPXTndrNS
	f4Gwy1XnzrzZThxpPk2Tihy+2iwyG8o8oDWKk5N
X-Google-Smtp-Source: AGHT+IGDQuMN+gg29lAh2F0Zc3BMnlKsqFh26CwGfibI6wQ3ACaTMswTHz+YNP0Tf758TFFJ3ZFsOA==
X-Received: by 2002:a17:902:ec83:b0:215:e98c:c5d9 with SMTP id d9443c01a7336-21a83f57012mr54803325ad.18.1736374044819;
        Wed, 08 Jan 2025 14:07:24 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc96e883sm332533265ad.72.2025.01.08.14.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 14:07:24 -0800 (PST)
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
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v10 17/22] io_uring/zcrx: add io_recvzc request
Date: Wed,  8 Jan 2025 14:06:38 -0800
Message-ID: <20250108220644.3528845-18-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250108220644.3528845-1-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add io_uring opcode OP_RECV_ZC for doing zero copy reads out of a
socket. Only the connection should be land on the specific rx queue set
up for zero copy, and the socket must be handled by the io_uring
instance that the rx queue was registered for zero copy with. That's
because neither net_iovs / buffers from our queue can be read by outside
applications, nor zero copy is possible if traffic for the zero copy
connection goes to another queue. This coordination is outside of the
scope of this patch series. Also, any traffic directed to the zero copy
enabled queue is immediately visible to the application, which is why
CAP_NET_ADMIN is required at the registration step.

Of course, no data is actually read out of the socket, it has already
been copied by the netdev into userspace memory via DMA. OP_RECV_ZC
reads skbs out of the socket and checks that its frags are indeed
net_iovs that belong to io_uring. A cqe is queued for each one of these
frags.

Recall that each cqe is a big cqe, with the top half being an
io_uring_zcrx_cqe. The cqe res field contains the len or error. The
lower IORING_ZCRX_AREA_SHIFT bits of the struct io_uring_zcrx_cqe::off
field contain the offset relative to the start of the zero copy area.
The upper part of the off field is trivially zero, and will be used
to carry the area id.

For now, there is no limit as to how much work each OP_RECV_ZC request
does. It will attempt to drain a socket of all available data. This
request always operates in multishot mode.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h |   2 +
 io_uring/io_uring.h           |  10 ++
 io_uring/net.c                |  72 +++++++++++++
 io_uring/opdef.c              |  16 +++
 io_uring/zcrx.c               | 190 +++++++++++++++++++++++++++++++++-
 io_uring/zcrx.h               |  13 +++
 6 files changed, 302 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e251f28507ce..b919a541d44f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -87,6 +87,7 @@ struct io_uring_sqe {
 	union {
 		__s32	splice_fd_in;
 		__u32	file_index;
+		__u32	zcrx_ifq_idx;
 		__u32	optlen;
 		struct {
 			__u16	addr_len;
@@ -278,6 +279,7 @@ enum io_uring_op {
 	IORING_OP_FTRUNCATE,
 	IORING_OP_BIND,
 	IORING_OP_LISTEN,
+	IORING_OP_RECV_ZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 032758b28d78..2b1ce5539bfe 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -184,6 +184,16 @@ static inline bool io_get_cqe(struct io_ring_ctx *ctx, struct io_uring_cqe **ret
 	return io_get_cqe_overflow(ctx, ret, false);
 }
 
+static inline bool io_defer_get_uncommited_cqe(struct io_ring_ctx *ctx,
+					       struct io_uring_cqe **cqe_ret)
+{
+	io_lockdep_assert_cq_locked(ctx);
+
+	ctx->cq_extra++;
+	ctx->submit_state.cq_flush = true;
+	return io_get_cqe(ctx, cqe_ret);
+}
+
 static __always_inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
 					    struct io_kiocb *req)
 {
diff --git a/io_uring/net.c b/io_uring/net.c
index 8457408194e7..5d8b9a016766 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -16,6 +16,7 @@
 #include "net.h"
 #include "notif.h"
 #include "rsrc.h"
+#include "zcrx.h"
 
 #if defined(CONFIG_NET)
 struct io_shutdown {
@@ -88,6 +89,13 @@ struct io_sr_msg {
  */
 #define MULTISHOT_MAX_RETRY	32
 
+struct io_recvzc {
+	struct file			*file;
+	unsigned			msg_flags;
+	u16				flags;
+	struct io_zcrx_ifq		*ifq;
+};
+
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_shutdown *shutdown = io_kiocb_to_cmd(req, struct io_shutdown);
@@ -1209,6 +1217,70 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
+int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
+	unsigned ifq_idx;
+
+	if (unlikely(sqe->file_index || sqe->addr2 || sqe->addr ||
+		     sqe->len || sqe->addr3))
+		return -EINVAL;
+
+	ifq_idx = READ_ONCE(sqe->zcrx_ifq_idx);
+	if (ifq_idx != 0)
+		return -EINVAL;
+	zc->ifq = req->ctx->ifq;
+	if (!zc->ifq)
+		return -EINVAL;
+
+	zc->flags = READ_ONCE(sqe->ioprio);
+	zc->msg_flags = READ_ONCE(sqe->msg_flags);
+	if (zc->msg_flags)
+		return -EINVAL;
+	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST | IORING_RECV_MULTISHOT))
+		return -EINVAL;
+	/* multishot required */
+	if (!(zc->flags & IORING_RECV_MULTISHOT))
+		return -EINVAL;
+	/* All data completions are posted as aux CQEs. */
+	req->flags |= REQ_F_APOLL_MULTISHOT;
+
+	return 0;
+}
+
+int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
+	struct socket *sock;
+	int ret;
+
+	if (!(req->flags & REQ_F_POLLED) &&
+	    (zc->flags & IORING_RECVSEND_POLL_FIRST))
+		return -EAGAIN;
+
+	sock = sock_from_file(req->file);
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+	ret = io_zcrx_recv(req, zc->ifq, sock, zc->msg_flags | MSG_DONTWAIT,
+			   issue_flags);
+	if (unlikely(ret <= 0) && ret != -EAGAIN) {
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
index 3de75eca1c92..6ae00c0af9a8 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -36,6 +36,7 @@
 #include "waitid.h"
 #include "futex.h"
 #include "truncate.h"
+#include "zcrx.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -513,6 +514,18 @@ const struct io_issue_def io_issue_defs[] = {
 		.async_size		= sizeof(struct io_async_msghdr),
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
@@ -744,6 +757,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_LISTEN] = {
 		.name			= "LISTEN",
 	},
+	[IORING_OP_RECV_ZC] = {
+		.name			= "RECV_ZC",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 273bad4d86a2..036de2981e64 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -13,6 +13,8 @@
 #include <net/netlink.h>
 
 #include <trace/events/page_pool.h>
+#include <net/tcp.h>
+#include <net/rps.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -100,7 +102,12 @@ static void io_zcrx_sync_for_device(const struct page_pool *pool,
 
 #define IO_RQ_MAX_ENTRIES		32768
 
-__maybe_unused
+struct io_zcrx_args {
+	struct io_kiocb		*req;
+	struct io_zcrx_ifq	*ifq;
+	struct socket		*sock;
+};
+
 static const struct memory_provider_ops io_uring_pp_zc_ops;
 
 static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *niov)
@@ -127,6 +134,11 @@ static bool io_zcrx_put_niov_uref(struct net_iov *niov)
 	return true;
 }
 
+static void io_zcrx_get_niov_uref(struct net_iov *niov)
+{
+	atomic_inc(io_get_user_counter(niov));
+}
+
 static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 				 struct io_uring_zcrx_ifq_reg *reg,
 				 struct io_uring_region_desc *rd)
@@ -594,3 +606,179 @@ static const struct memory_provider_ops io_uring_pp_zc_ops = {
 	.destroy		= io_pp_zc_destroy,
 	.nl_fill		= io_pp_nl_fill,
 };
+
+static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
+			      struct io_zcrx_ifq *ifq, int off, int len)
+{
+	struct io_uring_zcrx_cqe *rcqe;
+	struct io_zcrx_area *area;
+	struct io_uring_cqe *cqe;
+	u64 offset;
+
+	if (!io_defer_get_uncommited_cqe(req->ctx, &cqe))
+		return false;
+
+	cqe->user_data = req->cqe.user_data;
+	cqe->res = len;
+	cqe->flags = IORING_CQE_F_MORE;
+
+	area = io_zcrx_iov_to_area(niov);
+	offset = off + (net_iov_idx(niov) << PAGE_SHIFT);
+	rcqe = (struct io_uring_zcrx_cqe *)(cqe + 1);
+	rcqe->off = offset + ((u64)area->area_id << IORING_ZCRX_AREA_SHIFT);
+	rcqe->__pad = 0;
+	return true;
+}
+
+static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
+			     const skb_frag_t *frag, int off, int len)
+{
+	struct net_iov *niov;
+
+	if (unlikely(!skb_frag_is_net_iov(frag)))
+		return -EOPNOTSUPP;
+
+	niov = netmem_to_net_iov(frag->netmem);
+	if (niov->pp->mp_ops != &io_uring_pp_zc_ops ||
+	    niov->pp->mp_priv != ifq)
+		return -EFAULT;
+
+	if (!io_zcrx_queue_cqe(req, niov, ifq, off + skb_frag_off(frag), len))
+		return -ENOSPC;
+
+	/*
+	 * Prevent it from being recycled while user is accessing it.
+	 * It has to be done before grabbing a user reference.
+	 */
+	page_pool_ref_netmem(net_iov_to_netmem(niov));
+	io_zcrx_get_niov_uref(niov);
+	return len;
+}
+
+static int
+io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
+		 unsigned int offset, size_t len)
+{
+	struct io_zcrx_args *args = desc->arg.data;
+	struct io_zcrx_ifq *ifq = args->ifq;
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
+			ret = io_zcrx_recv_frag(req, ifq, frag, off, copy);
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
+			ret = io_zcrx_recv_skb(desc, frag_iter, off, copy);
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
+static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
+				struct sock *sk, int flags,
+				unsigned issue_flags)
+{
+	struct io_zcrx_args args = {
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
+	ret = tcp_read_sock(sk, &rd_desc, io_zcrx_recv_skb);
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
+	} else if (sock_flag(sk, SOCK_DONE)) {
+		/* Make it to retry until it finally gets 0. */
+		if (issue_flags & IO_URING_F_MULTISHOT)
+			ret = IOU_REQUEUE;
+		else
+			ret = -EAGAIN;
+	}
+out:
+	release_sock(sk);
+	return ret;
+}
+
+int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
+		 struct socket *sock, unsigned int flags,
+		 unsigned issue_flags)
+{
+	struct sock *sk = sock->sk;
+	const struct proto *prot = READ_ONCE(sk->sk_prot);
+
+	if (prot->recvmsg != tcp_recvmsg)
+		return -EPROTONOSUPPORT;
+
+	sock_rps_record_flow(sk);
+	return io_zcrx_tcp_recvmsg(req, ifq, sk, flags, issue_flags);
+}
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index beacf1ea6380..65e92756720f 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -3,6 +3,7 @@
 #define IOU_ZC_RX_H
 
 #include <linux/io_uring_types.h>
+#include <linux/socket.h>
 #include <net/page_pool/types.h>
 #include <net/net_trackers.h>
 
@@ -41,6 +42,9 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			 struct io_uring_zcrx_ifq_reg __user *arg);
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx);
 void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx);
+int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
+		 struct socket *sock, unsigned int flags,
+		 unsigned issue_flags);
 #else
 static inline int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 					struct io_uring_zcrx_ifq_reg __user *arg)
@@ -53,6 +57,15 @@ static inline void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 static inline void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 }
+static inline int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
+			       struct socket *sock, unsigned int flags,
+			       unsigned issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
+int io_recvzc(struct io_kiocb *req, unsigned int issue_flags);
+int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+
 #endif
-- 
2.43.5


