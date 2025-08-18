Return-Path: <io-uring+bounces-9024-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F06E1B2A8B5
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:08:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64D885A33D7
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 13:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB8B322DCE;
	Mon, 18 Aug 2025 13:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d4mP13FE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFA1322A3F;
	Mon, 18 Aug 2025 13:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525410; cv=none; b=NEGyxej1eU+BLutLD94ghT8b/+pvwUYnxy76l5/INYCRO14MVvk62QH6jDshkhikZjNuJMXBeqVagOfKJmzreBK6wyLjaAO1ZKkMMAWtJx2zd1at/YVQ/MdgZbhEJQDKlOjHLpplh/MVHVjE4kwFmZMAiD2I4tMS0+w4cta+abs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525410; c=relaxed/simple;
	bh=02ll7Hf0om4fnk8EYgvdpXG5XbOBZ69wid9PsjkjrbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCd1YedP/zkpeYV0mEx45/AT79V7vojVgJ0oc1NfvVQWKwjpjkKQwLL1bVT2bSMRTzeeJE4x8yueLPy3DflmCWfMPoKpLGpkXwfWNaheAG86B6rzxC4I/vJqImjJBx5IJA/Qh9lxZDkFr1rjl+JyxGWtsQ1d1vmplGzTOpal2gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d4mP13FE; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45a20c51c40so20513005e9.3;
        Mon, 18 Aug 2025 06:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525407; x=1756130207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9p9LD1mijTOfq8tIKHOFs1U4bUaxs+wWUrmPNl8XewU=;
        b=d4mP13FExk2pcBi6IF3e5dt9XhViQqne8NIl67O4qVL3tA15f+RknT78LX42eh/feD
         gybHkN60wMfuDgCObvB8SZ29VSJCQQfiikWmhoanqwvg6q0RHq7SkHJGMs2ezqLpuZ7+
         x78a8l+yfL5BqSr3+7am93ue3C++ubnoBm+penPU1LUlSxl4C//XGvctS6a0POxbk5cq
         rQwFjGVK06eMlR58EQCuGcRL/xeawBqHBMN2Vr8QdLseI5bS2hLTSCeGI/XjwSLCqDtM
         +0JjfYGZ2wN/OhNJobdDcUa5IrEwLm+TMLYZNIKHoL2mmSOGd1ZaOhYHqszLaz9JItUg
         Ihag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525407; x=1756130207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9p9LD1mijTOfq8tIKHOFs1U4bUaxs+wWUrmPNl8XewU=;
        b=SiquvcH2pbscKiid/+9Fh/UTp50x1UoqT/EiWtd4ylKwtomnC4ba2Rult4QGMM2d7J
         7uQVN6LU9rCSTb1kv6ZdrXtwPEAYv5dz4zUNM5Cd8dPZQvhPXjQPAxB4WaotgiiaIp/1
         SamprGZ16po4d3VywOfCWbPVCMjc0y8ank1DAvVonjE4vo+q1EFH4T8LZDJAgy50Qrxn
         6mzLAIk9ec4L3NggI9z72kIJW+/qWUYBe4JNzClvqFg2XwblpxX4PT8NZdEGuLl7FBzb
         H4qsw25Wwu/sKxgsW2dIX++d3Rv4nHzN9/t/3o67LcHUgXRZOtVTjz86LhjEHCOKNtVs
         xYiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMCrGI+9iyU52FKzhpNDf5B5GY3Z94HFgQkpdhFEGYNAEY9PRt2GICw9yf/+YDLKPbe0HEqpzJ@vger.kernel.org, AJvYcCUsJWjLbRP2IXzCiZi6SaJSW7MpYTiYYKF45Ol4LkrHhMPW+Nhf+duCbyPM2Us+mzkZd9n5JiLDxJKSTlRR@vger.kernel.org, AJvYcCUtGGne6iJWqp8jW1dHjFacr7lp3h4zGjhLrBUWb86yRaGjr+iHr+6u/Sb6RiuUqzZ0+Zjmh89lKA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwqOaELxNBwSkNxwj1ZQqj7KfylGBX/2YDA+fhM1C+FTfWexJbk
	5kHhMDGTf7N7ih2VBYt31wg1sdDNeSccQ2FERlh5n5OFvzQ4d/HpUqORgF0PpA==
X-Gm-Gg: ASbGncsrP3FqkWuR6bceqX6oAiWtRMLLk+fWA/VnTfGINbMhRU/vWnIXAd8rLWuVBTj
	knlpwvvyrADg27wh1r6W6ZGdAdNGQ3N5JcOUfMAqLbIRD3tYcXFw6ZTVTb05D1eikE+S5Zes+um
	uBlUG/VT7GGPFMzu63PBEwbFe/5est/42llRML7oGf5eIFTO0NtTrSWQNcVL4jW+8a+MVFkX4Ud
	tOTbx7WzTnxP+N75wTVkuu8tb+zhU/OdcOYYs9QLMmtcqX7dkCZbh6vbbtcF8X3bk5wqNMkQV+i
	3PwCJQBW2zeM9Poj9WwHaiZhk+OvnUsU6vW9ec54Bc8W2x2a90luyrytMT/wDnBJbS7ulV2dpHa
	4unjFznkpGDX9DHMZcIP+ZzHDF8Qbq0Yr6w==
X-Google-Smtp-Source: AGHT+IFNzpARJvLXV1EfITDeWXOyFQtbwixTX3RZylIBDZ29kLIj0YiFSVxoxFvOEdmEXPLzM+R9wQ==
X-Received: by 2002:a05:6000:2888:b0:3b8:d493:31f4 with SMTP id ffacd0b85a97d-3bb693b1f00mr9609443f8f.48.1755525406510;
        Mon, 18 Aug 2025 06:56:46 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:56:45 -0700 (PDT)
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
Subject: [PATCH net-next v3 09/23] eth: bnxt: support setting size of agg buffers via ethtool
Date: Mon, 18 Aug 2025 14:57:25 +0100
Message-ID: <155130382a12b1386540b51a4ca561f61e81177d.1755499376.git.asml.silence@gmail.com>
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

bnxt seems to be able to aggregate data up to 32kB without any issue.
The driver is already capable of doing this for systems with higher
order pages. While for systems with 4k pages we historically preferred
to stick to small buffers because they are easier to allocate, the
zero-copy APIs remove the allocation problem. The ZC mem is
pre-allocated and fixed size.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  3 ++-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 21 ++++++++++++++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index ac841d02d7ad..56aafae568f8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -758,7 +758,8 @@ struct nqe_cn {
 #define BNXT_RX_PAGE_SHIFT PAGE_SHIFT
 #endif
 
-#define BNXT_RX_PAGE_SIZE (1 << BNXT_RX_PAGE_SHIFT)
+#define BNXT_MAX_RX_PAGE_SIZE	(1 << 15)
+#define BNXT_RX_PAGE_SIZE	(1 << BNXT_RX_PAGE_SHIFT)
 
 #define BNXT_MAX_MTU		9500
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 1b37612b1c01..2e130eeeabe5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -835,6 +835,8 @@ static void bnxt_get_ringparam(struct net_device *dev,
 	ering->rx_jumbo_pending = bp->rx_agg_ring_size;
 	ering->tx_pending = bp->tx_ring_size;
 
+	kernel_ering->rx_buf_len_max = BNXT_MAX_RX_PAGE_SIZE;
+	kernel_ering->rx_buf_len = bp->rx_page_size;
 	kernel_ering->hds_thresh_max = BNXT_HDS_THRESHOLD_MAX;
 }
 
@@ -862,6 +864,21 @@ static int bnxt_set_ringparam(struct net_device *dev,
 		return -EINVAL;
 	}
 
+	if (!kernel_ering->rx_buf_len)	/* Zero means restore default */
+		kernel_ering->rx_buf_len = BNXT_RX_PAGE_SIZE;
+
+	if (kernel_ering->rx_buf_len != bp->rx_page_size &&
+	    !(bp->flags & BNXT_FLAG_CHIP_P5_PLUS)) {
+		NL_SET_ERR_MSG_MOD(extack, "changing rx-buf-len not supported");
+		return -EINVAL;
+	}
+	if (!is_power_of_2(kernel_ering->rx_buf_len) ||
+	    kernel_ering->rx_buf_len < BNXT_RX_PAGE_SIZE ||
+	    kernel_ering->rx_buf_len > BNXT_MAX_RX_PAGE_SIZE) {
+		NL_SET_ERR_MSG_MOD(extack, "rx-buf-len out of range, or not power of 2");
+		return -ERANGE;
+	}
+
 	if (netif_running(dev))
 		bnxt_close_nic(bp, false, false);
 
@@ -874,6 +891,7 @@ static int bnxt_set_ringparam(struct net_device *dev,
 
 	bp->rx_ring_size = ering->rx_pending;
 	bp->tx_ring_size = ering->tx_pending;
+	bp->rx_page_size = kernel_ering->rx_buf_len;
 	bnxt_set_ring_params(bp);
 
 	if (netif_running(dev))
@@ -5489,7 +5507,8 @@ const struct ethtool_ops bnxt_ethtool_ops = {
 				     ETHTOOL_COALESCE_STATS_BLOCK_USECS |
 				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX |
 				     ETHTOOL_COALESCE_USE_CQE,
-	.supported_ring_params	= ETHTOOL_RING_USE_TCP_DATA_SPLIT |
+	.supported_ring_params	= ETHTOOL_RING_USE_RX_BUF_LEN |
+				  ETHTOOL_RING_USE_TCP_DATA_SPLIT |
 				  ETHTOOL_RING_USE_HDS_THRS,
 	.get_link_ksettings	= bnxt_get_link_ksettings,
 	.set_link_ksettings	= bnxt_set_link_ksettings,
-- 
2.49.0


