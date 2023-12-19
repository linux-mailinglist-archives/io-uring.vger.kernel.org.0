Return-Path: <io-uring+bounces-304-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD13F8191EB
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:04:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CC701F23B03
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D6FC3D0AD;
	Tue, 19 Dec 2023 21:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="uKbjLRH0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10833A29B
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5c701bd9a3cso2265796a12.0
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019850; x=1703624650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zs+cSQCBJyAxSPUcytmGfDGwcvea+TXK48eVoO+ZZxM=;
        b=uKbjLRH01NjyMU7fK0zt3tZfcJ1pBEpXjlyqljltjkbg8k2/UGPp+mj3+dptL+Ij3C
         9SQrgGNo7SigjukR8AWHedc34Zn2w4yDbrM2T1ETDB9yHWAdjM4TnJqH8MS7ig6dLYLJ
         FmhGeDfcdkAw+Cq+aRdJDheg28Gg206Ttsf9BPY9DiOgc5so8AVRXpP4L0n8R/9oCVJ9
         y39bQdxVvpYbefpOEUaoCbhWc7BDlE5qhI91I66RX7YoRUlzUt8nj0T1WhUWCzwC2eSj
         CNkgeOgXlDiXBTaZOxunw//SA/gPe6QIwg+rzHHRJaCkJsGmNipVdSOYe3WE/ECWVFib
         ahgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019850; x=1703624650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zs+cSQCBJyAxSPUcytmGfDGwcvea+TXK48eVoO+ZZxM=;
        b=TMPmvtW8DKlBW41qMbIMRyV9WBYa/0UIfcNWzpjWkkeBsC7Uuf+6OkXHk5S/tVVi/f
         W3b/Kdju+ZfyLGwrGQQ10oaChlx51PkDS9pkee3IYUPGZ2gUA3e/eO6dhA67JqtTO41/
         9swAGA7hCSRkHM6ReEytaIMDlAa/2fP9O/0Iern9UkaPcdDLqNE9olPFkGt5bVXd+3OE
         SloKYehj4gAmzuGtY4K5XwQYycQuFa2bFVXVwZ8Ixq9/1c56Y2wHjRfxyiwwB8aVh1fX
         UFfriRZ2slAge5Hl6swRL0vlNPPUxLrgfhAGjWV6JMCsPVK8ARMdMYXeDZ/Wkwio64ip
         RwrA==
X-Gm-Message-State: AOJu0Yz2+zNOV3TTexzk8q1Y9wd6U7yyedqFblMI4oX/1b9jIKq2B7yU
	P6IrAUt6esBJUGwjFrOap6PSVeoi7teDQ0EhYJcNmQ==
X-Google-Smtp-Source: AGHT+IHjfDQaUz2sKAkFTiAhNVlx7Yd3lLWWRw8dr6FWMxhyPk+XlzUgXZXfLatLI87/PuyoBdiiAg==
X-Received: by 2002:a05:6a20:3ca3:b0:18b:ec94:deed with SMTP id b35-20020a056a203ca300b0018bec94deedmr9799295pzj.45.1703019849709;
        Tue, 19 Dec 2023 13:04:09 -0800 (PST)
Received: from localhost (fwdproxy-prn-002.fbsv.net. [2a03:2880:ff:2::face:b00c])
        by smtp.gmail.com with ESMTPSA id e9-20020a17090ab38900b0028b07d1f647sm2076812pjr.23.2023.12.19.13.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:09 -0800 (PST)
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
	Mina Almasry <almasrymina@google.com>
Subject: [RFC PATCH v3 05/20] net: page_pool: add ->scrub mem provider callback
Date: Tue, 19 Dec 2023 13:03:42 -0800
Message-Id: <20231219210357.4029713-6-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231219210357.4029713-1-dw@davidwei.uk>
References: <20231219210357.4029713-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

page pool is now waiting for all ppiovs to return before destroying
itself, and for that to happen the memory provider might need to push
some buffers, flush caches and so on.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/types.h | 1 +
 net/core/page_pool.c          | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index a701310b9811..fd846cac9fb6 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -134,6 +134,7 @@ enum pp_memory_provider_type {
 struct pp_memory_provider_ops {
 	int (*init)(struct page_pool *pool);
 	void (*destroy)(struct page_pool *pool);
+	void (*scrub)(struct page_pool *pool);
 	struct page *(*alloc_pages)(struct page_pool *pool, gfp_t gfp);
 	bool (*release_page)(struct page_pool *pool, struct page *page);
 };
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 71af9835638e..9e3073d61a97 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -947,6 +947,8 @@ static int page_pool_release(struct page_pool *pool)
 {
 	int inflight;
 
+	if (pool->mp_ops && pool->mp_ops->scrub)
+		pool->mp_ops->scrub(pool);
 	page_pool_scrub(pool);
 	inflight = page_pool_inflight(pool);
 	if (!inflight)
-- 
2.39.3


