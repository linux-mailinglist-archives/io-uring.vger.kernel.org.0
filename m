Return-Path: <io-uring+bounces-8207-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EBF4ACDA24
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 10:43:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B66577AAE75
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 08:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 841C526B094;
	Wed,  4 Jun 2025 08:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E18O9aCx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D3228C5C5;
	Wed,  4 Jun 2025 08:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749026495; cv=none; b=JqBskPG/yvNttXTpKo/OLq6Zw69bcAUGSDCVkQn4Aah6QEyLWS/9FcassSb7+pyoBsdagW0MaxsYoBHaOrKdkkq3BvlCj1VzSwigttycQQtOPgU2zRwPWpWDZ/Z3p0fDBJ+PWjiuONEQT8YljawDTyLtolqZpa5lq2YYRm2Iwy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749026495; c=relaxed/simple;
	bh=w1MRvPgElbQ6GdnLobOupWNjRD24U3aNuTOEX5hSkmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5Y+6h6RyK/5507gjIC48cqjusaqoeQJjMNftHT5tm71aKcWYPhHLclkPGnVbj/eo41xP7WODts9792ENFUXgHxStatj1dqVIGThrGuXIg5Y9VNEVL8mlkMuxFnixjGgT6zbHtLyMWjV1plPVJq3p+5O1d4QGQgh+QxclxqEirY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E18O9aCx; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-606741e8e7cso5184563a12.1;
        Wed, 04 Jun 2025 01:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749026491; x=1749631291; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3DPThBWk0HTd7rOSqsh44icsewfJ9KGfWfpRYHE+m5c=;
        b=E18O9aCxoQ/tfPMRX23Bsuix2BS7Im4H9eN5moIPKUELpamjmfrJeRGh5XbWUJgPLt
         ecBP2xMoIEGAdjAf2QNRvas232CdP6ybtwaw4zQH2v5Yi/mn6bYR40VJ4GoEEm7kvLfZ
         xp+MBF2Pb3xT9Q0tbZADLUTl1cww2Rd/hbaxXFkKemyvKmEv2Ks7USUvK979mNGe7Dm/
         F3IPnlnfJpprdztBt2Qh9QUi64kbuyhCcDg1MadfpBtAeCurfebqN5Z+Tla9pK4SSCXr
         EFeelAxaWv72umQUwr9QfetCYTT77vIm3JOhEA8viyf1Pdertn9g/DePnwzdU/7/vA9L
         rlGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749026491; x=1749631291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3DPThBWk0HTd7rOSqsh44icsewfJ9KGfWfpRYHE+m5c=;
        b=tx2nRYyVYFLQZaV4B5GkmTQzxfwoneNPUor+oTvPgh31HiVtDdVTs1CrkLlsMAx5jz
         21E3eZQ/W8pXPKHr5fVdsiKl1IEc+sg+AaEVJ1WPVOSXLd9K6VYwFAruAuwxWRBeb0/y
         mpKrK855ytWr1bRUMhA4pvpCCCq6YBA8FDmBGEoyf5L3Of80rortHP22IJQExR0fgVlV
         tj/MWKLbXZGV70XsM+HCLKlW5YShNxAfGg3DscOyCGPCX+aH/80T2DDR0LjhSenhIMvg
         fyjLrMueI822DSLRpUobgSAEfRI7Nl3TNSMV+LDe6wY1SH6F1guNbFe5bYXab4N3wo0d
         hltA==
X-Forwarded-Encrypted: i=1; AJvYcCWAculLd/8PPDTQCJCWJ37nNA9njFmEH0lzWE0QE/03RTB5jbfoRo8DKK1hiene6iRhn7m1L/8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhHZQCkkQhaxiQpRwFwUbhDyHcfwDyNOa+EjUsa6rNgqBeHqMj
	MvtRYtMjmrQ6Dqai91MciEP9MxAv26mVJd9oPuSsksVrMrGnHcs6LqC6hOIUow==
X-Gm-Gg: ASbGncvX6XSsidMZL9jf/GsKp1x74yBMgCQwtyipOSXKzRm6RlzmAnfoZIzoktZu/CG
	C+H9ea6f/Te7hGcM2bMcTCT6MUGaxDwBI8G4PE2MkRmp/pjNBpm4NLEhURvRil70oAbk8JFoOS7
	TTNHuV1pMectnmvQxiIThZB8vNXHcnfg6PU4R6FHGunzCM9ObduIH7B9WGXLn2XgIip76ecNVtA
	VL9eEu6IyIR6wDAMj+og99/+vAYRSWzykMFhQUbBHFqt4eNSuKCJlf5SaTJW+irbB8BEEf3RDMk
	HRMXHnltsCr1goZWfRhVFJSBkI9HYrpuu1g=
X-Google-Smtp-Source: AGHT+IEE+uWt2fhQ4ZAt9ZGsNZDpcUpdb6co13HDhZ36EW8kvSP/EWm2qMZcZaOFoTVbS+1lko7hwA==
X-Received: by 2002:a05:6402:27d0:b0:606:a77b:cca3 with SMTP id 4fb4d7f45d1cf-606e98b0020mr2141802a12.7.1749026491354;
        Wed, 04 Jun 2025 01:41:31 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b3d1])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-606f3ace23bsm544261a12.12.2025.06.04.01.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 01:41:30 -0700 (PDT)
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
Subject: [PATCH v2 5/5] io_uring/netcmd: add tx timestamping cmd support
Date: Wed,  4 Jun 2025 09:42:31 +0100
Message-ID: <7b81bb73e639ecfadc1300264eb75e12c925ad76.1749026421.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749026421.git.asml.silence@gmail.com>
References: <cover.1749026421.git.asml.silence@gmail.com>
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
index e99170c7d41a..dae59aea5847 100644
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


