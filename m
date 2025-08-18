Return-Path: <io-uring+bounces-9020-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB632B2A7EE
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 15:58:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC0777AB4B2
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 13:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6821632255F;
	Mon, 18 Aug 2025 13:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C8fo7v98"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863C3322532;
	Mon, 18 Aug 2025 13:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525403; cv=none; b=mbXXHhejP4L1WXEopiB0FrujVwzk1cAd8RdBopzJhVDMRwpEqts2a0jYNYz8vJHTwkp/R2BW3mpS5IK6MsT0vVyfM4f7neJU9Ai5PV0Vzs3fi0p8DBj++NMci9T4XAdvSWZN9t6q9rIhh4zE+7TS3un2Co72SSxOkZ43x7e8CU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525403; c=relaxed/simple;
	bh=gYb8YBi9GClyBnpN+21boWlLrjiO7+W2cPrK+FgitMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDohfCcDqJevc5en6octYTruXWvT/AWUWHf/ZzO0/edUUkMCbVi6HfzvJSy1lXQiFWocIivN0lHF2OV3eS78Pgx1pA8vrurZJHTiXu8mTmSk0Lc1xQxaVLzTRADwhGbDFb/fdMGr0yoDOknXnYAyxbhcwU6FYsoFJg37tuJMjVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C8fo7v98; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3bb2fb3a436so2261857f8f.1;
        Mon, 18 Aug 2025 06:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525400; x=1756130200; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pfQud3JQW5FBjJboy5AodeO9y125Lb1Qj1exFzfx7Sg=;
        b=C8fo7v98XAgovvuLZm6GjXfHmj18sPeQw1yR1mr9+hPJmA++pS3OCXBSMbPMYr2vcH
         eikZ7Hd0Hy4ey5id8eQKdEO6BzmWXf3CZsW1EpzvjILPsgcRsL0MP8QT2XHFohTswZXq
         hoKZwgwzcA6gZEOl8aC7QqFysSEZfbepiDrIPcETVtuctplNY5lZ2xE3hctLvS2FQygC
         LElswj655p5wcS3Pn5VaQxk6IeL63+z5mroYLSKr01MboyLVpTqWDkIG+FGeS2MjllIG
         kKB7OhYJHkZpdCteLbtXRCmIcQZMhmS2Lm+x/Csxx+dYrD45IIziD90jhJcV2U8Xohtl
         dt6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525400; x=1756130200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pfQud3JQW5FBjJboy5AodeO9y125Lb1Qj1exFzfx7Sg=;
        b=CWUDdHMuUageU/BKbGZRS9MozvM88vtjvYitcUY83lP6w1eFIq39i1HLfXZjcWf8Mr
         qjCiuB5xjE5V0XHyp2u4B2MY2fOXnnDSsuLiIUUcjjVlH4Ev5wZUd3F9XsfLj1ENAXVo
         PgSu02UnwA5GDI75iScF+AOMn9JRvk0VXlfyx33xN+HGJuLHJ1K3kzVvLxapMKAJMUpH
         h02XZxx6b59vaY3QoA0kQ9yd2b2LqKoBfdNV59i9cHzJh9HmFX1DKlNMPkqwr5pXuX9G
         K8QAiQrsEwXZOZH+o3kDPpUiZWi3BpCqv+8dGt8SHIJU1UZbXCdhfdhzTEX8j/NAI1zc
         VdcA==
X-Forwarded-Encrypted: i=1; AJvYcCUnC/rWSngXa7kgC4jX0EYRO2K8AeviXBtIwGO0NjB0yEnqW58nXpLwmRrVTu6lXNTXTbvy37rUTw==@vger.kernel.org, AJvYcCViwSFdSDCt4VyREuLUHyOV7K01Ra0HDSBiZyX3xIWwIuK57q7RazZtMSqA0KdrJbTRRHIu8PCGH6rGmD/+@vger.kernel.org, AJvYcCXJqefQ+UHVSwUVf7TERw/5rWYH2c1xrZ+SfTiJnWmeI/CJyrFz9XjMBb6YuV58pEPTWckTOF5t@vger.kernel.org
X-Gm-Message-State: AOJu0YxptdFlh+r/WvmRg4n2rkwZK+Vbr1Xk7Vjwkcpq7SaqYo7w7TTf
	51iOHXRtoqT6pivfak1G3QZFrgW0LHrj5Q9qHJtLAujLkUFtlCuS3Cc4
X-Gm-Gg: ASbGncv2p1NwTOQ13k3ok/NUXJQ3Km+91Nj8L/Lx7IPnJ7/CedC0tICgNDJwYUpQwx3
	0qqV0kXuCWh00HRClFsGmIQ3qLsutUOH5c6jLeXRcg7+LTeXQkyPWFdC3jv67IjIvJk1jwrTclA
	57qId/xlaJkoqJAOj/H6bWieUjNpLV7oDZXNlaRIEplHXENbhCbrpk8XqufWRd+0/M7qJfXfP8r
	T4c6oFU61ITCKnFxBaDm6NyjT9xQy0W62KKT6Hnbmby6FUggSzG9CufwFeH9TITqkr9s7KlhEDO
	mb7+f9F4iXP61Dzi/F+rP/OPCnIFaRxDzMo7WY+ziWXXxKrsTn7EPEbIOSSGjo3veuSqkvlGFdo
	xuovTyT8JJFaugk09owmEkR8OsvA9gAwjDw==
X-Google-Smtp-Source: AGHT+IHxIjgZLNrNT6Gg7iLX3j8pygieYq8x0uUhS1o/rgjFhIoBZm6xekcf/5NxSVGPZ511AYFo0g==
X-Received: by 2002:a5d:4f0a:0:b0:3b7:6d95:56d2 with SMTP id ffacd0b85a97d-3bc6800f436mr6218222f8f.7.1755525399677;
        Mon, 18 Aug 2025 06:56:39 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:56:38 -0700 (PDT)
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
Subject: [PATCH net-next v3 05/23] net: clarify the meaning of netdev_config members
Date: Mon, 18 Aug 2025 14:57:21 +0100
Message-ID: <8669b80579316a12d5b1eb652edb475db2f535e7.1755499376.git.asml.silence@gmail.com>
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
[pavel: applied clarification on relationship b/w HDS thresh and config]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/netdev_queues.h | 20 ++++++++++++++++++--
 net/ethtool/common.c        |  3 ++-
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index 6e835972abd1..c8ce23e7c812 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -6,11 +6,27 @@
 
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
+	 * no explicit way to "unset" / restore driver default. Used only
+	 * when @hds_config is set.
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
index 4f58648a27ad..faa95f91efad 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -882,12 +882,13 @@ void ethtool_ringparam_get_cfg(struct net_device *dev,
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


