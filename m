Return-Path: <io-uring+bounces-300-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E3308191E2
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:04:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6DA028215E
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E3063AC01;
	Tue, 19 Dec 2023 21:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="089NnUHM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50673B793
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6d5c4cb8a4cso1856871b3a.3
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019846; x=1703624646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oy9uiiKwbsIgKaUJ3odB6F3vW7RFsVN49w7UGQoPJaI=;
        b=089NnUHMEUakuL6hga0Fo8qZzebYOmm7mMBnZfsWGRQ0DqlmgnDelkwSUHj8OIbR99
         BPcdYhfZ5ULvq46KjyRvfSIXs6vUOzJhVSX8CQMjmWyPqxYQRiwk5uIdR+9cTJGtexZm
         HDA7GZNzhteNZkT4NU6yyCDMxZmUvvqb2EWGKyE4Xg4MWiXSxCv+8C1suSseacLEjDpF
         NeXV1VBiLrfzgrVPeU1uv1kerIE40Tin8I4e5M46hZ8au+0botfKCi7kR3N//QBCWoWR
         0AMBPdj01lLnco1MKEw7NPqsbGb3i+1rQ70TablD0wwjMZjTqZf40k6ufu2G06TovMmv
         U1fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019846; x=1703624646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oy9uiiKwbsIgKaUJ3odB6F3vW7RFsVN49w7UGQoPJaI=;
        b=KVfTemdYzlpXEljrldoMNNwyB36Y320cU0FmvD3AHRM4OkuNwbz5wNJet2M540DIXs
         qbL1YgVlELl4Ug6jYa+TpnDGm9JzaJOf6UNRtuWmgUsnM/f6/1qFwgbbv0KN6IVimds4
         lznwOd9nj4JMnecGVtRpv6xbEtw5Ed65Lre0jyqOLVve18tROfI3Rv/butThjxyrIS8X
         ODz0+/zDhXVwzz8PLryhw3OLV1/O/FGk5uOsVSWX6S2J+hfiDv3mZMd0F6PPwpYrtpEZ
         f8qGUC+1qtgknEtjpehQ80vUMLWWH8FmqfzymbcClFRNyaNBqZ6TeDm9Z2VNka6vflwC
         0vPA==
X-Gm-Message-State: AOJu0YylIV13J0z6NTmHPU/wIJli/FUkU6zeXkmv459ND5kHrHyLO7sJ
	uPZd/FCDlOD56uf+j8sL0cgVtaf9HqA2PIRSDXg+zg==
X-Google-Smtp-Source: AGHT+IHVEYep/1woYWBS9dt/9XVd4k3yjoZczvwC+R6/pD8ybviMhpX1EJ68kXcXPjNNtknzMGKX6A==
X-Received: by 2002:a17:90b:19c6:b0:28b:49d7:e746 with SMTP id nm6-20020a17090b19c600b0028b49d7e746mr2598512pjb.65.1703019846088;
        Tue, 19 Dec 2023 13:04:06 -0800 (PST)
Received: from localhost (fwdproxy-prn-016.fbsv.net. [2a03:2880:ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090adb4c00b002867594de40sm2086062pjx.14.2023.12.19.13.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:05 -0800 (PST)
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
Subject: [RFC PATCH v3 01/20] net: page_pool: add ppiov mangling helper
Date: Tue, 19 Dec 2023 13:03:38 -0800
Message-Id: <20231219210357.4029713-2-dw@davidwei.uk>
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

NOT FOR UPSTREAM

The final version will depend on how ppiov looks like, but add a
convenience helper for now.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/helpers.h | 5 +++++
 net/core/page_pool.c            | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/page_pool/helpers.h b/include/net/page_pool/helpers.h
index 95f4d579cbc4..92804c499833 100644
--- a/include/net/page_pool/helpers.h
+++ b/include/net/page_pool/helpers.h
@@ -86,6 +86,11 @@ static inline u64 *page_pool_ethtool_stats_get(u64 *data, void *stats)
 
 /* page_pool_iov support */
 
+static inline struct page *page_pool_mangle_ppiov(struct page_pool_iov *ppiov)
+{
+	return (struct page *)((unsigned long)ppiov | PP_DEVMEM);
+}
+
 static inline struct dmabuf_genpool_chunk_owner *
 page_pool_iov_owner(const struct page_pool_iov *ppiov)
 {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index c0bc62ee77c6..38eff947f679 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -1074,7 +1074,7 @@ static struct page *mp_dmabuf_devmem_alloc_pages(struct page_pool *pool,
 	pool->pages_state_hold_cnt++;
 	trace_page_pool_state_hold(pool, (struct page *)ppiov,
 				   pool->pages_state_hold_cnt);
-	return (struct page *)((unsigned long)ppiov | PP_DEVMEM);
+	return page_pool_mangle_ppiov(ppiov);
 }
 
 static void mp_dmabuf_devmem_destroy(struct page_pool *pool)
-- 
2.39.3


