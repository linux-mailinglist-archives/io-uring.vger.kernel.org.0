Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BCD32B54D
	for <lists+io-uring@lfdr.de>; Wed,  3 Mar 2021 07:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344386AbhCCGnU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 01:43:20 -0500
Received: from smtp01.tmcz.cz ([93.153.104.112]:33301 "EHLO smtp01.tmcz.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1581886AbhCBT2m (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 2 Mar 2021 14:28:42 -0500
Received: from leontynka.twibright.com (109-183-129-149.customers.tmcz.cz [109.183.129.149])
        by smtp01.tmcz.cz (Postfix) with ESMTPS id ABE784059E;
        Tue,  2 Mar 2021 20:05:57 +0100 (CET)
Received: from debian-a64.vm ([192.168.208.2])
        by leontynka.twibright.com with smtp (Exim 4.92)
        (envelope-from <mpatocka@redhat.com>)
        id 1lHALE-0003kL-Fd; Tue, 02 Mar 2021 20:05:57 +0100
Received: by debian-a64.vm (sSMTP sendmail emulation); Tue, 02 Mar 2021 20:05:55 +0100
Message-Id: <20210302190555.201228400@debian-a64.vm>
User-Agent: quilt/0.65
Date:   Tue, 02 Mar 2021 20:05:17 +0100
From:   Mikulas Patocka <mpatocka@redhat.com>
To:     JeffleXu <jefflexu@linux.alibaba.com>,
        Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, axboe@kernel.dk,
        caspar@linux.alibaba.com, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, hch@lst.de
Cc:     Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/4] dm: support I/O polling
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=dm-poll.patch
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Support I/O polling if submit_bio_noacct_mq_direct returned non-empty
cookie.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
@@ -1682,6 +1682,11 @@ static void __split_and_process_bio(stru
 		}
 	}
 
+	if (ci.poll_cookie != BLK_QC_T_NONE) {
+		while (atomic_read(&ci.io->io_count) > 1 &&
+		       blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
+	}
+
 	/* drop the extra reference count */
 	dec_pending(ci.io, errno_to_blk_status(error));
 }

