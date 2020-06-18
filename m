Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E6D1FF549
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 16:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730886AbgFROq1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 10:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730927AbgFROoC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 10:44:02 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BB5C061794
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:44:02 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ne5so2633285pjb.5
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=AMBC//GM9TUmKqc/Ee7MUTX4MVxXaivvBIm8XTKWtjI=;
        b=XjGUImD9rS9VeH3ATYR5UN46KsG/kGd5i8ObOVULAJ3bWbAHLUKz+Nt/bzRQeCC7k+
         q4pmWPc7rGRsnlJnmLarBBAj7QbxKCn+OtJBti2v/itk1DKcuvDFfV26CpsOgPwwVj46
         oKdSZT+E6O3bgsFXk2UysYjSDRy6zj4yUK78Rv1eqtIwgcAQ5nn/tpiH68Y8GD4/iHUw
         3O1/2ihPs06whdoc10VZDpvDnnO0QVgM3L+4vMq/X6KTuGPCEjHx9ydMZTrOPjVK9Bkv
         Qkf+MhMg3TkdzkCd8QX51qCa7+tmj/0j1O1H3Kj4Zv1sGjsxfa6mxtY9/zGOSIjiER3+
         piRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=AMBC//GM9TUmKqc/Ee7MUTX4MVxXaivvBIm8XTKWtjI=;
        b=cLtzlrK+pgbQeYv/F2FuhLPgq+SG5E5ylZGpYfDcrUN/abBN96v3v1n6glQgja0sQT
         9buL5NhiOaWQcKnJzhpJlnzP6sClEHUVm66M89Gq72FhEzxbV6yCV6/Tdt68esT9q+HT
         UwKiFAqdkFhkGL9ElfTI6uzUuiX+/MSFLyCiyZMiVwA50/Zq0NoFv0Z3vvuN32/k2Vok
         0JddVCybY6eJtFWK9G+gxsIJ4bkShPZ3uifL7I57x99545SToG/xxZtSWJ+Ikob/C9Gc
         fC4kmNiuLy2i8YNWEB70cZBgm39cxGJ00ge+HirsXjRBiU+Z7SqTce0ShWifddn4nKUx
         ax/w==
X-Gm-Message-State: AOAM531y6/vG2YMSrrZS4/3LWQ+RDU9lB/HMxsD/aRDd0D6ZhoxR3gWl
        lWSmxY5IwnwtUNjZLxbEAs7YDhspFruy6w==
X-Google-Smtp-Source: ABdhPJxPg9RpVdrGQ4Z6ww3Iq/Db4vGVv54cHwt8FNsBk1NOsUw3hrbUnoL/Xc/AmyjDRE+S7btjoQ==
X-Received: by 2002:a17:90b:3004:: with SMTP id hg4mr5050010pjb.208.1592491440947;
        Thu, 18 Jun 2020 07:44:00 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g9sm3127197pfm.151.2020.06.18.07.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 07:44:00 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/15] block: provide plug based way of signaling forced no-wait semantics
Date:   Thu, 18 Jun 2020 08:43:41 -0600
Message-Id: <20200618144355.17324-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200618144355.17324-1-axboe@kernel.dk>
References: <20200618144355.17324-1-axboe@kernel.dk>
Reply-To: "[PATCHSET v7 0/15]"@vger.kernel.org, Add@vger.kernel.org,
          support@vger.kernel.org, for@vger.kernel.org,
          async@vger.kernel.org, buffered@vger.kernel.org,
          reads@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Provide a way for the caller to specify that IO should be marked
with REQ_NOWAIT to avoid blocking on allocation.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c       | 6 ++++++
 include/linux/blkdev.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 03252af8c82c..62a4904db921 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -958,6 +958,7 @@ generic_make_request_checks(struct bio *bio)
 	struct request_queue *q;
 	int nr_sectors = bio_sectors(bio);
 	blk_status_t status = BLK_STS_IOERR;
+	struct blk_plug *plug;
 	char b[BDEVNAME_SIZE];
 
 	might_sleep();
@@ -971,6 +972,10 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
+	plug = blk_mq_plug(q, bio);
+	if (plug && plug->nowait)
+		bio->bi_opf |= REQ_NOWAIT;
+
 	/*
 	 * For a REQ_NOWAIT based request, return -EOPNOTSUPP
 	 * if queue is not a request based queue.
@@ -1800,6 +1805,7 @@ void blk_start_plug(struct blk_plug *plug)
 	INIT_LIST_HEAD(&plug->cb_list);
 	plug->rq_count = 0;
 	plug->multiple_queues = false;
+	plug->nowait = false;
 
 	/*
 	 * Store ordering should not be needed here, since a potential
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8fd900998b4e..6e067dca94cf 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1189,6 +1189,7 @@ struct blk_plug {
 	struct list_head cb_list; /* md requires an unplug callback */
 	unsigned short rq_count;
 	bool multiple_queues;
+	bool nowait;
 };
 #define BLK_MAX_REQUEST_COUNT 16
 #define BLK_PLUG_FLUSH_SIZE (128 * 1024)
-- 
2.27.0

