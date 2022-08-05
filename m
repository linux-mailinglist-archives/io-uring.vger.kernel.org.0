Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064C858ADBB
	for <lists+io-uring@lfdr.de>; Fri,  5 Aug 2022 17:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241145AbiHEPzX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Aug 2022 11:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241361AbiHEPzF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Aug 2022 11:55:05 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C137969F
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 08:53:30 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220805155314epoutp04c855916f3e406f4574a0609a68fcf6da~Ifc-5yha70030300303epoutp04Y
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 15:53:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220805155314epoutp04c855916f3e406f4574a0609a68fcf6da~Ifc-5yha70030300303epoutp04Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659714794;
        bh=5IRAjs6+m4OB4xTk3tclAQOLtoFiORzCHerBHOWaHZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pi6VduDbQO3FvD0OGWcZ797fl67h4GdvYod+R9ieYWd2SdUF6qmyH1TUuDT8Sf86p
         1vIb3uLhccOU3tUAnYDriP4aAr98h95dVzxkG4eoILKw2PJNC+x+rP0i1EX/uW062f
         Hj4/YDIC67HadgiiZHy0KmjbEygkG+KGfjKGonCY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220805155313epcas5p3b900662fb2a530dad95248adf6276cdc~Ifc_0k9j12910829108epcas5p35;
        Fri,  5 Aug 2022 15:53:13 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Lzqr72TJXz4x9Pt; Fri,  5 Aug
        2022 15:53:11 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7B.15.09639.7EC3DE26; Sat,  6 Aug 2022 00:53:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220805155310epcas5p2bd7ec5b9bee73893958f4bc84038eca0~Ifc8FvJhX2017620176epcas5p2U;
        Fri,  5 Aug 2022 15:53:10 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220805155310epsmtrp2040be2f0d9c1a34a63a932dd1253ec62~Ifc8FEgkV2288122881epsmtrp20;
        Fri,  5 Aug 2022 15:53:10 +0000 (GMT)
X-AuditID: b6c32a4b-e83ff700000025a7-49-62ed3ce7dee3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        55.B9.08905.6EC3DE26; Sat,  6 Aug 2022 00:53:10 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220805155309epsmtip2230ca8e5ac0461a35d0f554ac625fb4a~Ifc6wGjCc0383603836epsmtip2T;
        Fri,  5 Aug 2022 15:53:09 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        joshiiitr@gmail.com, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 3/4] block: export blk_rq_is_poll
Date:   Fri,  5 Aug 2022 21:12:25 +0530
Message-Id: <20220805154226.155008-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220805154226.155008-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCJsWRmVeSWpSXmKPExsWy7bCmuu5zm7dJBluO8lusvtvPZnHzwE4m
        i5WrjzJZvGs9x2Jx9P9bNovzbw8zWey9pW0xf9lTdotDk5uZHDg9ds66y+5x+Wypx+Yl9R67
        bzawebzfd5XNo2/LKkaPz5vkAtijsm0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3M
        lRTyEnNTbZVcfAJ03TJzgO5SUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgV
        J+YWl+al6+WlllgZGhgYmQIVJmRnzH1zj7VgEnfFpp4jrA2MSzm7GDk5JARMJC58PM3axcjF
        ISSwm1Hiz6w3zBDOJ0aJo9/mMUI43xglln54zgzTsuzpE3aIxF5GiQlXT0H1f2aUOPe4AaiF
        g4NNQFPiwuRSkAYRAXmJL7fXsoDUMAscYpR4vuQV2CRhAUOJles3gNWzCKhKrLhQCRLmFbCU
        2DynE2qZvMTMS9/ZQWxOASuJ1sNbmCFqBCVOznzCAmIzA9U0b50NdraEQCuHxJr1/6CaXSQu
        7/nECGELS7w6voUdwpaS+PxuLxuEnSxxaeY5Jgi7ROLxnoNQtr1E66l+ZpDbmIF+Wb9LH2IX
        n0Tv7ydMIGEJAV6JjjYhiGpFiXuTnrJC2OISD2csgbI9JLbcuAYNq15GicM/21knMMrPQvLC
        LCQvzELYtoCReRWjZGpBcW56arFpgXFeajk8YpPzczcxgpOnlvcOxkcPPugdYmTiYAQGLQez
        kgjvzx2vk4R4UxIrq1KL8uOLSnNSiw8xmgKDeCKzlGhyPjB955XEG5pYGpiYmZmZWBqbGSqJ
        83pd3ZQkJJCeWJKanZpakFoE08fEwSnVwMR/oi0imY9H3e/9yhucDDJnuHX3XrJ2nx1WaeXF
        9XjddfZpnQoF7888PPJ107ztwZdm7rnhfX7zb+mL2yvFT6zoiU88slmE2Zf9qsbE7pXsjab+
        bOWXdx7U3tckZNw2S0T1lsjNY+ynfWN3FP1pbFm9vLBnLZetRdeCGYaVV1QbPnEn37/Zzyd1
        2iT9Stlb769Hdm4/s+DeoVuG/L33a7bJxu3alyevqldfMcd03ar7f9Lc3n01/nh/5+MvldKb
        7vv6XJwkkLPj/UqDn9PEp622aoxm2KTTqHObv/XqHY69dkaNbvsMpN4c3KZ9/uVSfXOBn3vn
        6f/NY9oT4znr87nOg+cuLexrYny0Wejg83N6SizFGYmGWsxFxYkAH8iXoicEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWy7bCSvO4zm7dJBg93alqsvtvPZnHzwE4m
        i5WrjzJZvGs9x2Jx9P9bNovzbw8zWey9pW0xf9lTdotDk5uZHDg9ds66y+5x+Wypx+Yl9R67
        bzawebzfd5XNo2/LKkaPz5vkAtijuGxSUnMyy1KL9O0SuDLmvrnHWjCJu2JTzxHWBsalnF2M
        nBwSAiYSy54+Ye9i5OIQEtjNKPG85wQjREJcovnaD3YIW1hi5b/nUEUfGSXe9e5m62Lk4GAT
        0JS4MLkUpEZEQFFi48cmRpAaZoFTjBLvj75hAUkICxhKrFy/gRGknkVAVWLFhUqQMK+ApcTm
        OZ3MEPPlJWZe+g62i1PASqL18BZmkHIhoJr5d7ggygUlTs58AjaRGai8eets5gmMArOQpGYh
        SS1gZFrFKJlaUJybnltsWGCYl1quV5yYW1yal66XnJ+7iREc9FqaOxi3r/qgd4iRiYPxEKME
        B7OSCO/PHa+ThHhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCU
        amCqq34WZMh371PW47mqARMYDiy6F/0giC3wt8DH68Hi55/2BFhufHV04/KcOf9OGb2a1xZ8
        d8Yf6fd37jxym51UUvtUN/AH978E+989ftsPZcnX3hCuO8IgIjFpDhOTvZJqmfMzrbkB71++
        +Sp1bFfHyv2a4tG1paL/eywrbysvuCCbt/nANoUTO6ZOV/2hPYf56cQj/AUiOe7f1+f0f172
        +E/okbUNpkxqXJ1XZns+EJgWtLZaY07o6Y7yLbrmad3s2wLvhDMEyU7zEAnv/vDmUeq7GxpH
        di99IJ95ITU5wT9U1Fpu96RPr8951Vq5PQ/KlKzLLj8mo7FwYcHqeREXPs6LSj4wSel1Qldg
        UsVNJZbijERDLeai4kQAp56ntekCAAA=
X-CMS-MailID: 20220805155310epcas5p2bd7ec5b9bee73893958f4bc84038eca0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220805155310epcas5p2bd7ec5b9bee73893958f4bc84038eca0
References: <20220805154226.155008-1-joshi.k@samsung.com>
        <CGME20220805155310epcas5p2bd7ec5b9bee73893958f4bc84038eca0@epcas5p2.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

