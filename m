Return-Path: <io-uring+bounces-5227-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50E349E429F
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 18:58:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF9C6169D1B
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:58:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DCA42163A7;
	Wed,  4 Dec 2024 17:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="VPIYiPnj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECB1216395
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332983; cv=none; b=iCwsAZwgReJK81UUKS0elqfHmCjOgOiClHZQjMEOubGvgGscrET+7IKW8ssFaF7jopHI8H/YrEk/qYwZbTUXZ4gT2K6/oizYi6SnoncmvVGYBC6+OkHCXdSH6Ffz38lZaY1uFTpESXDn6vAcCbzV71JIP39genpd5hQCd2PvHDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332983; c=relaxed/simple;
	bh=fIRUjS4vvOeMBBHkJIKjbB93rfw/xVgs/ceXybEIiQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3oCLdpM3tz9CxxUf9oSU2sXrYahloOrhVL7UTM/60k8wM4mJyfQzeQPfqJzs2snDFHBg8p45ldxFGMsJmytbDyYt6rCRrqNrfXd71GauP7fSXhM5VteCSoyZhid0LD2FJWPbOVB2E+ROvZLkUa2Ke+VZ+hC75+7qHkVzQlsyr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=VPIYiPnj; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-215b4681c94so203335ad.0
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1733332981; x=1733937781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4lhNvgv8G0hs8gBqFhFT3X6E9Ed5HipxBFCScbaRG/E=;
        b=VPIYiPnj8d38QUwreM78GLNMAffERT7xOY6Ah5mjK+iqYMgaojuZNRPOm++FphmRMZ
         5U9IVz7KRDyK+AfYv5lBOF4LdwqPeWUC997Qjs+prlo01PzdW+PpdL+BL07hgpz0frzF
         eeEY5ZRDPduMNfy96zuzjZA5e+llsdAknO/CoYUtWV5zRQya1951jvvpQFVGgZ24B5RM
         Szv4GtqyiICejlc9iEDXAzeMRT5uQNqoZjfrzA9RILuoA6CZwliMl5m9/9uUA2YUTVCQ
         uf/sg2lNs9n6QFoKbxn5AflTtEOCuyiQbsplx86LZs5NCS0OtPV6o7MSc/WKV8JNaY2L
         wPfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733332981; x=1733937781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4lhNvgv8G0hs8gBqFhFT3X6E9Ed5HipxBFCScbaRG/E=;
        b=ByuXUT41btZrghUnV/5e6BkdSzn3zD1D/ACsr208ghvb/BW4X8FHNsq7Zs9feXXIvS
         jT7JT875exx04aF2Td5UjqPJBN1cscQ2078kgQOLklAqoAXIjxC5atKc6gjWRinfNDW9
         kgcwI8W/kCS742APJXc4M8ZLwk+X71DnMrj9+EqyrkjK2HiGupF7nX7SteOappBCT3Uh
         oIAmUhOjwtm4goTcsLs2jKfKiUcJtjjpoJLbR5NGfnhgo+fr82A70kmVtJSG23JxQNE6
         vvD3F55IBxkMeqTaXshFeQMEqHrTjn2PNqPR08FBUYW/UwzLm95mxNvv//nt0UK0nP2J
         3fbQ==
X-Gm-Message-State: AOJu0YzgzTMAyY3OlsuvKOLvgBiqKmQpX0Z9AABbR6H38iE/hU7Br0i7
	eliXcP8CN0ApgCDXtVCYk8BeLbEnuUtVTiBSGJ48MAXA2unxc9/ysBkVDvLoSXDXJ4EXNNeHjJ0
	+
X-Gm-Gg: ASbGncuaU/66YDRngOmW8rYUYrE8mDYZo+SrtQ/m/Yt/9ZsJWgFBx+Q9fwASwm/tSJ3
	+dJ0sdFo1ZVK+Q6dDJ/Oc2P4n+6HdgLQ8k0U2IOhhkuVh873tNse6bKLlpzX53O6vUEi1c8y8vS
	/ZP5glD4jngDp/vPoUGbnke2SHUly83JxwQBfsJyGulKb5zAUWs4O7ODsobPjX297iP6sHWxq0u
	0+tOiY8tvbalf6hD/mtMv9roAGw9GetTw==
X-Google-Smtp-Source: AGHT+IEyGgkHrloo1DbCEU1iG+0u4FRI3uHNEIIXRDGGus9M7foJV2KsxPqwGImtluQhQ5s+Dxdz0w==
X-Received: by 2002:a17:902:cf04:b0:215:6489:cfb8 with SMTP id d9443c01a7336-215bcfc475cmr79920235ad.10.1733332981197;
        Wed, 04 Dec 2024 09:23:01 -0800 (PST)
Received: from localhost ([2a03:2880:ff:e::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2154e5d6965sm87999925ad.71.2024.12.04.09.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 09:23:00 -0800 (PST)
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
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v8 15/17] io_uring/zcrx: throttle receive requests
Date: Wed,  4 Dec 2024 09:21:54 -0800
Message-ID: <20241204172204.4180482-16-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241204172204.4180482-1-dw@davidwei.uk>
References: <20241204172204.4180482-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

io_zc_rx_tcp_recvmsg() continues until it fails or there is nothing to
receive. If the other side sends fast enough, we might get stuck in
io_zc_rx_tcp_recvmsg() producing more and more CQEs but not letting the
user to handle them leading to unbound latencies.

Break out of it based on an arbitrarily chosen limit, the upper layer
will either return to userspace or requeue the request.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/net.c  | 2 ++
 io_uring/zcrx.c | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index f1431317182e..c8d718d7cbe6 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1266,6 +1266,8 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret <= 0) && ret != -EAGAIN) {
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (ret == IOU_REQUEUE)
+			return IOU_REQUEUE;
 
 		req_set_fail(req);
 		io_req_set_res(req, ret, 0);
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 8e4b9bfaed99..130583fbe7ca 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -24,10 +24,13 @@
 
 #define IO_RQ_MAX_ENTRIES		32768
 
+#define IO_SKBS_PER_CALL_LIMIT	20
+
 struct io_zcrx_args {
 	struct io_kiocb		*req;
 	struct io_zcrx_ifq	*ifq;
 	struct socket		*sock;
+	unsigned		nr_skbs;
 };
 
 struct io_zc_refill_data {
@@ -705,6 +708,9 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	int i, copy, end, off;
 	int ret = 0;
 
+	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
+		return -EAGAIN;
+
 	if (unlikely(offset < skb_headlen(skb))) {
 		ssize_t copied;
 		size_t to_copy;
@@ -809,6 +815,9 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			ret = -ENOTCONN;
 		else
 			ret = -EAGAIN;
+	} else if (unlikely(args.nr_skbs > IO_SKBS_PER_CALL_LIMIT) &&
+		   (issue_flags & IO_URING_F_MULTISHOT)) {
+		ret = IOU_REQUEUE;
 	} else if (sock_flag(sk, SOCK_DONE)) {
 		/* Make it to retry until it finally gets 0. */
 		if (issue_flags & IO_URING_F_MULTISHOT)
-- 
2.43.5


