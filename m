Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7FF59EAB5
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 20:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbiHWSNG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 14:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbiHWSMq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 14:12:46 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70289C2F3
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 09:25:19 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220823162518epoutp02ef59d3dee00274f3ca1a2cd635c86512~OBgILREWc2338423384epoutp02T
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 16:25:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220823162518epoutp02ef59d3dee00274f3ca1a2cd635c86512~OBgILREWc2338423384epoutp02T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661271918;
        bh=M5c5MSSpPjOFINuFSuBokw/onxM6vwEHa1nJRmz/DWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXw/ExN0zGDDsM7oGHvmZyVSDZdajHUTKIb1Dqll99RfqTaHDPb8J6t598sIsbvhJ
         68MMKPVG+RMBkmO9XzyXyIDiIbIwcsoyBHhi8iK1SpMfNdYA3Gr5tBmS7rPygA2ji/
         yXHQ/Xrk68FrVULr5nA+hGzosaTTv9YPJaFONSOI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220823162517epcas5p1b66853c5f5de3f7deb1a454ac896da57~OBgHjRodh1977519775epcas5p1C;
        Tue, 23 Aug 2022 16:25:17 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MBvhp6BdMz4x9Pv; Tue, 23 Aug
        2022 16:25:14 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AB.15.18001.A6FF4036; Wed, 24 Aug 2022 01:25:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220823162514epcas5p1a86cebaed6993eacd976b59fc2c68f29~OBgEiCaF21977519775epcas5p1-;
        Tue, 23 Aug 2022 16:25:14 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220823162514epsmtrp1003f6192e2d42549c83941eefcf2b0aa~OBgEhSAsd2270522705epsmtrp1J;
        Tue, 23 Aug 2022 16:25:14 +0000 (GMT)
X-AuditID: b6c32a4a-2c3ff70000004651-fc-6304ff6a8905
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3E.02.14392.A6FF4036; Wed, 24 Aug 2022 01:25:14 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220823162512epsmtip28f578ee1714d17addb16531bc69f4e8e~OBgDEus_z2555425554epsmtip26;
        Tue, 23 Aug 2022 16:25:12 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v3 3/4] block: export blk_rq_is_poll
Date:   Tue, 23 Aug 2022 21:44:42 +0530
Message-Id: <20220823161443.49436-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220823161443.49436-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmpm7Wf5Zkg3WfdC3mrNrGaLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLCYdusZosfeWtsX8ZU/ZLQ5NbmZy4PLYOesuu8fls6Ue
        m1Z1snlsXlLvsftmA5vH+31X2Tz6tqxi9Pi8SS6AIyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzje
        Od7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoQiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJ
        rVJqQUpOgUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsakGw3MBR3cFT/nzmdvYJzL2cXIwSEh
        YCKxZ6JYFyMXh5DAbkaJKy27mSCcT4wSxyavYe5i5ARyvjFK3DmtAGKDNHRPb2CBKNrLKDHr
        5nQ2iKLPjBK7byaDTGUT0JS4MLkUJCwi4CVx//Z7VpB6ZoG1jBKn935hAkkIC9hKfH/5mR3E
        ZhFQlVi0ZglYnFfAQmJZ1wV2iGXyEjMvfWcHmckpYClx+qAcRImgxMmZT1hAbGagkuats5kh
        yidySJxbEARhu0i8OjoBKi4s8er4FqiRUhIv+9ug7GSJSzPPMUHYJRKP9xyEsu0lWk/1M4Os
        ZQZ6Zf0ufYhVfBK9v58wQcKNV6KjTQiiWlHi3qSnrBC2uMTDGUugbA+JJV2LmCEh1cMo8eXx
        TbYJjPKzkHwwC8kHsxC2LWBkXsUomVpQnJueWmxaYJSXWg6P1OT83E2M4ESq5bWD8eGDD3qH
        GJk4GA8xSnAwK4nwWh1jSRbiTUmsrEotyo8vKs1JLT7EaAoM4YnMUqLJ+cBUnlcSb2hiaWBi
        ZmZmYmlsZqgkzjtFmzFZSCA9sSQ1OzW1ILUIpo+Jg1OqgSl+2T1HDZn1Std3TtjsdGPSMsEZ
        IZMsrju6f5X84Plvw70XHvu2+NaXrZi/tvSgbA931L5r60ItJa89c4jNMJSzWlgz2bYuQDRz
        22WjDKsnV38Hztv2f7Ly4eLL/junBO8Xe/dvyf8ZTW8yl79pf+g0Y8H22+Ji7WueBnM0TI/l
        VjvwfJb3/7d3zeVfbuJdfJu36rv7Fp0oOeMqRekn133PPr64L6tvqUfQTJZ3dku31W3ZXO+h
        uKpv4ae6sEWhfMVCrd/iLr6ZN/m4mJnKsVv+ZUlbF1eGHHh4wjLz4t+aj5/5r6+UeLz9SaLh
        keffU8Rinh6rnyt8Jq3U8VX907U/so9/3rJAbrb/C/uz3seetyqxFGckGmoxFxUnAgBPGbZ8
        LQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSvG7Wf5Zkg4NHRS3mrNrGaLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLCYdusZosfeWtsX8ZU/ZLQ5NbmZy4PLYOesuu8fls6Ue
        m1Z1snlsXlLvsftmA5vH+31X2Tz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoErY9KNBuaCDu6K
        n3PnszcwzuXsYuTkkBAwkeie3sDSxcjFISSwm1Hi29Vl7BAJcYnmaz+gbGGJlf+es0MUfWSU
        eLR0CmMXIwcHm4CmxIXJpSA1IgIBEgcbL4PVMAtsZpT4dPoYM0hCWMBW4vvLz2CDWARUJRat
        WcIEYvMKWEgs67oAtUBeYual7+wgMzkFLCVOH5QDCQsBlfzZ1MAGUS4ocXLmExYQmxmovHnr
        bOYJjAKzkKRmIUktYGRaxSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHAtamjsYt6/6
        oHeIkYmD8RCjBAezkgiv1TGWZCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGan
        phakFsFkmTg4pRqYan8K3Vr2/r5Xwt2QrLbgA/Nn/3f76vLi3N45+oZntnlPllIKlPpmph1w
        l2GKvk7TItfPkdw8gsserbwoN1O/XeeB6kL3Tztj7uwTc0tYFXIo6ZRH/bPOA9d77v97UyJz
        fE5HIOfauz9Zf+ZqH5jxuEGoezdzCPfJU8+5c/VKY73E0hz+zPz2PXGfxqJW0ZNXen977FGu
        /9Yd7tCYN7GqrimKJ2dy2tfaFyfVHS+ukpVKPP8v7ImzyomiH5ZbmlgPZwcd+rEsoXvP15kc
        1RWX52qG2IbfCIq6/j/esaQt88PWxc9bGXuzJ3hkLpmw7OJWzvVb2YIyFEu3lDXveK8hKSK+
        o05ydvn9577Pz8faK7EUZyQaajEXFScCANszprH0AgAA
X-CMS-MailID: 20220823162514epcas5p1a86cebaed6993eacd976b59fc2c68f29
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220823162514epcas5p1a86cebaed6993eacd976b59fc2c68f29
References: <20220823161443.49436-1-joshi.k@samsung.com>
        <CGME20220823162514epcas5p1a86cebaed6993eacd976b59fc2c68f29@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is in preparation to support iopoll for nvme passthrough.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/blk-mq.c         | 3 ++-
 include/linux/blk-mq.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4b90d2d8cfb0..4a07cab7dfb8 100644
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
index 74b99d716b0b..b43c81d91892 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -980,6 +980,7 @@ int blk_rq_map_kern(struct request_queue *, struct request *, void *,
 int blk_rq_append_bio(struct request *rq, struct bio *bio);
 void blk_execute_rq_nowait(struct request *rq, bool at_head);
 blk_status_t blk_execute_rq(struct request *rq, bool at_head);
+bool blk_rq_is_poll(struct request *rq);
 
 struct req_iterator {
 	struct bvec_iter iter;
-- 
2.25.1

