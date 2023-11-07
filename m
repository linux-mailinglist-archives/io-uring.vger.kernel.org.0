Return-Path: <io-uring+bounces-62-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E691B7E4AF3
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:42:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FEAA28143E
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F16392BCF0;
	Tue,  7 Nov 2023 21:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="T9ioqKuM"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E552B2EE
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:41:07 +0000 (UTC)
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E176B10E4
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:41:06 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1c9b7c234a7so56356395ad.3
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393266; x=1699998066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d9J1FEFzhrhikaZNta65SrTLG6ucsKYhta+WP1qgq5Y=;
        b=T9ioqKuM6X4kUSmM0Jbhyh9n+f7Qn7Gu7a2GeBpjhQT0JAIFiM+lSBoyTzJitWekfF
         4GnG4lPGVA2+9Jg7XFrkJB7Nc5qk2NZ5aQGeyZyVPUTwYrmmMIvVRV/96Uprpuc+kI9o
         9yqVOJt29jVI//CNlTQxysdadMA5UxqGt5Gsnd7AAHVPuik1HpV5nsCsl0Iqbc3caFYf
         B5yumalZuahX7oWinRiE7hq41Cw83sNTTy57wotCtd1Gn7CExVh14Su3BZCQVJDY7ogK
         Y/aKSvEauBVBhS8vIrQXipBTs1LxgSoNX3DL7TTryFXR+V3IqxvZqqoKz1aBnN0/QTI1
         gVoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393266; x=1699998066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d9J1FEFzhrhikaZNta65SrTLG6ucsKYhta+WP1qgq5Y=;
        b=axsQ47Axc3twr0Kby+OYgAdHFRsKk/Vv7rvi+jWj9I3DlefWNCxTpvYjAzlVHUWTv2
         qoRYg2c6nJkCmIGk+B2C+xVB+4wnohGKpZMwrggjMYOb1lWNF6MUb10wPswe63DKbhjQ
         aGv5eiBfD7h5POrBss9vKsW6HjvELqNO56le0Gu6JLoOeftjnxiDZvMU3G8zmhblzWEJ
         kar9eMBKErp+oHoLo2sY112jWYQE1a16fppeXvISFf8upwCKd2wC6yBXBYZKtLwN8df8
         aozJzVEgygiZJf6cXWCyPBwUDGso12auB1a6Z4yUOzhpF6cI5/fjMGUxuKDgoa0y9L0A
         DvhA==
X-Gm-Message-State: AOJu0YzIfeZEZMDWEQ6bm16ZSML3MaX+fdLnc8Ne6LeSfiudGuFTUYb/
	/M6sIKrJhD/jxgNTIN1JvrMkKLycYo81YUQoPNfW/g==
X-Google-Smtp-Source: AGHT+IEOXch3zKD+qAyCHDnaLeYtThJTFT4ZKIiazXb5IXi2lINxPtMnVCw9yz/JkYptgvDn6gPBaA==
X-Received: by 2002:a17:903:1252:b0:1cc:6597:f40b with SMTP id u18-20020a170903125200b001cc6597f40bmr232616plh.36.1699393266238;
        Tue, 07 Nov 2023 13:41:06 -0800 (PST)
Received: from localhost (fwdproxy-prn-120.fbsv.net. [2a03:2880:ff:78::face:b00c])
        by smtp.gmail.com with ESMTPSA id q13-20020a17090311cd00b001b016313b1dsm276284plh.86.2023.11.07.13.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:41:06 -0800 (PST)
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
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>
Subject: [PATCH 11/20] net: add data pool
Date: Tue,  7 Nov 2023 13:40:36 -0800
Message-Id: <20231107214045.2172393-12-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231107214045.2172393-1-dw@davidwei.uk>
References: <20231107214045.2172393-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a struct data_pool that holds both a page_pool and an ifq (by
extension, a ZC pool).

Each hardware Rx queue configured for ZC will have one data_pool, set in
its struct netdev_rx_queue. Payload hardware Rx queues are filled from
the ZC pool, while header Rx queues are filled from the page_pool as
normal.

Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/data_pool.h | 74 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100644 include/net/data_pool.h

diff --git a/include/net/data_pool.h b/include/net/data_pool.h
new file mode 100644
index 000000000000..bf2dff23724a
--- /dev/null
+++ b/include/net/data_pool.h
@@ -0,0 +1,74 @@
+#ifndef _DATA_POOL_H
+#define _DATA_POOL_H
+
+#include <linux/io_uring.h>
+#include <linux/io_uring_types.h>
+#include <linux/mm_types.h>
+#include <linux/netdevice.h>
+#include <net/page_pool/helpers.h>
+
+struct data_pool {
+	struct page_pool	*page_pool;
+	struct io_zc_rx_ifq	*zc_ifq;
+	struct ubuf_info	*zc_uarg;
+};
+
+static inline struct page *data_pool_alloc_page(struct data_pool *dp)
+{
+	if (dp->zc_ifq) {
+		struct io_zc_rx_buf *buf;
+
+		buf = io_zc_rx_get_buf(dp->zc_ifq);
+		if (!buf)
+			return NULL;
+		return buf->page;
+	} else {
+		return page_pool_dev_alloc_pages(dp->page_pool);
+	}
+}
+
+static inline void data_pool_fragment_page(struct data_pool *dp,
+					   struct page *page,
+					   unsigned long bias)
+{
+	if (dp->zc_ifq) {
+		struct io_zc_rx_buf *buf;
+
+		buf = io_zc_rx_buf_from_page(dp->zc_ifq, page);
+		atomic_set(&buf->refcount, bias);
+	} else {
+		page_pool_fragment_page(page, bias);
+	}
+}
+
+static inline void data_pool_put_page(struct data_pool *dp, struct page *page)
+{
+	if (dp->zc_ifq) {
+		struct io_zc_rx_buf *buf;
+
+		buf = io_zc_rx_buf_from_page(dp->zc_ifq, page);
+		if (!buf)
+			page_pool_recycle_direct(dp->page_pool, page);
+		else
+			io_zc_rx_put_buf(dp->zc_ifq, buf);
+	} else {
+		WARN_ON_ONCE(page->pp_magic != PP_SIGNATURE);
+
+		page_pool_recycle_direct(dp->page_pool, page);
+	}
+}
+
+static inline dma_addr_t data_pool_get_dma_addr(struct data_pool *dp,
+						struct page *page)
+{
+	if (dp->zc_ifq) {
+		struct io_zc_rx_buf *buf;
+
+		buf = io_zc_rx_buf_from_page(dp->zc_ifq, page);
+		return io_zc_rx_buf_dma(buf);
+	} else {
+		return page_pool_get_dma_addr(page);
+	}
+}
+
+#endif
-- 
2.39.3


