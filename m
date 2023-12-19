Return-Path: <io-uring+bounces-313-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADA228191FF
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:05:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF5801C2119A
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 955003A8EE;
	Tue, 19 Dec 2023 21:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="oux1MZOq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075C83C48B
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1d3ad3ad517so13782175ad.0
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019858; x=1703624658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+R3fraE1AUJLiBUl+irWqkEYdm8NtMUbP7MGr9N7dq0=;
        b=oux1MZOq0AzQgkcRmTCoj873Fn++FIU+nsu6uzWncnnZnBKhfjnsVhQmhuanI8ANrp
         441FQdX/PIBwqAwSTclUPmw51AHBolPPqVidjmbvYdV6jpbKyhLeOMAD2f+rb0XPFRXD
         1UF59ZJDEmS68G/aZQalCwtyuIb07xxrw3gaBQDCEMk6POItlGSjVr7inj5wFKxXH3En
         82J3w82CPGNwPSykYLF5NjH2kMYS9vBQhV8LsCPTez/TQ2wdqRHuF33hoG0Dp0qJp8NE
         UhOikBtYWJdeeZPiIuI6Cn0SDmXR5uEtFVBRFpUUepmYOQYQwJd7wSYsFnLCV0/qd1lv
         2Hfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019858; x=1703624658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+R3fraE1AUJLiBUl+irWqkEYdm8NtMUbP7MGr9N7dq0=;
        b=qV18tgA549bKsEVBc/qGQKVTrDf/pX0ZLfpuxRAAAnu8jk7UhaDJuLig+mONTqFklP
         kgmutE7v90KFjiq6+fx2kXVzj+b+oqEOykbH52xbesOakEse+tdMjT8AOb1nBwQKCnHn
         fWJwSXqSBre4nuI9SC7PI23oh+gQVVi9xtgsN2VJcu718BA3A30XcYLPEIA9CiOelXsq
         roQF832HZSCKnIibSRXzqdrtO6kliEE/yj/VMHWCF/zvspFuIQCTad0SMV7okfHPt9pZ
         YR5Tj8dNaVdyzkRAIuR7YUlNRe97M0jQNKQ4mmifo+gmYfYmA9smC6zBvzqyZFfPuCgQ
         /uwg==
X-Gm-Message-State: AOJu0YzUzKw9mTm/UR1AFqGfvL4iksRbj68olFNrLX+Nhf38OeQUDgkd
	elxbzNyY+okZpaMnacZjuqamNg4HfItvygz8LxIe6A==
X-Google-Smtp-Source: AGHT+IHv2Ih+zIMLBLTSl+oRkb/qmBFcX3CARWtV0GirJ8tYSwTCNeW0vzrX5FsoKxAiegCWCFM5LA==
X-Received: by 2002:a17:902:704c:b0:1d0:6ffd:ae22 with SMTP id h12-20020a170902704c00b001d06ffdae22mr9681493plt.137.1703019858245;
        Tue, 19 Dec 2023 13:04:18 -0800 (PST)
Received: from localhost (fwdproxy-prn-002.fbsv.net. [2a03:2880:ff:2::face:b00c])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902e80200b001acae9734c0sm4100365plg.266.2023.12.19.13.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:17 -0800 (PST)
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
Subject: [RFC PATCH v3 14/20] net: page pool: add io_uring memory provider
Date: Tue, 19 Dec 2023 13:03:51 -0800
Message-Id: <20231219210357.4029713-15-dw@davidwei.uk>
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

Allow creating a special io_uring pp memory providers, which will be for
implementing io_uring zerocopy receive.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/types.h | 1 +
 net/core/page_pool.c          | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index fd846cac9fb6..f54ee759e362 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -129,6 +129,7 @@ struct mem_provider;
 enum pp_memory_provider_type {
 	__PP_MP_NONE, /* Use system allocator directly */
 	PP_MP_DMABUF_DEVMEM, /* dmabuf devmem provider */
+	PP_MP_IOU_ZCRX, /* io_uring zerocopy receive provider */
 };
 
 struct pp_memory_provider_ops {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9e3073d61a97..ebf5ff009d9d 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -21,6 +21,7 @@
 #include <linux/ethtool.h>
 #include <linux/netdevice.h>
 #include <linux/genalloc.h>
+#include <linux/io_uring/net.h>
 
 #include <trace/events/page_pool.h>
 
@@ -242,6 +243,11 @@ static int page_pool_init(struct page_pool *pool,
 	case PP_MP_DMABUF_DEVMEM:
 		pool->mp_ops = &dmabuf_devmem_ops;
 		break;
+#if defined(CONFIG_IO_URING)
+	case PP_MP_IOU_ZCRX:
+		pool->mp_ops = &io_uring_pp_zc_ops;
+		break;
+#endif
 	default:
 		err = -EINVAL;
 		goto free_ptr_ring;
-- 
2.39.3


