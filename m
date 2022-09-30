Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483A75F051C
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 08:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiI3Goh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 02:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbiI3Go2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 02:44:28 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EE5C77CA
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 23:44:27 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220930064425epoutp0391b42d9bae7b96d94a08ad6de87e4bf2~ZkFzOmPjr2850328503epoutp03C
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 06:44:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220930064425epoutp0391b42d9bae7b96d94a08ad6de87e4bf2~ZkFzOmPjr2850328503epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664520265;
        bh=2l6r1DB02hn4cQZvMEIiXdgX6TaGb69i56uQGNumnms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vZ8NV62On6AR8MsDXpuYe5iYfJBXX4LcSTjGyLrw7kYYlX7OHBTLbgICSvk2vfMhx
         UcsnF/epUsOJqHJnjpHlkBEYbK4/m6ClgqEcSJEsanEj1ZUaRnuuiLpfVaSZl+4mcZ
         2b8YTraV0oiJ9X+GxVFiqQUGLWdtjXxMglcHH4J4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220930064425epcas5p20de9d92698b041556465d4c22df60c84~ZkFy3sFDd0972109721epcas5p25;
        Fri, 30 Sep 2022 06:44:25 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Mf1121Qzzz4x9Pq; Fri, 30 Sep
        2022 06:44:22 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        03.02.56352.64096336; Fri, 30 Sep 2022 15:44:22 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220930063826epcas5p491d9bc62214c1d7c8c24c883299edfb7~ZkAlF8ByA1804318043epcas5p4L;
        Fri, 30 Sep 2022 06:38:26 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220930063826epsmtrp13b1d534abf3cebea898c89a74730547e~ZkAlFF3H22641426414epsmtrp12;
        Fri, 30 Sep 2022 06:38:26 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-0b-6336904639b5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        64.69.14392.2EE86336; Fri, 30 Sep 2022 15:38:26 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220930063825epsmtip2a4279c2b0a76b59303f29082e3e0416e~ZkAjvCG4M1763417634epsmtip2K;
        Fri, 30 Sep 2022 06:38:25 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v12 08/12] block: rename bio_map_put to
 blk_mq_map_bio_put
Date:   Fri, 30 Sep 2022 11:57:45 +0530
Message-Id: <20220930062749.152261-9-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220930062749.152261-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmpq7bBLNkg+MtHBZNE/4yW6y+289m
        cfPATiaLlauPMlm8az3HYjHp0DVGi723tC3mL3vKbtF9fQebA6fH5bOlHptWdbJ5bF5S77H7
        ZgObR9+WVYwenzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam
        2iq5+AToumXmAJ2kpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L
        18tLLbEyNDAwMgUqTMjOWLvvA1PBO46KpvlfmBsY57N3MXJySAiYSNw+9oyxi5GLQ0hgN6PE
        8n/XmCCcT4wS83bcYYNwvjFK3PndwgTTcu/zAqiWvYwSk/Z1MUM4nxklFvWdABvMJqAuceR5
        KyOILSJgJLH/00lWkCJmgU2MEr+uHwMbJSwQKtG1ZR4riM0ioCqx+t4noGYODl4BK4k/xywh
        tslLzLz0HSzMKWAt0bwoByTMKyAocXLmExYQmxmopHnrbGaI8p/sEpP7bSFsF4nLu8+wQdjC
        Eq+Ob4H6WUriZX8blJ0u8ePyU6jHCiSaj+1jhLDtJVpP9TODrGUW0JRYv0sfIiwrMfXUOiaI
        tXwSvb+fQLXySuyYB2MrSbSvnANlS0jsPdcAZXtI3JzdC2YLCfQxSsy+qj6BUWEWkm9mIflm
        FsLmBYzMqxglUwuKc9NTi00LjPNSy+FxnJyfu4kRnEi1vHcwPnrwQe8QIxMH4yFGCQ5mJRFe
        8QLTZCHelMTKqtSi/Pii0pzU4kOMpsDAnsgsJZqcD0zleSXxhiaWBiZmZmYmlsZmhkrivItn
        aCULCaQnlqRmp6YWpBbB9DFxcEo1MD2akr95f8y6NQJLp92yD3X84ly2quh0qobPt32GX9Mj
        7SIOqSdHsm9rzrVzN5eOi9sefaxMVfnHKQ/Wq6tWCVcJsevurry6jmux2MxFq7cvWK8WULk5
        rFLK+bLIab0Uzut8TDuKDlc/4lHh/pSn0n5K76uLRjK75le1B5+m/1we+vhedVjjqdmLilJL
        tK0dFDo3TfbbOrNJQeDGShWVn5k3NlfcTI7fVBJ5KEd6U9yHbXZdTqcE3+bEvtjSO//Ug0CG
        WWYbmJ9t4NbRe8ZvvFv9a0i68VxZ08ygSay3OlIyIja9rn5e3PSgcV3My+0e3Ca1n/iuSR6f
        UTj5jECWspKjw17ZYydWlUy9VNW2TomlOCPRUIu5qDgRAHxqyLItBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSvO6jPrNkg/8btCyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxWLSoWuMFntvaVvMX/aU3aL7+g42B06Py2dLPTat6mTz2Lyk3mP3
        zQY2j74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4MpYu+8DU8E7joqm+V+YGxjns3cxcnJICJhI
        3Pu8gLGLkYtDSGA3o8S5Yy1sEAkJiVMvlzFC2MISK/89Z4co+sgo8XDzYrBuNgF1iSPPW8GK
        RATMJJYeXsMCUsQssINRYt2zxWAJYYFgiYb1D8FsFgFVidX3PgE1c3DwClhJ/DlmCbFAXmLm
        pe9gYU4Ba4nmRTkgYSGgis973oOt4hUQlDg58wkLiM0MVN68dTbzBEaBWUhSs5CkFjAyrWKU
        TC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93ECA52Lc0djNtXfdA7xMjEwXiIUYKDWUmEV7zA
        NFmINyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGpnTHI6E3
        blerOnJ+jL0/qaO4iW/itETZFe857iazu91xemvaXX9/r7N6nLvOfMf/1qtY3l6V7Re/PPdR
        Uv5NlZOiKTc/qPMoa2ft0wv27GatvDTr9u5vVccZylkNZpa5fbx5+EO6+6uzbU7rQo++XXqq
        WFtg6duuqdrXgnY6SFy59OnGN8O42cc5l18R9G5brRlfc+R2vp6I0Y3EnWozHPs/uM/Ls4uO
        79NNn/H3q85q+2CLI/OXr9RdfTPWeeGl/9UL33lkuXvy7OtbnbIv4fohxrVFB5h7dV0emPvJ
        FT/RYlZifPJXY4lLvmx5wRPGbAfv7yyS8/N6LrU03dteX87O7XX9t8RH1Y9mbfy2SizFGYmG
        WsxFxYkAOGILcuUCAAA=
X-CMS-MailID: 20220930063826epcas5p491d9bc62214c1d7c8c24c883299edfb7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220930063826epcas5p491d9bc62214c1d7c8c24c883299edfb7
References: <20220930062749.152261-1-anuj20.g@samsung.com>
        <CGME20220930063826epcas5p491d9bc62214c1d7c8c24c883299edfb7@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch renames existing bio_map_put function to blk_mq_map_bio_put.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-map.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 0e37bbedd46c..84b13a4158b7 100644
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
 
@@ -672,7 +672,7 @@ int blk_rq_unmap_user(struct bio *bio)
 
 		next_bio = bio;
 		bio = bio->bi_next;
-		bio_map_put(next_bio);
+		blk_mq_map_bio_put(next_bio);
 	}
 
 	return ret;
-- 
2.25.1

