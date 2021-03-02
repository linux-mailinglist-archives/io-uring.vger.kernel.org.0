Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE3B32B54C
	for <lists+io-uring@lfdr.de>; Wed,  3 Mar 2021 07:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239905AbhCCGnI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 01:43:08 -0500
Received: from smtp01.tmcz.cz ([93.153.104.112]:32050 "EHLO smtp01.tmcz.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1581885AbhCBT2l (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 2 Mar 2021 14:28:41 -0500
Received: from leontynka.twibright.com (109-183-129-149.customers.tmcz.cz [109.183.129.149])
        by smtp01.tmcz.cz (Postfix) with ESMTPS id 38EDF4039C;
        Tue,  2 Mar 2021 20:05:55 +0100 (CET)
Received: from debian-a64.vm ([192.168.208.2])
        by leontynka.twibright.com with smtp (Exim 4.92)
        (envelope-from <mpatocka@redhat.com>)
        id 1lHALB-0003kD-WF; Tue, 02 Mar 2021 20:05:55 +0100
Received: by debian-a64.vm (sSMTP sendmail emulation); Tue, 02 Mar 2021 20:05:52 +0100
Message-Id: <20210302190552.715551440@debian-a64.vm>
User-Agent: quilt/0.65
Date:   Tue, 02 Mar 2021 20:05:15 +0100
From:   Mikulas Patocka <mpatocka@redhat.com>
To:     JeffleXu <jefflexu@linux.alibaba.com>,
        Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, axboe@kernel.dk,
        caspar@linux.alibaba.com, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, hch@lst.de
Cc:     Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/4] block: dont clear REQ_HIPRI for bio-based drivers
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=block-allow-bio-hipri.patch
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't clear REQ_HIPRI for bio-based drivers. Device mapper will need to
see this flag in order to support polling.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2021-03-02 10:43:28.000000000 +0100
+++ linux-2.6/block/blk-core.c	2021-03-02 10:53:50.000000000 +0100
@@ -836,7 +836,7 @@ static noinline_for_stack bool submit_bi
 		}
 	}
 
-	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && !bdev->bd_disk->fops->submit_bio)
 		bio->bi_opf &= ~REQ_HIPRI;
 
 	switch (bio_op(bio)) {

