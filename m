Return-Path: <io-uring+bounces-9022-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD7D2B2A8EA
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:11:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B246D684DF9
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 13:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36661322A12;
	Mon, 18 Aug 2025 13:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cPIs/8vY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60859322776;
	Mon, 18 Aug 2025 13:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525407; cv=none; b=RV9yyWkxI3NZsTWXja9Tgmi6Z3Afq77inIIxvhO/AzG25xZboorKdM7jUnWb6ylEpfgXKP2g83PR4vJjx00gbnQV8kLmg8XBNPEmO0mt9YCb7zVg62edZnJ5SY5ulPnl23yFt3QZl0CAWNBjMWSAhoNJRY75G35QmNTRosDtGAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525407; c=relaxed/simple;
	bh=FlAybfuKHbG6+a7ZbRKEB6/E7DbObThw5ayznKjijpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBoZvXKWWypi825KAE7uhq7P/29Qu7Iko6XMWefmNeD0EF/k/5nUJP7MEEGPv1H0gFmEH8GvDsg/8DpRU/NtbopqCcF0I8A3m4uu5qPj1e/kFmmZ6DTam5QxjMoyL0upjFc4Dg/YmkH031rOwkI7vXQYDcRFqS4HUFj9CTunOpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cPIs/8vY; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45a1b05ac1eso19561395e9.1;
        Mon, 18 Aug 2025 06:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525401; x=1756130201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s6CWZWRRbyysTyJbo/8Elocwsz5g3qKnhCwDIxLbwp8=;
        b=cPIs/8vY4bqB6nxe+LYKZUseQfz4Bg4Bfn1XkjGsUBC9qUTk9XXwWiPk4Exjr6IMKq
         aeIWisWkICjJZfoDlZJ/PfEjkyKd5W+Z1sKcBJCdSTIhKE3zEDjAl6jNfhH+uhZ0m54G
         JgUI6aLcJOXIcojXGAqEyso1SrDjh6wfkG65RujijfmRn3KT4EYqhLQmZX7foEl/6mfv
         jiI/rbVsPC8vfzi9rc0H7Te+9kBwsAGpboMznYITiqADlYr+hdig+CEFXEZGdw+9nsIf
         dvAe35UQU08P8sQTAPZhy1/u1zGgdYvdfYCg000Ijf2lwXvZRsfvyjbXYh63VEXBHwLT
         FtqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525401; x=1756130201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s6CWZWRRbyysTyJbo/8Elocwsz5g3qKnhCwDIxLbwp8=;
        b=rmDvezjmKI62EAgVgNy/YnGh17MbPnj9tsZGIPGm2UtAaChu4Z9UF5TxHzeP1vr01m
         19bREmaLAtZXR5FDJg2l7tm5BSqbL5SOnhYQlZ1vLMm3VvvAk4SD0xkMU+9V3v7GCDr/
         JVgZvyooV4V7LUKDXZFdVWuI7uemiKGAY0GjVTOkSkgoZd1jHFK9+/Hs+mreBfu5aGk6
         fdhnS1Ckh9bV8J8D6h9N77afpGg9IxwUBgW4I/2f9MZU4YJ0O1CpHk8bXetDIXV9siDX
         +snZvdE99B51u11kcfL8zXuvQ1+2poLhWHiJg8j1LO9LrvWcLxPKai8O1m+dAEfLCCbQ
         GG0A==
X-Forwarded-Encrypted: i=1; AJvYcCUMFcMp+E557De/FSSynK/fgDWsyBBSblC4mrViUjHv2jgYo3H72WsGIp7pzULZxd5NWrfxurq41/1s6vWB@vger.kernel.org, AJvYcCWZnMrceZ+7FYScbbAOuw1F+ZuarpGP9IgXWIMt2y8HRAyu89dbdWcphJL7hgJt/4jQeCQkSFmc@vger.kernel.org, AJvYcCWoHV9WiE5VySITYT1BZ6+NH3YtaWS1dOFbZrZem9o0LmFYo5Pb2igd9y4AdRVJ6EhXAx7jVkDMZw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyBHuvg34UT82Je1K1OYpi2LmQzeToygHexT0moCPzjAEp9wJZQ
	Zy7zNKOBlk3gkQta1TuGBJQB7zVh6TS6qWehR1MLymWe72t9HdKCA2/w
X-Gm-Gg: ASbGncuwGJ+pP9i9Mr2iPlQhaa1jBGAufvXVwwdhvdjB34F9eRM7d+GqIN7ddWfxteG
	nHJN22eauafskA0nJptu1puvfSnh/yQj3NqDkThig+rASX7+49T1bP9/eQMVWngDfguRxN0dL2Y
	F4/peKvgqEzAPBUo5r27KxhpcaLV+1/4o2nsz7enXUr0KbT5yVjpDLciBnqCVLLYe8JPQEzAk79
	7fqh4JektBQYqMayZYfnwi14UOQg3aHOBrvKi7kts6///lnpfezi8yHRt8msbXhHWKFr8YcloHR
	9UT7W7WMJQkpGobGJDfct1Ik6VDuaDCopf7lZD9qMBQg8QXvl4Ka6IVdgvIQoBjdu1STx62+g+N
	MFoOK2s6Rpe+CvgCS5WvnkKj5exU/+pUr0g==
X-Google-Smtp-Source: AGHT+IH+tR2XWMLJZg0/0SvwYa74cV6Ty6uup/A/EKyiDBFftJoh6BBU2pCbd0h9aJQxrt19sfX62w==
X-Received: by 2002:a05:600c:4fce:b0:456:18f3:b951 with SMTP id 5b1f17b1804b1-45a21805be3mr109152805e9.15.1755525401413;
        Mon, 18 Aug 2025 06:56:41 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:56:40 -0700 (PDT)
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
Subject: [PATCH net-next v3 06/23] net: add rx_buf_len to netdev config
Date: Mon, 18 Aug 2025 14:57:22 +0100
Message-ID: <fab9f52289a416f823d2eac6544e01cb7040eee9.1755499376.git.asml.silence@gmail.com>
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

Add rx_buf_len to configuration maintained by the core.
Use "three-state" semantics where 0 means "driver default".

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/netdev_queues.h | 4 ++++
 net/ethtool/common.c        | 1 +
 net/ethtool/rings.c         | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index c8ce23e7c812..8c21ea9b9515 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -25,6 +25,10 @@ struct netdev_config {
 	 * If "unset" driver is free to decide, and may change its choice
 	 * as other parameters change.
 	 */
+	/** @rx_buf_len: Size of buffers on the Rx ring
+	 *		 (ETHTOOL_A_RINGS_RX_BUF_LEN).
+	 */
+	u32	rx_buf_len;
 	/** @hds_config: HDS enabled (ETHTOOL_A_RINGS_TCP_DATA_SPLIT).
 	 */
 	u8	hds_config;
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index faa95f91efad..44fd27480756 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -889,6 +889,7 @@ void ethtool_ringparam_get_cfg(struct net_device *dev,
 
 	/* Driver gives us current state, we want to return current config */
 	kparam->tcp_data_split = dev->cfg->hds_config;
+	kparam->rx_buf_len = dev->cfg->rx_buf_len;
 }
 
 static void ethtool_init_tsinfo(struct kernel_ethtool_ts_info *info)
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index 628546a1827b..6a74e7e4064e 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -41,6 +41,7 @@ static int rings_prepare_data(const struct ethnl_req_info *req_base,
 		return ret;
 
 	data->kernel_ringparam.tcp_data_split = dev->cfg->hds_config;
+	data->kernel_ringparam.rx_buf_len = dev->cfg->rx_buf_len;
 	data->kernel_ringparam.hds_thresh = dev->cfg->hds_thresh;
 
 	dev->ethtool_ops->get_ringparam(dev, &data->ringparam,
@@ -302,6 +303,7 @@ ethnl_set_rings(struct ethnl_req_info *req_info, struct genl_info *info)
 		return -EINVAL;
 	}
 
+	dev->cfg_pending->rx_buf_len = kernel_ringparam.rx_buf_len;
 	dev->cfg_pending->hds_config = kernel_ringparam.tcp_data_split;
 	dev->cfg_pending->hds_thresh = kernel_ringparam.hds_thresh;
 
-- 
2.49.0


