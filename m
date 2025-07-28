Return-Path: <io-uring+bounces-8815-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BD240B13976
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:03:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FE1E189C994
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E107251793;
	Mon, 28 Jul 2025 11:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bbE+NKgh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1BE25BF18;
	Mon, 28 Jul 2025 11:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700601; cv=none; b=fpH/bZWip1nJRDYT4MML8jzCExfJBpheqjiHVitGVHENbXooO7LV30R342kqCK1GKNSZ6WT/PBXSObffcLCSvbXEgGVpFBBOSg5ZSlmIcAF/ddOaKf1nzlHBBZKLFqa2ZVzNRrj0TYDX3r4bQ3ynsvD+4z08oGi+cxoIgpDXe9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700601; c=relaxed/simple;
	bh=/okBd18vec2VWb39KW8zp2+0RpQFd1WW7iTRHEjRxfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXCFUd2Xyrc5Hooz33I/BERF2MZt0cB/VYfMNoJ/untWLCn/34hq1A9Q2DZsB8u00JL2gxppMXqp2veOYVtjkVG1iBvCwzzAlPeMdxQpUOSDqe2DKgYF5kdTACOi96xTVaMEh7Yh21IRVIn4RKLSQ3a6EezRIFzXo1pdw/iuMYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bbE+NKgh; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4561a4a8bf2so48248135e9.1;
        Mon, 28 Jul 2025 04:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700597; x=1754305397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EZ9yCjyWghpo6k2yMmczIbfdVVTFmlV7Jv/CQgx47Vc=;
        b=bbE+NKghdN6uXyjRZCx2LM1XUYLLtOdqVSJaYsWx4DSf51prnC/jU1By9iiR3qvUgo
         hYfUQw6J/vYYDKWC5mEal6pAbCoS6YBi6XebvZOkVlN9OH43/mwkjjsQlLlpSXp8dbAN
         um33h3CqDD3+83V8b3NqCjxB8niOZH/tlZUcb755w1fdcs5Ap/wMB9DOIOstrn8M9fDw
         NHk7wy3E2e05oFNUrs/LZlhMIHHnpowgaCHMtu1hnJ8jfzl3nk3lJrvFc6UG9EHfUM6x
         xkpkhAtNDeyCLof85eI+qKfLDAUBK6/ewjXMUogtQ1DUXkkBHplQDgdJPwnMsh4TXvgp
         H7qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700597; x=1754305397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EZ9yCjyWghpo6k2yMmczIbfdVVTFmlV7Jv/CQgx47Vc=;
        b=M0suojyQpZv7LjLYiv2m0mDLxakwa2cuUCNFfd8+IbLSnFG/DuyDdexAGTCfZgfxAu
         V7tpFOs6geehOqtCyZhy0EGXUJ2eEyauUBJlYzGzgF6/h2g0348YEC475tVUVIz3VN38
         0DF/PGCFg3WC8ZEO5NYjdd6nTscTdtkzx2WY7GckIdYj/PLeLSGzb2NDIBKMdN3/oHLA
         2l1s5E1qHxU8G3+IRwUwMivQjfAvePK3ca7Zlo1g5g0QsH3Sf0NKc/4bBxq7zRccsZ5Q
         5RxqPaLWoJz6ODWOZYoZxzH2YRnlsNSwbMX+L4mr0byNOYBgBS94SZFXQs1PY8r4G3fP
         mCyg==
X-Forwarded-Encrypted: i=1; AJvYcCW8cZph1bol0KW9I7Lt8RASm4EhPs6WkGXzHUT5wQAakNPvbUbVEThDTJ8yhb6hGEp2+/u+as0h@vger.kernel.org, AJvYcCXHHI1LnjbGqHdTCSrI5BftWQoWI2fNoyPImvr59LJJFFphQuspuqRou6dsJwRuB7hzX90cHEfsKw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwDvOt3CFNWZoUzfMYQtfvG2MnnF66uWL2Vi5GRV/b86TmHnBWx
	IhlDY5+0maMp0Odfs1JD/P3Kd8za+rAmkg/59LLqMDqKTdDfMERCgtCf
X-Gm-Gg: ASbGncth7WwO/GnLj0YbYsonPvjZwoRCxR9SAVztCBuyb+RDvQaHqCi85qWv7R4uiQ4
	njjCld18rtiiUk/OS8dbtVlGuFNMZwcnk+e6TkqtUyWWGTgiaQQx9/k74k79DCs8BEXnBT8xhEb
	/CJYe2eus8dNIXFMvwsCokza/e3r30CXxlLKHOsfisZYTlC+gX8de7JShpCrk7Xx0VKiFeLcq1U
	mysq4Y01rw5SfCBOpDmN4Ml80myh0OeuK5EhptTmpVj42K7OQ+bsQmTWy/KBM+wdCNRX/zeN1EQ
	hSWUQ5d7UboF/lMqovQcVOUChbOQxVGub9cpTfh1IaMRWmc5g056aeWPDN22AhitxqE2Dxv4WZN
	yOnQ=
X-Google-Smtp-Source: AGHT+IGeF43mDYZ9K5FiKR0m/aj4CINHrRtr9g6bmkYlIobbYt/aYDpuF4HVgZRQIEGjARgVRNZeFA==
X-Received: by 2002:a05:600c:8218:b0:456:10a8:ff7 with SMTP id 5b1f17b1804b1-4587655b79cmr86172515e9.28.1753700596557;
        Mon, 28 Jul 2025 04:03:16 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:15 -0700 (PDT)
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
Subject: [RFC v1 04/22] net: clarify the meaning of netdev_config members
Date: Mon, 28 Jul 2025 12:04:08 +0100
Message-ID: <d8409af4cfe922f663a2f8a7de5fc4881b7fa576.1753694913.git.asml.silence@gmail.com>
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

hds_thresh and hds_config are both inside struct netdev_config
but have quite different semantics. hds_config is the user config
with ternary semantics (on/off/unset). hds_thresh is a straight
up value, populated by the driver at init and only modified by
user space. We don't expect the drivers to have to pick a special
hds_thresh value based on other configuration.

The two approaches have different advantages and downsides.
hds_thresh ("direct value") gives core easy access to current
device settings, but there's no way to express whether the value
comes from the user. It also requires the initialization by
the driver.

hds_config ("user config values") tells us what user wanted, but
doesn't give us the current value in the core.

Try to explain this a bit in the comments, so at we make a conscious
choice for new values which semantics we expect.

Move the init inside ethtool_ringparam_get_cfg() to reflect the semantics.
Commit 216a61d33c07 ("net: ethtool: fix ethtool_ringparam_get_cfg()
returns a hds_thresh value always as 0.") added the setting for the
benefit of netdevsim which doesn't touch the value at all on get.
Again, this is just to clarify the intention, shouldn't cause any
functional change.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/netdev_queues.h | 19 +++++++++++++++++--
 net/ethtool/common.c        |  3 ++-
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index ba2eaf39089b..81df0794d84c 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -6,11 +6,26 @@
 
 /**
  * struct netdev_config - queue-related configuration for a netdev
- * @hds_thresh:		HDS Threshold value.
- * @hds_config:		HDS value from userspace.
  */
 struct netdev_config {
+	/* Direct value
+	 *
+	 * Driver default is expected to be fixed, and set in this struct
+	 * at init. From that point on user may change the value. There is
+	 * no explicit way to "unset" / restore driver default.
+	 */
+	/** @hds_thresh: HDS Threshold value (ETHTOOL_A_RINGS_HDS_THRESH).
+	 */
 	u32	hds_thresh;
+
+	/* User config values
+	 *
+	 * Contain user configuration. If "set" driver must obey.
+	 * If "unset" driver is free to decide, and may change its choice
+	 * as other parameters change.
+	 */
+	/** @hds_config: HDS enabled (ETHTOOL_A_RINGS_TCP_DATA_SPLIT).
+	 */
 	u8	hds_config;
 };
 
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index eb253e0fd61b..a87298f659f5 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -825,12 +825,13 @@ void ethtool_ringparam_get_cfg(struct net_device *dev,
 	memset(param, 0, sizeof(*param));
 	memset(kparam, 0, sizeof(*kparam));
 
+	kparam->hds_thresh = dev->cfg->hds_thresh;
+
 	param->cmd = ETHTOOL_GRINGPARAM;
 	dev->ethtool_ops->get_ringparam(dev, param, kparam, extack);
 
 	/* Driver gives us current state, we want to return current config */
 	kparam->tcp_data_split = dev->cfg->hds_config;
-	kparam->hds_thresh = dev->cfg->hds_thresh;
 }
 
 static void ethtool_init_tsinfo(struct kernel_ethtool_ts_info *info)
-- 
2.49.0


