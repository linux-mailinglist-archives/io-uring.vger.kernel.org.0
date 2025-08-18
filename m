Return-Path: <io-uring+bounces-9019-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C20EAB2A8DC
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:10:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7AF2B1BA58F5
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 13:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21E5322535;
	Mon, 18 Aug 2025 13:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ScyMQgVR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05213321F59;
	Mon, 18 Aug 2025 13:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525401; cv=none; b=Fo0zaA+C7g709UmpHK88imb8v+iBeGZTmtt7hCVPjpQEyQIu7FdsdflTVB/80u4yZbiegNPbeI211lMUBUCqJXD7A5Du0P1hlsQCIbW9efinm4JkzCYEc6zmcIoJX1QxnhIkFG7LSBL8V0Y+NWfplaysZtoxdEXwb2bW9zWMEvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525401; c=relaxed/simple;
	bh=pQVryzCrqKahWsbuvWHxrlarAv7fIySFGod7Nm4agT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzT/x2CJDc79+OBt0P38FY5I8I/E7avagCQYiAKNovGo9UmKDTufaZEQ0hwdJCXoeTSHSGUPIHoSO2DaFMTVh2hF4fET6z3KTFE/5O5/+LPbTd9Ju5nK2KMtj74l7iG3P/goLF3KWj/v+tUmDP1Q3IEANnNe+PxepQJSWBCyJgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ScyMQgVR; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45a1b05a59fso31508615e9.1;
        Mon, 18 Aug 2025 06:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525397; x=1756130197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wvt1QlZQQO31LYe7Ap6eWwat4ky5qPqLAGE0m10UM/8=;
        b=ScyMQgVRgndz+HywDSB98NZyWaAH4WR2eSr67/YTu7PvwpTdCWHW/jt8cBPSggE0f+
         DGkUeNsW/KWGilo3GE1sbSNrxc3yFRrCRfqwzBPJpixai1reZoo4pnWNZCrVvlL+291Q
         6Dmraf/9ZmkEUh5wzyidhXdM8Pi2ZCTGwsF05bURDDfem6BtmBw12aPMJgjevl/Dw0b8
         Dy3y9rbvdnU+gfzryjFaxiS53Yc6U5g6HC5cNttCg3L1oU16MQzNqFLnPCiYiXjYvOyH
         QCpX4m7cXfGvlgUuJPsfMsFjtpQatZXeFx+uWB+yZjLiDWkjTxLf1VgLjxm3IWCD808i
         geYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525397; x=1756130197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wvt1QlZQQO31LYe7Ap6eWwat4ky5qPqLAGE0m10UM/8=;
        b=fz3aH0CsN1Ne+10YZAkp5VD14N0qRj9LPNEprXQ3cAA/rpoWRlF/XRvGFhY9MvVOm3
         JDYOMRdYoSipN+54XV6t4vyPHlY20nmssep5bYQAbaIC8vIGWLduK5NzW77jqpvc4VfQ
         2Ql+QCzybthFx2r1SBOOXJt30pKyu4Bn7QGn5vfl9WXWNsmsXTm5mGzQCj/0SwDzkczH
         1h+sxj1dhMZYp3MegQjeOVf4uCL3XlMUnCEokoehe0zjNXLr8CgFbfYxflQ0GuX4+QGA
         neZ3LoaoswPh35nUF+4LAQsCYT4XHHqLKvnA2etnX9KRoJr0UZmQGf5kioI2pSHZRuKG
         /qUg==
X-Forwarded-Encrypted: i=1; AJvYcCU20pEqzndhOWN0KBvuFudIvK2lpFAhd4jY+8WgpUHylMAGGMQipLwLj4SO/PsoSFbSbpKbrNcPEQ==@vger.kernel.org, AJvYcCU4PDV0xrlqqYoDPN9mPQSDE5Ohc2EDbdVoCien3yoPE4SOOTWy4MrMnvuvWg0hZ9yZ4RHGWTGAGQ837Sef@vger.kernel.org, AJvYcCXhSF5TOor17KoBnBuUkEzV148yDOUCD9Ws0VKos9CCofZrvI6BLTqqgkOaXtAPcT2QHoCHfCDy@vger.kernel.org
X-Gm-Message-State: AOJu0YyzVtXP/1WX+4jQH6FiyYjjy4E49fukJtVbKZhdDwCzEznSlVzf
	5Uo5PbjXRpBSI08J2P03Gq/Cxc4n8+OES182QiZSWs3dSraOqNBY3XAc
X-Gm-Gg: ASbGncuAKa3t45A+jgGASB3qYdWTuwX365QTOfHFKQnbmHpa7Pisp8R7JcaCdK13C1c
	OH0lvkojPU6OlnBW6e4bPgWnOpv9FUP/LVqaZDhXvb+CuTUz+WG1CHccCsd+RMrl5OQIhuns7O1
	rfY22sguBRWQDN9vyeaZ0S2peaRchhADf6lZxctnkQs5gwkwGwQlYJTKx3srejfY+Bc0sam8/Om
	STkkOsMvsXSdmUX8uVOTWI2mjnYLJjQKl9u8aeKRE+9HVTPwh5wTQEyAfGEEVPorxaAJYhTfCbt
	CQP0cKroyI/x+RZtgw/12nRdNW29BFr0Hn68JbyYewXcfUnrSB4iY9i1lnuG7kz8Cv+wXHLhiW8
	86hfCJ9/1ramSu3vRxbWeGKEx3tutA+TeUg==
X-Google-Smtp-Source: AGHT+IHn3QGYubT+l/zjkdnvdu+YEXRCCKdAA33enVUYxxYiOhoMR7Xa+aENOKSE8blBUyeIZmBbDw==
X-Received: by 2002:a05:600c:4f89:b0:455:fc16:9eb3 with SMTP id 5b1f17b1804b1-45a2679b098mr64615965e9.33.1755525396803;
        Mon, 18 Aug 2025 06:56:36 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:56:36 -0700 (PDT)
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
Subject: [PATCH net-next v3 04/23] net: use zero value to restore rx_buf_len to default
Date: Mon, 18 Aug 2025 14:57:20 +0100
Message-ID: <d36305d654e82045aff0547cb94521211245ed2c.1755499376.git.asml.silence@gmail.com>
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
index 05a7f6b3f945..83c6ac72549b 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -983,7 +983,7 @@ threshold value, header and data will be split.
 ``ETHTOOL_A_RINGS_RX_BUF_LEN`` controls the size of the buffers driver
 uses to receive packets. If the device uses different buffer pools for
 headers and payload (due to HDS, HW-GRO etc.) this setting must
-control the size of the payload buffers.
+control the size of the payload buffers. Setting to 0 restores driver default.
 
 CHANNELS_GET
 ============
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 1c8a7ee2e459..1d120b7825de 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -397,6 +397,9 @@ static int otx2_set_ringparam(struct net_device *netdev,
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
 		return -EINVAL;
 
+	if (!rx_buf_len)
+		rx_buf_len = OTX2_DEFAULT_RBUF_LEN;
+
 	/* Hardware supports max size of 32k for a receive buffer
 	 * and 1536 is typical ethernet frame size.
 	 */
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 9267bac16195..e65f04a64266 100644
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


