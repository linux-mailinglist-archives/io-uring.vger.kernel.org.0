Return-Path: <io-uring+bounces-6462-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6CACA36998
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 01:14:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3E9916E9A6
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 00:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA95157A46;
	Sat, 15 Feb 2025 00:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="fYI9mQWG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C71413CA9C
	for <io-uring@vger.kernel.org>; Sat, 15 Feb 2025 00:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739578211; cv=none; b=alUTmpvEMOliCbzOY/FYZiOZEghqAsUcHdz38XAwDuEJyiN/RIrYCT9CaN6Gp8Fch3PQhT9D85Q6cbE6bog8Qm/ykfAYzTZPGaWi7p4mxuAOWWT7rKb0p2JCrA9n0ptBLm+/0AzF9w0bLgKjrxyT3DgaeYPmwENerEo2nXhCkiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739578211; c=relaxed/simple;
	bh=yv828TZcRCYjgOUYA40GgMIAhXfiazwYmHkQmnj1NWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yfo7Yr82O72Qa4sn9K0G99m2Dn0oYXrU+GHg9wvmdBPTJNf8s0K3sRAFwd+a310x0QkX9wm95PGIzmG1R18b1Fg4BKlvfXFQpqz05PeA2ODTqQ62yoc2V1cAvTcOf8yjQW0z2QBBK0czki+5fdMR0lk2WGACwhsiNztIZxxDrc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=fYI9mQWG; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-220e83d65e5so35592215ad.1
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 16:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739578208; x=1740183008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cUvMDJY3LulrovKGYmLf0HXuAW/efdEv7GgYFLavCrU=;
        b=fYI9mQWGJiHSWJmS13WxAtZAm+uWMW6Bt3Dk53fj7nCmPzbRffb6XMe0NO0wxPjLNd
         sKT5HEVGskZLFcR6IwZ6BiA7kURyi5FFiH1h85rnHOO1u9EAj7pkurm1FZTTCN15HS7v
         qrnAlwbNV5KeWLj9JUbk6FLmsdLXqk3Wdt7rFU+kAlddRBuynSs9xjhe4npm+uq3+Jlo
         xqfvaKYH05ZbIKCgxqRQ2JXgknU4SBCCSzQhE68Y3FjyXq282K6Pi5C+BhOdrt8HnzA8
         FuxL7O11wALHkmcYoH5d1eAjIquUQ1yhEcaAk8ZtGeyo/PL8TmtTbIbjdKoi049a7mMf
         kt9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739578208; x=1740183008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cUvMDJY3LulrovKGYmLf0HXuAW/efdEv7GgYFLavCrU=;
        b=eQKR5teDveeM2rRL4t0kGKxPSB/9+B8ID2OthhMkcXn6h8dS5uHys3a06gVSl3Rxvg
         KQErBc5oJQAufeFeZxF/ABBv19/W8zk1IbxQIfHnhJw2XAJ0bjdjFtfUydCTlogX8ieE
         ckxrk9loKPlnHZB35P7nriGDW1Ln+TT+qk/CHwczklB1T/RthmcxJ62RInAOhrKSQ+Lt
         ux8BA6AhDQxcg2yxJ8E3Jlj1Q59YPmLva7im3EkI2tjR0niangSq3LFUSbuMqvT8dTyj
         bdWLg2g01rDcei4sCyDP1uzOZYaL/D8K1emwEblT6lajWkQEqqKvnZtHskTdl/PN5TIA
         Lpog==
X-Gm-Message-State: AOJu0YwwkYlzuAnp2eYqamdJTYpxQ2MZxg4zFChwDz529bP39rO6mTzt
	0tR1Tk/N5hBLpQoFo6g55fu8sdCQkZGX/WRwD2+Iwmvut0jfz+F7SI+fmozPl43+S8AgHhBto30
	0
X-Gm-Gg: ASbGncsZIkPhloLNZeJLcGVJVzwobh4SWZtzJRPrV1f5ucIMbvrVMWULb5nZs0Y8ohu
	v750SpxTfEH9RY7Qvef6ELs3yQ6/hzVtaQMXHdbmAvpYqoaaPrqtGorWep1fSiNRqQuULPvXz6B
	F8SsYtDnQ0OG/Min/3Bk0vF283ac3UMSvbpoIYpnmhw9+PS5Z75VxgxourGIjKj/wZeGm2iUgCi
	5a4eALuJypsXxyjNNyE9tdLCtMxXLF1siRemYgnpZMDcOQQiOwA95a2dk7/Fshl+AJMjWWiE5w=
X-Google-Smtp-Source: AGHT+IFCyZhH/nkjfrONygHuHLVOUuRCt5s+VsXaryqRUIqav3y3If8MKHA+uOTyAwE5xWM7Sc7Wgw==
X-Received: by 2002:a17:902:e80e:b0:220:e362:9b1a with SMTP id d9443c01a7336-221040623acmr18942415ad.25.1739578207917;
        Fri, 14 Feb 2025 16:10:07 -0800 (PST)
Received: from localhost ([2a03:2880:ff:c::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d545d07dsm33772755ad.138.2025.02.14.16.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 16:10:07 -0800 (PST)
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
Subject: [PATCH v14 07/11] io_uring/zcrx: set pp memory provider for an rx queue
Date: Fri, 14 Feb 2025 16:09:42 -0800
Message-ID: <20250215000947.789731-8-dw@davidwei.uk>
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

Set the page pool memory provider for the rx queue configured for zero
copy to io_uring. Then the rx queue is reset using
netdev_rx_queue_restart() and netdev core + page pool will take care of
filling the rx queue from the io_uring zero copy memory provider.

For now, there is only one ifq so its destruction happens implicitly
during io_uring cleanup.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 49 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 8 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 8833879d94ba..7d24fc98b306 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -11,11 +11,12 @@
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/memory_provider.h>
 #include <net/netlink.h>
-
-#include <trace/events/page_pool.h>
+#include <net/netdev_rx_queue.h>
 #include <net/tcp.h>
 #include <net/rps.h>
 
+#include <trace/events/page_pool.h>
+
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
@@ -275,8 +276,34 @@ static void io_zcrx_drop_netdev(struct io_zcrx_ifq *ifq)
 	spin_unlock(&ifq->lock);
 }
 
+static void io_close_queue(struct io_zcrx_ifq *ifq)
+{
+	struct net_device *netdev;
+	netdevice_tracker netdev_tracker;
+	struct pp_memory_provider_params p = {
+		.mp_ops = &io_uring_pp_zc_ops,
+		.mp_priv = ifq,
+	};
+
+	if (ifq->if_rxq == -1)
+		return;
+
+	spin_lock(&ifq->lock);
+	netdev = ifq->netdev;
+	netdev_tracker = ifq->netdev_tracker;
+	ifq->netdev = NULL;
+	spin_unlock(&ifq->lock);
+
+	if (netdev) {
+		net_mp_close_rxq(netdev, ifq->if_rxq, &p);
+		netdev_put(netdev, &netdev_tracker);
+	}
+	ifq->if_rxq = -1;
+}
+
 static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 {
+	io_close_queue(ifq);
 	io_zcrx_drop_netdev(ifq);
 
 	if (ifq->area)
@@ -291,6 +318,7 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zcrx_ifq_reg __user *arg)
 {
+	struct pp_memory_provider_params mp_param = {};
 	struct io_uring_zcrx_area_reg area;
 	struct io_uring_zcrx_ifq_reg reg;
 	struct io_uring_region_desc rd;
@@ -341,7 +369,6 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		goto err;
 
 	ifq->rq_entries = reg.rq_entries;
-	ifq->if_rxq = reg.if_rxq;
 
 	ret = -ENODEV;
 	ifq->netdev = netdev_get_by_index(current->nsproxy->net_ns, reg.if_idx,
@@ -358,16 +385,20 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (ret)
 		goto err;
 
+	mp_param.mp_ops = &io_uring_pp_zc_ops;
+	mp_param.mp_priv = ifq;
+	ret = net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param);
+	if (ret)
+		goto err;
+	ifq->if_rxq = reg.if_rxq;
+
 	reg.offsets.rqes = sizeof(struct io_uring);
 	reg.offsets.head = offsetof(struct io_uring, head);
 	reg.offsets.tail = offsetof(struct io_uring, tail);
 
 	if (copy_to_user(arg, &reg, sizeof(reg)) ||
-	    copy_to_user(u64_to_user_ptr(reg.region_ptr), &rd, sizeof(rd))) {
-		ret = -EFAULT;
-		goto err;
-	}
-	if (copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
+	    copy_to_user(u64_to_user_ptr(reg.region_ptr), &rd, sizeof(rd)) ||
+	    copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
 		ret = -EFAULT;
 		goto err;
 	}
@@ -444,6 +475,8 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 
 	if (ctx->ifq)
 		io_zcrx_scrub(ctx->ifq);
+
+	io_close_queue(ctx->ifq);
 }
 
 static inline u32 io_zcrx_rqring_entries(struct io_zcrx_ifq *ifq)
-- 
2.43.5


