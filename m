Return-Path: <io-uring+bounces-7758-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83637A9F16D
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 14:52:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14CC34615E6
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 12:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1D792690D0;
	Mon, 28 Apr 2025 12:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O/OFWDYB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7EB26A0C7
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 12:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745844713; cv=none; b=Y/UZKspamZUAUcmfskOHmLwTKC4edE8LAOi1WocARyj/PObKeabeWp7khHkrLV5n1h3/Flmn65nbA8te6Ni1Xq2zzXhb6WdY7i8OQEpVHqxdtHtimagNs4tcfzCtmDTXiwHrXWbsvCzuMWIkDc1Z9SwVc0UKDnljFNYv+ry7L5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745844713; c=relaxed/simple;
	bh=0eHxTNSfDyklrz95cGPTkU0zXOVHDANNG9z6sOX4pBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+pbloWhfIu0704vQI2Nfp7jkJvWkK029zczLH9LRc0nYf0o3TKsqkPD7FBrSpqgzT4pnzmxiWo+/Ve6gz3y2OxvIREigVO/UHfGKJA9BfMarnt9e5hmLCz8CKRbaSMX2VLAUK1rcUictycZjhIEoXgOpoxsMArcaPY+Iahg1mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O/OFWDYB; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ac2ab99e16eso1021700366b.0
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 05:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745844710; x=1746449510; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hdr8fcwvYBtLHHvd5FLVoP90nkJ8U7ESzwbq9KgKxhc=;
        b=O/OFWDYBdX4IeizYTSbL7xMV/2uIE7y6kr0c4pfHvK6aLEEh29wXaHnRdPFkcg57pw
         52uTHukcUOG2r728yCeoyjwmyu6iTQ6SUgMpC6nT2vnce4WGQrYWdfE8/Kn3NLUiast5
         pDy+PCnNF7/CozpiJnZfftgO44CrqJUg/UM+b1jJkUbGLV7MdcPEmFWAH1kTZ3KZffqY
         2mtjwmAhkiTo8Ebxfy/a8I7XiZvLsbmcsvjRpgANqMoq0VXFrDdkkBBI/rT3EwGfIFRI
         hAR/n55BmOHYkCnd0mka5CJ2Vz8N10mYIjAGbnGGZZQH8w/tWmZ4OcH55P4yNYUr6kCS
         /4gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745844710; x=1746449510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hdr8fcwvYBtLHHvd5FLVoP90nkJ8U7ESzwbq9KgKxhc=;
        b=Ko1STg2PJ226+jeekOikuE8exvBqEB5YFKUnO4XBLh6ms83Q5iKQrGdCVHK2uyKqNn
         FiWj5hKskAX7oI9HH6RAV8jZnaGwvG67k/x/z00bjrtaCgkHN+6Y59UDSBi/BbZA+T3h
         S59Cuk7/AUL0glP1gz5cIboRQN0HuPZXbcen138Dy+1iRC5YAowORxn5ScrnlPtkbBss
         toPW5lzwZhV1BvsVWxpmtevpvf5av7Y/rEjsxWU7bth2FvVb7WirXIYwUTt9UeoCxu7M
         VbsqOoPFYGF/SsZpJvnZNcLmVNhF0WeE98oaDfU0nDot2wq45Qphi/tnjJbsRSSPfvK2
         qR9Q==
X-Gm-Message-State: AOJu0YxsZlTPbbN9WsQcxE93ljE6rHPDXn5PtNSBXtg4nuIs1fL7+aHV
	m0myEGdcXuEF0OVB4O5p2C5OvSyzRVfohS0SbzbHh/6NsRSkUO1z6/MVIQ==
X-Gm-Gg: ASbGncuoUrDwc/mFwNn3PyaEInqTOizohwUz5x8mbpglbaXm2j7cur+u14MThiBi6al
	sK6huk+O83EqyyrFK8hbS6aMLgqlGIE3xNpD+NGOyj6OXG/axrXylNeBtX6fp8dY33DCkbI/eN8
	fABIXMVgc8pb/g0fxmOde2S6bMoaeENNiUtoRCLOX8M6GWpU9yIFqgiHqs06ykian/kdObbDNfX
	oG2ytoZE8IthlYhXE4HsxSqeCbpcwQCG7+6WdJJ6O8ScjCR3Xkvl5fp1xCXAf7tPOVHPn2XOJZT
	oan09LzVkJOABqHYrV+ZUjS1
X-Google-Smtp-Source: AGHT+IH6gfRngO5psKAMIV/1y8RbOTh820VNfRE5ITEtLyWCVcGPJsNer3mMj7R5f2EWnc8sTUgsdg==
X-Received: by 2002:a17:906:c110:b0:aca:a688:fb13 with SMTP id a640c23a62f3a-ace71178f01mr1114538166b.36.1745844709589;
        Mon, 28 Apr 2025 05:51:49 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c92c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e58673dsm613010766b.76.2025.04.28.05.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 05:51:48 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: [PATCH RFC 7/7] io_uring/cmd: add tx timestamping cmd support
Date: Mon, 28 Apr 2025 13:52:38 +0100
Message-ID: <6f5b01cc66b200d99c494caaa62f429268923263.1745843119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745843119.git.asml.silence@gmail.com>
References: <cover.1745843119.git.asml.silence@gmail.com>
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
cancelled or fails in any other way (e.g. with no space in the CQ).

The command requires CQE32 as it posts the timespec value in the upper
half, and the lower cqe holds the tstamp key/id and type.

Suggested-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  6 +++
 io_uring/cmd_net.c            | 94 +++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 130f3bc71a69..3a477dbd2627 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -956,6 +956,11 @@ struct io_uring_recvmsg_out {
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
@@ -964,6 +969,7 @@ enum io_uring_socket_op {
 	SOCKET_URING_OP_SIOCOUTQ,
 	SOCKET_URING_OP_GETSOCKOPT,
 	SOCKET_URING_OP_SETSOCKOPT,
+	SOCKET_URING_OP_TX_TIMESTAMP,
 };
 
 /* Zero copy receive refill queue entry */
diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
index e99170c7d41a..9695a9f78d76 100644
--- a/io_uring/cmd_net.c
+++ b/io_uring/cmd_net.c
@@ -1,5 +1,6 @@
 #include <asm/ioctls.h>
 #include <linux/io_uring/net.h>
+#include <linux/errqueue.h>
 #include <net/sock.h>
 
 #include "uring_cmd.h"
@@ -51,6 +52,97 @@ static inline int io_uring_cmd_setsockopt(struct socket *sock,
 				  optlen);
 }
 
+static bool io_skb_has_tx_tstamp(struct sk_buff *skb, struct sock *sk)
+{
+	u32 tsflags = READ_ONCE(sk->sk_tsflags);
+	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
+
+	if (serr->ee.ee_errno != ENOMSG ||
+	    serr->ee.ee_origin != SO_EE_ORIGIN_TIMESTAMPING ||
+	    skb->len)
+		return false;
+
+	/* software time stamp available and wanted */
+	if ((tsflags & SOF_TIMESTAMPING_SOFTWARE) && skb->tstamp)
+		return true;
+	/* hardware time stamps available and wanted */
+	return (tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
+		skb_hwtstamps(skb)->hwtstamp;
+}
+
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
+	if (!skb_get_tx_timestamp(sk, skb, &ts))
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
+			if (!io_skb_has_tx_tstamp(skb, sk))
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
@@ -76,6 +168,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		return io_uring_cmd_getsockopt(sock, cmd, issue_flags);
 	case SOCKET_URING_OP_SETSOCKOPT:
 		return io_uring_cmd_setsockopt(sock, cmd, issue_flags);
+	case SOCKET_URING_OP_TX_TIMESTAMP:
+		return io_uring_cmd_timestamp(sock, cmd, issue_flags);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.48.1


