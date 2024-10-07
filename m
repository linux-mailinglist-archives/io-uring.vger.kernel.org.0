Return-Path: <io-uring+bounces-3447-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E67399939F9
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 00:17:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACD6128368C
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 22:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D071A191F96;
	Mon,  7 Oct 2024 22:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="RWLWaOiv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D43118FDB7
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 22:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728339396; cv=none; b=LJoRH3w1ulrzJm2OhY0ZEnnR/Mo5UlO8SSLcQVWb9+WDC5ikiG3BLngSQANImz/xRfJqhPi+mM8NDUN17Muzz2ugxC4SExfzpeo+Moumq+uGaBY5iJZJSyL1fQbXIDlp0q4SqflOajdw6dzdn8r2eBnrZuPNe9y/E5nBi98RBWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728339396; c=relaxed/simple;
	bh=9WBfy/JyuSrDBn5Dv9c4MWarmPAF9vNMtpPK/13z3hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krF6TiuXeyyqleNjjTeCkba0dypvhPXBXeUVy8emOJR6UCMxr2heMG4v4yJxyxcIrGCQEZvlVxplY6Z7GymjabOA5zp52v2NOSRXBVoBmD04QX++qI2Hhv4A1KRixH1+O3PMnh3hAEtHhKZR1rvDjpCLrBjPC3LmWv4m59z15so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=RWLWaOiv; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-71e038f3835so1255276b3a.0
        for <io-uring@vger.kernel.org>; Mon, 07 Oct 2024 15:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728339395; x=1728944195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XVeL/qGFfpZ8R7diB0tLtQAmfPMkGjT+PyauVsiDpEk=;
        b=RWLWaOivLJHVDK4mU/7oMKCc/IVvLFBc2pGkmagQLxqByBb41VE5VX8hJaiyBV96/1
         nz6ZuGNOHRIWK7MjJRbPLDFKIKIb7N55EQt1sGbIGQAROcUGIvIf/QHX4sXtnCkopalB
         FTjDIbTM8Y85fBvHifO4AaG3h3/OxS3trPMsO9U4rQ3NNEjXpq5+92vX2CSCLKB8+w1F
         HHhFPBHaeOBisgLA2XtlISRgvqht1qVpet7OlJmDW/nfIOmQ6ifIbo+fIirtrLUJgw2c
         LcTX5w3+vQARWGweZUZuhBnTQqPKs6TUOTRIaUOUilNHXUSXsUs7RB5frYtu25fsWtRk
         kleg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728339395; x=1728944195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XVeL/qGFfpZ8R7diB0tLtQAmfPMkGjT+PyauVsiDpEk=;
        b=DISO84lSeW0TCqHJfM5+2Jdb3IJWZCLa008Mn9YjpE0vws+rp352sPQQu3HsLhItXP
         +fY7VrIbsRGW41kCASonC0L/2nv767vLP24oYctshOq+laO40NcaezFLH0VlC6daMfFM
         LPFmHZ/R7HiIAcT6bF9Z/IhPngT/aJI4LXLvJjoKrOLP2sqcIHLppoiO+q2nQE4TdWku
         gNzVNMAa5qT/k6WU5jRSsyzze9o2zqpKA+TL1FKC7presLK0MxxqYsix1OezPY/TszGo
         1TKHkxur+QqBx/cH1wKXxjagTrzUhoIp0GpNZxncOcxjwZYU5XPP1LGnL5G6d4ss77o2
         y0NA==
X-Gm-Message-State: AOJu0YzeqCZ2CcMeNROrUOon1K1k34V5p9rZPL3xqRvksOw1sktDkhyl
	9DzGQ+fw7Hc+Nz8xAqDTU9/zJzt34MCb6jcZGUoUzknYlIBHiD3vWoIksj/V2JKFhFLEmI/3l0s
	k
X-Google-Smtp-Source: AGHT+IHegCrN5QL0rZ0MnmFa7fPZpbWcgff4p9G4WYORD/nyz+of7AEWu5cNnyeTMRt+kHX9KhvLUQ==
X-Received: by 2002:a05:6a00:3c88:b0:71d:f423:e6d8 with SMTP id d2e1a72fcca58-71df423e9a1mr14912700b3a.6.1728339394670;
        Mon, 07 Oct 2024 15:16:34 -0700 (PDT)
Received: from localhost (fwdproxy-prn-001.fbsv.net. [2a03:2880:ff:1::face:b00c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0d66324sm5056841b3a.172.2024.10.07.15.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 15:16:34 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [PATCH v1 06/15] net: page_pool: add ->scrub mem provider callback
Date: Mon,  7 Oct 2024 15:15:54 -0700
Message-ID: <20241007221603.1703699-7-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241007221603.1703699-1-dw@davidwei.uk>
References: <20241007221603.1703699-1-dw@davidwei.uk>
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

todo: we'll try to get by without it before the final release

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/types.h | 1 +
 net/core/page_pool.c          | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index 8a35fe474adb..fd0376ad0d26 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -157,6 +157,7 @@ struct memory_provider_ops {
 	bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
 	int (*init)(struct page_pool *pool);
 	void (*destroy)(struct page_pool *pool);
+	void (*scrub)(struct page_pool *pool);
 };
 
 struct pp_memory_provider_params {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index c21c5b9edc68..9a675e16e6a4 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -1038,6 +1038,9 @@ static void page_pool_empty_alloc_cache_once(struct page_pool *pool)
 
 static void page_pool_scrub(struct page_pool *pool)
 {
+	if (pool->mp_ops && pool->mp_ops->scrub)
+		pool->mp_ops->scrub(pool);
+
 	page_pool_empty_alloc_cache_once(pool);
 	pool->destroy_cnt++;
 
-- 
2.43.5


