Return-Path: <io-uring+bounces-911-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBB02879DC8
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 22:47:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58CC81F228B4
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 21:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 349A3145B38;
	Tue, 12 Mar 2024 21:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="kuW/KzYd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9325A145339
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 21:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279885; cv=none; b=Jk5+zePckr2AoUAwU6h80GMNNFdxYZ2r8ODPzE+PcRbxv8PrSHVQ+EGfdQktiVUMHkS2MPASL9kkguzEeH3sAGaITnccQPiZKzl1hBWw7DVjhqcITX/Qwa0Hl+HuE1voBf9x67hFLgoqlaaPz3W9+CD77OqShXtFSxYNPMFQc8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279885; c=relaxed/simple;
	bh=jq3KJoKRpx3fmCjnE4Ssin7zDmiZaX04toiitKi+c6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3pv4WE7nrA8ByllMUh0/GMam1+acgFiUzuWLd1jiEJjAEhobk/4anMrSPo8qP0pWDg9U4YnReJaXrgHJmqpNtSUV1h1BFVRlhLgwg9lc2sbCUz4zWKsJ958lpX+V08ZSGPn3aiCuMBICullnT6V/Wn3ew2dTtAv1GVlQFcY41Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=kuW/KzYd; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e6b22af648so239829b3a.0
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 14:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1710279883; x=1710884683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1e150jmPmcmnhUwqwkgkSEpSo+j9RzHXKffT0azea6k=;
        b=kuW/KzYdlboaUiJr8cZG++jpTJOCEXicDox+JBgn0WvYs0sBYaMLZRHG9jjMxOyDv/
         FEdbUy7HibOvi6hjxXi/LypGDibkCVIJfqu2/vvCF/0HtGlCtgIsxsN2pp4loDGuqsHj
         PC0ETXP87eEOXH6n+8Rp9vTX9BibUXDnDRbFF5/fUanThkc7Mb2TKcUv4zMB2BswQwWO
         yHCZdA+caFAHLSKoYV0I+QH0JJPQU5aKorJCBugvbgXjBJRpVJlMOmfB87fnrCe9nBkU
         lljI/K0YwsqjJSacGWFT7mGiicBJAmB2kz5aQTrWsZDkSRl5xmwpRYsUFQeDkxQh23Da
         4GjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710279883; x=1710884683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1e150jmPmcmnhUwqwkgkSEpSo+j9RzHXKffT0azea6k=;
        b=emYpC3SAtNcUdcc56BDvuzLQLhuqlqH+YMD52wt1sl0qn/jORcKnA0J9SRJwwq0t4b
         j7tO/K/mgoSVu0o9vKDoWTz/b3Kmx67Ytiwrsx8A59acS360YFfprwpnoYcMUQRud9hX
         BmKUpVaLjwzkrpU8+qshpg2Hf0G3bXcrI+NjWCp39S1CsmSoBPgQBE22lppFQtwZhEKX
         ogOK/IsEoY5Ks9Bc/TXyUcSkE1fzFVLmATI8TeyTZ9NiZJR1knM2M30XoqoMnSUtl+hn
         3u84f251+tjyb4Soa62WHczKrmEUOjvxhu+iAExuH4husmoA1yK24jZDwCawvZzYxm4E
         hoyA==
X-Gm-Message-State: AOJu0Yy8eBerRYSCkLoyCVpvGm+GWakYscwg+lIt0IsZsqpU21lGZfGz
	eQN/DeRrax9x1yWD+78CHYM2wc17MH2eaJX3mJOq+zmf0LhgsInTq8MErmLDe1gbHcJQ4LXrY9d
	a
X-Google-Smtp-Source: AGHT+IHOcvscYPKCK8J8fb8jWUvnptRIGd04d9aE24Qi4deIrOQGZ1H1ukCkgOC6LYYroq04Cm9CVQ==
X-Received: by 2002:a05:6a20:3d02:b0:1a1:841a:33ef with SMTP id y2-20020a056a203d0200b001a1841a33efmr1130568pzi.3.1710279882656;
        Tue, 12 Mar 2024 14:44:42 -0700 (PDT)
Received: from localhost (fwdproxy-prn-006.fbsv.net. [2a03:2880:ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id w2-20020aa79a02000000b006e6931a50e8sm4177179pfj.79.2024.03.12.14.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 14:44:42 -0700 (PDT)
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
Subject: [RFC PATCH v4 09/16] io_uring/zcrx: implement socket registration
Date: Tue, 12 Mar 2024 14:44:23 -0700
Message-ID: <20240312214430.2923019-10-dw@davidwei.uk>
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

From: Pavel Begunkov <asml.silence@gmail.com>

We want userspace to explicitly list all sockets it'll be using with a
particular zc ifq, so we can properly configure them, e.g. binding the
sockets to the corresponding interface and setting steering rules. We'll
also need it to better control ifq lifetime and for
termination / unregistration purposes.

TODO: remove zc_rx_idx from struct socket, which will fix zc_rx_idx
token init races and re-registration bug.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/net.h           |  2 +
 include/uapi/linux/io_uring.h |  7 +++
 io_uring/net.c                | 20 ++++++++
 io_uring/register.c           |  6 +++
 io_uring/zc_rx.c              | 91 +++++++++++++++++++++++++++++++++--
 io_uring/zc_rx.h              | 17 +++++++
 net/socket.c                  |  1 +
 7 files changed, 141 insertions(+), 3 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index c9b4a63791a4..867061a91d30 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -126,6 +126,8 @@ struct socket {
 	const struct proto_ops	*ops; /* Might change with IPV6_ADDRFORM or MPTCP. */
 
 	struct socket_wq	wq;
+
+	unsigned		zc_rx_idx;
 };
 
 /*
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a085ed60478f..26e945e6258d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -579,6 +579,7 @@ enum {
 
 	/* register a network interface queue for zerocopy */
 	IORING_REGISTER_ZC_RX_IFQ		= 29,
+	IORING_REGISTER_ZC_RX_SOCK		= 30,
 
 	/* this goes last */
 	IORING_REGISTER_LAST,
@@ -824,6 +825,12 @@ struct io_uring_zc_rx_ifq_reg {
 	struct io_rbuf_rqring_offsets rq_off;
 };
 
+struct io_uring_zc_rx_sock_reg {
+	__u32	sockfd;
+	__u32	zc_rx_ifq_idx;
+	__u32	__resv[2];
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/net.c b/io_uring/net.c
index 54dff492e064..1fa7c1fa6b5d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -16,6 +16,7 @@
 #include "net.h"
 #include "notif.h"
 #include "rsrc.h"
+#include "zc_rx.h"
 
 #if defined(CONFIG_NET)
 struct io_shutdown {
@@ -1033,6 +1034,25 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
+static __maybe_unused
+struct io_zc_rx_ifq *io_zc_verify_sock(struct io_kiocb *req,
+					struct socket *sock)
+{
+	unsigned token = READ_ONCE(sock->zc_rx_idx);
+	unsigned ifq_idx = token >> IO_ZC_IFQ_IDX_OFFSET;
+	unsigned sock_idx = token & IO_ZC_IFQ_IDX_MASK;
+	struct io_zc_rx_ifq *ifq;
+
+	if (ifq_idx)
+		return NULL;
+	ifq = req->ctx->ifq;
+	if (!ifq || sock_idx >= ifq->nr_sockets)
+		return NULL;
+	if (ifq->sockets[sock_idx] != req->file)
+		return NULL;
+	return ifq;
+}
+
 void io_send_zc_cleanup(struct io_kiocb *req)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
diff --git a/io_uring/register.c b/io_uring/register.c
index 760f0b6a051c..7f40403a1716 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -570,6 +570,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_zc_rx_ifq(ctx, arg);
 		break;
+	case IORING_REGISTER_ZC_RX_SOCK:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_zc_rx_sock(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 521eeea04f9d..77459c0fc14b 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -5,12 +5,15 @@
 #include <linux/mm.h>
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
+#include <net/tcp.h>
+#include <net/af_unix.h>
 
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
 #include "kbuf.h"
 #include "zc_rx.h"
+#include "rsrc.h"
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 
@@ -76,10 +79,31 @@ static struct io_zc_rx_ifq *io_zc_rx_ifq_alloc(struct io_ring_ctx *ctx)
 	return ifq;
 }
 
-static void io_zc_rx_ifq_free(struct io_zc_rx_ifq *ifq)
+static void io_shutdown_ifq(struct io_zc_rx_ifq *ifq)
 {
-	if (ifq->if_rxq_id != -1)
+	int i;
+
+	if (!ifq)
+		return;
+
+	for (i = 0; i < ifq->nr_sockets; i++) {
+		if (ifq->sockets[i]) {
+			fput(ifq->sockets[i]);
+			ifq->sockets[i] = NULL;
+		}
+	}
+	ifq->nr_sockets = 0;
+
+	if (ifq->if_rxq_id != -1) {
 		io_close_zc_rxq(ifq);
+		ifq->if_rxq_id = -1;
+	}
+}
+
+static void io_zc_rx_ifq_free(struct io_zc_rx_ifq *ifq)
+{
+	io_shutdown_ifq(ifq);
+
 	if (ifq->dev)
 		dev_put(ifq->dev);
 	io_free_rbuf_ring(ifq);
@@ -132,7 +156,6 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 	reg.rq_off.tail = offsetof(struct io_uring, tail);
 
 	if (copy_to_user(arg, &reg, sizeof(reg))) {
-		io_close_zc_rxq(ifq);
 		ret = -EFAULT;
 		goto err;
 	}
@@ -153,6 +176,8 @@ void io_unregister_zc_rx_ifqs(struct io_ring_ctx *ctx)
 	if (!ifq)
 		return;
 
+	WARN_ON_ONCE(ifq->nr_sockets);
+
 	ctx->ifq = NULL;
 	io_zc_rx_ifq_free(ifq);
 }
@@ -160,6 +185,66 @@ void io_unregister_zc_rx_ifqs(struct io_ring_ctx *ctx)
 void io_shutdown_zc_rx_ifqs(struct io_ring_ctx *ctx)
 {
 	lockdep_assert_held(&ctx->uring_lock);
+
+	io_shutdown_ifq(ctx->ifq);
+}
+
+int io_register_zc_rx_sock(struct io_ring_ctx *ctx,
+			   struct io_uring_zc_rx_sock_reg __user *arg)
+{
+	struct io_uring_zc_rx_sock_reg sr;
+	struct io_zc_rx_ifq *ifq;
+	struct socket *sock;
+	struct file *file;
+	int ret = -EEXIST;
+	int idx;
+
+	if (copy_from_user(&sr, arg, sizeof(sr)))
+		return -EFAULT;
+	if (sr.__resv[0] || sr.__resv[1])
+		return -EINVAL;
+	if (sr.zc_rx_ifq_idx != 0 || !ctx->ifq)
+		return -EINVAL;
+
+	ifq = ctx->ifq;
+	if (ifq->nr_sockets >= ARRAY_SIZE(ifq->sockets))
+		return -EINVAL;
+
+	BUILD_BUG_ON(ARRAY_SIZE(ifq->sockets) > IO_ZC_IFQ_IDX_MASK);
+
+	file = fget(sr.sockfd);
+	if (!file)
+		return -EBADF;
+
+	if (!!unix_get_socket(file)) {
+		fput(file);
+		return -EBADF;
+	}
+
+	sock = sock_from_file(file);
+	if (unlikely(!sock || !sock->sk)) {
+		fput(file);
+		return -ENOTSOCK;
+	}
+
+	idx = ifq->nr_sockets;
+	lock_sock(sock->sk);
+	if (!sock->zc_rx_idx) {
+		unsigned token;
+
+		token = idx + (sr.zc_rx_ifq_idx << IO_ZC_IFQ_IDX_OFFSET);
+		WRITE_ONCE(sock->zc_rx_idx, token);
+		ret = 0;
+	}
+	release_sock(sock->sk);
+
+	if (ret) {
+		fput(file);
+		return ret;
+	}
+	ifq->sockets[idx] = file;
+	ifq->nr_sockets++;
+	return 0;
 }
 
 #endif
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
index 35b019b275e0..d7b8397d525f 100644
--- a/io_uring/zc_rx.h
+++ b/io_uring/zc_rx.h
@@ -2,6 +2,13 @@
 #ifndef IOU_ZC_RX_H
 #define IOU_ZC_RX_H
 
+#include <linux/io_uring_types.h>
+#include <linux/skbuff.h>
+
+#define IO_ZC_MAX_IFQ_SOCKETS		16
+#define IO_ZC_IFQ_IDX_OFFSET		16
+#define IO_ZC_IFQ_IDX_MASK		((1U << IO_ZC_IFQ_IDX_OFFSET) - 1)
+
 struct io_zc_rx_ifq {
 	struct io_ring_ctx		*ctx;
 	struct net_device		*dev;
@@ -11,6 +18,9 @@ struct io_zc_rx_ifq {
 
 	/* hw rx descriptor ring id */
 	u32				if_rxq_id;
+
+	unsigned			nr_sockets;
+	struct file			*sockets[IO_ZC_MAX_IFQ_SOCKETS];
 };
 
 #if defined(CONFIG_PAGE_POOL)
@@ -18,6 +28,8 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zc_rx_ifq_reg __user *arg);
 void io_unregister_zc_rx_ifqs(struct io_ring_ctx *ctx);
 void io_shutdown_zc_rx_ifqs(struct io_ring_ctx *ctx);
+int io_register_zc_rx_sock(struct io_ring_ctx *ctx,
+			   struct io_uring_zc_rx_sock_reg __user *arg);
 #else
 static inline int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zc_rx_ifq_reg __user *arg)
@@ -30,6 +42,11 @@ static inline void io_unregister_zc_rx_ifqs(struct io_ring_ctx *ctx)
 static inline void io_shutdown_zc_rx_ifqs(struct io_ring_ctx *ctx)
 {
 }
+static inline int io_register_zc_rx_sock(struct io_ring_ctx *ctx,
+				struct io_uring_zc_rx_sock_reg __user *arg)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #endif
diff --git a/net/socket.c b/net/socket.c
index c69cd0e652b8..18181a4e0295 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -637,6 +637,7 @@ struct socket *sock_alloc(void)
 
 	sock = SOCKET_I(inode);
 
+	sock->zc_rx_idx = 0;
 	inode->i_ino = get_next_ino();
 	inode->i_mode = S_IFSOCK | S_IRWXUGO;
 	inode->i_uid = current_fsuid();
-- 
2.43.0


