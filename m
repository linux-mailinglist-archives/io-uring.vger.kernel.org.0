Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422B34D1C14
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 16:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347918AbiCHPn6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 10:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347928AbiCHPn4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 10:43:56 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AEE2CC89
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 07:42:57 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220308154255epoutp037e3c47e40ed675e931d082f2dd7d272a~acjK0Zyuq2772027720epoutp03h
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:42:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220308154255epoutp037e3c47e40ed675e931d082f2dd7d272a~acjK0Zyuq2772027720epoutp03h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646754175;
        bh=t4ZrZpuvC13gfl85z8lIeeIdlnonTz/uCGTqcpBiwxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vla7QIYupvhYCJ5O2M1R7aYv+2mpLetxZyTgphP+6MD5And8gWCiRL/GphvBEVR6J
         FKOjG3aqluLZymH1dsL+qAimcx6anIphmZbsMxMziJvLYvBqP6L6hfpJ13nibbeVNK
         w+TbEocv6DN/d63s3z1/L1YgKkaEKmwXsCIkTl2Q=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220308154254epcas5p3d9c44455f00cfa3e2418dfaeb97a2037~acjJ7WQs-1110111101epcas5p3b;
        Tue,  8 Mar 2022 15:42:54 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KCfjQ1xGDz4x9Pq; Tue,  8 Mar
        2022 15:42:50 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0F.AB.05590.A7977226; Wed,  9 Mar 2022 00:42:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220308152716epcas5p3d38d2372c184259f1a10c969f7e4396f~acVfzwP-30623006230epcas5p3k;
        Tue,  8 Mar 2022 15:27:16 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220308152716epsmtrp20d7f75940f1233e666a3e0d035a212a3~acVfyxrEJ2706527065epsmtrp2C;
        Tue,  8 Mar 2022 15:27:16 +0000 (GMT)
X-AuditID: b6c32a4b-723ff700000015d6-5b-6227797ade75
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5A.51.29871.4D577226; Wed,  9 Mar 2022 00:27:16 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152714epsmtip165f9a4da945e9fd75cdc64cd6d1d83a5~acVdwBZ8h3168431684epsmtip1F;
        Tue,  8 Mar 2022 15:27:13 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [PATCH 11/17] block: factor out helper for bio allocation from
 cache
Date:   Tue,  8 Mar 2022 20:50:59 +0530
Message-Id: <20220308152105.309618-12-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308152105.309618-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJsWRmVeSWpSXmKPExsWy7bCmpm5VpXqSQdM9bovphxUtmib8ZbaY
        s2obo8Xqu/1sFitXH2WyeNd6jsWi8/QFJovzbw8zWUw6dI3RYu8tbYv5y56yWyxpPc5mcWPC
        U0aLNTefslh8PjOP1YHf49nVZ4weO2fdZfdoXnCHxePy2VKPTas62Tw2L6n32H2zgc1j2+KX
        rB59W1YxenzeJBfAFZVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
        5OIToOuWmQP0g5JCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwKRArzgxt7g0L10v
        L7XEytDAwMgUqDAhO+PIhNyCk5IV95Z9ZWtgvC3SxcjBISFgIvGwn7GLkYtDSGA3o8SFO4fY
        uxg5gZxPjBKtX5UgEt8YJdp2HWEGSYA0dJ57zARRtJdR4uwOLwj7M6PE/CdRIEPZBDQlLkwu
        BQmLCHhJ3L/9nhVkDrNAF5PE23332UASwgL+Ekv/zAGbwyKgKnGp5SCYzStgJbH98TZGiF3y
        EjMvfQc7iBMo/vPWVlaIGkGJkzOfsIDYzEA1zVtnM4MskBA4wCHxr2sJVLOLxK2ns1ghbGGJ
        V8e3sEPYUhKf3+1lg7CLJX7dOQrV3MEocb1hJgtEwl7i4p6/TCDfMAN9s36XPkRYVmLqqXVM
        EIv5JHp/P2GCiPNK7JgHYytK3Jv0FGqvuMTDGUugbA+JiVsuskBCtJdR4kT3F6YJjAqzkDw0
        C8lDsxBWL2BkXsUomVpQnJueWmxaYJyXWg6P4uT83E2M4ESt5b2D8dGDD3qHGJk4GA8xSnAw
        K4nw3j+vkiTEm5JYWZValB9fVJqTWnyI0RQY4hOZpUST84G5Iq8k3tDE0sDEzMzMxNLYzFBJ
        nPdU+oZEIYH0xJLU7NTUgtQimD4mDk6pBqY5pXOFJA2P+vDHrFGYurLjnprXOwXnrx/02Vre
        ukpUHV8naCa2YfKrH4kKrxikW3VYdc/737zlUyTv2vhO46btl+P/T3ksqRJaP//pX4ETyXnP
        ua/NtlQz13mfFJzcL/hbOMnC48zxG8mn6tev1JrGeLmm/Q2TuiTbqh8mFuIhn38ULHno3WOm
        JvX53TZzObsDFg63K0WPrz99OlzgnVSC5psN00wUT/oue3XslN6Khcvfsq/xuOe+4AXjnfXK
        twvCm5m8J7qGuLKx+r88X7B+1a7Fa7RS/1s+cV5blc9Xpdz759wtrnl5ppNvXRbocTi08h77
        lW45TpOEXacEWM/9tneSO2ofNNOo6KuL3CMlluKMREMt5qLiRAAqDQ66XQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LZdlhJTvdKqXqSwas/3BbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AK4rLJiU1J7MstUjfLoEr48iE3IKTkhX3ln1la2C8LdLFyMkhIWAi0Xnu
        MROILSSwm1Gi9aEDRFxcovnaD3YIW1hi5b/nQDYXUM1HRol3ky6wdDFycLAJaEpcmFwKUiMi
        ECBxsPEyWA2zwAwmiZ7mzywgCWEBX4mFm3vZQGwWAVWJSy0HwZbxClhJbH+8jRFigbzEzEvf
        wZZxAsV/3trKCnGQpcSKdb/ZIOoFJU7OfAI2kxmovnnrbOYJjAKzkKRmIUktYGRaxSiZWlCc
        m55bbFhgmJdarlecmFtcmpeul5yfu4kRHE1amjsYt6/6oHeIkYmD8RCjBAezkgjv/fMqSUK8
        KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwuTxhXH0s+kf8
        /Z3d2655SX3RqnbMikmTTz55f13iy0BdF3ftb8yZnOeXGr2Vn9Thsv3663D+xEU3s1MKfopP
        Pch05+uTpPNcG63zM9OOepWfKZO028BWOE3P49vSNSdFAlUiFtuuM7a1nuCasIhNL5bnb/LB
        u2esFfsue72wjA56krJ7tnz8BJVZUw+/fz3V98VGySCZpBlbj95In3KLM2K61ZRZvYy2D6ft
        adn4PGC9+KY35jV3ztrvSJPcer30aNaUJStFqpLldtas21f/71xuzG699XfehQr8aE5eFqZm
        yBd/i2+pjt2qr5kpul8WML05uPznkhtqSu8qTvevYd3Aycpz1ezUFdX98VZmc5RYijMSDbWY
        i4oTAYJXiPcVAwAA
X-CMS-MailID: 20220308152716epcas5p3d38d2372c184259f1a10c969f7e4396f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152716epcas5p3d38d2372c184259f1a10c969f7e4396f
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152716epcas5p3d38d2372c184259f1a10c969f7e4396f@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Factor the code to pull out bio_from_cache helper which is not tied to
kiocb. This is prep patch.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio.c         | 43 ++++++++++++++++++++++++++-----------------
 include/linux/bio.h |  1 +
 2 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 4312a8085396..5e12c6bd43d3 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1705,27 +1705,12 @@ int bioset_init_from_src(struct bio_set *bs, struct bio_set *src)
 }
 EXPORT_SYMBOL(bioset_init_from_src);
 
-/**
- * bio_alloc_kiocb - Allocate a bio from bio_set based on kiocb
- * @kiocb:	kiocb describing the IO
- * @nr_vecs:	number of iovecs to pre-allocate
- * @bs:		bio_set to allocate from
- *
- * Description:
- *    Like @bio_alloc_bioset, but pass in the kiocb. The kiocb is only
- *    used to check if we should dip into the per-cpu bio_set allocation
- *    cache. The allocation uses GFP_KERNEL internally. On return, the
- *    bio is marked BIO_PERCPU_CACHEABLE, and the final put of the bio
- *    MUST be done from process context, not hard/soft IRQ.
- *
- */
-struct bio *bio_alloc_kiocb(struct kiocb *kiocb, unsigned short nr_vecs,
-			    struct bio_set *bs)
+struct bio *bio_from_cache(unsigned short nr_vecs, struct bio_set *bs)
 {
 	struct bio_alloc_cache *cache;
 	struct bio *bio;
 
-	if (!(kiocb->ki_flags & IOCB_ALLOC_CACHE) || nr_vecs > BIO_INLINE_VECS)
+	if (nr_vecs > BIO_INLINE_VECS)
 		return bio_alloc_bioset(GFP_KERNEL, nr_vecs, bs);
 
 	cache = per_cpu_ptr(bs->cache, get_cpu());
@@ -1744,6 +1729,30 @@ struct bio *bio_alloc_kiocb(struct kiocb *kiocb, unsigned short nr_vecs,
 	bio_set_flag(bio, BIO_PERCPU_CACHE);
 	return bio;
 }
+EXPORT_SYMBOL_GPL(bio_from_cache);
+
+/**
+ * bio_alloc_kiocb - Allocate a bio from bio_set based on kiocb
+ * @kiocb:	kiocb describing the IO
+ * @nr_vecs:	number of iovecs to pre-allocate
+ * @bs:		bio_set to allocate from
+ *
+ * Description:
+ *    Like @bio_alloc_bioset, but pass in the kiocb. The kiocb is only
+ *    used to check if we should dip into the per-cpu bio_set allocation
+ *    cache. The allocation uses GFP_KERNEL internally. On return, the
+ *    bio is marked BIO_PERCPU_CACHEABLE, and the final put of the bio
+ *    MUST be done from process context, not hard/soft IRQ.
+ *
+ */
+struct bio *bio_alloc_kiocb(struct kiocb *kiocb, unsigned short nr_vecs,
+			    struct bio_set *bs)
+{
+	if (!(kiocb->ki_flags & IOCB_ALLOC_CACHE))
+		return bio_alloc_bioset(GFP_KERNEL, nr_vecs, bs);
+
+	return bio_from_cache(nr_vecs, bs);
+}
 EXPORT_SYMBOL_GPL(bio_alloc_kiocb);
 
 static int __init init_bio(void)
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 117d7f248ac9..3216401f75b0 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -409,6 +409,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp, unsigned short nr_iovecs,
 		struct bio_set *bs);
 struct bio *bio_alloc_kiocb(struct kiocb *kiocb, unsigned short nr_vecs,
 		struct bio_set *bs);
+struct bio *bio_from_cache(unsigned short nr_vecs, struct bio_set *bs);
 struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned short nr_iovecs);
 extern void bio_put(struct bio *);
 
-- 
2.25.1

