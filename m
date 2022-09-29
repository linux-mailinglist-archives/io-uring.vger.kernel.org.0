Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B895EF549
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 14:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbiI2MX3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 08:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbiI2MXP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 08:23:15 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832D5149786
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 05:23:13 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220929122312epoutp0142a21050b105462134b067ce9dd41d80~ZVETbi-w90298002980epoutp01P
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 12:23:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220929122312epoutp0142a21050b105462134b067ce9dd41d80~ZVETbi-w90298002980epoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664454192;
        bh=jJ27zbCLEceaklctu22+6qXhghsfenDH5+qFluqe48M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcRsGUKlt8XdiDeibBEtqxznANL6buO635EIJBSt9Y3v2xIgTKabDFYlp+NduBk91
         bxMgarJAO5AkxFACzagdXH53PJR8E94ahFIrPCuV8afmh8s1EpwAqWmCsJeio2QQgE
         3U0vc+abIR6e5LAb4PH1Uf/xHPErJ0S8sthDnqLg=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220929122311epcas5p308d2641ec13b884de5460d42442fa9aa~ZVES-F8vR2720827208epcas5p3D;
        Thu, 29 Sep 2022 12:23:11 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MdXZN58T7z4x9Pw; Thu, 29 Sep
        2022 12:23:08 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5E.78.39477.C2E85336; Thu, 29 Sep 2022 21:23:08 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220929121657epcas5p213b7a187fd77b0783adb4b9389579b44~ZU_21iE6w2731427314epcas5p2Q;
        Thu, 29 Sep 2022 12:16:57 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220929121657epsmtrp2cdc61ec37973b43a2f5c47929c60e46d~ZU_20zlB81794617946epsmtrp2b;
        Thu, 29 Sep 2022 12:16:57 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-34-63358e2c03df
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        46.43.14392.9BC85336; Thu, 29 Sep 2022 21:16:57 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220929121656epsmtip18e8b2a9c803d0c673f2d5d6e3dbbb534~ZU_1aCYLx3141831418epsmtip1n;
        Thu, 29 Sep 2022 12:16:56 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v11 08/13] block: extend functionality to map bvec
 iterator
Date:   Thu, 29 Sep 2022 17:36:27 +0530
Message-Id: <20220929120632.64749-9-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929120632.64749-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEJsWRmVeSWpSXmKPExsWy7bCmpq5On2mywYJr6hZNE/4yW6y+289m
        cfPATiaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2i+7rO9gcuDwuny312LSqk81j
        85J6j903G9g8+rasYvT4vEkugC0q2yYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJc
        SSEvMTfVVsnFJ0DXLTMH6C4lhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5x
        Ym5xaV66Xl5qiZWhgYGRKVBhQnbGgzmbGQuO81T0LH/N2sD4i7OLkZNDQsBEonX7cdYuRi4O
        IYHdjBKfD7xmgnA+MUpMeraQEcL5xihx7uQvVpiWdWf+s0Mk9jJKfFv7EqrlM6PEopV7WECq
        2ATUJY48b2UEsUUEjCT2fzoJtoRZ4CajRPOxfUwgCWGBMIn3e+6CFbEIqEqc/nodyObg4BWw
        lHiyOR1im7zEzEvf2UFsTgEricXX5oBdwSsgKHFy5hOwXcxANc1bZzODzJcQaOWQONRzjgWi
        2UXizfQORghbWOLV8S3sELaUxOd3e9kg7HSJH5efMkHYBSC3QdXbS7Se6mcGuYdZQFNi/S59
        iLCsxNRT65gg9vJJ9P5+AtXKK7FjHoytJNG+cg6ULSGx91wDlO0hsat9BzRIexklts95wDqB
        UWEWkn9mIflnFsLqBYzMqxglUwuKc9NTi00LjPJSy+HRnJyfu4kRnFi1vHYwPnzwQe8QIxMH
        4yFGCQ5mJRFe8QLTZCHelMTKqtSi/Pii0pzU4kOMpsDwnsgsJZqcD0zteSXxhiaWBiZmZmYm
        lsZmhkrivItnaCULCaQnlqRmp6YWpBbB9DFxcEo1MM1uSnGWX2FdHit46MX0B5s2Hxfhckz0
        +NVy+fq0Ps0bxlvW3GC5OVty2Xs9o4V/d51dFhqZ2/2bqeWo5+1Jc8UN1D+X8LUd53A+tezY
        zn/Pv7axxJ+0zv52WMd0j8aJg7ryJ3nnBDqe7BIwnrzfyiiMX+X7/L+Ns2dsU9u4Lffo601e
        ht7z+k66L/4788wu1b3/kvJMOOfM3vav+rP3Sqb8uxzivXeZ/9i+d2fzdOkyiDl8z3PHzCPG
        y3aqairfdP74RXPVoa1XPjAm1Nw97/A6PVC3+1+XPfe/uNzpXEx9Bt7OlcvKPHsDnjq+zrNN
        fpF6ICptO+PdKS9mTlk9qW+Noamwv7uVR9rjSX5WdzWUWIozEg21mIuKEwF45/C6NQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSnO7OHtNkg69r1S2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8aDOZsZC47zVPQsf83awPiLs4uR
        k0NCwERi3Zn/7F2MXBxCArsZJd69OcQGkZCQOPVyGSOELSyx8t9zqKKPjBKnbh8BK2ITUJc4
        8rwVrEhEwExi6eE1LCBFzAL3GSXeNu9mAUkIC4RI7Li/H8xmEVCVOP31OlADBwevgKXEk83p
        EAvkJWZe+s4OYnMKWEksvjaHFaRECKhk+00FkDCvgKDEyZlPwKYwA5U3b53NPIFRYBaS1Cwk
        qQWMTKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYLDXktzB+P2VR/0DjEycTAeYpTg
        YFYS4RUvME0W4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoRTJaJg1Oq
        gcmukzFpI9N8NbUFzbp8kmy3Td8xdD/VzXn5Vq1/i27EKp0cp/8WvF7ndHo7Hz2Y9dmcKyfz
        avr7ujXMhlV+z7S3cc1d2V4ldOGSf+GFh+L8zsLyPrEnP1R3nf8XdU9o9d1m212vSnIDf9Qs
        4ym7NrVZhU887/ALo57zVb5tkZlLOA5Ou/e7W7dILeRMsmT+LON305oWLTcw/vri4udn23fl
        H5jZlHFH8vnklE9fpvQd+PcjL1OssnDfgvVMyaYr3SZpHz8oZMRz9bFKsb24lctEvSfWceoa
        2q/nuVzie6Kmxplwf/Ill3NZD3ySP1x5Y7FQNeLsz12Td8eaPFT6oDZzp7RnTKXqkgvHNpr2
        KSqxFGckGmoxFxUnAgAmrHG16gIAAA==
X-CMS-MailID: 20220929121657epcas5p213b7a187fd77b0783adb4b9389579b44
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220929121657epcas5p213b7a187fd77b0783adb4b9389579b44
References: <20220929120632.64749-1-anuj20.g@samsung.com>
        <CGME20220929121657epcas5p213b7a187fd77b0783adb4b9389579b44@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Kanchan Joshi <joshi.k@samsung.com>

Extend blk_rq_map_user_iov so that it can handle bvec iterator, using
the new blk_rq_map_user_bvec function.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-map.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 023b63ad06d8..ffab5d2d8d6d 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -623,24 +623,35 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 			struct rq_map_data *map_data,
 			const struct iov_iter *iter, gfp_t gfp_mask)
 {
-	bool copy = false;
+	bool copy = false, map_bvec = false;
 	unsigned long align = q->dma_pad_mask | queue_dma_alignment(q);
 	struct bio *bio = NULL;
 	struct iov_iter i;
 	int ret = -EINVAL;
 
-	if (!iter_is_iovec(iter))
-		goto fail;
-
 	if (map_data)
 		copy = true;
 	else if (blk_queue_may_bounce(q))
 		copy = true;
 	else if (iov_iter_alignment(iter) & align)
 		copy = true;
+	else if (iov_iter_is_bvec(iter))
+		map_bvec = true;
+	else if (!iter_is_iovec(iter))
+		copy = true;
 	else if (queue_virt_boundary(q))
 		copy = queue_virt_boundary(q) & iov_iter_gap_alignment(iter);
 
+	if (map_bvec) {
+		ret = blk_rq_map_user_bvec(rq, iter);
+		if (!ret)
+			return 0;
+		if (ret != -EREMOTEIO)
+			goto fail;
+		/* fall back to copying the data on limits mismatches */
+		copy = true;
+	}
+
 	i = *iter;
 	do {
 		if (copy)
-- 
2.25.1

