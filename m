Return-Path: <io-uring+bounces-8830-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07FC1B13996
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:06:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 174313BDC01
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9BCF25C6F3;
	Mon, 28 Jul 2025 11:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WXleyUVS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D197246BA5;
	Mon, 28 Jul 2025 11:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700623; cv=none; b=mZzu/yUPE7LHfRPnsCwcnCFc/KiuE/cC1Y9qIn1fs1o2FT+4elUSw8mIQ5Zs6j/cmKHhzmP2m8KuQTKnBtTQH25dDkcvZcd3ZfrO5IIDLMdfJc8YlMxkZYzDX7Yfa9DeLWqnOBTsnStv/lX4v17CUgogFh54cRb+PSvuQif+ljI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700623; c=relaxed/simple;
	bh=go2uhXh3NAEJPr0eluCoNxgLOMEZjVqmm9+Ys2+zD5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dR3V9Hf8OZqD+EfiWqk/DNE7CucHoBlDivimVhrIiiSAUzRu4R7zMjejhOvMWy+1LQr0T7qAngW6I26v4XZqJOXGpSgSd6r3nKAL0hraAe7WtEcBNz9oZgIGuSyYQVhpaWD1RqhjEE/N8CGmVx/oHIPwTUhqtphxIzwaCyDAJrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WXleyUVS; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4561a4a8bf2so48252285e9.1;
        Mon, 28 Jul 2025 04:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700620; x=1754305420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m9KEU6U2/qu7I98PwBqSyjf7JwXgRq3jopn+u9xf2AM=;
        b=WXleyUVStsCci5z+k9f6lejY2Xi+L6XcRUyOVeXVAWiXvcxmvdNi947bkJYROWz08/
         +03pu4Omn+WRB0ZANsTYIl8AxLIcFVMlEMK2gl/e46Hd9+OilmXZbclBhsQEXVWXBBM5
         armV6ea+lSIxyiWIhA8QedJ3KuMc+OgggtjD5EtBiKDWvaGxF9eX1h0yJWF8IhgcGzzW
         AngrSifJHtxea4IqXauOJmH/6lHdQJOo+hcP6HDMCVqIeoJg0Lb25elMwXJdNZxFCtP2
         ezL+SsbmdX4l50x6mahaectlFvteHUQ5nasieKQJIf26INPfX4qIcqKw5455q1D0P+NG
         FfuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700620; x=1754305420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m9KEU6U2/qu7I98PwBqSyjf7JwXgRq3jopn+u9xf2AM=;
        b=kc1ywP0yqFhjZZe5AZTWtED5XQCJDTnBCEY2DbfbdCSNGQ5y0nuAFVZkqzQ9Jci4Ae
         m1yCKn9F6a/yUUI6IAshuYGzueAH8o2uMunEqnjvbnjW8+9ABi/nMBodBosYVNxF+n00
         9IsTTZDXj4o0ZJmaLu8SPJkxBo99fckwsjFLMITMZ5YYZdimBVwuCFbgJWD6BjqXdNoy
         2PgbXh4t6q/yUpPWsKCbSZNKL+FZ9ZFAmCwvFxFHH/a2K/F2SpKCoolVRqe7mJ4wan/2
         hD/UNOhXGHxPrE6HWiEudPVKvkax3qiVEePEF/EYP5hlaGtUuDGWBH1otPpkf6li1x3C
         dVIA==
X-Forwarded-Encrypted: i=1; AJvYcCUR77XkkUXnam6/+j4Occv/82QFrJk7ZmFswiNJE60gco6B72KE1M6CorGs6YySOPA61/el4RJw@vger.kernel.org, AJvYcCUmuMtgFM/yaZDFhAQHU4VUQl1d2lUw1zogPbUuRMTk+WoONlvLTeeHRBWltcRZ+nWYeA31yYMIVg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxjnHsIjm8b1z83mfh0qNd3KGgIFYvItvTJ6l7l8e6QvaYWbitJ
	2LBzoue8JqG1xJ9D5s3Z6QndQXLzLdAu4Xji7/zdfWRS3EwYH1LNyafY
X-Gm-Gg: ASbGncuK4gugWlHOj06dSU77eIiq3wCnIbnk70omDcni873j6dOF0RVX7boLHk9PPWF
	3uHbHE6kZgANIi5NUaEv7RSFw2HqMw1vVMKoW4RSbdM0IJh5YDo4/W/hwL/7JAEgpPjLnKWm/uo
	601yoZv2hLvIgFaGlV4WtTOXsk8z+TdOaLSKkbmNxPPGNGvj/wryTgPV2A/TssiDg4GSZzY09b7
	Q27g7uJ2L8HThompMt3S2+6Hsw8Nahcm2MMjr2JuauBwR8ZQxSwJAQnSD9TGXtcSz79M5kxogVd
	7MSwShOW+c1gmwSto5Wg9L68K6zEPnxa4x12ySp5TyQTeqdzeYKZ9+v5FYAIdCMoiYxKleaCwMr
	ysmE=
X-Google-Smtp-Source: AGHT+IG4ub6F7umSCtD2qsz00KNF8peW0F311GOEAAA2M8xFYYRSN6eicqomTN/skMRdLiUgdqbIKA==
X-Received: by 2002:a05:600c:1d90:b0:455:f59e:fd79 with SMTP id 5b1f17b1804b1-4587630f8d2mr81176175e9.11.1753700620139;
        Mon, 28 Jul 2025 04:03:40 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:39 -0700 (PDT)
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
Subject: [RFC v1 19/22] eth: bnxt: use queue op config validate
Date: Mon, 28 Jul 2025 12:04:23 +0100
Message-ID: <376a52149021bb57bee0cc668582756654022b02.1753694914.git.asml.silence@gmail.com>
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

Move the rx-buf-len config validation to the queue ops.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 40 +++++++++++++++++++
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 12 ------
 2 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 017f08ca8d1d..5788518fe407 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -16139,8 +16139,46 @@ static int bnxt_queue_stop(struct net_device *dev, void *qmem, int idx)
 	return 0;
 }
 
+static int
+bnxt_queue_cfg_validate(struct net_device *dev, int idx,
+			struct netdev_queue_config *qcfg,
+			struct netlink_ext_ack *extack)
+{
+	struct bnxt *bp = netdev_priv(dev);
+
+	/* Older chips need MSS calc so rx_buf_len is not supported,
+	 * but we don't set queue ops for them so we should never get here.
+	 */
+	if (qcfg->rx_buf_len != bp->rx_page_size &&
+	    !(bp->flags & BNXT_FLAG_CHIP_P5_PLUS)) {
+		NL_SET_ERR_MSG_MOD(extack, "changing rx-buf-len not supported");
+		return -EINVAL;
+	}
+
+	if (!is_power_of_2(qcfg->rx_buf_len)) {
+		NL_SET_ERR_MSG_MOD(extack, "rx-buf-len is not power of 2");
+		return -ERANGE;
+	}
+	if (qcfg->rx_buf_len < BNXT_RX_PAGE_SIZE ||
+	    qcfg->rx_buf_len > BNXT_MAX_RX_PAGE_SIZE) {
+		NL_SET_ERR_MSG_MOD(extack, "rx-buf-len out of range");
+		return -ERANGE;
+	}
+	return 0;
+}
+
+static void
+bnxt_queue_cfg_defaults(struct net_device *dev, int idx,
+			struct netdev_queue_config *qcfg)
+{
+	qcfg->rx_buf_len	= BNXT_RX_PAGE_SIZE;
+}
+
 static const struct netdev_queue_mgmt_ops bnxt_queue_mgmt_ops = {
 	.ndo_queue_mem_size	= sizeof(struct bnxt_rx_ring_info),
+
+	.ndo_queue_cfg_defaults	= bnxt_queue_cfg_defaults,
+	.ndo_queue_cfg_validate = bnxt_queue_cfg_validate,
 	.ndo_queue_mem_alloc	= bnxt_queue_mem_alloc,
 	.ndo_queue_mem_free	= bnxt_queue_mem_free,
 	.ndo_queue_start	= bnxt_queue_start,
@@ -16148,6 +16186,8 @@ static const struct netdev_queue_mgmt_ops bnxt_queue_mgmt_ops = {
 };
 
 static const struct netdev_queue_mgmt_ops bnxt_queue_mgmt_ops_unsupp = {
+	.ndo_queue_cfg_defaults	= bnxt_queue_cfg_defaults,
+	.ndo_queue_cfg_validate = bnxt_queue_cfg_validate,
 };
 
 static void bnxt_remove_one(struct pci_dev *pdev)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 0e225414d463..38178051e0d3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -867,18 +867,6 @@ static int bnxt_set_ringparam(struct net_device *dev,
 	if (!kernel_ering->rx_buf_len)	/* Zero means restore default */
 		kernel_ering->rx_buf_len = BNXT_RX_PAGE_SIZE;
 
-	if (kernel_ering->rx_buf_len != bp->rx_page_size &&
-	    !(bp->flags & BNXT_FLAG_CHIP_P5_PLUS)) {
-		NL_SET_ERR_MSG_MOD(extack, "changing rx-buf-len not supported");
-		return -EINVAL;
-	}
-	if (!is_power_of_2(kernel_ering->rx_buf_len) ||
-	    kernel_ering->rx_buf_len < BNXT_RX_PAGE_SIZE ||
-	    kernel_ering->rx_buf_len > BNXT_MAX_RX_PAGE_SIZE) {
-		NL_SET_ERR_MSG_MOD(extack, "rx-buf-len out of range, or not power of 2");
-		return -ERANGE;
-	}
-
 	if (netif_running(dev))
 		bnxt_close_nic(bp, false, false);
 
-- 
2.49.0


