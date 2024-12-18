Return-Path: <io-uring+bounces-5550-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C9709F5BBD
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:39:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 631B87A256D
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DEFA13C3C2;
	Wed, 18 Dec 2024 00:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="gYj/39d2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9E5137930
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482292; cv=none; b=bcp6Nbf0tqJGRYazjwP1L9e2kYJTEP09+rLEWzVBEeTMP/o4K0xsUi68vPefmfthHpqkvrq+l+p5aImMGy2GEL4FGkCkLn5rpt7C+TRzUNWYetU5Rb05xXqiEz+E+ouOVxFCCkOAmxTzoi56ScEABD32qKSSwZbqsbMfbEqTupY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482292; c=relaxed/simple;
	bh=NRFL2+PeYQBpke3MuIFNDap9yjTLOeiLgLS3XvL+I/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPe3nNCZydHNkvUdwhDkUEmcw5N2f4TUKCQFHjrCNFj8MCQ3sXI6zYxx5kRSTmQ8RR9naE1eyRyHw/VvUtBrWm6slgd0ykdJezsFdvCFDMHmZF8RU/BGDw33unfmG1ASZCvyYfXXrEXtW/RPy1fuVwalBgrSfcGPzZwSwKxaOb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=gYj/39d2; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-728e729562fso5116295b3a.0
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482290; x=1735087090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N2rr3bFZ4xcAeCxIuffGlTrB+I+DvsKrMkXA8KeXORw=;
        b=gYj/39d23fYDT5eAQfjh6vLk3Vf1QtN40DtLx7/rDFVaFJh1GRMsnq5fgcZwHKbndm
         52JvI2b0E3ZJE9iAoADjoR/24WGUJjXywJCW2yT5QcdzZrfTHaxvIC5ghTKkMbiHRben
         1BztSd3Ui9nF5Z9wFi9i7Le2wbv0q+nbzm2b0MA2pwdk+Jj2/g+SwvLUter9JCSWPtlG
         /5li0izdRnn9YJotiaMvnX8solZ9SJ7Adu0Al54IkD6dMcxaYFX1aIga9DX0Yx5wb8EJ
         CYLwGqGvdv0cEVaGAJJTSEzvgcFMpNk9ysXpIxcM/YrX7X2Auq1nS4G+wKwjJgDwvUEs
         mDkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482290; x=1735087090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N2rr3bFZ4xcAeCxIuffGlTrB+I+DvsKrMkXA8KeXORw=;
        b=Hll+IOxYyXP+yHKlw4rcHmhPDDZXsAVuliJyrHu2BHd2imzDERk9bQcPXxjiTIeImL
         4Oz3vRTqI75CFrZp1V3IvNkQeof0cOHlxI77Ute9yoNIpJtm9yWCkm9a74sl4cGwk2pw
         GvGCLzammqQDBfNkNyYEcKY5U6z75jqnyETtgh4Xy4biS9/YKEan2cjWfCGr7n0sk6nZ
         NIuwVIrm5wEeivFMNkMnvNSZspGmPTguphAk11BI3y6aSwxQ7PAIgugkZ2+L13klUtkT
         luYxmYlRCN9hAQGFmbR4e9EYarDerTOdmSwss8hggwkqbnTQ+QspckKeOxWDIa2/rC7n
         6LaQ==
X-Gm-Message-State: AOJu0YzSqvwywmwwA2vxw/PsdgPJbA8LWQh0UhEF0YgcSLTTQpgvo48r
	gwwhW7i0JbQIslk20KXMh+5uVFeGEHQaEu4A21rqEIZcFOvObiwCGTd9x2shg2iUrBjEWtaVGMd
	o
X-Gm-Gg: ASbGncsMC0DmuHRLwP/qZBZwidNYhUhbBIonLO4EjpNfJmSPQpZq8gvSivl335SsvyY
	MwK4yeoHOspHqxFWxa3mThpGN/rYLpclirC8KVIEH0RsvmRHVfMUmbfRZbAhiZVlpX9We4GHJFi
	pVgM9IaGy+ctS1gQeTkv+JkJbcDHgdrzRcWA2BTe4KKGMvr5X6KfPyYf3UHujHzNze3YoYeAPgb
	xAaRjjuZ1uNkAkvRyUSGT/tqpZ1AmlOtdYK3v+pPQ==
X-Google-Smtp-Source: AGHT+IE5LWeBYUo39S/rAUJIC66HtimKMqRa3eFWsBxg5kxpIdN2gzU1mmJgkXRFCD1/tZShgt7iow==
X-Received: by 2002:a05:6a00:1948:b0:728:9d19:d2ea with SMTP id d2e1a72fcca58-72a8d2611e6mr1662236b3a.13.1734482290015;
        Tue, 17 Dec 2024 16:38:10 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1b::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72918af0f01sm7332001b3a.87.2024.12.17.16.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:38:09 -0800 (PST)
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
Subject: [PATCH net-next v9 12/20] io_uring/zcrx: grab a net device
Date: Tue, 17 Dec 2024 16:37:38 -0800
Message-ID: <20241218003748.796939-13-dw@davidwei.uk>
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

Zerocopy receive needs a net device to bind to its rx queue and dma map
buffers. As a preparation to following patches, resolve a net device
from the if_idx parameter with no functional changes otherwise.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 10 ++++++++++
 io_uring/zcrx.h |  3 +++
 2 files changed, 13 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 04883a3ae80c..e6cca6747148 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -3,6 +3,8 @@
 #include <linux/errno.h>
 #include <linux/mm.h>
 #include <linux/io_uring.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -136,6 +138,8 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 	if (ifq->area)
 		io_zcrx_free_area(ifq->area);
 
+	if (ifq->dev)
+		netdev_put(ifq->dev, &ifq->netdev_tracker);
 	io_free_rbuf_ring(ifq);
 	kfree(ifq);
 }
@@ -195,6 +199,12 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	ifq->rq_entries = reg.rq_entries;
 	ifq->if_rxq = reg.if_rxq;
 
+	ret = -ENODEV;
+	ifq->dev = netdev_get_by_index(current->nsproxy->net_ns, reg.if_idx,
+					&ifq->netdev_tracker, GFP_KERNEL);
+	if (!ifq->dev)
+		goto err;
+
 	reg.offsets.rqes = sizeof(struct io_uring);
 	reg.offsets.head = offsetof(struct io_uring, head);
 	reg.offsets.tail = offsetof(struct io_uring, tail);
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 53fd94b65b38..46988a1dbd54 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -4,6 +4,7 @@
 
 #include <linux/io_uring_types.h>
 #include <net/page_pool/types.h>
+#include <net/net_trackers.h>
 
 struct io_zcrx_area {
 	struct net_iov_area	nia;
@@ -27,6 +28,8 @@ struct io_zcrx_ifq {
 	u32				rq_entries;
 
 	u32				if_rxq;
+	struct net_device		*dev;
+	netdevice_tracker		netdev_tracker;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.43.5


