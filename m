Return-Path: <io-uring+bounces-8360-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C91D9ADAC3F
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 11:46:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D675C3AD4E7
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 09:45:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198052749ED;
	Mon, 16 Jun 2025 09:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AMuhq/zo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDDC26E153;
	Mon, 16 Jun 2025 09:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750067136; cv=none; b=JEqh4KswtbKHnp01d9pYbzEy4IyNn2OvNsZTpOvhq0hmPQo8HoEZV9Xu+0E2Rt/m5xW7UJOEGhRLtagggZFOJrmxyUPfHxHXCmYK/gTsnjj72LhqZpBAHNuW/PGRhNaemZXZbpXgnk2wDEVL9uKIv/CIS/jbajp0lB41aWu7xJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750067136; c=relaxed/simple;
	bh=9pRR7o5GYsbFeOJ3joJsOxaJTn5+Svn+cL9X+lfJkgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igff3HYVIYUdidOZS33MM4KnjgcqWij8urrMcvof3WlsJ/YemLkk79O9L3cX98oL1nkrcq52Ll4+vvmQDRko8IfyLA0KngPSgoQdbS/yB+3uFPnxY+M81XP9+J3TamRGfdi7Pb0SNJwOvOO2heWdbr9Uhc2HamHuMJwcVqLiFDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AMuhq/zo; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6071ac9dc3eso7518732a12.1;
        Mon, 16 Jun 2025 02:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750067132; x=1750671932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dsrQVZ5sveNAKuUap0eBiKfTgG64PECrNDedHgR/X80=;
        b=AMuhq/zoeL97A5spycEqAd+QhDM4dhJ0qtcyZyY4fKSZ6KEGfdSbco4xdtgyxwsriP
         xOSBF/0irNwGOMtw9RvIuxnRByUBoTJkdtADFrkjd/dm7e/kaKNoWEQjPx9OYq/c53OQ
         +3589sZ8RyT5EyVXHhJruMJ7PwLj2Gy2qN0ce5cbQ8Pqzd/4cAvjDiKt+W6Fv+JfqI3f
         z177BKLyF/K1Q8dBNcwbEB1M15FTLmQOyFe7+VH/Uw85YFo+sbWcQbU1PtmoqodbbQ6+
         6TG8LBqwMt0Kc55n1bwW1QKfN3sn3RxOxbFozBiktUgQE+6O17huNwzv17e0bb+R0bOr
         KkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750067132; x=1750671932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dsrQVZ5sveNAKuUap0eBiKfTgG64PECrNDedHgR/X80=;
        b=xK6SlJDUq9JD7ztv639Duo4AiqNWXYOWfdLz01ED5/Ls2HDQcbPa9HuvwrOipHdYe6
         kUsZjXVA2z/mvF8ai+Y5khVqSNrWAxT2/vS983bvILBuNtcnGFEs5OKtJDJtAmKdORxK
         EGywZ9sxh8CB0DFAHloXNRwfhE/BW5XNgXlxL/2tSQbRhXdrxxLctdazRejpt7MPzJx8
         6sdcbd0ChO5cSNzAELfaSwy1Tuoy+M8zHFwC+pofls5AHBizKNZV3onSPcBEnWaSSvl2
         dSBQlTj6eum6fEI+aquWsjYBMFnYxOtV+MhX0xZvjmKyWYjFcRV8fQW7mgQ70ZzIvTSv
         vmgg==
X-Forwarded-Encrypted: i=1; AJvYcCWOXKiKmEAflySssUSyfPaTVTAgUuxw9IMW9M5BXwikePdJduPpCPYvdXFhuIJCIcD/2UIOSDQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwclqcfX0EZr2YZ/aRAaBYi3/RyLSdMGjTe5XjalOZhJxWvstcO
	O0bNVAWbJL2IZrAl2OM+pMFe/LbaPAVjN46RXux7OKwJuxmQgEFiCV4tsP/01Q==
X-Gm-Gg: ASbGncvjAo4OvGG8Ny2uar7ofgq9ABii5s12qeY8uiy1USAYq+lAkjdIBJkKnsY9Clz
	RZMw7K8l1/ZB+H6mIfAK0oJQf7yQzLDVZnKGrjEWdN6UgEyvVvvCKYIepg1g9P8JwXWc1N60gCD
	UB4Omx1B08o+iYlbsJuaigzMvCokg6Y1wzr5PjoUZh4sCsfRiDaWic5YUHdbMv+pdTdfvi2nB6/
	xvOoVdazV6XvvkpOKgpUxEGDJGl7Rgi2mAwA2LQthxGYvK0oq+x2TyFXFHQleiBLYqNTxFSF1UD
	XIOWnaBqzkUTA6kl80zKMTsBSh7cYbNSrvYqvTIX8sFBoA==
X-Google-Smtp-Source: AGHT+IGMuUEcRc7M1qMsgFb2ZOgc8xNfB1lCzTII3Hbv2ySHbkb0YoJjBpbBL0e1/D8mzwlgBC3CLg==
X-Received: by 2002:a17:907:7f27:b0:ad8:8621:924f with SMTP id a640c23a62f3a-adfad4f510emr843420966b.56.1750067131958;
        Mon, 16 Jun 2025 02:45:31 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a3c1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec8159393sm629363266b.15.2025.06.16.02.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 02:45:30 -0700 (PDT)
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
Subject: [PATCH v5 5/5] io_uring/netcmd: add tx timestamping cmd support
Date: Mon, 16 Jun 2025 10:46:29 +0100
Message-ID: <92ee66e6b33b8de062a977843d825f58f21ecd37.1750065793.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750065793.git.asml.silence@gmail.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
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
Acked-by: Willem de Bruijn <willemb@google.com>
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
index e99170c7d41a..3866fe6ff541 100644
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
+	if (ret == SOF_TIMESTAMPING_TX_HARDWARE)
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


