Return-Path: <io-uring+bounces-9035-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E972B2A905
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:14:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46E921B64A15
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 14:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E699345732;
	Mon, 18 Aug 2025 13:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hyk+YxBg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AB4340D9A;
	Mon, 18 Aug 2025 13:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525432; cv=none; b=CSnj9D5G+G8BcWU9R6CBLXsSafV3Pwlap2hLFla2nesaZbVKpZTEMV4s/7jozfMg3Sqf00Gbh8zs0CEjgsBFMgF4HI/Uz2WI7Nqv6l3ZKj04FNo6sIE8i6q5VBzzo86MyYP2Ub0nh88TPhMix6MZy1Xmnj/t18GZXvPjsx5yBgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525432; c=relaxed/simple;
	bh=RReO56BatJj7rMlajRFlgYtUF9/vCtVpo9sSe60qrVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONORBG/4DNIAuHYKlLpbqV1Di/tzt6oeUdQVU+r0vc4XlRTQxZBM639bPEMJCtk1opejEmmxvY6vnIZvF+DtMcLJEIW+iRVnfeZlK39rkOGVrroOgBPWRmzlsXRs07L5ZnS4zDRv1bbwupAOmcxg/f1LZT+1OSXOhVjAFXKVo/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hyk+YxBg; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45a286135c8so7919905e9.0;
        Mon, 18 Aug 2025 06:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525428; x=1756130228; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z25S50YCNKWhUSA7z3uNSqaKR5tWMv56D/QyK+4pnsk=;
        b=hyk+YxBgicVi+HqJ7Kaj8xshqSl6lkY8VY24uuyTzfzYbj8ZsTSndY2Oo13BoYxNxC
         YSfEI95OnA1x3y7acDK//qLQITePc19WFDQ2KqLzE1/pvWvmH/UmrI6WanELtjmYqu7v
         yxMolsxaKhZJof/NOE4B7aGcFYLWG7DMsSn6SK3v3h5Sb0riuDFC51fmoa0Lf3rN0QOm
         YTGC/dJDfgMLpI6I5lw+NyJmqBuwmFfKo6hv1lFJM24Zoq74T+BHoe+ncEAxKHWsQe9H
         sWUoGbdBsaHNJkyBTyiPW2/zNsahvS0gFrc+NqENy9F7fYuEpmECrDG3hKp/GF9DwiQ6
         +HhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525428; x=1756130228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z25S50YCNKWhUSA7z3uNSqaKR5tWMv56D/QyK+4pnsk=;
        b=xHkn3ZHJAdsbg8gCr14tcWDWg+tlYCnI69WjBw/PRTFHhlTt9fyRfdmobLhmDb04S+
         6OcO3pcjjZCVU+P7CS6IOhL04FIMxAzsSmteSWNlu9u+dHRLGfeNP4hmdXY7TLmfuwb5
         1r42emS9KI8NgPQ2asPMRvmAVjTK9e14LZvM5itB7GRCJ7Wwq2mPL8tux7JDLzM8vEvq
         7GILsDtvVNAMgFyZVnX9pZ+vpGntL4pk4p0orPzxX43SWHkpVZyg1vHOPya35hWTZNHl
         1ik/mlsZO8kSS4OfKpRnTs4UhM8GyQNND4Z71uNTDUnEr2J+pgxf+LrMQGbs6WSUHY61
         i5ow==
X-Forwarded-Encrypted: i=1; AJvYcCULsSc5eXqzYjUJVIU/wT0gFb1NcqbYEFr5Q1vRMH8UklcocJI6t9GKoIKCc4A1z+KVWyVlY9PjCpzDraiN@vger.kernel.org, AJvYcCWOdlW4rpwOMVvrmu+6ym5RnIgmDFd335fk0Kl92aLKP5r5CRrTFkJhKblO9X/QkwgtQAnZK5lE@vger.kernel.org, AJvYcCXhpoD6Uo5vWX9hUZLDM/TiP5/A/B57/FNUkuy4lgZbO8aqSWjTpIFIGOQQDp+W5qUxp56cVMps9g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx/ITXL/3LpJ+oLxWvwphSgrZhb/OYm4ibH8hVesttLI3jFXhV
	wDWETqoB5REWREFsNax7rv3oEEX2/mzJZF3gzwPhBQ7NBIKg2m0hvrQS
X-Gm-Gg: ASbGncvSUUgUyaAwlh9aWvWJ2YyKyY9Hw3R8+LGOjv+stFp7X/NDCrlzQgiwgeLgmuH
	ihzKNwieZ4r8ByLE5CIeS8AYkTG/kCVtmTGBaiLk6O9thavf8dGJ/GdFERMMnnO8PkCnfdnFOx1
	3apkVtNuoCCts8dgkCsyN5jIYozAT4k3dDymihiUjotU2082srtdAl7CF4I1A3Cr1kn73aFApve
	oDGZqE3g9Bp2GCuG8K5AhL9FSjmJBmmYu5jtaz//fhClvNBPVlhUVWBdGSACfyZEAQDBzpDOT1P
	MtY/Q6x9mxVCnCR5NxvWvQQuJMt0hE1FssRTHahYnfk+kSfgzarXgXY5vNdAFjFD3zJ/e0i0vMI
	SnZetWlnnB9pBhn8MItOzAKDLWQzQcE4nww==
X-Google-Smtp-Source: AGHT+IG7pX8UX1OSGUSdBOtglakEOCMLFNhwxEIKiHPZz3/EGTvhoNq5cxEvUolV5KjbDogZrOJmiw==
X-Received: by 2002:a05:600c:4687:b0:458:bade:72c5 with SMTP id 5b1f17b1804b1-45a21809208mr88670935e9.8.1755525428352;
        Mon, 18 Aug 2025 06:57:08 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:57:07 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
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
	ap420073@gmail.com,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v3 20/23] eth: bnxt: use queue op config validate
Date: Mon, 18 Aug 2025 14:57:36 +0100
Message-ID: <e86603d2404d52727ee9397f635817eeff0b8a1f.1755499376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755499375.git.asml.silence@gmail.com>
References: <cover.1755499375.git.asml.silence@gmail.com>
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
index b47b95631a33..b02205f1f010 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -16147,8 +16147,46 @@ static int bnxt_queue_stop(struct net_device *dev, void *qmem, int idx)
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
@@ -16156,6 +16194,8 @@ static const struct netdev_queue_mgmt_ops bnxt_queue_mgmt_ops = {
 };
 
 static const struct netdev_queue_mgmt_ops bnxt_queue_mgmt_ops_unsupp = {
+	.ndo_queue_cfg_defaults	= bnxt_queue_cfg_defaults,
+	.ndo_queue_cfg_validate = bnxt_queue_cfg_validate,
 };
 
 static void bnxt_remove_one(struct pci_dev *pdev)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 2e130eeeabe5..65b8eabdcd24 100644
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


