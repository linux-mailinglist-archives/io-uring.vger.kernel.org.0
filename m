Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602E15E95F1
	for <lists+io-uring@lfdr.de>; Sun, 25 Sep 2022 22:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbiIYUdw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Sep 2022 16:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIYUdp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Sep 2022 16:33:45 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA5C2C675
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 13:33:41 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220925203339epoutp02979cb006453fd2e9c0d9347e319a31fc~YNLZHIzPy2609626096epoutp02Y
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 20:33:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220925203339epoutp02979cb006453fd2e9c0d9347e319a31fc~YNLZHIzPy2609626096epoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664138019;
        bh=1eUFXioQABTGlcCmvgZ3Nvy1qjkLXODANaisMexCU74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uxjDf2+VmwEm1YH0EzoyBvFqKiC4mEiAHB652oSbFx6R4ZFAJCUSk+fRbb2CK3QmB
         4Pff4ujkXcDIxR0oFgr8JjPpqwnwA3HnALBBUxL54hRq4QYgVTX182XrwCs3xDdz6R
         OLPkXOXE816Swg//A9nexuZYodewDUvBRYalriOE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220925203339epcas5p20a93b564c3e0bcf57c9702ff44dcfb96~YNLYkDV3K2718327183epcas5p2R;
        Sun, 25 Sep 2022 20:33:39 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MbHf90mxQz4x9Pq; Sun, 25 Sep
        2022 20:33:37 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1E.54.39477.02BB0336; Mon, 26 Sep 2022 05:33:37 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220925203336epcas5p39e910479f992d7d9e233210e0647a6bf~YNLV_xuIR2847928479epcas5p3S;
        Sun, 25 Sep 2022 20:33:36 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220925203336epsmtrp2b1458761586f35ff92632a3314f7e0d8~YNLV99BIi1586315863epsmtrp2L;
        Sun, 25 Sep 2022 20:33:36 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-95-6330bb20148a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        EB.1A.18644.02BB0336; Mon, 26 Sep 2022 05:33:36 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220925203334epsmtip108ffed27c7bf31c0b92b85dfedc42eb1~YNLTxn6SR2877328773epsmtip1m;
        Sun, 25 Sep 2022 20:33:33 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v9 6/7] block: introduce helper to map bvec
 iterator
Date:   Mon, 26 Sep 2022 01:53:03 +0530
Message-Id: <20220925202304.28097-7-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220925202304.28097-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42LZdlhTS1dxt0GywfZSi6YJf5ktVt/tZ7O4
        eWAnk8XK1UeZLN61nmOxOPr/LZvFpEPXGC323tK2mL/sKbsDp8fls6Uem1Z1snlsXlLvsftm
        A5tH35ZVjB6fN8kFsEVl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qba
        Krn4BOi6ZeYAXaSkUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvX
        y0stsTI0MDAyBSpMyM7o+LueqWCBdMWjVS8ZGxgviXYxcnJICJhI9D2cz9zFyMUhJLCbUWLP
        jz1MEM4nRolPL5awQjifGSWOLnjODNOy6NwnqMQuRokPhycyw1W9n3kCyOHgYBPQlLgwuRSk
        QUTASGL/p5NgDcwgO1b/fcsKUiMs4C9x7FsRSA2LgKrE3/42dhCbV8BC4ueGq1DL5CVmXvoO
        FucUsJR4MncrM0SNoMTJmU9YQGxmoJrmrbPBbpAQ+MsuMfV0MyNEs4vE26dPWSFsYYlXx7ew
        Q9hSEp/f7WWDsJMlLs08xwRhl0g83nMQyraXaD3VD/YLM9Av63fpQ+zik+j9/YQJJCwhwCvR
        0SYEUa0ocW8SzCZxiYczlkDZHhITH3+GhlUPo8SuNV0sExjlZyF5YRaSF2YhbFvAyLyKUTK1
        oDg3PbXYtMAoL7UcHrHJ+bmbGMEJU8trB+PDBx/0DjEycTAeYpTgYFYS4U25qJssxJuSWFmV
        WpQfX1Sak1p8iNEUGMYTmaVEk/OBKTuvJN7QxNLAxMzMzMTS2MxQSZx38QytZCGB9MSS1OzU
        1ILUIpg+Jg5OqQYm+3TP89cOKF6JyDZ9EhO8I36HrUiD8UdnVybL5j8SjYuWCTvqX393M4vF
        LGFN1z+3xK8fW+S81TPfPGVdPLXHPTplWbKrjHvXdJGPPC4+6/6Eh7JcrlGN09wc+PiMSSt7
        LfdNcdsZUtVdBq+OHq1U4Z54snbpxS0MZ/8t279+W9rv2tdr5skVrN7t/+NC0zU9mWbeeVPj
        OA+97f0gnuDYw3sw8cbHHMvMKUZnVjjnprC6Vd/4GZtryMUaxGU1bSXToe3PLZj5Oj+V2QcX
        ZKR3MaxNr+Cq+CnLc3nBypqdrWGVzyUVPV8/X6d7TqbSJqf5Qv1LGTU27h7pj+Kfz7rdZ70p
        lmc4Tclz0/S3O5RYijMSDbWYi4oTAf7kYdAhBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSnK7CboNkg2NThS2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsDpwel8+Wemxa1cnmsXlJvcfu
        mw1sHn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJXR8Xc9U8EC6YpHq14yNjBeEu1i5OSQEDCR
        WHTuE2sXIxeHkMAORomnW64wQyTEJZqv/WCHsIUlVv57zg5R9JFR4uXVRUxdjBwcbAKaEhcm
        l4LUiAiYSSw9vIYFpIZZ4CCjxPmmbywgCWEBX4k5q7cygtgsAqoSf/vbwIbyClhI/NxwFWqZ
        vMTMS9/B4pwClhJP5m5lBpkvBFSz9bwWRLmgxMmZT8BGMgOVN2+dzTyBUWAWktQsJKkFjEyr
        GCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCg11LawfjnlUf9A4xMnEwHmKU4GBWEuFN
        uaibLMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVAOTSmTL
        h/63icYenyVvi7wMzX53e/qfuu87YuM7a1/0dJbn/WK0KDPbsdRd07pPXlIv58jKq7crJgR9
        f/Qn2Vv+TPOHE2/3FnaLqAZEa91buM9C3kFRyeF4lkXc1ImZl7J6/dbMXF8561ZuwZOfu+Sm
        TEl0Tfmcvtr8mdm+pPPCbb4sj6OiDL9snlL06vxOgUyPNO3dy1jn9Cjy/1lRc7FCcOoOn59b
        5jx7Gmyb0jrjcWb4yScmH+tqA5Iyi404du8R2eTyMcmon88oedaFOW+iprZeWr9yZ5jtekWJ
        9dwKaT8Ocs69Ztn9iT9p6dFj9bNf7fgiJ+8c/m7FpsqqozPZrjsvfs0Q80rLUnyKeFGGEktx
        RqKhFnNRcSIAU+MZMeUCAAA=
X-CMS-MailID: 20220925203336epcas5p39e910479f992d7d9e233210e0647a6bf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220925203336epcas5p39e910479f992d7d9e233210e0647a6bf
References: <20220925202304.28097-1-joshi.k@samsung.com>
        <CGME20220925203336epcas5p39e910479f992d7d9e233210e0647a6bf@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add blk_rq_map_user_bvec which maps the pages from bvec iterator into a
bio, and places the bio into the request. This helper will be used by
nvme for uring-passthrough path with pre-mapped buffers.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/blk-map.c        | 80 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/blk-mq.h |  1 +
 2 files changed, 81 insertions(+)

diff --git a/block/blk-map.c b/block/blk-map.c
index a7838879e28e..d6265d49b15b 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -622,6 +622,86 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 }
 EXPORT_SYMBOL(blk_rq_map_user);
 
+/* Prepare bio for passthrough IO given an existing bvec iter */
+int blk_rq_map_user_bvec(struct request *rq, struct iov_iter *iter)
+{
+	struct request_queue *q = rq->q;
+	size_t nr_iter, nr_segs, i;
+	struct bio *bio = NULL;
+	struct bio_vec *bv, *bvecs, *bvprvp = NULL;
+	struct queue_limits *lim = &q->limits;
+	unsigned int nsegs = 0, bytes = 0;
+	bool copy = false;
+	int ret;
+	unsigned long align = q->dma_pad_mask | queue_dma_alignment(q);
+
+	/* see if we need to copy pages due to any weird situation */
+	if (blk_queue_may_bounce(q))
+		copy = true;
+	else if (iov_iter_alignment(iter) & align)
+		copy = true;
+
+	if (copy) {
+		do {
+			ret = bio_copy_user_iov(rq, NULL, iter, GFP_KERNEL);
+			if (ret) {
+				blk_rq_unmap_user(bio);
+				rq->bio = NULL;
+				break;
+			}
+			if (!bio)
+				bio = rq->bio;
+		} while (iov_iter_count(iter));
+
+		return ret;
+	}
+	/* common (non-copy) case handling */
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
+	bio_iov_bvec_set(bio, iter);
+	blk_rq_bio_prep(rq, bio, nr_segs);
+
+	/* loop to perform a bunch of sanity checks */
+	bvecs = (struct bio_vec *)iter->bvec;
+	for (i = 0; i < nr_segs; i++) {
+		bv = &bvecs[i];
+		/*
+		 * If the queue doesn't support SG gaps and adding this
+		 * offset would create a gap, disallow it.
+		 */
+		if (bvprvp && bvec_gap_to_prev(lim, bvprvp, bv->bv_offset))
+			goto put_bio;
+
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
+}
+EXPORT_SYMBOL_GPL(blk_rq_map_user_bvec);
+
 /**
  * blk_rq_unmap_user - unmap a request with user data
  * @bio:	       start of bio list
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 00a15808c137..1a9ae17e49be 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -977,6 +977,7 @@ struct rq_map_data {
 	bool from_user;
 };
 
+int blk_rq_map_user_bvec(struct request *rq, struct iov_iter *iter);
 int blk_rq_map_user(struct request_queue *, struct request *,
 		struct rq_map_data *, void __user *, unsigned long, gfp_t);
 int blk_rq_map_user_iov(struct request_queue *, struct request *,
-- 
2.25.1

