Return-Path: <io-uring+bounces-7470-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94475A8AB94
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 00:50:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64F5F7A538F
	for <lists+io-uring@lfdr.de>; Tue, 15 Apr 2025 22:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25BF82D3221;
	Tue, 15 Apr 2025 22:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3kXIV5mn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679512D1F4B
	for <io-uring@vger.kernel.org>; Tue, 15 Apr 2025 22:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744757293; cv=none; b=rygdmYzBDaG643hiXb9vM0JFqRb9tshyOgHhHoP1FLRxoCye6yDypCNa/dJ7FCu765K5/+MC3iWYAYNDMzxKupPZB/1zgjDMArBxteIkc+mx2pvmQ9Ml6boFtv3k3LTv37qnPD+1GJiUHWlFQO+T7Ky6hz2NhBg2zzvrp0j28t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744757293; c=relaxed/simple;
	bh=Cqzn0jIx+ICXy20erkdmco/hDp3aOf21xpNbmkO7QhI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jJRGWl6foMExEYtRZ1qqIcBmqLl/lWIM1s4XzYg7x3LX6y37HYzBShNpWo99aT838411beSErFlFPutDvbKfzb2PWhIKlmuEtcs3dJJxAYtiK99NqQ9laShTPDKY5gfAeNQ59DrigA0ggr/8O9ldwXNyfmyeJE8OjIMYTIhTfcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3kXIV5mn; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-73917303082so3992064b3a.3
        for <io-uring@vger.kernel.org>; Tue, 15 Apr 2025 15:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744757289; x=1745362089; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5Y0gt4KGR4y8gxIG8GX1gRAmwKzn/ocefSDNpr0C4Oc=;
        b=3kXIV5mnKO5VpqEaBODRszdZqoMY0FbDDCZCWlhmyJjxgvYgxfbo6uHL4/LUMWAxuD
         wEjQ5v+BSKJmp2r85VBN4BP0g1g6/xNNiZ+wrB3GFPxEXCfEc9qjvoaAcdbcPAoEWcyW
         LjsG0+2FVOybX8rmEuFEJ60Id5BYtKaNA4dG8u9+DvOwGouRe7En31p2sfnysW8bVUEx
         nTNcPSgB4u4JmOoGCihAW8cv8stL1PxexuhBNSbYHBOIoJ1oaNTyi9gS2xudQ9F3cZUU
         ZHkP+7TzpZBjHZy1P/WlGkT0m6PDzIHT4z2k4HCE2pM2Tsl3o8XsS7lxKA/XI/AQhBpp
         ZA8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744757289; x=1745362089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Y0gt4KGR4y8gxIG8GX1gRAmwKzn/ocefSDNpr0C4Oc=;
        b=RU/4MHwvdE70CJqv+w93j6HUubvKHMwydz/oJaVXKyDkg8QKQW71pjDM6uCF2dbWYx
         BAoKwAveCNpaN8vg3jb3GxdQ7Lx3jIJhkriYmnbaax1+LKdXU0lK6LozalovAL+Jr2aK
         +TSIH0msU+wSvkB98sOnSIcAwR8D1hJWsLjU3wUG8mM3aVpBAl4N1VvtZEL5M+9qLbsr
         s/MYUj/q5qkFNPkmlgRA48USNbX4H+1bs8bzWjGWe+NRG9LauowwKr+9SCqKzLpjL+NV
         YDacem4BifniiWD2g4uy4XSIuN1zn4HIw86D1+1xNEfP7yHAnEV2x1LBb+2rWBQZ335C
         Ef2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXf+C2eyS1hUZkNPNo6AbtsSo2rUUvN4HgXArvpR/tDoPJ4ZPOlzhemj0RreHrdy/8Nab1AO8d0vA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0BjF47K7FmlpM4G2Fct7POcUhtx+koFJFY0t1JrnxwdsERUip
	pGjRPNW3NIg7Qb5jyXbRiYQxaVqT+GfDS+y6iu6J1Fkfz2E2i7bd7JrLdLRNgsJ4NhRx7Nq+qVH
	lKSCB3V2aq9IQVXSrk5n3ug==
X-Google-Smtp-Source: AGHT+IG5NdGfYD5N9W8W7UHWdGCQl03DIg/olddW2S6Vpl+mwIRiJnb8xyrZV4MMvX8nbx7uCAGqaaZxX+2uVhCWMg==
X-Received: from pfbi30.prod.google.com ([2002:a05:6a00:af1e:b0:736:4313:e6bc])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:21c4:b0:730:9946:5973 with SMTP id d2e1a72fcca58-73c1f8c6c69mr1778523b3a.5.1744757288544;
 Tue, 15 Apr 2025 15:48:08 -0700 (PDT)
Date: Tue, 15 Apr 2025 22:47:54 +0000
In-Reply-To: <20250415224756.152002-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250415224756.152002-1-almasrymina@google.com>
X-Mailer: git-send-email 2.49.0.777.g153de2bbd5-goog
Message-ID: <20250415224756.152002-7-almasrymina@google.com>
Subject: [PATCH net-next v8 7/9] gve: add netmem TX support to GVE DQO-RDA mode
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kselftest@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Use netmem_dma_*() helpers in gve_tx_dqo.c DQO-RDA paths to
enable netmem TX support in that mode.

Declare support for netmem TX in GVE DQO-RDA mode.

Signed-off-by: Mina Almasry <almasrymina@google.com>

---

v4:
- New patch
---
 drivers/net/ethernet/google/gve/gve_main.c   | 4 ++++
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 8 +++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 8aaac9101377..430314225d4d 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -2665,6 +2665,10 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	dev_info(&pdev->dev, "GVE version %s\n", gve_version_str);
 	dev_info(&pdev->dev, "GVE queue format %d\n", (int)priv->queue_format);
+
+	if (!gve_is_gqi(priv) && !gve_is_qpl(priv))
+		dev->netmem_tx = true;
+
 	gve_clear_probe_in_progress(priv);
 	queue_work(priv->gve_wq, &priv->service_task);
 	return 0;
diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index 2eba868d8037..a27f1574a733 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -660,7 +660,8 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 			goto err;
 
 		dma_unmap_len_set(pkt, len[pkt->num_bufs], len);
-		dma_unmap_addr_set(pkt, dma[pkt->num_bufs], addr);
+		netmem_dma_unmap_addr_set(skb_frag_netmem(frag), pkt,
+					  dma[pkt->num_bufs], addr);
 		++pkt->num_bufs;
 
 		gve_tx_fill_pkt_desc_dqo(tx, desc_idx, skb, len, addr,
@@ -1038,8 +1039,9 @@ static void gve_unmap_packet(struct device *dev,
 	dma_unmap_single(dev, dma_unmap_addr(pkt, dma[0]),
 			 dma_unmap_len(pkt, len[0]), DMA_TO_DEVICE);
 	for (i = 1; i < pkt->num_bufs; i++) {
-		dma_unmap_page(dev, dma_unmap_addr(pkt, dma[i]),
-			       dma_unmap_len(pkt, len[i]), DMA_TO_DEVICE);
+		netmem_dma_unmap_page_attrs(dev, dma_unmap_addr(pkt, dma[i]),
+					    dma_unmap_len(pkt, len[i]),
+					    DMA_TO_DEVICE, 0);
 	}
 	pkt->num_bufs = 0;
 }
-- 
2.49.0.777.g153de2bbd5-goog


