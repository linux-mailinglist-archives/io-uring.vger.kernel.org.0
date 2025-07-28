Return-Path: <io-uring+bounces-8816-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27FC5B13979
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:04:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4360E3BBCF3
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0957725C711;
	Mon, 28 Jul 2025 11:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ha0KUNVh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423E219AD70;
	Mon, 28 Jul 2025 11:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700601; cv=none; b=OjtXtTbwQ82YeGkgUYTO9s9l+kekGbqqwsMSfeNCV6+F2H8V4fIaj0sW2/XZSSu1b+p5MRe5Tv0hs/erTRfNinmGcGSyYI6syFANpP29sGzF2USm6FtqUXHvO/NUQGs4MFJ2Tg8MZwDsZg6GUtPNZrbQiioxGw7+UCNQbo8zR5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700601; c=relaxed/simple;
	bh=bpq8bSu5vUpnJbwMA39SrGl36N2KzhwjnqAGKM+3+Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xi7WknaZKqq6XkOpT9ojQdJ0KQxqkKckamp6nCKnU1W3rW9wGPkxIOyQKBmBFvXNd8+PLP2/vyj5DTALg0ytJgcyu8naMiibqoT19IROZv2YrVFvW0rr3xy0fvB7qujlPtukTefL99Kr5WzAPZsbuuN4iemeY7gATF3ZVhx5xVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ha0KUNVh; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4563cfac2d2so45534895e9.3;
        Mon, 28 Jul 2025 04:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700598; x=1754305398; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dw1ueqs+sn1SYCkdrkF4u8wUGhQrmnEyy8WU30jg9Ss=;
        b=ha0KUNVhmhHTVv1eU6KhoKVH8fF2oPsbtdMxrkO0k+0vQHLJgd0wUhVjqMrSKg2CMn
         LQdTvFAVeXUbuv6UkMZZ1wogWZ2chHejweiL9ATPOvP7R0GkdcBUC0KiKIe9umpXRX3W
         noXYJ+GgYQGB4uXjbwMDggjsPD4umz3DziRvLxY8Z+QpKS4NsioAs6EBU8nr6pQ6Nxu1
         3hiq43aGYlt2728oWhnYXKgCHNKUSYRhrdrg98ybP8/kFw3VGIBpCLt6wCxjKnqKzyD2
         mNMGSnSMVzNok2qW272ZMotIuimVWMO6KsehKh+61ZFxh2cvsF9tVU+QvqhguPGlJmD9
         f0/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700598; x=1754305398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dw1ueqs+sn1SYCkdrkF4u8wUGhQrmnEyy8WU30jg9Ss=;
        b=mc2kHG1la1RNb1ucUhcRRp/LbpWW5TPkS7QhKBtyo60u1QNhPOUY75G5ev2MWvT4mT
         Gn7S2aWBKI3bHD1ZE7c2jBnRo813MdGYdVJRNV7aq5fBpwEKA1jMG+HS2OH9zxt/zZDw
         Pe3C+/88gWCEraVr8hKhIWQM+YNLl65aEN7joJyUmWuScWhVqAUPPZfEUHqHkLxcoVY+
         5nBU9VKmlJDA9ykLlNl8rRDmyOk3lkngEFpGfZaeQCCDtn/JNZC45sDm86lxvgFGseEY
         8/GGpmYXaCPYz58JzLeUQYon5TbRygieNTbYtnVFa7HikkjUnzkIe0Dxp2A+ijYnPluR
         U+WQ==
X-Forwarded-Encrypted: i=1; AJvYcCWw1jmmg+J84/xUV6iMXsUnv/i5HldWIWrXykTUpHzzImHR3hSxbYxascTSknbhyDOHGmoQWJ5s@vger.kernel.org, AJvYcCXnsflCtY15DA/v9W9YxOzgk6TQIykHX9No3WVe50R9HIA+gkpPuxGhJIIfmJElZGYPpuS8tGBrSg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3AL8yzpA+EA9FcGvIP0RyxQ1ksPX9I6S9H1RD+9U5yONu6p6u
	nJb5ma2EBUSCmOO1i9DJlIR0UG7cv1x/MWfzThkAEUIACtikjEiDF674
X-Gm-Gg: ASbGnctqqp3dMbADF0IS4lmq708pk31XY8pciiXuHN8mTqutOwsLs3tFHx47J93CbWD
	d+tF+jjlqLkdQtdEHWrftZpmoA4VZ+NyipyGvz5v4M21NH+MXzfF4xGLcvBRV6sTVo2D3fwkJFY
	ckLSas1GqnG7VeIAgepKMEx498ecv87hSL4YRLMU24P6PBJ0nJl2NZHwV3EHQb1Oxqm8WyPqtu/
	TAq/7e2FB7gE4jQqTTdV8t8fbmjpgFYoUS8euF2Ahrzgu+EY5WnE8U5sHGo1IFhY2vDbDmMRh/y
	kz8+ANclzdySdf/8oHJcRdvR6Y77Aeb65CtkT5beIKKvIiPInmUPkd+XqBIs035p2lsQ3reDZNv
	/HM0=
X-Google-Smtp-Source: AGHT+IHIUu7ZUhXioXY7WaIAKZINomp6Y7akVWk2V7pggpqhYXuIsIvlzS1UjFy3uFZdQLuocmWfbg==
X-Received: by 2002:a05:600c:450e:b0:456:1c4a:82b2 with SMTP id 5b1f17b1804b1-4587630f5a6mr112488485e9.10.1753700598017;
        Mon, 28 Jul 2025 04:03:18 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:17 -0700 (PDT)
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
Subject: [RFC v1 05/22] net: add rx_buf_len to netdev config
Date: Mon, 28 Jul 2025 12:04:09 +0100
Message-ID: <261d0d566d3005a3f2a3657c40bf3b3f7a9fdc98.1753694913.git.asml.silence@gmail.com>
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
index 81df0794d84c..eb3a5ac823e6 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -24,6 +24,10 @@ struct netdev_config {
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
index a87298f659f5..8fdffc77e981 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -832,6 +832,7 @@ void ethtool_ringparam_get_cfg(struct net_device *dev,
 
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


