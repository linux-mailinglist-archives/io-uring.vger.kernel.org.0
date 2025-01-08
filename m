Return-Path: <io-uring+bounces-5772-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7DA8A067EB
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:09:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E94053A7033
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 22:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420CF205ACE;
	Wed,  8 Jan 2025 22:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="cDqoXsIW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEDD205AA8
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 22:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736374049; cv=none; b=cC1JZwRMOcr8r0xEeZGwbYIhm9bTShXqyV1CrjcosXj4bMNxyO/yFVkxWfRc2oZFAGWmUeaXZ9EfCdM+J/06LEipgBtjgFdgkO6TQ6QeyHEoXEYlh9aYu/n3dmNZj5Pni2SEwESos/HMmImAJCQcGFrMvx+qg9z/Qxtz8cB99DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736374049; c=relaxed/simple;
	bh=ucD427e85qUTwFRQjJcGMV6IGNLXsiIhlBVrZEzf/2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kdrxb9JORmlwWeIda8vkp4dqMScHGLuN7RxcEpvjRqd/dXF0GQuDRO6KcG8NNXhVV6LzlGDC48e6JID2PJbXAueD480M/DzlIKswKUJP3IS56Ff4J2F2VzRS4GGLkDAYaP2mZbWGK+pEPA2Uuxfd0rTCVKTE2RBB+Dc52mVgCGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=cDqoXsIW; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2164b1f05caso3366435ad.3
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 14:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736374047; x=1736978847; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rM5oqwlPCboF3L0KLpjyjzpa6cyTqgw+zU9Oh18/VIs=;
        b=cDqoXsIWm3Vqb/BcuZ0fScFAWKxGw0Lg7eohspM6pfIHtIJEU4EGBkWl3gYWwGfohO
         nFJM2Z+PEb1k/2JDWLJA0xs34DfPeUj5r9Ftm2eAuhgbyV/MNweKKwaXgzOL9junUzNm
         96iwELXcjVmzXPsYlurYFE3PitPUeZBSWfxZKYFCXWwrla5a84dWpreZvuTTg3L10lVp
         LV4C4THDTRbOOqEoN3dVH+TEH/fBysxmn839cgfn1hle0iHeWkmZDOSxmw711AizbRXM
         bkgIffREBiZrsYbzrSx8dDL8kBXSK/5hkb0ckVru81MGuKPheQCGRFFOzqZwDI2DOHZn
         tlsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736374047; x=1736978847;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rM5oqwlPCboF3L0KLpjyjzpa6cyTqgw+zU9Oh18/VIs=;
        b=UKxD2+9ksqAuQuRQFBywlZ+41+W1n71DJxZVuS5ACbSmdaHbqJcpY/aW2NSg1rYpIK
         KMXKyFiOMAJTxNimF5ttjMVD+5QaARTThb2+v5BqStEIuixOLl+TH3jtNp+HQ1DLkCFE
         6tK9i+qRPsb+ToxijkI6n100LwJMFbtchCYf6yxN2uvieRP4V3XY4FHmRtw5xpLBk/eA
         CPJayhR0F+v9ksaoB/rH35twub1pTR7Jw0VXT1t1Udr2bAdONMqxFdxMxFd3qZdiSMVb
         isFL+mSCYvENKodPGuxwaAIkNtE340xHpMHcn8U1kEbylHF0WeKat0X4S/s/OoIOak1i
         uePg==
X-Gm-Message-State: AOJu0Yx+WHcA83UpjdAPl0nj8Usy6PDpgP1hbVPkFyDvKerhm0QBHb28
	3A4v08UEg23b3EygqClH/2OPe41wBOz3ZJbUFoycp4/UVBLztXPt73acU2gb8zJNzdf2eCnNGG5
	u
X-Gm-Gg: ASbGnctQsVnEd8cw2EDTG144Q6kCWfgrZvbOXa+W3hrk+fZrVjp3HGG+Nk4moCagSs5
	WDY9MFitFsQ6bAH9ccwg6RO1Dp4jKV54lIKOH3wtcNfJYNJ4uwKbfM74YDDOZePapSPKonXwStR
	Vvr/hEq+jTFTRjWqe0vdM1PXJZOID2ki49FDXrMwdtCuxbtG7mdJeKFodZHkv9WezUnkX5I4LDR
	m9baKJy46zxdd8kRiqB4o9MbBvFqQgQZedU/S24
X-Google-Smtp-Source: AGHT+IHocG7GscyfUwB2sW3F7E+mdclDRN/mLUnuLEbf4sEtVLy56qsB+YrqQ8es+luw47eXQJJIoA==
X-Received: by 2002:a17:902:f706:b0:216:69ca:773b with SMTP id d9443c01a7336-21a83f4b2bfmr65633395ad.5.1736374047223;
        Wed, 08 Jan 2025 14:07:27 -0800 (PST)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dca02aa7sm335703425ad.268.2025.01.08.14.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 14:07:26 -0800 (PST)
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
Subject: [PATCH net-next v10 19/22] io_uring/zcrx: throttle receive requests
Date: Wed,  8 Jan 2025 14:06:40 -0800
Message-ID: <20250108220644.3528845-20-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250108220644.3528845-1-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
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
index caaec528cc3c..0c737ab9058d 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -103,10 +103,13 @@ static void io_zcrx_sync_for_device(const struct page_pool *pool,
 
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
@@ -734,6 +737,9 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	int i, copy, end, off;
 	int ret = 0;
 
+	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
+		return -EAGAIN;
+
 	start = skb_headlen(skb);
 	start_off = offset;
 
@@ -824,6 +830,9 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
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


