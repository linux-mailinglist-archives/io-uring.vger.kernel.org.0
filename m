Return-Path: <io-uring+bounces-71-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AF607E4B07
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:43:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50DB9B20D57
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD642BCEE;
	Tue,  7 Nov 2023 21:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="DZYmBary"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39E52CCB7
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:41:15 +0000 (UTC)
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2988F10E9
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:41:15 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1cc53d0030fso1101075ad.0
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393274; x=1699998074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aN4oMaI4R9lQb3D1p9Iwygb5XnCuCVbIIXzTcWlvdpg=;
        b=DZYmBaryiWUy/oPARqPJEF50u3v87tKbQ+qlTDjEt+UZkUiQhUxbAEu/Qd/p+Ogq27
         d7N9vlSeIqGRlql1kNg/G05KyA57/ORqXhTfg4D/CezVvVmGH2U4xNw6yxvAJ6INI0y3
         CO/AWhUrrjSKleYEJXusYjx4C5UsiPzraOsgabEtG3cPh5dtDGWiIHdRdSBzA9Fv5o5o
         5dAtXybbO3nrDOEAPSY6FEy5fDxIA4UCk7Pth5XS6pHI4M2KFKZ6qviCoB9FWPHsKWcE
         OkVOSpIj97lVJt0OQ9SCt+ZeHjAMF6ogNVwI3r1o7WMppaVR4VnG2h0ya1aH8dP4mqec
         Ijng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393274; x=1699998074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aN4oMaI4R9lQb3D1p9Iwygb5XnCuCVbIIXzTcWlvdpg=;
        b=EQoC8jrR7ZE+fV40/vV+2p7XFlZWR0kw31/Lsv4ggVb/h+WNn5j6v1KtkXeDSsPePk
         jshajyDyQBtXDtEDHfEmOVwoqZgOCsEmCpo3u3HvnjewxYicPOHFVF2G2sAeKb3yM+9+
         9iA7hkDgLkQ3gs01hFp3k1NsOKgQGmKBzj2Zs82SWvb67HX5edRORRolAORQU5tJ3NvY
         2EL9HPyP5ULOe0C5qcKEwAqGjYZZ6RIvj5NbDWQE2uloGcIkBNCHzd2h8nEleIiiUH+Z
         LuByY9dEq3BdGRS9PAi0bTWSmUEIAxytcBfsy5MyCRMKEFfF/9mrJhMF4wONq90YkMHl
         14Bg==
X-Gm-Message-State: AOJu0YyIgZiJgdGzFVS/zy7OiV8gkc3a9o+gDDbCp9cPHcunyPIXyhRA
	S+w2fsU3qSmPTC+20C0/SIjmcGf9wfoGlf09A5Z4qQ==
X-Google-Smtp-Source: AGHT+IEC28F2Hi8Z2PLSGIkXJCyYnwk65ti/b8HkC4XdItbMFIjTiR7+o2qyYlTD6mIX1MINY5plzA==
X-Received: by 2002:a17:903:2281:b0:1cc:332f:9e4b with SMTP id b1-20020a170903228100b001cc332f9e4bmr12727plh.1.1699393274402;
        Tue, 07 Nov 2023 13:41:14 -0800 (PST)
Received: from localhost (fwdproxy-prn-011.fbsv.net. [2a03:2880:ff:b::face:b00c])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902748a00b001cc0d1af177sm264672pll.229.2023.11.07.13.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:41:14 -0800 (PST)
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
Subject: [PATCH 20/20] io_uring/zcrx: add multi socket support per Rx queue
Date: Tue,  7 Nov 2023 13:40:45 -0800
Message-Id: <20231107214045.2172393-21-dw@davidwei.uk>
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

Extract the io_uring internal sock_idx from a sock and set it in each
rbuf cqe. This allows userspace to distinguish which cqe belongs to
which socket (and by association, which flow).

This complicates the uapi as userspace now needs to keep a table of
sock_idx to bufs per loop iteration. Each io_recvzc request on a socket
will return its own completion event, but all rbuf cqes from all sockets
already exist in the rbuf cq ring.

Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h |  3 ++-
 io_uring/net.c                |  1 +
 io_uring/zc_rx.c              | 29 ++++++++++++++++++++++-------
 3 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 603d07d0a791..588fd7eda797 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -754,8 +754,9 @@ struct io_uring_rbuf_cqe {
 	__u32	off;
 	__u32	len;
 	__u16	region;
+	__u8	sock;
 	__u8	flags;
-	__u8	__pad[3];
+	__u8	__pad[2];
 };
 
 struct io_rbuf_rqring_offsets {
diff --git a/io_uring/net.c b/io_uring/net.c
index e7b41c5826d5..4f8d19e88dcb 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1031,6 +1031,7 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct io_zc_rx_ifq *ifq;
+	unsigned sock_idx;
 
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		return -EAGAIN;
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 611a068c3402..fdeaed4b4883 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -47,6 +47,11 @@ struct io_zc_refill_data {
 	unsigned count;
 };
 
+struct io_zc_rx_recv_args {
+	struct io_zc_rx_ifq	*ifq;
+	struct socket		*sock;
+};
+
 static inline u32 io_zc_rx_cqring_entries(struct io_zc_rx_ifq *ifq)
 {
 	struct io_rbuf_ring *ring = ifq->ring;
@@ -667,7 +672,7 @@ static inline struct io_uring_rbuf_cqe *io_zc_get_rbuf_cqe(struct io_zc_rx_ifq *
 }
 
 static ssize_t zc_rx_copy_chunk(struct io_zc_rx_ifq *ifq, void *data,
-				unsigned int offset, size_t len)
+				unsigned int offset, size_t len, unsigned sock_idx)
 {
 	size_t copy_size, copied = 0;
 	struct io_uring_rbuf_cqe *cqe;
@@ -702,6 +707,7 @@ static ssize_t zc_rx_copy_chunk(struct io_zc_rx_ifq *ifq, void *data,
 		cqe->off = pgid * PAGE_SIZE + off;
 		cqe->len = copy_size;
 		cqe->flags = 0;
+		cqe->sock = sock_idx;
 
 		offset += copy_size;
 		len -= copy_size;
@@ -712,7 +718,7 @@ static ssize_t zc_rx_copy_chunk(struct io_zc_rx_ifq *ifq, void *data,
 }
 
 static int zc_rx_recv_frag(struct io_zc_rx_ifq *ifq, const skb_frag_t *frag,
-			   int off, int len, bool zc_skb)
+			   int off, int len, unsigned sock_idx, bool zc_skb)
 {
 	struct io_uring_rbuf_cqe *cqe;
 	struct page *page;
@@ -732,6 +738,7 @@ static int zc_rx_recv_frag(struct io_zc_rx_ifq *ifq, const skb_frag_t *frag,
 		cqe->region = 0;
 		cqe->off = pgid * PAGE_SIZE + off;
 		cqe->len = len;
+		cqe->sock = sock_idx;
 		cqe->flags = 0;
 	} else {
 		u32 p_off, p_len, t, copied = 0;
@@ -741,7 +748,7 @@ static int zc_rx_recv_frag(struct io_zc_rx_ifq *ifq, const skb_frag_t *frag,
 		skb_frag_foreach_page(frag, off, len,
 				      page, p_off, p_len, t) {
 			vaddr = kmap_local_page(page);
-			ret = zc_rx_copy_chunk(ifq, vaddr, p_off, p_len);
+			ret = zc_rx_copy_chunk(ifq, vaddr, p_off, p_len, sock_idx);
 			kunmap_local(vaddr);
 
 			if (ret < 0)
@@ -758,9 +765,12 @@ static int
 zc_rx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	       unsigned int offset, size_t len)
 {
-	struct io_zc_rx_ifq *ifq = desc->arg.data;
+	struct io_zc_rx_recv_args *args = desc->arg.data;
+	struct io_zc_rx_ifq *ifq = args->ifq;
+	struct socket *sock = args->sock;
 	struct io_zc_rx_ifq *skb_ifq;
 	struct sk_buff *frag_iter;
+	unsigned sock_idx = sock->zc_rx_idx & IO_ZC_IFQ_IDX_MASK;
 	unsigned start, start_off = offset;
 	int i, copy, end, off;
 	bool zc_skb = true;
@@ -778,7 +788,7 @@ zc_rx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 		size_t to_copy;
 
 		to_copy = min_t(size_t, skb_headlen(skb) - offset, len);
-		copied = zc_rx_copy_chunk(ifq, skb->data, offset, to_copy);
+		copied = zc_rx_copy_chunk(ifq, skb->data, offset, to_copy, sock_idx);
 		if (copied < 0) {
 			ret = copied;
 			goto out;
@@ -807,7 +817,7 @@ zc_rx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 				copy = len;
 
 			off = offset - start;
-			ret = zc_rx_recv_frag(ifq, frag, off, copy, zc_skb);
+			ret = zc_rx_recv_frag(ifq, frag, off, copy, sock_idx, zc_skb);
 			if (ret < 0)
 				goto out;
 
@@ -850,9 +860,14 @@ zc_rx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 
 static int io_zc_rx_tcp_read(struct io_zc_rx_ifq *ifq, struct sock *sk)
 {
+	struct io_zc_rx_recv_args args = {
+		.ifq = ifq,
+		.sock = sk->sk_socket,
+	};
+
 	read_descriptor_t rd_desc = {
 		.count = 1,
-		.arg.data = ifq,
+		.arg.data = &args,
 	};
 
 	return tcp_read_sock(sk, &rd_desc, zc_rx_recv_skb);
-- 
2.39.3


