Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD145ECB98
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 19:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbiI0Rte (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Sep 2022 13:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbiI0RtE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Sep 2022 13:49:04 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA306BD5A
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 10:46:45 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220927174644epoutp02040eafbf239579c289b2001ea49787ff~YyMN-7fER0070100701epoutp02U
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 17:46:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220927174644epoutp02040eafbf239579c289b2001ea49787ff~YyMN-7fER0070100701epoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664300804;
        bh=GlOSiXoErVKZqBReawxn7jrswKJDL5aTOisQmoB9Zsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUoeq70lUAfQClJ74i56O1hYi/YqX19GV2hZAyJSCaz/Wpr8cpD65+k0ur76JNTn9
         BXuJ7jUR4a5VgknxZs4RTBQ65F6BOmZ8C6SFAeEqd1YS8jFj7FBMPRRsF5lI7oyVTQ
         DYmFk4a7jq/Eax6Af4Ja3O/0dfrutjfoVblw0xiU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220927174643epcas5p2e49f728e79181f948d62db1233f9c78f~YyMNcPxi92853728537epcas5p2d;
        Tue, 27 Sep 2022 17:46:43 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4McRrb6wBjz4x9Pp; Tue, 27 Sep
        2022 17:46:39 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8D.79.56352.FF633336; Wed, 28 Sep 2022 02:46:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220927174639epcas5p22b46aed144d81d82b2a9b9de586808ac~YyMJhpRII2853728537epcas5p2N;
        Tue, 27 Sep 2022 17:46:39 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220927174639epsmtrp2fb2ae91112128e3ca140dd60128be690~YyMJgvtbv3251332513epsmtrp2k;
        Tue, 27 Sep 2022 17:46:39 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-d2-633336ff1547
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EA.1D.14392.FF633336; Wed, 28 Sep 2022 02:46:39 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220927174637epsmtip1e540b5c04c91280656b47e9fdfa2265c~YyMIEMg860699206992epsmtip1V;
        Tue, 27 Sep 2022 17:46:37 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v10 6/7] block: extend functionality to map bvec
 iterator
Date:   Tue, 27 Sep 2022 23:06:09 +0530
Message-Id: <20220927173610.7794-7-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220927173610.7794-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplk+LIzCtJLcpLzFFi42LZdlhTU/e/mXGyQd9kY4umCX+ZLVbf7Wez
        uHlgJ5PFytVHmSzetZ5jsTj6/y2bxaRD1xgt9t7Stpi/7Cm7A6fH5bOlHptWdbJ5bF5S77H7
        ZgObR9+WVYwenzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam
        2iq5+AToumXmAJ2kpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L
        18tLLbEyNDAwMgUqTMjOmLzwFFtBm3TF64btbA2MW0S7GDk5JARMJD7tOcvaxcjFISSwm1Gi
        /9cnFgjnE6PExwmvGSGcb4wS/9+sZIJp+T57LTOILSSwl1Giry0Gougzo0Tnhb1Aszg42AQ0
        JS5MLgWpEREwktj/6STYCmaQFav/vmUFSQgLhEi0tT4Bs1kEVCXW7mpmAbF5Bcwlen6/ZIZY
        Ji8x89J3dpCZnAIWEoc/ZkKUCEqcnPkErJwZqKR562xmkPkSAn/ZJe6cn8sG0esi8bLnJ9Qc
        YYlXx7ewQ9hSEp/f7YWqSZa4NPMc1GMlEo/3HISy7SVaT/Uzg+xlBvpl/S59iF18Er2/nzCB
        hCUEeCU62oQgqhUl7k16ygphi0s8nLEEyvaQuL/zLzskqLoZJX4sTZ3AKD8LyQezkHwwC2HZ
        AkbmVYySqQXFuempxaYFxnmp5fBoTc7P3cQITpda3jsYHz34oHeIkYmD8RCjBAezkgjv76OG
        yUK8KYmVValF+fFFpTmpxYcYTYEhPJFZSjQ5H5iw80riDU0sDUzMzMxMLI3NDJXEeRfP0EoW
        EkhPLEnNTk0tSC2C6WPi4JRqYOqT8X6qwjXzOuNkVZvtt/JffTd48/n5IU23wLQ7Dofs92yy
        8L27uffKida3Z8TZLgvvfCHoflXgYpnahXdv3u9Yf2TSOm1G7cxi/2s3+b9fmyD8k9VYaYrU
        Pu9lXardk76cWXzp88lArexTMmpc57duZezdJTlpwokp/66m9NaFrfglMtl+5vQc/ud9kgdX
        VR6Qf98aI/nQLGf3jvLfd4wW/vdW2HhzP9fbpmPPw06rN4ieeyS2vTz8wQxPsaLl3c9VVuzd
        aZ8r9/xxpk8691mLRXrpa6J+O+wWEk7hfZnkcmZispqWAPef1S2LP6ZypUf8klkn/fHgy++6
        /k9F1kw1P1LGP1vu36dqAYt38p+2KbEUZyQaajEXFScCAC+8z0cgBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSnO5/M+Nkg8knxCyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsDpwel8+Wemxa1cnmsXlJvcfu
        mw1sHn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJUxeeEptoI26YrXDdvZGhi3iHYxcnJICJhI
        fJ+9lrmLkYtDSGA3o8T3I1tZIRLiEs3XfrBD2MISK/89Z4co+sgosX7xPKAODg42AU2JC5NL
        QWpEBMwklh5ewwJSwyxwkFHifNM3FpCEsECQxKSHL9lAbBYBVYm1u5rB4rwC5hI9v18yQyyQ
        l5h56Ts7yExOAQuJwx8zQcJCQCVbN32AKheUODnzCZjNDFTevHU28wRGgVlIUrOQpBYwMq1i
        lEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAgOdi3NHYzbV33QO8TIxMF4iFGCg1lJhPf3
        UcNkId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZODilGpi0D1hN
        uMnr8jFo8kGeDP9M1tPmfbyvfuUynMnObj4/6+AJzc13L2uf9U4xvrP7HMvEYCfXFWoLdlt6
        X9acZTpXTqHgxJ35cRH/GoL9DrJ9bN7/IJiHX102Zc9p356/DZnl9qf1fl188cE1usm6WFLP
        J095/xqjwP4dv47+UTcQ/9Dqrnv2vt4bIb06pdA/TZyCuSreHqvZt2+ff+SvwkX716/cLhn6
        TVv31Xvh45zZKlOOn3V3zdxVyFIVckbcYO2xPZ8OTpac8bXqsL12bPSDXbN9iq3+XOZd4+Tk
        +CY07cdD/3aJnsZdq2bYy/1y5Hfcsn6aGb9RW4Jz3iGJDdqbN6fa6G8MKzq+Qy374GMlluKM
        REMt5qLiRADu0mLf5QIAAA==
X-CMS-MailID: 20220927174639epcas5p22b46aed144d81d82b2a9b9de586808ac
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220927174639epcas5p22b46aed144d81d82b2a9b9de586808ac
References: <20220927173610.7794-1-joshi.k@samsung.com>
        <CGME20220927174639epcas5p22b46aed144d81d82b2a9b9de586808ac@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Extend blk_rq_map_user_iov so that it can handle bvec iterator.
It  maps the pages from bvec iterator into a bio and place the bio into
request.

This helper will be used by nvme for uring-passthrough path when IO is
done using pre-mapped buffers.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/blk-map.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/block/blk-map.c b/block/blk-map.c
index a7838879e28e..a1aa8dacb02b 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -548,6 +548,74 @@ int blk_rq_append_bio(struct request *rq, struct bio *bio)
 }
 EXPORT_SYMBOL(blk_rq_append_bio);
 
+/* Prepare bio for passthrough IO given ITER_BVEC iter */
+static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter,
+				bool *copy)
+{
+	struct request_queue *q = rq->q;
+	size_t nr_iter, nr_segs, i;
+	struct bio *bio = NULL;
+	struct bio_vec *bv, *bvecs, *bvprvp = NULL;
+	struct queue_limits *lim = &q->limits;
+	unsigned int nsegs = 0, bytes = 0;
+	unsigned long align = q->dma_pad_mask | queue_dma_alignment(q);
+
+	/* see if we need to copy pages due to any weird situation */
+	if (blk_queue_may_bounce(q))
+		goto out_copy;
+	else if (iov_iter_alignment(iter) & align)
+		goto out_copy;
+	/* virt-alignment gap is checked anyway down, so avoid extra loop here */
+
+	nr_iter = iov_iter_count(iter);
+	nr_segs = iter->nr_segs;
+
+	if (!nr_iter || (nr_iter >> SECTOR_SHIFT) > queue_max_hw_sectors(q))
+		return -EINVAL;
+	if (nr_segs > queue_max_segments(q))
+		return -EINVAL;
+
+	/* no iovecs to alloc, as we already have a BVEC iterator */
+	bio = bio_map_get(rq, 0, GFP_KERNEL);
+	if (bio == NULL)
+		return -ENOMEM;
+
+	bio_iov_bvec_set(bio, (struct iov_iter *)iter);
+	blk_rq_bio_prep(rq, bio, nr_segs);
+
+	/* loop to perform a bunch of sanity checks */
+	bvecs = (struct bio_vec *)iter->bvec;
+	for (i = 0; i < nr_segs; i++) {
+		bv = &bvecs[i];
+		/*
+		 * If the queue doesn't support SG gaps and adding this
+		 * offset would create a gap, fallback to copy.
+		 */
+		if (bvprvp && bvec_gap_to_prev(lim, bvprvp, bv->bv_offset)) {
+			bio_map_put(bio);
+			goto out_copy;
+		}
+		/* check full condition */
+		if (nsegs >= nr_segs || bytes > UINT_MAX - bv->bv_len)
+			goto put_bio;
+		if (bytes + bv->bv_len > nr_iter)
+			goto put_bio;
+		if (bv->bv_offset + bv->bv_len > PAGE_SIZE)
+			goto put_bio;
+
+		nsegs++;
+		bytes += bv->bv_len;
+		bvprvp = bv;
+	}
+	return 0;
+put_bio:
+	bio_map_put(bio);
+	return -EINVAL;
+out_copy:
+	*copy = true;
+	return 0;
+}
+
 /**
  * blk_rq_map_user_iov - map user data to a request, for passthrough requests
  * @q:		request queue where request should be inserted
@@ -573,6 +641,14 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	struct iov_iter i;
 	int ret = -EINVAL;
 
+	if (iov_iter_is_bvec(iter)) {
+		ret = blk_rq_map_user_bvec(rq, iter, &copy);
+		if (ret != 0)
+			goto fail;
+		if (copy)
+			goto do_copy;
+		return ret;
+	}
 	if (!iter_is_iovec(iter))
 		goto fail;
 
@@ -585,6 +661,7 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	else if (queue_virt_boundary(q))
 		copy = queue_virt_boundary(q) & iov_iter_gap_alignment(iter);
 
+do_copy:
 	i = *iter;
 	do {
 		if (copy)
-- 
2.25.1

