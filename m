Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0548C58BC84
	for <lists+io-uring@lfdr.de>; Sun,  7 Aug 2022 20:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbiHGSqC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Aug 2022 14:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbiHGSqB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Aug 2022 14:46:01 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA5495A6
        for <io-uring@vger.kernel.org>; Sun,  7 Aug 2022 11:45:59 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220807184555epoutp04fbd8de61aebd4fa8e2998ad9d43dc666~JJGVYtBUy0667206672epoutp04D
        for <io-uring@vger.kernel.org>; Sun,  7 Aug 2022 18:45:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220807184555epoutp04fbd8de61aebd4fa8e2998ad9d43dc666~JJGVYtBUy0667206672epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659897955;
        bh=5IRAjs6+m4OB4xTk3tclAQOLtoFiORzCHerBHOWaHZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ck44F3rH65TOzqMZS4aLVEqAld5i8rOQV9/akI5/vlUnFfsgr+5heT4XTfbsfhDM2
         eza7D2qj65IbWPBh9qWaGrk2PBcB/cNlGP+HzZ7pAcoNhmyeYSnpuAV7TWcCT6GUnn
         RQHnWX7KOc9U9/ZWJfTs6XWs+pTgu5oeFeh1GVZk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220807184554epcas5p42c3108dc74a0f9949527b5a43fd3266d~JJGUXhwe62500825008epcas5p4O;
        Sun,  7 Aug 2022 18:45:54 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4M17ZR4czRz4x9Pt; Sun,  7 Aug
        2022 18:45:51 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        11.5F.09662.F5800F26; Mon,  8 Aug 2022 03:45:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220807184551epcas5p3b85421505f9c28d31492163f69c59d69~JJGRkfS2c1284912849epcas5p3H;
        Sun,  7 Aug 2022 18:45:51 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220807184551epsmtrp2e02088ce37748614fff16b228adce981~JJGRjq0gh0248002480epsmtrp2q;
        Sun,  7 Aug 2022 18:45:51 +0000 (GMT)
X-AuditID: b6c32a49-885ff700000025be-d5-62f0085fd424
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.79.08802.F5800F26; Mon,  8 Aug 2022 03:45:51 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220807184549epsmtip2280c98ff52b9b36411fbf9e829075728~JJGQW0uI22085320853epsmtip2k;
        Sun,  7 Aug 2022 18:45:49 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v2 3/4] block: export blk_rq_is_poll
Date:   Mon,  8 Aug 2022 00:06:06 +0530
Message-Id: <20220807183607.352351-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220807183607.352351-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkk+LIzCtJLcpLzFFi42LZdlhTQzee40OSwZXdyhar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLvLW2L+cueslscmtzM5MDhcflsqcfmJfUeu282sHm833eVzaNv
        yypGj8+b5ALYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
        dN0yc4CuUVIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZY
        GRoYGJkCFSZkZ8x9c4+1YBJ3xaaeI6wNjEs5uxg5OSQETCRmdPxl7GLk4hAS2M0o8XLFTRYI
        5xOjxJcXDVCZz4wS9xq3ssO0zGrawQaR2MUo0TDtBztc1fOZL4EcDg42AU2JC5NLQRpEBOQl
        vtxeCzaWWWAto8TpvV+YQBLCArYSd26uZAGpZxFQldj/kAskzCtgKbFv6XM2iGXyEjMvfQcb
        ySlgJdG1RRmiRFDi5MwnLCA2M1BJ89bZzCDjJQR+sku8Wn+OEaLXRWLW86usELawxKvjW6Ae
        kJL4/G4v1PxkiUszzzFB2CUSj/cchLLtJVpP9TOD7GUGemX9Ln2IXXwSvb+fMIGEJQR4JTra
        hCCqFSXuTXoKtUlc4uGMJVC2h8Te3rXMkNDpZZTomXOEeQKj/CwkL8xC8sIshG0LGJlXMUqm
        FhTnpqcWmxYY5qWWw+M1OT93EyM4TWp57mC8++CD3iFGJg7GQ4wSHMxKIrxH1r5PEuJNSays
        Si3Kjy8qzUktPsRoCgzhicxSosn5wESdVxJvaGJpYGJmZmZiaWxmqCTO63V1U5KQQHpiSWp2
        ampBahFMHxMHp1QD0/RbTPpFsQ+UuFPTp9zgLb0R/5tPouv32ky2TcY2zoG9MXJx8/p+PjD7
        +1TXz8b2+rasdR1BrowXb6Wf7YupePro2esZS6Jaf9rtet1t8DjlspDMV43aVSWdgXcuzjy5
        OWLRqcMrLZYfnHbF9nZ2lVfDRqvQdN+CkAVPpN6/KY828OLJ085pvvrGY++7JWaSf23+XUj0
        qmHgvbJw75Lj5mtu/3279Eu9/xrNsx3h9r9N/iqsss7/eV+EV+zaNGeGOvH9OQ/Zfm7pXXEy
        pdb6R4aT1iPH4/r/Jlz5n7zOUOiHp9ic/c67au9OzNAJ/fdu734fs3X/5T/OWXXsiMJzZb7d
        Lq1dab02jzZuCPtz7pkSS3FGoqEWc1FxIgABKitPHAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWy7bCSvG48x4ckg9+zuSxW3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8XeW9oW85c9Zbc4NLmZyYHD4/LZUo/NS+o9dt9sYPN4v+8qm0ff
        llWMHp83yQWwRXHZpKTmZJalFunbJXBlzH1zj7VgEnfFpp4jrA2MSzm7GDk5JARMJGY17WDr
        YuTiEBLYwSjx5+MRJoiEuETztR/sELawxMp/z9khij4ySjzbNJO5i5GDg01AU+LC5FKQGhEB
        RYmNH5sYQWqYBTYzSnw6fYwZJCEsYCtx5+ZKFpB6FgFVif0PuUDCvAKWEvuWPmeDmC8vMfPS
        d3aQEk4BK4muLcogYSGgkrMXWpghygUlTs58wgJiMwOVN2+dzTyBUWAWktQsJKkFjEyrGCVT
        C4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCA1xLawfjnlUf9A4xMnEwHmKU4GBWEuE9svZ9
        khBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtSi2CyTBycUg1Mkltva8jP
        4zoasuZoXWvzvvYZfx/orDLKMjp8uGNzCZ9fqvub1zm/d0QyF0bJ9Ojp8ryNqalqvRqtc+Ta
        XfOz7hFNOybEzTR4eOPLIr5dO3c/tNbwNt+Ylp5Xo+K1WKHSb694CeuRgvct2+6u89x7wP5d
        fofbE+cfD1wb2Xc1rq7VEjG/u3nZQ7W9Ep8u3JymV37h5KW0lRITjve8/LK5zcXFbPe071dZ
        atSvP8/NPp3792WSSZNXhFDiLj6+tOlf66W1CyapFr/c33L0hqiUDvvvOxP8ec8cnp0+07df
        ryBqIZtwgs0szZT8p8sX7f19wWD5/3vSws4T3CyVnn385j11jpXmtLt+tS6XXA9PUWIpzkg0
        1GIuKk4EAB/KuPHfAgAA
X-CMS-MailID: 20220807184551epcas5p3b85421505f9c28d31492163f69c59d69
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220807184551epcas5p3b85421505f9c28d31492163f69c59d69
References: <20220807183607.352351-1-joshi.k@samsung.com>
        <CGME20220807184551epcas5p3b85421505f9c28d31492163f69c59d69@epcas5p3.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is being done as preparation to support iopoll for nvme passthrough

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/blk-mq.c         | 3 ++-
 include/linux/blk-mq.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5ee62b95f3e5..de42f7237bad 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1233,7 +1233,7 @@ static void blk_end_sync_rq(struct request *rq, blk_status_t ret)
 	complete(&wait->done);
 }
 
-static bool blk_rq_is_poll(struct request *rq)
+bool blk_rq_is_poll(struct request *rq)
 {
 	if (!rq->mq_hctx)
 		return false;
@@ -1243,6 +1243,7 @@ static bool blk_rq_is_poll(struct request *rq)
 		return false;
 	return true;
 }
+EXPORT_SYMBOL_GPL(blk_rq_is_poll);
 
 static void blk_rq_poll_completion(struct request *rq, struct completion *wait)
 {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index effee1dc715a..8f841caaa4cb 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -981,6 +981,7 @@ int blk_rq_map_kern(struct request_queue *, struct request *, void *,
 int blk_rq_append_bio(struct request *rq, struct bio *bio);
 void blk_execute_rq_nowait(struct request *rq, bool at_head);
 blk_status_t blk_execute_rq(struct request *rq, bool at_head);
+bool blk_rq_is_poll(struct request *rq);
 
 struct req_iterator {
 	struct bvec_iter iter;
-- 
2.25.1

