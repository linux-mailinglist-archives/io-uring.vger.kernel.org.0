Return-Path: <io-uring+bounces-312-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 953748191FC
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:05:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CFC7282392
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2302B3FB1D;
	Tue, 19 Dec 2023 21:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ndC5qhFj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929CA3AC30
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d3dc30ae01so9161075ad.0
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019855; x=1703624655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4hgHL/ZvjBTD8SimX6JIDvgoHS0Ce7mxEyaQY6vMoO4=;
        b=ndC5qhFj70vcYE3zzd1Z8oKtmAK7yQds9L97HIBTmUCSPXqX8eIuod2sJUCT/kWV2o
         1WD7ug9WugzyrQ5igdGgk/kAWRDxlFdbYFwl0CuL0RWE8gPOh4ydGYTiy0x/NiZmppgU
         mtahQZQjxV/il001JfBpurOMQkeSR5D2nLSNOQnSoQvGHMoQIjmwWFLtZrPK8LzuSq0U
         dvGNYlQKzdnDAM4Ohs/GTAStmdb8PmwHl2IK2YoWNwetMraxGLnQ4NbDc4D2S+hUNjzh
         HuT4P9fTYjCICCIC4kYAqbod/Y1G/5qYdBzTgns9ji2zaJ00sd93yjsAPGauz4RMDkh4
         bQ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019855; x=1703624655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4hgHL/ZvjBTD8SimX6JIDvgoHS0Ce7mxEyaQY6vMoO4=;
        b=MpkJhrmO36zD/vtJBqrMMcGh8+WWWhR3+k+hlrazoQU+0Wrcm/wa/N7I/6qpmMirX6
         hRBBAoXz3Nk0pmCTel03xAzglq40vskzgi5sOwJD/xWHsNoDCBodxYX46MI3Ze/SqpJ7
         1+IroX+xZGx9ro/4oSGCxmHz/X9O7/UxmeGFRoo4uluB774Ux3WHA3oHyLlMwmTHnGUF
         LTRV9FXWof8/WxjIvkR+DTSn7P9VXV5AYcaY2iaWbCE5yCaJf0uS8yVRbOvLUFzphVER
         3aXUWtNiH69DUWsJpIkZLy8H30Y939oSeCgiheKvycUtVUIw+OOp0ezIfiqbk9o+DU1d
         LJDw==
X-Gm-Message-State: AOJu0YxBYIAcw4vADYxk5XaVvRks59sIh3VGhK0cfoFFIYYiugAendHb
	wIRnNJgLholYF5VLbq2J1kBd+PuSfSCf5IiTacZSNg==
X-Google-Smtp-Source: AGHT+IGpRb8Vk7U6vTaxpT/fIISuWL242u8wPDqXvpB/Hrzrc8SZbdwoUsYlgc7jNB61e7DGfKmrpA==
X-Received: by 2002:a17:902:7b8d:b0:1d0:6ffd:9e36 with SMTP id w13-20020a1709027b8d00b001d06ffd9e36mr18734326pll.136.1703019855312;
        Tue, 19 Dec 2023 13:04:15 -0800 (PST)
Received: from localhost (fwdproxy-prn-015.fbsv.net. [2a03:2880:ff:f::face:b00c])
        by smtp.gmail.com with ESMTPSA id c2-20020a170902848200b001d09c539c96sm10014931plo.229.2023.12.19.13.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:15 -0800 (PST)
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
Subject: [RFC PATCH v3 11/20] io_uring/zcrx: implement socket registration
Date: Tue, 19 Dec 2023 13:03:48 -0800
Message-Id: <20231219210357.4029713-12-dw@davidwei.uk>
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
 io_uring/io_uring.c           |  6 +++
 io_uring/net.c                | 20 ++++++++
 io_uring/zc_rx.c              | 89 +++++++++++++++++++++++++++++++++--
 io_uring/zc_rx.h              | 17 +++++++
 net/socket.c                  |  1 +
 7 files changed, 139 insertions(+), 3 deletions(-)

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
index 839933e562e6..f4ba58bce3bd 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -562,6 +562,7 @@ enum {
 
 	/* register a network interface queue for zerocopy */
 	IORING_REGISTER_ZC_RX_IFQ		= 26,
+	IORING_REGISTER_ZC_RX_SOCK		= 27,
 
 	/* this goes last */
 	IORING_REGISTER_LAST,
@@ -803,6 +804,12 @@ struct io_uring_zc_rx_ifq_reg {
 	struct io_rbuf_cqring_offsets cq_off;
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
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 02d6d638bd65..47859599469d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4627,6 +4627,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
diff --git a/io_uring/net.c b/io_uring/net.c
index 75d494dad7e2..454ba301ae6b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -16,6 +16,7 @@
 #include "net.h"
 #include "notif.h"
 #include "rsrc.h"
+#include "zc_rx.h"
 
 #if defined(CONFIG_NET)
 struct io_shutdown {
@@ -955,6 +956,25 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
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
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 259e08a34ab2..06e2c54d3f3d 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -11,6 +11,7 @@
 #include "io_uring.h"
 #include "kbuf.h"
 #include "zc_rx.h"
+#include "rsrc.h"
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 
@@ -79,10 +80,31 @@ static struct io_zc_rx_ifq *io_zc_rx_ifq_alloc(struct io_ring_ctx *ctx)
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
@@ -141,7 +163,6 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 	reg.cq_off.tail = offsetof(struct io_rbuf_ring, cq.tail);
 
 	if (copy_to_user(arg, &reg, sizeof(reg))) {
-		io_close_zc_rxq(ifq);
 		ret = -EFAULT;
 		goto err;
 	}
@@ -162,6 +183,8 @@ void io_unregister_zc_rx_ifqs(struct io_ring_ctx *ctx)
 	if (!ifq)
 		return;
 
+	WARN_ON_ONCE(ifq->nr_sockets);
+
 	ctx->ifq = NULL;
 	io_zc_rx_ifq_free(ifq);
 }
@@ -169,6 +192,66 @@ void io_unregister_zc_rx_ifqs(struct io_ring_ctx *ctx)
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
+	if (io_file_need_scm(file)) {
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
+		return -EINVAL;
+	}
+	ifq->sockets[idx] = file;
+	ifq->nr_sockets++;
+	return 0;
 }
 
 #endif
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
index aab57c1a4c5d..9257dda77e92 100644
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
@@ -13,6 +20,9 @@ struct io_zc_rx_ifq {
 
 	/* hw rx descriptor ring id */
 	u32				if_rxq_id;
+
+	unsigned			nr_sockets;
+	struct file			*sockets[IO_ZC_MAX_IFQ_SOCKETS];
 };
 
 #if defined(CONFIG_PAGE_POOL)
@@ -20,6 +30,8 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zc_rx_ifq_reg __user *arg);
 void io_unregister_zc_rx_ifqs(struct io_ring_ctx *ctx);
 void io_shutdown_zc_rx_ifqs(struct io_ring_ctx *ctx);
+int io_register_zc_rx_sock(struct io_ring_ctx *ctx,
+			   struct io_uring_zc_rx_sock_reg __user *arg);
 #else
 static inline int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zc_rx_ifq_reg __user *arg)
@@ -32,6 +44,11 @@ static inline void io_unregister_zc_rx_ifqs(struct io_ring_ctx *ctx)
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
index d75246450a3c..a9cef870309a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -637,6 +637,7 @@ struct socket *sock_alloc(void)
 
 	sock = SOCKET_I(inode);
 
+	sock->zc_rx_idx = 0;
 	inode->i_ino = get_next_ino();
 	inode->i_mode = S_IFSOCK | S_IRWXUGO;
 	inode->i_uid = current_fsuid();
-- 
2.39.3


