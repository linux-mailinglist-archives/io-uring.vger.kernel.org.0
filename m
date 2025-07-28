Return-Path: <io-uring+bounces-8833-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D4E1B1399F
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B921A17D6FA
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB6D5264638;
	Mon, 28 Jul 2025 11:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dmszjQfw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FA5265CC8;
	Mon, 28 Jul 2025 11:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700628; cv=none; b=jdvA8VF6ex4MVp3jS4Jr1A4yoX6iUt9RGz/VZ/gDQmOetvdpaFzesYU6jdG8flIp9sjhm7EI3ld/o3+F7bnaqmm4kL6AedGc38TFml8BG9tWJke472tRIQx43Z9IB97hH9nd3uKCBkNLg8eyRhfpyoUMlzYyGT3M31EbToQlpu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700628; c=relaxed/simple;
	bh=t3AiHcnf9UbGvXBnY7A6WX7EUYHNVlEjDxCmrXiD+0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mv0nU1O3jKTozqUtZkUiJHXrilCxNYhIkoxejFkBOYrpR+mvE8Xon+ObqWx7lT7vaL2175FC3ZZy2h6TIxBqwRRHb3fY5YbIDdWAFGynbYLywqhphkp6CSZCi89u5iP2kihl0KfzrGe4VwDQWInV7/6FdEYuDYp82ZXd2AfDmNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dmszjQfw; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4561a4a8bf2so48253235e9.1;
        Mon, 28 Jul 2025 04:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700625; x=1754305425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xCfTsWWTa7wdeH4U61LV0QVujn0Rr5yA6peexPuxYv4=;
        b=dmszjQfwlLGScX6Rrlqm82H8UxS1LxwgNHl2Z/2+fHAAKlJyxk/aS+wOjRbwnnpGzG
         AvHAmawQBBbnDyYpZuXbygZbqJNYjCaSPNZCqjYTAQ3ow1c6Qi1qIgNTjtpjExt0e+Yi
         bdUBSsiMRk3nJ2PVDvGn3EuWbbl4vVW7Ncbgt5svFQaA17HVxwcxsSz//yg4rhz1XnC4
         PAAHbPJmCDBFQArDxy+dALwhMkCc0XyK+NdCOojq4HdaFpItvUy893qRLGsGC7dNjAOV
         VJdFf1sBp+5Z/W8yD3ohDB6cD34kTGVw0GKnQ+UI16I/SaFO1cft4A+jiFut0pufcfBs
         lp5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700625; x=1754305425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xCfTsWWTa7wdeH4U61LV0QVujn0Rr5yA6peexPuxYv4=;
        b=ljod6wDiRPJ7GWsl5cj0Kc0egvTS1+Kky6+c2BtipuBhhCb5o8Ac4XwVUf/q9mk6n1
         X1sPkYN3CCdLG4ENbH+oD+Sn229XVq6T/Yah+AT14VvyDKxfa0d3vqaIA9gXdCMPpsSW
         IwkpspZAWbz8wq2cs6nd9UtxWpnAof3QB+cWwxquekggTzJPspZZYJMbX3hfVRksxWqM
         7EdW03Mu9vfBJEmX14M7KD+JCMiyjbHJVo/AHlqg8IbrWc6J1va6sS6PUOm4LKizo0T8
         QMIhv13Yu5g30D7hjvyBW45chRhbNXUPXI3lqcpjh07gxhuIM/YB3krTXdUa/kEYar3d
         H78A==
X-Forwarded-Encrypted: i=1; AJvYcCUIccihMY+OFiy+0TPRfq7rsryTN6k9YB9BuBeCEw9M0wHYpqMcUHpOIJEJ/olAmXjFPS4BvNuo4g==@vger.kernel.org, AJvYcCVEkf58tTYnz5xbAdo7Rp7btd3Z/IMEzhqZmEjydcKGL9qYN+gBawVZALWGRSKu+mMmfVTIYYDc@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/lQKmAFWOUdDSX4ZYaOj/p/rJXTKGq7FcOWdjHu3xV+4e9Ysr
	VooXP9idNFAeCXUTkEiZBJqjeai7EA1T/XeRzKjjpmBt1wsV5fj5G/dy
X-Gm-Gg: ASbGncu9AppHee+SVWiXZLZ6rXRzjqMwM3OIfWftQoKFlwpGmiLWcryd6knQoCCUGVa
	ptZmKujYW8a0h/HL6Fuh8oxZHtrG+smAIIcc4xEC8qE174r7CaP/u16uFFdEkV3Y7MOA2lG/VIi
	GG13SC258q1JURQ83xuEZbZWXKhOMCryFFTLmHNsUxxIOrR3r5lh8zuTOjKAxPgsdLmypbFV6ph
	yNvnhM44Ojo1zAoeWtDHa2R1BjoFYdl88cEj8MFfYy3Xi5TiAG9744cv/UVHAES2SrRLgPGKOgz
	Bm+rFI0ChwzvbfFzE+jJBq063Bm6rS1uJn4Z7TENNGVME2MMgXaLFuJ74UDoMxWvgOFUn/6qw6l
	H7oI=
X-Google-Smtp-Source: AGHT+IGgyPMOcv8M+bhV3mrP0uIyvmsPwxWYZJ1xn2f8mb0xDTXip8JQuZBdFu0kFSIz0TzLD7WX5Q==
X-Received: by 2002:a05:600c:a012:b0:456:11cc:360d with SMTP id 5b1f17b1804b1-4587630f640mr104788175e9.9.1753700624962;
        Mon, 28 Jul 2025 04:03:44 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:44 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	davem@davemloft.net,
	sdf@fomichev.me,
	almasrymina@google.com,
	dw@davidwei.uk,
	michael.chan@broadcom.com,
	dtatulea@nvidia.com,
	ap420073@gmail.com
Subject: [RFC v1 22/22] io_uring/zcrx: implement large rx buffer support
Date: Mon, 28 Jul 2025 12:04:26 +0100
Message-ID: <f6d352a8eb9f0297196fdaf0eccc6d9e2a44a357.1753694914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1753694913.git.asml.silence@gmail.com>
References: <cover.1753694913.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are network cards that support receive buffers larger than 4K, and
that can be vastly beneficial for performance, and benchmarks for this
patch showed up to 30% CPU util improvement for 32K vs 4K buffers.

Allows zcrx users to specify the size in struct
io_uring_zcrx_ifq_reg::rx_buf_len. If set to zero, zcrx will use a
default value. zcrx will check and fail if the memory backing the area
can't be split into physically contiguous chunks of the required size.
It's more restrictive as it only needs dma addresses to be contig, but
that's beyond this series.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  2 +-
 io_uring/zcrx.c               | 39 +++++++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 9d306eb5251c..8e3a342a4ad8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1041,7 +1041,7 @@ struct io_uring_zcrx_ifq_reg {
 
 	struct io_uring_zcrx_offsets offsets;
 	__u32	zcrx_id;
-	__u32	__resv2;
+	__u32	rx_buf_len;
 	__u64	__resv[3];
 };
 
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a00243e10164..3caa3f472af1 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -13,6 +13,7 @@
 #include <net/page_pool/memory_provider.h>
 #include <net/netlink.h>
 #include <net/netdev_rx_queue.h>
+#include <net/netdev_queues.h>
 #include <net/tcp.h>
 #include <net/rps.h>
 
@@ -53,6 +54,18 @@ static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 	return area->mem.pages[net_iov_idx(niov) << niov_pages_shift];
 }
 
+static int io_area_max_shift(struct io_zcrx_mem *mem)
+{
+	struct sg_table *sgt = mem->sgt;
+	struct scatterlist *sg;
+	unsigned order = -1U;
+	unsigned i;
+
+	for_each_sgtable_dma_sg(sgt, sg, i)
+		order = min(order, __ffs(sg->length));
+	return order;
+}
+
 static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
 				struct io_zcrx_area *area)
 {
@@ -384,8 +397,10 @@ static int io_zcrx_append_area(struct io_zcrx_ifq *ifq,
 }
 
 static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
-			       struct io_uring_zcrx_area_reg *area_reg)
+			       struct io_uring_zcrx_area_reg *area_reg,
+			       struct io_uring_zcrx_ifq_reg *reg)
 {
+	int buf_size_shift = PAGE_SHIFT;
 	struct io_zcrx_area *area;
 	unsigned nr_iovs;
 	int i, ret;
@@ -400,7 +415,16 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	if (ret)
 		goto err;
 
-	ifq->niov_shift = PAGE_SHIFT;
+	if (reg->rx_buf_len) {
+		if (!is_power_of_2(reg->rx_buf_len) ||
+		     reg->rx_buf_len < PAGE_SIZE)
+			return -EINVAL;
+		buf_size_shift = ilog2(reg->rx_buf_len);
+	}
+	if (buf_size_shift > io_area_max_shift(&area->mem))
+		return -EINVAL;
+
+	ifq->niov_shift = buf_size_shift;
 	nr_iovs = area->mem.size >> ifq->niov_shift;
 	area->nia.num_niovs = nr_iovs;
 
@@ -522,6 +546,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zcrx_ifq_reg __user *arg)
 {
 	struct pp_memory_provider_params mp_param = {};
+	struct netdev_queue_config qcfg = {};
 	struct io_uring_zcrx_area_reg area;
 	struct io_uring_zcrx_ifq_reg reg;
 	struct io_uring_region_desc rd;
@@ -544,8 +569,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		return -EFAULT;
 	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
 		return -EFAULT;
-	if (!mem_is_zero(&reg.__resv, sizeof(reg.__resv)) ||
-	    reg.__resv2 || reg.zcrx_id)
+	if (!mem_is_zero(&reg.__resv, sizeof(reg.__resv)) || reg.zcrx_id)
 		return -EINVAL;
 	if (reg.if_rxq == -1 || !reg.rq_entries || reg.flags)
 		return -EINVAL;
@@ -589,13 +613,14 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	}
 	get_device(ifq->dev);
 
-	ret = io_zcrx_create_area(ifq, &area);
+	ret = io_zcrx_create_area(ifq, &area, &reg);
 	if (ret)
 		goto err;
 
 	mp_param.mp_ops = &io_uring_pp_zc_ops;
 	mp_param.mp_priv = ifq;
-	ret = net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param, NULL);
+	qcfg.rx_buf_len = 1U << ifq->niov_shift;
+	ret = net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param, &qcfg);
 	if (ret)
 		goto err;
 	ifq->if_rxq = reg.if_rxq;
@@ -612,6 +637,8 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			goto err;
 	}
 
+	reg.rx_buf_len = 1U << ifq->niov_shift;
+
 	if (copy_to_user(arg, &reg, sizeof(reg)) ||
 	    copy_to_user(u64_to_user_ptr(reg.region_ptr), &rd, sizeof(rd)) ||
 	    copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
-- 
2.49.0


