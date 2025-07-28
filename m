Return-Path: <io-uring+bounces-8828-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5126B13995
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:06:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE6ED1679BF
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4112625BF1B;
	Mon, 28 Jul 2025 11:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TVUbHNJw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B60B264634;
	Mon, 28 Jul 2025 11:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700622; cv=none; b=tPVfYnJHt5wFajTuMYOaagoL2Op0vDYUpnLmVzVcxVIu76uwiKh6xd7Nwr+GXSJGA7+I7UVfC2mrhV4BfNtCcEflOE1DhLIyunRUbOFZ8wgt/mYw3ciR2iD0RWsMcMV9w/7ku6AY+xrPbfraTVXUCe6fXfJyHtVcp2fkn5T/Hdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700622; c=relaxed/simple;
	bh=Kazo359TedRr5WG5TZJXywgHN+i4PeBWRhr3xxErffc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sig69zfanRVliV3ryLmtyxpb+b6rxCKDkmXN3Pj0OwLRINVqC7Ty/89ZUi4i6NjFTKaQ0hC7/tliN8NO6zITgi26AYct6rRZBYPP1Qiq3m6lVmM3pNMCrkjFxSZz9MwjmYyHuafJGOdS9V8S+t6+aBcfMJ4hPuEk4Z4N50VSDxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TVUbHNJw; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45629703011so29805005e9.0;
        Mon, 28 Jul 2025 04:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700619; x=1754305419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zwY2mzHwihlK+raHIl11LrN1Z4nwGPJ0gt9rWAafa6I=;
        b=TVUbHNJwXpDWStbHryBkPdDS6B3E22YvH6Z+a4ROeNhxoWYDF/diedvU2zXUUzm2Rl
         2wN9Sl811eyaN9AfRI092+yeHPe4I3lcoULyX3t2UBlWCGeudW3ZmrWKHzaDhgkQvOZO
         pI53fzccw7FHW+RhpX8+4TyN1HELiwGHs99x2DKPbjQ2BSTB8/YA6Qm8xO3iNk+k08Oi
         N4oLPpx6aPRQzrdJsTOA2tkwMsVnJK87orOU6AIvxGKQtP0G/qmYn+mbvj2hQLMmyVOF
         HzdTLxiGyDXpactQrPaomAlNNhPd0kwPqRPtNxe6eYvrjy9D9NJQyq3u2pBfZFzZ9ScQ
         fs1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700619; x=1754305419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zwY2mzHwihlK+raHIl11LrN1Z4nwGPJ0gt9rWAafa6I=;
        b=hN0DTIJnT1u7rO26b6a9omWQrdhbm7e65ZZ8atFIL0/vwZ4D7eYaqIR9Qyb93oehKI
         +MkUSHoztKq1jmbLNHOAvGhRPrXNB6Lb5/3J58Hcj2qQZRCFTPjPMn1LHgn6rQKmgf86
         uTM5eSjChkzaOOl+QdlXJoHdjy89j2/JwK1yjpy3vRLq9UYo1lojSpxrT8OSs/bY//Z7
         ZbDi+cj7ZLCwkEb8asp/oKBP/UlL017ilpRDWca+t81p79H8NqkfeIP4VEbog5+d46DC
         ZRSkhPYNEsC83+Y8WOkKAFCGrA5Re3x7CfehNz11r12be+CYFD0DcxXXhJDPfApdGjVL
         cG+g==
X-Forwarded-Encrypted: i=1; AJvYcCVk19s9kkpnBItkQgyq8GavR7RK/EtIdDZl9/mN1oa9z/LrHc3rFWOOuoeXawkBEoINM0h21Z2n@vger.kernel.org, AJvYcCXWmyo7KEoaYq217sC8dMwNVl0YBDk5ZVUvYLC7fwXVCptoNJGJSii5KyL8YDLbz1xa400QHVVGuA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxQOsambtQyQQspiyFNNuZnXXR5opc26+d0IvvR7wmMG4GFFEwW
	4o4yICLZhn+iRgtgcxL2MSCCaEMJIDlEycKBrWxXpNPC5CnRt/59lrMC
X-Gm-Gg: ASbGncuJOmWvqzhA4k+Qw4Cy/mX7n3ZuHL33GASGfcnLdvSf3yd0A53EuvyTwaT0BMK
	4EQCSV6RiNPTxa4WTjFz4v9SSRfneeMkK5DRDhDQc6Mckjm31McerWAYHsbgnvH7C93Y0aYgty1
	gkQXfUVbOrO6QIt7mDrRu8A/uELGzhgoQmMiJGUW31KxoZ5QSIDSZwdPwDwjwH2ferl1BwsA4VS
	VXwGlTjAPzUKyRFfQu7SHeD6yQNBfFCJ+13TPQh0YmzmuZwJ2WoIQGq400UqZUsUh7gQ0WSHoz5
	HQuAEPaUbNfasO509ORvkp2RNkYQsPK2iNZWncFSVONT+PwClaYbrMO2NmXJgW6ZRXBBvZuJIRr
	eg4g=
X-Google-Smtp-Source: AGHT+IGxWEq5aSn5gpXyUQe13xUKL0fSwaP+FE72eqUUQlE+7Wb8qY0oE7jG2/6wC2l9zfoiH66WgA==
X-Received: by 2002:a05:600c:699a:b0:442:f4a3:b5f2 with SMTP id 5b1f17b1804b1-45876304b8dmr83534105e9.6.1753700618655;
        Mon, 28 Jul 2025 04:03:38 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:37 -0700 (PDT)
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
Subject: [RFC v1 18/22] net: wipe the setting of deactived queues
Date: Mon, 28 Jul 2025 12:04:22 +0100
Message-ID: <e4626dc1eaf64506bf5661cfe3ffc875cdb9bcdc.1753694914.git.asml.silence@gmail.com>
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

From: Jakub Kicinski <kuba@kernel.org>

Clear out all settings of deactived queues when user changes
the number of channels. We already perform similar cleanup
for shapers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/dev.c           |  5 +++++
 net/core/dev.h           |  2 ++
 net/core/netdev_config.c | 13 +++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 757fa06d7392..2446e7136bd8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3190,6 +3190,8 @@ int netif_set_real_num_tx_queues(struct net_device *dev, unsigned int txq)
 		if (dev->num_tc)
 			netif_setup_tc(dev, txq);
 
+		netdev_queue_config_update_cnt(dev, txq,
+					       dev->real_num_rx_queues);
 		net_shaper_set_real_num_tx_queues(dev, txq);
 
 		dev_qdisc_change_real_num_tx(dev, txq);
@@ -3236,6 +3238,9 @@ int netif_set_real_num_rx_queues(struct net_device *dev, unsigned int rxq)
 						  rxq);
 		if (rc)
 			return rc;
+
+		netdev_queue_config_update_cnt(dev, dev->real_num_tx_queues,
+					       rxq);
 	}
 
 	dev->real_num_rx_queues = rxq;
diff --git a/net/core/dev.h b/net/core/dev.h
index e0d433fb6325..4cdd8ac7df4f 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -101,6 +101,8 @@ void __netdev_queue_config(struct net_device *dev, int rxq,
 			   struct netdev_queue_config *qcfg, bool pending);
 int netdev_queue_config_revalidate(struct net_device *dev,
 				   struct netlink_ext_ack *extack);
+void netdev_queue_config_update_cnt(struct net_device *dev, unsigned int txq,
+				    unsigned int rxq);
 
 /* netdev management, shared between various uAPI entry points */
 struct netdev_name_node {
diff --git a/net/core/netdev_config.c b/net/core/netdev_config.c
index ede02b77470e..c5ae39e76f40 100644
--- a/net/core/netdev_config.c
+++ b/net/core/netdev_config.c
@@ -64,6 +64,19 @@ int netdev_reconfig_start(struct net_device *dev)
 	return -ENOMEM;
 }
 
+void netdev_queue_config_update_cnt(struct net_device *dev, unsigned int txq,
+				    unsigned int rxq)
+{
+	size_t len;
+
+	if (rxq < dev->real_num_rx_queues) {
+		len = (dev->real_num_rx_queues - rxq) * sizeof(*dev->cfg->qcfg);
+
+		memset(&dev->cfg->qcfg[rxq], 0, len);
+		memset(&dev->cfg_pending->qcfg[rxq], 0, len);
+	}
+}
+
 void __netdev_queue_config(struct net_device *dev, int rxq,
 			   struct netdev_queue_config *qcfg, bool pending)
 {
-- 
2.49.0


