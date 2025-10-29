Return-Path: <io-uring+bounces-10286-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6859BC1DABC
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 00:18:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2415E4E50CC
	for <lists+io-uring@lfdr.de>; Wed, 29 Oct 2025 23:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2B52FFDF3;
	Wed, 29 Oct 2025 23:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="DTX/eMQE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE6D2FC01A
	for <io-uring@vger.kernel.org>; Wed, 29 Oct 2025 23:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761779820; cv=none; b=ryUEAbFuumnHhfvgIe0IRfkCKUDZI2lGtpF6BdBnDFgXQIT2COPkWflpljaoLJPgVD+gqrNuOwJ2/mXYk5lYuWRHiFVbnAUpNa7Av9YS3NGY+dQYMxdtjUk9wNtUS1IEIY/VuRmTGbfoj5ah2Rnaot4AkzZMqFFarvd2y2H//oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761779820; c=relaxed/simple;
	bh=Y0bV3uOqQa0TmJ2BTXmCRJtuU5Q6CRukeoWm1kvXiU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+jS/XdkVRg1zbPxu04RMssvFvSX+mDOBaf4fsiQnm7ufQghUkBd8rLK2P9rb7inPBJe1RNfd2A5va1lpb4uHfqClgVs5auVIqbHr6xDuWd+PPLBDO7uSkr+wLq9NYRaBzvQikCqkAomIaKtGOQIGMXHnhy3Bm+sIY7OzuiKct0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=DTX/eMQE; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-3d5bb138b2cso211979fac.1
        for <io-uring@vger.kernel.org>; Wed, 29 Oct 2025 16:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761779817; x=1762384617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yzjBeoCQ8MaxzzsfgtZXJfGuzfexJFlkMup0/3yKERI=;
        b=DTX/eMQEjhoa3/3V3N+hIDmGsb1PWCjVqYdDCFgauDbaSp2ZDLHw1CxAKmhszs8yko
         x1b0p8W8HPLTUIuwfC3TzJvD7jZ3JI1jnOs3ZLVBEBB6Kb4lGjduF7fy6HAV22utcXph
         373rgBiBmzjlGSDT0p1RVBajC3jpOFpNdp8ymojadE33H2eijcyFCvwTMkUFlIYCTqnt
         HS6tMMdrdcZul0oYiB7N3XgoBL1W8CLgo1N/WkieSpzU+qN4M+japZ5OPJmFRPYavKvm
         byd6k/u8PrI9T2xFqYuyEjQ+wcFa38/uoLhN1F/bofD4Zw+ZVPwSlADgKq1XD9nveTkp
         xQqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761779817; x=1762384617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yzjBeoCQ8MaxzzsfgtZXJfGuzfexJFlkMup0/3yKERI=;
        b=VxjlNlTZbDp2y9DPnsbORXFXETZA5c1I0LXHz7ZC9Iily99YA53hh3OBUfH6iC9c4g
         7VKA8pjhiOMcV7W0dpNrcTkNc5vj1yvpD9v3i/RaTEoRzyNGlr0yPWhozsGQuSTYnv4N
         gPDAF+wEmk5wG/sciTRswnzXPeTXyi/YxRM1/nXdVMmdp3ogIlvQq72R0FFCgc4jEjdg
         0/rT90KX4SVKY1cIyXNgVL0nGhdFZxEHghP17KSCemdsAzhjsAG6rNYwz4lTZJ5JzyFY
         xC1XEq5etT20utXMnTA8USVHlEaAGiK7CnvXOdHosqnu3DDDS+FqzdhHVeyWnSLF9sjC
         ZoSw==
X-Gm-Message-State: AOJu0YwV2b4lpO+8hOOBI+ujppDOjgxkgMnnOeuy0/34SUGU/+K0XWQ8
	z7q9WoEChDo4kYxvzeI7sOLH/Z6svdrPUN2BubmWtqM4Hrl4vEU+++QyDOw9LAqXX/I534JOOAf
	o0xfh
X-Gm-Gg: ASbGnct5WgcweCCxt/9b6YcyO/GkxA5/uLBBRvy2/xAlhfDYpaXJAG8OSPBEaJQ/TGo
	oLs0liKGaZjfBlTrtHZ+g9lVTSWFlNpSCX02R//qFnAuUtRehr19BkkhJabKfPWK8F+Iyb050og
	QG3xj9UN40NxyxJBxZbI+iKwgoDNB3jQqV3OHWYSQB3ufrDmj/lzhZcq1zI35t2i+dOn3Nyz2xi
	17esFdLzmcM0xuHQh3vkUuJOyqyf8XlgtCZcVaDLtWj74dfnMpY6UKTr+IE2xv2xs0mTfyMxk+W
	j3ysJumSaGwbyS7nF5uHWDWscd7oqF92Hxn0BroGc6QHVCfmNk2bazeDaUdE4kyvXBfOeG1va3K
	2AcsHUEUrudU/kcMeqpEh/Jdm/gPM+WAfag4pLXhAqAJ/N0oBPAP0FQbyf7skchBLimwuKTUmHj
	ra7HwLiUK08uHwMZaeaPk=
X-Google-Smtp-Source: AGHT+IEbT+2c9fUYGpfZP0URl7Gt/aBbWW1x3GT8+zF4zksuc2BgrtHFAIMB1hd1CMW/+ncpXmbzQA==
X-Received: by 2002:a05:6870:1490:b0:3d3:10a4:c6e4 with SMTP id 586e51a60fabf-3d7481a610bmr2512441fac.51.1761779817372;
        Wed, 29 Oct 2025 16:16:57 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:71::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3d1e3a62f09sm5209364fac.24.2025.10.29.16.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 16:16:57 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH v2 1/2] net: export netdev_get_by_index_lock()
Date: Wed, 29 Oct 2025 16:16:53 -0700
Message-ID: <20251029231654.1156874-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251029231654.1156874-1-dw@davidwei.uk>
References: <20251029231654.1156874-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Need to call netdev_get_by_index_lock() from io_uring/zcrx.c, but it is
currently private to net. Export the function in linux/netdevice.h.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/netdevice.h | 1 +
 net/core/dev.c            | 1 +
 net/core/dev.h            | 1 -
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d1a687444b27..77c46a2823ec 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3401,6 +3401,7 @@ struct net_device *dev_get_by_index(struct net *net, int ifindex);
 struct net_device *__dev_get_by_index(struct net *net, int ifindex);
 struct net_device *netdev_get_by_index(struct net *net, int ifindex,
 				       netdevice_tracker *tracker, gfp_t gfp);
+struct net_device *netdev_get_by_index_lock(struct net *net, int ifindex);
 struct net_device *netdev_get_by_name(struct net *net, const char *name,
 				      netdevice_tracker *tracker, gfp_t gfp);
 struct net_device *netdev_get_by_flags_rcu(struct net *net, netdevice_tracker *tracker,
diff --git a/net/core/dev.c b/net/core/dev.c
index 2acfa44927da..7e4ef9a915f9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1089,6 +1089,7 @@ struct net_device *netdev_get_by_index_lock(struct net *net, int ifindex)
 
 	return __netdev_put_lock(dev, net);
 }
+EXPORT_SYMBOL(netdev_get_by_index_lock);
 
 struct net_device *
 netdev_get_by_index_lock_ops_compat(struct net *net, int ifindex)
diff --git a/net/core/dev.h b/net/core/dev.h
index 900880e8b5b4..df8a90fe89f8 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -29,7 +29,6 @@ struct napi_struct *
 netdev_napi_by_id_lock(struct net *net, unsigned int napi_id);
 struct net_device *dev_get_by_napi_id(unsigned int napi_id);
 
-struct net_device *netdev_get_by_index_lock(struct net *net, int ifindex);
 struct net_device *__netdev_put_lock(struct net_device *dev, struct net *net);
 struct net_device *
 netdev_xa_find_lock(struct net *net, struct net_device *dev,
-- 
2.47.3


