Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AFA1EE9BE
	for <lists+io-uring@lfdr.de>; Thu,  4 Jun 2020 19:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbgFDRsi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Jun 2020 13:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730094AbgFDRsi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Jun 2020 13:48:38 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7ACEC08C5C1
        for <io-uring@vger.kernel.org>; Thu,  4 Jun 2020 10:48:37 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m7so2489924plt.5
        for <io-uring@vger.kernel.org>; Thu, 04 Jun 2020 10:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J7LFtc41HM0xKogCHwU3PJalnMW16dWjgSOWGN/8m/o=;
        b=Ns8gTLNpSNdYyPUANFNsD0VACkX39FNeCZ0GADBluEORkmeAnuckLCEOWMybx3pvub
         u6UZPsvfVfWubeW7CJZ6Q9N3qn2D2qEl/sYwtk+NSnYWZTJmYdJpA3NRgLuXqWVWoSee
         OTf3R/E/OyEAe59T9YvuFIOI1UiD2i6lIsajDTAXuAPI/dMPoi69gKYLMkw0i1xIYxa/
         YpeO+N5Ff9U1XZDf93+V8p4XQHoUvqXIvqemoxt40FzoxlSlH+j0Rm0uRa+EgwLPdyzD
         9l5/ojDl2QQ2bA7t2euycGt3jdcYvLpqfTuvOJH+gvaYUWbxi7ZF8cM91tEAXrrV+Iz7
         38KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J7LFtc41HM0xKogCHwU3PJalnMW16dWjgSOWGN/8m/o=;
        b=YscvxY5Xp4hWkJTHVM8vXBAlr34vX7/ujcXbNXs/WR9cd0Sd25CN2BEnfJA5oE8u27
         LPofVngP4ner+sg8pKsJ+CVxspDfy+NKS1y2OfG5U55wycmPQ0Hi5n4QIFT8lBM7BqVj
         6NbLpgcLHpvrpM2UUCNMeWzysfV4NSZ8AvQSdYwS4rXp60vUhUDYYvAccIAsgXf9jlhw
         akQ8A9NJ7q9KsetYvj9zTbZBmHiSpXNiWdntR7f0ClBliHQbarv6vozr3sYgxF33sSxp
         3ILhKsssA06rpoBM/ZIUQWJIrGVnGVONdL/ypJ2qwqymnqtoQDva201rHERt7IqUOx2+
         zoVw==
X-Gm-Message-State: AOAM532e0mRB3jn3VaYzqYZ5wbN4pj9Ubss8z6nHFLvyhhUg59SwZocc
        d3GKZeD21Ra7bcSNjtG8adjkctfav/ulRg==
X-Google-Smtp-Source: ABdhPJyxh9d76lstKqGTWENz+yP3RY9tb457Oxt67I39dO7PTKYG/RiBpuw76xLbAhRNVq8OWK2ZVg==
X-Received: by 2002:a17:90a:f011:: with SMTP id bt17mr7302365pjb.179.1591292917088;
        Thu, 04 Jun 2020 10:48:37 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n9sm6044494pjj.23.2020.06.04.10.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 10:48:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] block: provide plug based way of signaling forced no-wait semantics
Date:   Thu,  4 Jun 2020 11:48:29 -0600
Message-Id: <20200604174832.12905-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200604174832.12905-1-axboe@kernel.dk>
References: <20200604174832.12905-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Provide a way for the caller to specify that IO should be marked
with REQ_NOWAIT to avoid blocking on allocation, as well as a list
head for caller use.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c       | 6 ++++++
 include/linux/blkdev.h | 2 ++
 2 files changed, 8 insertions(+)

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
index 8fd900998b4e..27887bf36d50 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1187,8 +1187,10 @@ extern void blk_set_queue_dying(struct request_queue *);
 struct blk_plug {
 	struct list_head mq_list; /* blk-mq requests */
 	struct list_head cb_list; /* md requires an unplug callback */
+	struct list_head nowait_list;	/* caller user */
 	unsigned short rq_count;
 	bool multiple_queues;
+	bool nowait;
 };
 #define BLK_MAX_REQUEST_COUNT 16
 #define BLK_PLUG_FLUSH_SIZE (128 * 1024)
-- 
2.27.0

