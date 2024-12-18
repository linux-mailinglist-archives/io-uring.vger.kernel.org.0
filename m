Return-Path: <io-uring+bounces-5539-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2F2C9F5BAC
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:38:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09552161A60
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B391D555;
	Wed, 18 Dec 2024 00:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="AusVc5nf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78494FC0E
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482277; cv=none; b=E6SS/AhBKmiaJPeYD6TMxoTY4EB6Xb6slH0nlN2qr1emIsG8k7MJc/5Tsz8cU8HRKxyrwIgpueusABYVdL6kiH1/Lq+1RL19ZMX2Lv5UbutbbXIAOmQ0qGORGQpDefzayQCXWwmJ7HBjJHhm2licHrzpkH66iI2N6dIX97/91rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482277; c=relaxed/simple;
	bh=CztbvP9+RIyhpbrNQZVgPuMnd7qkzCOzRjukEnHDodc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6FiiALZ3hwoMalnWX9JvKY/YZWcFro2VOr4yDrwIXlmzbSuPFE32fw+7AoSl+V1Rjq5H99znjh6lwJodpOkUalQh9k8JdkmhFy7pX0J8g20XhCLQ7ZV9FBwjsSL3k0RGHyFwNk5WEJeAUtZPZUKSFIPlPaLvw0BQ04THYiG4bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=AusVc5nf; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-725ef0397aeso5281056b3a.2
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482276; x=1735087076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3FmBtD/9kNoCPyeDOsGVnpCJKDKHQdivfmWBaZAFy/E=;
        b=AusVc5nfBufnLs22EbWfq+U9VvthWkO3tB3yNSQWJrZc/0bhQNh+95bZ4VquKw7KXH
         jwBU12DR3nFfF6SABvf5VYMDl0usCTDmQ9gxyYKjIHLi0ZYSfsNOa4mwfPEYmjVnkofu
         JiHbsEjg36DZVqIG7hBvgJfWvRbjUYHVFZ1fnCMr49UGIfgwvWa4ZycVA5J19oPtPkuH
         DJJEDzcmW1CJKWi8P1cl7g49JKg0aQ8AR9piBrwTG4nwCOn4U3nh8Ppt9E6xlVC/MJf5
         t33HFxFk22+v13iO2Sgo602mxlYuMMgivLV7nnEudoIqjsh0ff2oaNqeIGSKyw0igiHN
         HLwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482276; x=1735087076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3FmBtD/9kNoCPyeDOsGVnpCJKDKHQdivfmWBaZAFy/E=;
        b=rBDYcpNlHQ2CfsxeQIZzpehah9GecnF9U4Wyx2CFJV0vk/83pxjbPyiYSZmn+RmEOZ
         2HX9W+8DsGaWXZUWu6ley8yNK7WvsNChS5916eKA9wHzR2XVSeYvMZ7vJM1pBf/MFam8
         oaOIRQggrcRM8fuJUlPWQBGL2CQDswDpEARO7WK2itHJALs4umS5XLa1ih99ubJHP4jv
         FiuzLxLDXWYB5G3d0i5owAKIMpqa+IdZCtUhQZcLKxxxj5hl4qv94tDqB/UDJnUy3WZh
         NRzy4xx9xg4yB400qWMNj9d4VojyN8VmPzCnGgieloX5Cz3+C1Lj3q6IHmL6xoSZ19v2
         WcCg==
X-Gm-Message-State: AOJu0YwyC2prtpUIGXaoIyXsmVQBll+/njqrpAwrmJhj2W0d1fTvfsHg
	RSVC/Pz34e6u6jTlPb4uQ0vbWDekwXSaeA17banYaNRTeYsJrcM0FkwZxy1cY7hjtxVRJvKReWr
	I
X-Gm-Gg: ASbGncsMP0PJ42Zkn7qyq+zKE0PXUK/klNwNwGwBt+RgOJ+dvRRhJf8Ns98LeL/7kiA
	Qgmn9PZqfs0uktmrn2KaGO1zZKZjsJSt/qCgl3dl9F0Mb1kP4g3JTv/coRCNAyiWmdWrUX58qvy
	DpLqwuWEvYm4GuHoqrF3ao6tKrvJkk29jjYL2Jedvjp4/8vjej1OYnEuGBfmxnrHyXY1O+RMDNl
	hZIc3JGf5wTwwzlplMUA/wh+0MQwqqpNyyhCoZh
X-Google-Smtp-Source: AGHT+IEQ/e/f05KYvugRA8kF98/vSc9zeC46GuK5+HSz3OGGkvguKsaBFClQoh/UbEHWew5KD3fsmg==
X-Received: by 2002:a05:6a00:4f87:b0:725:e1de:c0bf with SMTP id d2e1a72fcca58-72a8d2377b1mr1351050b3a.9.1734482275820;
        Tue, 17 Dec 2024 16:37:55 -0800 (PST)
Received: from localhost ([2a03:2880:ff:d::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-801d5aa9633sm6338924a12.21.2024.12.17.16.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:37:55 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v9 01/20] net: page_pool: don't cast mp param to devmem
Date: Tue, 17 Dec 2024 16:37:27 -0800
Message-ID: <20241218003748.796939-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241218003748.796939-1-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

page_pool_check_memory_provider() is a generic path and shouldn't assume
anything about the actual type of the memory provider argument. It's
fine while devmem is the only provider, but cast away the devmem
specific binding types to avoid confusion.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 net/core/page_pool_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
index 48335766c1bf..8d31c71bea1a 100644
--- a/net/core/page_pool_user.c
+++ b/net/core/page_pool_user.c
@@ -353,7 +353,7 @@ void page_pool_unlist(struct page_pool *pool)
 int page_pool_check_memory_provider(struct net_device *dev,
 				    struct netdev_rx_queue *rxq)
 {
-	struct net_devmem_dmabuf_binding *binding = rxq->mp_params.mp_priv;
+	void *binding = rxq->mp_params.mp_priv;
 	struct page_pool *pool;
 	struct hlist_node *n;
 
-- 
2.43.5


