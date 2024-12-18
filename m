Return-Path: <io-uring+bounces-5555-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8971E9F5BD5
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:42:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33842188849D
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 965EC70817;
	Wed, 18 Dec 2024 00:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="kHGnU2RC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BEA146A68
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482299; cv=none; b=ktndEaUt/oy+k6dAYCLmbRs/O1IyVhYaWXDy37JMvDKFVvfmsUQowlNuFUD95gqnM8xybuAeEzfSqo7OOiqqzxDhvJzJ8ehpeSmheopa7qBdt4w3usUMgTejdK2C4iuhzMAoK32P+8eYw8GEwdAQbNngMz3IVHwrva0y9RCZZUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482299; c=relaxed/simple;
	bh=lVCOuuWDfuKOXGIrHnPB8CsTsDheB1WzUxlQN8EhV+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUEf3fwjBujEBaah38HT29e0bPYCWak90/67oEDvbNhiYewoVmWq8JOJki9PNQ8GEb7Ghp2nbnPQHd8gFeCGT9rRyXVSqT4IlFhbLaCS+UuoBubGYyO5gBCW0cuf8yJ8e5TS4+gBrOZjIZKOQS+q8J0NzKUXj8SC+Uy7eum2bI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=kHGnU2RC; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-728ea1e0bdbso4629158b3a.0
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482296; x=1735087096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AAmVgJjEX2zRkXc1WMFyYK6FynX6DxypvcjR34FvDLQ=;
        b=kHGnU2RCcKoHe04FV86GSQFM6UfD1bAvIYKBh7116FMC0BdfQP+bqHGXC/x+EXGW6E
         FsBAjKKNL0/U3M63HxXYlGp+zpeS7guqQ9PRwBLyApKyHQulebHsbLiqyV8Ka5FkwGdz
         MTGDpbQvjTJlD1XyiUv3+85cLH8h8OD+XhUKHkQSGW595TF8kyjQbyhYWWPc42z0wUh6
         c4tqR8XVI2G7qyEgp6Yn5APF0Iv5pWOsvCjXVbXHWQYT7za2mphJImecjtTsXYxHHDMm
         9voALYEaFSSiM1bDpXugs4AJNZhX35X9Dbtp/KAFnOX1W7XIcgGZ7wkA2xf4n+dmsx0/
         xY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482296; x=1735087096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AAmVgJjEX2zRkXc1WMFyYK6FynX6DxypvcjR34FvDLQ=;
        b=lswvriKREsHDw74AaBtkBfCw52hcy8JbEmPlcywG2seSDxjGAf0Vn6LyuPeqZLlsP3
         jOxWmLGKT2kLW1y/C8OxG+4m0jtc7ox6OSW3CeAADNrNM1v8Oh+sPrGVWOBNHi37bOcT
         yuu0SqG1t8BQsnsMJlS0VfUJRXJSvJtzaxEbWLI4SM+KpluZQkJ2XDoXBsEFQhRehj4n
         BQnIMHZnpddsOSpbo7v/0nJQ7xSNIsd8+wR+vHS4amwzF3m5ZdQovVIg7sgpeT9KxYj0
         hTF/9ThafbOl0Vr9FGN8uDgDtDxQv+L/FWrKh+UFCjbWl/hlEidYXyPt61fzFuIFWt7B
         Oyyg==
X-Gm-Message-State: AOJu0YxwAWCamD/XmV5MO+uU9vs8MZAdVPATpvMlfids7o+Aqc/zOpCP
	Tnipr+U1g0rraYNu/XgXAtkpwiE8CWo5ZUSDz2V+VxK/LkYwXW7Ybwpx3+VmEi5jF213RfRZf2z
	m
X-Gm-Gg: ASbGnctkTT7fDFa+qBm13GZ0TX+FniXI4LMP1kKxBFKeSy9KJtkyRO6raEV5LktYGja
	IaWK3R9YSYiXYA8dCe6W7T8Ta5H92kOKxZ1BcplCqkV0OFkdBqt+st4WxBnqoXocIEf3fdxwkq2
	FAXg2lDF4J/H7oaU6v5s+d+TUHuEkAmz9Qy7zwxXP2hPoJsut3gAry8r9jQ/KcpJ2bZ/5G5eT1A
	wNW3ceinsIuv/bRpYd8ndIik2NHToVrqJYt4WDgEg==
X-Google-Smtp-Source: AGHT+IGBYf6cB6qBpXVxmhnTAAXi9dKtoUVUeDwYV+80YBoMFlVtpBJajP377jN3aOi0ncdTXU6FdA==
X-Received: by 2002:a05:6a20:4309:b0:1e0:d8c1:cfe2 with SMTP id adf61e73a8af0-1e5b487df65mr1755623637.34.1734482296299;
        Tue, 17 Dec 2024 16:38:16 -0800 (PST)
Received: from localhost ([2a03:2880:ff:13::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72918af0eb1sm7315461b3a.84.2024.12.17.16.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:38:15 -0800 (PST)
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
Subject: [PATCH net-next v9 17/20] io_uring/zcrx: throttle receive requests
Date: Tue, 17 Dec 2024 16:37:43 -0800
Message-ID: <20241218003748.796939-18-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241218003748.796939-1-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
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
index 5d8b9a016766..86eaba37e739 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1267,6 +1267,8 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret <= 0) && ret != -EAGAIN) {
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (ret == IOU_REQUEUE)
+			return IOU_REQUEUE;
 
 		req_set_fail(req);
 		io_req_set_res(req, ret, 0);
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 756c78c0920e..ffa388fbb1e4 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -83,10 +83,13 @@ static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 
 #define IO_RQ_MAX_ENTRIES		32768
 
+#define IO_SKBS_PER_CALL_LIMIT	20
+
 struct io_zcrx_args {
 	struct io_kiocb		*req;
 	struct io_zcrx_ifq	*ifq;
 	struct socket		*sock;
+	unsigned		nr_skbs;
 };
 
 static const struct memory_provider_ops io_uring_pp_zc_ops;
@@ -702,6 +705,9 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	int i, copy, end, off;
 	int ret = 0;
 
+	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
+		return -EAGAIN;
+
 	start = skb_headlen(skb);
 	start_off = offset;
 
@@ -792,6 +798,9 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
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


