Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD135ABE67
	for <lists+io-uring@lfdr.de>; Sat,  3 Sep 2022 12:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiICKGo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 3 Sep 2022 06:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiICKGn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 3 Sep 2022 06:06:43 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5525B5AC43
        for <io-uring@vger.kernel.org>; Sat,  3 Sep 2022 03:06:42 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220903100640epoutp01457a8bd62561af007086f216d4896c23~RUbrbjuua2974729747epoutp01b
        for <io-uring@vger.kernel.org>; Sat,  3 Sep 2022 10:06:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220903100640epoutp01457a8bd62561af007086f216d4896c23~RUbrbjuua2974729747epoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662199600;
        bh=zAwmlpFiEk6c+FVJcJtlhijLgKFCtJqWuBMlHXTCg74=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QfVRt3qQ0tprWxo/0AoyyNMOO/IhIjJ9G/mCObJuqAIw7mOEUG6CUkCx4JfgmLGOp
         +mf9XJO8w1Oo1qjpBF/TsFinXJPkAfhG+h597994hjs3IEmfnZWJ3vlaxVFGysq8gD
         1kFyp3N8tKDYBySYGMNjpixhP6nq0/PKhVqFdo70=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220903100639epcas5p260aa22b35007b24a885aa06869f85094~RUbq1f0A21026910269epcas5p2a;
        Sat,  3 Sep 2022 10:06:39 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MKVms2gMQz4x9Px; Sat,  3 Sep
        2022 10:06:37 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2C.4B.54060.C2723136; Sat,  3 Sep 2022 19:06:36 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220903100636epcas5p3894cec41c82dc2411d44e67dabeb5163~RUbnRyvFk0485504855epcas5p3R;
        Sat,  3 Sep 2022 10:06:36 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220903100635epsmtrp2f244b8b04d4d9bb901978aa6470efadd~RUbnRNWnS1948019480epsmtrp2J;
        Sat,  3 Sep 2022 10:06:35 +0000 (GMT)
X-AuditID: b6c32a4b-be1ff7000000d32c-3a-6313272c10da
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6F.6B.14392.B2723136; Sat,  3 Sep 2022 19:06:35 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220903100635epsmtip190467d52391aae0ca344d76de1555f7f~RUbmxIbR00072900729epsmtip1D;
        Sat,  3 Sep 2022 10:06:35 +0000 (GMT)
Date:   Sat, 3 Sep 2022 15:26:52 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 2/3] nvme: use separate end IO handler for IOPOLL
Message-ID: <20220903095652.GB10373@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220902230052.275835-3-axboe@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsWy7bCmpq6OunCyQdduSYvVd/vZLN61nmNx
        YPK4fLbU4/MmuQCmqGybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
        F58AXbfMHKDpSgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL28
        1BIrQwMDI1OgwoTsjB2L77MUzJaquHOZrYHxjmgXIyeHhICJxIUHt1hBbCGB3YwSO3sTuhi5
        gOxPjBI33pxgh3C+MUqs3nWQGaZjxZU1TBCJvYwSCzf/ZYRwnjFKfDh4lB2kikVAReLE3+lA
        czk42AQ0JS5MLgUJiwgoSPT8XskGYjMLyEhMnnMZrFxYwFVi48KJYHFeAV2JUxNusEPYghIn
        Zz5hAbE5Bcwk1k3cDXaEqICyxIFtx8GOkBA4xC5xePZBdojrXCSebVvJCGELS7w6vgUqLiXx
        +d1eNgg7WeLSzHNMEHaJxOM9B6Fse4nWU/3MEMdlSKzp38cEYfNJ9P5+wgTyi4QAr0RHmxBE
        uaLEvUlPWSFscYmHM5ZA2R4Sc+4thQbQVkaJJytfsU5glJuF5J9ZSFZA2FYSnR+aWGcBrWAW
        kJZY/o8DwtSUWL9LfwEj6ypGydSC4tz01GLTAuO81HJ4FCfn525iBCc3Le8djI8efNA7xMjE
        wXiIUYKDWUmEd+phgWQh3pTEyqrUovz4otKc1OJDjKbA6JnILCWanA9Mr3kl8YYmlgYmZmZm
        JpbGZoZK4rxTtBmThQTSE0tSs1NTC1KLYPqYODilGphmLNTrcTSvfbyPLfaOpOnkRxdq+Noe
        rs/1m+rAnPjwevT8uLqJeZcYGZTPaKT+S7Tv5WH/JtpWw3EgXMDOMVhXRL2SqWPNlugQp8W5
        y3bmZ7o3LVl684S/1EOVJadU6gUiD0+OvObdGDrxy5XEr1ZmP68GTmVfZcUvo6rc5rOtQ9Z7
        gavDoYTvOnMeHhGerT33DNskm38x3Tr5X7VEf0x7u/vKN8dXy/bns++fJSI678JbyQ9P2jd9
        X18kFbH4ZU3WwvvJ2aceN6wtF1KwmzDze27jXF5Gr57Gq5XRJ/IDnV8aWNxn/LKQadLBkinX
        tnXNbrrc2TzB/nbLFr73K49N/XHS9LvwbYe9vVLT4zKVWIozEg21mIuKEwG+bThH9wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsWy7bCSnK62unCywZ/lFhar7/azWbxrPcfi
        wORx+Wypx+dNcgFMUVw2Kak5mWWpRfp2CVwZ/6ccZyk4K17x/1AbUwPjCuEuRk4OCQETiRVX
        1jB1MXJxCAnsZpS4tOoxI0RCXKL52g92CFtYYuW/52C2kMATRok984xBbBYBFYkTf6ezdjFy
        cLAJaEpcmFwKEhYRUJDo+b2SDcRmFpCRmDznMlirsICrxMaFE8HivAK6Eqcm3GCH2LuVUeLd
        iYXMEAlBiZMzn7BANJtJzNv8kBlkPrOAtMTyfxwgYU6g8LqJu8HKRQWUJQ5sO840gVFwFpLu
        WUi6ZyF0L2BkXsUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERyuWpo7GLev+qB3iJGJ
        g/EQowQHs5II79TDAslCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2C
        yTJxcEo1MB2JbN1btaSE6wXL0Vv6eybdDHLWCMvT+H1kgmjlJt+P8+Oib1hJlx3NLq645C1V
        cq+SMecMz1/2ZpFFModWHI3YJRkx/ZXW/IleOlu2bXzmIX+hcvXk9Z4e818dUxJ82fxIZKN+
        7H0DncMaJ649j1C1KPw/8+6mDQVmr69+Snzny3z/1tkpflwCqz8XZmvaRxZaWJXZay9ZXaH+
        seic04fm6doTzkm13+BzfvZ10xdVvunefwo8mqLvlgpyN04xSX/+sZdDY+O5F1M//Zzx2GWW
        PPuOnyKpbtN1XF1exLe6/ClRTnq27tdWNv9d2XMnv8rV2PwqaO/xTac/5BUGO7ccXPGX07Sk
        7tH9VylrQ1YqsRRnJBpqMRcVJwIAxyS9cMYCAAA=
X-CMS-MailID: 20220903100636epcas5p3894cec41c82dc2411d44e67dabeb5163
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----zvU9B7RYhoxo0n0NtQiMJbd43ri29uhJZ9UzgKuz80Y8n-YR=_46058_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220902230104epcas5p1b9bd2831a421f145e919bce7275503f0
References: <20220902230052.275835-1-axboe@kernel.dk>
        <CGME20220902230104epcas5p1b9bd2831a421f145e919bce7275503f0@epcas5p1.samsung.com>
        <20220902230052.275835-3-axboe@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------zvU9B7RYhoxo0n0NtQiMJbd43ri29uhJZ9UzgKuz80Y8n-YR=_46058_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Sep 02, 2022 at 05:00:51PM -0600, Jens Axboe wrote:
>Don't need to rely on the cookie or request type, set the right handler
>based on how we're handling the IO.
>
>Signed-off-by: Jens Axboe <axboe@kernel.dk>
>---
> drivers/nvme/host/ioctl.c | 30 ++++++++++++++++++++++--------
> 1 file changed, 22 insertions(+), 8 deletions(-)
>
>diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
>index 7756b439a688..f34abe95821e 100644
>--- a/drivers/nvme/host/ioctl.c
>+++ b/drivers/nvme/host/ioctl.c
>@@ -385,25 +385,36 @@ static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
> 	io_uring_cmd_done(ioucmd, status, result);
> }
>
>-static void nvme_uring_cmd_end_io(struct request *req, blk_status_t err)
>+static void nvme_uring_iopoll_cmd_end_io(struct request *req, blk_status_t err)
> {
> 	struct io_uring_cmd *ioucmd = req->end_io_data;
> 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
> 	/* extract bio before reusing the same field for request */
> 	struct bio *bio = pdu->bio;
>-	void *cookie = READ_ONCE(ioucmd->cookie);
>
> 	pdu->req = req;
> 	req->bio = bio;
>
> 	/*
> 	 * For iopoll, complete it directly.
>-	 * Otherwise, move the completion to task work.
> 	 */
>-	if (cookie != NULL && blk_rq_is_poll(req))
>-		nvme_uring_task_cb(ioucmd);
>-	else
>-		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
>+	nvme_uring_task_cb(ioucmd);
>+}
>+
>+static void nvme_uring_cmd_end_io(struct request *req, blk_status_t err)
>+{
>+	struct io_uring_cmd *ioucmd = req->end_io_data;
>+	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
>+	/* extract bio before reusing the same field for request */
>+	struct bio *bio = pdu->bio;
>+
>+	pdu->req = req;
>+	req->bio = bio;
>+
>+	/*
>+	 * Move the completion to task work.
>+	 */
>+	io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
> }
>
> static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
>@@ -464,7 +475,10 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
> 			blk_flags);
> 	if (IS_ERR(req))
> 		return PTR_ERR(req);
>-	req->end_io = nvme_uring_cmd_end_io;
>+	if (issue_flags & IO_URING_F_IOPOLL)
>+		req->end_io = nvme_uring_iopoll_cmd_end_io;
>+	else
>+		req->end_io = nvme_uring_cmd_end_io;

The polled handler (nvme_uring_iopoll_cmd_end_io) may get called in irq
context (some swapper/kworker etc.) too. And in that case will it be
safe to call nvme_uring_task_cb directly. 
We don't touch the user-fields in cmd (thanks to Big CQE) so that part is
sorted. But there is blk_rq_unmap_user call - can that or anything else
inside io_req_complete_post() cause trouble.

 *    A matching blk_rq_unmap_user() must be issued at the end of I/O, while
 *    still in process context.
 */
int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
                        struct rq_map_data *map_data,
                        const struct iov_iter *iter, gfp_t gfp_mask)

------zvU9B7RYhoxo0n0NtQiMJbd43ri29uhJZ9UzgKuz80Y8n-YR=_46058_
Content-Type: text/plain; charset="utf-8"


------zvU9B7RYhoxo0n0NtQiMJbd43ri29uhJZ9UzgKuz80Y8n-YR=_46058_--
