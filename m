Return-Path: <io-uring+bounces-903-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC1B9879DB6
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 22:46:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED8781C20FEE
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 21:46:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E36414402C;
	Tue, 12 Mar 2024 21:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Pwv0Gfy7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D940914374A
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 21:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279877; cv=none; b=Ypa6nyZLUU1/+rl90W4fh6Nj1kMHFVIKvNGQ9NFJJaYY1aQQTA4DtJHZIlRKq4Z6gbR8ozJr0NlEHK5WqEEOfFXYDcT77eKCrfZsIIe/lvr37D3vK1b0y574HKlE2uJQdbj8l0I57UzAWURcMzp/AmlVlxBOyi8PAMtI3PwlSfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279877; c=relaxed/simple;
	bh=5LIz+n21IO/BI82JjqRprXHon+WApM+Js27POLGqQWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOt+UoIGPzlbJqlzkprI1tt8oG+PweFiCwMSFj5vkKXHooeltkf5DKZrUcn2TemdP2+04VgVrwJaoP+0zOaYYqPJW13nFq99iglniyiPy4zuwXb9Dui7fKkdX6PuIJU5S7MKajGB0hTw9QGi8SQjt5U1oDU6YCFIOeKX5Yg/vHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Pwv0Gfy7; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e649a2548cso4226522b3a.3
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 14:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1710279875; x=1710884675; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ki4E7PMtuF4SSoJCESY70J5JzUkN3PrG7EZAs5PtLHg=;
        b=Pwv0Gfy7BNKH8v92w1sXPteJAvi/mSXFv/Id3cgoo9jYzp3kDNMgrmxH383koBD2Jh
         3r7LYUZXfrAfe0qzZXewMdwnaZX6XU4K/XosLjCYJ4vsJQHYyMYyJw6f5ApP0GaFpOMn
         7pqA/DRHAmqYPMXUACUh2o1AsGe+bshtL21jquYGxTCTmEFSLNQhD5o9RFd6znB+QK6S
         EbgNlb2i/tDEAytbupO1pKZU0POvVmw65OQSiddT1M/5XoZNCcZbFjTY+q6Zx+zdpOLZ
         pzSbuqIoy7VDkRyS1Xq1d5uplwzcUZOJK1oi0IIJnpg1SU22hkShOzGpF27O5kH0G8rx
         9DnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710279875; x=1710884675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ki4E7PMtuF4SSoJCESY70J5JzUkN3PrG7EZAs5PtLHg=;
        b=MrvkSSdzGrhD423yuQl2GhjERT2/LFZyvU1ufOkPPPV9bbhiq7KwC7a6n8YaRWUmQM
         X+9NScRwQiNUz+o7Iy4XPkKdT8Rw8W8obaf0lU7TWgPCcckXsykeYEYTAWCYg/JufBzY
         +o+buRwnz5REsQHrMvmn7K6oG5n0G+ACJan7sy0OUU+rLHbfGEm7j+UD5EohrQAjWAuB
         bwMGqd9Jlv5Nus8gOrRb01NahgAOIBvadh8eaWlVBByvhAn4gk2mWuI+q9ucJsBomC8a
         Bjm2ahphySgpwn30dvNDDJXWGotFLNvY2CSRJvvZSLUuKqHqTjn/X8918M5SU30wLwVs
         3RrQ==
X-Gm-Message-State: AOJu0YwQjdRZzbvZbZRPJ26TE0nhcPjONRwK4RX664bxI3FS5pA7hGqw
	Lb03MmIB6wMgezWw4tl7HvU3PinTpU+Wr7Cerip6wrj+0sn5K4ns60NjG+3yNJUncwCa9J/T5Ul
	k
X-Google-Smtp-Source: AGHT+IEytnLFhFfxcOEd6KuDVTAKRKneRq76aXN3P/JDiA9CUmXL59+Us4Nkh7nNStj0CDihdR7Ksw==
X-Received: by 2002:a05:6a00:c95:b0:6e5:696d:9eb8 with SMTP id a21-20020a056a000c9500b006e5696d9eb8mr916681pfv.3.1710279874793;
        Tue, 12 Mar 2024 14:44:34 -0700 (PDT)
Received: from localhost (fwdproxy-prn-024.fbsv.net. [2a03:2880:ff:18::face:b00c])
        by smtp.gmail.com with ESMTPSA id t64-20020a628143000000b006e6aee6807dsm985326pfd.22.2024.03.12.14.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 14:44:34 -0700 (PDT)
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
	Mina Almasry <almasrymina@google.com>
Subject: [RFC PATCH v4 01/16] net: generalise pp provider params passing
Date: Tue, 12 Mar 2024 14:44:15 -0700
Message-ID: <20240312214430.2923019-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240312214430.2923019-1-dw@davidwei.uk>
References: <20240312214430.2923019-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

RFC only, not for upstream

Add a way to pass custom page pool parameters, but the final version
should converge with devmem.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/netdev_rx_queue.h | 3 +++
 net/core/dev.c                | 2 +-
 net/core/page_pool.c          | 3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/net/netdev_rx_queue.h b/include/net/netdev_rx_queue.h
index 5dc35628633a..41f8c4e049bb 100644
--- a/include/net/netdev_rx_queue.h
+++ b/include/net/netdev_rx_queue.h
@@ -26,6 +26,9 @@ struct netdev_rx_queue {
 	 */
 	struct napi_struct		*napi;
 	struct netdev_dmabuf_binding *binding;
+
+	const struct memory_provider_ops	*pp_ops;
+	void					*pp_private;
 } ____cacheline_aligned_in_smp;
 
 /*
diff --git a/net/core/dev.c b/net/core/dev.c
index 255a38cf59b1..2096ff57685a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2189,7 +2189,7 @@ int netdev_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 
 	rxq = __netif_get_rx_queue(dev, rxq_idx);
 
-	if (rxq->binding)
+	if (rxq->binding || rxq->pp_ops)
 		return -EEXIST;
 
 	err = xa_alloc(&binding->bound_rxq_list, &xa_idx, rxq, xa_limit_32b,
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 53039d2f8514..5d5b78878473 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -262,6 +262,9 @@ static int page_pool_init(struct page_pool *pool,
 	if (binding) {
 		pool->mp_ops = &dmabuf_devmem_ops;
 		pool->mp_priv = binding;
+	} else if (pool->p.queue && pool->p.queue->pp_ops) {
+		pool->mp_ops = pool->p.queue->pp_ops;
+		pool->mp_priv = pool->p.queue->pp_private;
 	}
 
 	if (pool->mp_ops) {
-- 
2.43.0


