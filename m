Return-Path: <io-uring+bounces-63-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FCE27E4AF5
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:42:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD536281514
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D567D2BD05;
	Tue,  7 Nov 2023 21:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="TPoADq/V"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F17C450F4
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:41:09 +0000 (UTC)
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE11C10E7
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:41:08 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1cc3216b2a1so50328175ad.2
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393268; x=1699998068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H88/FIrlrOF9cEijoa57DWCiKAkLO7WMP992r2a8IF0=;
        b=TPoADq/V/11CTgjT/bXQohO+wcWOl7AGkhcHzFxCxCxvNvwcYR+hkNSuqt2vfeXyBY
         JLclsyMA92/c5mY5i6a6nfpJKwXY4WTNIUOlZQgp7J2WIMsWnGsi5jwRCKYdlpENXihb
         xMQyKWiMkUF5SDagEbBU3gesND8DPltcJifCDhXwNGqjTDvsunP8z6UDuxEGWRqg9E/+
         25ZSzAE6qQTKeh5ebWD0jP7Hul9Nf+6fVHpszTHDb3kZ22d4XfqcqLHyifkvSw/xHD9B
         1xwFjcnWkse6dQ9Dhb/Y8jzG0mdgXYLYwJgx7i2CVleGXVl2El2mAXzCUAdEE3tTr+xO
         Quig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393268; x=1699998068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H88/FIrlrOF9cEijoa57DWCiKAkLO7WMP992r2a8IF0=;
        b=VbW+adLnBscVk0LX+ZT3vtJIcTC6XMqm3XdZEtpMh9jcIeeM/UBOielh7c5hErkJgs
         t0z7+UO1GQFjXUO2S5GrXG0d2vozOW0aNpGDKYQHNLf7eNnmGF/2LIMG3gNvmrHz6DE+
         gNfrc1i1eMPxgPXRBiTbbndqykyUmJxsP8xfaOsVT+5WpWBzoPBVPiumhNFWBD9dD8wk
         11tHae279XqVAgxEESxb/NXmyEv4kIe7uJcTwO7TPEDXQ5gnCoTDkhZNcRC6oU2reavr
         yAuBAGq9AUGJ0ONWe7b00r5lCS4KgZ0WvJtBOupDe4pPyUj1ucXpB1IUR8so7RGFs26r
         +Xgw==
X-Gm-Message-State: AOJu0YyupgUxrF9/f9NKzaf15oj55guIPFyG1p5dwDf0npk5PPsDJdlF
	ti13JJIU+H4xCvsTbV7XPXTuxG1rDEFVJ9zOI6IfMw==
X-Google-Smtp-Source: AGHT+IHl9L3su6ib7CEqSX0f32m1v8z2zQFvHUGj1R2HWuJaFei56dCXR3qaXd6c5WDITbtZTIWrZA==
X-Received: by 2002:a17:902:8f8c:b0:1cc:665d:f818 with SMTP id z12-20020a1709028f8c00b001cc665df818mr181332plo.68.1699393267988;
        Tue, 07 Nov 2023 13:41:07 -0800 (PST)
Received: from localhost (fwdproxy-prn-001.fbsv.net. [2a03:2880:ff:1::face:b00c])
        by smtp.gmail.com with ESMTPSA id w5-20020a170902e88500b001c5fe217fb9sm260355plg.267.2023.11.07.13.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:41:07 -0800 (PST)
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
Subject: [PATCH 13/20] io_uring/zcrx: propagate ifq down the stack
Date: Tue,  7 Nov 2023 13:40:38 -0800
Message-Id: <20231107214045.2172393-14-dw@davidwei.uk>
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

We need to know the current ifq for copy fallback purposes, so pass it
down from the issue callback down to zc_rx_recv_frag(). It'll also be
needed in the future for notifications, accounting and so on.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/net.c   |  2 +-
 io_uring/zc_rx.c | 30 +++++++++++++++++++-----------
 io_uring/zc_rx.h |  3 ++-
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 79f2ed3a6fc0..e7b41c5826d5 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1053,7 +1053,7 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 	if (flags & MSG_WAITALL)
 		min_ret = zc->len;
 
-	ret = io_zc_rx_recv(sock, zc->datalen, flags);
+	ret = io_zc_rx_recv(ifq, sock, zc->datalen, flags);
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
 			if (issue_flags & IO_URING_F_MULTISHOT)
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 842aae760deb..038692d3265e 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -577,7 +577,7 @@ static struct io_zc_rx_ifq *io_zc_rx_ifq_skb(struct sk_buff *skb)
 }
 
 static int zc_rx_recv_frag(struct io_zc_rx_ifq *ifq, const skb_frag_t *frag,
-			   int off, int len)
+			   int off, int len, bool zc_skb)
 {
 	struct io_uring_rbuf_cqe *cqe;
 	unsigned int cq_idx, queued, free, entries;
@@ -588,7 +588,7 @@ static int zc_rx_recv_frag(struct io_zc_rx_ifq *ifq, const skb_frag_t *frag,
 	page = skb_frag_page(frag);
 	off += skb_frag_off(frag);
 
-	if (likely(ifq && is_zc_rx_page(page))) {
+	if (likely(zc_skb && is_zc_rx_page(page))) {
 		mask = ifq->cq_entries - 1;
 		pgid = page_private(page) & 0xffffffff;
 		io_zc_rx_get_buf_uref(ifq->pool, pgid);
@@ -618,14 +618,19 @@ static int
 zc_rx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	       unsigned int offset, size_t len)
 {
-	struct io_zc_rx_ifq *ifq;
+	struct io_zc_rx_ifq *ifq = desc->arg.data;
+	struct io_zc_rx_ifq *skb_ifq;
 	struct sk_buff *frag_iter;
 	unsigned start, start_off;
 	int i, copy, end, off;
+	bool zc_skb = true;
 	int ret = 0;
 
-	ifq = io_zc_rx_ifq_skb(skb);
-	if (!ifq) {
+	skb_ifq = io_zc_rx_ifq_skb(skb);
+	if (unlikely(ifq != skb_ifq)) {
+		zc_skb = false;
+		if (WARN_ON_ONCE(skb_ifq))
+			return -EFAULT;
 		pr_debug("non zerocopy pages are not supported\n");
 		return -EFAULT;
 	}
@@ -649,7 +654,7 @@ zc_rx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 				copy = len;
 
 			off = offset - start;
-			ret = zc_rx_recv_frag(ifq, frag, off, copy);
+			ret = zc_rx_recv_frag(ifq, frag, off, copy, zc_skb);
 			if (ret < 0)
 				goto out;
 
@@ -690,16 +695,18 @@ zc_rx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	return offset - start_off;
 }
 
-static int io_zc_rx_tcp_read(struct sock *sk)
+static int io_zc_rx_tcp_read(struct io_zc_rx_ifq *ifq, struct sock *sk)
 {
 	read_descriptor_t rd_desc = {
 		.count = 1,
+		.arg.data = ifq,
 	};
 
 	return tcp_read_sock(sk, &rd_desc, zc_rx_recv_skb);
 }
 
-static int io_zc_rx_tcp_recvmsg(struct sock *sk, unsigned int recv_limit,
+static int io_zc_rx_tcp_recvmsg(struct io_zc_rx_ifq *ifq, struct sock *sk,
+				unsigned int recv_limit,
 				int flags, int *addr_len)
 {
 	size_t used;
@@ -712,7 +719,7 @@ static int io_zc_rx_tcp_recvmsg(struct sock *sk, unsigned int recv_limit,
 
 	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 	while (recv_limit) {
-		ret = io_zc_rx_tcp_read(sk);
+		ret = io_zc_rx_tcp_read(ifq, sk);
 		if (ret < 0)
 			break;
 		if (!ret) {
@@ -767,7 +774,8 @@ static int io_zc_rx_tcp_recvmsg(struct sock *sk, unsigned int recv_limit,
 	return ret;
 }
 
-int io_zc_rx_recv(struct socket *sock, unsigned int limit, unsigned int flags)
+int io_zc_rx_recv(struct io_zc_rx_ifq *ifq, struct socket *sock,
+		  unsigned int limit, unsigned int flags)
 {
 	struct sock *sk = sock->sk;
 	const struct proto *prot;
@@ -783,7 +791,7 @@ int io_zc_rx_recv(struct socket *sock, unsigned int limit, unsigned int flags)
 
 	sock_rps_record_flow(sk);
 
-	ret = io_zc_rx_tcp_recvmsg(sk, limit, flags, &addr_len);
+	ret = io_zc_rx_tcp_recvmsg(ifq, sk, limit, flags, &addr_len);
 
 	return ret;
 }
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
index bfba21c370b0..fac32089e699 100644
--- a/io_uring/zc_rx.h
+++ b/io_uring/zc_rx.h
@@ -62,6 +62,7 @@ static inline int io_register_zc_rx_sock(struct io_ring_ctx *ctx,
 
 int io_recvzc(struct io_kiocb *req, unsigned int issue_flags);
 int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-int io_zc_rx_recv(struct socket *sock, unsigned int limit, unsigned int flags);
+int io_zc_rx_recv(struct io_zc_rx_ifq *ifq, struct socket *sock,
+		  unsigned int limit, unsigned int flags);
 
 #endif
-- 
2.39.3


