Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980755EF53C
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 14:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbiI2MWl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 08:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbiI2MWa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 08:22:30 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539A914F8DA
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 05:22:28 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220929122225epoutp02f071d7a9b4b2e2fc2605990f357fed66~ZVDoXJR3z0536305363epoutp02M
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 12:22:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220929122225epoutp02f071d7a9b4b2e2fc2605990f357fed66~ZVDoXJR3z0536305363epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664454145;
        bh=59MWC7YKVdzgmkE5Wy/YUKyd6wK6AegrnshKeeB/mZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lyTLJ5m7GGnjIHSRrKIzjETaPdBWaCWqwzewQ6bqZgO+Qth1AdLWg9RqZ20eLniiR
         Ehbi0yNZjpnWckcoXd/IEDKKzYIGJGDQHfiIOr/nSU728BKTKr1/Ysavxog9ZjA2Jq
         J4Njd48Wa2w1WmQsgB5l9motfiJptrOVAFonEOxY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220929122225epcas5p1e8b3a0589c411fefac09641f5004345b~ZVDoA8c2m2788827888epcas5p1b;
        Thu, 29 Sep 2022 12:22:25 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MdXYV5438z4x9Pt; Thu, 29 Sep
        2022 12:22:22 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C5.D2.26992.EFD85336; Thu, 29 Sep 2022 21:22:22 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220929121647epcas5p2d4ca8ae0b83a1fce230914f586ee3cc0~ZU_s4RNeD2579425794epcas5p2B;
        Thu, 29 Sep 2022 12:16:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220929121647epsmtrp2a837379cd2f37959172aa4103b7d7299~ZU_s3mBYr1794617946epsmtrp2S;
        Thu, 29 Sep 2022 12:16:47 +0000 (GMT)
X-AuditID: b6c32a49-319fb70000016970-1c-63358dfe8c16
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        70.3C.18644.EAC85336; Thu, 29 Sep 2022 21:16:46 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220929121645epsmtip10ef31f1711717eaeaf118834a0438953~ZU_rhjGXU2848328483epsmtip1Y;
        Thu, 29 Sep 2022 12:16:45 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v11 05/13] block: rename bio_map_put to
 blk_mq_map_bio_put
Date:   Thu, 29 Sep 2022 17:36:24 +0530
Message-Id: <20220929120632.64749-6-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929120632.64749-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmuu6/XtNkg+0dyhZNE/4yW6y+289m
        cfPATiaLlauPMlm8az3HYjHp0DVGi723tC3mL3vKbtF9fQebA6fH5bOlHptWdbJ5bF5S77H7
        ZgObR9+WVYwenzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam
        2iq5+AToumXmAJ2kpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L
        18tLLbEyNDAwMgUqTMjOOHn8M3PBQY6KL9962BoYv7N1MXJySAiYSNy9dQzI5uIQEtjNKPHr
        7WVmCOcTo8SZbTvYIZzPjBLfGmcwwrSceLuHCSKxi1Fi7+U1YAmwqrl7LUBsNgF1iSPPW8Hi
        IgJGEvs/nWQFaWAW2AS04/oxJpCEsECoxNT+XrBDWARUJY7OWwdm8wpYSizee58ZYpu8xMxL
        39lBbE4BK4nF1+awQtQISpyc+YQFxGYGqmneOhvsbgmBn+wSn05+YoVodpF4//cE1KfCEq+O
        b2GHsKUkPr/bCxVPl/hx+SkThF0g0XxsH9Sb9hKtp/qBhnIALdCUWL9LHyIsKzH11DomiL18
        Er2/n0C18krsmAdjK0m0r5wDZUtI7D3XwAQyRkLAQ2LPZnlIwPUySly69Y5pAqPCLCTvzELy
        ziyEzQsYmVcxSqYWFOempxabFhjmpZbDYzk5P3cTIziZannuYLz74IPeIUYmDsZDjBIczEoi
        vOIFpslCvCmJlVWpRfnxRaU5qcWHGE2B4T2RWUo0OR+YzvNK4g1NLA1MzMzMTCyNzQyVxHkX
        z9BKFhJITyxJzU5NLUgtgulj4uCUamDKCdPY963kkv6HO89ORvwqbbjGtlF7dtDSpSJdAtOu
        hk6c/M9nUv3U8KbZ2nlfU9jOsV0KCXp17gbfZdaHG7//EvTheKuj2rR24WS2E1KZ/Lr3RR48
        Xrsu2iLeSEf+kahP+v5HCQ+zLh55WlT+Rv6GfIPPNtNn0+UrWrYGKLLFn3pp16KR6s+6+vnF
        Sb3TkzMWF/wrfbtzGuOktBTlNsudJ3rcLjw02RLkWMRmy9WU1zKjd1nzTLl3cz+0PJ2hYrxR
        zrDJOrTrod3Oi0cSAm9Ny6y9sEqf3eq1v4f2S61v1bP3abKbSPNNmPMv9ojhsp3tKlOmiaTk
        ui9hbmljOKIfsWJecIiBVMvjojtPVBOUWIozEg21mIuKEwGh7LaILwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWy7bCSnO66HtNkg2uzzSyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxWLSoWuMFntvaVvMX/aU3aL7+g42B06Py2dLPTat6mTz2Lyk3mP3
        zQY2j74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4Mo4efwzc8FBjoov33rYGhi/s3UxcnJICJhI
        nHi7h6mLkYtDSGAHo0T7zf1MEAkJiVMvlzFC2MISK/89ZwexhQQ+MkpM2BUHYrMJqEsced4K
        ViMiYCax9PAaFpBBzCCD1j1bDJTg4BAWCJZY/TcbpIZFQFXi6Lx1YIt5BSwlFu+9zwwxX15i
        5qXvYPM5BawkFl+bwwrSKgRUs/2mAkS5oMTJmU9YQGxmoPLmrbOZJzAKzEKSmoUktYCRaRWj
        ZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnCoa2ntYNyz6oPeIUYmDsZDjBIczEoivOIF
        pslCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MCVn3e4x
        KGb7nXZ2i6y8+zOe3jB1v5kWz9Llp5vuUTzia5SVcS/Olq2I/ZxVWNjD7RJPmeK5mPO/eK+S
        avESnC298d29C0s2zZdQCpmnuZgjac0ha5enOutu3Nq9edaBBJP27jciNpcqZnVO8P2ZoXy3
        9mqfbJKVau0XmW9zPL9vtZ2pclDx85SXoQJsnz/+O+q137xe6tG+ytO2x7jWmSs5zvopbJSt
        k7fOPJL968pjax47qef4fRH6MfXiQ6VP3mWLcvjly2U38O69dT29IZTL+IGkZyGD5crMKwJb
        tz5X/rO7f9FkbRG3t6VCavKPpGNsLmTHlgbOaf/6myX1xIyGxKQ6/bP/CpVWVDcfU2Ipzkg0
        1GIuKk4EAAyJtZzkAgAA
X-CMS-MailID: 20220929121647epcas5p2d4ca8ae0b83a1fce230914f586ee3cc0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220929121647epcas5p2d4ca8ae0b83a1fce230914f586ee3cc0
References: <20220929120632.64749-1-anuj20.g@samsung.com>
        <CGME20220929121647epcas5p2d4ca8ae0b83a1fce230914f586ee3cc0@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch renames existing bio_map_put function to blk_mq_map_bio_put.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-map.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 7693f8e3c454..d913ef92a9fe 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -231,7 +231,7 @@ static int bio_copy_user_iov(struct request *rq, struct rq_map_data *map_data,
 	return ret;
 }
 
-static void bio_map_put(struct bio *bio)
+static void blk_mq_map_bio_put(struct bio *bio)
 {
 	if (bio->bi_opf & REQ_ALLOC_CACHE) {
 		bio_put(bio);
@@ -331,7 +331,7 @@ static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
 
  out_unmap:
 	bio_release_pages(bio, false);
-	bio_map_put(bio);
+	blk_mq_map_bio_put(bio);
 	return ret;
 }
 
@@ -636,7 +636,7 @@ int blk_rq_unmap_user(struct bio *bio)
 
 		next_bio = bio;
 		bio = bio->bi_next;
-		bio_map_put(next_bio);
+		blk_mq_map_bio_put(next_bio);
 	}
 
 	return ret;
-- 
2.25.1

