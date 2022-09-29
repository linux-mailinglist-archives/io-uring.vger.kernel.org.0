Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96605EF543
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 14:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbiI2MXH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 08:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiI2MXC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 08:23:02 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9222A2F64D
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 05:23:01 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220929122300epoutp04b37ca93ccd0ef7b640a50fd3759bbd5a~ZVEIQpN9L0840708407epoutp04J
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 12:23:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220929122300epoutp04b37ca93ccd0ef7b640a50fd3759bbd5a~ZVEIQpN9L0840708407epoutp04J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664454180;
        bh=ab9DY8Ucw3isFXw+5koECtKHmSq1jktgfR1i7oX2zNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIxsGOzk43hZ4FR6MdIQdNsfAV/c9pdYuYG7Zs2BsE3kg/gf1HE5TX3A3m7Xn2ncM
         RvkUCarzJZn2aiKxu5R3u+3Il3pd1k4jX8o2Ajb6EFluPaTAg7kF/pUabBzLSxz+MK
         Bualfrd+1Kb3TqmLMe/kjX2YDRFE3RXZisjkCe5M=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220929122259epcas5p2319827770a29f624a0c4b149ff9c3913~ZVEH8d-Z82677026770epcas5p2I;
        Thu, 29 Sep 2022 12:22:59 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MdXZ91kJMz4x9Px; Thu, 29 Sep
        2022 12:22:57 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2D.68.39477.12E85336; Thu, 29 Sep 2022 21:22:57 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220929121653epcas5p4ee82ef35b46d6686820dc4d870b6588e~ZU_zPDYV93131131311epcas5p4x;
        Thu, 29 Sep 2022 12:16:53 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220929121653epsmtrp146a3953021124a5b36115e448a9ac939~ZU_zN3BoZ1820918209epsmtrp1U;
        Thu, 29 Sep 2022 12:16:53 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-0e-63358e2188fd
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        03.3C.18644.5BC85336; Thu, 29 Sep 2022 21:16:53 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220929121652epsmtip1b55397e978a4316537867fb857c255af~ZU_xupW4Q2919929199epsmtip1C;
        Thu, 29 Sep 2022 12:16:52 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v11 07/13] block: add blk_rq_map_user_bvec
Date:   Thu, 29 Sep 2022 17:36:26 +0530
Message-Id: <20220929120632.64749-8-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929120632.64749-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHJsWRmVeSWpSXmKPExsWy7bCmpq5in2mywZdnHBZNE/4yW6y+289m
        cfPATiaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2i+7rO9gcuDwuny312LSqk81j
        85J6j903G9g8+rasYvT4vEkugC0q2yYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJc
        SSEvMTfVVsnFJ0DXLTMH6C4lhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5x
        Ym5xaV66Xl5qiZWhgYGRKVBhQnZG/6WDrAVNIhUHvvg0MDYLdDFyckgImEg8PXqOrYuRi0NI
        YDejxObFC1ghnE+MEtvfHIfKfGaUWLPyBDNMS/ukSSwQiV2MEg8nLWcCSUBUfVMHsdkE1CWO
        PG9lBLFFBIwk9n86CTaWWeAmo0TzsX1gDcICzhJdf9aygdgsAqoS0zfNYu9i5ODgFbCU+DAn
        BWKZvMTMS9/ZQWxOASuJxdfmsILYvAKCEidnPmEBsZmBapq3zmYGmS8h0Mghsfb/cRaIZheJ
        +Y8fs0HYwhKvjm9hh7ClJF72t0HZ6RI/Lj9lgrALQG5jhLDtJVpP9TOD3MMsoCmxfpc+RFhW
        YuqpdUwQe/kken8/gWrlldgxD8ZWkmhfOQfKlpDYe66BCWSMhICHxMZ3+ZCg6mWUeHBUcQKj
        wiwk38xC8s0shMULGJlXMUqmFhTnpqcWmxYY5aWWw6M4OT93EyM4oWp57WB8+OCD3iFGJg7G
        Q4wSHMxKIrziBabJQrwpiZVVqUX58UWlOanFhxhNgaE9kVlKNDkfmNLzSuINTSwNTMzMzEws
        jc0MlcR5F8/QShYSSE8sSc1OTS1ILYLpY+LglGpgyv7b93LjZ86smuvhAn9kpau+CF88uv21
        Gz/n3ZRtW/InN8l2X2H3+5L8jPlMnsstgcar7s2dXfOurLGL+ScSoL7tjsabF3ND/8zO3LrU
        6XfU060fZWZr+vhruDfkaxSbTLaOdLYscmE1FGtq5br8QWzxzj2Pz+XFKt0NyrNmV0taeYsx
        8uNlIc4+Rd/MzY+s9nzSs/VP/FjXbCQmnBkYU1ezy/z0scsL9JkDw26eEj2c1VDpdd+ppfqc
        AItTCndtwumtW4WfzOHUvHL8QvzxysmGk/5376nlqZxekSWtfvn6jFPnC56x3GOcbdpy1/Xe
        hyD5icZzLk3mD4tNrnwsFp79XbLw07TEaRe9LxcqsRRnJBpqMRcVJwIATLtwxjEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWy7bCSnO7WHtNkg9XvNC2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV0b/pYOsBU0iFQe++DQwNgt0MXJy
        SAiYSLRPmsQCYgsJ7GCUODvdEiIuIXHq5TJGCFtYYuW/5+wQNR8ZJT5u8AGx2QTUJY48bwWr
        EREwk1h6eA3QHC4OZoH7jBJvm3eDDRUWcJbo+rOWDcRmEVCVmL5pFtAgDg5eAUuJD3NSIObL
        S8y89B1sPqeAlcTia3NYQUqEgEq231QACfMKCEqcnPkEbCIzUHnz1tnMExgFZiFJzUKSWsDI
        tIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzjgtbR2MO5Z9UHvECMTB+MhRgkOZiUR
        XvEC02Qh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamDpv
        v17m0fjETqk0Wvl5I//txQqmNudU/rQr6OVX9ciVPMv5/+bX5hULQs4GnU277HjLhK0jYEqr
        yXuTb7Vq1vvdLudNOTB7YvkDGd6bK92v7ypqyl9ku7T/0JOS6zqd7wLuz5JYIF7g8/jm9b3J
        a1l6nR9eE+YKuFvH+fVMgse02q1fuZgPPry0d6fbqo8ph4Ua9oZfOibe9YdzjTpfeuXhi7Z7
        mxbZF+dyvTls5eW7/I9iRMOhHXd/2AoVH3/b3TznanxrzJc/Uunr377MNH3iKr7DPv1hybGJ
        CZLlEisFI/JPrfrt0N1QGma1IWPiLMkPOouT3MQbHQ5sf/WwS93p/p6JdyJ7xHr+z1UrDlVi
        Kc5INNRiLipOBAAtRurN5wIAAA==
X-CMS-MailID: 20220929121653epcas5p4ee82ef35b46d6686820dc4d870b6588e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220929121653epcas5p4ee82ef35b46d6686820dc4d870b6588e
References: <20220929120632.64749-1-anuj20.g@samsung.com>
        <CGME20220929121653epcas5p4ee82ef35b46d6686820dc4d870b6588e@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Kanchan Joshi <joshi.k@samsung.com>

This is a prep patch. This function maps the pages from bvec iterator into
a bio and place the bio into request.

This helper will be used by nvme for uring-passthrough path when IO is
done using pre-mapped buffers.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-map.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/block/blk-map.c b/block/blk-map.c
index 9e37a03b8a21..023b63ad06d8 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -548,6 +548,62 @@ int blk_rq_append_bio(struct request *rq, struct bio *bio)
 }
 EXPORT_SYMBOL(blk_rq_append_bio);
 
+/* Prepare bio for passthrough IO given ITER_BVEC iter */
+static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter)
+{
+	struct request_queue *q = rq->q;
+	size_t nr_iter = iov_iter_count(iter);
+	size_t nr_segs = iter->nr_segs;
+	struct bio_vec *bvecs, *bvprvp = NULL;
+	struct queue_limits *lim = &q->limits;
+	unsigned int nsegs = 0, bytes = 0;
+	struct bio *bio;
+	size_t i;
+
+	if (!nr_iter || (nr_iter >> SECTOR_SHIFT) > queue_max_hw_sectors(q))
+		return -EINVAL;
+	if (nr_segs > queue_max_segments(q))
+		return -EINVAL;
+
+	/* no iovecs to alloc, as we already have a BVEC iterator */
+	bio = blk_rq_map_bio_alloc(rq, 0, GFP_KERNEL);
+	if (bio == NULL)
+		return -ENOMEM;
+
+	bio_iov_bvec_set(bio, (struct iov_iter *)iter);
+	blk_rq_bio_prep(rq, bio, nr_segs);
+
+	/* loop to perform a bunch of sanity checks */
+	bvecs = (struct bio_vec *)iter->bvec;
+	for (i = 0; i < nr_segs; i++) {
+		struct bio_vec *bv = &bvecs[i];
+
+		/*
+		 * If the queue doesn't support SG gaps and adding this
+		 * offset would create a gap, fallback to copy.
+		 */
+		if (bvprvp && bvec_gap_to_prev(lim, bvprvp, bv->bv_offset)) {
+			blk_mq_map_bio_put(bio);
+			return -EREMOTEIO;
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
+	blk_mq_map_bio_put(bio);
+	return -EINVAL;
+}
+
 /**
  * blk_rq_map_user_iov - map user data to a request, for passthrough requests
  * @q:		request queue where request should be inserted
-- 
2.25.1

