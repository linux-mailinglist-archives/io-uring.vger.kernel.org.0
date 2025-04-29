Return-Path: <io-uring+bounces-7778-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDA32AA0075
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 05:29:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B98AE48188C
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 03:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B66277004;
	Tue, 29 Apr 2025 03:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kIk9jEOS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2473A27511D
	for <io-uring@vger.kernel.org>; Tue, 29 Apr 2025 03:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745897223; cv=none; b=EGvAoKmZ0w5yeI/MDB4hq5s1EgPeXKuvR+YOK+ceCCli9ylqIrB0+23KBv/Ou2ZEPwG9c4/mm/fJY5L+guRtSODYdl5qsCZsy9ywtDfZoRhYfekyJrLR6QQZmYDgqV7S4VvMT1gSYLwuUKlU/NC5mgFV41GqA92uYSPRxQhhM+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745897223; c=relaxed/simple;
	bh=Z68cpH5fxZGeLfS2U33TAcTiBeuN2mj7/zWyxfXYDl4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gt8Q2EHOwrBFcjHEjyOkG4VE/MT9ZYr43fsURAnaxFSaz3RpOa1HMFo7vMhCkv6ZhB+szP2PPWj3EIDiWE2MEky4dW6dyBGpIcBtHx6V5dZNqQv+JUXevtzTAFlc7YS1i8ESWr5vCRGnrOWnMIay4LKIRPpcp7Gs3Jj7D1kNnZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kIk9jEOS; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-309f0d465bdso7351585a91.3
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 20:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745897220; x=1746502020; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l8LoBj5QkNQ61HAUzl5WW8jyz94OzO6sbAtFCnjrTQU=;
        b=kIk9jEOSEnqT7pbJ/aDrCT/sEEAvd7uUwBAc+lHDgSV4jbrvnlEmZpGumc8i9fFSAc
         /DE29NA2f7O+LkTyzeO7CReOEkVei/5wpq1va7QBmx+BZikhYkHti8ctyP03UW+iAocL
         8LOkb4QvX2IeSBjD0MEi2jfJo5Jek83zAMgStsHAHqoprB8xLn1oSH5Hkp/UgaYENu3r
         09XJV/xTn0DZO3IS0EXvvwc3kd/JXmKnEo6tTBdf4m5jNOqmN+IUt0+X2a4KP4gDWTFx
         KeVCQqCjWI/k0tKFBcsIcLcggheirtDxdn3NTR2GXHkMKVtfAiXEUjhPzzXc5v9EcM1M
         dexw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745897220; x=1746502020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l8LoBj5QkNQ61HAUzl5WW8jyz94OzO6sbAtFCnjrTQU=;
        b=aJ8SRHpVBXxu0oo5dR5I852coIPi70Z7WI5onfdrkHEjEVbafMd6SSbm9ZaRX7QaYy
         JewDsHrxMrT+daA/dh/S7q4iIXHMNy9bJ6BXaGPYKT4aiVoyMdrIavfRAbwR2I9VKH1H
         Fd1/pODUhbPoDPdTcLAWQktS/15s1H+rFtkZxCH9b69pYek3aJ2XGpQXLybmOF67pPnV
         TjK5uAkSHf0dMbMd+vV4Ix8LC/VzF2gKp1rdUqR87eXbhGdyyg75yAHv4ImFbCGqQqbh
         uRTi0xPGf/8GX4m/+A3SIEQ2zTOGg7PYJQ0nMVxGcw4uLjkJ9roD4b/lbl543U3Ls6E3
         n0OA==
X-Forwarded-Encrypted: i=1; AJvYcCXDVAiCHHL/llhz5yjqCHXlhc3LjVM2Au1iuwF5l8SJTsFbxDEq+OqIpCRVjMK2kHcIcPrG70Ulow==@vger.kernel.org
X-Gm-Message-State: AOJu0YxutEDUYJsU6jYYOsPLE8qTxl1/JMf6n/myEn7sQ/qoExp95ftu
	bjQxekDZ9r+jvTyONwzfgniBzUGcnJcA6ZGyXi7+UzS00kbNBW7VKXIq/W91Z5ubtgzcHjWAIlm
	siCzNwXfNiU8cibVkPLFCXw==
X-Google-Smtp-Source: AGHT+IH1lqsX8YSUWmxKt4wH8YxPdTvxLmFAq8QU54Wh5cs1YGokpWg+zAzqbk5N7Wr1gfY0alNdXpMcYe8P+4i2Rw==
X-Received: from pjbsk17.prod.google.com ([2002:a17:90b:2dd1:b0:2ff:4ba2:f3a5])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1c09:b0:2ff:64c3:3bd4 with SMTP id 98e67ed59e1d1-30a2159bd80mr2907614a91.31.1745897220307;
 Mon, 28 Apr 2025 20:27:00 -0700 (PDT)
Date: Tue, 29 Apr 2025 03:26:43 +0000
In-Reply-To: <20250429032645.363766-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250429032645.363766-1-almasrymina@google.com>
X-Mailer: git-send-email 2.49.0.901.g37484f566f-goog
Message-ID: <20250429032645.363766-8-almasrymina@google.com>
Subject: [PATCH net-next v13 7/9] gve: add netmem TX support to GVE DQO-RDA mode
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"

Use netmem_dma_*() helpers in gve_tx_dqo.c DQO-RDA paths to
enable netmem TX support in that mode.

Declare support for netmem TX in GVE DQO-RDA mode.

Signed-off-by: Mina Almasry <almasrymina@google.com>
Acked-by: Harshitha Ramamurthy <hramamurthy@google.com>

---

v11:
- Fix whitespace (Harshitha)

v10:
- Move setting dev->netmem_tx to right after priv is initialized
  (Harshitha)

v4:
- New patch
---
 drivers/net/ethernet/google/gve/gve_main.c   | 3 +++
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 8 +++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 446e4b6fd3f17..e1ffbd561fac6 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -2659,6 +2659,9 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto abort_with_wq;
 
+	if (!gve_is_gqi(priv) && !gve_is_qpl(priv))
+		dev->netmem_tx = true;
+
 	err = register_netdev(dev);
 	if (err)
 		goto abort_with_gve_init;
diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index 2eba868d80370..a27f1574a7337 100644
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
2.49.0.901.g37484f566f-goog


