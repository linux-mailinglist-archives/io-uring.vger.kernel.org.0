Return-Path: <io-uring+bounces-8999-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E75AFB29589
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:42:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2944F189A166
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A486225779;
	Sun, 17 Aug 2025 22:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CwJLwO3X"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D908B21D3E4
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470572; cv=none; b=Buml+BqExILY5m+p14b18QM2+CfFUlZ2ZCTeA1Jce3qAseBUIys5bcj+euyXQtmbHpWTfPlqzlK57w3pphubKgKI254PS1EQ3mkEnVsRWqZgN/QjayUENtTU95SszCb4V3Nv8gGdoABMPSWy+abtDwvkLwNFXIRFmJi5Ya8zNqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470572; c=relaxed/simple;
	bh=VubLGm1HnvkpErqYxZO1sjUXxs0d1a6qAuSHYib3nS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhCQ5AwQZeMOHAlsV++wcUffujZ1AzbV7BfheIrl7IXcBu1eQqk/k+2Uw7SWJLVeaoqmm0+70gJoIHp8kRSQK3Hbnlz9KgOjSGAGZM+DbzCkoALAn2eEh1TcZzYf0f5EgDDvMVbyzztT7j0cWLAoyelUG+0fxjfvZeofX0lSkvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CwJLwO3X; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45a25ce7978so5644325e9.3
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470569; x=1756075369; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PLtU2BnONoH8GrRkiRqWpYlIllvTcV370Qg7aJ7R/2g=;
        b=CwJLwO3XoXLFPztGaTUJZ0Wi7ZtD+8AP7Zd5zMTCfE0WZxxjlGUB9L9VQn80e30We8
         KWIW/DWwx0MCCY214dbbryQNVc0oD1TsSku2iVaR+3xZCefSxpaKQyN5shFj4x+SVz/c
         L8tMQKKmDhSZ3zRs6fbSPCAcv09/Yig3gSAOJQ9OgWvIavsWsIk7TJ21REFZAC59oqTQ
         qc3IfQw7Vhh62BEpiZnZwk6xYlLvfCKW8HtrySNxZHTqo+YIoLRugdpaOYOUt7Qw+fz2
         jT91bO+JfFqfgsxkmGPPc1av4mVA9TzLR1fXd+jUTF4PGHe8jG9bQG7L+ZWSQ1OKtoFo
         Mn4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470569; x=1756075369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PLtU2BnONoH8GrRkiRqWpYlIllvTcV370Qg7aJ7R/2g=;
        b=UuKysXzzyMlGweLEuqjTFoReCVpAScpT9GDrR0QOcDWnGKBA4uIjGltJtg0zXHpAvq
         OxzGeWZEfG24WU6sldgOkPQ0NO14OeIUNyqZIy5C1HMjIEJTpTdztgO3nBQ4tP+waukd
         AbDfAgtByFyhq372u5gp3iEW9Hxbwxj4WO9GQEx6zXv720CWIHO/zOwjcLyiuq0pp+xH
         SAaW4bWGXPJR2KBMiirgroWP59UyHBwQLvNvjEvspL8JIk9MaCnLJq6iFk6bBM7cNiSE
         DRSmS/IsXh7mRLVMHLv9GkRoszwFJNvDQ7Af8/4khqxmRJ6N4mR/0AkHknlTqsBtrUHP
         T0Dg==
X-Gm-Message-State: AOJu0Yy0p3Pz+SWlqQJ7GVHfBAXyVApsWxHl11ImL9qaQU0EvzdyfbWz
	2RgkE5XjEHlx6YhzItW1xxOiUYwj/yvEhhmLox/TI4LB8GipKsrcosXt5dXCcw==
X-Gm-Gg: ASbGncuH4jIz/p9mqjYP68g7NxfWUrr7b5uJOUhzclxhr1g/2olHcImJg+fwzG5w9Gn
	V92KyL21ZVG5a62qCSKycLc6P28ZYSOiY06+hY8+yif6bGHPBZ4ltXZ3hGES3zXZcZSBd4qHOwO
	NxsfmXbAJE+M6AeTO4SqG+lv36nrpJT7xMqvozI0pJ5ksKzZ6cKucGw51aYrDgrVnCMEnyJ9iFA
	xHmcIGMghL2HmKqEH56Q+Poyr1iZqH4rdyBIEJGo8oUL3tgt3U7mkNe973mD9AkA3/3SHjjljR7
	VmvzD/bjsXaFYRNUS2KDhv6AbBmyLQsuREAvke/g7tyaIbZdBFs3okfowdp2lv+Ed5RX7iM2nvC
	+Mt1lsIillAHlsAAyMnHdehm5U5k7g1hmpQ==
X-Google-Smtp-Source: AGHT+IGrNWUCHLSHKgoskJPZD0ZDnixy+/RFw+fJ4r9tUw22wrKlToCMXS2LzHsenZRIebdTDhbDhw==
X-Received: by 2002:a05:600c:19d3:b0:458:c002:6888 with SMTP id 5b1f17b1804b1-45a218637a8mr64037335e9.32.1755470568719;
        Sun, 17 Aug 2025 15:42:48 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2231f7e8sm112001565e9.14.2025.08.17.15.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:42:47 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 09/10] io_uring/zcrx: don't adjust free cache space
Date: Sun, 17 Aug 2025 23:43:35 +0100
Message-ID: <2e8ca8531eb664a4ae36082754ad93634f57431f.1755467432.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755467432.git.asml.silence@gmail.com>
References: <cover.1755467432.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The cache should be empty when io_pp_zc_alloc_netmems() is called,
that's promised by page pool and further checked, so there is no need to
recalculate the available space in io_zcrx_ring_refill().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a235ef2f852a..6d6b09b932d2 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -739,7 +739,7 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 	guard(spinlock_bh)(&ifq->rq_lock);
 
 	entries = io_zcrx_rqring_entries(ifq);
-	entries = min_t(unsigned, entries, PP_ALLOC_CACHE_REFILL - pp->alloc.count);
+	entries = min_t(unsigned, entries, PP_ALLOC_CACHE_REFILL);
 	if (unlikely(!entries))
 		return;
 
-- 
2.49.0


