Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D17F978921D
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 00:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjHYW4p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 18:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjHYW4O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 18:56:14 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9891D199F
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:12 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-7923483bb68so50172539f.3
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1693004172; x=1693608972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f+GIQ4i5ByNuKwYrRpt0EIU7cHtWJOixaax1XVLnBrM=;
        b=AmaWnMsV+9KbMhRjYIdPNb0DB4vWadGknaAYTmIQ9/rpIyh3VFL4DovERIjRF36Zj0
         5bC9U7ePzbYpIlBNzpKndR8SH2E0FuqutABzNzdGcovFRzmjSRtPspOEyxCM0aePCIs7
         Sug+9bBKgXWZqFXXqZpDSzXc9veS42drqyv2vLG2xm0wUdfhra3zN3XLFkrDeFczKHgU
         rTlNEzaOFp6ko7jZi6C99p1SMsDmQJV2zSgNIBJcTjWlThL0jkdtxmwJvU9lMkKm9UVT
         zqnCZFd5QHu+/LIdhmrnFQW8OKTa3nWpFjNsFEDZudH01x3UF2705+WF5bkX3hoDbWok
         HXBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693004172; x=1693608972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f+GIQ4i5ByNuKwYrRpt0EIU7cHtWJOixaax1XVLnBrM=;
        b=eMkIo1nQAWUoaNLMuH0GH7J3hoEq659wcs4launBNWdmvFInvQh+M03HpaVpEycq0r
         eYBfBl6vMEMZB+6QuDGjfWsINjt9esv3lyao0DhP0wvlOqAZN/wJgL5h13EHqifbf94v
         KiLR4uNB1nJgk2Ng2IHsxq+j0rI6QZY28NkWjmFh2DfJVpkp6sgK/X16Ur/Dl3fL6YPM
         aszhGWkzSuCw2gQB8nGA30ikOad9rPrwhlmKlSRnQL9xH+n0JrxPgwcoWq0T0x8n4RfJ
         otRcIM5zeh98SSaWNwhc+z4R/mg/NmPg5/pcWwMEsinFynKiMfMu2ajFw0T4bxWSRLN0
         xTvw==
X-Gm-Message-State: AOJu0YwFtBhf5VQUxa+Vz90YUJsey9/uCy/IOyQyME6rGIYDH8Jvf0bS
        9dsa/CvtBQotXJgrUiBYeXEC/iiVZRIoqekJqSHB/w==
X-Google-Smtp-Source: AGHT+IGpvWAfrK0facOjoagwGnhgqQZXTMb61hsDP0pg8x+84G76jg4Mw1+nYgaNb2asY883nIRN+A==
X-Received: by 2002:a05:6e02:1568:b0:34b:ae46:803d with SMTP id k8-20020a056e02156800b0034bae46803dmr11857949ilu.4.1693004171964;
        Fri, 25 Aug 2023 15:56:11 -0700 (PDT)
Received: from localhost (fwdproxy-prn-011.fbsv.net. [2a03:2880:ff:b::face:b00c])
        by smtp.gmail.com with ESMTPSA id bt27-20020a63291b000000b0056b920051b3sm2212333pgb.7.2023.08.25.15.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 15:56:11 -0700 (PDT)
From:   David Wei <dw@davidwei.uk>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 09/11] io_uring: delay ZC pool destruction
Date:   Fri, 25 Aug 2023 15:55:48 -0700
Message-Id: <20230825225550.957014-10-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230825225550.957014-1-dw@davidwei.uk>
References: <20230825225550.957014-1-dw@davidwei.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: David Wei <davidhwei@meta.com>

At a point in time, a ZC buf may be in:

* RX queue
* Socket
* One of the ifq ringbufs
* Userspace

The ZC pool region and the pool itself cannot be destroyed until all
bufs have been returned.

This patch changes the ZC pool destruction to be delayed work, waiting
for up to 10 seconds for bufs to be returned before unconditionally
destroying the pool.

Signed-off-by: David Wei <davidhwei@meta.com>
Co-developed-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 io_uring/zc_rx.c | 50 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 44 insertions(+), 6 deletions(-)

diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index b8dd699e2777..70e39f851e47 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -28,6 +28,10 @@ struct io_zc_rx_pool {
 	u32			cache_count;
 	u32			cache[POOL_CACHE_SIZE];
 
+	/* delayed destruction */
+	unsigned long		delay_end;
+	struct delayed_work	destroy_work;
+
 	/* freelist */
 	spinlock_t		freelist_lock;
 	u32			free_count;
@@ -222,20 +226,56 @@ int io_zc_rx_create_pool(struct io_ring_ctx *ctx,
 	return ret;
 }
 
-static void io_zc_rx_destroy_pool(struct io_zc_rx_pool *pool)
+static void io_zc_rx_destroy_ifq(struct io_zc_rx_ifq *ifq)
+{
+	if (ifq->dev)
+		dev_put(ifq->dev);
+	io_free_rbuf_ring(ifq);
+	kfree(ifq);
+}
+
+static void io_zc_rx_destroy_pool_work(struct work_struct *work)
 {
+	struct io_zc_rx_pool *pool = container_of(
+			to_delayed_work(work), struct io_zc_rx_pool, destroy_work);
 	struct device *dev = netdev2dev(pool->ifq->dev);
 	struct io_zc_rx_buf *buf;
+	int i, refc, count;
 
-	for (int i = 0; i < pool->nr_pages; i++) {
+	for (i = 0; i < pool->nr_pages; i++) {
 		buf = &pool->bufs[i];
+		refc = atomic_read(&buf->refcount) & IO_ZC_RX_KREF_MASK;
+		if (refc) {
+			if (time_before(jiffies, pool->delay_end)) {
+				schedule_delayed_work(&pool->destroy_work, HZ);
+				return;
+			}
+			count++;
+		}
+	}
+
+	if (count)
+		pr_debug("freeing pool with %d/%d outstanding pages\n",
+			 count, pool->nr_pages);
 
+
+	for (i = 0; i < pool->nr_pages; i++) {
+		buf = &pool->bufs[i];
 		io_zc_rx_unmap_buf(dev, buf);
 	}
+
+	io_zc_rx_destroy_ifq(pool->ifq);
 	kvfree(pool->bufs);
 	kvfree(pool);
 }
 
+static void io_zc_rx_destroy_pool(struct io_zc_rx_pool *pool)
+{
+	pool->delay_end = jiffies + HZ * 10;
+	INIT_DELAYED_WORK(&pool->destroy_work, io_zc_rx_destroy_pool_work);
+	schedule_delayed_work(&pool->destroy_work, 0);
+}
+
 static struct io_zc_rx_ifq *io_zc_rx_ifq_alloc(struct io_ring_ctx *ctx)
 {
 	struct io_zc_rx_ifq *ifq;
@@ -256,10 +296,8 @@ static void io_zc_rx_ifq_free(struct io_zc_rx_ifq *ifq)
 		io_close_zc_rxq(ifq);
 	if (ifq->pool)
 		io_zc_rx_destroy_pool(ifq->pool);
-	if (ifq->dev)
-		dev_put(ifq->dev);
-	io_free_rbuf_ring(ifq);
-	kfree(ifq);
+	else
+		io_zc_rx_destroy_ifq(ifq);
 }
 
 int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
-- 
2.39.3

