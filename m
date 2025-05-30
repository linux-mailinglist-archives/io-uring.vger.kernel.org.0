Return-Path: <io-uring+bounces-8139-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71640AC8D74
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 14:18:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F7619E2058
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 12:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7E322D4EF;
	Fri, 30 May 2025 12:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fisk8B8X"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893D8225412;
	Fri, 30 May 2025 12:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748607446; cv=none; b=uamihE1iZEnvTD/z6I2Bjo9Hp+UXGpC+GdZ1aKxMoVQc0FYzESJjfeGScdsS8IjM2BTU8jcgy/L2AxQXM5aEE/zDcz/SXBnbsVn1G427hMzou6DAN4fdd0cyRyEkmrGAG+nsXytfK3L7DOtWcjClbK8fEeQc8i8sH6bdRu0sCLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748607446; c=relaxed/simple;
	bh=oj6XP+CNQ+I7kidj3kHMshyshT7NyZ0B0H6yPf8DXNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhq2zSTo7pQVHX5GZb0Ul0NgFnaAOZCwPrik9vLyr16nDDI15D3ShoOLQkI1d0ngrhcKwLp+nbpo30eFZQMjPDNUE37bC3KP7EJXZUcDdWaiLJK+Z35P3ioipb7bYL+TPRhV52wTDeI7VrgVlJ8O06Coxg4NHVuWZnJsa3TDTY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fisk8B8X; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-604bf67b515so3617094a12.0;
        Fri, 30 May 2025 05:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748607442; x=1749212242; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T7DQwCIp/wsn0JizreQf8XabaC8QZ8mrk4zPHSvlEsc=;
        b=Fisk8B8XAJW3e1lx5+lsgvJR/fxJdkRZnzofFu4oDBGi83I7MevIzrwTqcJGAK/gos
         bq1Em5B8WB+mVe4aioqBWBySKGwfK/DxjlCiHCLZUG9Oum7qCmbBXrkgs6MIPgqRr4bF
         7pUH+mhcXgM1+ww1aDkG/aSELltM6tmavbQLan3nVLcYqSw6L4Cswtw28t4Ky2n1c7PE
         DWcOHldEzZw6EVCGQtawqaQmp6CTMOh6kdlC6Fxu9j6vMYd5O8nAdbRPS7VI/zlkvrVf
         fI/h0vaBxy5U+OQaMxKZxYonSRUs5O8Drvl/wocGQVqg4tWghqo2iMsLSPinVrAfdN55
         YmeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748607442; x=1749212242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T7DQwCIp/wsn0JizreQf8XabaC8QZ8mrk4zPHSvlEsc=;
        b=Exn3cBARH9fks5hFfMf0OKus14N11KIl6i0/JOcgG3FOdIj0KQQ5nd69Fvo2iWxv2x
         jWgnuCVnf4JsO5yCgZ+3I463XXBOikWOxLoVWmYd78AJ4dTX+qHvE34g1pbEVgNflQvL
         FZvaj/6GJ0tzkg3+E/ncoK3Z6HbwwrzITW0VUm813JVKlQ69stTVkrC0dT+SqjDBh8mC
         l9J3opg5ijTAhgmCLGBS5DysGwz3k8DTkX004uJQb0BKkh4hT7C+M4sLIc9hrI1ClK8V
         7ZR1KQofMRk4fTBbqaekeg4poMHVkiRRw+yZqWwSpz08QEVVVVzrlUa9Omp+q83nIIUX
         FJWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUA02/1h3LvJj3t8O0TK3SIPDOGXFCIs3n10X0Ifk1ZSByUFCaJy2KXWisBihE31Yb9jAXcTxo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPQy5eRtlVP9uEXLXaLSsTbpO7z4kU1lt96XCLQC96KfFsaEQi
	Y7dCuRoMKs7zFq8t+dUahBAXVgvmbGhXiTTDBWUphAMz6LKJfQKcm3b3CufP/w==
X-Gm-Gg: ASbGncsJDpqrODOhupJkC144zwqG9SvpsFvnKhYRn6vvfzv1b9paM/meXS3rTMlOsUI
	LS7e99sVZjbIs+vSb1l7vwPJzFC7IqiDVkMQShKCm0PB4ewnZ07Y2+l4k1e8uB+RpM5dsTkzOAU
	HRbIXrS7Ug3sZexOm8P4oiWRPY+s2FJk32YzvZiYxJLBJA9/TbkvL7wsr/hT27oKDtQZ/A//H9b
	O6rfUPOrzUJoYTZhGS+oJz/GLwdcqK/eOpYri8ypHOjR4wgN565yLOf99P8fmKO2L22kPPKC44q
	M/wVpGwlILxgQLfgcvPztx8gIv2y5UsbbSU=
X-Google-Smtp-Source: AGHT+IGT1yWTnDBnTMBBlU9a7avEQ0g0UsR8Ov1GzbzADyhFlNuo33Q52R3DqSq2wU6Lc3ouPg3Hkw==
X-Received: by 2002:a17:907:724b:b0:adb:2bb2:50a8 with SMTP id a640c23a62f3a-adb36b316e0mr186835266b.21.1748607442223;
        Fri, 30 May 2025 05:17:22 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada5d82ccedsm318566966b.48.2025.05.30.05.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 05:17:20 -0700 (PDT)
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
	Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 5/5] io_uring/netcmd: add tx timestamping cmd support
Date: Fri, 30 May 2025 13:18:23 +0100
Message-ID: <2308b0e2574858aeef6837f4f9897560a835e0f7.1748607147.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748607147.git.asml.silence@gmail.com>
References: <cover.1748607147.git.asml.silence@gmail.com>
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
completion won't have IORING_CQR_F_MORE and will have cqe->res storing
0/error.

Suggested-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  6 +++
 io_uring/cmd_net.c            | 77 +++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index cfd17e382082..0bc156eb96d4 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -960,6 +960,11 @@ struct io_uring_recvmsg_out {
 	__u32 flags;
 };
 
+struct io_timespec {
+	__u64		tv_sec;
+	__u64		tv_nsec;
+};
+
 /*
  * Argument for IORING_OP_URING_CMD when file is a socket
  */
@@ -968,6 +973,7 @@ enum io_uring_socket_op {
 	SOCKET_URING_OP_SIOCOUTQ,
 	SOCKET_URING_OP_GETSOCKOPT,
 	SOCKET_URING_OP_SETSOCKOPT,
+	SOCKET_URING_OP_TX_TIMESTAMP,
 };
 
 /* Zero copy receive refill queue entry */
diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
index e99170c7d41a..c9e80f7e14cb 100644
--- a/io_uring/cmd_net.c
+++ b/io_uring/cmd_net.c
@@ -1,5 +1,6 @@
 #include <asm/ioctls.h>
 #include <linux/io_uring/net.h>
+#include <linux/errqueue.h>
 #include <net/sock.h>
 
 #include "uring_cmd.h"
@@ -51,6 +52,80 @@ static inline int io_uring_cmd_setsockopt(struct socket *sock,
 				  optlen);
 }
 
+static bool io_process_timestamp_skb(struct io_uring_cmd *cmd, struct sock *sk,
+				     struct sk_buff *skb, unsigned issue_flags)
+{
+	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
+	struct io_uring_cqe cqe[2];
+	struct io_timespec *iots;
+	struct timespec64 ts;
+	u32 tskey;
+
+	BUILD_BUG_ON(sizeof(struct io_uring_cqe) != sizeof(struct io_timespec));
+
+	if (!skb_get_tx_timestamp(skb, sk, &ts))
+		return false;
+
+	tskey = serr->ee.ee_data;
+
+	cqe->user_data = 0;
+	cqe->res = tskey;
+	cqe->flags = IORING_CQE_F_MORE;
+	cqe->flags |= (u32)serr->ee.ee_info << IORING_CQE_BUFFER_SHIFT;
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
+	ret = io_cmd_poll_multishot(cmd, issue_flags, POLLERR);
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
@@ -76,6 +151,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
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


