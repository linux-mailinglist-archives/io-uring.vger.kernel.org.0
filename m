Return-Path: <io-uring+bounces-8339-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89BBAAD947C
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 20:32:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88B2C1BC2CCA
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 18:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7BF5239E6F;
	Fri, 13 Jun 2025 18:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dJkjmBm1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BDA23814C;
	Fri, 13 Jun 2025 18:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749839494; cv=none; b=TXf/ff7oXaGZ76j9h28ugTT9+6QvaVqag6hIabvDEuj614TJ8H32EPRPKknMdNPY4dCWlQEnVqUhwBkDNPOumnYK4Q+Fm48QsrJ24o1e9+zxPbCl08fJhNgqrSzILYWotVKUpzKnPz9Zt2iT996TgBgSqLQOENo7qigkcGAag7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749839494; c=relaxed/simple;
	bh=kAZ5psEFA82bcJIWxJ/RhBfYCAexF+CUyzpr9B/CVwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=govAKavSgMBPhGBj9fvA9JJ5738lK14T7pzI9z/1HkVI0hq2vQUXFty0rkLjAU7IflKw3qWl0mQXZV/luELYCtKLox4ZnenBz1NAvkzaY9Iht/I6SAd3Jtc5b5Jz0L9DC30oSuCBccjBQitk22uJEBbmBFeyP/3avOSDiRQ0evI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dJkjmBm1; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ade33027bcfso387934766b.1;
        Fri, 13 Jun 2025 11:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749839491; x=1750444291; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VMT/TmzdnwX8gjT0kL+5VZilMO9bSQWco01HwQIhqxw=;
        b=dJkjmBm1Mex9rgzB6NZPg3Nj+MmYLN7P+HI9+XltlMs1QKHI74wiBvmYw5DeBf9l0n
         m+BJNfhoqwcifxN2hWibR48WXmqQrNDcrUFA8n6+BxyggDBGU1MsgIthxte9stuKuRlj
         ZTt8AV5zBm/Wo5+e+hUIenN3vdaU6ab11DdHu8fhGTf60ctfvTpFhflkKWYBeZ3HbNLG
         +6n+YIyYU0w9W4/YSDgP2HnrclITXAlL30/rhSG2xz2mT8UkVrZ1nDKMabzJ2bgJ7Gt5
         51W7WQbZ3GcBYd6jjErng+xYDJjvPEuZyQmDm7gTC3XSYcFW8eiCyJyzUr1o9kN+TKj/
         NW7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749839491; x=1750444291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VMT/TmzdnwX8gjT0kL+5VZilMO9bSQWco01HwQIhqxw=;
        b=Tw/6L/HRqxRW3ol3EMJAUWDRhNAO3dqci2R6F7IVgJko5ADAVTtw6KT4hp8sw8jQdE
         Cl0n81ioygHAAo776Z5gGHWGV2h3rnnJHljvZYrAmwKPfeZLkt0CecP7n25nXGBZV1/x
         7c6k7Ou9QMfHCBfanMbAqHi5vbNT5vg5e06ziDV49oCgFV7CQTzVdVakgtZbmf4VkoWN
         X7OTUanbn7j4qJL/GybegatAe6R8g8Sa7g7elvaVwWETqxV3+fP4Z1eVC547wlee91zG
         R5YM4NzQ6zM0hXbz1KBP9Gq1L15hlXAzMovoY0HWmqlAN9zokcXEJaJTQ8ifyvTTfzw1
         u5kw==
X-Forwarded-Encrypted: i=1; AJvYcCUcDYRqeu0u8s5JfSTpbNwiJ3Y0k8f64k27WhUlSNGBXOZ85YRzX0iOx4tKyuKuD8RBh4vkqCk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyds5kDbJBS40OzgZW7/QCqHVHf0/395POLIRW8QTm8ENpUFJcP
	Dr1tgHom3zqwZV1+1JYlmBC08CzviFUAZAQa5X0y+YnZWJn0lg6JCU2p9/cikw==
X-Gm-Gg: ASbGncv2cMvPBmwPgJBB6pUVfiVG72IN50wZae1BgZ8xXHazSLo7QxJNmH2m9AcYlA4
	Q85OTxQ3zU+zhTrxe8CMhMOJGKvXiaFSGLhIogYvrgmkmKTgdrvjd1ZISl6Ff5ITs/MVyxFjkFi
	n9uewcBa3Tpj1xMV5lhEo6p5Z0DJPCQoYFU5nyaE7ikuCGhPyBhooxerNWVPpn5UrGm6ISAIdlI
	D/K4tW9gOgkEIZmo2XywAr3eUWl1vB9LC8uirAopw7153Mu49npCcWiWU3+BeRdyv5zT/O6GqtJ
	1t6jLfq4TcvhTb+IwSdV+xiceLR5jq4lUOKGihIgIdLKaMBa29QWfnw76Z3JM+P+chkiKFEY1w=
	=
X-Google-Smtp-Source: AGHT+IEeUfgADXjw1DWGlSslGcDBMnyEvRJirfyXeCHzyKXDq7jfThdI6tOWKEsX3EVS6pHqwUY6gw==
X-Received: by 2002:a17:906:6a0a:b0:ad5:372d:87e3 with SMTP id a640c23a62f3a-adfad36811fmr23135766b.27.1749839490576;
        Fri, 13 Jun 2025 11:31:30 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adf688970a1sm54772466b.175.2025.06.13.11.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 11:31:29 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jason Xing <kerneljasonxing@gmail.com>
Subject: [PATCH v4 5/5] io_uring/netcmd: add tx timestamping cmd support
Date: Fri, 13 Jun 2025 19:32:27 +0100
Message-ID: <a0e726f33e940429276a209532b36090d3976fa5.1749839083.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749839083.git.asml.silence@gmail.com>
References: <cover.1749839083.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new socket command which returns tx time stamps to the user. It
provide an alternative to the existing error queue recvmsg interface.
The command works in a polled multishot mode, which means io_uring will
poll the socket and keep posting timestamps until the request is
cancelled or fails in any other way (e.g. with no space in the CQ). It
reuses the net infra and grabs timestamps from the socket's error queue.

The command requires IORING_SETUP_CQE32. All non-final CQEs (marked with
IORING_CQE_F_MORE) have cqe->res set to the tskey, and the upper 16 bits
of cqe->flags keep tstype (i.e. offset by IORING_CQE_BUFFER_SHIFT). The
timevalue is store in the upper part of the extended CQE. The final
completion won't have IORING_CQE_F_MORE and will have cqe->res storing
0/error.

Suggested-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 16 +++++++
 io_uring/cmd_net.c            | 82 +++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index cfd17e382082..dcadf709bfc4 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -968,6 +968,22 @@ enum io_uring_socket_op {
 	SOCKET_URING_OP_SIOCOUTQ,
 	SOCKET_URING_OP_GETSOCKOPT,
 	SOCKET_URING_OP_SETSOCKOPT,
+	SOCKET_URING_OP_TX_TIMESTAMP,
+};
+
+/*
+ * SOCKET_URING_OP_TX_TIMESTAMP definitions
+ */
+
+#define IORING_TIMESTAMP_HW_SHIFT	16
+/* The cqe->flags bit from which the timestamp type is stored */
+#define IORING_TIMESTAMP_TYPE_SHIFT	(IORING_TIMESTAMP_HW_SHIFT + 1)
+/* The cqe->flags flag signifying whether it's a hardware timestamp */
+#define IORING_CQE_F_TSTAMP_HW		((__u32)1 << IORING_TIMESTAMP_HW_SHIFT);
+
+struct io_timespec {
+	__u64		tv_sec;
+	__u64		tv_nsec;
 };
 
 /* Zero copy receive refill queue entry */
diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
index e99170c7d41a..39726283b951 100644
--- a/io_uring/cmd_net.c
+++ b/io_uring/cmd_net.c
@@ -1,5 +1,6 @@
 #include <asm/ioctls.h>
 #include <linux/io_uring/net.h>
+#include <linux/errqueue.h>
 #include <net/sock.h>
 
 #include "uring_cmd.h"
@@ -51,6 +52,85 @@ static inline int io_uring_cmd_setsockopt(struct socket *sock,
 				  optlen);
 }
 
+static bool io_process_timestamp_skb(struct io_uring_cmd *cmd, struct sock *sk,
+				     struct sk_buff *skb, unsigned issue_flags)
+{
+	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
+	struct io_uring_cqe cqe[2];
+	struct io_timespec *iots;
+	struct timespec64 ts;
+	u32 tstype, tskey;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct io_uring_cqe) != sizeof(struct io_timespec));
+
+	ret = skb_get_tx_timestamp(skb, sk, &ts);
+	if (ret < 0)
+		return false;
+
+	tskey = serr->ee.ee_data;
+	tstype = serr->ee.ee_info;
+
+	cqe->user_data = 0;
+	cqe->res = tskey;
+	cqe->flags = IORING_CQE_F_MORE;
+	cqe->flags |= tstype << IORING_TIMESTAMP_TYPE_SHIFT;
+	if (ret == NET_TIMESTAMP_ORIGIN_HW)
+		cqe->flags |= IORING_CQE_F_TSTAMP_HW;
+
+	iots = (struct io_timespec *)&cqe[1];
+	iots->tv_sec = ts.tv_sec;
+	iots->tv_nsec = ts.tv_nsec;
+	return io_uring_cmd_post_mshot_cqe32(cmd, issue_flags, cqe);
+}
+
+static int io_uring_cmd_timestamp(struct socket *sock,
+				  struct io_uring_cmd *cmd,
+				  unsigned int issue_flags)
+{
+	struct sock *sk = sock->sk;
+	struct sk_buff_head *q = &sk->sk_error_queue;
+	struct sk_buff *skb, *tmp;
+	struct sk_buff_head list;
+	int ret;
+
+	if (!(issue_flags & IO_URING_F_CQE32))
+		return -EINVAL;
+	ret = io_cmd_poll_multishot(cmd, issue_flags, EPOLLERR);
+	if (unlikely(ret))
+		return ret;
+
+	if (skb_queue_empty_lockless(q))
+		return -EAGAIN;
+	__skb_queue_head_init(&list);
+
+	scoped_guard(spinlock_irq, &q->lock) {
+		skb_queue_walk_safe(q, skb, tmp) {
+			/* don't support skbs with payload */
+			if (!skb_has_tx_timestamp(skb, sk) || skb->len)
+				continue;
+			__skb_unlink(skb, q);
+			__skb_queue_tail(&list, skb);
+		}
+	}
+
+	while (1) {
+		skb = skb_peek(&list);
+		if (!skb)
+			break;
+		if (!io_process_timestamp_skb(cmd, sk, skb, issue_flags))
+			break;
+		__skb_dequeue(&list);
+		consume_skb(skb);
+	}
+
+	if (!unlikely(skb_queue_empty(&list))) {
+		scoped_guard(spinlock_irqsave, &q->lock)
+			skb_queue_splice(q, &list);
+	}
+	return -EAGAIN;
+}
+
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct socket *sock = cmd->file->private_data;
@@ -76,6 +156,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		return io_uring_cmd_getsockopt(sock, cmd, issue_flags);
 	case SOCKET_URING_OP_SETSOCKOPT:
 		return io_uring_cmd_setsockopt(sock, cmd, issue_flags);
+	case SOCKET_URING_OP_TX_TIMESTAMP:
+		return io_uring_cmd_timestamp(sock, cmd, issue_flags);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.49.0


