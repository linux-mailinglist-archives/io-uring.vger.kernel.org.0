Return-Path: <io-uring+bounces-5979-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BE50A153CE
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 17:11:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 685513A27D6
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 16:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B44119CC3E;
	Fri, 17 Jan 2025 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LzhSQYa+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91211199EAF;
	Fri, 17 Jan 2025 16:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737130283; cv=none; b=jQhv1DadBSZrgX4OxwaDa1tWRwu5htyoYGeZjsO+sdHKax4T4vHhNqVe07/7wAj62ohBy6xgZgpbQmNfbkW6Z1eVAAQx91t5v/VYDlSYavgqFx/5+2eif9um/HVhVoexNpNhasCxsFgJrw9NqSADgKmJfRUsYXEj7HvoleFKDUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737130283; c=relaxed/simple;
	bh=bA3pAcJfLjwZfSQNCnlsBmesxFX9eRKBrhTwj0Xnaso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WL0cr+tOcS1Pcyn5+/hj/A33B86n1p70n5FKKKUUCtAmME+YEh+EJL7MV4YVMt4Uybf68yDWrHnqUnZNQgoKM8bglnsbYiMQoGY9GLaFeTavAPWvpQFcv/ZAJfSPj96yOmb9tFT3I/3Wjct/51w6UjRf3J3dSIymOtl/8+RNzsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LzhSQYa+; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ab322ecd75dso411019366b.0;
        Fri, 17 Jan 2025 08:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737130280; x=1737735080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MBLDh/CsE/QEymQb9xLVicBSkf/Bpc1RfWbzcmd0aio=;
        b=LzhSQYa+z37Qx8ultJB0h3toQX1VZO5CKKOsOgMY/nAxvhThUgQ8/r/KYEq1vBoxX6
         /EBi9H6lP2VXkgdgJ3JDRBW4WtvNHaMJom94OfGrIJR+0YFE9AT9vwWjNqXe8Qi5NSqI
         N9L5B8vsbt9k9TqqxZHt1HkWFFetssnJHQSyZ0CTzrHFRe5PpctCPuYc17qoo/h957jC
         GU2gQxSc15F1Ro1qHINSciDq7aEoRWlcagsI+FBspHrZ54vKJ/7i6psAnsyZ6IQpyGWs
         LsYMSnasK2hnsXbdgw+elViOkR0kbAxCv5+RbOzkGiuWPih7aZJ3+ktclTPe8Q4wnAE9
         S7hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737130280; x=1737735080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBLDh/CsE/QEymQb9xLVicBSkf/Bpc1RfWbzcmd0aio=;
        b=FHJl+dRy90xCHxbIt51DJ0Iez4uhBZphEUe8M68LMZKlOnbssBdtAUj7pMesqh8Yoj
         JAwzGo1Gd+XzRF7brlxp0Ikf3UaM7ZThUYLvZgzz76SLwFs7zOJbKxH9rq9ijUyCePrk
         7y5G20Orn+h2FAc6Bn0TKN2Xa5Wf8QktAXiEgZVCqke+zSkG38mloDD+R8VPnOQl0zBi
         e7HcwQScgPM7dbJUoOWBmJP43vCO04vzUOENmAbsSCqEBwAQkzznZv7WS43NjFBaksH3
         OCF4mpBLx40iI33uGHBQmlHU+EkvDyt8BBth++MoeE45pxsSL07tlV7h5P6CDuGutwmw
         ui8A==
X-Forwarded-Encrypted: i=1; AJvYcCUxGBDaspoJDW7iECKV2kkSxreaVfLoe3LYjKo9UE82az1GsJOF3QMv3ja/sxbhnWG8J4q5DMY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm81h5Ca7TkNq+bpIGiKcrMSlY5y/qH9soxvuptvJ1msH6KH1n
	UVRdpEAT3lhogePktPmZXisnwD0hWbpX72dvojLWjeR3JMlouR+5Pf2TLw==
X-Gm-Gg: ASbGncvfrSUbkq12jSWD3Er+cPFYjzQTS8ZNaH4OlOLg21ZU+/MjM4CRhE1fJB2qSF9
	GMDPJe8YlSYp3e4zIRrpggK0a4UjrXnqZUT1bVTj+rYnSsepSVZES2wG9oW7i3Q7RpqeePf045H
	FMJNeF1CxIbpzighBx5w7AUOIks/m3sIdPEVyT5hdyqRuab7xaR6RUNovJa9nmiL7KOtJaT0HOg
	E9RX5QmiNEP95bE4x50KlNqBM6sUfS0Mem7321f
X-Google-Smtp-Source: AGHT+IHn5v5/fshGqaQRY9t4rwSrPaD8MkGBdbX5oXbFwvx0sptPKtInAfZu2CFnJIAE62vA3NoyYQ==
X-Received: by 2002:a17:907:268a:b0:aa6:938a:3c40 with SMTP id a640c23a62f3a-ab36e479602mr766171766b.24.1737130277959;
        Fri, 17 Jan 2025 08:11:17 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:56de])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f23007sm193716366b.96.2025.01.17.08.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 08:11:17 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	David Wei <dw@davidwei.uk>
Subject: [PATCH net-next v12 01/10] net: page_pool: don't cast mp param to devmem
Date: Fri, 17 Jan 2025 16:11:39 +0000
Message-ID: <b491138e65fa878f27a80cc989a769b75315ec9c.1737129699.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1737129699.git.asml.silence@gmail.com>
References: <cover.1737129699.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

page_pool_check_memory_provider() is a generic path and shouldn't assume
anything about the actual type of the memory provider argument. It's
fine while devmem is the only provider, but cast away the devmem
specific binding types to avoid confusion.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
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
2.47.1


