Return-Path: <io-uring+bounces-5938-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19231A1454C
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:19:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 970EE165D20
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D894E2459A8;
	Thu, 16 Jan 2025 23:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="2ABNWw9r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C97F244FB5
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 23:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069444; cv=none; b=BnzID1pUPhUwmiZZpkEn6MgvZOgRrS/nyJTG1ehQ9shmt/yyT8imc10qpdfgsPKsF1SJEq7/lSB4wmPMBIPxILiSjbGFoVUOJBmZkqF+IqZZ0bEU61KidpX5gtO5/n4fR7T3HGWLoSnXN5+kJ89ArUH5zPJ4trHSqGRG+xYQ0pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069444; c=relaxed/simple;
	bh=moxT/9tlqEGGqkvg89jEl7qnqkLxWddMi6wsJk9KyOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbWLDV/WEQUAtMM48HCHOexxhzzKX2wKHgErVU/mFM3cbuPVPPRvmGtQU91eFa0Vddz7KeN5Ce02mNhTibqqQGMgqy1jdLH0e/QosB6FBik+krOSryyU/LKRSEPhJ4JWVbRHO0xoCBcm1ezmVVsW3w23Mq2VbXGzOfhCKGTjlZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=2ABNWw9r; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ee8e8e29f6so2181680a91.0
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 15:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737069443; x=1737674243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6McXPFUQHYSYEvRYSRp9lVm8DJpoafPAg8IZnzA+YUI=;
        b=2ABNWw9rdgCycN+Zslx78MFL7Pm8surhUpDO7v+4pGWVRF+Hvz+s9GUBYQVsACOaJ8
         CKcwXv4/MEse5qNxtzEdGiagQ/1r9XvhIKlM8FNB4+9RYMarpFTyOauGREvNK7vTO93T
         i8mg/WVYz27Wyxqq7o7jsLNEQ5FstSVCD+GqJfbo/HLRTZgAW+zAJaPD0UIah0bteK4K
         qR59JCikTmDS2PVQ0LlgAdvQCkKooTPGHQ5h8ukqEeEPp0TFsUJvDFeCRGmdEihLJKDx
         GcuE3tXxlym7gceFaBbR8V+M8f/x+UBmKCjexPuDM/bxXNJobu3ThC8fjujPnsrNOHaJ
         TlMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737069443; x=1737674243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6McXPFUQHYSYEvRYSRp9lVm8DJpoafPAg8IZnzA+YUI=;
        b=A7NRV+fH+lGDBXFZnk/NTkHnzXDas3Vgj/Id+7H/OYmWJhSgon+34deAJfiBMx2Bbj
         fKvS2ba1twfmlL3fO2J3zhLkK+AwCmMxfMQgmFxN9yy9Bx6Ts+Pr4kMt8Hq7RzDi/gGL
         LskCsDY3WlQ5kcz3jISDzIOENZYtfa8V5R5g7cnRm/mCRwVu3Z3MIMcqCvp9RWqrR7Vi
         MhiSKiUbUQnH/9p5WdjpYDTyPoPZagsVgpeXKcMOo5puJIlREFyHCmQW1txa1SS1LV64
         gBI52xQoV8/XF28qVayr9W4GM1gbtXMwt/5ggeWGZhLwNa+SeLt20EOQ93c1pftg6+CI
         fUxQ==
X-Gm-Message-State: AOJu0YwbGkWZJ6HRwpTzEzLMGXaTmdhTNEts6/Zd6xR7lDKV6rL9jM3g
	E7+rBzN+I1GjHToCXIEgDpmkJwDIO9sKRiLzDY4/hpBgJ6A6fHMkAeYmxb166OV5eGR8ASYFx8u
	R
X-Gm-Gg: ASbGncukn1rSXO9k3HedDrAUjWkngbIPCNjakF4Xt8a9ZH7IxXPxQoJF3f1S9Bm4M3D
	4NvGGePy61tI/7tTFUEhBA/p0CEtLkpYV2EviyV/Mo+AdNmOa9mVcVTxpEvuy88UAPQdL+TnP/M
	UHsQpPJzZrWM0hQlb5R30eREXDXlBMxiL1w/uAps+7ewT6YNnkolzfbgaUVfxwwHS3YtyOuUazl
	pUJIUJJ8Gtg5xdSVPQGpBXEVNS8BDy+3+y9oZeLEw==
X-Google-Smtp-Source: AGHT+IGqq7ZxkRc3/1V0W4uC5/iqUYVT44pqYaPtChWDnrvoE36MzzgrU5K+BZPNWwgUmJqah9EJaw==
X-Received: by 2002:a17:90a:c2c7:b0:2ee:693e:ed7c with SMTP id 98e67ed59e1d1-2f782d9ea43mr631647a91.33.1737069442711;
        Thu, 16 Jan 2025 15:17:22 -0800 (PST)
Received: from localhost ([2a03:2880:ff:54::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f72c2f31d6sm3840917a91.40.2025.01.16.15.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:17:22 -0800 (PST)
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
Subject: [PATCH net-next v11 13/21] io_uring/zcrx: grab a net device
Date: Thu, 16 Jan 2025 15:16:55 -0800
Message-ID: <20250116231704.2402455-14-dw@davidwei.uk>
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

Zerocopy receive needs a net device to bind to its rx queue and dma map
buffers. As a preparation to following patches, resolve a net device
from the if_idx parameter with no functional changes otherwise.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 28 ++++++++++++++++++++++++++++
 io_uring/zcrx.h |  5 +++++
 2 files changed, 33 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 04883a3ae80c..435cd634f91c 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -3,6 +3,8 @@
 #include <linux/errno.h>
 #include <linux/mm.h>
 #include <linux/io_uring.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -128,13 +130,28 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 
 	ifq->if_rxq = -1;
 	ifq->ctx = ctx;
+	spin_lock_init(&ifq->lock);
 	return ifq;
 }
 
+static void io_zcrx_drop_netdev(struct io_zcrx_ifq *ifq)
+{
+	spin_lock(&ifq->lock);
+	if (ifq->netdev) {
+		netdev_put(ifq->netdev, &ifq->netdev_tracker);
+		ifq->netdev = NULL;
+	}
+	spin_unlock(&ifq->lock);
+}
+
 static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 {
+	io_zcrx_drop_netdev(ifq);
+
 	if (ifq->area)
 		io_zcrx_free_area(ifq->area);
+	if (ifq->dev)
+		put_device(ifq->dev);
 
 	io_free_rbuf_ring(ifq);
 	kfree(ifq);
@@ -195,6 +212,17 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	ifq->rq_entries = reg.rq_entries;
 	ifq->if_rxq = reg.if_rxq;
 
+	ret = -ENODEV;
+	ifq->netdev = netdev_get_by_index(current->nsproxy->net_ns, reg.if_idx,
+					  &ifq->netdev_tracker, GFP_KERNEL);
+	if (!ifq->netdev)
+		goto err;
+
+	ifq->dev = ifq->netdev->dev.parent;
+	if (!ifq->dev)
+		return -EOPNOTSUPP;
+	get_device(ifq->dev);
+
 	reg.offsets.rqes = sizeof(struct io_uring);
 	reg.offsets.head = offsetof(struct io_uring, head);
 	reg.offsets.tail = offsetof(struct io_uring, tail);
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 53fd94b65b38..595bca0001d2 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -4,6 +4,7 @@
 
 #include <linux/io_uring_types.h>
 #include <net/page_pool/types.h>
+#include <net/net_trackers.h>
 
 struct io_zcrx_area {
 	struct net_iov_area	nia;
@@ -27,6 +28,10 @@ struct io_zcrx_ifq {
 	u32				rq_entries;
 
 	u32				if_rxq;
+	struct device			*dev;
+	struct net_device		*netdev;
+	netdevice_tracker		netdev_tracker;
+	spinlock_t			lock;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.43.5


