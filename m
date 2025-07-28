Return-Path: <io-uring+bounces-8819-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61644B13983
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABEDA3BBE39
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B561E25EF97;
	Mon, 28 Jul 2025 11:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GI12lCcP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A5025DB07;
	Mon, 28 Jul 2025 11:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700606; cv=none; b=Tn+V9p3JHSYp8OuKAMX4UqaQuKAZTsVBGJZtfukNMUHrubMnoAcNtRYveWOE1PLno7NStvTsQFVmk9MZXklWnJmFR4ax7jfB/6fpXq8ASxcCblz6L7M4GXeJfBoE0A1W7rH2NlyjSvQ07aRwlH0Rfi1AK3jx+9xFs08eiM8ut68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700606; c=relaxed/simple;
	bh=p4Aearm89mP2V6+EZh9bYH7517VLEThN07w0FKFuDdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzwQ5usLSJZIuEcPSGfKJuQ9SpA/1s3Ws9ncj30x1VpdZUrnjniFChWfd1DXOaAr56w9D0YF1ugN/odjnLHKJclIkwXRANuH9YHalc24Xtj5USv34hARzYtOeCsBBxWkJDf2weQios+s8IxHJjxzXlp6VUazp5ktuTd1wTtgue8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GI12lCcP; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4560add6cd2so31556065e9.0;
        Mon, 28 Jul 2025 04:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700603; x=1754305403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PF6KnIxi/jze719ANEb4v+KSfJ8jx+BMPrxtTTMehcc=;
        b=GI12lCcP6/+vgKcq6Ie6B92sP7yXWt09NDVwFuSgWojy3CftiJ/0qC33pURHSu4Eej
         nB60/aKKylrQ+iI/nqv5Oc8Q5dVOJS0AGDbFvFLHNwqZXBhTMQYkmyaaEvZKfraCj3MN
         MAkOB15bZ1t6YGlGVMJhhmmUpTOTSXa9PwQkq8ozNnw3aPK2yNG2klXFmmN3AXls3AXT
         q4virgPj3IZyrytXN+r58MuvFeACwzga4iRE0w2DeRpvY0LIjvQbGFhWLgZAKhzGLlgY
         qAPUXkCetJ9V8Gx10vDrHgv5OUcnzxdDtj/STf4brcxNMPAuSS3gax72Pg8O8ZVULUEY
         ThFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700603; x=1754305403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PF6KnIxi/jze719ANEb4v+KSfJ8jx+BMPrxtTTMehcc=;
        b=AsKUHK5eDfjRRw6+lLNQ+cRNJDntyjZYMPlgxuVNxOaMSByrRxuxq0PXyAyvABJ/3q
         RdECLoWgmX0FsLUHu7eTVWThOn2qeJYFSB4iT1plWq70upe1YXHqd0eI1nPdNIJTV5PV
         NyR/iZdUH7D0cYKPm+A7kWTQvRXE1xIrG8E1waLqzHeob5MbekZ6/8R7kzaq1oKAc/fK
         dEJFr1aoxtVzqlPVKr8ko3Rx3O9Fe1v4FMS0dAvxRUKjCmJtpJ3wxz8BnD2m4Wgc+p9b
         6HmEoAV7E1LN0zqzEfJQmrab6u6AkhT5tydslfA2h0x5gbbHDn4S5WJLN3uyv39gz3t5
         mHeg==
X-Forwarded-Encrypted: i=1; AJvYcCVFJMm2j8KG5lYQSgMGk0fGT0ElfvpsQtFg0ke/e5R2U9RJPETFd6JJc65+gY4BBCXNC7Sd6BGa4w==@vger.kernel.org, AJvYcCX0q6ovMEsvihRwlD+CNd4zSB14ZmSYraR21a+IyIrBBXEwsb97JsSZjfrwrZ5EuSf3kGro2zGn@vger.kernel.org
X-Gm-Message-State: AOJu0YzEWnMUrMdtJLBoNOE8t77NT/cF3WiF5Sl3JLayAJ+ky4Lif/bH
	kr/uqsIQZXr+YqMXsYJpdsuXyeMYvJAAJuXPA0Ud75qWrPBjEcKl0CxE
X-Gm-Gg: ASbGnct1LBzoBZkP+KD5BBQgGI/mftD/HZPiHEJpaeloEbQQZOOTCjzElzBfQpfLiAZ
	kN728eM5/fkPk1gGmoiHt/6ZKmc71Mg+pRyrebMp1OGDiYVGXme6zJH84kmQQVO8Lr5+8hTOs24
	Llc1KnY3FyzknXHHOYG5dD6J1ntUeaI2xJbTKNDF6djCG/Sl9cMcAX4CRsRNtMpSpwAA1Bk6H5W
	FGO2AevfoRVGe7n/93aMvrtjtfzqs84dPKVMDKv309JmWstRrTFCL2St4LrexieEaV1g/H70tsa
	mZio1aik6tMwTBkRQYlimrT6HWTiSNP1uLgfM35F4OQ+OmMdTrG3q9ay3cHu+Vk6qTO7ocoTLP6
	j8ek=
X-Google-Smtp-Source: AGHT+IEa6jxhg2qPege/vahDlvP6V+J91GLkShY79sVATtu/c91ojSqQSYe3Jmz6hBFrNmnMWzdyUA==
X-Received: by 2002:a05:600c:4918:b0:458:6dea:af6f with SMTP id 5b1f17b1804b1-4587058a4b6mr86224505e9.15.1753700602994;
        Mon, 28 Jul 2025 04:03:22 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:22 -0700 (PDT)
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
Subject: [RFC v1 08/22] eth: bnxt: support setting size of agg buffers via ethtool
Date: Mon, 28 Jul 2025 12:04:12 +0100
Message-ID: <b017a553394430a33d721f32b8249a545c06f839.1753694913.git.asml.silence@gmail.com>
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
index f5d490bf997e..0e225414d463 100644
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


