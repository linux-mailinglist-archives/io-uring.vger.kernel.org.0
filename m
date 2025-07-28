Return-Path: <io-uring+bounces-8814-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44DDBB13977
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:03:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB6BA3BD662
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:03:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79F46202998;
	Mon, 28 Jul 2025 11:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R3HBuGIw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEBC19AD70;
	Mon, 28 Jul 2025 11:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700598; cv=none; b=ZNrHdcvPqU1BNulkrWwNOky6hSTauXPFr17/NNeXPdyV1LkTU8IJds1shqDEM4MVP2O6eqBgeuAP3nXAGnNtL55x6bA/INUtMSpSvQdzsQLWIWh30q8GxleK5zlXX4wkUIXg3pN4KJPFAHMJywQxREYANdO8ULM6I2IxiqT7SYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700598; c=relaxed/simple;
	bh=FHuvdF45QpfBAE3mFSgsxBtTyywpJO44UfDykrqi3mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWK9N1FFF6Z4IedjLppVhLCbGo6DqjgLpylYmzZyjprumMM/jDbvIUp6uFF7+gDJnTQPUkfBL1WMe3blLD2O+mduB3bXWneM2EIFXxZfxBq0UbeYHA5x75IikGR0yCb2ksgLoECP6TXAoK7AZNtL5OtWSMRdZ46YAQuZXV1KAXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R3HBuGIw; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4560cdf235cso20790505e9.1;
        Mon, 28 Jul 2025 04:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700595; x=1754305395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RmF2h6kscHf9xSzMprRSCAW+Jlc20qkCt5Cp7BihqEI=;
        b=R3HBuGIw/Q2Yw7U682GuA+v9tEY+Knz5ybjXEc8JmvreFhMM/t040tWZtiTujgX7yx
         ygCzVl95oO720cLAibZDn6JYxWJnGokq8wpho/A8GF1r+DMMAlXtbGXQkSX3OgiF8kEG
         9H5fqFk1I7aORCBH7RlkroAjbsNRlJJm6bWtvuJ4zhm7kHPsaQZR6pvGJb1DkjNtiOQF
         wQfYTV6Moa8274gVnWTVgf4iYKWjJY90Vdgebb3JgJWtAAbWE9KBNQhBnIFyLIQJfVwC
         BDg/umXkwPcNXIOX5cw+9vS4Y5EEoZHzfNcP2/h2mLipsQQBbdVl5VOq3+aWfYHD79/A
         F2HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700595; x=1754305395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RmF2h6kscHf9xSzMprRSCAW+Jlc20qkCt5Cp7BihqEI=;
        b=uf1x2s7Orrr7AO9ngcdsTrS0JCjGdegpL35gchjSsXjA9T/I9Za0LWwCkVbrLUUA3w
         rI57/se/rWuy385MTscdxCdHWN5jC544Dn3S+MrROzRG/0B2G+zGiqb9b6EKmGXM7Ntz
         VEShQJFQvgswFwiAkfhuYZgJG3Fgui/R5ptOteaxDrajsig1sdPcoNd3pPBlAEoA2TyG
         Bmi9OyWQqkrzK/WWY0c/FXWELpLR6Naznqd/a9fvEoPRDlpQ1p/mJLJYP87Hahaj146S
         y8azXySvAWSWZt9nO0Z1z5aINa5nm2l3BOzfjAi4aYFMv8gbg49OzB1m6WC1bbT1Oy1+
         Xbkg==
X-Forwarded-Encrypted: i=1; AJvYcCU9Pm92bqgxlZn/xmFbUfceOlvuHkxyfH5/YPro0aYHZYXoYAG2CHlikdwNiObNWrTONVHgHZt0@vger.kernel.org, AJvYcCWlK1RQiOHMNDP6EbN/sBPUiMTAF8V6hxsqSuLV0oJc5VEWiKyhZaH98PPpuSV1/JOZCndizxkjCg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQEb0NuB4A6vyPh/wMga+ySUUA7r1CpnuDuV1VloZWUQ5XCiqP
	dTD10IOsd5QHQ8Ph2x/hhV4JJffaAFysRSvI3stAURggHmRXq4awofHH
X-Gm-Gg: ASbGncu6DojUKcO2k4cnYrEOsRhNDQaKrqcqekJcW88FKryjPAyfQIW1oQu30wdM//g
	YmEKyggWtiqrZiMkP9QtqKk/GxEdfIzqrKtI3G782qC8vGWHjQmr/nMe2GCRgFmxDaebByJcwRn
	Rrd90CLY4fceA/b4RAJFMLTPxNkk5J5fnkKov/ov+Qf+TsCnBsPz0x/7mBhhNpiEGrXmOkTw5Rf
	6GroghaAogS9f9dieuJIRhRSp6QW4JVXecfUSnKMYrp7Pyx9elMhZKQ2EBCByTA1GsXuMTHAlEh
	Y5tptJXZQdG83l45z6Ljj6rIFUeu1sCINwmFwiQylHfDsRxYMUl/x9PyeKma5wktMEtW9bT51qh
	HQXQ=
X-Google-Smtp-Source: AGHT+IHCE8dzQCegHKnRteyLXPfsRF6DZu4cYhSRSry0fXfIYqv8ZPfxAvox6iOKNMDSyrOxMHBBpQ==
X-Received: by 2002:a05:600c:828e:b0:456:c3c:d285 with SMTP id 5b1f17b1804b1-458762f07e3mr69070475e9.1.1753700594546;
        Mon, 28 Jul 2025 04:03:14 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:13 -0700 (PDT)
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
Subject: [RFC v1 03/22] net: use zero value to restore rx_buf_len to default
Date: Mon, 28 Jul 2025 12:04:07 +0100
Message-ID: <12b155ca79e838e2c141d9411f0b8b3aa15e508e.1753694913.git.asml.silence@gmail.com>
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

Distinguish between rx_buf_len being driver default vs user config.
Use 0 as a special value meaning "unset" or "restore driver default".
This will be necessary later on to configure it per-queue, but
the ability to restore defaults may be useful in itself.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 Documentation/networking/ethtool-netlink.rst              | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 3 +++
 include/linux/ethtool.h                                   | 1 +
 net/ethtool/rings.c                                       | 2 +-
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index b7a99dfdffa9..723f8e1a33a7 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -974,7 +974,7 @@ threshold value, header and data will be split.
 ``ETHTOOL_A_RINGS_RX_BUF_LEN`` controls the size of the buffer chunks driver
 uses to receive packets. If the device uses different memory polls for headers
 and payload this setting may control the size of the header buffers but must
-control the size of the payload buffers.
+control the size of the payload buffers. Setting to 0 restores driver default.
 
 CHANNELS_GET
 ============
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 7bdef64926c8..1a74a7b81ac1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -396,6 +396,9 @@ static int otx2_set_ringparam(struct net_device *netdev,
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
 		return -EINVAL;
 
+	if (!rx_buf_len)
+		rx_buf_len = OTX2_DEFAULT_RBUF_LEN;
+
 	/* Hardware supports max size of 32k for a receive buffer
 	 * and 1536 is typical ethernet frame size.
 	 */
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index dd9f253a56ae..bbc5c485bfbf 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -77,6 +77,7 @@ enum {
 /**
  * struct kernel_ethtool_ringparam - RX/TX ring configuration
  * @rx_buf_len: Current length of buffers on the rx ring.
+ *		Setting to 0 means reset to driver default.
  * @rx_buf_len_max: Max length of buffers on the rx ring.
  * @tcp_data_split: Scatter packet headers and data to separate buffers
  * @tx_push: The flag of tx push mode
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index 5e872ceab5dd..628546a1827b 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -139,7 +139,7 @@ const struct nla_policy ethnl_rings_set_policy[] = {
 	[ETHTOOL_A_RINGS_RX_MINI]		= { .type = NLA_U32 },
 	[ETHTOOL_A_RINGS_RX_JUMBO]		= { .type = NLA_U32 },
 	[ETHTOOL_A_RINGS_TX]			= { .type = NLA_U32 },
-	[ETHTOOL_A_RINGS_RX_BUF_LEN]            = NLA_POLICY_MIN(NLA_U32, 1),
+	[ETHTOOL_A_RINGS_RX_BUF_LEN]            = { .type = NLA_U32 },
 	[ETHTOOL_A_RINGS_TCP_DATA_SPLIT]	=
 		NLA_POLICY_MAX(NLA_U8, ETHTOOL_TCP_DATA_SPLIT_ENABLED),
 	[ETHTOOL_A_RINGS_CQE_SIZE]		= NLA_POLICY_MIN(NLA_U32, 1),
-- 
2.49.0


