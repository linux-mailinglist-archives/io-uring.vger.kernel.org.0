Return-Path: <io-uring+bounces-56-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA5657E4AE3
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:41:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18A0A1C20A42
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:41:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 964F82B2C2;
	Tue,  7 Nov 2023 21:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ZysJlVCK"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960D02A8D1
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:41:02 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC6310DF
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:41:01 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-6b20a48522fso5307447b3a.1
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393261; x=1699998061; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mOi3kgM6YMdJ3o8a6c8h2Q5Yb4bopwAacE/KWvRpLyw=;
        b=ZysJlVCKeevLgVhhfRKI1U8utXwAB3c86wL5dSN7EeAnLXomQwOGfBZGvSxm7fv2W/
         0enD7Q7q2pKoMRt+57vPH6BeeHyPgroEi8bwvvFtJfBA2mB+8OcNe5d7QHuToHTpaGrL
         KvrlcrhXpW0eQbIjh3sj5fpVn5rYqZeJ99cWKmMmAf1eFe2NCKspsXUU61qp/h48V6vs
         Znb7WdCoLDKvkjXYdZXaQTCXq2SDLf2nLFxCyBQ6o6RgjySh80LAFutyOqOus/yXMwpH
         fkZkVdC4NUXmSRMG0UYPyRGH+ExfOZxZ95j6OCXPybcXH51vIoF8c2wNCaUb2I5ePtub
         R+mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393261; x=1699998061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mOi3kgM6YMdJ3o8a6c8h2Q5Yb4bopwAacE/KWvRpLyw=;
        b=IMFutXwBSvG5JZjy5Bl3lkW+Wo9Kq4LkqQU2wCCmLo1FDeXQ0rlSbA+1/DNwF3pK1C
         kSX1Yh2sGRgUObVGH/MUf+r8oolq+zDfTZ7CXJcZtHXuz0gtTmAqC1gh0ta/Ey2avhC/
         8ialwZBUuwO+GSxxJCfwnX3+y2mQJ4Ux0ow6dymCjktnuslCIa2z6oeJYXFsM3QI25YQ
         5k3x36uvHKljZ+hB5SBQX+YFU+Vk1YOtc6YYehlC90qbAQErZfizYuGM2Xeas80VimoE
         Ft0A1nALZuvTMkKmWs6cq4DS3MNjZUHU894DP72c3/dz7SmixTj16D8vRMwJvr1h30Fg
         /6uQ==
X-Gm-Message-State: AOJu0YzNe/l1pTMmf/LIOlJX4oclNVIFVLcQrbLM3pVBQumEuAQHNX9U
	5TzuvhLx/8fmCcW9DhJ+Rmb9y7yBvOkkL/gGL58khg==
X-Google-Smtp-Source: AGHT+IHvA1IbXaADsbrtc9iZC/hG8Lytson8e0HTxc42XE/7jKTGiVwh1DGmhtsIq0IrXRJeZ+c+TQ==
X-Received: by 2002:a05:6a00:23d2:b0:6bd:66ce:21d4 with SMTP id g18-20020a056a0023d200b006bd66ce21d4mr273980pfc.23.1699393261026;
        Tue, 07 Nov 2023 13:41:01 -0800 (PST)
Received: from localhost (fwdproxy-prn-016.fbsv.net. [2a03:2880:ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id fa16-20020a056a002d1000b0068fece2c190sm5734815pfb.70.2023.11.07.13.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:41:00 -0800 (PST)
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
Subject: [PATCH 05/20] io_uring/zcrx: implement socket registration
Date: Tue,  7 Nov 2023 13:40:30 -0800
Message-Id: <20231107214045.2172393-6-dw@davidwei.uk>
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

From: Pavel Begunkov <asml.silence@gmail.com>

We want userspace to explicitly list all sockets it'll be using with a
particular zc ifq, so we can properly configure them, e.g. binding the
sockets to the corresponding interface and setting steering rules. We'll
also need it to better control ifq lifetime and for
termination / unregistration purposes.

TODO: remove zc_rx_idx from struct socket, and uapi is likely to change

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/net.h           |  2 ++
 include/uapi/linux/io_uring.h |  7 ++++
 io_uring/io_uring.c           |  6 ++++
 io_uring/net.c                | 19 +++++++++++
 io_uring/zc_rx.c              | 63 +++++++++++++++++++++++++++++++++++
 io_uring/zc_rx.h              | 17 ++++++++++
 net/socket.c                  |  1 +
 7 files changed, 115 insertions(+)

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
index ae5608bcd785..917d0025cc94 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -550,6 +550,7 @@ enum {
 
 	/* register a network interface queue for zerocopy */
 	IORING_REGISTER_ZC_RX_IFQ		= 26,
+	IORING_REGISTER_ZC_RX_SOCK		= 27,
 
 	/* this goes last */
 	IORING_REGISTER_LAST,
@@ -788,6 +789,12 @@ struct io_uring_zc_rx_ifq_reg {
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
index f06e9ed397da..e24e2c308a8a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4549,6 +4549,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
index 7a8e298af81b..fc0b7936971d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -955,6 +955,25 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
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
index 85180c3044d8..b5266a67395e 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -11,6 +11,7 @@
 #include "io_uring.h"
 #include "kbuf.h"
 #include "zc_rx.h"
+#include "rsrc.h"
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 
@@ -129,12 +130,74 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 int io_unregister_zc_rx_ifq(struct io_ring_ctx *ctx)
 {
 	struct io_zc_rx_ifq *ifq = ctx->ifq;
+	int i;
 
 	if (!ifq)
 		return -EINVAL;
 
+	for (i = 0; i < ifq->nr_sockets; i++)
+		fput(ifq->sockets[i]);
+
 	ctx->ifq = NULL;
 	io_zc_rx_ifq_free(ifq);
 	return 0;
 }
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
+}
 #endif
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
index 5f6d80c1c2b8..ab25f8dbb433 100644
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
 	struct io_ring_ctx	*ctx;
 	struct net_device	*dev;
@@ -11,6 +18,9 @@ struct io_zc_rx_ifq {
 	u32			rq_entries, cq_entries;
 	void			*pool;
 
+	unsigned		nr_sockets;
+	struct file		*sockets[IO_ZC_MAX_IFQ_SOCKETS];
+
 	/* hw rx descriptor ring id */
 	u32			if_rxq_id;
 };
@@ -19,6 +29,8 @@ struct io_zc_rx_ifq {
 int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zc_rx_ifq_reg __user *arg);
 int io_unregister_zc_rx_ifq(struct io_ring_ctx *ctx);
+int io_register_zc_rx_sock(struct io_ring_ctx *ctx,
+			   struct io_uring_zc_rx_sock_reg __user *arg);
 #else
 static inline int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zc_rx_ifq_reg __user *arg)
@@ -29,6 +41,11 @@ static inline int io_unregister_zc_rx_ifq(struct io_ring_ctx *ctx)
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_register_zc_rx_sock(struct io_ring_ctx *ctx,
+				struct io_uring_zc_rx_sock_reg __user *arg)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #endif
diff --git a/net/socket.c b/net/socket.c
index c4a6f5532955..419b7bda3f9c 100644
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


