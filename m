Return-Path: <io-uring+bounces-5943-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DDEBA14550
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:19:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A562C7A266F
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CDAF242244;
	Thu, 16 Jan 2025 23:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="O+gLlPkV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D1E2459D7
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 23:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069449; cv=none; b=TogTG2mB56siYWK81rqSVdYbSH9Wncb59HDDgMh5twXXqCB7dsNZxi1mT9p1kodwqVX3bZ8jT0WwHjgy9Ir0HUvnXYVLTptXOp9ww6xLQuJdfOEiHqn6qLKeXNGnt/aGatW02UrgQ8GALTfjif5en3LCTTgTCMXyzKK9yKmD4Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069449; c=relaxed/simple;
	bh=a0yytqucfmG1Nfx2iu7A4JDn1CAOzvKCv+TQ/9N91bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUldC7zUfbFMd4l9kRgJGbxLA+OY0E8iVggL0TeSoygJ9BA74cY9iVS2IK40JUWIN19dHH5lNAGGJ5SF7OGwTGrZrgGubExyRuRD0U/p5zSA1iOm/UG+Zpp8zunD2VeKhtWgiUzjAzfNMmvAL52zzJ6wI3RMmhpSTFo3iAoyR3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=O+gLlPkV; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-21661be2c2dso28582915ad.1
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 15:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737069447; x=1737674247; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SuAE6fDwK//h41IEaYgXJ1RaqDuWb9ybdIHvBrGsuDQ=;
        b=O+gLlPkV52bHn1XRniav5XFAlgW77hcATQL58hLTv+u9mXVeYbbGONGivIWbhIxK0M
         WlNEHeU+vjFJ03pglNcqyO6nTRkmYt7/4AEm7yP6bsBrjIa3axP6g0clwItFl3mcTciN
         Qo2UaOp5FW121vekzW11r5lDbLmxKswD8BhtRFC29jS3WM2V2c296b7UvxqlTTFVJdwv
         t2ZDn6NTWzZzRw97seYPK0SNVMfUjHXmXzX1a/+7+7ozRlmUxWJ+MjbHF7xtEmkXHr4R
         oHAGgj9ETbPndG5LDVt5hF2K4Z01kUoDiI8fzUmIVtrWKR0uUO6CuNP/dKmDGqKuF0Vc
         L4Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737069447; x=1737674247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SuAE6fDwK//h41IEaYgXJ1RaqDuWb9ybdIHvBrGsuDQ=;
        b=YHfa/QFU80H7Ooi/yBaZYdLxpkMtai6/eiufz6Hi+bVrdwaDcdsErFjtToUYxR7oOU
         RyHe73IA4/H5bCQszQA1wmvTPso74Ykoc5xzNMC8TuxxGPftNUjX8p0n0F8C6OovqTLI
         4qsKDyR7oF3vgJdahvPlEKrUpVcMgLbFFviMEBsvmeCqBAM0OLLLni9UKlqcygmmPTuB
         VsR1xS10AdIMDKhYpS4ix6n3Q2cXej46wzuGgyjOW3qzIvyBZkZFaQdgSQXHaq7ZDgwZ
         YTz1gAEL4C1hveUiNvqAQgamfdKhsMwLn0jxz5sKScOIntyJ1UHFALmkLhJfPQ00onhh
         xYSg==
X-Gm-Message-State: AOJu0Yyl1rDH/ISoNtMchC9SSJDGA+QcGu6V3UyaQy5uRLNkVoM64UL/
	8JXX4Ssjgv0JMDJh4TE5sutvxQHpTRHkqvcfDDdM67WKj72quarbbnDGJYfnVrlMh8TcnQhhI5X
	0
X-Gm-Gg: ASbGncvHCXKLDUeqLVEIqzIzsyh9s0NV8ldJaEE4d2dUwXQZTG8T5b/AtRmx2x8b2pp
	JOwNsi5yIJDGzm4TUwX2YvkhY99UH6Jv1dmt/slxAfztSBGiB0tZuUolhQ48XdLCSAzoBK4ig+4
	bH4Dfcx1w2UwTfkha4acBJ+xNqW6ztpnu4yDDNW7GELS1k292FkeJ7Co29w3Wow+sg1htGlMlPS
	CBjUKsC5BvPhJd4vQqGJ+NPcH+CX+zgoUO+Q45lGg==
X-Google-Smtp-Source: AGHT+IFqPtYTzhwR/lxML7Vm56sgRoBNvogqzdMHmjzhV3yhmtRlZcd4FMZX5F+JH/qyvtKHo2F0KQ==
X-Received: by 2002:a17:903:947:b0:216:5b64:90f6 with SMTP id d9443c01a7336-21c355fa2eamr7843835ad.45.1737069447373;
        Thu, 16 Jan 2025 15:17:27 -0800 (PST)
Received: from localhost ([2a03:2880:ff:14::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2d404755sm4862385ad.243.2025.01.16.15.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:17:27 -0800 (PST)
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
Subject: [PATCH net-next v11 18/21] io_uring/zcrx: throttle receive requests
Date: Thu, 16 Jan 2025 15:17:00 -0800
Message-ID: <20250116231704.2402455-19-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250116231704.2402455-1-dw@davidwei.uk>
References: <20250116231704.2402455-1-dw@davidwei.uk>
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
index 0cfa8c0ecff8..6f3fbb9337db 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -94,10 +94,13 @@ static void io_zcrx_sync_for_device(const struct page_pool *pool,
 
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
@@ -713,6 +716,9 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	int i, copy, end, off;
 	int ret = 0;
 
+	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
+		return -EAGAIN;
+
 	start = skb_headlen(skb);
 	start_off = offset;
 
@@ -803,6 +809,9 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
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


