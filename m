Return-Path: <io-uring+bounces-6463-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EF1CA36999
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 01:14:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C34F16F217
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 00:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93C2513C80E;
	Sat, 15 Feb 2025 00:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ZC7ByNfX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C011519B7
	for <io-uring@vger.kernel.org>; Sat, 15 Feb 2025 00:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739578211; cv=none; b=QbtN6jQr7fvjgZHha3aBBPAwvBM+3ueXrdm0wQMBsSBbpmhUt4de7HRQrmXb+cKP6sCjZ8l3D5eoqliWPHsDEqGaeJjn7tCGHjnlesXtKIr1Xc3E4KRhI7fc4FCsI+o6T2QI6kXasTGbirEMd9ny5/FjbkOY2Faqm6/05Axvi7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739578211; c=relaxed/simple;
	bh=0MhYOdt8cjrVmKwEWCLWnrpFJTfV5rsb6X7z7fMlHBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNWFlrZMPsndEEpkH8roMFkMLcU7EKoMUO80qWYLr/eIS4ghDH6NgIXqY3ciysTDE24Kh4r5uG42A/jMKam9hwujwtBrfs21rtxTBhs0wkohBhzBw36gfwVXrH+LoqJKIcTQnDs2Vk6l41Dy9ARH493HLFY4WdWcXOpSvfyhrOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ZC7ByNfX; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2fbfc9ff0b9so4174062a91.2
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 16:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739578209; x=1740183009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VsiC6df/8ep3kbOMlvv6NHk6oNEYLUzPa8XU1Wwcwfk=;
        b=ZC7ByNfXE3l7MFiPD1cXGbUoNNyT3v1Cwbj5IZEtVEFSoHXC+d3NAskgvmJDiJlOt7
         kKuViUW87q+NiMIL849Bf2AF+SOnGE5A8qJIpneiTNj/3I6z+dsJTC6IHgDbjKZCAIeR
         OgI0CabA6DRf+e+3O6TAlgC0BCp5LQjnD1RuslssaX2BWWYyT4R6Bq0y4OWRvJTai5RU
         7WYz++e5EGaF9E58XLmVNefU65a9AeU6KdFNwi6VntqqsrKfLHVORgp8NJDgaeILK9gG
         3D3CKLdN1zFqfU/m4YQBDyJ6exxG87V72hWYdr+bLdrrLALHPpCZN9gm9H8fpjfOcAQU
         5veA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739578209; x=1740183009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VsiC6df/8ep3kbOMlvv6NHk6oNEYLUzPa8XU1Wwcwfk=;
        b=MtKY0GHC5SBmeIIlW8rpLNIUd4TfeEhve8knP156kJbHw84LUc+nUPp5hUSh7P5EyY
         RrRh/4xaS4KkNBd2gc9RU4tWSgqZtbGYHT25xoIhAxWcAtxDglsaRsMCTxgDYKnubMFW
         aKAC/PPnGL4e/yiRjYqxlQmkXwgUzgXJDaKRErt3iXl0eU5v3bhIsk2TjSahNIsqJQvT
         bTO+FaQsI8uHwzkhR2JqOVNd55sbIATNTB3y4eltPkucxS9irR0YWvEpbvB9b/Jgo4hG
         SA3yC4MHZdNV7FVJEeIbKHdzsIQ+J1q9+pid9j4ggc+n2N2t5mbv5Jv35lSSrZLLRKOk
         FWow==
X-Gm-Message-State: AOJu0YzXXFjA8YJSQu5vo4UQwQDY7iVO48M2GXjI7b2eYl8YsUUIZgVX
	lK758ZF96tayHzJTonFvJme04BYM2ms7AQlFPGm3z1S4nedClaL9ECkcZmxZ2fsbjnntHRAdcc2
	Q
X-Gm-Gg: ASbGncv0SwHsV9wbV107gE3VgKTOU+pXoC9LbyPzg4mdBQqYrx/Cyr+lVBv4L8qMe2B
	9ju9xBFf9usc34ew4TaJsLLCxcqRpTAbYy5OwBgKMHMziDX714ptSWC7P29BR5n/LBsjRbGoIOq
	PNOYMm4os27GePnqj2R1Ty0YR2VdO5z2gfR/EA0bOyt4nvR874d6/N6rZQpMRBVXdrf7QsgoKZw
	Z1TBhB3JxUSPWP5f1rtYyoBsdRMgKUSwLkqOtHk1S+HJifCvoOx36SLZ/B/j86gk/urjAaBhNo=
X-Google-Smtp-Source: AGHT+IHugWOSLZs+TvP13HCCC7S3wQ76eEDjldwt9oMOrHcveDSC9AhwnXDIS5a7f4CumTvw/f2SSg==
X-Received: by 2002:a17:90a:d44c:b0:2ee:bf84:4fe8 with SMTP id 98e67ed59e1d1-2fc41153f71mr1530599a91.30.1739578209221;
        Fri, 14 Feb 2025 16:10:09 -0800 (PST)
Received: from localhost ([2a03:2880:ff:7::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fc13aafebesm3690961a91.4.2025.02.14.16.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 16:10:08 -0800 (PST)
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
	Pedro Tammela <pctammela@mojatatu.com>,
	lizetao <lizetao1@huawei.com>
Subject: [PATCH v14 08/11] io_uring/zcrx: throttle receive requests
Date: Fri, 14 Feb 2025 16:09:43 -0800
Message-ID: <20250215000947.789731-9-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250215000947.789731-1-dw@davidwei.uk>
References: <20250215000947.789731-1-dw@davidwei.uk>
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
index 7d24fc98b306..7e0cba1e0f39 100644
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
@@ -720,6 +723,9 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	int i, copy, end, off;
 	int ret = 0;
 
+	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
+		return -EAGAIN;
+
 	start = skb_headlen(skb);
 	start_off = offset;
 
@@ -810,6 +816,9 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
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


