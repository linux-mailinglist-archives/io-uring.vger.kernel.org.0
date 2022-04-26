Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B8A50F189
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 08:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241578AbiDZG5Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 02:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239877AbiDZG5P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 02:57:15 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC8642EFE
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 23:54:05 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220426065402epoutp03299302fb48b16eff880bb9d4ae44db2d~pX8YJArvv2227222272epoutp03L
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 06:54:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220426065402epoutp03299302fb48b16eff880bb9d4ae44db2d~pX8YJArvv2227222272epoutp03L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1650956042;
        bh=7Q1YrUJrgtQdiWAsAzyb807QeU9Z7hSinlx6BCiS/cY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dl78JIxAaKr+PVIUb//jt41KXBN1JnF8rm+VdV21N1meRwV9xbX5dxM7+AoW20vZj
         g1v/Qrur0tpZbgt0zJs6nKEsyaYOLFuB8MvZhNVO/rOOZ/Xy6abQE2FIZvsB6UScRo
         8k6SZ/A7NPGeWFiRjmorMG1cqf9LRpPUuld1lT3M=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220426065402epcas5p161353eae65ef77c5088d655ee86e15fa~pX8X399HS1792617926epcas5p1t;
        Tue, 26 Apr 2022 06:54:02 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4KnXfY6VZnz4x9QB; Tue, 26 Apr
        2022 06:53:57 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        92.7B.09827.CF697626; Tue, 26 Apr 2022 15:53:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220426063335epcas5p4e38854e6c1f2686612952a5215ef7010~pXqhdH8xO1225612256epcas5p4H;
        Tue, 26 Apr 2022 06:33:35 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220426063335epsmtrp1db51443aa87edbeedeeacd50984601ec~pXqhcfT411951519515epsmtrp13;
        Tue, 26 Apr 2022 06:33:35 +0000 (GMT)
X-AuditID: b6c32a4a-b51ff70000002663-f2-626796fcda94
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        61.52.08924.F3297626; Tue, 26 Apr 2022 15:33:35 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220426063334epsmtip27b4a508c4837d42453619807ff3f920e~pXqgbE5dT2331423314epsmtip2q;
        Tue, 26 Apr 2022 06:33:34 +0000 (GMT)
Date:   Tue, 26 Apr 2022 11:58:26 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        kernel-team@fb.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 08/12] io_uring: overflow processing for CQE32
Message-ID: <20220426062826.GC14174@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220425182530.2442911-9-shr@fb.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdlhTQ/fPtPQkg4cbZSxW3+1ns3jXeo7F
        4ljfe1aL+cuesltcfXmA3YHVY2LzO3aPy2dLPTYvqff4vEkugCUq2yYjNTEltUghNS85PyUz
        L91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKuSQlliTilQKCCxuFhJ386mKL+0
        JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITvj9fap7AX7hSv+z37J3MC4
        VqCLkZNDQsBE4sKyiYwgtpDAbkaJ72vquhi5gOxPjBI/jp1kgXA+M0psWXWBFaZj+aIOZojE
        LkaJaRsvskM4zxgldre2MoFUsQioSrzu7wVq5+BgE9CUuDC5FCQsIiAnMWvpfjYQm1mgQOLM
        jolgtrCAq8T7f//BFvAK6EocmHSdGcIWlDg58wkLiM0pYCSx/cwWsFNFBZQlDmw7zgSyV0Lg
        EbvEss+72CGuc5FY/Hw3E4QtLPHq+BaouJTEy/42KDtZonX7ZXaQ2yQESiSWLFCHCNtLXNzz
        lwnitnSJUxMfMELEZSWmnloHFeeT6P39BGo8r8SOeTC2osS9SU+hASQu8XDGEijbQ2Lnj3Zo
        8K5llDg9hWsCo/wsJK/NQrIOwraS6PzQxDoL6DpmAWmJ5f84IExNifW79Bcwsq5ilEwtKM5N
        Ty02LTDKSy2HR3dyfu4mRnCS1PLawfjwwQe9Q4xMHIyHGCU4mJVEeKeqpiUJ8aYkVlalFuXH
        F5XmpBYfYjQFxtREZinR5Hxgms4riTc0sTQwMTMzM7E0NjNUEuc9nb4hUUggPbEkNTs1tSC1
        CKaPiYNTqoGJ4XWcaKVDdkTxLm0Xvz0nOKetLF0ZZPZ56Zz3S/J9DdoX8Zcd39ARcT08r/Ln
        omtabzP4vpoHmed+28e1Qmbfwl2yVwMmJjw301XiFMo3mLRM6PbahH+TnRUVDnyIFGT9PeFe
        w5/yyCktK3fe1fUu3SJX9fHigYaDag3NMjLxgQGBhoonVr7c+Kr91xHFwvDWWW+KHy4918M+
        x7NuntQCp4N9vV/bO4NLuKRnyF7gLu0rfnn89Kt+tstLz89tEUvZrPxQdSe/Et/5+rDdv2Pc
        vjndCNWP31q3ZnM/6wEXt6lLypcIvBO/y7q86/cGtfduZ2dMOPFh7+FepSVLTvq6zztTm3b3
        7qf5Ka/yQ/RllViKMxINtZiLihMBvo3KTRsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWy7bCSvK79pPQkg6b78har7/azWbxrPcdi
        cazvPavF/GVP2S2uvjzA7sDqMbH5HbvH5bOlHpuX1Ht83iQXwBLFZZOSmpNZllqkb5fAlXHu
        +16Wgi8CFRu3zWNrYPzD28XIySEhYCKxfFEHcxcjF4eQwA5GiUuzf7JBJMQlmq/9YIewhSVW
        /nvODlH0hFHiQfNxFpAEi4CqxOv+XiCbg4NNQFPiwuRSkLCIgJzErKX7weYwCxRInNkxEcwW
        FnCVeP/vPyuIzSugK3Fg0nWoxWsZJe4d2sgGkRCUODnzCQtEs5nEvM0PmUHmMwtISyz/xwES
        5hQwkth+ZgsjiC0qoCxxYNtxpgmMgrOQdM9C0j0LoXsBI/MqRsnUguLc9NxiwwKjvNRyveLE
        3OLSvHS95PzcTYzgANfS2sG4Z9UHvUOMTByMhxglOJiVRHinqqYlCfGmJFZWpRblxxeV5qQW
        H2KU5mBREue90HUyXkggPbEkNTs1tSC1CCbLxMEp1cCkEnBCfBfTXsv2iZuYlk/aKX0v6ZR5
        znNX9T6JM7eFLjGqKHK3OcybpNa6/KSDWvDtQi1TtQMSZ8pymOetYxHyTC9bFOLKYPab/fHK
        U0m3GafPu3/1I+ckrZRVuzo3PdL0PdZwzXC18Zvk6wmTPsdc4+aVlUs9M7Vc9be+hfHzn53b
        xaMatQ8eyAnT7lu2rHXi+TPKj5c3Rh8NTZh59+RPTnvHGWkWDcKaK5zEPu1xTBX0rvM9Oa15
        TczMVbE+Lm2e8VZBz3bfttB90vYvZ1b0zX+CvNN6WCRbVst9Lrr1f7Xwmiurdt5JCblScVAt
        ueN98soy+7mKIRreDi+sr9sWZe5R7Jz0XTd5vUZC/20lluKMREMt5qLiRAAdENhu3wIAAA==
X-CMS-MailID: 20220426063335epcas5p4e38854e6c1f2686612952a5215ef7010
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----B60c1XsBAYLlAvSr_Hnug5kZhc5LtmZ3tZiwVK7tFSQflFGl=_e4ae_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220425182611epcas5p2c999ed62c22300b8483c576523198c4e
References: <20220425182530.2442911-1-shr@fb.com>
        <CGME20220425182611epcas5p2c999ed62c22300b8483c576523198c4e@epcas5p2.samsung.com>
        <20220425182530.2442911-9-shr@fb.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------B60c1XsBAYLlAvSr_Hnug5kZhc5LtmZ3tZiwVK7tFSQflFGl=_e4ae_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Mon, Apr 25, 2022 at 11:25:26AM -0700, Stefan Roesch wrote:
>This adds the overflow processing for large CQE's.
>
>This adds two parameters to the io_cqring_event_overflow function and
>uses these fields to initialize the large CQE fields.
>
>Allocate enough space for large CQE's in the overflow structue. If no
>large CQE's are used, the size of the allocation is unchanged.
>
>The cqe field can have a different size depending if its a large
>CQE or not. To be able to allocate different sizes, the two fields
>in the structure are re-ordered.
>
>Co-developed-by: Jens Axboe <axboe@kernel.dk>
>Signed-off-by: Stefan Roesch <shr@fb.com>
>Signed-off-by: Jens Axboe <axboe@kernel.dk>
>---
> fs/io_uring.c | 31 ++++++++++++++++++++++---------
> 1 file changed, 22 insertions(+), 9 deletions(-)
>
>diff --git a/fs/io_uring.c b/fs/io_uring.c
>index 68b61d2b356d..3630671325ea 100644
>--- a/fs/io_uring.c
>+++ b/fs/io_uring.c
>@@ -220,8 +220,8 @@ struct io_mapped_ubuf {
> struct io_ring_ctx;
>
> struct io_overflow_cqe {
>-	struct io_uring_cqe cqe;
> 	struct list_head list;
>+	struct io_uring_cqe cqe;
> };
>
> struct io_fixed_file {
>@@ -2017,10 +2017,14 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
> static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
> {
> 	bool all_flushed, posted;
>+	size_t cqe_size = sizeof(struct io_uring_cqe);
>
> 	if (!force && __io_cqring_events(ctx) == ctx->cq_entries)
> 		return false;
>
>+	if (ctx->flags & IORING_SETUP_CQE32)
>+		cqe_size <<= 1;
>+
> 	posted = false;
> 	spin_lock(&ctx->completion_lock);
> 	while (!list_empty(&ctx->cq_overflow_list)) {
>@@ -2032,7 +2036,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
> 		ocqe = list_first_entry(&ctx->cq_overflow_list,
> 					struct io_overflow_cqe, list);
> 		if (cqe)
>-			memcpy(cqe, &ocqe->cqe, sizeof(*cqe));
>+			memcpy(cqe, &ocqe->cqe, cqe_size);

Maybe a nit, but if we do it this way -
memcpy(cqe, &ocqe->cqe, 
	sizeof(*cqe) << (ctx->flags & IORING_SETUP_CQE32));

we can do away with all previous changes in this function.


------B60c1XsBAYLlAvSr_Hnug5kZhc5LtmZ3tZiwVK7tFSQflFGl=_e4ae_
Content-Type: text/plain; charset="utf-8"


------B60c1XsBAYLlAvSr_Hnug5kZhc5LtmZ3tZiwVK7tFSQflFGl=_e4ae_--
