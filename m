Return-Path: <io-uring+bounces-10860-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A29A6C95657
	for <lists+io-uring@lfdr.de>; Mon, 01 Dec 2025 00:35:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 99C7B3406DD
	for <lists+io-uring@lfdr.de>; Sun, 30 Nov 2025 23:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CD182FF16D;
	Sun, 30 Nov 2025 23:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S+se13Sj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9FA2FE566
	for <io-uring@vger.kernel.org>; Sun, 30 Nov 2025 23:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764545736; cv=none; b=h/XmSnsN5Q1vNeDctjmaUymAr1tA7ZKSnO4NO4k/HbuqCrBnhpyLMxHK9VodLMRjgJQBssmTiAF1im2kefkuREGR/UsJ/oGrgNWapCP+6h8/eF/cUbbnAGrb4YqvSuI0dwofv0Qcme7D5nRYQZrxIrvIC15hDVKsAg0a6X7Mshg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764545736; c=relaxed/simple;
	bh=J+v78DVUuvU5F3kifckIxv2vG5fH2TZFf9LLLr3M6jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXH5ZPBdp9s6p/1D5vBGc+A9GaJokpo+jmHDu//bnvGFdMqx3w8MDm4WWe4i+J5dLOdEOhRRUyEjczKKjjkIp/QY2lJAr1j3O8Qr5YZejITycvySF1vSX2AiG8/lPg/WAgDQ4cs101QZf606IY2tecWGt9wpoavHIwxJs3DAOsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S+se13Sj; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-477a219db05so21292725e9.2
        for <io-uring@vger.kernel.org>; Sun, 30 Nov 2025 15:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764545733; x=1765150533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CGfI5v2bo8QpS6mN8gMlhUgE+Lz+xF251MkehL1RpaY=;
        b=S+se13SjkHj/Mp9LCNMSncllJh85+8gmEePKyT9QQ1FeU1NvA4/hKKHhtgxeY22vuA
         RezFwgh7Zx6Tvg0ocqgegG0eczuKVtH2u3dBoZV0GE86hPg6BOGNtEX4DHQJVlSHniIr
         rNaablOfsG333wImhegHcAcvHj+KnTDJiw0aFsWHNStAn6oXX50ViBNQ4iMAIgLqaxOM
         AhuwWCzFBZSgZJw14DjgVoa8icC/ZLgZAGsgAa4oZdx/vRpTJksBJWpriR1ABkAVL3Gx
         rwo7hR9F5GiAGeEJBhr/wqfzTqitjKfSqWIjJdL0iShISoRwma0XU4o0vdhkOkjnmJVK
         E37A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764545733; x=1765150533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CGfI5v2bo8QpS6mN8gMlhUgE+Lz+xF251MkehL1RpaY=;
        b=H2BBM/vmig1DEnrENXUKxJiz5fl1UP7hvEt5Agq+S0AX9J02IX16XlozZLYC7TB4Kh
         D3Qy6Q2SNiv7tDGtWSvbSwy73XODg3z8caWijpE1/QbelyspAFPQSpxP3n9qNvHX3UIm
         c27c7EfF/cFpqFrO5vyMwEmtGcKhDDLLH9SqNY734FUxLC3aV+hrVyUrYJsZyR+CSTX1
         s7o6RLKVXIQKQE10f0xHhdnuDpi8sKdGkPg8tkz7ohiSwDik4m3durRLnmv8fx+P2d/T
         E8P9qHAJSTbcN8HqOYroupiksgvw6JQuh5NTTnjIsAoSdkluZvRfKWElP4OVVttwFbS2
         3DhA==
X-Forwarded-Encrypted: i=1; AJvYcCVvoGR9RrhNLISCbRyFAn3kvzu+GU/PbUnG/0U9fdRt8jG5PFup8ol3vk+4/0qnSUGRrVE5j2svbA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQkaA4x3cwq1qrdQ84E/kA00iRanTU277CS0+0s7Es4ogNCFwE
	9azf/zqiVncz4BPfM2T+83i0CSZ7g2S8Ub9ZeqBfEltzt5auc5wS8C8V
X-Gm-Gg: ASbGnct+O+Q8mS51abQaO5tDC53OypYv0Pk1txB4VA6Ysd55q+PILhLGTdVj/rlMOMw
	h2k1SfiA78UOXj/bMHagOoOZH0EKvfu2PDQg1f4F2M5Ein5V2zwu1gLeuBvzBUbeBy7jR9yS5+p
	zjtA3hhz76lM+UQPxc/WJUp6hzpiuwhsg4AXDamBRSZTgbCmOr7eIJO2c/gLjdft3VlX30FBCXh
	rdvncREDhNA/D20AA6fPudntfngU/PLqM1/oFp9Z8CY+8MwdwWsFfarw9NMu3pnG6H1Q+W+jNJV
	cBa3dgK+88Gblh/c+Hvop5aQ9bOshnbd1RREz6AsKneKIewyt83Og1kORspan47iVEalZdZ7tbU
	/7Yi2v4tz0bmj/BIynFsCfM7SaItl2EIdgDNCf+OOgubZ7dUVdpeyK7/s4Ok/eEF0l/kXDfJ2BP
	WVI+Su+Yf5ySg3w/qRRdv8ObX2fcPn6yHFsrEbMyt99DMHE4Aa6D4idL8z/5xOj17e1GcHD1xFq
	zKjBnVdYTNalUYgp4BeF8MD4fY=
X-Google-Smtp-Source: AGHT+IF67CntAQ/arhcWo5ytqV99C28dV2Q49OsMgdQEXfIMhJP+Hcig8yH6oHJJ/T2ZRfd3/soE3A==
X-Received: by 2002:a05:600c:c490:b0:477:b734:8c41 with SMTP id 5b1f17b1804b1-477c10c8596mr322154935e9.1.1764545732812;
        Sun, 30 Nov 2025 15:35:32 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479040b3092sm142722075e9.1.2025.11.30.15.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 15:35:30 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Shuah Khan <shuah@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Yue Haibing <yuehaibing@huawei.com>,
	David Wei <dw@davidwei.uk>,
	Haiyue Wang <haiyuewa@163.com>,
	Jens Axboe <axboe@kernel.dk>,
	Joe Damato <jdamato@fastly.com>,
	Simon Horman <horms@kernel.org>,
	Vishwanath Seshagiri <vishs@fb.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	io-uring@vger.kernel.org,
	dtatulea@nvidia.com
Subject: [PATCH net-next v7 1/9] net: page pool: xa init with destroy on pp init
Date: Sun, 30 Nov 2025 23:35:16 +0000
Message-ID: <02904c6d83dbe5cc1c671106a5c97bd93ab31006.1764542851.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1764542851.git.asml.silence@gmail.com>
References: <cover.1764542851.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The free_ptr_ring label path initialises ->dma_mapped xarray but doesn't
destroy it in case of an error. That's not a real problem since init
itself doesn't do anything requiring destruction, but still match it
with xa_destroy() to silence warnings.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/page_pool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 1a5edec485f1..a085fd199ff0 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -307,6 +307,7 @@ static int page_pool_init(struct page_pool *pool,
 
 free_ptr_ring:
 	ptr_ring_cleanup(&pool->ring, NULL);
+	xa_destroy(&pool->dma_mapped);
 #ifdef CONFIG_PAGE_POOL_STATS
 	if (!pool->system)
 		free_percpu(pool->recycle_stats);
-- 
2.52.0


