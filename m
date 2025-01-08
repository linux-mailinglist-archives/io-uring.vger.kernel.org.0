Return-Path: <io-uring+bounces-5755-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B6EAEA067CE
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:07:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33B3418885D9
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 22:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35BDC2046A9;
	Wed,  8 Jan 2025 22:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="GJPHVQ7i"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5251202C4F
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 22:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736374027; cv=none; b=fPNOT4W5uZ3TfYhYYPrVnuXDZ8rfz/tHUaE1DsCKRrLzKdehKHOXvRiOT3vLbc3YWwNhRuRIe69maTJOIRFPPH5pXfuvfVx1PCiLcBfZXViZfOxb02MjxZI1aOmxU3FOrgAEKcbvXrgeFLC97vRDgIyHcht0QYsXljrIx7lge+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736374027; c=relaxed/simple;
	bh=VAoUMQEGqjLFxP/Xbi0jSPU2djzzUYFnXJh5BOeqN14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9jR4p0Vlkaqf3sDIJwDdxGTICACnNunwO3sn25hyI3q81FEAy3hfYive+mjjfpaC604CmlvNCidZcOcZ3FugRpqvVpJ1UzLatFjy/DTgPICeHoDGi6n30NR1IgVphnS+kQrPKYDEKCcuoJxOTw9DQH9Ds+6g6I7iWjPxfxaoiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=GJPHVQ7i; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-21669fd5c7cso3270005ad.3
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 14:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736374024; x=1736978824; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qtABS+dmyoe0kdyaoBin9gQ/i6vhks1kSLsluvXpY8o=;
        b=GJPHVQ7inCWfegO88IZpUo3aoT5KH4s8ZEgdc753YYwwzzEWt6WnlSGNw0Xp4IDtWP
         P37Zz4GIf/qLi3dFEeohaIRVx/SRNTTDE84LD6mqdkXe9ERGOEsvW/QcwnR6UczhtNia
         r3XGz83qXoeG2mISTDahcwrwapk3KNNHPZdleolvN7cwO1lml8HH1cun0YLStEtCshC8
         ahVkXdAKaAXJlkKnYmebk3+JZWN8pjumiWJOH6uOOdvS4zfhN8djdA7LymwktMsBiFfx
         vAwQuXUp7JvDjgQxGAGrRNBm+y10gQnXp73Wh3AmRPCAo2qnMRovmEFBZEJtX+BkDHYh
         9LRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736374024; x=1736978824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qtABS+dmyoe0kdyaoBin9gQ/i6vhks1kSLsluvXpY8o=;
        b=sssSH1+BnQ6TAJn3yCf/NqTU+9pMO5lRMS3g/4App9E4W8Hsit7PLIrWUMhDfDIY8h
         umXSrTmabz3xqGEuSGWo/zESwUlNm6+FN03QIaS4Yy7I25OtiZCJnQBO6Xe2k4fI6b+h
         kZfOCopzgU3qpqE9mlj48vF3FMfa/aa6YMFwdssuhsnR5xfLfa0T/YKiVLnJtCy4i+z8
         ND9Y3ZiYvK7i3QJusTGHr9SGKATN28w/02uCpV2pRYJ1xZY8r6mpJxlmAIUSVfUciUNP
         Ny62VLrpv3geqBklhIcaH8Kf8oOyp9HmavlVDLhUEB88RCiNS9BUIYhiJ6AOjcl16lFq
         +rNw==
X-Gm-Message-State: AOJu0YxxfrkOeuUFF9svrC2LXu5KPLXmHomgpqzMou7XjI3eOPotmLzY
	anJ3ea73ipSEedFzXfUHkqsNiv8IiPjxdK5D0oPGhNIO9r/S8Avaq+ryLsbu2veZdPjRNSEa/LP
	z
X-Gm-Gg: ASbGnctbv5/pzquAecXUeL9XSCHEELZzY+p61fMQK4fb3qDeXM6NBhiA0cH1pbE6pl7
	8yefsomda0e+jBNeBMWqkA8dSVlWQLC25QWLL/9VXcGkTy+vbWlQksnbsCJQyFjZFyI30mMbBsv
	QWcf17FVNM1a5daUGpkBIWFEnFvGXv9+4mSrFXARdDLBwxSgVDLH7djqL9WgRU+P6dxpczGeb5x
	OyimRtkjTna4dkHgQI83B9Vz0zefuOwSSvLwolM
X-Google-Smtp-Source: AGHT+IGDDgScB0l1nhJ5EZNjTq3i4T3SvpWHOaO5xF5nuTlOcFaaBYfOnCUs22uz9e2PIY798zrLKA==
X-Received: by 2002:a05:6a20:c88d:b0:1dc:e8d:c8f0 with SMTP id adf61e73a8af0-1e88d0bfd48mr8336038637.29.1736374024131;
        Wed, 08 Jan 2025 14:07:04 -0800 (PST)
Received: from localhost ([2a03:2880:ff:3::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8dbafesm36622053b3a.128.2025.01.08.14.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 14:07:03 -0800 (PST)
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
Subject: [PATCH net-next v10 01/22] net: make page_pool_ref_netmem work with net iovs
Date: Wed,  8 Jan 2025 14:06:22 -0800
Message-ID: <20250108220644.3528845-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250108220644.3528845-1-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

page_pool_ref_netmem() should work with either netmem representation, but
currently it casts to a page with netmem_to_page(), which will fail with
net iovs. Use netmem_get_pp_ref_count_ref() instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/helpers.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/page_pool/helpers.h b/include/net/page_pool/helpers.h
index 543f54fa3020..582a3d00cbe2 100644
--- a/include/net/page_pool/helpers.h
+++ b/include/net/page_pool/helpers.h
@@ -307,7 +307,7 @@ static inline long page_pool_unref_page(struct page *page, long nr)
 
 static inline void page_pool_ref_netmem(netmem_ref netmem)
 {
-	atomic_long_inc(&netmem_to_page(netmem)->pp_ref_count);
+	atomic_long_inc(netmem_get_pp_ref_count_ref(netmem));
 }
 
 static inline void page_pool_ref_page(struct page *page)
-- 
2.43.5


