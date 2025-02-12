Return-Path: <io-uring+bounces-6377-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1D17A32F1D
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 20:00:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 490A7188A223
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 19:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A689263C81;
	Wed, 12 Feb 2025 18:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ftrWzmuJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75912262817
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 18:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739386756; cv=none; b=uxFf9Dmh2PrMlhaKdlgZvx8t7WyBT0k05wAc9ROrH9qJYsztDulXQ25LBBSmB62oj+Fx4ysQKtRa5+b1Y3ZD5fm2dpPYT1TtkP+JFGqTwe5z9jX0nthHRNcvWDDTR6NmxdxsV6TNlw4qVWul3b4KXKNmdgXVup/nWVIydzSMDC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739386756; c=relaxed/simple;
	bh=ee/nN2D6QNSrV0ltZWEtUTkHe8hZqD01WUDrrxCQo70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHAkDJqjcSnsHzD+x45ojT0xdaMVE/IpfEAr5iWTMhROeLoZ+V/pW4q5v9KAkHVmj4o/Nchi4N8dTpofuHlETxmazJqWq0Bd2YflesaWFzdCprx5cLenhuScDrlT4ZWKKdn5E1NEDDVtBZ52je2SL0STvqZuNPz503S7PD4MZKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ftrWzmuJ; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21f818a980cso70797395ad.3
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 10:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739386754; x=1739991554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jwmwJaLfYGswpQ8xBKMbzXODDugRtY7fPeN6XrAbeLU=;
        b=ftrWzmuJtqIMkJa6jAxpWUC81DHa51Zk8fQ1Xa3CLpEg8VAgI/H0kSii8DIk+CVyk5
         Dc42oAhXA2uGZdgmdlFnhcjwF+mMbjnPiiB7FazAjsI7HruAxhHER1Lzf/6KohmQcH/y
         +NEOS5no4YHDQm3KDN8NbmqwiobBvAxADjsG6nIQkuaYYRKxTuVUqlmev4GEKXKRlEg0
         U+lp+Jq3Bl0PfcrsL67nanN9h6QkaAmxm1Ppoi18RMyXUmMQH3lYwnfr1oMNIMwhecrQ
         TMbJ6tHKCkmCO10KljZxovzNnLpX8JlazIVKg45kVT9N2t9acc2m9Q1kJEtMtBPDUQfu
         rs0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739386754; x=1739991554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jwmwJaLfYGswpQ8xBKMbzXODDugRtY7fPeN6XrAbeLU=;
        b=cePRPvY3WB0rWD0JK3U/ubPjfzk53llBol2Y0Vgl+7t/wwsfBMFKx41qx0TkjdMsv+
         joHYrOZuEmoX6SrNumi60b8gJGG3CNgggqJWzinuShAL6JFR0rrVkv0ri2463W6MkSBE
         Cjc5BRC5g3H5XVOLXQs52bLJbgnKvpmZ0MndfSvfayicNkR+mZ4e+vKjtskPRRYxZjDC
         xH8ccMsmBr3P8ZoTx2FBEpDgUkW5gKAN63I/5SbG1gdeMEgSXpG37OiAMU4tHFJC7q+2
         cjsD6Oh4HDbCbfWYxk5jfFwg9yxNxtKnoS/vyB1tZkY3muxrDUAXjCY4Xlg34uPBYunN
         oDJQ==
X-Gm-Message-State: AOJu0Yx6ROWPjp0KHZZwCWTV3rR2L6qvA0vxRFa8BWCi9wwMeGWRmsZc
	Qz5RO0hvIvAPmtZu4YLlhrqMwwl8vabnh4gWUhfZbdvjqtMGK0FGMKvrCPh9pdcZIfPiO+VAlIk
	z
X-Gm-Gg: ASbGncv8FXunumoI4kQsU2iYH1j+UeuQDtO9f7tUN1M2YVqLWBrT0lIJAfMlIoNgkDc
	gyZRbAhYp6crzw1+4OLCuK+iofxlxWYHbCgrEkoc74doilXfDm9h6DsonX6bab3Nz4dPkrX9Z2a
	TY8nBv3PaT/OiXwxHsrlC7ZVXFOBfwG6WsqYNqcPqvIZKryYt1HZHKQBnzGuBuiaxXKezG6+zyf
	GdtZH+B1ZkvQFvSXmvlq9JUw7X8uTwleSDdV7ubFfF2Pc/aku6v1kxdhs46eLYAfgWlGGfMHBc=
X-Google-Smtp-Source: AGHT+IG7KHjLnWLQTFWVT1k+WnOpKOaw9wmIuzkylonZYRxl3HKxiIApLSWaXxMBbETPpgwijus8UA==
X-Received: by 2002:a05:6a20:2583:b0:1ed:a4b3:800 with SMTP id adf61e73a8af0-1ee5c747328mr7052965637.12.1739386753847;
        Wed, 12 Feb 2025 10:59:13 -0800 (PST)
Received: from localhost ([2a03:2880:ff:3::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ad54f1691ddsm6075971a12.61.2025.02.12.10.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 10:59:13 -0800 (PST)
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
Subject: [PATCH net-next v13 08/11] io_uring/zcrx: throttle receive requests
Date: Wed, 12 Feb 2025 10:57:58 -0800
Message-ID: <20250212185859.3509616-9-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250212185859.3509616-1-dw@davidwei.uk>
References: <20250212185859.3509616-1-dw@davidwei.uk>
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
index 260eb73a5854..000dc70d08d0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1285,6 +1285,8 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret <= 0) && ret != -EAGAIN) {
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (ret == IOU_REQUEUE)
+			return IOU_REQUEUE;
 
 		req_set_fail(req);
 		io_req_set_res(req, ret, 0);
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index af357400aeb8..8f8a71f5d0a4 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -92,10 +92,13 @@ static void io_zcrx_sync_for_device(const struct page_pool *pool,
 
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
@@ -717,6 +720,9 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	int i, copy, end, off;
 	int ret = 0;
 
+	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
+		return -EAGAIN;
+
 	start = skb_headlen(skb);
 	start_off = offset;
 
@@ -807,6 +813,9 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
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


