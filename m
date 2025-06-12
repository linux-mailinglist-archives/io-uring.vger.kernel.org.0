Return-Path: <io-uring+bounces-8316-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B4BAD6BC5
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 11:10:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B43A2173C36
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 09:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3686F224B1F;
	Thu, 12 Jun 2025 09:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="izcDEiJb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363DD22FDEA;
	Thu, 12 Jun 2025 09:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749719320; cv=none; b=U4jqLE1BAz+pg9yM2l8JdMvv/kDFj2n0+2XMn9wRqDdYtD3EbrpNVEM/mOzOlRg38bXLuCb/RKfaLyHY4u++a16RX5aaddrBVMo0oColHwgNHOqfxi4pQVMPuTA1qerz4+vEUXB99EspXz/Anpwi8DkZSxEEGuC1aZboUurz4D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749719320; c=relaxed/simple;
	bh=TTpgCt1xNx9Lql5p6wed//0MOtX0gnkS7/Ns5dKta7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7Y6jgkxANQcVWMukuqCSkEIqE314Fut/RUWe4558jICTCBrkDFJUofv4VQTDqfx8Z1TXzOrjVhc1a3qy213UFkMnepX7+kp9te9oC/obPGQGNGWBye+cmciAPBBrEr1FK5rEe4HOJyFyX9yP+bYJBj0H8hXbh3GjiKuyhF1kz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=izcDEiJb; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-adeaa4f3d07so122132666b.0;
        Thu, 12 Jun 2025 02:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749719316; x=1750324116; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x179C/0PNf9L29M+iTrVGH+5QIo25qLi2eKE4SrJvt8=;
        b=izcDEiJbXllfLs+SAbdLLmxDPD6E3g+nqufmqFdItwGWicyz3Y8aSU5fuDiKgVR4g+
         ihyUlqyt0wyVLYEFTBrBJ9ePyoEPzf5vPjYBqLi/pViI43XH0mGLu4u2bunAgG5d6oWN
         CQI4BQ/87vvCUWdeEerH+jZt3cL+CxaPvmO2dmbgOMSLQ1Q7qyKpeCuzB7WECOd/uFj/
         WTORZ+yjO1Vv5Bz/JRo9THpJLN+dj4yq0NXbh/iA3d1XfdnEqTaQQzZR1ZKUoBUoI36v
         Mbc7F3O+LRq4Dx9a0/UWF21MkS/adSgTD9PoUzzZEmKkU6LHcpgCpSlbNTfIDwVcdQgt
         Oorg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749719316; x=1750324116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x179C/0PNf9L29M+iTrVGH+5QIo25qLi2eKE4SrJvt8=;
        b=oIaw+2IwYVep/jT6biyh0G7jv28zw1HuqNDp8qVdXewyao+dVo5/wg2HLLpOb++FmQ
         WCUBbCrROJP/QDmvNYbRfrGZB5S4w7UccRyLxnsm+J4/ZKRL3Qjxxp1hppnNXbc7Bg3W
         awWm2YnsJ0rc2w+5p8k9TqcSK82ER+CI0gNzpb5Y3eYam3hzagurnPLYdWOIoyPBvlYL
         14nBgDXMy5PpDDI0FtEDCmzL4OY0+nB4Em13rci2X4rFL0cgYf17FC+jdnA1Ob3e+CS+
         H4KiRYWHJmJtUTOhO9BxJKHjAhZsjrFXu7VuxeQworwqSO0x9ck5xBpu8/r6fL7ht298
         Dh0A==
X-Forwarded-Encrypted: i=1; AJvYcCXWS7IYfht+abv5545eHD2WF0D2aM3nyTuWE1fPWwwZUdTJHpSRenNyRdmb/k0tT2XVraKt+Ok=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLHmb9bHgtOv8rW9YG2E2TFWN4OtioLPyrrKG3+imu6jNQGi3k
	JomteQkRlntsJbwqBDem21hEkAjR9YtLI5yS0mT6zG3LzLl7dIZ2O9ZtxazpJg==
X-Gm-Gg: ASbGncsUTKuec060ojnahncXHbg/x1jFhPoAN6Jcr/PsWaJOZ30oGRCLqk4GhPJIMBA
	RscIKOnGsInSJ0Ku0NGvoOXwKe8rY0ITA7CGg8PhBj2KWPg+wGmy9tUtDE/H+7vwCHskSsj+kkX
	aETewLUwJg9iG859KNE4n+M1s1arBcAdXLPqnpMQ5DXKLm0yGAXShjx/d5IPHh70+H2VPaGcNCR
	BZmudDvaByqgxPJibFDvU8zn8M2pE5ZZx72sPms6ojf7poElZncMr+/DjM+OzsqtAz4+NZBlj66
	v2WmtwWtDKfu1Ej6f3ZeoQyXItzbCS3JHsd/GjI50UMC
X-Google-Smtp-Source: AGHT+IEb6n1vNSX8n3eZYyfd6wE0f2oeNgdN6ZA1RhfC4/QLwya8ZyWAWwJEoEa16VA/KCtj7SK26g==
X-Received: by 2002:a17:907:d0f:b0:ade:9b52:4d78 with SMTP id a640c23a62f3a-adea375cae6mr287033366b.48.1749719315449;
        Thu, 12 Jun 2025 02:08:35 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:be2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adeaded7592sm96883166b.155.2025.06.12.02.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 02:08:34 -0700 (PDT)
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
Subject: [PATCH v3 5/5] io_uring/netcmd: add tx timestamping cmd support
Date: Thu, 12 Jun 2025 10:09:43 +0100
Message-ID: <1e9c0e393d6d207ba438da3ad5bf7e4125b28cb7.1749657325.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749657325.git.asml.silence@gmail.com>
References: <cover.1749657325.git.asml.silence@gmail.com>
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
 include/uapi/linux/io_uring.h |  9 ++++
 io_uring/cmd_net.c            | 82 +++++++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index cfd17e382082..5c89e6f6d624 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -968,6 +968,15 @@ enum io_uring_socket_op {
 	SOCKET_URING_OP_SIOCOUTQ,
 	SOCKET_URING_OP_GETSOCKOPT,
 	SOCKET_URING_OP_SETSOCKOPT,
+	SOCKET_URING_OP_TX_TIMESTAMP,
+};
+
+#define IORING_CQE_F_TIMESTAMP_HW	((__u32)1 << IORING_CQE_BUFFER_SHIFT)
+#define IORING_TIMESTAMP_TSTYPE_SHIFT	(IORING_CQE_BUFFER_SHIFT + 1)
+
+struct io_timespec {
+	__u64		tv_sec;
+	__u64		tv_nsec;
 };
 
 /* Zero copy receive refill queue entry */
diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
index e99170c7d41a..bc2d33ea2db3 100644
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
+	cqe->flags |= tstype << IORING_TIMESTAMP_TSTYPE_SHIFT;
+	if (ret == NET_TIMESTAMP_ORIGIN_HW)
+		cqe->flags |= IORING_CQE_F_TIMESTAMP_HW;
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


