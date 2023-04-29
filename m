Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116976F2400
	for <lists+io-uring@lfdr.de>; Sat, 29 Apr 2023 11:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjD2JnU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Apr 2023 05:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbjD2JnR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Apr 2023 05:43:17 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F341FF2
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 02:43:05 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230429094302epoutp01502e1da19530010ee492a430242c217d~aXo_yNEC92598925989epoutp016
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 09:43:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230429094302epoutp01502e1da19530010ee492a430242c217d~aXo_yNEC92598925989epoutp016
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682761382;
        bh=aMQGYrKQR0F3Yjruge3qlF3MmwpDpKmN737Ouil9Fvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DjLZ1OMkEkxFruTg0IJrFdCGK/TLOTC66cvssvLViJphwGoTYlp4R7Us0TIfmnKm5
         RNe/4hUiH7t5UbYMdrA5yu0PWr/OKkwu/tDWb6fZEV4hhBRlPh+95SKLgUThFBcPl0
         SQmzEUtQYhsQnt6jT5e7zUM/01Q0vskAaDobVD5A=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230429094301epcas5p36aac06352f25c1a7a6cbfd232443861c~aXo_NTa2k2426524265epcas5p3z;
        Sat, 29 Apr 2023 09:43:01 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Q7kzm1Wpxz4x9Pv; Sat, 29 Apr
        2023 09:43:00 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        86.60.55646.4A6EC446; Sat, 29 Apr 2023 18:43:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230429094259epcas5p11f0f3422eb4aa4e3ebf00e0666790efa~aXo8bbf_M2856928569epcas5p10;
        Sat, 29 Apr 2023 09:42:59 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230429094259epsmtrp2d3c103cd3d0c04bd93d29d979136e0a6~aXo8atG-O0329503295epsmtrp2R;
        Sat, 29 Apr 2023 09:42:59 +0000 (GMT)
X-AuditID: b6c32a4b-b71fa7000001d95e-ff-644ce6a45ea4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D6.29.28392.3A6EC446; Sat, 29 Apr 2023 18:42:59 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230429094257epsmtip248e853837ceca4e51363fca0e2ab46f4~aXo6e_z7J0191301913epsmtip2A;
        Sat, 29 Apr 2023 09:42:57 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        anuj1072538@gmail.com, xiaoguang.wang@linux.alibaba.com,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [RFC PATCH 11/12] pci: modify nvme_setup_prp_simple parameters
Date:   Sat, 29 Apr 2023 15:09:24 +0530
Message-Id: <20230429093925.133327-12-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230429093925.133327-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOJsWRmVeSWpSXmKPExsWy7bCmhu6SZz4pBre62Sw+fv3NYtE04S+z
        xeq7/WwWNw/sZLJYufook8W71nMsFpMOXWO02HtL22L+sqfsFutev2ex2PT3JJMDt8fOWXfZ
        Pc7f28jicflsqcemVZ1sHjsfWnpsXlLvsftmA5tH35ZVjB6fN8kFcEZl22SkJqakFimk5iXn
        p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaqkUJaYUwoUCkgsLlbSt7Mp
        yi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM44segAe8FO3opNC74z
        NTB+5epi5OSQEDCRmDnlD3sXIxeHkMBuRonV25awQTifGCUWPpoGlfnMKNHceI8ZpmXZiitQ
        VbsYJbpOTWKFq/p1eipjFyMHB5uApsSFyaUgDSICLhJNa6eCNTALnGeUuNffBDZJWMBd4s/y
        lywgNouAqsS5t3fZQHp5BawkDk+qh1gmLzHz0nd2EJsTKPx9xm6wVl4BQYmTM5+AtTID1TRv
        nc0MMl9CYC6HRMeH/VCXukhM2L+fBcIWlnh1fAs7hC0l8fndXjYIO1ni0sxzTBB2icTjPQeh
        bHuJ1lP9zCD3MAP9sn6XPsQuPone30+YQMISArwSHW1CENWKEvcmPWWFsMUlHs5YAmV7SBzd
        MAsaiL2MEnM23GKewCg/C8kLs5C8MAth2wJG5lWMkqkFxbnpqcWmBcZ5qeXwiE3Oz93ECE6x
        Wt47GB89+KB3iJGJg/EQowQHs5IIL2+le4oQb0piZVVqUX58UWlOavEhRlNgEE9klhJNzgcm
        +bySeEMTSwMTMzMzE0tjM0MlcV5125PJQgLpiSWp2ampBalFMH1MHJxSDUzhqYLSqxnbDmdt
        +shmOEn5Z2OlG2dW4ys+y6QbBs4hCsqZNXcmH929Mk/bY+fJyaf9WcoDJ8xwtWXb1vTryTo3
        tVXssr9XyC7InV0XFc9tmM13OvaP0o3Prv5ruqJXLOq81PN2Stz/v8aPxKuTj3I3urj8fVIx
        y/TQw6h/j+VO2+bd2CJl82j1/wr55fLJ7w1FduXkSkeKt/stkN2ueWXTT0NG+5eGRtmvr30P
        vrmO84+CxJl/cTP/nTDWag/NrFrHwbvO30pYt6Qq7MW8+RvTjd55eCdNlVI6MzfO8kSA+H3/
        1u7C2R/fJ3s0tcTNmlfo/OS41O/J6lHB639m1Xu+L3p5u+VCQkVcOe/BC0osxRmJhlrMRcWJ
        AFbzc6o6BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsWy7bCSvO7iZz4pBlcaxCw+fv3NYtE04S+z
        xeq7/WwWNw/sZLJYufook8W71nMsFpMOXWO02HtL22L+sqfsFutev2ex2PT3JJMDt8fOWXfZ
        Pc7f28jicflsqcemVZ1sHjsfWnpsXlLvsftmA5tH35ZVjB6fN8kFcEZx2aSk5mSWpRbp2yVw
        ZZxYdIC9YCdvxaYF35kaGL9ydTFyckgImEgsW3GFrYuRi0NIYAejxN3ZjcwQCXGJ5ms/2CFs
        YYmV/56zQxR9ZJQ4OH0TUAcHB5uApsSFyaUgNSICXhLtb2eBDWIWuM4ocXPldrBBwgLuEn+W
        v2QBsVkEVCXOvb0L1ssrYCVxeFI9xHx5iZmXvoPt4gQKf5+xmxmkREjAUqJxQTxImFdAUOLk
        zCdgU5iBypu3zmaewCgwC0lqFpLUAkamVYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsY
        wbGhpbWDcc+qD3qHGJk4GA8xSnAwK4nw8la6pwjxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1
        Ml5IID2xJDU7NbUgtQgmy8TBKdXA5Cy53Xnx3wzTWwkRXhN3/zu/Vc5znWKy5wGPOGu/Flfp
        FR9a3vzcdrjFIPXxt0PGtyN7J9gsCJd6yvbz7Iq2V8/mvJHPO7tH195uv0/um70zVR7GP7oS
        YrB9/i2H1v/qvVUJduKrT072fCFvyrlrgl7d4ik56ydaqy8+fG31x8d9XCdtMg97zw0qbjrJ
        ZXX4zOKsj3Xn1NunyjVsVDUOD8kJyl2vtYm1dK0h/y3vtLPSK/65eLDtmePPk3CtNPSZC9fX
        DW4Te4+3pMu4P3K3mZQ6IWZ+S8P67S3vynpO+M/lfh/w9mvsoyfCyysOmG4X2ZA1e7UMd/4R
        S64vKycZ7L3jnRVhGvaCa9HCWeaVjUosxRmJhlrMRcWJADYdJqz8AgAA
X-CMS-MailID: 20230429094259epcas5p11f0f3422eb4aa4e3ebf00e0666790efa
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230429094259epcas5p11f0f3422eb4aa4e3ebf00e0666790efa
References: <20230429093925.133327-1-joshi.k@samsung.com>
        <CGME20230429094259epcas5p11f0f3422eb4aa4e3ebf00e0666790efa@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

Refactor parameters of nvme_setup_prp_simple a bit.
This is a prep patch.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/pci.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index b4498e198e8a..30d7a1a6eaab 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -750,14 +750,13 @@ static blk_status_t nvme_pci_setup_sgls(struct nvme_dev *dev,
 }
 
 static blk_status_t nvme_setup_prp_simple(struct nvme_dev *dev,
-		struct request *req, struct nvme_rw_command *cmnd,
-		struct bio_vec *bv)
+		struct nvme_iod *iod, struct nvme_rw_command *cmnd,
+		struct bio_vec *bv, int dma_dir)
 {
-	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 	unsigned int offset = bv->bv_offset & (NVME_CTRL_PAGE_SIZE - 1);
 	unsigned int first_prp_len = NVME_CTRL_PAGE_SIZE - offset;
 
-	iod->first_dma = dma_map_bvec(dev->dev, bv, rq_dma_dir(req), 0);
+	iod->first_dma = dma_map_bvec(dev->dev, bv, dma_dir, 0);
 	if (dma_mapping_error(dev->dev, iod->first_dma))
 		return BLK_STS_RESOURCE;
 	iod->dma_len = bv->bv_len;
@@ -801,8 +800,10 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 
 		if (!is_pci_p2pdma_page(bv.bv_page)) {
 			if (bv.bv_offset + bv.bv_len <= NVME_CTRL_PAGE_SIZE * 2)
-				return nvme_setup_prp_simple(dev, req,
-							     &cmnd->rw, &bv);
+				return nvme_setup_prp_simple(dev,
+					       blk_mq_rq_to_pdu(req),
+					       &cmnd->rw, &bv,
+					       rq_dma_dir(req));
 
 			if (nvmeq->qid && sgl_threshold &&
 			    nvme_ctrl_sgl_supported(&dev->ctrl))
-- 
2.25.1

