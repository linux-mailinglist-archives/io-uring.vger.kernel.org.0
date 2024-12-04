Return-Path: <io-uring+bounces-5225-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CB2C9E42D8
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 19:05:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E997DBC0BE6
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB84A215F4D;
	Wed,  4 Dec 2024 17:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="X3nTMss8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EA5215F61
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332979; cv=none; b=q818k2ww+0UrZXm0ucEgni93mggqPQbTJBU0Nyv38Yeq1rZ9oT5oPT5hm+e/bshcHzjx31NWJce19Tr4+b/HFkBdK/T8ASYx+8JKgEsp80QXO5q5+BgpfEtcF2uQbFiibdneheaMYqs9lHtzXHXIH0n1YfsUUOZ8q8c8ggkJ9j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332979; c=relaxed/simple;
	bh=x/uZA805S3iVIhd3bfJ1Xb1AvU2SLvAinmwQ3ZLvkDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUnmtePi6f8Tv/5cFMNmtsu06gRmS20cfu0064HrxFvcNNlX0l3HCQjff/ZIlSKRdK3GyaUJnU98BD7iq3XwLCcshrqscedWIjMUdw7BkUC91cvpn1TcWd1K5O6ZizP9WvQaxVcMCOaL1jHENcQFEAYLzTfk72MS0P/oz0CdfoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=X3nTMss8; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-215666ea06aso10143335ad.0
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1733332977; x=1733937777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=36AKyg8XNehMVPLo0eGDF2m2iBOmxflwQFk/rKqTLQo=;
        b=X3nTMss8K7wEAzl4hwwP8zpOoaQoqBVXvMOzYBwAtGK1B38G81r5L0QLjfW3TqDvd7
         FgYK/BmR4zBgpsLHuAK/GYqhPZgFpnAVV1d6CjaP4IZ3fNRFlvzMJ5VaGIo6rTF514uF
         UAAzCU70jNfGSvANwVy7BtPgNlaX5rKz7+MyiAMfg2TGaX2ueRpc1uXlmIHK8AHLbzEX
         u92hYHU/KSMp5MIgEN2wZyF6OhmU+ImvxL6a3G9R0V6cLK4J+IFEcD4ufP94DJWBKO7+
         dVtodhT7C9d/kt9mkXZ/fZtg+K9zPC20D6gY6j2ij0sFLb0D7qmihV+a+A7otSifZWZB
         0PWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733332977; x=1733937777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=36AKyg8XNehMVPLo0eGDF2m2iBOmxflwQFk/rKqTLQo=;
        b=ITTwWt+szKIXpz6GuZWoj2DdfDUSNWfv5fGQujrAiMWI0J9Xlk4wAPk440MHJ2oZb5
         KKmyxsRTzyp6kF9OAkQkqzb89a/wyKPr5gx9WY57gNyxcoF0ToMUKkI0s0iIZw9WFXXf
         lxdS/8SoJA+oNrQjYSUBx4UfvoylYSMDEYmiESuO0a9gJRYhd7302ldXioiONlssWyh/
         yx0epwd1We/dZJY8jGJbjPmm6YY4gMbGemR6B1T9tKRM+Xxw66tjH+WvDGK//MtFHMDM
         z5ra4EmqMsdxCfWLPm6W7Ju/yGFsCfIaFkJjR/z+olej/hljJSFBn3HRD7aCrICzWoCf
         y9XQ==
X-Gm-Message-State: AOJu0Yyg44S8J1xVOLMy3WZdp9MnBZUn1rRFfwXC9ygD62s56Dmg8RgI
	186H6JFdQzwFIxe0JXjJA3yeCjUEhkzbUStfgL0UPFB5B0z53KMYWT3MauomnAMDOBkPkmLGU/R
	6
X-Gm-Gg: ASbGncsuERsF78LwJYpEqwioUcpN6R08Ks0Hk8C+NJMdukVV+iRIPTLTErNsTGT65yM
	SMGXWThwBPX3SWyv0Ma3iJqPM7CXw7vRke8xPViq9MexN3WqPlgZpGBTS8ig5LQcMqTxRA8DnYA
	VAyBMI689gtgSE6TQ6b1urIuo2oiX3+TeAEBdlt+0uSsvHtMRZ5hfJGpaX74dGKdM1yA1aLNAVM
	66OhBrl3ONve+6kRIe+pbgYiuK01X2ecg==
X-Google-Smtp-Source: AGHT+IGzx/c2WVMwensNoW5kMz0LaqsR6R0VjtGxt2XKoBe6e2/suMvQRNbm1Iju6RoPSXD6zETw7w==
X-Received: by 2002:a17:902:e743:b0:215:5d8c:7e3f with SMTP id d9443c01a7336-215f3cfb7f8mr1957905ad.23.1733332977439;
        Wed, 04 Dec 2024 09:22:57 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215609fadb6sm78440225ad.243.2024.12.04.09.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 09:22:56 -0800 (PST)
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
Subject: [PATCH net-next v8 12/17] io_uring/zcrx: add io_recvzc request
Date: Wed,  4 Dec 2024 09:21:51 -0800
Message-ID: <20241204172204.4180482-13-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241204172204.4180482-1-dw@davidwei.uk>
References: <20241204172204.4180482-1-dw@davidwei.uk>
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
CAP_NET_ADMIN is required at the registeration step.

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
 io_uring/zcrx.c               | 186 +++++++++++++++++++++++++++++++++-
 io_uring/zcrx.h               |  13 +++
 6 files changed, 298 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7d72de92378d..6a8ee24a79c6 100644
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
@@ -262,6 +263,7 @@ enum io_uring_op {
 	IORING_OP_FTRUNCATE,
 	IORING_OP_BIND,
 	IORING_OP_LISTEN,
+	IORING_OP_RECV_ZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 4070d4c8ef97..0f54d73b80c5 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -182,6 +182,16 @@ static inline bool io_get_cqe(struct io_ring_ctx *ctx, struct io_uring_cqe **ret
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
index df1f7dc6f1c8..f1431317182e 100644
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
@@ -1208,6 +1216,70 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
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
index 7919f5e52c73..004730d16e8f 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -8,6 +8,8 @@
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/memory_provider.h>
 #include <trace/events/page_pool.h>
+#include <net/tcp.h>
+#include <net/rps.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -19,7 +21,12 @@
 
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
@@ -257,6 +264,11 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 	lockdep_assert_held(&ctx->uring_lock);
 }
 
+static void io_zcrx_get_buf_uref(struct net_iov *niov)
+{
+	atomic_long_add(IO_ZC_RX_UREF, &niov->pp_ref_count);
+}
+
 static bool io_zcrx_niov_put(struct net_iov *niov, int nr)
 {
 	return atomic_long_sub_and_test(nr, &niov->pp_ref_count);
@@ -453,3 +465,175 @@ static const struct memory_provider_ops io_uring_pp_zc_ops = {
 	.destroy		= io_pp_zc_destroy,
 	.scrub			= io_pp_zc_scrub,
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
+	off += skb_frag_off(frag);
+
+	if (unlikely(!skb_frag_is_net_iov(frag)))
+		return -EOPNOTSUPP;
+
+	niov = netmem_to_net_iov(frag->netmem);
+	if (niov->pp->mp_ops != &io_uring_pp_zc_ops ||
+	    niov->pp->mp_priv != ifq)
+		return -EFAULT;
+
+	if (!io_zcrx_queue_cqe(req, niov, ifq, off, len))
+		return -ENOSPC;
+	io_zcrx_get_buf_uref(niov);
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
+				unsigned int issue_flags)
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
+		 unsigned int issue_flags)
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
index 8515cde78a2c..ffc3e333b4af 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -3,6 +3,7 @@
 #define IOU_ZC_RX_H
 
 #include <linux/io_uring_types.h>
+#include <linux/socket.h>
 #include <net/page_pool/types.h>
 
 #define IO_ZC_RX_UREF			0x10000
@@ -42,6 +43,9 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			 struct io_uring_zcrx_ifq_reg __user *arg);
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx);
 void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx);
+int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
+		 struct socket *sock, unsigned int flags,
+		 unsigned int issue_flags);
 #else
 static inline int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 					struct io_uring_zcrx_ifq_reg __user *arg)
@@ -54,6 +58,15 @@ static inline void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 static inline void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 }
+static inline int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
+			       struct socket *sock, unsigned int flags,
+			       unsigned int issue_flags)
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


